From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/2] mptsas : Removed print form mptctl.
Date: Wed, 7 Oct 2009 11:26:54 +0530
Message-ID: <20091007055647.GB24815@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35460 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbZJGGVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 02:21:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Removed printk which floods unnecessary messages to var/log/message

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 9b2e219..352acd0 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -621,11 +621,8 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	 */
 	iocnumX = khdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
-	    (iocp == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnumX);
+	    (iocp == NULL))
 		return -ENODEV;
-	}
 
 	if (!iocp->active) {
 		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - Controller disabled.\n",
