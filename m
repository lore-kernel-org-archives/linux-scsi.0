From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 4/6] scsi: hisi_sas: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 11:41:11 +0200
Message-ID: <20170329094122.9997-2-jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54083 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932114AbdC2Jla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 05:41:30 -0400
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
removal path of kernfs to make it recursive we have to remove the SAS host
before the SCSI host or we will see sysfs warnings on not found sysfs groups for
kobjects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 53637a9..34476c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1582,10 +1582,16 @@ int hisi_sas_remove(struct platform_device *pdev)
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = sha->core.shost;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_set_state(shost, SHOST_CANCEL))
+		WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	scsi_remove_host(sha->core.shost);
 	sas_unregister_ha(sha);
-	sas_remove_host(sha->core.shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
 
 	hisi_sas_free(hisi_hba);
 	kfree(shost);
-- 
1.8.5.6
