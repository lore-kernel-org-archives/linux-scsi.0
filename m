From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 08/32] scsi: hisi_sas: add hisi_sas_remove
Date: Mon, 16 Nov 2015 21:05:54 +0800
Message-ID: <1447679178-220222-9-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

This patch also includes relevant memory/pool
free'ing and sas/scsi host removal

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 71 ++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 97f5368..b96a2ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -126,6 +126,59 @@ err_out:
 	return -ENOMEM;
 }
 
+static void hisi_sas_free(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	int i, s;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
+		if (hisi_hba->cmd_hdr[i])
+			dma_free_coherent(dev, s,
+					  hisi_hba->cmd_hdr[i],
+					  hisi_hba->cmd_hdr_dma[i]);
+
+		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+		if (hisi_hba->complete_hdr[i])
+			dma_free_coherent(dev, s,
+					  hisi_hba->complete_hdr[i],
+					  hisi_hba->complete_hdr_dma[i]);
+	}
+
+	dma_pool_destroy(hisi_hba->status_buffer_pool);
+	dma_pool_destroy(hisi_hba->command_table_pool);
+	dma_pool_destroy(hisi_hba->sge_page_pool);
+
+	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
+	if (hisi_hba->itct)
+		dma_free_coherent(dev, s,
+				  hisi_hba->itct, hisi_hba->itct_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
+	if (hisi_hba->iost)
+		dma_free_coherent(dev, s,
+				  hisi_hba->iost, hisi_hba->iost_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
+	if (hisi_hba->breakpoint)
+		dma_free_coherent(dev, s,
+				  hisi_hba->breakpoint,
+				  hisi_hba->breakpoint_dma);
+
+
+	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
+	if (hisi_hba->initial_fis)
+		dma_free_coherent(dev, s,
+				  hisi_hba->initial_fis,
+				  hisi_hba->initial_fis_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
+	if (hisi_hba->sata_breakpoint)
+		dma_free_coherent(dev, s,
+				  hisi_hba->sata_breakpoint,
+				  hisi_hba->sata_breakpoint_dma);
+
+}
 
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
@@ -188,8 +241,10 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (IS_ERR(hisi_hba->ctrl))
 		goto err_out;
 
-	if (hisi_sas_alloc(hisi_hba, shost))
+	if (hisi_sas_alloc(hisi_hba, shost)) {
+		hisi_sas_free(hisi_hba);
 		goto err_out;
+	}
 
 	return shost;
 err_out:
@@ -270,6 +325,20 @@ err_out_ha:
 }
 EXPORT_SYMBOL_GPL(hisi_sas_probe);
 
+int hisi_sas_remove(struct platform_device *pdev)
+{
+	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	scsi_remove_host(sha->core.shost);
+	sas_unregister_ha(sha);
+	sas_remove_host(sha->core.shost);
+
+	hisi_sas_free(hisi_hba);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_remove);
+
 static __init int hisi_sas_init(void)
 {
 	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
-- 
1.9.1
