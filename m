From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 02/41] hpsa: clean up host, channel, target, lun prints
Date: Fri, 06 Mar 2015 17:45:58 -0600
Message-ID: <20150306234558.29973.69186.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40567 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbCFXr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:47:27 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |  103 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c95e1af..52711fd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -886,6 +886,53 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 	return !found;
 }
 
+static inline void hpsa_show_dev_msg(int type, struct ctlr_info *h,
+	struct hpsa_scsi_dev_t *dev, char *description)
+{
+#define HPSA_INFO 0
+#define HPSA_WARN 1
+#define HPSA_ERR 2
+	if (type == HPSA_INFO)
+		dev_info(&h->pdev->dev,
+			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			description,
+			scsi_device_type(dev->devtype),
+			dev->vendor,
+			dev->model,
+			dev->raid_level > RAID_UNKNOWN ?
+				"RAID-?" : raid_label[dev->raid_level],
+			dev->offload_config ? '+' : '-',
+			dev->offload_enabled ? '+' : '-',
+			dev->expose_state);
+	else if (type == HPSA_WARN)
+		dev_warn(&h->pdev->dev,
+			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			description,
+			scsi_device_type(dev->devtype),
+			dev->vendor,
+			dev->model,
+			dev->raid_level > RAID_UNKNOWN ?
+				"RAID-?" : raid_label[dev->raid_level],
+			dev->offload_config ? '+' : '-',
+			dev->offload_enabled ? '+' : '-',
+			dev->expose_state);
+	else if (type == HPSA_ERR)
+		dev_err(&h->pdev->dev,
+			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			description,
+			scsi_device_type(dev->devtype),
+			dev->vendor,
+			dev->model,
+			dev->raid_level > RAID_UNKNOWN ?
+				"RAID-?" : raid_label[dev->raid_level],
+			dev->offload_config ? '+' : '-',
+			dev->offload_enabled ? '+' : '-',
+			dev->expose_state);
+}
+
 /* Add an entry into h->dev[] array. */
 static int hpsa_scsi_add_entry(struct ctlr_info *h, int hostno,
 		struct hpsa_scsi_dev_t *device,
@@ -955,15 +1002,8 @@ lun_assigned:
 	device->offload_enabled = 0;
 	added[*nadded] = device;
 	(*nadded)++;
-
-	/* initially, (before registering with scsi layer) we don't
-	 * know our hostno and we don't want to print anything first
-	 * time anyway (the scsi layer's inquiries will show that info)
-	 */
-	/* if (hostno != -1) */
-		dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d added.\n",
-			scsi_device_type(device->devtype), hostno,
-			device->bus, device->target, device->lun);
+	hpsa_show_dev_msg(HPSA_INFO, h, device,
+		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
 	return 0;
 }
 
@@ -1003,6 +1043,7 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	if (!new_entry->offload_enabled)
 		h->dev[entry]->offload_enabled = 0;
 
+	hpsa_show_dev_msg(HPSA_INFO, h, h->dev[entry], "updated");
 }
 
 /* Replace an entry from h->dev[] array. */
@@ -1030,9 +1071,7 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
-	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d changed.\n",
-		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,
-			new_entry->target, new_entry->lun);
+	hpsa_show_dev_msg(HPSA_INFO, h, new_entry, "replaced");
 }
 
 /* Remove an entry from h->dev[] array. */
@@ -1052,9 +1091,7 @@ static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
 	for (i = entry; i < h->ndevices-1; i++)
 		h->dev[i] = h->dev[i+1];
 	h->ndevices--;
-	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d removed.\n",
-		scsi_device_type(sd->devtype), hostno, sd->bus, sd->target,
-		sd->lun);
+	hpsa_show_dev_msg(HPSA_INFO, h, sd, "removed");
 }
 
 #define SCSI3ADDR_EQ(a, b) ( \
@@ -1435,9 +1472,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		 */
 		if (sd[i]->volume_offline) {
 			hpsa_show_volume_status(h, sd[i]);
-			dev_info(&h->pdev->dev, "c%db%dt%dl%d: temporarily offline\n",
-				h->scsi_host->host_no,
-				sd[i]->bus, sd[i]->target, sd[i]->lun);
+			hpsa_show_dev_msg(HPSA_INFO, h, sd[i], "offline");
 			continue;
 		}
 
@@ -1501,10 +1536,11 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 				 * future cmds to this device will get selection
 				 * timeout as if the device was gone.
 				 */
-				dev_warn(&h->pdev->dev,
-					"didn't find c%db%dt%dl%d for removal.\n",
+			dev_warn(&h->pdev->dev,
+					"scsi %d:%d:%d:%d %s\n",
 					hostno, removed[i]->bus,
-					removed[i]->target, removed[i]->lun);
+					removed[i]->target, removed[i]->lun,
+					"didn't find device for removal.");
 			}
 		}
 		kfree(removed[i]);
@@ -1518,8 +1554,9 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
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
@@ -4378,7 +4415,6 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
 		return SUCCESS;
 
-	dev_warn(&h->pdev->dev, "resetting device failed.\n");
 	return FAILED;
 }
 
@@ -4494,8 +4530,9 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 
 	if (h->raid_offload_debug > 0)
 		dev_info(&h->pdev->dev,
-			"Reset as abort: Abort requested on C%d:B%d:T%d:L%d scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+			"scsi %d:%d:%d:%d %s scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			"Reset as abort",
 			scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
 			scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]);
 
@@ -4597,9 +4634,10 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "ABORT REQUEST on C%d:B%d:T%d:L%llu ",
+	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu %s",
 		h->scsi_host->host_no, sc->device->channel,
-		sc->device->id, sc->device->lun);
+		sc->device->id, sc->device->lun,
+		"Aborting command");
 
 	/* Find the device of the command to be aborted */
 	dev = sc->device->hostdata;
@@ -4627,8 +4665,9 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
 			as->cmnd[0], as->serial_number);
 	dev_dbg(&h->pdev->dev, "%s\n", msg);
-	dev_warn(&h->pdev->dev, "Abort request on C%d:B%d:T%d:L%d\n",
-		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
+	dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
+		h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+		"Aborting command");
 	/*
 	 * Command is in flight, or possibly already completed
 	 * by the firmware (but not to the scsi mid layer) but we can't
@@ -4636,10 +4675,10 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort);
 	if (rc != 0) {
-		dev_dbg(&h->pdev->dev, "%s Request FAILED.\n", msg);
-		dev_warn(&h->pdev->dev, "FAILED abort on device C%d:B%d:T%d:L%d\n",
+		dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
 			h->scsi_host->host_no,
-			dev->bus, dev->target, dev->lun);
+			dev->bus, dev->target, dev->lun,
+			"FAILED to abort command");
 		cmd_free(h, abort);
 		return FAILED;
 	}

