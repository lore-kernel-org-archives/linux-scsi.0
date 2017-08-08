From: Pan Bian <bianpan2016@163.com>
Subject: scsi: pm8001: fix double free in pm8001_pci_probe
Date: Tue,  8 Aug 2017 19:40:30 +0800
Message-ID: <1502192430-12440-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

In function pm8001_pci_probe(), on errors that the control flow jumps to
label err_out_ha_free, function pm8001_free() is called. In pm8001_free(),
scsi_host_put() is called to release shost, which keeps the return value
of scsi_host_alloc(). After pm8001_free() returns, kfree() is called to
free shost again, resulting in a double free bug. This patch removes
scsi_host_put() from pm8001_free() and explicitly calls scsi_host_put()
to release Scsi_Host in need.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 034b2f7..2908881 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -160,8 +160,6 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 			}
 	}
 	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
-	if (pm8001_ha->shost)
-		scsi_host_put(pm8001_ha->shost);
 	flush_workqueue(pm8001_wq);
 	kfree(pm8001_ha->tags);
 	kfree(pm8001_ha);
@@ -1073,7 +1071,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 err_out_free:
 	kfree(SHOST_TO_SAS_HA(shost));
 err_out_free_host:
-	kfree(shost);
+	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
 err_out_disable:
@@ -1112,6 +1110,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
+	scsi_host_put(pm8001_ha->shost);
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
-- 
1.9.1
