From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 1/4] megaraid_sas: reduce memory footprints in kdump mode
Date: Fri, 15 Apr 2016 00:23:30 -0700
Message-ID: <1460705013-6482-2-git-send-email-sumit.saxena@broadcom.com>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35263 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDOHX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 03:23:58 -0400
Received: by mail-pf0-f178.google.com with SMTP id n1so54390372pfn.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 00:23:58 -0700 (PDT)
In-Reply-To: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com

This patch will reduce memory footprints of megaraid_sas driver when booted in kdump mode.
Driver will not allocate memory for optional and perfromance oriented features.
Below are key changes done in megaraid_sas driver to do this-
1. Limit Controller's queue depth to 100 in kdump mode.
2. Do not allocate memory for system info buffer and PD info buffer.
3. Disable performance oriented features e.g. Disable RDPQ mode, disable dual queue depth,
   restrict to single MSI-x vector. 

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 ++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 48 +++++++++++++++++------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 ++
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index fce414a..1784b09 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1344,6 +1344,8 @@ struct megasas_ctrl_info {
 #define SCAN_PD_CHANNEL	0x1
 #define SCAN_VD_CHANNEL	0x2
 
+#define MEGASAS_KDUMP_QUEUE_DEPTH               100
+
 enum MR_SCSI_CMD_TYPE {
 	READ_WRITE_LDIO = 0,
 	NON_READ_WRITE_LDIO = 1,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e6ebc7a..8588202 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5761,13 +5761,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		break;
 	}
 
-	instance->system_info_buf = pci_zalloc_consistent(pdev,
-					sizeof(struct MR_DRV_SYSTEM_INFO),
-					&instance->system_info_h);
-
-	if (!instance->system_info_buf)
-		dev_info(&instance->pdev->dev, "Can't allocate system info buffer\n");
-
 	/* Crash dump feature related initialisation*/
 	instance->drv_buf_index = 0;
 	instance->drv_buf_alloc = 0;
@@ -5777,14 +5770,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	spin_lock_init(&instance->crashdump_lock);
 	instance->crash_dump_buf = NULL;
 
-	if (!reset_devices)
-		instance->crash_dump_buf = pci_alloc_consistent(pdev,
-						CRASH_DMA_BUF_SIZE,
-						&instance->crash_dump_h);
-	if (!instance->crash_dump_buf)
-		dev_err(&pdev->dev, "Can't allocate Firmware "
-			"crash dump DMA buffer\n");
-
 	megasas_poll_wait_aen = 0;
 	instance->flag_ieee = 0;
 	instance->ev = NULL;
@@ -5803,11 +5788,26 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		goto fail_alloc_dma_buf;
 	}
 
-	instance->pd_info = pci_alloc_consistent(pdev,
-		sizeof(struct MR_PD_INFO), &instance->pd_info_h);
+	if (!reset_devices) {
+		instance->system_info_buf = pci_zalloc_consistent(pdev,
+					sizeof(struct MR_DRV_SYSTEM_INFO),
+					&instance->system_info_h);
+		if (!instance->system_info_buf)
+			dev_info(&instance->pdev->dev, "Can't allocate system info buffer\n");
+
+		instance->pd_info = pci_alloc_consistent(pdev,
+			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
 
-	if (!instance->pd_info)
-		dev_err(&instance->pdev->dev, "Failed to alloc mem for pd_info\n");
+		if (!instance->pd_info)
+			dev_err(&instance->pdev->dev, "Failed to alloc mem for pd_info\n");
+
+		instance->crash_dump_buf = pci_alloc_consistent(pdev,
+						CRASH_DMA_BUF_SIZE,
+						&instance->crash_dump_h);
+		if (!instance->crash_dump_buf)
+			dev_err(&pdev->dev, "Can't allocate Firmware "
+				"crash dump DMA buffer\n");
+	}
 
 	/*
 	 * Initialize locks and queues
@@ -7174,6 +7174,16 @@ static int __init megasas_init(void)
 	int rval;
 
 	/*
+	 * Booted in kdump kernel, minimize memory footprints by
+	 * disabling few features
+	 */
+	if (reset_devices) {
+		msix_vectors = 1;
+		rdpq_enable = 0;
+		dual_qdepth_disable = 1;
+	}
+
+	/*
 	 * Announce driver version and other information
 	 */
 	pr_info("megasas: %s\n", MEGASAS_VERSION);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 98a848b..320c1a0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -257,6 +257,9 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 		if (!instance->is_rdpq)
 			instance->max_fw_cmds = min_t(u16, instance->max_fw_cmds, 1024);
 
+		if (reset_devices)
+			instance->max_fw_cmds = min(instance->max_fw_cmds,
+						(u16)MEGASAS_KDUMP_QUEUE_DEPTH);
 		/*
 		* Reduce the max supported cmds by 1. This is to ensure that the
 		* reply_q_sz (1 more than the max cmd that driver may send)
-- 
2.4.11

