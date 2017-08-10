From: John Garry <john.garry@huawei.com>
Subject: [PATCH 18/19] scsi: hisi_sas: replace kfree with scsi_host_put
Date: Fri, 11 Aug 2017 00:09:43 +0800
Message-ID: <1502381384-219889-19-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Instances of kfree(shost) should be replaced with
scsi_host_put().

In addition, a missing scsi_host_put() is added for
error path in hisi_sas_shost_alloc_pci() and v3 driver
removal.

Signed-off-by: Pan Bian <bianpan2016@163.com> # For main.c changes
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  6 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 13 +++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4112afd..9427835 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1900,7 +1900,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 
 	return shost;
 err_out:
-	kfree(shost);
+	scsi_host_put(shost);
 	dev_err(dev, "shost alloc failed\n");
 	return NULL;
 }
@@ -1991,7 +1991,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 	scsi_remove_host(shost);
 err_out_ha:
 	hisi_sas_free(hisi_hba);
-	kfree(shost);
+	scsi_host_put(shost);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(hisi_sas_probe);
@@ -2006,7 +2006,7 @@ int hisi_sas_remove(struct platform_device *pdev)
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_free(hisi_hba);
-	kfree(shost);
+	scsi_host_put(shost);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_sas_remove);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3620a3e..a20e354 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1811,8 +1811,10 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	struct device *dev = &pdev->dev;
 
 	shost = scsi_host_alloc(hisi_sas_sht, sizeof(*hisi_hba));
-	if (!shost)
-		goto err_out;
+	if (!shost) {
+		dev_err(dev, "shost alloc failed\n");
+		return NULL;
+	}
 	hisi_hba = shost_priv(shost);
 
 	hisi_hba->hw = &hisi_sas_v3_hw;
@@ -1833,6 +1835,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 
 	return shost;
 err_out:
+	scsi_host_put(shost);
 	dev_err(dev, "shost alloc failed\n");
 	return NULL;
 }
@@ -1941,7 +1944,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
-	kfree(shost);
+	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
 err_out_disable_device:
@@ -1971,14 +1974,16 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	struct device *dev = &pdev->dev;
 	struct sas_ha_struct *sha = dev_get_drvdata(dev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = sha->core.shost;
 
 	sas_unregister_ha(sha);
 	sas_remove_host(sha->core.shost);
 
-	hisi_sas_free(hisi_hba);
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	hisi_sas_free(hisi_hba);
+	scsi_host_put(shost);
 }
 
 enum {
-- 
1.9.1
