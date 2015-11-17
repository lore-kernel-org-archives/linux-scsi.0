From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 31/32] scsi: hisi_sas: add fatal irq handler
Date: Wed, 18 Nov 2015 00:50:58 +0800
Message-ID: <1447779059-136143-32-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Add handlers for fatal interrupts

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 119 +++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index a95259c..e29b7c7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1573,6 +1573,93 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t fatal_ecc_int_v1_hw(int irq, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 ecc_int = hisi_sas_read32(hisi_hba, SAS_ECC_INTR);
+
+	if (ecc_int & SAS_ECC_INTR_DQ_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("%s: Fatal DQ 1b ECC interrupt (0x%x)\n",
+		      dev_name(dev), ecc_err);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_DQ_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_DQ_ECC_ADDR) &
+				HGC_DQ_ECC_ADDR_BAD_MSK) >>
+				HGC_DQ_ECC_ADDR_BAD_OFF;
+
+		panic("%s: Fatal DQ RAM ECC interrupt @ 0x%08x\n",
+		      dev_name(dev), addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_IOST_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("%s: Fatal IOST 1b ECC interrupt (0x%x)\n",
+		      dev_name(dev), ecc_err);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_IOST_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_IOST_ECC_ADDR) &
+				HGC_IOST_ECC_ADDR_BAD_MSK) >>
+				HGC_IOST_ECC_ADDR_BAD_OFF;
+
+		panic("%s: Fatal IOST RAM ECC interrupt @ 0x%08x\n",
+		      dev_name(dev), addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_ITCT_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_ITCT_ECC_ADDR) &
+				HGC_ITCT_ECC_ADDR_BAD_MSK) >>
+				HGC_ITCT_ECC_ADDR_BAD_OFF;
+
+		panic("%s: Fatal TCT RAM ECC interrupt @ 0x%08x\n",
+		      dev_name(dev), addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_ITCT_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("%s: Fatal ITCT 1b ECC interrupt (0x%x)\n",
+		      dev_name(dev), ecc_err);
+	}
+
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR, ecc_int | 0x3f);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fatal_axi_int_v1_hw(int irq, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 axi_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC2);
+	u32 axi_info = hisi_sas_read32(hisi_hba, HGC_AXI_FIFO_ERR_INFO);
+
+	if (axi_int & ENT_INT_SRC2_DQ_CFG_ERR_MSK)
+		panic("%s: Fatal DQ_CFG_ERR interrupt (0x%x)\n",
+		      dev_name(dev), axi_info);
+
+	if (axi_int & ENT_INT_SRC2_CQ_CFG_ERR_MSK)
+		panic("%s: Fatal CQ_CFG_ERR interrupt (0x%x)\n",
+		      dev_name(dev), axi_info);
+
+	if (axi_int & ENT_INT_SRC2_AXI_WRONG_INT_MSK)
+		panic("%s: Fatal AXI_WRONG_INT interrupt (0x%x)\n",
+		      dev_name(dev), axi_info);
+
+	if (axi_int & ENT_INT_SRC2_AXI_OVERLF_INT_MSK)
+		panic("%s: Fatal AXI_OVERLF_INT incorrect interrupt (0x%x)\n",
+		      dev_name(dev), axi_info);
+
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC2, axi_int | 0x30000000);
+
+	return IRQ_HANDLED;
+}
+
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 	{"Bcast"},
 	{"Phy Up"},
@@ -1580,12 +1667,22 @@ static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 };
 
 static const char cq_int_name[32] = "cq";
+static const char fatal_int_name[HISI_SAS_FATAL_INT_NR][32] = {
+	"fatal ecc",
+	"fatal axi"
+};
+
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_bcast_v1_hw,
 	int_phyup_v1_hw,
 	int_abnormal_v1_hw
 };
 
+static irq_handler_t fatal_interrupts[HISI_SAS_MAX_QUEUES] = {
+	fatal_ecc_int_v1_hw,
+	fatal_axi_int_v1_hw
+};
+
 static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
@@ -1646,6 +1743,28 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		}
 	}
 
+	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
+	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
+		irq = irq_of_parse_and_map(np, idx);
+		if (!irq) {
+			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+		(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+			       HISI_SAS_NAME_LEN,
+			       "%s %s:%d", dev_name(dev), fatal_int_name[i], i);
+		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
+				      &int_names[idx * HISI_SAS_NAME_LEN],
+				      hisi_hba);
+		if (rc) {
+			dev_err(dev,
+				"irq init: could not request fatal interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.9.1
