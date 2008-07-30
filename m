From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 4/6] cciss: change the way we notify scsi midlayer of tape drives
Date: Wed, 30 Jul 2008 16:15:05 -0500
Message-ID: <20080730211505.GD1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28014 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYG3VPG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:15:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 4 of 6

This patch changes way we notify the scsi layer that something has changed
on the SCSI tape side of the driver. The user can now just tell the driver
to rescan a particular controller rather than having to know the SCSI nexus
to echo into the SCSI mid-layer.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/Documentation/cciss.txt b/Documentation/cciss.txt
index 63e59b8..8244c64 100644
--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -112,27 +112,18 @@ Hot plug support for SCSI tape drives
 
 Hot plugging of SCSI tape drives is supported, with some caveats.
 The cciss driver must be informed that changes to the SCSI bus
-have been made, in addition to and prior to informing the SCSI 
-mid layer.  This may be done via the /proc filesystem.  For example:
+have been made.  This may be done via the /proc filesystem.
+For example:
 
 	echo "rescan" > /proc/scsi/cciss0/1
 
-This causes the adapter to query the adapter about changes to the 
-physical SCSI buses and/or fibre channel arbitrated loop and the 
+This causes the driver to query the adapter about changes to the
+physical SCSI buses and/or fibre channel arbitrated loop and the
 driver to make note of any new or removed sequential access devices
 or medium changers.  The driver will output messages indicating what 
 devices have been added or removed and the controller, bus, target and 
-lun used to address the device.  Once this is done, the SCSI mid layer 
-can be informed of changes to the virtual SCSI bus which the driver 
-presents to it in the usual way. For example: 
-
-	echo scsi add-single-device 3 2 1 0 > /proc/scsi/scsi
- 
-to add a device on controller 3, bus 2, target 1, lun 0.   Note that
-the driver makes an effort to preserve the devices positions
-in the virtual SCSI bus, so if you are only moving tape drives 
-around on the same adapter and not adding or removing tape drives 
-from the adapter, informing the SCSI mid layer may not be necessary.
+lun used to address the device.  It then notifies the SCSI mid layer
+of these changes.
 
 Note that the naming convention of the /proc filesystem entries 
 contains a number in addition to the driver name.  (E.g. "cciss0" 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e4bf9a1..c673ff1 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -358,10 +358,15 @@ find_bus_target_lun(int ctlr, int *bus, int *target, int *lun)
 	}
 	return (!found);	
 }
+struct scsi2map {
+	char scsi3addr[8];
+	int bus, target, lun;
+};
 
 static int 
 cciss_scsi_add_entry(int ctlr, int hostno, 
-		unsigned char *scsi3addr, int devtype)
+		unsigned char *scsi3addr, int devtype,
+		struct scsi2map *added, int *nadded)
 {
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
 	int n = ccissscsi[ctlr].ndevices;
@@ -375,6 +380,12 @@ cciss_scsi_add_entry(int ctlr, int hostno,
 	sd = &ccissscsi[ctlr].dev[n];
 	if (find_bus_target_lun(ctlr, &sd->bus, &sd->target, &sd->lun) != 0)
 		return -1;
+
+	added[*nadded].bus = sd->bus;
+	added[*nadded].target = sd->target;
+	added[*nadded].lun = sd->lun;
+	(*nadded)++;
+
 	memcpy(&sd->scsi3addr[0], scsi3addr, 8);
 	sd->devtype = devtype;
 	ccissscsi[ctlr].ndevices++;
@@ -390,7 +401,8 @@ cciss_scsi_add_entry(int ctlr, int hostno,
 }
 
 static void
-cciss_scsi_remove_entry(int ctlr, int hostno, int entry)
+cciss_scsi_remove_entry(int ctlr, int hostno, int entry,
+	struct scsi2map *removed, int *nremoved)
 {
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
 	int i;
@@ -398,6 +410,10 @@ cciss_scsi_remove_entry(int ctlr, int hostno, int entry)
 
 	if (entry < 0 || entry >= CCISS_MAX_SCSI_DEVS_PER_HBA) return;
 	sd = ccissscsi[ctlr].dev[entry];
+	removed[*nremoved].bus    = sd.bus;
+	removed[*nremoved].target = sd.target;
+	removed[*nremoved].lun    = sd.lun;
+	(*nremoved)++;
 	for (i=entry;i<ccissscsi[ctlr].ndevices-1;i++)
 		ccissscsi[ctlr].dev[i] = ccissscsi[ctlr].dev[i+1];
 	ccissscsi[ctlr].ndevices--;
@@ -417,6 +433,26 @@ cciss_scsi_remove_entry(int ctlr, int hostno, int entry)
 	(a)[1] == (b)[1] && \
 	(a)[0] == (b)[0])
 
+static void fixup_botched_add(int ctlr, char *scsi3addr)
+{
+	/* called when scsi_add_device fails in order to re-adjust */
+	/* ccissscsi[] to match the mid layer's view. */
+	unsigned long flags;
+	int i, j;
+	CPQ_TAPE_LOCK(ctlr, flags);
+	for (i = 0; i < ccissscsi[ctlr].ndevices; i++) {
+		if (memcmp(scsi3addr,
+				ccissscsi[ctlr].dev[i].scsi3addr, 8) == 0) {
+			for (j = i; j < ccissscsi[ctlr].ndevices-1; j++)
+				ccissscsi[ctlr].dev[j] =
+					ccissscsi[ctlr].dev[j+1];
+			ccissscsi[ctlr].ndevices--;
+			break;
+		}
+	}
+	CPQ_TAPE_UNLOCK(ctlr, flags);
+}
+
 static int
 adjust_cciss_scsi_table(int ctlr, int hostno,
 	struct cciss_scsi_dev_t sd[], int nsds)
@@ -429,13 +465,33 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 	int i,j, found, changes=0;
 	struct cciss_scsi_dev_t *csd;
 	unsigned long flags;
+	struct scsi2map *added, *removed;
+	int nadded, nremoved;
+	struct Scsi_Host *sh = NULL;
+
+	added = kzalloc(sizeof(*added) * CCISS_MAX_SCSI_DEVS_PER_HBA,
+			GFP_KERNEL);
+	removed = kzalloc(sizeof(*removed) * CCISS_MAX_SCSI_DEVS_PER_HBA,
+			GFP_KERNEL);
+
+	if (!added || !removed) {
+		printk(KERN_WARNING "cciss%d: Out of memory in "
+			"adjust_cciss_scsi_table\n", ctlr);
+		goto free_and_out;
+	}
 
 	CPQ_TAPE_LOCK(ctlr, flags);
 
+	if (hostno != -1)  /* if it's not the first time... */
+		sh = ((struct cciss_scsi_adapter_data_t *)
+			hba[ctlr]->scsi_ctlr)->scsi_host;
+
 	/* find any devices in ccissscsi[] that are not in 
 	   sd[] and remove them from ccissscsi[] */
 
 	i = 0;
+	nremoved = 0;
+	nadded = 0;
 	while(i<ccissscsi[ctlr].ndevices) {
 		csd = &ccissscsi[ctlr].dev[i];
 		found=0;
@@ -455,8 +511,9 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 			/* printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
 				ctlr, scsi_device_type(csd->devtype), hostno,
 					csd->bus, csd->target, csd->lun); */
-			cciss_scsi_remove_entry(ctlr, hostno, i);
-			/* note, i not incremented */
+			cciss_scsi_remove_entry(ctlr, hostno, i,
+				removed, &nremoved);
+			/* remove ^^^, hence i not incremented */
 		} 
 		else if (found == 1) { /* device is different kind */
 			changes++;
@@ -464,8 +521,15 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 				"(device type now %s).\n",
 				ctlr, hostno, csd->bus, csd->target, csd->lun,
 					scsi_device_type(csd->devtype));
+			cciss_scsi_remove_entry(ctlr, hostno, i,
+				removed, &nremoved);
+			/* remove ^^^, hence i not incremented */
+			if (cciss_scsi_add_entry(ctlr, hostno,
+				&sd[j].scsi3addr[0], sd[j].devtype,
+				added, &nadded) != 0)
+				/* we just removed one, so add can't fail. */
+					BUG();
 			csd->devtype = sd[j].devtype;
-			i++;	/* so just move along. */
 		} else 		/* device is same as it ever was, */
 			i++;	/* so just move along. */
 	}
@@ -489,7 +553,9 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 		if (!found) {
 			changes++;
 			if (cciss_scsi_add_entry(ctlr, hostno, 
-				&sd[i].scsi3addr[0], sd[i].devtype) != 0)
+
+				&sd[i].scsi3addr[0], sd[i].devtype,
+				added, &nadded) != 0)
 				break;
 		} else if (found == 1) {
 			/* should never happen... */
@@ -501,9 +567,50 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 	}
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 
-	if (!changes) 
-		printk("cciss%d: No device changes detected.\n", ctlr);
+	/* Don't notify scsi mid layer of any changes the first time through */
+	/* (or if there are no changes) scsi_scan_host will do it later the */
+	/* first time through. */
+	if (hostno == -1 || !changes)
+		goto free_and_out;
+
+	/* Notify scsi mid layer of any removed devices */
+	for (i = 0; i < nremoved; i++) {
+		struct scsi_device *sdev =
+			scsi_device_lookup(sh, removed[i].bus,
+				removed[i].target, removed[i].lun);
+		if (sdev != NULL) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
+		} else {
+			/* We don't expect to get here. */
+			/* future cmds to this device will get selection */
+			/* timeout as if the device was gone. */
+			printk(KERN_WARNING "cciss%d: didn't find "
+				"c%db%dt%dl%d\n for removal.",
+				ctlr, hostno, removed[i].bus,
+				removed[i].target, removed[i].lun);
+		}
+	}
+
+	/* Notify scsi mid layer of any added devices */
+	for (i = 0; i < nadded; i++) {
+		int rc;
+		rc = scsi_add_device(sh, added[i].bus,
+			added[i].target, added[i].lun);
+		if (rc == 0)
+			continue;
+		printk(KERN_WARNING "cciss%d: scsi_add_device "
+			"c%db%dt%dl%d failed, device not added.\n",
+			ctlr, hostno,
+			added[i].bus, added[i].target, added[i].lun);
+		/* now we have to remove it from ccissscsi, */
+		/* since it didn't get added to scsi mid layer */
+		fixup_botched_add(ctlr, added[i].scsi3addr);
+	}
 
+free_and_out:
+	kfree(added);
+	kfree(removed);
 	return 0;
 }
 
@@ -1355,32 +1462,6 @@ cciss_unregister_scsi(int ctlr)
 }
 
 static int 
-cciss_register_scsi(int ctlr)
-{
-	unsigned long flags;
-
-	CPQ_TAPE_LOCK(ctlr, flags);
-
-	/* Since this is really a block driver, the SCSI core may not be 
-	   initialized at init time, in which case, calling scsi_register_host
-	   would hang.  Instead, we do it later, via /proc filesystem
-	   and rc scripts, when we know SCSI core is good to go. */
-
-	/* Only register if SCSI devices are detected. */
-	if (ccissscsi[ctlr].ndevices != 0) {
-		((struct cciss_scsi_adapter_data_t *) 
-			hba[ctlr]->scsi_ctlr)->registered = 1;
-		CPQ_TAPE_UNLOCK(ctlr, flags);
-		return cciss_scsi_detect(ctlr);
-	}
-	CPQ_TAPE_UNLOCK(ctlr, flags);
-	printk(KERN_INFO 
-		"cciss%d: No appropriate SCSI device detected, "
-		"SCSI subsystem not engaged.\n", ctlr);
-	return 0;
-}
-
-static int 
 cciss_engage_scsi(int ctlr)
 {
 	struct cciss_scsi_adapter_data_t *sa;
@@ -1391,15 +1472,15 @@ cciss_engage_scsi(int ctlr)
 	sa = (struct cciss_scsi_adapter_data_t *) hba[ctlr]->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
-	if (((struct cciss_scsi_adapter_data_t *) 
-		hba[ctlr]->scsi_ctlr)->registered) {
+	if (sa->registered) {
 		printk("cciss%d: SCSI subsystem already engaged.\n", ctlr);
 		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 		return ENXIO;
 	}
+	sa->registered = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	cciss_update_non_disk_devices(ctlr, -1);
-	cciss_register_scsi(ctlr);
+	cciss_scsi_detect(ctlr);
 	return 0;
 }
 
@@ -1493,7 +1574,5 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 /* If no tape support, then these become defined out of existence */
 
 #define cciss_scsi_setup(cntl_num)
-#define cciss_unregister_scsi(ctlr)
-#define cciss_register_scsi(ctlr)
 
 #endif /* CONFIG_CISS_SCSI_TAPE */
