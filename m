From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 5/6] mvsas: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 11:41:12 +0200
Message-ID: <20170329094122.9997-3-jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
removal path of kernfs to make it recursive we have to remove the SAS host
before the SCSI host or we will see sysfs warnings on not found sysfs groups for
kobjects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mvsas/mv_init.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8280046..32b86c8 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -634,17 +634,26 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	unsigned short core_nr, i = 0;
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct mvs_info *mvi = NULL;
+	struct Scsi_Host *shost;
+	unsigned long flags;
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
+	shost = mvi->shost;
 
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
-	scsi_remove_host(mvi->shost);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_set_state(shost, SHOST_CANCEL))
+		WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+
 	sas_unregister_ha(sha);
-	sas_remove_host(mvi->shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
 
 	MVS_CHIP_DISP->interrupt_disable(mvi);
 	free_irq(mvi->pdev->irq, sha);
-- 
1.8.5.6
