From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 2/5] aic94xx: remove the SAS host after the SCSI host
Date: Fri, 21 Apr 2017 10:04:47 +0200
Message-ID: <6662a9f80f6bc52dd0e28cf57d9612c3bef2fd4f.1492760075.git.jthumshirn@suse.de>
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
 drivers/scsi/aic94xx/aic94xx_init.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 662b2321d1b0..8b9c6b9ea67d 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -701,13 +701,14 @@ static int asd_register_sas_ha(struct asd_ha_struct *asd_ha)
 
 static int asd_unregister_sas_ha(struct asd_ha_struct *asd_ha)
 {
+	struct Scsi_Host *shost = asd_ha->sas_ha.core.shost;
 	int err;
 
-	scsi_remove_host(asd_ha->sas_ha.core.shost);
 	err = sas_unregister_ha(&asd_ha->sas_ha);
 
-	sas_remove_host(asd_ha->sas_ha.core.shost);
-	scsi_host_put(asd_ha->sas_ha.core.shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
+	scsi_host_put(shost);
 
 	kfree(asd_ha->sas_ha.sas_phy);
 	kfree(asd_ha->sas_ha.sas_port);
-- 
2.12.0
