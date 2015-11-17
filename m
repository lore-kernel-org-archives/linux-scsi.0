From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 13/32] scsi: hisi_sas: add hisi_hba workqueue
Date: Wed, 18 Nov 2015 00:50:40 +0800
Message-ID: <1447779059-136143-14-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index c50384f..62bc6f3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -72,6 +72,7 @@ struct hisi_hba {
 
 	int n_phy;
 
+	struct workqueue_struct *wq;
 
 	int slot_index_count;
 	unsigned long *slot_index_tags;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d7d9516..7f32c6b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -150,6 +150,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	hisi_sas_slot_index_init(hisi_hba);
 
+	hisi_hba->wq = create_singlethread_workqueue(dev_name(dev));
+	if (!hisi_hba->wq) {
+		dev_err(dev, "sas_alloc: failed to create workqueue\n");
+		goto err_out;
+	}
+
 	return 0;
 err_out:
 	return -ENOMEM;
@@ -207,6 +213,8 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 				  hisi_hba->sata_breakpoint,
 				  hisi_hba->sata_breakpoint_dma);
 
+	if (hisi_hba->wq)
+		destroy_workqueue(hisi_hba->wq);
 }
 
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
-- 
1.9.1
