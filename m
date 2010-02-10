From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/1] be2iscsi: Adding support for BE3
Date: Thu, 11 Feb 2010 05:11:15 +0530
Message-ID: <20100210234035.GA16829@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:43420 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756742Ab0BJXlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 18:41:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch contains changes to support the BE3 chip

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be.h      |    3 +++
 drivers/scsi/be2iscsi/be_main.c |   30 +++++++++++++++++++++++++-----
 drivers/scsi/be2iscsi/be_main.h |    6 +++++-
 drivers/scsi/be2iscsi/be_mgmt.c |    2 ++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 0063740..136b49c 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -25,6 +25,9 @@
 #define MCC_Q_LEN	128
 #define MCC_CQ_LEN	256
 #define MAX_MCC_CMD	16
+/* BladeEngine Generation numbers */
+#define BE_GEN2 2
+#define BE_GEN3 3
 
 struct be_dma_mem {
 	void *va;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 687d535..7c22616 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -61,10 +61,10 @@ static int beiscsi_slave_configure(struct scsi_device *sdev)
 /*------------------- PCI Driver operations and data ----------------- */
 static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID3) },
-	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID4) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
@@ -143,6 +143,7 @@ static int beiscsi_map_pci_bars(struct beiscsi_hba *phba,
 				struct pci_dev *pcidev)
 {
 	u8 __iomem *addr;
+	int pcicfg_reg;
 
 	addr = ioremap_nocache(pci_resource_start(pcidev, 2),
 			       pci_resource_len(pcidev, 2));
@@ -159,13 +160,19 @@ static int beiscsi_map_pci_bars(struct beiscsi_hba *phba,
 	phba->db_va = addr;
 	phba->db_pa.u.a64.address =  pci_resource_start(pcidev, 4);
 
-	addr = ioremap_nocache(pci_resource_start(pcidev, 1),
-			       pci_resource_len(pcidev, 1));
+	if (phba->generation == BE_GEN2)
+		pcicfg_reg = 1;
+	else
+		pcicfg_reg = 0;
+
+	addr = ioremap_nocache(pci_resource_start(pcidev, pcicfg_reg),
+			       pci_resource_len(pcidev, pcicfg_reg));
+
 	if (addr == NULL)
 		goto pci_map_err;
 	phba->ctrl.pcicfg = addr;
 	phba->pci_va = addr;
-	phba->pci_pa.u.a64.address = pci_resource_start(pcidev, 1);
+	phba->pci_pa.u.a64.address = pci_resource_start(pcidev, pcicfg_reg);
 	return 0;
 
 pci_map_err:
@@ -3492,7 +3499,6 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		      io_task->pwrb_handle->wrb_index);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, sgl_icd_idx, pwrb,
 		      io_task->psgl_handle->sgl_index);
-
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
@@ -3695,6 +3701,20 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
+	switch (pcidev->device) {
+	case BE_DEVICE_ID1:
+	case OC_DEVICE_ID1:
+	case OC_DEVICE_ID2:
+		phba->generation = BE_GEN2;
+		break;
+	case BE_DEVICE_ID2:
+	case OC_DEVICE_ID3:
+		phba->generation = BE_GEN3;
+		break;
+	default:
+		phba->generation = 0;
+	}
+
 	if (enable_msix)
 		num_cpus = find_num_cpus();
 	else
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 8cbe908..c53a80a 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -40,11 +40,14 @@
 #define DRV_DESC		BE_NAME " " "Driver"
 
 #define BE_VENDOR_ID 		0x19A2
+/* DEVICE ID's for BE2 */
 #define BE_DEVICE_ID1		0x212
 #define OC_DEVICE_ID1		0x702
 #define OC_DEVICE_ID2		0x703
+
+/* DEVICE ID's for BE3 */
+#define BE_DEVICE_ID2		0x222
 #define OC_DEVICE_ID3		0x712
-#define OC_DEVICE_ID4		0x222
 
 #define BE2_IO_DEPTH		1024
 #define BE2_MAX_SESSIONS	256
@@ -325,6 +328,7 @@ struct beiscsi_hba {
 	struct workqueue_struct *wq;	/* The actuak work queue */
 	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
+	unsigned int generation;
 };
 
 struct beiscsi_session {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 39106da..317bcd0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -85,6 +85,7 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
 	req = nonemb_cmd.va;
+	memset(req, 0, sizeof(*req));
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
@@ -171,6 +172,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
 	req = nonemb_cmd.va;
+	memset(req, 0, sizeof(*req));
 	wrb = wrb_from_mccq(phba);
 	sge = nonembedded_sgl(wrb);
 	wrb->tag0 |= tag;
-- 
1.6.4

