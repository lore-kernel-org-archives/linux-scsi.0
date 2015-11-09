From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 09/32] scsi: hisi_sas: add slot init code
Date: Tue, 10 Nov 2015 00:32:14 +0800
Message-ID: <1447086757-147706-10-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add functionality to init slot indexing.

Slot indexing is for the host to track which slots
(or tags) are free and which are used.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  4 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6d1b7d8..2cd6771 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -66,6 +66,10 @@ struct hisi_hba {
 
 	int n_phy;
 
+
+	int slot_index_count;
+	unsigned long *slot_index_tags;
+
 	/* SCSI/SAS glue */
 	struct sas_ha_struct sha;
 	struct Scsi_Host *shost;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7f81000..985f074 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -12,6 +12,21 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas"
 
+static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
+{
+	void *bitmap = hisi_hba->slot_index_tags;
+
+	clear_bit(slot_idx, bitmap);
+}
+
+static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->slot_index_count; ++i)
+		hisi_sas_slot_index_clear(hisi_hba, i);
+}
+
 static struct scsi_transport_template *hisi_sas_stt;
 
 static struct scsi_host_template hisi_sas_sht = {
@@ -102,6 +117,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	memset(hisi_hba->breakpoint, 0, s);
 
+	hisi_hba->slot_index_count = HISI_SAS_COMMAND_ENTRIES;
+	s = hisi_hba->slot_index_count / sizeof(unsigned long);
+	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
+	if (!hisi_hba->slot_index_tags)
+		goto err_out;
+
 	hisi_hba->sge_page_pool = dma_pool_create("status_sge", dev,
 				sizeof(struct hisi_sas_sge_page), 16, 0);
 	if (!hisi_hba->sge_page_pool)
@@ -121,6 +142,8 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		goto err_out;
 	memset(hisi_hba->sata_breakpoint, 0, s);
 
+	hisi_sas_slot_index_init(hisi_hba);
+
 	return 0;
 err_out:
 	return -ENOMEM;
-- 
1.9.1
