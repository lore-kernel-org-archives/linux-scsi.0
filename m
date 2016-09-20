From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] hisi_sas: add device tree support for hip07
Date: Tue, 20 Sep 2016 18:48:59 +0800
Message-ID: <1474368540-186535-3-git-send-email-john.garry@huawei.com>
References: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, devicetree@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Chipset hip07 incorporates v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9825a3f..c1e3aa7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -777,7 +777,8 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 	/* Global registers init */
 
 	/* Deal with am-max-transmissions quirk */
-	if (device_property_present(dev, "hip06-sas-v2-quirk-amt")) {
+	if (device_property_present(dev, "hip06-sas-v2-quirk-amt") ||
+	    device_property_present(dev, "hip07-sas-v2-quirk-amt")) {
 		hisi_sas_write32(hisi_hba, AM_CFG_MAX_TRANS, 0x2020);
 		hisi_sas_write32(hisi_hba, AM_CFG_SINGLE_PORT_MAX_TRANS,
 				 0x2020);
@@ -2319,6 +2320,7 @@ static int hisi_sas_v2_remove(struct platform_device *pdev)
 
 static const struct of_device_id sas_v2_of_match[] = {
 	{ .compatible = "hisilicon,hip06-sas-v2",},
+	{ .compatible = "hisilicon,hip07-sas-v2",},
 	{},
 };
 MODULE_DEVICE_TABLE(of, sas_v2_of_match);
-- 
1.9.1
