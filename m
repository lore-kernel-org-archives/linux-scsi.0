From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/6] aic94xx: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 11:41:10 +0200
Message-ID: <20170329094122.9997-1-jthumshirn@suse.de>
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
 drivers/scsi/aic94xx/aic94xx_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 662b232..362d65a 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -701,13 +701,20 @@ static int asd_register_sas_ha(struct asd_ha_struct *asd_ha)
 
 static int asd_unregister_sas_ha(struct asd_ha_struct *asd_ha)
 {
+	struct Scsi_Host *shost = asd_ha->sas_ha.core.shost;
+	unsigned long flags;
 	int err;
 
-	scsi_remove_host(asd_ha->sas_ha.core.shost);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_set_state(shost, SHOST_CANCEL))
+		WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	err = sas_unregister_ha(&asd_ha->sas_ha);
 
-	sas_remove_host(asd_ha->sas_ha.core.shost);
-	scsi_host_put(asd_ha->sas_ha.core.shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
+	scsi_host_put(shost);
 
 	kfree(asd_ha->sas_ha.sas_phy);
 	kfree(asd_ha->sas_ha.sas_port);
-- 
1.8.5.6
