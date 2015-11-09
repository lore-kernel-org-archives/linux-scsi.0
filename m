From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 13/32] scsi: hisi_sas: add hisi_hba workqueue
Date: Tue, 10 Nov 2015 00:32:18 +0800
Message-ID: <1447086757-147706-14-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
index f78c2a9..53e1819 100644
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
