From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/25] scsi: hisi_sas: add cq structure initialization
Date: Mon, 12 Oct 2015 23:20:20 +0800
Message-ID: <1444663237-238302-9-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:13446 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbbJLPK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:10:58 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Each completion queue has a structure. This is mainly for
passing to irq handler so we know which queue the irq occured
on.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_init.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5f72d98..6c5d22a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -44,6 +44,10 @@ struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
 };
 
+struct hisi_sas_cq {
+	struct hisi_hba *hisi_hba;
+	int	id;
+};
 
 struct hisi_sas_slot {
 	struct list_head entry;
@@ -92,6 +96,8 @@ struct hisi_hba {
 	/* SCSI/SAS glue */
 	struct sas_ha_struct sha;
 	struct Scsi_Host *shost;
+
+	struct hisi_sas_cq cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 	int	id;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 8f1e856..44fc524 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -42,6 +42,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct device *dev = &hisi_hba->pdev->dev;
 
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

