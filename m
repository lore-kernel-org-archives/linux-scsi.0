From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Sat, 13 Aug 2005 20:37:06 -0500
Message-ID: <1123983426.5115.32.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
	 <20050813213955.GB19235@kroah.com>  <1123976180.5115.23.camel@mulgrave>
	 <1123980143.5115.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20413 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932294AbVHNBhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 21:37:18 -0400
In-Reply-To: <1123980143.5115.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Smart@Emulex.Com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-08-13 at 19:42 -0500, James Bottomley wrote:
> I'll look into it.

OK, I think this fix will work for either patch.  The problem is that if
the class hasn't been made visible, then the dentry has no inode, so in
that case we can just exit out of sysfs_hash_and_remove().

Someone needs to check this though ... I've ventured further into sysfs
than a sane person ought to go.  In fact if I don't leave now, Mr.
Flibble's going to be very cross ...

James

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -228,6 +228,10 @@ void sysfs_hash_and_remove(struct dentry
 	struct sysfs_dirent * sd;
 	struct sysfs_dirent * parent_sd = dir->d_fsdata;
 
+	if (dir->d_inode == NULL)
+		/* no inode means this hasn't been made visible yet */
+		return;
+
 	down(&dir->d_inode->i_sem);
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element)


