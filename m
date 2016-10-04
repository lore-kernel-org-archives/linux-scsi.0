From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/3] hisi_sas: add v2 hw support for different refclk
Date: Tue, 4 Oct 2016 19:11:11 +0800
Message-ID: <1475579471-11308-4-git-send-email-john.garry@huawei.com>
References: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, hare@suse.com, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

The hip06 D03 and hip07 D05 boards have different
reference clock frequencies for the SAS controller.

Register PHY_CTRL needs to be programmed differently
according to this frequency, so add support for this.

The default register setting in PHY_CTRL is for 50MHz,
so only update this register when the refclk frequency
is 66MHz.

For ACPI we expect the _RST handler to set the correct
value for PHY_CTRL (we're forced to take different
approach for DT and ACPI as ACPI does not support
fixed-clock device).

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 72c9852..64046c5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -13,6 +13,7 @@
 #define _HISI_SAS_H_
 
 #include <linux/acpi.h>
+#include <linux/clk.h>
 #include <linux/dmapool.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
@@ -183,6 +184,7 @@ struct hisi_hba {
 	u32 ctrl_reset_reg;
 	u32 ctrl_reset_sts_reg;
 	u32 ctrl_clock_ena_reg;
+	u32 refclk_frequency_mhz;
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	int n_phy;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2f872f7..9afc697 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1396,6 +1396,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
 	struct device_node *np = pdev->dev.of_node;
+	struct clk *refclk;
 
 	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
 	if (!shost)
@@ -1432,6 +1433,12 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 			goto err_out;
 	}
 
+	refclk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(refclk))
+		dev_info(dev, "no ref clk property\n");
+	else
+		hisi_hba->refclk_frequency_mhz = clk_get_rate(refclk) / 1000000;
+
 	if (device_property_read_u32(dev, "phy-count", &hisi_hba->n_phy))
 		goto err_out;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 758e06f..0763b47 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -836,7 +836,9 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, SL_RX_BCAST_CHK_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT_COAL_EN, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x0);
-		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, 0x199B694);
+		if (hisi_hba->refclk_frequency_mhz == 66)
+			hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL, 0x199B694);
+		/* else, do nothing -> leave it how you found it */
 	}
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
-- 
1.9.1
