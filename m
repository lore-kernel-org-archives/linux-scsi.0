From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 01/11] megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid Controllers
Date: Thu,  1 Dec 2016 14:10:35 -0500
Message-ID: <1480619445-45073-2-git-send-email-sasikumar.pc@broadcom.com>
References: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.48]:37685 "EHLO
        rndsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758838AbcLATUr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2016 14:20:47 -0500
In-Reply-To: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

From: root <sasikumar.pc@broadcom.com>

This patch contains new pci device ids for SAS3.5 Generic Megaraid Controllers

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 11 ++++++++++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 20 +++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 29 ++++++++++++++++++++++-------
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 0d2625b..f24ce88 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -56,6 +56,14 @@
 #define PCI_DEVICE_ID_LSI_INTRUDER_24		0x00cf
 #define PCI_DEVICE_ID_LSI_CUTLASS_52		0x0052
 #define PCI_DEVICE_ID_LSI_CUTLASS_53		0x0053
+#define PCI_DEVICE_ID_LSI_MECTOR		    0x00D4
+#define PCI_DEVICE_ID_LSI_VENTURA		    0x0014
+#define PCI_DEVICE_ID_LSI_CRUSADER		    0x0015
+#define PCI_DEVICE_ID_LSI_HARPOON		    0x0016
+#define PCI_DEVICE_ID_LSI_TOMCAT		    0x0017
+#define PCI_DEVICE_ID_LSI_VENTURA_4PORT		0x001B
+#define PCI_DEVICE_ID_LSI_CRUSADER_4PORT	0x001C
+#define PCI_DEVICE_ID_LSI_MARLIN		    0x00D3
 
 /*
  * Intel HBA SSDIDs
@@ -1478,7 +1486,7 @@ struct megasas_register_set {
 
 	u32 	inbound_high_queue_port ;	/*00C4h*/
 
-	u32 	reserved_5;			/*00C8h*/
+	u32 inbound_single_queue_port;	/*00C8h*/
 	u32	res_6[11];			/*CCh*/
 	u32	host_diag;
 	u32	seq_offset;
@@ -2143,6 +2151,7 @@ struct megasas_instance {
 	u8 is_rdpq;
 	bool dev_handle;
 	bool fw_sync_cache_support;
+	bool is_ventura;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5462676..b7166b8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -155,6 +155,15 @@ static int megasas_register_aen(struct megasas_instance *instance,
 	/* Intruder 24 port*/
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CUTLASS_52)},
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CUTLASS_53)},
+	/* VENTURA */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VENTURA)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_MARLIN)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_MECTOR)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CRUSADER)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_HARPOON)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_TOMCAT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VENTURA_4PORT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_CRUSADER_4PORT)},
 	{}
 };
 
@@ -5723,6 +5732,15 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->pdev = pdev;
 
 	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_VENTURA:
+	case PCI_DEVICE_ID_LSI_MARLIN:
+	case PCI_DEVICE_ID_LSI_MECTOR:
+	case PCI_DEVICE_ID_LSI_CRUSADER:
+	case PCI_DEVICE_ID_LSI_HARPOON:
+	case PCI_DEVICE_ID_LSI_TOMCAT:
+	case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
+	case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
+	     instance->is_ventura = true;
 	case PCI_DEVICE_ID_LSI_FUSION:
 	case PCI_DEVICE_ID_LSI_PLASMA:
 	case PCI_DEVICE_ID_LSI_INVADER:
@@ -5747,7 +5765,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 			(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA))
 			fusion->adapter_type = THUNDERBOLT_SERIES;
-		else
+		else if (!instance->is_ventura)
 			fusion->adapter_type = INVADER_SERIES;
 	}
 	break;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 24778ba..e048423 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -189,15 +189,29 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
  */
 static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
-		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc, bool is_32bit)
 {
+	struct megasas_register_set __iomem *regs = instance->reg_set;
+	unsigned long flags;
+	
+	if (is_32bit)
+		writel(le32_to_cpu(req_desc->u.low),
+			&(regs)->inbound_single_queue_port);
+	else if (instance->is_ventura) {
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		writel(le32_to_cpu(req_desc->u.low),
+			&(regs)->inbound_low_queue_port);
+		writel(le32_to_cpu(req_desc->u.high),
+			&(regs)->inbound_high_queue_port);
+		mmiowb();
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+	} else {
 #if defined(writeq) && defined(CONFIG_64BIT)
 	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
 			le32_to_cpu(req_desc->u.low));
 
 	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
 #else
-	unsigned long flags;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel(le32_to_cpu(req_desc->u.low),
@@ -207,6 +221,7 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	mmiowb();
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
+	}
 }
 
 /**
@@ -850,7 +865,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	megasas_fire_cmd_fusion(instance, &req_desc);
+	megasas_fire_cmd_fusion(instance, &req_desc, false);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
@@ -2224,7 +2239,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 	 */
 	atomic_inc(&instance->fw_outstanding);
 
-	megasas_fire_cmd_fusion(instance, req_desc);
+	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
 
 	return 0;
 }
@@ -2595,7 +2610,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 		return DCMD_NOT_FIRED;
 	}
 
-	megasas_fire_cmd_fusion(instance, req_desc);
+	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
 	return DCMD_SUCCESS;
 }
 
@@ -2888,7 +2903,7 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 				cpu_to_le32(MR_DCMD_SYSTEM_PD_MAP_GET_INFO)))
 				&& !(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
 		if (refire_cmd)
-			megasas_fire_cmd_fusion(instance, req_desc);
+			megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
 		else
 			megasas_return_cmd(instance, cmd_mfi);
 	}
@@ -3067,7 +3082,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 		mr_request->tmReqFlags.isTMForLD = 1;
 
 	init_completion(&cmd_fusion->done);
-	megasas_fire_cmd_fusion(instance, req_desc);
+	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
 
 	timeleft = wait_for_completion_timeout(&cmd_fusion->done, 50 * HZ);
 
-- 
1.8.3.1

