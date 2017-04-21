From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 3/5] scsi: hisi_sas: remove the SAS host after the SCSI host
Date: Fri, 21 Apr 2017 10:04:48 +0200
Message-ID: <0b94e2ae5bc364d8bd369bdd4db705504d0a0d73.1492760075.git.jthumshirn@suse.de>
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
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 53637a941b94..9ae39226d454 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1583,9 +1583,9 @@ int hisi_sas_remove(struct platform_device *pdev)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = sha->core.shost;
 
-	scsi_remove_host(sha->core.shost);
 	sas_unregister_ha(sha);
-	sas_remove_host(sha->core.shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
 
 	hisi_sas_free(hisi_hba);
 	kfree(shost);
-- 
2.12.0
