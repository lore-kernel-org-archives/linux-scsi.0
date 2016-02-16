From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Tue, 16 Feb 2016 20:22:30 +0800
Message-ID: <1455625351-165881-6-git-send-email-john.garry@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In high-datarate aging tests, it is found that
the SCSI framework can periodically
issue lu resets to the device. This is because scsi
commands begin to timeout. It is found that TASK SET
FULL may be returned many times for the same command,
causing the timeouts.
To overcome this, the queue depth for the device needs
to be reduced to 64 (from 256, set in
sas_slave_configure()).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 65509eb..dde7c5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -454,6 +454,19 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	return 0;
 }
 
+static int hisi_sas_slave_configure(struct scsi_device *sdev)
+{
+	struct domain_device *dev = sdev_to_domain_dev(sdev);
+	int ret = sas_slave_configure(sdev);
+
+	if (ret)
+		return ret;
+	if (!dev_is_sata(dev))
+		sas_change_queue_depth(sdev, 64);
+
+	return 0;
+}
+
 static void hisi_sas_scan_start(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
@@ -997,7 +1010,7 @@ static struct scsi_host_template hisi_sas_sht = {
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= sas_slave_configure,
+	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-- 
1.9.1
