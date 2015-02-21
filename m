From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 02/43] hpsa: clean up host, channel, target, lun prints
Date: Sat, 21 Feb 2015 16:17:41 -0600
Message-ID: <20150221221741.21954.90751.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1385 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbBUWTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:19:01 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

We had a mix of formats used for specifying controller, bus, target,
and lun address of devices.

change to the format used by the scsi midlayer and upper layer (2:3:0:0)
so you can easily follow the information from hpsa to scsi midlayer
to sd upper layer.

Also add this information:
- product ID
- vendor ID
- RAID level
- SSD Smath Path capable and enabled
- exposure level (sg-only)

Example:
hpsa 0000:04:00.0: added scsi 2:0:0:0: Direct-Access     HP LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En+ Exp=4
scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdr] 12501713072 512-byte logical blocks: (6.40 TB/5.82 TiB)
sd 2:0:0:0: [sdr] 4096-byte physical blocks
sd 2:0:0:0: [sdr] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg20 type 0

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   94 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5f12f32..9a82ede 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -956,14 +956,18 @@ lun_assigned:
 	added[*nadded] = device;
 	(*nadded)++;
 
-	/* initially, (before registering with scsi layer) we don't
-	 * know our hostno and we don't want to print anything first
-	 * time anyway (the scsi layer's inquiries will show that info)
-	 */
-	/* if (hostno != -1) */
-		dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d added.\n",
-			scsi_device_type(device->devtype), hostno,
-			device->bus, device->target, device->lun);
+	dev_info(&h->pdev->dev,
+		"%6s scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked",
+		hostno, device->bus, device->target, device->lun,
+		scsi_device_type(device->devtype),
+		device->vendor,
+		device->model,
+		device->raid_level > RAID_UNKNOWN ?
+			"RAID-?" : raid_label[device->raid_level],
+		device->offload_config ? '+' : '-',
+		device->offload_enabled ? '+' : '-',
+		device->expose_state);
 	return 0;
 }
 
@@ -1003,6 +1007,18 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	if (!new_entry->offload_enabled)
 		h->dev[entry]->offload_enabled = 0;
 
+	dev_info(&h->pdev->dev,
+		"updated scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+		hostno, h->dev[entry]->bus,
+		h->dev[entry]->target, h->dev[entry]->lun,
+		scsi_device_type(h->dev[entry]->devtype),
+		h->dev[entry]->vendor,
+		h->dev[entry]->model,
+		h->dev[entry]->raid_level > RAID_UNKNOWN ?
+			"RAID-?" : raid_label[h->dev[entry]->raid_level],
+		h->dev[entry]->offload_config ? '+' : '-',
+		h->dev[entry]->offload_enabled ? '+' : '-',
+		h->dev[entry]->expose_state);
 }
 
 /* Replace an entry from h->dev[] array. */
@@ -1030,9 +1046,17 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
-	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d changed.\n",
-		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,
-			new_entry->target, new_entry->lun);
+	dev_info(&h->pdev->dev,
+		"replaced scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+		hostno, new_entry->bus, new_entry->target, new_entry->lun,
+		scsi_device_type(new_entry->devtype),
+		new_entry->vendor,
+		new_entry->model,
+		new_entry->raid_level > RAID_UNKNOWN ?
+			"RAID-?" : raid_label[new_entry->raid_level],
+		new_entry->offload_config ? '+' : '-',
+		new_entry->offload_enabled ? '+' : '-',
+		new_entry->expose_state);
 }
 
 /* Remove an entry from h->dev[] array. */
@@ -1052,9 +1076,17 @@ static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
 	for (i = entry; i < h->ndevices-1; i++)
 		h->dev[i] = h->dev[i+1];
 	h->ndevices--;
-	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d removed.\n",
-		scsi_device_type(sd->devtype), hostno, sd->bus, sd->target,
-		sd->lun);
+	dev_info(&h->pdev->dev,
+		"removed scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+		hostno, sd->bus, sd->target, sd->lun,
+		scsi_device_type(sd->devtype),
+		sd->vendor,
+		sd->model,
+		sd->raid_level > RAID_UNKNOWN ?
+			"RAID-?" : raid_label[sd->raid_level],
+		sd->offload_config ? '+' : '-',
+		sd->offload_enabled ? '+' : '-',
+		sd->expose_state);
 }
 
 #define SCSI3ADDR_EQ(a, b) ( \
@@ -1435,9 +1467,18 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		 */
 		if (sd[i]->volume_offline) {
 			hpsa_show_volume_status(h, sd[i]);
-			dev_info(&h->pdev->dev, "c%db%dt%dl%d: temporarily offline\n",
-				h->scsi_host->host_no,
-				sd[i]->bus, sd[i]->target, sd[i]->lun);
+			dev_info(&h->pdev->dev,
+				"offline scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+				hostno, sd[i]->bus, sd[i]->target, sd[i]->lun,
+				scsi_device_type(sd[i]->devtype),
+				sd[i]->vendor,
+				sd[i]->model,
+				sd[i]->raid_level > RAID_UNKNOWN ?
+					"RAID-?" :
+					raid_label[sd[i]->raid_level],
+				sd[i]->offload_config ? '+' : '-',
+				sd[i]->offload_enabled ? '+' : '-',
+				sd[i]->expose_state);
 			continue;
 		}
 
@@ -1501,8 +1542,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 				 * future cmds to this device will get selection
 				 * timeout as if the device was gone.
 				 */
-				dev_warn(&h->pdev->dev,
-					"didn't find c%db%dt%dl%d for removal.\n",
+			dev_warn(&h->pdev->dev,
+					"didn't find scsi %d:%d:%d:%d for removal.\n",
 					hostno, removed[i]->bus,
 					removed[i]->target, removed[i]->lun);
 			}
@@ -1518,8 +1559,9 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		if (scsi_add_device(sh, added[i]->bus,
 			added[i]->target, added[i]->lun) == 0)
 			continue;
-		dev_warn(&h->pdev->dev, "scsi_add_device c%db%dt%dl%d failed, "
-			"device not added.\n", hostno, added[i]->bus,
+		dev_warn(&h->pdev->dev,
+			"scsi %d:%d:%d:%d addition failed, device not added.\n",
+			hostno, added[i]->bus,
 			added[i]->target, added[i]->lun);
 		/* now we have to remove it from h->dev,
 		 * since it didn't get added to scsi mid layer
@@ -4383,7 +4425,6 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
 		return SUCCESS;
 
-	dev_warn(&h->pdev->dev, "resetting device failed.\n");
 	return FAILED;
 }
 
@@ -4499,7 +4540,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 
 	if (h->raid_offload_debug > 0)
 		dev_info(&h->pdev->dev,
-			"Reset as abort: Abort requested on C%d:B%d:T%d:L%d scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+			"Reset as abort: scsi %d:%d:%d:%d scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
 			scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
 			scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]);
@@ -4602,7 +4643,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "ABORT REQUEST on C%d:B%d:T%d:L%llu ",
+	ml += sprintf(msg+ml, "Aborting command on scsi %d:%d:%d:%llu ",
 		h->scsi_host->host_no, sc->device->channel,
 		sc->device->id, sc->device->lun);
 
@@ -4632,7 +4673,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
 			as->cmnd[0], as->serial_number);
 	dev_dbg(&h->pdev->dev, "%s\n", msg);
-	dev_warn(&h->pdev->dev, "Abort request on C%d:B%d:T%d:L%d\n",
+	dev_warn(&h->pdev->dev, "Aborting command on scsi %d:%d:%d:%d\n",
 		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
 	/*
 	 * Command is in flight, or possibly already completed
@@ -4641,8 +4682,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort);
 	if (rc != 0) {
-		dev_dbg(&h->pdev->dev, "%s Request FAILED.\n", msg);
-		dev_warn(&h->pdev->dev, "FAILED abort on device C%d:B%d:T%d:L%d\n",
+		dev_warn(&h->pdev->dev, "FAILED abort command on scsi %d:%d:%d:%d\n",
 			h->scsi_host->host_no,
 			dev->bus, dev->target, dev->lun);
 		cmd_free(h, abort);

