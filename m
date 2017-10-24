From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/19] scsi: hisi_sas: complete all tasklets prior to host reset
Date: Tue, 24 Oct 2017 23:51:47 +0800
Message-ID: <1508860309-212397-18-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

The CQ event is handled in tasklet context, and it could
be delayed if the system loading is high.

It is possible to run into some problems when executing
a host reset when cq_tasklet_vx_hw() is being executed.

So, prior to host reset, execute tasklet_kill() to ensure
that all CQ tasklets are complete.

Besides, as the function hisi_sas_wait_tasklets_done()
is added to do tasklet_kill(), this patch refactors some
code where tasklet_kill() is used.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 ++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 ++-
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 00fefea..636cdf8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -435,4 +435,5 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct hisi_sas_slot *slot);
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
+extern void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1d417a4..4cbb999 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1548,6 +1548,17 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_phy_down);
 
+void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+
+		tasklet_kill(&cq->tasklet);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_kill_tasklets);
 
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8626d9f..433412a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3512,6 +3512,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 
 	interrupt_disable_v2_hw(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
+	hisi_sas_kill_tasklets(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -3595,16 +3596,11 @@ static int hisi_sas_v2_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
-	int i;
 
 	if (timer_pending(&hisi_hba->timer))
 		del_timer(&hisi_hba->timer);
 
-	for (i = 0; i < hisi_hba->queue_count; i++) {
-		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-
-		tasklet_kill(&cq->tasklet);
-	}
+	hisi_sas_kill_tasklets(hisi_hba);
 
 	return hisi_sas_remove(pdev);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 243fa1d..18cc3b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1768,6 +1768,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 
 	interrupt_disable_v3_hw(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
+	hisi_sas_kill_tasklets(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -1977,7 +1978,6 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
 		free_irq(pci_irq_vector(pdev, i+16), cq);
-		tasklet_kill(&cq->tasklet);
 	}
 	pci_free_irq_vectors(pdev);
 }
@@ -1993,6 +1993,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
+	hisi_sas_kill_tasklets(hisi_hba);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	hisi_sas_free(hisi_hba);
-- 
1.9.1
