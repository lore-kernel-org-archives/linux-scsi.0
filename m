From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/7] scsi: hisi_sas: modify some values of ITCT table
Date: Thu, 19 Jan 2017 00:32:48 +0800
Message-ID: <1484757173-235951-3-git-send-email-john.garry@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Set SMP connection timeout and continue AWT timer;
Clear ITCT table when dev gone.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 6c787eb..452e329 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -334,6 +334,8 @@
 #define ITCT_HDR_MCR_MSK		(0xf << ITCT_HDR_MCR_OFF)
 #define ITCT_HDR_VLN_OFF		9
 #define ITCT_HDR_VLN_MSK		(0xf << ITCT_HDR_VLN_OFF)
+#define ITCT_HDR_SMP_TIMEOUT_OFF	16
+#define ITCT_HDR_AWT_CONTINUE_OFF	25
 #define ITCT_HDR_PORT_ID_OFF		28
 #define ITCT_HDR_PORT_ID_MSK		(0xf << ITCT_HDR_PORT_ID_OFF)
 /* qw2 */
@@ -696,6 +698,8 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
 		(device->linkrate << ITCT_HDR_MCR_OFF) |
 		(1 << ITCT_HDR_VLN_OFF) |
+		(0xfa << ITCT_HDR_SMP_TIMEOUT_OFF) |
+		(1 << ITCT_HDR_AWT_CONTINUE_OFF) |
 		(port->id << ITCT_HDR_PORT_ID_OFF));
 	itct->qw0 = cpu_to_le64(qw0);
 
@@ -705,7 +709,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 
 	/* qw2 */
 	if (!dev_is_sata(device))
-		itct->qw2 = cpu_to_le64((500ULL << ITCT_HDR_INLT_OFF) |
+		itct->qw2 = cpu_to_le64((5000ULL << ITCT_HDR_INLT_OFF) |
 					(0x1ULL << ITCT_HDR_BITLT_OFF) |
 					(0x32ULL << ITCT_HDR_MCTLT_OFF) |
 					(0x1ULL << ITCT_HDR_RTOLT_OFF));
@@ -714,7 +718,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
-	u64 qw0, dev_id = sas_dev->device_id;
+	u64 dev_id = sas_dev->device_id;
 	struct device *dev = &hisi_hba->pdev->dev;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
 	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
@@ -738,8 +742,7 @@ static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 			dev_dbg(dev, "got clear ITCT done interrupt\n");
 
 			/* invalid the itct state*/
-			qw0 = cpu_to_le64(itct->qw0);
-			qw0 &= ~(1 << ITCT_HDR_VALID_OFF);
+			memset(itct, 0, sizeof(struct hisi_sas_itct));
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					 ENT_INT_SRC3_ITC_INT_MSK);
 
-- 
1.9.1
