From: John Garry <john.garry@huawei.com>
Subject: [PATCH 24/25] scsi: hisi_sas: add fatal irq handler
Date: Mon, 12 Oct 2015 23:20:36 +0800
Message-ID: <1444663237-238302-25-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:11758 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbJLPFf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:05:35 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add handlers for fatal interrupts.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 118 +++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b5ba46a..bc8e23e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1621,6 +1621,91 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t fatal_ecc_int_v1_hw(int irq, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	u32 ecc_int = hisi_sas_read32(hisi_hba, SAS_ECC_INTR);
+
+	if (ecc_int & SAS_ECC_INTR_DQ_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("Fatal DQ 1b ECC interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, ecc_err);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_DQ_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_DQ_ECC_ADDR) &
+				HGC_DQ_ECC_ADDR_BAD_MSK) >>
+				HGC_DQ_ECC_ADDR_BAD_OFF;
+
+		panic("Fatal DQ RAM ECC interrupt on controller %d @ 0x%08x\n",
+			hisi_hba->id, addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_IOST_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("Fatal IOST 1b ECC interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, ecc_err);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_IOST_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_IOST_ECC_ADDR) &
+				HGC_IOST_ECC_ADDR_BAD_MSK) >>
+				HGC_IOST_ECC_ADDR_BAD_OFF;
+
+		panic("Fatal IOST RAM ECC interrupt on controller %d @ 0x%08x\n",
+			hisi_hba->id, addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_ITCT_ECCBAD_MSK) {
+		u32 addr = (hisi_sas_read32(hisi_hba, HGC_ITCT_ECC_ADDR) &
+				HGC_ITCT_ECC_ADDR_BAD_MSK) >>
+				HGC_ITCT_ECC_ADDR_BAD_OFF;
+
+		panic("Fatal TCT RAM ECC interrupt on controller %d @ 0x%08x\n",
+			hisi_hba->id, addr);
+	}
+
+	if (ecc_int & SAS_ECC_INTR_ITCT_ECC1B_MSK) {
+		u32 ecc_err = hisi_sas_read32(hisi_hba, HGC_ECC_ERR);
+
+		panic("Fatal ITCT 1b ECC interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, ecc_err);
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
+	u32 axi_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC2);
+	u32 axi_info = hisi_sas_read32(hisi_hba, HGC_AXI_FIFO_ERR_INFO);
+
+	if (axi_int & ENT_INT_SRC2_DQ_CFG_ERR_MSK)
+		panic("Fatal DQ_CFG_ERR interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, axi_info);
+
+	if (axi_int & ENT_INT_SRC2_CQ_CFG_ERR_MSK)
+		panic("Fatal CQ_CFG_ERR interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, axi_info);
+
+	if (axi_int & ENT_INT_SRC2_AXI_WRONG_INT_MSK)
+		panic("Fatal AXI_WRONG_INT interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, axi_info);
+
+	if (axi_int & ENT_INT_SRC2_AXI_OVERLF_INT_MSK)
+		panic("Fatal AXI_OVERLF_INT incorrect interrupt on controller %d (0x%x)\n",
+			hisi_hba->id, axi_info);
+
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC2, axi_int | 0x30000000);
+
+	return IRQ_HANDLED;
+}
+
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 	{"Bcast"},
 	{"Phy Up"},
@@ -1628,6 +1713,10 @@ static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 };
 
 static const char cq_int_name[32] = "cq";
+static const char fatal_int_name[HISI_SAS_FATAL_INT_NR][32] = {
+	"fatal ecc",
+	"fatal axi"
+};
 
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_bcast_v1_hw,
@@ -1635,6 +1724,11 @@ static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_abnormal_v1_hw
 };
 
+static irq_handler_t fatal_interrupts[HISI_SAS_MAX_QUEUES] = {
+	fatal_ecc_int_v1_hw,
+	fatal_axi_int_v1_hw
+};
+
 int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 {
 	int i, j, irq, rc, id = hisi_hba->id;
@@ -1697,6 +1791,30 @@ int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		idx++;
 	}
 
+	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++) {
+		int idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) +
+				hisi_hba->queue_count + i;
+
+		irq = irq_of_parse_and_map(np, idx);
+		if (!irq) {
+			dev_err(dev, "irq init: [%d] could not map fatal interrupt %d\n",
+				hisi_hba->id, idx);
+			return -ENOENT;
+		}
+		(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+				HISI_SAS_NAME_LEN,
+				DRV_NAME" %s [%d]", fatal_int_name[i], id);
+		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
+				&int_names[idx * HISI_SAS_NAME_LEN],
+				hisi_hba);
+		if (rc) {
+			dev_err(dev,
+				"irq init: [%d] could not request fatal interrupt %d, rc=%d\n",
+				hisi_hba->id, irq, rc);
+			return -ENOENT;
+		}
+		idx++;
+	}
 
 	return 0;
 }
-- 
1.9.1

