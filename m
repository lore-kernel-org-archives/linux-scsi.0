From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 10/32] scsi: hisi_sas: add cq structure initialization
Date: Mon, 26 Oct 2015 22:14:41 +0800
Message-ID: <1445868903-183817-11-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:6715 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbbJZOBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 10:01:49 -0400
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Each completion queue has a structure. This is mainly for
passing to irq handler so we know which queue the irq occured
on.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index b6889f4..817fcb1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -46,6 +46,11 @@ struct hisi_sas_port {
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
index 073993e..7e0669a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -59,6 +59,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 
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

