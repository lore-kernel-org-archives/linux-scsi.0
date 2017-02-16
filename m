From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 03/15] aacraid: Fix for excessive prints on EEH
Date: Thu, 16 Feb 2017 12:51:12 -0800
Message-ID: <20170216205124.20271-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:23296
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755147AbdBQD2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:11 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

This issue showed up on a kdump debug(single CPU on powerkvm), when EEH
errors rendered the adapter unusable. The driver correctly detected the
issue and attempted to restart the controller, in doing so the driver
attempted to read the status registers of the controller. This triggered
additional eeh errors which continued for a good 6 minutes.

Fixed by returning without waiting when EEH error is reported.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>

---
Changes for V2:
Refactored code to remove CONFIG_EEH macros

 drivers/scsi/aacraid/commsup.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 56090f5..a8dd4b5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -461,6 +461,35 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw
 	return 0;
 }
 
+#ifdef CONFIG_EEH
+static inline int aac_check_eeh_failure(struct aac_dev *dev)
+{
+	/* Check for an EEH failure for the given
+	 * device node. Function eeh_dev_check_failure()
+	 * returns 0 if there has not been an EEH error
+	 * otherwise returns a non-zero value.
+	 *
+	 * Need to be called before any PCI operation,
+	 * i.e.,before aac_adapter_check_health()
+	 */
+	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev->pdev);
+
+	if (eeh_dev_check_failure(edev)) {
+		/* The EEH mechanisms will handle this
+		 * error and reset the device if
+		 * necessary.
+		 */
+		return 1;
+	}
+	return 0;
+}
+#else
+static inline int aac_check_eeh_failure(struct aac_dev *dev)
+{
+	return 0;
+}
+#endif
+
 /*
  *	Define the highest level of host to adapter communication routines.
  *	These routines will support host to adapter FS commuication. These
@@ -496,7 +525,6 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	unsigned long mflags = 0;
 	unsigned long sflags = 0;
 
-
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
 	/*
@@ -662,6 +690,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					}
 					return -ETIMEDOUT;
 				}
+
+				if (aac_check_eeh_failure(dev))
+					return -EFAULT;
+
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
 					if (wait == -1) {
 	        				printk(KERN_ERR "aacraid: aac_fib_send: adapter blinkLED 0x%x.\n"
@@ -755,7 +787,12 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 	FIB_COUNTER_INCREMENT(aac_config.NativeSent);
 
 	if (wait) {
+
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
+
+		if (aac_check_eeh_failure(dev))
+			return -EFAULT;
+
 		/* Only set for first known interruptable command */
 		if (down_interruptible(&fibptr->event_wait)) {
 			fibptr->done = 2;
-- 
2.7.4
