From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 01/41] hpsa: add masked physical devices into h->dev[]
 array
Date: Fri, 06 Mar 2015 17:45:53 -0600
Message-ID: <20150306234552.29973.81396.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40546 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbCFXrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:47:22 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Cache the ioaccel handle so that when we need to abort commands sent
down the ioaccel2 path, we can look up the LUN ID in h->dev[] instead of
having to do I/O to the controller.

Add a field to elements in h->dev[] to keep track of how the device is exposed
to the SCSI mid layer: Not at all, without an upper level driver
(no_uld_attach) or normally exposed.

Since masked physical devices are now present in h->dev[] array
it would be perfectly possible to do

	echo scsi add-single-device 2 2 0 0 > /proc/scsi/scsi

and bring them online.  This was previously not allowed for masked
physical devices.

Ensure that the mapping of physical disks to logical drives gets updated in a
consistent way when a RAID migration occurs and is not touched until updates
to it are complete.

now instead of doing CISS_REPORT_PHYSICAL to get the LUNID for
the physical disk in hpsa_get_pdisk_of_ioaccel2(), just get
it out of h->dev[] where we already have it cached.

do not touch phys_disk[] for ioaccel enabled logical drives during rescan

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  256 +++++++++++++++++++++++++----------------------
 drivers/scsi/hpsa.h     |    6 +
 drivers/scsi/hpsa_cmd.h |    3 +
 3 files changed, 144 insertions(+), 121 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1cfbd3..c95e1af 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -222,6 +222,7 @@ static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_eh_abort_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_slave_alloc(struct scsi_device *sdev);
+static int hpsa_slave_configure(struct scsi_device *sdev);
 static void hpsa_slave_destroy(struct scsi_device *sdev);
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
@@ -667,6 +668,9 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	NULL,
 };
 
+#define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_ABORTS + \
+		HPSA_CMDS_RESERVED_FOR_DRIVER + HPSA_MAX_CONCURRENT_PASSTHRUS)
+
 static struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= HPSA,
@@ -681,6 +685,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.eh_device_reset_handler = hpsa_eh_device_reset_handler,
 	.ioctl			= hpsa_ioctl,
 	.slave_alloc		= hpsa_slave_alloc,
+	.slave_configure	= hpsa_slave_configure,
 	.slave_destroy		= hpsa_slave_destroy,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= hpsa_compat_ioctl,
@@ -946,6 +951,8 @@ lun_assigned:
 
 	h->dev[n] = device;
 	h->ndevices++;
+	device->offload_to_be_enabled = device->offload_enabled;
+	device->offload_enabled = 0;
 	added[*nadded] = device;
 	(*nadded)++;
 
@@ -982,16 +989,20 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 		 */
 		h->dev[entry]->raid_map = new_entry->raid_map;
 		h->dev[entry]->ioaccel_handle = new_entry->ioaccel_handle;
-		wmb(); /* ensure raid map updated prior to ->offload_enabled */
 	}
 	h->dev[entry]->offload_config = new_entry->offload_config;
 	h->dev[entry]->offload_to_mirror = new_entry->offload_to_mirror;
-	h->dev[entry]->offload_enabled = new_entry->offload_enabled;
 	h->dev[entry]->queue_depth = new_entry->queue_depth;
 
-	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d updated.\n",
-		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,
-		new_entry->target, new_entry->lun);
+	/*
+	 * We can turn off ioaccel offload now, but need to delay turning
+	 * it on until we can update h->dev[entry]->phys_disk[], but we
+	 * can't do that until all the devices are updated.
+	 */
+	h->dev[entry]->offload_to_be_enabled = new_entry->offload_enabled;
+	if (!new_entry->offload_enabled)
+		h->dev[entry]->offload_enabled = 0;
+
 }
 
 /* Replace an entry from h->dev[] array. */
@@ -1014,6 +1025,8 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 		new_entry->lun = h->dev[entry]->lun;
 	}
 
+	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
+	new_entry->offload_enabled = 0;
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
@@ -1312,7 +1325,8 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		 */
 		if (!logical_drive->phys_disk[i]) {
 			logical_drive->offload_enabled = 0;
-			logical_drive->queue_depth = h->nr_cmds;
+			logical_drive->offload_to_be_enabled = 0;
+			logical_drive->queue_depth = 8;
 		}
 	}
 	if (nraid_map_entries)
@@ -1335,6 +1349,16 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 			continue;
 		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
 			continue;
+
+		/*
+		 * If offload is currently enabled, the RAID map and
+		 * phys_disk[] assignment *better* not be changing
+		 * and since it isn't changing, we do not need to
+		 * update it.
+		 */
+		if (dev[i]->offload_enabled)
+			continue;
+
 		hpsa_figure_phys_disk_ptrs(h, dev, ndevices, dev[i]);
 	}
 }
@@ -1433,6 +1457,14 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 			/* but if it does happen, we just ignore that device */
 		}
 	}
+	hpsa_update_log_drive_phys_drive_ptrs(h, h->dev, h->ndevices);
+
+	/* Now that h->dev[]->phys_disk[] is coherent, we can enable
+	 * any logical drives that need it enabled.
+	 */
+	for (i = 0; i < h->ndevices; i++)
+		h->dev[i]->offload_enabled = h->dev[i]->offload_to_be_enabled;
+
 	spin_unlock_irqrestore(&h->devlock, flags);
 
 	/* Monitor devices which are in one of several NOT READY states to be
@@ -1456,20 +1488,24 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	sh = h->scsi_host;
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
-		struct scsi_device *sdev =
-			scsi_device_lookup(sh, removed[i]->bus,
-				removed[i]->target, removed[i]->lun);
-		if (sdev != NULL) {
-			scsi_remove_device(sdev);
-			scsi_device_put(sdev);
-		} else {
-			/* We don't expect to get here.
-			 * future cmds to this device will get selection
-			 * timeout as if the device was gone.
-			 */
-			dev_warn(&h->pdev->dev, "didn't find c%db%dt%dl%d "
-				" for removal.", hostno, removed[i]->bus,
-				removed[i]->target, removed[i]->lun);
+		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
+			struct scsi_device *sdev =
+				scsi_device_lookup(sh, removed[i]->bus,
+					removed[i]->target, removed[i]->lun);
+			if (sdev != NULL) {
+				scsi_remove_device(sdev);
+				scsi_device_put(sdev);
+			} else {
+				/*
+				 * We don't expect to get here.
+				 * future cmds to this device will get selection
+				 * timeout as if the device was gone.
+				 */
+				dev_warn(&h->pdev->dev,
+					"didn't find c%db%dt%dl%d for removal.\n",
+					hostno, removed[i]->bus,
+					removed[i]->target, removed[i]->lun);
+			}
 		}
 		kfree(removed[i]);
 		removed[i] = NULL;
@@ -1477,6 +1513,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 
 	/* Notify scsi mid layer of any added devices */
 	for (i = 0; i < nadded; i++) {
+		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
+			continue;
 		if (scsi_add_device(sh, added[i]->bus,
 			added[i]->target, added[i]->lun) == 0)
 			continue;
@@ -1512,7 +1550,6 @@ static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
 	return NULL;
 }
 
-/* link sdev->hostdata to our per-device structure. */
 static int hpsa_slave_alloc(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd;
@@ -1523,16 +1560,38 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 	spin_lock_irqsave(&h->devlock, flags);
 	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
 		sdev_id(sdev), sdev->lun);
-	if (sd != NULL) {
-		sdev->hostdata = sd;
-		if (sd->queue_depth)
-			scsi_change_queue_depth(sdev, sd->queue_depth);
+	if (likely(sd)) {
 		atomic_set(&sd->ioaccel_cmds_out, 0);
-	}
+		sdev->hostdata = (sd->expose_state & HPSA_SCSI_ADD) ? sd : NULL;
+	} else
+		sdev->hostdata = NULL;
 	spin_unlock_irqrestore(&h->devlock, flags);
 	return 0;
 }
 
+/* configure scsi device based on internal per-device structure */
+static int hpsa_slave_configure(struct scsi_device *sdev)
+{
+	struct hpsa_scsi_dev_t *sd;
+	int queue_depth;
+
+	sd = sdev->hostdata;
+	sdev->no_uld_attach = !sd || !(sd->expose_state & HPSA_ULD_ATTACH);
+
+	if (sd)
+		queue_depth = sd->queue_depth != 0 ?
+			sd->queue_depth : sdev->host->can_queue;
+	else
+		queue_depth = sdev->host->can_queue;
+
+	if (!shost_use_blk_mq(sdev->host))
+		sdev->tagged_supported = 1;
+
+	scsi_change_queue_depth(sdev, queue_depth);
+
+	return 0;
+}
+
 static void hpsa_slave_destroy(struct scsi_device *sdev)
 {
 	/* nothing to do. */
@@ -2438,6 +2497,7 @@ static void hpsa_get_ioaccel_status(struct ctlr_info *h,
 
 	this_device->offload_config = 0;
 	this_device->offload_enabled = 0;
+	this_device->offload_to_be_enabled = 0;
 
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
@@ -2461,6 +2521,7 @@ static void hpsa_get_ioaccel_status(struct ctlr_info *h,
 		if (hpsa_get_raid_map(h, scsi3addr, this_device))
 			this_device->offload_enabled = 0;
 	}
+	this_device->offload_to_be_enabled = this_device->offload_enabled;
 out:
 	kfree(buf);
 	return;
@@ -2708,6 +2769,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;
 		this_device->offload_enabled = 0;
+		this_device->offload_to_be_enabled = 0;
 		this_device->volume_offline = 0;
 		this_device->queue_depth = h->nr_cmds;
 	}
@@ -2850,88 +2912,23 @@ static int add_ext_target_dev(struct ctlr_info *h,
 static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
 	struct CommandList *ioaccel2_cmd_to_abort, unsigned char *scsi3addr)
 {
-	struct ReportExtendedLUNdata *physicals = NULL;
-	int responsesize = 24;	/* size of physical extended response */
-	int reportsize = sizeof(*physicals) + HPSA_MAX_PHYS_LUN * responsesize;
-	u32 nphysicals = 0;	/* number of reported physical devs */
-	int found = 0;		/* found match (1) or not (0) */
-	u32 find;		/* handle we need to match */
+	struct io_accel2_cmd *c2 =
+			&h->ioaccel2_cmd_pool[ioaccel2_cmd_to_abort->cmdindex];
+	unsigned long flags;
 	int i;
-	struct scsi_cmnd *scmd;	/* scsi command within request being aborted */
-	struct hpsa_scsi_dev_t *d; /* device of request being aborted */
-	struct io_accel2_cmd *c2a; /* ioaccel2 command to abort */
-	__le32 it_nexus;	/* 4 byte device handle for the ioaccel2 cmd */
-	__le32 scsi_nexus;	/* 4 byte device handle for the ioaccel2 cmd */
-
-	if (ioaccel2_cmd_to_abort->cmd_type != CMD_IOACCEL2)
-		return 0; /* no match */
-
-	/* point to the ioaccel2 device handle */
-	c2a = &h->ioaccel2_cmd_pool[ioaccel2_cmd_to_abort->cmdindex];
-	if (c2a == NULL)
-		return 0; /* no match */
-
-	scmd = (struct scsi_cmnd *) ioaccel2_cmd_to_abort->scsi_cmd;
-	if (scmd == NULL)
-		return 0; /* no match */
-
-	d = scmd->device->hostdata;
-	if (d == NULL)
-		return 0; /* no match */
-
-	it_nexus = cpu_to_le32(d->ioaccel_handle);
-	scsi_nexus = c2a->scsi_nexus;
-	find = le32_to_cpu(c2a->scsi_nexus);
-
-	if (h->raid_offload_debug > 0)
-		dev_info(&h->pdev->dev,
-			"%s: scsi_nexus:0x%08x device id: 0x%02x%02x%02x%02x %02x%02x%02x%02x %02x%02x%02x%02x %02x%02x%02x%02x\n",
-			__func__, scsi_nexus,
-			d->device_id[0], d->device_id[1], d->device_id[2],
-			d->device_id[3], d->device_id[4], d->device_id[5],
-			d->device_id[6], d->device_id[7], d->device_id[8],
-			d->device_id[9], d->device_id[10], d->device_id[11],
-			d->device_id[12], d->device_id[13], d->device_id[14],
-			d->device_id[15]);
-
-	/* Get the list of physical devices */
-	physicals = kzalloc(reportsize, GFP_KERNEL);
-	if (physicals == NULL)
-		return 0;
-	if (hpsa_scsi_do_report_phys_luns(h, physicals, reportsize)) {
-		dev_err(&h->pdev->dev,
-			"Can't lookup %s device handle: report physical LUNs failed.\n",
-			"HP SSD Smart Path");
-		kfree(physicals);
-		return 0;
-	}
-	nphysicals = be32_to_cpu(*((__be32 *)physicals->LUNListLength)) /
-							responsesize;
-
-	/* find ioaccel2 handle in list of physicals: */
-	for (i = 0; i < nphysicals; i++) {
-		struct ext_report_lun_entry *entry = &physicals->LUN[i];
-
-		/* handle is in bytes 28-31 of each lun */
-		if (entry->ioaccel_handle != find)
-			continue; /* didn't match */
-		found = 1;
-		memcpy(scsi3addr, entry->lunid, 8);
-		if (h->raid_offload_debug > 0)
-			dev_info(&h->pdev->dev,
-				"%s: Searched h=0x%08x, Found h=0x%08x, scsiaddr 0x%8phN\n",
-				__func__, find,
-				entry->ioaccel_handle, scsi3addr);
-		break; /* found it */
-	}
-
-	kfree(physicals);
-	if (found)
-		return 1;
-	else
-		return 0;
 
+	spin_lock_irqsave(&h->devlock, flags);
+	for (i = 0; i < h->ndevices; i++)
+		if (h->dev[i]->ioaccel_handle == le32_to_cpu(c2->scsi_nexus)) {
+			memcpy(scsi3addr, h->dev[i]->scsi3addr,
+				sizeof(h->dev[i]->scsi3addr));
+			spin_unlock_irqrestore(&h->devlock, flags);
+			return 1;
+		}
+	spin_unlock_irqrestore(&h->devlock, flags);
+	return 0;
 }
+
 /*
  * Do CISS_REPORT_PHYS and CISS_REPORT_LOG.  Data is returned in physdev,
  * logdev.  The number of luns in physdev and logdev are returned in
@@ -3142,10 +3139,12 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
 			i, nphysicals, nlogicals, physdev_list, logdev_list);
-		/* skip masked physical devices. */
-		if (lunaddrbytes[3] & 0xC0 &&
-			i < nphysicals + (raid_ctlr_position == 0))
-			continue;
+
+		/* skip masked non-disk devices */
+		if (MASKED_DEVICE(lunaddrbytes))
+			if (i < nphysicals + (raid_ctlr_position == 0) &&
+				NON_DISK_PHYS_DEV(lunaddrbytes))
+				continue;
 
 		/* Get device type, vendor, model, device id */
 		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
@@ -3170,6 +3169,18 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 		*this_device = *tmpdevice;
 
+		/* do not expose masked devices */
+		if (MASKED_DEVICE(lunaddrbytes) &&
+			i < nphysicals + (raid_ctlr_position == 0)) {
+			if (h->hba_mode_enabled)
+				dev_warn(&h->pdev->dev,
+					"Masked physical device detected\n");
+			this_device->expose_state = HPSA_DO_NOT_EXPOSE;
+		} else {
+			this_device->expose_state =
+					HPSA_SG_ATTACH | HPSA_ULD_ATTACH;
+		}
+
 		switch (this_device->devtype) {
 		case TYPE_ROM:
 			/* We don't *really* support actual CD-ROM devices,
@@ -3211,6 +3222,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		case TYPE_MEDIUM_CHANGER:
 			ncurrent++;
 			break;
+		case TYPE_ENCLOSURE:
+			if (h->hba_mode_enabled)
+				ncurrent++;
+			break;
 		case TYPE_RAID:
 			/* Only present the Smartarray HBA as a RAID controller.
 			 * If it's a RAID controller other than the HBA itself
@@ -3227,7 +3242,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		if (ncurrent >= HPSA_MAX_DEVICES)
 			break;
 	}
-	hpsa_update_log_drive_phys_drive_ptrs(h, currentsd, ncurrent);
 	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
 out:
 	kfree(tmpdevice);
@@ -4252,10 +4266,7 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
 	sh->max_lun = HPSA_MAX_LUN;
 	sh->max_id = HPSA_MAX_LUN;
-	sh->can_queue = h->nr_cmds -
-			HPSA_CMDS_RESERVED_FOR_ABORTS -
-			HPSA_CMDS_RESERVED_FOR_DRIVER -
-			HPSA_MAX_CONCURRENT_PASSTHRUS;
+	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
 	sh->cmd_per_lun = sh->can_queue;
 	sh->sg_tablesize = h->maxsgentries;
 	h->scsi_host = sh;
@@ -6097,18 +6108,21 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
 
 static void hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
 {
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+#define MIN_MAX_COMMANDS 16
+	BUILD_BUG_ON(MIN_MAX_COMMANDS <= HPSA_NRESERVED_CMDS);
+
+	h->max_commands = readl(&h->cfgtable->MaxPerformantModeCommands);
 
 	/* Limit commands in memory limited kdump scenario. */
 	if (reset_devices && h->max_commands > 32)
 		h->max_commands = 32;
 
-	if (h->max_commands < 16) {
-		dev_warn(&h->pdev->dev, "Controller reports "
-			"max supported commands of %d, an obvious lie. "
-			"Using 16.  Ensure that firmware is up to date.\n",
-			h->max_commands);
-		h->max_commands = 16;
+	if (h->max_commands < MIN_MAX_COMMANDS) {
+		dev_warn(&h->pdev->dev,
+			"Controller reports max supported commands of %d Using %d instead. Ensure that firmware is up to date.\n",
+			h->max_commands,
+			MIN_MAX_COMMANDS);
+		h->max_commands = MIN_MAX_COMMANDS;
 	}
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6577130..58f3315 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -54,6 +54,7 @@ struct hpsa_scsi_dev_t {
 	u32 ioaccel_handle;
 	int offload_config;		/* I/O accel RAID offload configured */
 	int offload_enabled;		/* I/O accel RAID offload enabled */
+	int offload_to_be_enabled;
 	int offload_to_mirror;		/* Send next I/O accelerator RAID
 					 * offload request to mirror drive
 					 */
@@ -68,6 +69,11 @@ struct hpsa_scsi_dev_t {
 	 * devices in order to honor physical device queue depth limits.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
+#define HPSA_DO_NOT_EXPOSE	0x0
+#define HPSA_SG_ATTACH		0x1
+#define HPSA_ULD_ATTACH		0x2
+#define HPSA_SCSI_ADD		(HPSA_SG_ATTACH | HPSA_ULD_ATTACH)
+	u8 expose_state;
 };
 
 struct reply_queue_buffer {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 3a621c7..76d5499 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -240,6 +240,7 @@ struct ReportLUNdata {
 
 struct ext_report_lun_entry {
 	u8 lunid[8];
+#define MASKED_DEVICE(x) ((x)[3] & 0xC0)
 #define GET_BMIC_BUS(lunid) ((lunid)[7] & 0x3F)
 #define GET_BMIC_LEVEL_TWO_TARGET(lunid) ((lunid)[6])
 #define GET_BMIC_DRIVE_NUMBER(lunid) (((GET_BMIC_BUS((lunid)) - 1) << 8) + \
@@ -247,6 +248,8 @@ struct ext_report_lun_entry {
 	u8 wwid[8];
 	u8 device_type;
 	u8 device_flags;
+#define NON_DISK_PHYS_DEV(x) ((x)[17] & 0x01)
+#define PHYS_IOACCEL(x) ((x)[17] & 0x08)
 	u8 lun_count; /* multi-lun device, how many luns */
 	u8 redundant_paths;
 	u32 ioaccel_handle; /* ioaccel1 only uses lower 16 bits */

