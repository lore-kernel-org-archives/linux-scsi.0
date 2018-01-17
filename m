From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] scsi: hisi_sas: directly attached disk LED feature for v2 hw
Date: Thu, 18 Jan 2018 00:46:53 +0800
Message-ID: <1516207614-159721-3-git-send-email-john.garry@huawei.com>
References: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

This patch implements LED feature of directly attached
disk for v2 hw.
As libsas has provided an interface lldd_write_gpio()
for this feature, we just need realise the interface
following SPGIO API.

We use an CPLD to finish the hardware part of this
feature, and the base address of CPLD should be
configured through ACPI or DT tables.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 20 +++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 39 ++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4000de4..e7fd287 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -244,6 +244,8 @@ struct hisi_sas_hw {
 				struct domain_device *device);
 	int (*soft_reset)(struct hisi_hba *hisi_hba);
 	u32 (*get_phys_state)(struct hisi_hba *hisi_hba);
+	int (*write_gpio)(struct hisi_hba *hisi_hba, u8 reg_type,
+				u8 reg_index, u8 reg_count, u8 *write_data);
 	int max_command_entries;
 	int complete_hdr_size;
 };
@@ -257,6 +259,7 @@ struct hisi_hba {
 	struct device *dev;
 
 	void __iomem *regs;
+	void __iomem *sgpio_regs;
 	struct regmap *ctrl;
 	u32 ctrl_reset_reg;
 	u32 ctrl_reset_sts_reg;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e3e7285..791462d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1634,6 +1634,18 @@ static void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
 {
 }
 
+static int hisi_sas_write_gpio(struct sas_ha_struct *sha, u8 reg_type,
+			u8 reg_index, u8 reg_count, u8 *write_data)
+{
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	if (!hisi_hba->hw->write_gpio)
+		return -EOPNOTSUPP;
+
+	return hisi_hba->hw->write_gpio(hisi_hba, reg_type,
+				reg_index, reg_count, write_data);
+}
+
 static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	phy->phy_attached = 0;
@@ -1731,6 +1743,7 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 	.lldd_clear_nexus_ha = hisi_sas_clear_nexus_ha,
 	.lldd_port_formed	= hisi_sas_port_formed,
 	.lldd_port_deformed = hisi_sas_port_deformed,
+	.lldd_write_gpio = hisi_sas_write_gpio,
 };
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
@@ -2055,6 +2068,13 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (IS_ERR(hisi_hba->regs))
 		goto err_out;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res) {
+		hisi_hba->sgpio_regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(hisi_hba->sgpio_regs))
+			goto err_out;
+	}
+
 	if (hisi_sas_alloc(hisi_hba, shost)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ebee2e4..4ccb61e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3474,6 +3474,44 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+static int write_gpio_v2_hw(struct hisi_hba *hisi_hba, u8 reg_type,
+			u8 reg_index, u8 reg_count, u8 *write_data)
+{
+	struct device *dev = hisi_hba->dev;
+	int phy_no, count;
+
+	if (!hisi_hba->sgpio_regs)
+		return -EOPNOTSUPP;
+
+	switch (reg_type) {
+	case SAS_GPIO_REG_TX:
+		count = reg_count * 4;
+		count = min(count, hisi_hba->n_phy);
+
+		for (phy_no = 0; phy_no < count; phy_no++) {
+			/*
+			 * GPIO_TX[n] register has the highest numbered drive
+			 * of the four in the first byte and the lowest
+			 * numbered drive in the fourth byte.
+			 * See SFF-8485 Rev. 0.7 Table 24.
+			 */
+			void __iomem  *reg_addr = hisi_hba->sgpio_regs +
+					reg_index * 4 + phy_no;
+			int data_idx = phy_no + 3 - (phy_no % 4) * 2;
+
+			writeb(write_data[data_idx], reg_addr);
+		}
+
+		break;
+	default:
+		dev_err(dev, "write gpio: unsupported or bad reg type %d\n",
+				reg_type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.setup_itct = setup_itct_v2_hw,
@@ -3501,6 +3539,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 	.soft_reset = soft_reset_v2_hw,
 	.get_phys_state = get_phys_state_v2_hw,
+	.write_gpio = write_gpio_v2_hw,
 };
 
 static int hisi_sas_v2_probe(struct platform_device *pdev)
-- 
1.9.1
