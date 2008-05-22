From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] aacraid: BKL push down
Date: Thu, 22 May 2008 23:18:27 +0100
Message-ID: <20080522231827.32e68a08@core>
References: <20080522223957.6c079b33@core>
	<Pine.LNX.4.64.0805221454560.3694@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760357AbYEVWa4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 18:30:56 -0400
In-Reply-To: <Pine.LNX.4.64.0805221454560.3694@shark.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 22 May 2008 14:55:20 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 22 May 2008, Alan Cox wrote:
> 
> > The aacraid definitely needs the BKL internally right now so push the
> > lock take down into the driver but go no further
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Wrong patch file ??

Correct one below

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1f7c836..f0aaee7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -692,12 +692,16 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
  *	Bugs: Needs to handle hot plugging
  */
 
-static int aac_cfg_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long aac_cfg_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
+	long ret;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	lock_kernel();
+	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	unlock_kernel();
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1016,7 +1020,7 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 
 static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= aac_cfg_ioctl,
+	.unlocked_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = aac_compat_cfg_ioctl,
 #endif
