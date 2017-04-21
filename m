From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: sas: move scsi_remove_host call into sas_remove_host
Date: Fri, 21 Apr 2017 14:11:41 +0200
Message-ID: <20170421121141.20701-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Move scsi_remove_host call into sas_remove_host and remove it from SAS HBA
drivers, so we don't mess up the ordering. This solves an issue with double
deleting sysfs entries that was introduced by the change of sysfs behaviour
from commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: John Garry <john.garry@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c   | 1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
 drivers/scsi/isci/init.c              | 1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 1 -
 drivers/scsi/mvsas/mv_init.c          | 1 -
 drivers/scsi/pm8001/pm8001_init.c     | 1 -
 drivers/scsi/scsi_transport_sas.c     | 8 ++++++--
 7 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 662b2321d1b0..a14ba7a6b81e 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -703,7 +703,6 @@ static int asd_unregister_sas_ha(struct asd_ha_struct *asd_ha)
 {
 	int err;
 
-	scsi_remove_host(asd_ha->sas_ha.core.shost);
 	err = sas_unregister_ha(&asd_ha->sas_ha);
 
 	sas_remove_host(asd_ha->sas_ha.core.shost);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 53637a941b94..843bedae6c09 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1583,7 +1583,6 @@ int hisi_sas_remove(struct platform_device *pdev)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = sha->core.shost;
 
-	scsi_remove_host(sha->core.shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(sha->core.shost);
 
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0b5b5db0d0f8..45371179ab87 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -272,7 +272,6 @@ static void isci_unregister(struct isci_host *isci_host)
 		return;
 
 	shost = to_shost(isci_host);
-	scsi_remove_host(shost);
 	sas_unregister_ha(&isci_host->sas_ha);
 
 	sas_remove_host(shost);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 919ba2bb15f1..a5d872664257 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8283,7 +8283,6 @@ static void scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
-	scsi_remove_host(shost);
 	mpt3sas_base_detach(ioc);
 	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8280046fd1f0..4e047b5001a6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -642,7 +642,6 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
-	scsi_remove_host(mvi->shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 417368ccb686..034b2f7d1135 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1088,7 +1088,6 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	struct pm8001_hba_info *pm8001_ha;
 	int i, j;
 	pm8001_ha = sha->lldd_ha;
-	scsi_remove_host(pm8001_ha->shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index cdbb293aca08..ca0e5a9a17f8 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -370,12 +370,16 @@ EXPORT_SYMBOL(sas_remove_children);
  * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
  * @shost:	Scsi Host that is torn down
  *
- * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
- * Must be called just before scsi_remove_host for SAS HBAs.
+ * Removes all SAS PHYs and remote PHYs for a given Scsi_Host and remove the
+ * Scsi_Host as well.
+ *
+ * Note: Do not call scsi_remove_host() on the Scsi_Host any more, as it is
+ * already removed.
  */
 void sas_remove_host(struct Scsi_Host *shost)
 {
 	sas_remove_children(&shost->shost_gendev);
+	scsi_remove_host(shost);
 }
 EXPORT_SYMBOL(sas_remove_host);
 
-- 
2.12.0
