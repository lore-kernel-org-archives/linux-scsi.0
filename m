From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] mvsas: don't allow negative timeouts
Date: Fri, 13 Nov 2015 17:23:23 +0300
Message-ID: <20151113142323.GB1445@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a static checker warning here because "val" is controlled by
the user and we have a upper bound on it but allow negative numbers.
"val" appears to be a timeout in usec so this bug probably means we
have a longer timeout than we should.  Let's fix this by changing "val"
to unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Checkpatch has several complaints about this code but I left it as-is.

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 90fdf0e..675e7fa 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -758,7 +758,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr,
 			const char *buffer, size_t size)
 {
-	int val = 0;
+	unsigned int val = 0;
 	struct mvs_info *mvi = NULL;
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
@@ -766,7 +766,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 	if (buffer == NULL)
 		return size;
 
-	if (sscanf(buffer, "%d", &val) != 1)
+	if (sscanf(buffer, "%u", &val) != 1)
 		return -EINVAL;
 
 	if (val >= 0x10000) {
