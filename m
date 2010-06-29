From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 03/12]  be2iscsi: Adding crashdump support
Date: Wed, 30 Jun 2010 05:28:10 +0530
Message-ID: <20100629235800.GA20193@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:35297 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752700Ab0F3AHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:07:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	These changes allow the driver to support crashdump. We need to reset the
chip incase of a crashdump

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h |    3 +
 drivers/scsi/be2iscsi/be_main.c |   50 ++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.h |    9 ++++-
 4 files changed, 141 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4f19030..faba6d2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -19,6 +19,86 @@
 #include "be_mgmt.h"
 #include "be_main.h"
 
+int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
+{
+	u32 sreset;
+	u8 *pci_reset_offset = 0;
+	u8 *pci_online0_offset = 0;
+	u8 *pci_online1_offset = 0;
+	u32 pconline0 = 0;
+	u32 pconline1 = 0;
+	u32 i;
+
+	pci_reset_offset = (u8 *)phba->pci_va + BE2_SOFT_RESET;
+	pci_online0_offset = (u8 *)phba->pci_va + BE2_PCI_ONLINE0;
+	pci_online1_offset = (u8 *)phba->pci_va + BE2_PCI_ONLINE1;
+	sreset = readl((void *)pci_reset_offset);
+	sreset |= BE2_SET_RESET;
+	writel(sreset, (void *)pci_reset_offset);
+
+	i = 0;
+	while (sreset & BE2_SET_RESET) {
+		if (i > 64)
+			break;
+		msleep(100);
+		sreset = readl((void *)pci_reset_offset);
+		i++;
+	}
+
+	if (sreset & BE2_SET_RESET) {
+		printk(KERN_ERR "Soft Reset  did not deassert\n");
+		return -EIO;
+	}
+	pconline1 = BE2_MPU_IRAM_ONLINE;
+	writel(pconline0, (void *)pci_online0_offset);
+	writel(pconline1, (void *)pci_online1_offset);
+
+	sreset = BE2_SET_RESET;
+	writel(sreset, (void *)pci_reset_offset);
+
+	i = 0;
+	while (sreset & BE2_SET_RESET) {
+		if (i > 64)
+			break;
+		msleep(1);
+		sreset = readl((void *)pci_reset_offset);
+		i++;
+	}
+	if (sreset & BE2_SET_RESET) {
+		printk(KERN_ERR "MPU Online Soft Reset did not deassert\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+int be_chk_reset_complete(struct beiscsi_hba *phba)
+{
+	unsigned int num_loop;
+	u8 *mpu_sem = 0;
+	u32 status;
+
+	num_loop = 1000;
+	mpu_sem = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
+	msleep(5000);
+
+	while (num_loop) {
+		status = readl((void *)mpu_sem);
+
+		if ((status & 0x80000000) || (status & 0x0000FFFF) == 0xC000)
+			break;
+		msleep(60);
+		num_loop--;
+	}
+
+	if ((status & 0x80000000) || (!num_loop)) {
+		printk(KERN_ERR "Failed in be_chk_reset_complete"
+		"status = 0x%x\n", status);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 void be_mcc_notify(struct beiscsi_hba *phba)
 {
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index f94df6c..18915a6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -901,6 +901,9 @@ struct be_fw_cfg {
 						 * the cxn
 						 */
 
+int beiscsi_pci_soft_reset(struct beiscsi_hba *phba);
+int be_chk_reset_complete(struct beiscsi_hba *phba);
+
 void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
 			bool embedded, u8 sge_cnt);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 83fabe8..d5ece74 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -41,6 +41,8 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
+static unsigned int gcrashmode = 0;
+static unsigned int num_hba = 0;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -3713,6 +3715,8 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	unsigned int i, msix_vec;
+	u8 *real_offset = 0;
+	u32 value = 0;
 
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
 	if (!phba) {
@@ -3741,6 +3745,14 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
+	real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
+
+	value = readl((void *)real_offset);
+
+	if (value & 0x00010000) {
+		value &= 0xfffeffff;
+		writel(value, (void *)real_offset);
+	}
 	beiscsi_unmap_pci_function(phba);
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
@@ -3774,6 +3786,8 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	int ret, msix_vec, num_cpus, i;
+	u8 *real_offset = 0;
+	u32 value = 0;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -3819,6 +3833,33 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto hba_free;
 	}
 
+	if (!num_hba) {
+		real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
+		value = readl((void *)real_offset);
+		if (value & 0x00010000) {
+			gcrashmode++;
+			shost_printk(KERN_ERR, phba->shost,
+				"Loading Driver in crashdump mode\n");
+			ret = beiscsi_pci_soft_reset(phba);
+			if (ret) {
+				shost_printk(KERN_ERR, phba->shost,
+					"Reset Failed. Aborting Crashdump\n");
+				goto hba_free;
+			}
+			ret = be_chk_reset_complete(phba);
+			if (ret) {
+				shost_printk(KERN_ERR, phba->shost,
+					"Failed to get out of reset."
+					"Aborting Crashdump\n");
+				goto hba_free;
+			}
+		} else {
+			value |= 0x00010000;
+			writel(value, (void *)real_offset);
+			num_hba++;
+		}
+	}
+
 	spin_lock_init(&phba->io_sgl_lock);
 	spin_lock_init(&phba->mgmt_sgl_lock);
 	spin_lock_init(&phba->isr_lock);
@@ -3904,6 +3945,15 @@ free_twq:
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
 free_port:
+	real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
+
+	value = readl((void *)real_offset);
+
+	if (value & 0x00010000) {
+		value &= 0xfffeffff;
+		writel(value, (void *)real_offset);
+	}
+
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index e6ddddb..05ad76e 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -69,7 +69,14 @@
 #define BEISCSI_NUM_DEVICES_SUPPORTED	0x01
 #define BEISCSI_MAX_FRAGS_INIT	192
 #define BE_NUM_MSIX_ENTRIES	1
-#define MPU_EP_SEMAPHORE	0xac
+
+#define MPU_EP_CONTROL          0
+#define MPU_EP_SEMAPHORE        0xac
+#define BE2_SOFT_RESET          0x5c
+#define BE2_PCI_ONLINE0         0xb0
+#define BE2_PCI_ONLINE1         0xb4
+#define BE2_SET_RESET           0x80
+#define BE2_MPU_IRAM_ONLINE     0x00000080
 
 #define BE_SENSE_INFO_SIZE		258
 #define BE_ISCSI_PDU_HEADER_SIZE	64
-- 
1.6.5.2

