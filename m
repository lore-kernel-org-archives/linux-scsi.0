From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Fix error handler offline behaviour
Date: Wed, 17 Mar 2004 11:29:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6BB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:16584 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261532AbUCQQ3H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:29:07 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

There was a scsi_device_online(Sdev) handler used in the patch, why not
a scsi_device_set_online(Sdev) and a scsi_device_set_offline(Sdev)?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Tuesday, March 16, 2004 5:32 PM
To: SCSI Mailing List
Subject: [PATCH] Fix error handler offline behaviour

No-one seems to have noticed, but there's a bug in our offline handling
which can cause the eh to loop forever when it tries to offline a device
(basically offline I/O rejections are done in prep, which doesn't work
for already prepped commands).

The attached fixes this, and also sweeps offline up into a fairly fully
fledged scsi state model.

With this applied I can now offline my root device under load without
causing a SCSI hang (ext2 BUG()s rather unhappily but at least that's
not a SCSI problem).

James

===== drivers/scsi/dpt_i2o.c 1.35 vs edited =====
--- 1.35/drivers/scsi/dpt_i2o.c	Sat Sep 20 09:04:56 2003
+++ edited/drivers/scsi/dpt_i2o.c	Tue Mar 16 16:00:17 2004
@@ -592,7 +592,7 @@
 				unit = d->pI2o_dev->lct_data.tid;
 				len += sprintf(buffer+len, "\tTID=%d,
(Channel=%d, Target=%d, Lun=%d)  (%s)\n\n",
 					       unit,
(int)d->scsi_channel, (int)d->scsi_id, (int)d->scsi_lun,
-					       d->pScsi_dev->online?
"online":"offline"); 
+
scsi_device_online(d->pScsi_dev)? "online":"offline"); 
 				pos = begin + len;
 
 				/* CHECKPOINT */
@@ -2436,11 +2436,11 @@
 			// We found an old device - check it
 			while(pDev) {
 				if(pDev->scsi_lun == scsi_lun) {
-					if(pDev->pScsi_dev->online ==
FALSE) {
+
if(!scsi_device_online(pDev->pScsi_dev)) {
 						printk(KERN_WARNING"%s:
Setting device (%d,%d,%d) back online\n",
 
pHba->name,bus_no,scsi_id,scsi_lun);
 						if (pDev->pScsi_dev) {
-
pDev->pScsi_dev->online = TRUE;
+
scsi_device_set_state(pDev->pScsi_dev, SDEV_RUNNING);
 						}
 					}
 					d = pDev->pI2o_dev;
@@ -2471,7 +2471,7 @@
 			pDev->state = DPTI_DEV_OFFLINE;
 			printk(KERN_WARNING"%s: Device (%d,%d,%d)
offline\n",pHba->name,pDev->scsi_channel,pDev->scsi_id,pDev->scsi_lun);
 			if (pDev->pScsi_dev) {
-				pDev->pScsi_dev->online = FALSE;
+				scsi_device_set_state(pDev->pScsi_dev,
SDEV_OFFLINE);
 			}
 		}
 	}
===== drivers/scsi/scsi_error.c 1.71 vs edited =====
--- 1.71/drivers/scsi/scsi_error.c	Wed Feb 25 05:38:53 2004
+++ edited/drivers/scsi/scsi_error.c	Tue Mar 16 16:00:17 2004
@@ -186,12 +186,16 @@
  **/
 int scsi_block_when_processing_errors(struct scsi_device *sdev)
 {
+	int online;
+
 	wait_event(sdev->host->host_wait, (!test_bit(SHOST_RECOVERY,
&sdev->host->shost_state)));
 
+	online = scsi_device_online(sdev);
+
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
-					  sdev->online));
+					  online));
 
-	return sdev->online;
+	return online;
 }
 
 #ifdef CONFIG_SCSI_LOGGING
@@ -792,7 +796,8 @@
 		rtn = scsi_try_to_abort_cmd(scmd);
 		if (rtn == SUCCESS) {
 			scsi_eh_eflags_clr(scmd,  SCSI_EH_CANCEL_CMD);
-			if (!scmd->device->online || !scsi_eh_tur(scmd))
{
+			if (!scsi_device_online(scmd->device) ||
+			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
 				
@@ -920,7 +925,8 @@
 						  " 0x%p\n",
current->comm, sdev));
 
 		if (!scsi_eh_try_stu(stu_scmd)) {
-			if (!sdev->online || !scsi_eh_tur(stu_scmd)) {
+			if (!scsi_device_online(sdev) ||
+			    !scsi_eh_tur(stu_scmd)) {
 				list_for_each_safe(lh, lh_sf, work_q) {
 					scmd = list_entry(lh, struct
scsi_cmnd, eh_entry);
 					if (scmd->device == sdev)
@@ -974,7 +980,8 @@
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
 		if (rtn == SUCCESS) {
-			if (!sdev->online || !scsi_eh_tur(bdr_scmd)) {
+			if (!scsi_device_online(sdev) ||
+			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_safe(lh, lh_sf,
 						   work_q) {
 					scmd = list_entry(lh, struct
@@ -1105,7 +1112,7 @@
 				scmd = list_entry(lh, struct scsi_cmnd,
 						  eh_entry);
 				if (channel == scmd->device->channel)
-					if (!scmd->device->online ||
+					if
(!scsi_device_online(scmd->device) ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
 
done_q);
@@ -1143,7 +1150,7 @@
 		if (rtn == SUCCESS) {
 			list_for_each_safe(lh, lh_sf, work_q) {
 				scmd = list_entry(lh, struct scsi_cmnd,
eh_entry);
-				if (!scmd->device->online ||
+				if (!scsi_device_online(scmd->device) ||
 				    (!scsi_eh_try_stu(scmd) &&
!scsi_eh_tur(scmd)) ||
 				    !scsi_eh_tur(scmd))
 					scsi_eh_finish_cmd(scmd,
done_q);
@@ -1178,7 +1185,7 @@
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
-		scmd->device->online = FALSE;
+		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
 			/*
 			 * FIXME: Handle lost cmds.
@@ -1248,7 +1255,7 @@
 	 * if the device is offline, then we clearly just pass the
result back
 	 * up to the top level.
 	 */
-	if (!scmd->device->online) {
+	if (!scsi_device_online(scmd->device)) {
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline -
report"
 						  " as SUCCESS\n",
 						  __FUNCTION__));
@@ -1480,7 +1487,7 @@
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (sdev->online && sdev->locked)
+		if (scsi_device_online(sdev) && sdev->locked)
 			scsi_eh_lock_door(sdev);
 	}
 
@@ -1535,7 +1542,7 @@
 	list_for_each_safe(lh, lh_sf, done_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
 		list_del_init(lh);
-		if (scmd->device->online &&
+		if (scsi_device_online(scmd->device) &&
 		    	(++scmd->retries < scmd->allowed)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd:
%p\n",
===== drivers/scsi/scsi_lib.c 1.123 vs edited =====
--- 1.123/drivers/scsi/scsi_lib.c	Thu Mar 11 15:38:26 2004
+++ edited/drivers/scsi/scsi_lib.c	Tue Mar 16 16:02:00 2004
@@ -957,10 +957,20 @@
 	struct scsi_cmnd *cmd;
 	int specials_only = 0;
 
-	if(unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+	/*
+	 * Just check to see if the device is online.  If it isn't, we
+	 * refuse to process any commands.  The device must be brought
+	 * online before trying any recovery commands
+	 */
+	if (unlikely(!scsi_device_online(sdev))) {
+		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to
offline device\n",
+		       sdev->host->host_no, sdev->id, sdev->lun);
+		return BLKPREP_KILL;
+	}
+	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
 		/* OK, we're not in a running state don't prep
 		 * user commands */
-		if(sdev->sdev_state == SDEV_DEL) {
+		if (sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to dead device\n",
@@ -1005,18 +1015,6 @@
 			
 			
 		/*
-		 * Just check to see if the device is online.  If
-		 * it isn't, we refuse to process ordinary commands
-		 * (we will allow specials just in case someone needs
-		 * to send a command to an offline device without
bringing
-		 * it back online)
-		 */
-		if(!sdev->online) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to offline device\n",
-			       sdev->host->host_no, sdev->id,
sdev->lun);
-			return BLKPREP_KILL;
-		}
-		/*
 		 * Now try and find a command block that we can use.
 		 */
 		if (!req->special) {
@@ -1205,6 +1203,18 @@
 		if (!req || !scsi_dev_queue_ready(q, sdev))
 			break;
 
+		if (unlikely(!scsi_device_online(sdev))) {
+			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to offline device\n",
+			       sdev->host->host_no, sdev->id,
sdev->lun);
+			blkdev_dequeue_request(req);
+			req->flags |= REQ_QUIET;
+			while (end_that_request_first(req, 0,
req->nr_sectors))
+				;
+			end_that_request_last(req);
+			continue;
+		}
+
+
 		/*
 		 * Remove the request from the request list.
 		 */
@@ -1556,29 +1566,77 @@
 {
 	enum scsi_device_state oldstate = sdev->sdev_state;
 
-	/* FIXME: eventually we will enforce all the state model
-	 * transitions here */
-
-	if(oldstate == state)
+	if (state == oldstate)
 		return 0;
 
-	switch(state) {
+	switch (state) {
+	case SDEV_CREATED:
+		/* There are no legal states that come back to
+		 * created.  This is the manually initialised start
+		 * state */
+		goto illegal;
+			
 	case SDEV_RUNNING:
-		if(oldstate != SDEV_CREATED && oldstate != SDEV_QUIESCE)
-			return -EINVAL;
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_OFFLINE:
+		case SDEV_QUIESCE:
+			break;
+		default:
+			goto illegal;
+		}
 		break;
 
 	case SDEV_QUIESCE:
-		if(oldstate != SDEV_RUNNING)
-			return -EINVAL;
+		switch (oldstate) {
+		case SDEV_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SDEV_OFFLINE:
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SDEV_CANCEL:
+		switch (oldstate) {
+		case SDEV_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
 		break;
 
-	default:
+	case SDEV_DEL:
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_CANCEL:
+		case SDEV_OFFLINE:
+			break;
+		default:
+			goto illegal;
+		}
 		break;
+
 	}
 	sdev->sdev_state = state;
-
 	return 0;
+
+ illegal:
+	dev_printk(KERN_ERR, &sdev->sdev_gendev,
+		   "Illegal state transition %s->%s\n",
+		   scsi_device_state_name(oldstate),
+		   scsi_device_state_name(state));
+	WARN_ON(1);
+	return -EINVAL;
 }
 EXPORT_SYMBOL(scsi_device_set_state);
 
@@ -1601,11 +1659,11 @@
 scsi_device_quiesce(struct scsi_device *sdev)
 {
 	int err = scsi_device_set_state(sdev, SDEV_QUIESCE);
-	if(err)
+	if (err)
 		return err;
 
 	scsi_run_queue(sdev->request_queue);
-	while(sdev->device_busy) {
+	while (sdev->device_busy) {
 		schedule_timeout(HZ/5);
 		scsi_run_queue(sdev->request_queue);
 	}
@@ -1625,10 +1683,8 @@
 void
 scsi_device_resume(struct scsi_device *sdev)
 {
-	if(sdev->sdev_state != SDEV_QUIESCE)
+	if(scsi_device_set_state(sdev, SDEV_RUNNING))
 		return;
-
-	scsi_device_set_state(sdev, SDEV_RUNNING);
 	scsi_run_queue(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
===== drivers/scsi/scsi_scan.c 1.117 vs edited =====
--- 1.117/drivers/scsi/scsi_scan.c	Sat Mar 13 09:35:03 2004
+++ edited/drivers/scsi/scsi_scan.c	Tue Mar 16 16:00:18 2004
@@ -205,7 +205,6 @@
 	sdev->id = id;
 	sdev->lun = lun;
 	sdev->channel = channel;
-	sdev->online = TRUE;
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
@@ -552,7 +551,7 @@
 	if (((inq_result[0] >> 5) & 7) == 1) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan:
peripheral"
 				" qualifier of 1, device offlined\n"));
-		sdev->online = FALSE;
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
 	}
 
 	sdev->removable = (0x80 & inq_result[1]) >> 7;
===== drivers/scsi/scsi_sysfs.c 1.43 vs edited =====
--- 1.43/drivers/scsi/scsi_sysfs.c	Sat Mar 13 06:09:30 2004
+++ edited/drivers/scsi/scsi_sysfs.c	Tue Mar 16 16:00:19 2004
@@ -19,6 +19,32 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+static struct {
+	enum scsi_device_state	value;
+	char			*name;
+} sdev_states[] = {
+	{ SDEV_CREATED, "created" },
+	{ SDEV_RUNNING, "running" },
+	{ SDEV_CANCEL, "cancel" },
+	{ SDEV_DEL, "deleted" },
+	{ SDEV_QUIESCE, "quiesce" },
+	{ SDEV_OFFLINE,	"offline" },
+};
+
+const char *scsi_device_state_name(enum scsi_device_state state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < sizeof(sdev_states)/sizeof(sdev_states[0]); i++)
{
+		if (sdev_states[i].value == state) {
+			name = sdev_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
 static int check_set(unsigned int *val, char *src)
 {
 	char *last;
@@ -222,6 +248,9 @@
 }
\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field,
sdev_store_##field)
 
+/* Currently we don't export bit fields, but we might in future,
+ * so leave this code in */
+#if 0
 /*
  * sdev_rd_attr: create a function and attribute variable for a
  * read/write bit field.
@@ -260,7 +289,7 @@
 	} else
 		return -EINVAL;
 }
-
+#endif
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -271,7 +300,6 @@
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
-sdev_rw_attr_bit (online);
 
 static ssize_t
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
@@ -289,6 +317,44 @@
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
+static ssize_t
+store_state_field(struct device *dev, const char *buf, size_t count)
+{
+	int i;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	enum scsi_device_state state = 0;
+
+	for (i = 0; i < sizeof(sdev_states)/sizeof(sdev_states[0]); i++)
{
+		const int len = strlen(sdev_states[i].name);
+		if (strncmp(sdev_states[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			state = sdev_states[i].value;
+			break;
+		}
+	}
+	if (!state)
+		return -EINVAL;
+
+	if (scsi_device_set_state(sdev, state))
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+show_state_field(struct device *dev, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *name = scsi_device_state_name(sdev->sdev_state);
+
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field,
store_state_field);
+
+
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,
@@ -298,9 +364,9 @@
 	&dev_attr_vendor,
 	&dev_attr_model,
 	&dev_attr_rev,
-	&dev_attr_online,
 	&dev_attr_rescan,
 	&dev_attr_delete,
+	&dev_attr_state,
 	NULL
 };
 
@@ -439,7 +505,7 @@
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state ==
SDEV_CANCEL) {
 		scsi_device_set_state(sdev, SDEV_DEL);
 		class_device_unregister(&sdev->sdev_classdev);
-		if(sdev->transport_classdev.class)
+		if (sdev->transport_classdev.class)
 
class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
===== drivers/scsi/sd.c 1.142 vs edited =====
--- 1.142/drivers/scsi/sd.c	Thu Mar  4 09:38:18 2004
+++ edited/drivers/scsi/sd.c	Tue Mar 16 16:00:20 2004
@@ -245,7 +245,7 @@
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s,
block=%llu, "
 			    "count=%d\n", disk->disk_name, (unsigned
long long)block, this_count));
 
-	if (!sdp || !sdp->online ||
+	if (!sdp || !scsi_device_online(sdp) ||
  	    block + SCpnt->request->nr_sectors > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
 				 SCpnt->request->nr_sectors));
@@ -452,7 +452,7 @@
 	 * open actually succeeded.
 	 */
 	retval = -ENXIO;
-	if (!sdev->online)
+	if (!scsi_device_online(sdev))
 		goto error_out;
 
 	if (!sdkp->openers++ && sdev->removable) {
@@ -619,7 +619,7 @@
 	 * can deal with it then.  It is only because of unrecoverable
errors
 	 * that we would ever take a device offline in the first place.
 	 */
-	if (!sdp->online)
+	if (!scsi_device_online(sdp))
 		goto not_present;
 
 	/*
@@ -1254,7 +1254,7 @@
 	 * If the device is offline, don't try and read capacity or any
 	 * of the other niceties.
 	 */
-	if (!sdp->online)
+	if (!scsi_device_online(sdp))
 		goto out;
 
 	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
@@ -1474,7 +1474,7 @@
 	if (!sdkp)
                return;         /* this can happen */
 
-	if (!sdp->online || !sdkp->WCE)
+	if (!scsi_device_online(sdp) || !sdkp->WCE)
 		return;
 
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: ",
===== drivers/scsi/sg.c 1.84 vs edited =====
--- 1.84/drivers/scsi/sg.c	Fri Mar 12 10:22:11 2004
+++ edited/drivers/scsi/sg.c	Tue Mar 16 16:00:20 2004
@@ -2920,7 +2920,7 @@
 			      1,
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
-			      (int) scsidp->online);
+			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
 	return 0;
===== drivers/scsi/sr.c 1.100 vs edited =====
--- 1.100/drivers/scsi/sr.c	Thu Mar 11 06:19:52 2004
+++ edited/drivers/scsi/sr.c	Tue Mar 16 16:00:21 2004
@@ -267,7 +267,7 @@
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block =
%d\n",
 				cd->disk->disk_name, block));
 
-	if (!cd->device || !cd->device->online) {
+	if (!cd->device || !scsi_device_online(cd->device)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
 					SCpnt->request->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
===== include/scsi/scsi_device.h 1.14 vs edited =====
--- 1.14/include/scsi/scsi_device.h	Thu Mar 11 12:14:57 2004
+++ edited/include/scsi/scsi_device.h	Tue Mar 16 16:00:21 2004
@@ -12,7 +12,9 @@
 

 /*
- * sdev state
+ * sdev state: If you alter this, you also need to alter scsi_sysfs.c
+ * (for the ascii descriptions) and the state model enforcer:
+ * scsi_lib:scsi_device_set_state().
  */
 enum scsi_device_state {
 	SDEV_CREATED = 1,	/* device created but not added to sysfs
@@ -26,6 +28,8 @@
 	SDEV_QUIESCE,		/* Device quiescent.  No block commands
 				 * will be accepted, only specials
(which
 				 * originate in the mid-layer) */
+	SDEV_OFFLINE,		/* Device offlined (by error handling or
+				 * user request */
 };
 
 struct scsi_device {
@@ -67,8 +71,6 @@
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for
single_lun */
 
-	unsigned online:1;
-
 	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
@@ -177,4 +179,9 @@
 				 enum scsi_device_state state);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
+extern const char *scsi_device_state_name(enum scsi_device_state);
+static int inline scsi_device_online(struct scsi_device *sdev)
+{
+	return sdev->sdev_state != SDEV_OFFLINE;
+}
 #endif /* _SCSI_SCSI_DEVICE_H */

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
