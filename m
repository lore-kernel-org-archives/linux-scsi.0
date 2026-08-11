Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5225138DC66;
	Tue, 11 Aug 2026 02:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786414963; cv=none; b=taAoizyzW1pYaY9q2iZPp29zN1HyMhdUHkyCSePt5Huw8xyT14EQGjOCpzeA25cC/FOBWtIsM9zdZ27t1JT8RhFWHIIavYoh3HykuEja/3Bz0rXqSmF5+kgfCU+s/NF38pkU5t8IN4wUwOfIwHfjcd55wCUK4Nxp+xRiaNQ3eag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786414963; c=relaxed/simple;
	bh=b56cFAevsZhO6sRWfRQNK3OpQGsBzIBbfn15IkN+9Rs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U5HR1aeR5ZaXETwWOiF0haTWguN2F8TZsk9Jd5U0S/hZ2Jm+cI/zNEylfjpTlqo7X8NSWgBI21TwbVqIrbtCTnzIgzhCE0V/GsPwOJur4NMrrQUlIXrOIVSw9yCMIVJguRi/mAcQ7KDXNMRvmc/7xxy/hgtb0udAgro2xuPQSD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wAnES9Nh3pqk7iCAA--.0S3;
	Tue, 11 Aug 2026 10:22:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgAH7DRMh3pqAYIYAw--.10028S2;
	Tue, 11 Aug 2026 10:22:04 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: liyihang9@h-partners.com,
	linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: hisi_sas: free IRQs before hisi_hba on remove and probe error
Date: Tue, 11 Aug 2026 02:21:04 +0000
Message-Id: <20260811022104.136370-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgAH7DRMh3pqAYIYAw--.10028S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?SbmDJQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZwZJX6JbFrLuOi9nhhC3guamOsT5I6lRyw1M911JmiP9ViF
	Phg03gJCxELteYJG7wWp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW3Aw1rJF1fKr4kAw4xGryUArc_yoWDGF1rpF
	WkJayavr48GF42qw17uay3ZFn5t3W8ZryYgrWS934fAFn8J34vgr1UAFy2qFW5Jry8uF1U
	Xrs0qrW5Ga48JrbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

The v1/v2 platform backends and the v3 PCI backend register their
interrupts with devm_request_irq()/devm_request_threaded_irq(), using
hisi_hba (or &hisi_hba->phy[i] / &hisi_hba->cq[i]) as the cookie. devm
releases those IRQs after the probe/remove callback returns, during
devres teardown; the .remove path and the probe error paths reached once
IRQs are registered free the cookie before then. A handler that fires in
the window dereferences freed memory.

The v3 PCI .remove already avoided this with hisi_sas_v3_destroy_irqs();
the platform backends and the v3 probe error path did not. Record each
successfully requested IRQ in a small per-HBA ledger and release them in
reverse order from .remove and the probe error path, before
hisi_sas_free(). interrupt_init_v1_hw/v2_hw/v3_hw can fail partway and
leave earlier registrations armed, so the ledger frees only what was
requested; this also replaces hisi_sas_v3_destroy_irqs() with the common
helper.

This issue was found by an in-house static analysis tool.

Fixes: d37a00829193 ("scsi: hisi_sas: fix free'ing in probe and remove")
Fixes: 2ebde94f2ea4 ("scsi: hisi_sas: Fix up probe error handling for v3 hw")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 13 +++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 24 ++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 ++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 24 ++++++------------------
 5 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1323ed8..8a7e220 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -30,6 +30,14 @@
 
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
+
+/* Maximum number of devm-requested IRQs recorded per hisi_hba. */
+#define HISI_SAS_MAX_IRQS	(HISI_SAS_MAX_PHYS * 3 + HISI_SAS_MAX_QUEUES + 2)
+
+struct hisi_sas_irq_entry {
+	unsigned int irq;
+	void *dev_id;
+};
 #define HISI_SAS_QUEUE_SLOTS	4096
 #define HISI_SAS_MAX_ITCT_ENTRIES 1024
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
@@ -468,6 +476,8 @@ struct hisi_hba {
 	u32 intr_coal_count; /* Interrupt count to coalesce */
 
 	int cq_nvecs;
+	struct hisi_sas_irq_entry devm_irqs[HISI_SAS_MAX_IRQS];
+	int nr_irqs;
 
 	/* bist */
 	enum sas_linkrate debugfs_bist_linkrate;
@@ -680,6 +690,9 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
+void hisi_sas_track_irq(struct hisi_hba *hisi_hba, unsigned int irq,
+			void *dev_id);
+void hisi_sas_free_irqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no);
 extern bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
 				enum hisi_sas_phy_event event);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 30a9c66..fb32df1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2621,6 +2621,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 err_out_hw_init:
 	sas_unregister_ha(sha);
+	hisi_sas_free_irqs(hisi_hba);
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
@@ -2630,6 +2631,27 @@ err_out_ha:
 }
 EXPORT_SYMBOL_GPL(hisi_sas_probe);
 
+/* Record a successfully requested IRQ; freed by hisi_sas_free_irqs(). */
+void hisi_sas_track_irq(struct hisi_hba *hisi_hba, unsigned int irq, void *dev_id)
+{
+	if (WARN_ON_ONCE(hisi_hba->nr_irqs >= HISI_SAS_MAX_IRQS))
+		return;
+	hisi_hba->devm_irqs[hisi_hba->nr_irqs].irq = irq;
+	hisi_hba->devm_irqs[hisi_hba->nr_irqs].dev_id = dev_id;
+	hisi_hba->nr_irqs++;
+}
+
+/* Release recorded IRQs in reverse order, before hisi_hba is freed. */
+void hisi_sas_free_irqs(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = hisi_hba->nr_irqs - 1; i >= 0; i--)
+		devm_free_irq(hisi_hba->dev, hisi_hba->devm_irqs[i].irq,
+			      hisi_hba->devm_irqs[i].dev_id);
+	hisi_hba->nr_irqs = 0;
+}
+
 void hisi_sas_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
@@ -2641,6 +2663,8 @@ void hisi_sas_remove(struct platform_device *pdev)
 	sas_unregister_ha(sha);
 	sas_remove_host(shost);
 
+	hisi_sas_free_irqs(hisi_hba);
+
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa94d71..1cd769c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1643,6 +1643,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 					irq, rc);
 				return rc;
 			}
+			hisi_sas_track_irq(hisi_hba, irq, phy);
 		}
 	}
 
@@ -1659,6 +1660,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 				irq, rc);
 			return rc;
 		}
+		hisi_sas_track_irq(hisi_hba, irq, &hisi_hba->cq[i]);
 	}
 
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
@@ -1674,6 +1676,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 				irq, rc);
 			return rc;
 		}
+		hisi_sas_track_irq(hisi_hba, irq, hisi_hba);
 	}
 
 	hisi_hba->cq_nvecs = hisi_hba->queue_count;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0..57c388e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3343,6 +3343,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+		hisi_sas_track_irq(hisi_hba, irq, hisi_hba);
 	}
 
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
@@ -3357,6 +3358,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+		hisi_sas_track_irq(hisi_hba, irq, phy);
 	}
 
 	for (fatal_no = 0; fatal_no < HISI_SAS_FATAL_INT_NR; fatal_no++) {
@@ -3369,6 +3371,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+		hisi_sas_track_irq(hisi_hba, irq, hisi_hba);
 	}
 
 	for (queue_no = 0; queue_no < hisi_hba->cq_nvecs; queue_no++) {
@@ -3385,6 +3388,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+		hisi_sas_track_irq(hisi_hba, cq->irq_no, cq);
 		cq->irq_mask = irq_get_affinity_mask(cq->irq_no);
 	}
 err_out:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2f9e017..512ba17 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2635,6 +2635,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		dev_err(dev, "could not request phy interrupt, rc=%d\n", rc);
 		return -ENOENT;
 	}
+	hisi_sas_track_irq(hisi_hba, pci_irq_vector(pdev, IRQ_PHY_UP_DOWN_INDEX), hisi_hba);
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, IRQ_CHL_INDEX),
 			      int_chnl_int_v3_hw, 0,
@@ -2643,6 +2644,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		dev_err(dev, "could not request chnl interrupt, rc=%d\n", rc);
 		return -ENOENT;
 	}
+	hisi_sas_track_irq(hisi_hba, pci_irq_vector(pdev, IRQ_CHL_INDEX), hisi_hba);
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, IRQ_AXI_INDEX),
 			      fatal_axi_int_v3_hw, 0,
@@ -2651,6 +2653,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		dev_err(dev, "could not request fatal interrupt, rc=%d\n", rc);
 		return -ENOENT;
 	}
+	hisi_sas_track_irq(hisi_hba, pci_irq_vector(pdev, IRQ_AXI_INDEX), hisi_hba);
 
 	if (hisi_sas_intr_conv)
 		dev_info(dev, "Enable interrupt converge\n");
@@ -2673,6 +2676,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 				i, rc);
 			return -ENOENT;
 		}
+		hisi_sas_track_irq(hisi_hba, cq->irq_no, cq);
 		cq->irq_mask = pci_irq_get_affinity(pdev, i + BASE_VECTORS_V3_HW);
 		if (!cq->irq_mask) {
 			dev_err(dev, "could not get cq%d irq affinity!\n", i);
@@ -5058,6 +5062,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_out_unregister_ha:
 	sas_unregister_ha(sha);
+	hisi_sas_free_irqs(hisi_hba);
 err_out_remove_host:
 	scsi_remove_host(shost);
 err_out_free_host:
@@ -5067,23 +5072,6 @@ err_out:
 	return rc;
 }
 
-static void
-hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, IRQ_PHY_UP_DOWN_INDEX), hisi_hba);
-	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, IRQ_CHL_INDEX), hisi_hba);
-	devm_free_irq(&pdev->dev, pci_irq_vector(pdev, IRQ_AXI_INDEX), hisi_hba);
-	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
-		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-		int nr = hisi_sas_intr_conv ? BASE_VECTORS_V3_HW :
-					      BASE_VECTORS_V3_HW + i;
-
-		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
-	}
-}
-
 static void hisi_sas_v3_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -5099,7 +5087,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	flush_workqueue(hisi_hba->wq);
 	sas_remove_host(shost);
 
-	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
+	hisi_sas_free_irqs(hisi_hba);
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 }

