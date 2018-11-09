From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/5] scsi: hisi_sas: Create separate host attributes per HBA
Date: Fri, 9 Nov 2018 22:06:32 +0800
Message-ID: <1541772396-161814-2-git-send-email-john.garry@huawei.com>
References: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541772396-161814-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently all the three HBA (v1/v2/v3 HW) share the same host attribute.

To support each HBA having separate attributes in future, create per-HBA
attributes.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 6 ------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 ++++++-
 5 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 0ddb53c..94a9e13 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -468,7 +468,6 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 extern int hisi_sas_slave_configure(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
-extern struct device_attribute *host_attrs[];
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
 extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b3f01d5..8633ff9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1994,12 +1994,6 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
-struct device_attribute *host_attrs[] = {
-	&dev_attr_phy_event_threshold,
-	NULL,
-};
-EXPORT_SYMBOL_GPL(host_attrs);
-
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index f0e457e..d24342b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1799,6 +1799,11 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+static struct device_attribute *host_attrs_v1_hw[] = {
+	&dev_attr_phy_event_threshold,
+	NULL
+};
+
 static struct scsi_host_template sht_v1_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -1817,7 +1822,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
-	.shost_attrs		= host_attrs,
+	.shost_attrs		= host_attrs_v1_hw,
 };
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cc36b64..e78a97e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3554,6 +3554,11 @@ static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 	dev_dbg(dev, "wait commands complete %dms\n", time);
 }
 
+struct device_attribute *host_attrs_v2_hw[] = {
+	&dev_attr_phy_event_threshold,
+	NULL
+};
+
 static struct scsi_host_template sht_v2_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -3572,7 +3577,7 @@ static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
-	.shost_attrs		= host_attrs,
+	.shost_attrs		= host_attrs_v2_hw,
 };
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bd4ce38..68a6ec2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2091,6 +2091,11 @@ static void wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
 	dev_dbg(dev, "wait commands complete %dms\n", time);
 }
 
+struct device_attribute *host_attrs_v3_hw[] = {
+	&dev_attr_phy_event_threshold,
+	NULL
+};
+
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -2109,7 +2114,7 @@ static void wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
-	.shost_attrs		= host_attrs,
+	.shost_attrs		= host_attrs_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 };
 
-- 
1.9.1
