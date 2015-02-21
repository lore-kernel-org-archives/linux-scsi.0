From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 14/43] hpsa: use ioaccel2 path to submit IOs to physical
 drives in HBA mode.
Date: Sat, 21 Feb 2015 16:18:47 -0600
Message-ID: <20150221221847.21954.32444.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1573 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbbBUWUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:05 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Joe Handzik <joseph.t.handzik@hp.com>

use ioaccel2 path to submit I/O to physical drives in HBA mode

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 +++++++++-
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e151662..0b3499c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1093,6 +1093,11 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 		h->dev[entry]->raid_map = new_entry->raid_map;
 		h->dev[entry]->ioaccel_handle = new_entry->ioaccel_handle;
 	}
+	if (new_entry->hba_ioaccel_enabled) {
+		h->dev[entry]->ioaccel_handle = new_entry->ioaccel_handle;
+		wmb(); /* set ioaccel_handle *before* hba_ioaccel_enabled */
+	}
+	h->dev[entry]->hba_ioaccel_enabled = new_entry->hba_ioaccel_enabled;
 	h->dev[entry]->offload_config = new_entry->offload_config;
 	h->dev[entry]->offload_to_mirror = new_entry->offload_to_mirror;
 	h->dev[entry]->queue_depth = new_entry->queue_depth;
@@ -3055,6 +3060,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		this_device->offload_config = 0;
 		this_device->offload_enabled = 0;
 		this_device->offload_to_be_enabled = 0;
+		this_device->hba_ioaccel_enabled = 0;
 		this_device->volume_offline = 0;
 		this_device->queue_depth = h->nr_cmds;
 	}
@@ -3343,6 +3349,8 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 		(struct ext_report_lun_entry *) lunaddrbytes;
 
 	dev->ioaccel_handle = rle->ioaccel_handle;
+	if (PHYS_IOACCEL(lunaddrbytes) && dev->ioaccel_handle)
+		dev->hba_ioaccel_enabled = 1;
 	memset(id_phys, 0, sizeof(*id_phys));
 	rc = hpsa_bmic_id_physical_device(h, lunaddrbytes,
 			GET_BMIC_DRIVE_NUMBER(lunaddrbytes), id_phys,
@@ -4444,7 +4452,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
-	} else if (dev->ioaccel_handle) {
+	} else if (dev->hba_ioaccel_enabled) {
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index df2468c..87a70b5 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -55,6 +55,7 @@ struct hpsa_scsi_dev_t {
 	int offload_config;		/* I/O accel RAID offload configured */
 	int offload_enabled;		/* I/O accel RAID offload enabled */
 	int offload_to_be_enabled;
+	int hba_ioaccel_enabled;
 	int offload_to_mirror;		/* Send next I/O accelerator RAID
 					 * offload request to mirror drive
 					 */

