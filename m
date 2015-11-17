From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 14/32] scsi: hisi_sas: add hisi sas device type
Date: Wed, 18 Nov 2015 00:50:41 +0800
Message-ID: <1447779059-136143-15-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Include initialisation.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 12 ++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 62bc6f3..5ac5a82 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -37,6 +37,11 @@
 
 #define HISI_SAS_NAME_LEN 32
 
+
+enum dev_status {
+	HISI_SAS_DEV_NORMAL,
+	HISI_SAS_DEV_EH,
+};
 struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 	u64		dev_sas_addr;
@@ -51,6 +56,12 @@ struct hisi_sas_cq {
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
index 7f32c6b..21111d4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -57,6 +57,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct platform_device *pdev = hisi_hba->pdev;
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
