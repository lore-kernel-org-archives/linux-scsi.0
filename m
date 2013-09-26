From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: fix memory leaks
Date: Thu, 26 Sep 2013 13:54:10 -0400
Message-ID: <524474C2.6010600@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020604070601030803040006"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46391 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab3IZRyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 13:54:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Vegard Nossum <vegard.nossum@oracle.com>, vaughan <vaughan.cao@oracle.com>

This is a multi-part message in MIME format.
--------------020604070601030803040006
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch plugs two memory leaks in the sg driver. The
first was reported by Vegard Nossum and the second was
found by checking for the same pattern.

ChangeLog:
    - close two heap memory leaks. The first is an error
      path; the second is associated with getting debug
      information from procfs and sysfs.

The patch is generated from lk 3.12.0-rc2 .


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------020604070601030803040006
Content-Type: text/x-patch;
 name="sg_leaks312rc2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_leaks312rc2.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..aa86276 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2060,6 +2060,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	spin_lock_irqsave(&sdp->sfd_lock, iflags);
 	if (sdp->detached) {
 		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
@@ -2433,8 +2434,10 @@ static void * dev_seq_start(struct seq_file *s, loff_t *pos)
 
 	it->index = *pos;
 	it->max = sg_last_dev();
-	if (it->index >= it->max)
+	if (it->index >= it->max) {
+		kfree(it);
 		return NULL;
+	}
 	return it;
 }
 


--------------020604070601030803040006--
