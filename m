From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH 1/3] scsi: aacraid: Check for PCI state of device in a generic way
Date: Fri, 17 Nov 2017 19:14:53 -0200
Message-ID: <20171117211455.29031-2-gpiccoli@linux.vnet.ibm.com>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752942AbdKQVPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 16:15:12 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAHLFAlf047517
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:11 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ea4rd7ae4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:11 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Fri, 17 Nov 2017 16:15:09 -0500
In-Reply-To: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org
Cc: gpiccoli@linux.vnet.ibm.com, david.carroll@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, gpiccoli@protonmail.ch

Commit 16ae9dd35d37 ("scsi: aacraid: Fix for excessive prints on EEH")
introduced checks about the state of device before any PCI operations
in the driver. Basically, this prevents it to perform PCI accesses
when device is in the process of recover from a PCI error. In PowerPC,
such mechanism is called EEH, and the aforementioned commit introduced
checks that are based on EEH-specific primitives for that.

The potential problems with this approach are three: first, these checks
are "locked" to powerpc only - another archs could have error recovery
methods too, like AER in Intel. Also, the powerpc primitives perform
expensive FW accesses to validate the precise PCI state of a device.
Finally, code becomes more complicated and needs ifdef validation
based on arch config being set.

So, this patch makes use of generic PCI state checks, which are
lightweight and non-dependent of arch configs - also, it makes
the code cleaner.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
 drivers/scsi/aacraid/commsup.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 525a652dab48..2abe8fd83494 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -467,35 +467,6 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw
 	return 0;
 }
 
-#ifdef CONFIG_EEH
-static inline int aac_check_eeh_failure(struct aac_dev *dev)
-{
-	/* Check for an EEH failure for the given
-	 * device node. Function eeh_dev_check_failure()
-	 * returns 0 if there has not been an EEH error
-	 * otherwise returns a non-zero value.
-	 *
-	 * Need to be called before any PCI operation,
-	 * i.e.,before aac_adapter_check_health()
-	 */
-	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev->pdev);
-
-	if (eeh_dev_check_failure(edev)) {
-		/* The EEH mechanisms will handle this
-		 * error and reset the device if
-		 * necessary.
-		 */
-		return 1;
-	}
-	return 0;
-}
-#else
-static inline int aac_check_eeh_failure(struct aac_dev *dev)
-{
-	return 0;
-}
-#endif
-
 /*
  *	Define the highest level of host to adapter communication routines.
  *	These routines will support host to adapter FS commuication. These
@@ -701,7 +672,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					return -ETIMEDOUT;
 				}
 
-				if (aac_check_eeh_failure(dev))
+				if (unlikely(pci_channel_offline(dev->pdev)))
 					return -EFAULT;
 
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
@@ -801,7 +772,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
-		if (aac_check_eeh_failure(dev))
+		if (unlikely(pci_channel_offline(dev->pdev)))
 			return -EFAULT;
 
 		fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
-- 
2.15.0
