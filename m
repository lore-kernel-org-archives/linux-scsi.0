From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 21/23] scsi: hisi_sas: Add v3 code to support ECC and AXI bus fatal error
Date: Fri, 9 Jun 2017 22:16:34 +0800
Message-ID: <1497017796-105067-22-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For ECC 1bit error, logic can recover it, so we only print a warning.
For ECC multi-bit and AXI bus fatal error, we panic.

Note: once v3 hw controller reset support is added, the panic will
      be replaced by a controller reset, like v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 394 +++++++++++++++++++++++++++++++++
 1 file changed, 394 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3cd4b9a..63a74a0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -51,7 +51,39 @@
 #define CFG_SET_ABORTED_IPTT_OFF	0
 #define CFG_SET_ABORTED_IPTT_MSK	(0xfff << CFG_SET_ABORTED_IPTT_OFF)
 #define CFG_1US_TIMER_TRSH		0xcc
+#define HGC_LM_DFX_STATUS2		0x128
+#define HGC_LM_DFX_STATUS2_IOSTLIST_OFF		0
+#define HGC_LM_DFX_STATUS2_IOSTLIST_MSK	(0xfff <<\
+					HGC_LM_DFX_STATUS2_IOSTLIST_OFF)
+#define HGC_LM_DFX_STATUS2_ITCTLIST_OFF		12
+#define HGC_LM_DFX_STATUS2_ITCTLIST_MSK	(0x7ff <<\
+					HGC_LM_DFX_STATUS2_ITCTLIST_OFF)
+#define HGC_CQE_ECC_ADDR		0x13c
+#define HGC_CQE_ECC_1B_ADDR_OFF		0
+#define HGC_CQE_ECC_1B_ADDR_MSK		(0x3f << HGC_CQE_ECC_1B_ADDR_OFF)
+#define HGC_CQE_ECC_MB_ADDR_OFF		8
+#define HGC_CQE_ECC_MB_ADDR_MSK		(0x3f << HGC_CQE_ECC_MB_ADDR_OFF)
+#define HGC_IOST_ECC_ADDR		0x140
+#define HGC_IOST_ECC_1B_ADDR_OFF	0
+#define HGC_IOST_ECC_1B_ADDR_MSK	(0x3ff << HGC_IOST_ECC_1B_ADDR_OFF)
+#define HGC_IOST_ECC_MB_ADDR_OFF	16
+#define HGC_IOST_ECC_MB_ADDR_MSK	(0x3ff << HGC_IOST_ECC_MB_ADDR_OFF)
+#define HGC_DQE_ECC_ADDR		0x144
+#define HGC_DQE_ECC_1B_ADDR_OFF		0
+#define HGC_DQE_ECC_1B_ADDR_MSK		(0xfff << HGC_DQE_ECC_1B_ADDR_OFF)
+#define HGC_DQE_ECC_MB_ADDR_OFF		16
+#define HGC_DQE_ECC_MB_ADDR_MSK		(0xfff << HGC_DQE_ECC_MB_ADDR_OFF)
 #define CHNL_INT_STATUS			0x148
+#define HGC_ITCT_ECC_ADDR		0x150
+#define HGC_ITCT_ECC_1B_ADDR_OFF	0
+#define HGC_ITCT_ECC_1B_ADDR_MSK	(0x3ff << HGC_ITCT_ECC_1B_ADDR_OFF)
+#define HGC_ITCT_ECC_MB_ADDR_OFF	16
+#define HGC_ITCT_ECC_MB_ADDR_MSK	(0x3ff << HGC_ITCT_ECC_MB_ADDR_OFF)
+#define HGC_AXI_FIFO_ERR_INFO	0x154
+#define AXI_ERR_INFO_OFF		0
+#define AXI_ERR_INFO_MSK		(0xff << AXI_ERR_INFO_OFF)
+#define FIFO_ERR_INFO_OFF		8
+#define FIFO_ERR_INFO_MSK		(0xff << FIFO_ERR_INFO_OFF)
 #define INT_COAL_EN			0x19c
 #define OQ_INT_COAL_TIME		0x1a0
 #define OQ_INT_COAL_CNT			0x1a4
@@ -85,6 +117,26 @@
 #define ENT_INT_SRC_MSK3_ENT95_MSK_MSK	(0x1 << ENT_INT_SRC_MSK3_ENT95_MSK_OFF)
 #define SAS_ECC_INTR			0x1e8
 #define SAS_ECC_INTR_MSK		0x1ec
+#define SAS_ECC_INTR_DQE_ECC_1B_OFF		0
+#define SAS_ECC_INTR_DQE_ECC_MB_OFF		1
+#define SAS_ECC_INTR_IOST_ECC_1B_OFF	2
+#define SAS_ECC_INTR_IOST_ECC_MB_OFF	3
+#define SAS_ECC_INTR_ITCT_ECC_MB_OFF	4
+#define SAS_ECC_INTR_ITCT_ECC_1B_OFF	5
+#define SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF	6
+#define SAS_ECC_INTR_IOSTLIST_ECC_1B_OFF	7
+#define SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF	8
+#define SAS_ECC_INTR_ITCTLIST_ECC_1B_OFF	9
+#define SAS_ECC_INTR_CQE_ECC_1B_OFF		10
+#define SAS_ECC_INTR_CQE_ECC_MB_OFF		11
+#define SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF	12
+#define SAS_ECC_INTR_NCQ_MEM0_ECC_1B_OFF	13
+#define SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF	14
+#define SAS_ECC_INTR_NCQ_MEM1_ECC_1B_OFF	15
+#define SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF	16
+#define SAS_ECC_INTR_NCQ_MEM2_ECC_1B_OFF	17
+#define SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF	18
+#define SAS_ECC_INTR_NCQ_MEM3_ECC_1B_OFF	19
 #define HGC_ERR_STAT_EN			0x238
 #define DLVRY_Q_0_BASE_ADDR_LO		0x260
 #define DLVRY_Q_0_BASE_ADDR_HI		0x264
@@ -98,6 +150,20 @@
 #define COMPL_Q_0_DEPTH			0x4e8
 #define COMPL_Q_0_WR_PTR		0x4ec
 #define COMPL_Q_0_RD_PTR		0x4f0
+#define HGC_RXM_DFX_STATUS14	0xae8
+#define HGC_RXM_DFX_STATUS14_MEM0_OFF		0
+#define HGC_RXM_DFX_STATUS14_MEM0_MSK		(0x1ff <<\
+						HGC_RXM_DFX_STATUS14_MEM0_OFF)
+#define HGC_RXM_DFX_STATUS14_MEM1_OFF		9
+#define HGC_RXM_DFX_STATUS14_MEM1_MSK		(0x1ff <<\
+						HGC_RXM_DFX_STATUS14_MEM1_OFF)
+#define HGC_RXM_DFX_STATUS14_MEM2_OFF		18
+#define HGC_RXM_DFX_STATUS14_MEM2_MSK		(0x1ff <<\
+						HGC_RXM_DFX_STATUS14_MEM2_OFF)
+#define HGC_RXM_DFX_STATUS15	0xaec
+#define HGC_RXM_DFX_STATUS15_MEM3_OFF		0
+#define HGC_RXM_DFX_STATUS15_MEM3_MSK		(0x1ff <<\
+						HGC_RXM_DFX_STATUS15_MEM3_OFF)
 #define AWQOS_AWCACHE_CFG	0xc84
 #define ARQOS_ARCACHE_CFG	0xc88
 
@@ -260,6 +326,8 @@
 #define ITCT_HDR_RTOLT_OFF		48
 #define ITCT_HDR_RTOLT_MSK		(0xffffULL << ITCT_HDR_RTOLT_OFF)
 
+#define HISI_SAS_FATAL_INT_NR	2
+
 struct hisi_sas_complete_v3_hdr {
 	__le32 dw0;
 	__le32 dw1;
@@ -1212,6 +1280,320 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
+static void one_bit_ecc_error_process_v3_hw(struct hisi_hba *hisi_hba,
+		u32 irq_value)
+{
+	struct device *dev = hisi_hba->dev;
+	u32 reg_val;
+
+	if (irq_value & BIT(SAS_ECC_INTR_DQE_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_DQE_ECC_ADDR);
+		dev_info(dev, "hgc_dqe_acc1b_intr found: Ram address is 0x%08X\n",
+				(reg_val & HGC_DQE_ECC_1B_ADDR_MSK)
+				>> HGC_DQE_ECC_1B_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_IOST_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_IOST_ECC_ADDR);
+		dev_info(dev, "hgc_iost_acc1b_intr found: Ram address is 0x%08X\n",
+				(reg_val & HGC_IOST_ECC_1B_ADDR_MSK)
+				>> HGC_IOST_ECC_1B_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_ITCT_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_ITCT_ECC_ADDR);
+		dev_info(dev, "hgc_itct_acc1b_intr found: Ram address is 0x%08X\n",
+				(reg_val & HGC_ITCT_ECC_1B_ADDR_MSK)
+				>> HGC_ITCT_ECC_1B_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_IOSTLIST_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
+		dev_info(dev, "hgc_iostl_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_LM_DFX_STATUS2_IOSTLIST_MSK)
+				>> HGC_LM_DFX_STATUS2_IOSTLIST_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_ITCTLIST_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
+		dev_info(dev, "hgc_itctl_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_LM_DFX_STATUS2_ITCTLIST_MSK)
+				>> HGC_LM_DFX_STATUS2_ITCTLIST_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_CQE_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_CQE_ECC_ADDR);
+		dev_info(dev, "hgc_cqe_acc1b_intr found: Ram address is 0x%08X\n",
+				(reg_val & HGC_CQE_ECC_1B_ADDR_MSK)
+				>> HGC_CQE_ECC_1B_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		dev_info(dev, "rxm_mem0_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_RXM_DFX_STATUS14_MEM0_MSK)
+				>> HGC_RXM_DFX_STATUS14_MEM0_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		dev_info(dev, "rxm_mem1_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_RXM_DFX_STATUS14_MEM1_MSK)
+				>> HGC_RXM_DFX_STATUS14_MEM1_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		dev_info(dev, "rxm_mem2_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_RXM_DFX_STATUS14_MEM2_MSK)
+				>> HGC_RXM_DFX_STATUS14_MEM2_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_1B_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS15);
+		dev_info(dev, "rxm_mem3_acc1b_intr found: memory address is 0x%08X\n",
+				(reg_val & HGC_RXM_DFX_STATUS15_MEM3_MSK)
+				>> HGC_RXM_DFX_STATUS15_MEM3_OFF);
+	}
+
+}
+
+static void multi_bit_ecc_error_process_v3_hw(struct hisi_hba *hisi_hba,
+		u32 irq_value)
+{
+	u32 reg_val;
+	struct device *dev = hisi_hba->dev;
+
+	if (irq_value & BIT(SAS_ECC_INTR_DQE_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_DQE_ECC_ADDR);
+		panic("%s: hgc_dqe_accbad_intr (0x%x) found:"
+		      " Ram address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_DQE_ECC_MB_ADDR_MSK)
+		      >> HGC_DQE_ECC_MB_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_IOST_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_IOST_ECC_ADDR);
+		panic("%s: hgc_iost_accbad_intr (0x%x) found:"
+		      " Ram address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_IOST_ECC_MB_ADDR_MSK)
+		      >> HGC_IOST_ECC_MB_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_ITCT_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_ITCT_ECC_ADDR);
+		panic("%s: hgc_itct_accbad_intr (0x%x) found:"
+		      " Ram address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_ITCT_ECC_MB_ADDR_MSK)
+		      >> HGC_ITCT_ECC_MB_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
+		panic("%s: hgc_iostl_accbad_intr (0x%x) found:"
+		      " memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_LM_DFX_STATUS2_IOSTLIST_MSK)
+		      >> HGC_LM_DFX_STATUS2_IOSTLIST_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
+		panic("%s: hgc_itctl_accbad_intr (0x%x) found:"
+		      " memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_LM_DFX_STATUS2_ITCTLIST_MSK)
+		      >> HGC_LM_DFX_STATUS2_ITCTLIST_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_CQE_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_CQE_ECC_ADDR);
+		panic("%s: hgc_cqe_accbad_intr (0x%x) found:"
+		      " Ram address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_CQE_ECC_MB_ADDR_MSK)
+		      >> HGC_CQE_ECC_MB_ADDR_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		panic("%s: rxm_mem0_accbad_intr (0x%x) found:"
+		      "memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_RXM_DFX_STATUS14_MEM0_MSK)
+		      >> HGC_RXM_DFX_STATUS14_MEM0_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		panic("%s: rxm_mem1_accbad_intr (0x%x) found:"
+		      " memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_RXM_DFX_STATUS14_MEM1_MSK)
+		      >> HGC_RXM_DFX_STATUS14_MEM1_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
+		panic("%s: rxm_mem2_accbad_intr (0x%x) found:"
+		      " memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_RXM_DFX_STATUS14_MEM2_MSK)
+		      >> HGC_RXM_DFX_STATUS14_MEM2_OFF);
+	}
+
+	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF)) {
+		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS15);
+		panic("%s: rxm_mem3_accbad_intr (0x%x) found:"
+		      " memory address is 0x%08X\n",
+		      dev_name(dev), irq_value,
+		      (reg_val & HGC_RXM_DFX_STATUS15_MEM3_MSK)
+		      >> HGC_RXM_DFX_STATUS15_MEM3_OFF);
+	}
+
+}
+
+static irqreturn_t fatal_ecc_int_v3_hw(int irq_no, struct hisi_hba *hisi_hba)
+{
+	u32 irq_value, irq_msk;
+
+	irq_msk = hisi_sas_read32(hisi_hba, SAS_ECC_INTR_MSK);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, irq_msk | 0xffffffff);
+
+	irq_value = hisi_sas_read32(hisi_hba, SAS_ECC_INTR);
+	if (irq_value) {
+		multi_bit_ecc_error_process_v3_hw(hisi_hba, irq_value);
+		one_bit_ecc_error_process_v3_hw(hisi_hba, irq_value);
+	}
+
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR, irq_value);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, irq_msk);
+
+	return IRQ_HANDLED;
+}
+
+#define AXI_ERR_NR	8
+static const char axi_err_info[AXI_ERR_NR][32] = {
+	"IOST_AXI_W_ERR",
+	"IOST_AXI_R_ERR",
+	"ITCT_AXI_W_ERR",
+	"ITCT_AXI_R_ERR",
+	"SATA_AXI_W_ERR",
+	"SATA_AXI_R_ERR",
+	"DQE_AXI_R_ERR",
+	"CQE_AXI_W_ERR"
+};
+
+#define FIFO_ERR_NR	5
+static const char fifo_err_info[FIFO_ERR_NR][32] = {
+	"CQE_WINFO_FIFO",
+	"CQE_MSG_FIFIO",
+	"GETDQE_FIFO",
+	"CMDP_FIFO",
+	"AWTCTRL_FIFO"
+};
+
+static irqreturn_t fatal_axi_int_v3_hw(int irq_no, struct hisi_hba *hisi_hba)
+{
+	u32 irq_value, irq_msk, err_value;
+	struct device *dev = hisi_hba->dev;
+
+	irq_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK3);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, irq_msk | 0xfffffffe);
+
+	irq_value = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+	if (irq_value) {
+		if (irq_value & BIT(ENT_INT_SRC3_WP_DEPTH_OFF)) {
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					1 << ENT_INT_SRC3_WP_DEPTH_OFF);
+			panic("%s: write pointer and depth error (0x%x) found!\n",
+					dev_name(dev), irq_value);
+		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_IPTT_SLOT_NOMATCH_OFF)) {
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+				1 << ENT_INT_SRC3_IPTT_SLOT_NOMATCH_OFF);
+			panic("%s: iptt no match slot error (0x%x) found!\n",
+					dev_name(dev), irq_value);
+		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_RP_DEPTH_OFF))
+			panic("%s: read pointer and depth error (0x%x) found!\n",
+					dev_name(dev), irq_value);
+
+		if (irq_value & BIT(ENT_INT_SRC3_AXI_OFF)) {
+			int i;
+
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					1 << ENT_INT_SRC3_AXI_OFF);
+			err_value = hisi_sas_read32(hisi_hba,
+						    HGC_AXI_FIFO_ERR_INFO);
+
+			for (i = 0; i < AXI_ERR_NR; i++) {
+				if (err_value & BIT(i))
+					panic("%s: %s (0x%x) found!\n",
+					      dev_name(dev),
+					      axi_err_info[i], irq_value);
+			}
+		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_FIFO_OFF)) {
+			int i;
+
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					1 << ENT_INT_SRC3_FIFO_OFF);
+			err_value = hisi_sas_read32(hisi_hba,
+						    HGC_AXI_FIFO_ERR_INFO);
+
+			for (i = 0; i < FIFO_ERR_NR; i++) {
+				if (err_value & BIT(AXI_ERR_NR + i))
+					panic("%s: %s (0x%x) found!\n",
+					      dev_name(dev),
+					      fifo_err_info[i], irq_value);
+			}
+
+		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_LM_OFF)) {
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					1 << ENT_INT_SRC3_LM_OFF);
+			panic("%s: LM add/fetch list error (0x%x) found!\n",
+					dev_name(dev), irq_value);
+		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_ABT_OFF)) {
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					1 << ENT_INT_SRC3_ABT_OFF);
+			panic("%s: SAS_HGC_ABT fetch LM list error (0x%x) found!\n",
+					dev_name(dev), irq_value);
+		}
+	}
+
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, irq_msk);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fatal_interrupt_v3_hw(int irq_no, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	u32 irq_value1, irq_value2;
+
+	irq_value1 = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+	irq_value2 = hisi_sas_read32(hisi_hba, SAS_ECC_INTR);
+
+	if (irq_value1)
+		return fatal_axi_int_v3_hw(irq_no, hisi_hba);
+
+	if (irq_value2)
+		return fatal_ecc_int_v3_hw(irq_no, hisi_hba);
+
+	return IRQ_NONE;
+}
+
 static void
 slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	       struct hisi_sas_slot *slot)
@@ -1508,6 +1890,15 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		goto free_phy_irq;
 	}
 
+	rc = devm_request_irq(dev, pci_irq_vector(pdev, 11),
+			      fatal_interrupt_v3_hw, 0,
+			      DRV_NAME " fatal", hisi_hba);
+	if (rc) {
+		dev_err(dev, "could not request fatal interrupt, rc=%d\n", rc);
+		rc = -ENOENT;
+		goto free_chnl_interrupt;
+	}
+
 	/* Init tasklets for cq only */
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
@@ -1535,6 +1926,8 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 
 		free_irq(pci_irq_vector(pdev, k+16), cq);
 	}
+	free_irq(pci_irq_vector(pdev, 11), hisi_hba);
+free_chnl_interrupt:
 	free_irq(pci_irq_vector(pdev, 2), hisi_hba);
 free_phy_irq:
 	free_irq(pci_irq_vector(pdev, 1), hisi_hba);
@@ -1730,6 +2123,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 
 	free_irq(pci_irq_vector(pdev, 1), hisi_hba);
 	free_irq(pci_irq_vector(pdev, 2), hisi_hba);
+	free_irq(pci_irq_vector(pdev, 11), hisi_hba);
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
-- 
1.9.1
