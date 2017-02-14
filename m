From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 03/16] aacraid: Fix for excessive prints on EEH
Date: Tue, 14 Feb 2017 12:44:33 -0800
Message-ID: <20170214204446.14808-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:13488
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751656AbdBODWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:35 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
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
 drivers/scsi/aacraid/commsup.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 56090f5..6220b47 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -461,6 +461,30 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw
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
+#endif
+
 /*
  *	Define the highest level of host to adapter communication routines.
  *	These routines will support host to adapter FS commuication. These
@@ -496,7 +520,6 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	unsigned long mflags = 0;
 	unsigned long sflags = 0;
 
-
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
 	/*
@@ -662,6 +685,12 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					}
 					return -ETIMEDOUT;
 				}
+
+#if defined(CONFIG_EEH)
+				if (aac_check_eeh_failure(dev))
+					return -EFAULT;
+#endif
+
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
 					if (wait == -1) {
 	        				printk(KERN_ERR "aacraid: aac_fib_send: adapter blinkLED 0x%x.\n"
@@ -755,7 +784,14 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 	FIB_COUNTER_INCREMENT(aac_config.NativeSent);
 
 	if (wait) {
+
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
+
+#if defined(CONFIG_EEH)
+		if (aac_check_eeh_failure(dev))
+			return -EFAULT;
+#endif
+
 		/* Only set for first known interruptable command */
 		if (down_interruptible(&fibptr->event_wait)) {
 			fibptr->done = 2;
-- 
2.7.4
