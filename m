From: Rob Landley <rob@landley.net>
Subject: [PATCH 6/16]  Update kerneldoc comments in drivers/scsi/scsi_ioctl.c
Date: Fri, 26 Oct 2007 23:11:17 -0500
Message-ID: <200710262311.17366.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35966
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbXJ0DLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:11:33 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id EB4A673938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:14:16 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_ioctl.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_ioctl.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_ioctl.c	Fri Oct 26 22:44:42 2007 -0500
@@ -174,10 +174,15 @@ static int scsi_ioctl_get_pci(struct scs
 }
 
 
-/*
- * the scsi_ioctl() function differs from most ioctls in that it does
- * not take a major/minor number as the dev field.  Rather, it takes
- * a pointer to a scsi_devices[] element, a structure. 
+/**
+ * scsi_ioctl - Dispatch ioctl to scsi device
+ * @sdev: scsi device receiving ioctl
+ * @cmd: which ioctl is it
+ * @arg: data associated with ioctl
+ *
+ * Description: The scsi_ioctl() function differs from most ioctls in that it
+ * does not take a major/minor number as the dev field.  Rather, it takes
+ * a pointer to a &struct scsi_device. 
  */
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
@@ -264,9 +269,12 @@ int scsi_ioctl(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
-/*
- * the scsi_nonblock_ioctl() function is designed for ioctls which may
- * be executed even if the device is in recovery.
+/**
+ * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * @sdev: scsi device receiving ioctl
+ * @cmd: Must be SC_SCSI_RESET
+ * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
+ * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, struct file *filp)
@@ -276,7 +284,7 @@ int scsi_nonblockable_ioctl(struct scsi_
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
-	if (filp && filp->f_flags & O_NONBLOCK) {
+	if (filp && (filp->f_flags & O_NONBLOCK)) {
 		if (scsi_host_in_recovery(sdev->host))
 			return -ENODEV;
 	} else if (!scsi_block_when_processing_errors(sdev))

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
