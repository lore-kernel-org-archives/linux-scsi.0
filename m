From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/28] visorhba: sanitze private device data allocation
Date: Wed, 28 Jun 2017 10:25:14 +0200
Message-ID: <1498638316-44420-27-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751643AbdF1IbZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:25 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, David Kershner <david.kershner@unisys.com>

There's no need to keep the private data for a device in a separate
list; better to store it in ->hostdata and do away with the additional
list.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: David Kershner <david.kershner@unisys.com>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 123 ++++++++++--------------
 1 file changed, 53 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 6997b16..811abfc 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -47,8 +47,8 @@
 MODULE_ALIAS("visorbus:" SPAR_VHBA_CHANNEL_PROTOCOL_UUID_STR);
 
 struct visordisk_info {
+	struct scsi_device *sdev;
 	u32 valid;
-	u32 channel, id, lun;	/* Disk Path */
 	atomic_t ios_threshold;
 	atomic_t error_count;
 	struct visordisk_info *next;
@@ -101,12 +101,6 @@ struct visorhba_devices_open {
 	struct visorhba_devdata *devdata;
 };
 
-#define for_each_vdisk_match(iter, list, match) \
-	for (iter = &list->head; iter->next; iter = iter->next) \
-		if ((iter->channel == match->channel) && \
-		    (iter->id == match->id) && \
-		    (iter->lun == match->lun))
-
 /*
  *	visor_thread_start - starts a thread for the device
  *	@threadfn: Function the thread starts
@@ -296,10 +290,9 @@ static void cleanup_scsitaskmgmt_handles(struct idr *idrtable,
  *	Returns whether the command was queued successfully or not.
  */
 static int forward_taskmgmt_command(enum task_mgmt_types tasktype,
-				    struct scsi_cmnd *scsicmd)
+				    struct scsi_device *scsidev)
 {
 	struct uiscmdrsp *cmdrsp;
-	struct scsi_device *scsidev = scsicmd->device;
 	struct visorhba_devdata *devdata =
 		(struct visorhba_devdata *)scsidev->host->hostdata;
 	int notifyresult = 0xffff;
@@ -347,12 +340,6 @@ static int forward_taskmgmt_command(enum task_mgmt_types tasktype,
 	dev_dbg(&scsidev->sdev_gendev,
 		"visorhba: taskmgmt type=%d success; result=0x%x\n",
 		 tasktype, notifyresult);
-	if (tasktype == TASK_MGMT_ABORT_TASK)
-		scsicmd->result = DID_ABORT << 16;
-	else
-		scsicmd->result = DID_RESET << 16;
-
-	scsicmd->scsi_done(scsicmd);
 	cleanup_scsitaskmgmt_handles(&devdata->idr, cmdrsp);
 	return SUCCESS;
 
@@ -376,17 +363,20 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 	/* issue TASK_MGMT_ABORT_TASK */
 	struct scsi_device *scsidev;
 	struct visordisk_info *vdisk;
-	struct visorhba_devdata *devdata;
+	int rtn;
 
 	scsidev = scsicmd->device;
-	devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-	for_each_vdisk_match(vdisk, devdata, scsidev) {
-		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
-			atomic_inc(&vdisk->error_count);
-		else
-			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+	vdisk = scsidev->hostdata;
+	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
+		atomic_inc(&vdisk->error_count);
+	else
+		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+	rtn = forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsidev);
+	if (rtn == SUCCESS) {
+		scsicmd->result = DID_ABORT << 16;
+		scsicmd->scsi_done(scsicmd);
 	}
-	return forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsicmd);
+	return rtn;
 }
 
 /*
@@ -400,17 +390,20 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* issue TASK_MGMT_LUN_RESET */
 	struct scsi_device *scsidev;
 	struct visordisk_info *vdisk;
-	struct visorhba_devdata *devdata;
+	int rtn;
 
 	scsidev = scsicmd->device;
-	devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-	for_each_vdisk_match(vdisk, devdata, scsidev) {
-		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
-			atomic_inc(&vdisk->error_count);
-		else
-			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+	vdisk = scsidev->hostdata;
+	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
+		atomic_inc(&vdisk->error_count);
+	else
+		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
+	if (rtn == SUCCESS) {
+		scsicmd->result = DID_RESET << 16;
+		scsicmd->scsi_done(scsicmd);
 	}
-	return forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsicmd);
+	return rtn;
 }
 
 /*
@@ -424,17 +417,22 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 {
 	struct scsi_device *scsidev;
 	struct visordisk_info *vdisk;
-	struct visorhba_devdata *devdata;
+	int rtn;
 
 	scsidev = scsicmd->device;
-	devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-	for_each_vdisk_match(vdisk, devdata, scsidev) {
+	shost_for_each_device(scsidev, scsidev->host) {
+		vdisk = scsidev->hostdata;
 		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
 			atomic_inc(&vdisk->error_count);
 		else
 			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	}
-	return forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsicmd);
+	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
+	if (rtn == SUCCESS) {
+		scsicmd->result = DID_RESET << 16;
+		scsicmd->scsi_done(scsicmd);
+	}
+	return rtn;
 }
 
 /*
@@ -569,25 +567,22 @@ static int visorhba_slave_alloc(struct scsi_device *scsidev)
 	 * LLD can alloc any struct & do init if needed.
 	 */
 	struct visordisk_info *vdisk;
-	struct visordisk_info *tmpvdisk;
 	struct visorhba_devdata *devdata;
 	struct Scsi_Host *scsihost = (struct Scsi_Host *)scsidev->host;
 
+	if (scsidev->hostdata)
+		return 0; /* already allocated return success */
+
 	devdata = (struct visorhba_devdata *)scsihost->hostdata;
 	if (!devdata)
 		return 0; /* even though we errored, treat as success */
 
-	for_each_vdisk_match(vdisk, devdata, scsidev)
-		return 0; /* already allocated return success */
-
-	tmpvdisk = kzalloc(sizeof(*tmpvdisk), GFP_ATOMIC);
-	if (!tmpvdisk)
+	vdisk = kzalloc(sizeof(*vdisk), GFP_ATOMIC);
+	if (!vdisk)
 		return -ENOMEM;
 
-	tmpvdisk->channel = scsidev->channel;
-	tmpvdisk->id = scsidev->id;
-	tmpvdisk->lun = scsidev->lun;
-	vdisk->next = tmpvdisk;
+	vdisk->sdev = scsidev;
+	scsidev->hostdata = vdisk;
 	return 0;
 }
 
@@ -603,17 +598,11 @@ static void visorhba_slave_destroy(struct scsi_device *scsidev)
 	/* midlevel calls this after device has been quiesced and
 	 * before it is to be deleted.
 	 */
-	struct visordisk_info *vdisk, *delvdisk;
-	struct visorhba_devdata *devdata;
-	struct Scsi_Host *scsihost = (struct Scsi_Host *)scsidev->host;
+	struct visordisk_info *vdisk;
 
-	devdata = (struct visorhba_devdata *)scsihost->hostdata;
-	for_each_vdisk_match(vdisk, devdata, scsidev) {
-		delvdisk = vdisk->next;
-		vdisk->next = delvdisk->next;
-		kfree(delvdisk);
-		return;
-	}
+	vdisk = scsidev->hostdata;
+	scsidev->hostdata = NULL;
+	kfree(vdisk);
 }
 
 static struct scsi_host_template visorhba_driver_template = {
@@ -787,7 +776,6 @@ static int visorhba_serverdown(struct visorhba_devdata *devdata)
 static void
 do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 {
-	struct visorhba_devdata *devdata;
 	struct visordisk_info *vdisk;
 	struct scsi_device *scsidev;
 
@@ -800,12 +788,10 @@ static int visorhba_serverdown(struct visorhba_devdata *devdata)
 	    (cmdrsp->scsi.addlstat == ADDL_SEL_TIMEOUT))
 		return;
 	/* Okay see what our error_count is here.... */
-	devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-	for_each_vdisk_match(vdisk, devdata, scsidev) {
-		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT) {
-			atomic_inc(&vdisk->error_count);
-			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
-		}
+	vdisk = scsidev->hostdata;
+	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT) {
+		atomic_inc(&vdisk->error_count);
+		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	}
 }
 
@@ -846,7 +832,6 @@ static int set_no_disk_inquiry_result(unsigned char *buf,
 	char *this_page_orig;
 	int bufind = 0;
 	struct visordisk_info *vdisk;
-	struct visorhba_devdata *devdata;
 
 	scsidev = scsicmd->device;
 	if ((cmdrsp->scsi.cmnd[0] == INQUIRY) &&
@@ -883,13 +868,11 @@ static int set_no_disk_inquiry_result(unsigned char *buf,
 		}
 		kfree(buf);
 	} else {
-		devdata = (struct visorhba_devdata *)scsidev->host->hostdata;
-		for_each_vdisk_match(vdisk, devdata, scsidev) {
-			if (atomic_read(&vdisk->ios_threshold) > 0) {
-				atomic_dec(&vdisk->ios_threshold);
-				if (atomic_read(&vdisk->ios_threshold) == 0)
-					atomic_set(&vdisk->error_count, 0);
-			}
+		vdisk = scsidev->hostdata;
+		if (atomic_read(&vdisk->ios_threshold) > 0) {
+			atomic_dec(&vdisk->ios_threshold);
+			if (atomic_read(&vdisk->ios_threshold) == 0)
+				atomic_set(&vdisk->error_count, 0);
 		}
 	}
 }
-- 
1.8.5.6
