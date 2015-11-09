From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 10/32] scsi: hisi_sas: add cq structure initialization
Date: Tue, 10 Nov 2015 00:32:15 +0800
Message-ID: <1447086757-147706-11-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Each completion queue has a structure. This is mainly for
passing to irq handler so we know which queue the irq occured
on.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2cd6771..315fe46 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -45,6 +45,11 @@ struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
 };
 
+struct hisi_sas_cq {
+	struct hisi_hba *hisi_hba;
+	int	id;
+};
+
 struct hisi_sas_slot {
 };
 
@@ -73,6 +78,8 @@ struct hisi_hba {
 	/* SCSI/SAS glue */
 	struct sas_ha_struct sha;
 	struct Scsi_Host *shost;
+
+	struct hisi_sas_cq cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 985f074..79d6530 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -58,6 +58,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct device *dev = &pdev->dev;
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+
+		/* Completion queue structure */
+		cq->id = i;
+		cq->hisi_hba = hisi_hba;
+
 		/* Delivery queue */
 		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
 		hisi_hba->cmd_hdr[i] = dma_alloc_coherent(dev, s,
-- 
1.9.1
