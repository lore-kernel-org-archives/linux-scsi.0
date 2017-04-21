From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 4/5] mvsas: remove the SAS host after the SCSI host
Date: Fri, 21 Apr 2017 10:04:49 +0200
Message-ID: <69fbe3f0c6a371c8c60bc59a4b38bc8f75d014fa.1492760075.git.jthumshirn@suse.de>
References: <cover.1492760075.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1492760075.git.jthumshirn@suse.de>
In-Reply-To: <cover.1492760075.git.jthumshirn@suse.de>
References: <cover.1492760075.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>, tj@kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
removal path of kernfs to make it recursive we have to remove the SAS host
before the SCSI host or we will see sysfs warnings on not found sysfs groups for
kobjects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mvsas/mv_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8280046fd1f0..4592a915c2b9 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -634,17 +634,19 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	unsigned short core_nr, i = 0;
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct mvs_info *mvi = NULL;
+	struct Scsi_Host *shost;
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
+	shost = mvi->shost;
 
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
-	scsi_remove_host(mvi->shost);
 	sas_unregister_ha(sha);
-	sas_remove_host(mvi->shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
 
 	MVS_CHIP_DISP->interrupt_disable(mvi);
 	free_irq(mvi->pdev->irq, sha);
-- 
2.12.0
