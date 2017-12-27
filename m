From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 26/30] scsi: aacraid: Fix hang while scanning in eh recovery
Date: Tue, 26 Dec 2017 20:34:47 -0800
Message-ID: <20171227043451.27813-27-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0046.outbound.protection.outlook.com ([104.47.41.46]:7296
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751856AbdL0EfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:24 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Add back the ability to scan for hotplug changes while eh was in progress.

Schedule a rescan for a later time in the eh recovery code and wait for
eh to complete in the rescan worker.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aacraid.h | 4 ++++
 drivers/scsi/aacraid/commsup.c | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 54078bf..4cefc47 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -41,6 +41,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <scsi/scsi_host.h>
 
 /*------------------------------------------------------------------------------
  *              D E F I N E S
@@ -2655,6 +2656,9 @@ static inline void aac_safw_rescan_worker(struct work_struct *work)
 	struct aac_dev *dev = container_of(to_delayed_work(work),
 		struct aac_dev, safw_rescan_work);
 
+	wait_event(dev->scsi_host_ptr->host_wait,
+		!scsi_host_in_recovery(dev->scsi_host_ptr));
+
 	aac_scan_host(dev, AAC_RESCAN);
 }
 
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d562053..706aba0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1671,6 +1671,15 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	aac->in_reset = 0;
 	scsi_unblock_requests(host);
 
+	/*
+	 * Issue bus rescan to catch any configuration that might have
+	 * occurred
+	 */
+	if (!retval) {
+		dev_info(&aac->pdev->dev, "Scheduling bus rescan\n");
+		aac_schedule_safw_scan_worker(aac);
+	}
+
 	if (jafo) {
 		spin_lock_irq(host->host_lock);
 	}
-- 
2.9.4
