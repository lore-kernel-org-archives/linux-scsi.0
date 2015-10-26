From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 14/32] scsi: hisi_sas: add hisi sas device type
Date: Mon, 26 Oct 2015 22:14:45 +0800
Message-ID: <1445868903-183817-15-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Include initialisation.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 12 ++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 424d693..f2757cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -38,6 +38,11 @@
 #define HISI_SAS_NAME_LEN 32
 #define HISI_SAS_CTRL_REG_CNT 5
 
+
+enum dev_status {
+	HISI_SAS_DEV_NORMAL,
+	HISI_SAS_DEV_EH,
+};
 struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 	u64		dev_sas_addr;
@@ -52,6 +57,12 @@ struct hisi_sas_cq {
 	int	id;
 };
 
+struct hisi_sas_device {
+	enum sas_device_type	dev_type;
+	u64 device_id;
+	u8 dev_status;
+};
+
 struct hisi_sas_slot {
 };
 
@@ -89,6 +100,7 @@ struct hisi_hba {
 	char	*int_names;
 
 	struct dma_pool *sge_page_pool;
+	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
 	struct dma_pool *command_table_pool;
 	struct dma_pool *status_buffer_pool;
 	struct hisi_sas_cmd_hdr	*cmd_hdr[HISI_SAS_MAX_QUEUES];
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fb83233..57fd9e0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -58,6 +58,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct device *dev = &pdev->dev;
 
 
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
+		hisi_hba->devices[i].dev_type = SAS_PHY_UNUSED;
+		hisi_hba->devices[i].device_id = i;
+		hisi_hba->devices[i].dev_status = HISI_SAS_DEV_NORMAL;
+	}
+
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
-- 
1.9.1
