From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/5] target: pscsi: Introduce TYPE_ZBC support
Date: Wed, 28 Jun 2017 14:58:57 +0900
Message-ID: <20170628055900.22889-3-damien.lemoal@wdc.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39551 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbdF1F7j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 01:59:39 -0400
In-Reply-To: <20170628055900.22889-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

TYPE_ZBC host managed zoned block devices are also block devices
despite the non-standard device type (14h). Handle them similarly to
regular TYPE_DISK devices.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_pscsi.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3e4abb1..97d0318 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -384,7 +384,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	spin_unlock_irq(sh->host_lock);
 	/*
 	 * Claim exclusive struct block_device access to struct scsi_device
-	 * for TYPE_DISK using supplied udev_path
+	 * for TYPE_DISK and TYPE_ZBC using supplied udev_path
 	 */
 	bd = blkdev_get_by_path(dev->udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
@@ -402,8 +402,9 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 		return ret;
 	}
 
-	pr_debug("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d:%llu\n",
-		phv->phv_host_id, sh->host_no, sd->channel, sd->id, sd->lun);
+	pr_debug("CORE_PSCSI[%d] - Added TYPE_%s for %d:%d:%d:%llu\n",
+		phv->phv_host_id, sd->type == TYPE_DISK ? "DISK" : "ZBC",
+		sh->host_no, sd->channel, sd->id, sd->lun);
 	return 0;
 }
 
@@ -522,6 +523,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		 */
 		switch (sd->type) {
 		case TYPE_DISK:
+		case TYPE_ZBC:
 			ret = pscsi_create_type_disk(dev, sd);
 			break;
 		default:
@@ -573,9 +575,11 @@ static void pscsi_free_device(struct se_device *dev)
 	if (sd) {
 		/*
 		 * Release exclusive pSCSI internal struct block_device claim for
-		 * struct scsi_device with TYPE_DISK from pscsi_create_type_disk()
+		 * struct scsi_device with TYPE_DISK or TYPE_ZBC
+		 * from pscsi_create_type_disk()
 		 */
-		if ((sd->type == TYPE_DISK) && pdv->pdv_bd) {
+		if ((sd->type == TYPE_DISK || sd->type == TYPE_ZBC) &&
+		    pdv->pdv_bd) {
 			blkdev_put(pdv->pdv_bd,
 				   FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 			pdv->pdv_bd = NULL;
@@ -1004,7 +1008,8 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	req->end_io_data = cmd;
 	scsi_req(req)->cmd_len = scsi_command_size(pt->pscsi_cdb);
 	scsi_req(req)->cmd = &pt->pscsi_cdb[0];
-	if (pdv->pdv_sd->type == TYPE_DISK)
+	if (pdv->pdv_sd->type == TYPE_DISK ||
+	    pdv->pdv_sd->type == TYPE_ZBC)
 		req->timeout = PS_TIMEOUT_DISK;
 	else
 		req->timeout = PS_TIMEOUT_OTHER;
-- 
2.9.4
