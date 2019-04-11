From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/9] scsi: hisi_sas: add host reset interface for test
Date: Thu, 11 Apr 2019 20:46:36 +0800
Message-ID: <1554986804-233706-2-git-send-email-john.garry@huawei.com>
References: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add host reset interface to make it easier for testing the host
reset feature.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 13 +++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  1 +
 4 files changed, 16 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 14bac4966c87..a1eaddcf740d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2234,6 +2234,19 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_kill_tasklets);
 
+int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+
+	if (reset_type != SCSI_ADAPTER_RESET)
+		return -EOPNOTSUPP;
+
+	queue_work(hisi_hba->wq, &hisi_hba->rst_work);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_host_reset);
+
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 293807443480..078ddd3871f2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1823,6 +1823,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v1_hw,
+	.host_reset             = hisi_sas_host_reset,
 };
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 89160ab3efb0..33b72c7f72c5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3599,6 +3599,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v2_hw,
+	.host_reset		= hisi_sas_host_reset,
 };
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 086695a4099f..e8323d038d53 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2678,6 +2678,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.host_reset             = hisi_sas_host_reset,
 };
 
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
-- 
2.17.1
