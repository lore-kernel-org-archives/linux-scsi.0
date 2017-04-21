From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 5/5] scsi: pm8001: remove the SAS host after the SCSI host
Date: Fri, 21 Apr 2017 10:04:50 +0200
Message-ID: <99ded108ba92054564a83594d3d65deb47ea8631.1492760075.git.jthumshirn@suse.de>
References: <cover.1492760075.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1036400AbdDUIFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 04:05:09 -0400
In-Reply-To: <cover.1492760075.git.jthumshirn@suse.de>
In-Reply-To: <cover.1492760075.git.jthumshirn@suse.de>
References: <cover.1492760075.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>, tj@kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
removal path of kernfs to make it recursive we have to remove the SAS host
before the SCSI host or we will see sysfs warnings on not found sysfs groups for
kobjects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 417368ccb686..e8f3d5ada201 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1086,11 +1086,15 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
+	struct Scsi_Host *shost;
 	int i, j;
 	pm8001_ha = sha->lldd_ha;
-	scsi_remove_host(pm8001_ha->shost);
+	shost = pm8001_ha->shost;
+
 	sas_unregister_ha(sha);
-	sas_remove_host(pm8001_ha->shost);
+	sas_remove_host(shost);
+	scsi_remove_host(shost);
+
 	list_del(&pm8001_ha->list);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
-- 
2.12.0
