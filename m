From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/5] scsi: isci: remove the SAS host after the SCSI host
Date: Fri, 21 Apr 2017 10:04:46 +0200
Message-ID: <1e28d39c4d45acbbc0d0def44990875f05968fd6.1492760075.git.jthumshirn@suse.de>
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
before the SCSI host or we will see sysfs warnings on not found sysfs groups
for kobjects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/isci/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0b5b5db0d0f8..e5824758aece 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -272,10 +272,11 @@ static void isci_unregister(struct isci_host *isci_host)
 		return;
 
 	shost = to_shost(isci_host);
-	scsi_remove_host(shost);
+
 	sas_unregister_ha(&isci_host->sas_ha);
 
 	sas_remove_host(shost);
+	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
-- 
2.12.0
