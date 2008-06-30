From: christof.schmitt@de.ibm.com
Subject: [patch 06/11] zfcp: Cleanup of code in zfcp_scsi.c
Date: Mon, 30 Jun 2008 12:52:42 +0200
Message-ID: <20080630110058.621352000@de.ibm.com>
References: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56667 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYF3LBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:01:52 -0400
Content-Disposition: inline; filename=zfcp_scsi_cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

Cleanup code in zfcp_scsi.c, fix coding style issues and simplify the
code.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |    3 
 drivers/s390/scsi/zfcp_def.h  |    6 
 drivers/s390/scsi/zfcp_ext.h  |    5 
 drivers/s390/scsi/zfcp_fsf.c  |    4 
 drivers/s390/scsi/zfcp_scsi.c |  555 +++++++++++++-----------------------------
 5 files changed, 184 insertions(+), 389 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-30 11:01:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-30 11:04:29.000000000 +0200
@@ -9,137 +9,32 @@
 #include "zfcp_ext.h"
 #include <asm/atomic.h>
 
-static void zfcp_scsi_slave_destroy(struct scsi_device *sdp);
-static int zfcp_scsi_slave_alloc(struct scsi_device *sdp);
-static int zfcp_scsi_slave_configure(struct scsi_device *sdp);
-static int zfcp_scsi_queuecommand(struct scsi_cmnd *,
-				  void (*done) (struct scsi_cmnd *));
-static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *);
-static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *);
-static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *);
-static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *);
-static int zfcp_task_management_function(struct zfcp_unit *, u8,
-					 struct scsi_cmnd *);
-
-static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *, int,
-					  unsigned int, unsigned int);
-
-static struct device_attribute *zfcp_sysfs_sdev_attrs[];
-static struct device_attribute *zfcp_a_stats_attrs[];
-
-struct zfcp_data zfcp_data = {
-	.scsi_host_template = {
-		.name			= "zfcp",
-		.module			= THIS_MODULE,
-		.proc_name		= "zfcp",
-		.slave_alloc		= zfcp_scsi_slave_alloc,
-		.slave_configure	= zfcp_scsi_slave_configure,
-		.slave_destroy		= zfcp_scsi_slave_destroy,
-		.queuecommand		= zfcp_scsi_queuecommand,
-		.eh_abort_handler	= zfcp_scsi_eh_abort_handler,
-		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
-		.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
-		.eh_host_reset_handler	= zfcp_scsi_eh_host_reset_handler,
-		.can_queue		= 4096,
-		.this_id		= -1,
-		.sg_tablesize		= ZFCP_MAX_SBALES_PER_REQ,
-		.cmd_per_lun		= 1,
-		.use_clustering		= 1,
-		.sdev_attrs		= zfcp_sysfs_sdev_attrs,
-		.max_sectors		= ZFCP_MAX_SECTORS,
-		.shost_attrs		= zfcp_a_stats_attrs,
-	},
-};
-
-/* Find start of Response Information in FCP response unit*/
-char *
-zfcp_get_fcp_rsp_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
-{
-	char *fcp_rsp_info_ptr;
-
-	fcp_rsp_info_ptr =
-	    (unsigned char *) fcp_rsp_iu + (sizeof (struct fcp_rsp_iu));
-
-	return fcp_rsp_info_ptr;
-}
-
 /* Find start of Sense Information in FCP response unit*/
-char *
-zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
+char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
 {
 	char *fcp_sns_info_ptr;
 
-	fcp_sns_info_ptr =
-	    (unsigned char *) fcp_rsp_iu + (sizeof (struct fcp_rsp_iu));
+	fcp_sns_info_ptr = (unsigned char *) &fcp_rsp_iu[1];
 	if (fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)
-		fcp_sns_info_ptr = (char *) fcp_sns_info_ptr +
-		    fcp_rsp_iu->fcp_rsp_len;
+		fcp_sns_info_ptr += fcp_rsp_iu->fcp_rsp_len;
 
 	return fcp_sns_info_ptr;
 }
 
-static fcp_dl_t *
-zfcp_get_fcp_dl_ptr(struct fcp_cmnd_iu * fcp_cmd)
+void zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_cmd, fcp_dl_t fcp_dl)
 {
-	int additional_length = fcp_cmd->add_fcp_cdb_length << 2;
-	fcp_dl_t *fcp_dl_addr;
+	fcp_dl_t *fcp_dl_ptr;
 
-	fcp_dl_addr = (fcp_dl_t *)
-		((unsigned char *) fcp_cmd +
-		 sizeof (struct fcp_cmnd_iu) + additional_length);
 	/*
 	 * fcp_dl_addr = start address of fcp_cmnd structure +
 	 * size of fixed part + size of dynamically sized add_dcp_cdb field
 	 * SEE FCP-2 documentation
 	 */
-	return fcp_dl_addr;
-}
-
-fcp_dl_t
-zfcp_get_fcp_dl(struct fcp_cmnd_iu * fcp_cmd)
-{
-	return *zfcp_get_fcp_dl_ptr(fcp_cmd);
-}
-
-void
-zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_cmd, fcp_dl_t fcp_dl)
-{
-	*zfcp_get_fcp_dl_ptr(fcp_cmd) = fcp_dl;
+	fcp_dl_ptr = (fcp_dl_t *) ((unsigned char *) &fcp_cmd[1] +
+				   (fcp_cmd->add_fcp_cdb_length << 2));
+	*fcp_dl_ptr = fcp_dl;
 }
 
-static int
-zfcp_scsi_slave_alloc(struct scsi_device *sdp)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_unit *unit;
-	unsigned long flags;
-	int retval = -ENXIO;
-
-	adapter = (struct zfcp_adapter *) sdp->host->hostdata[0];
-	if (!adapter)
-		goto out;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	unit = zfcp_unit_lookup(adapter, sdp->channel, sdp->id, sdp->lun);
-	if (unit && atomic_test_mask(ZFCP_STATUS_UNIT_REGISTERED,
-				     &unit->status)) {
-		sdp->hostdata = unit;
-		unit->device = sdp;
-		zfcp_unit_get(unit);
-		retval = 0;
-	}
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
- out:
-	return retval;
-}
-
-/**
- * zfcp_scsi_slave_destroy - called when scsi device is removed
- *
- * Remove reference to associated scsi device for an zfcp_unit.
- * Mark zfcp_unit as failed. The scsi device might be deleted via sysfs
- * or a scan for this device might have failed.
- */
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
@@ -153,26 +48,16 @@ static void zfcp_scsi_slave_destroy(stru
 	}
 }
 
-/*
- * called from scsi midlayer to allow finetuning of a device.
- */
-static int
-zfcp_scsi_slave_configure(struct scsi_device *sdp)
+static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
 {
 	if (sdp->tagged_supported)
-		scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, ZFCP_CMND_PER_LUN);
+		scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, 32);
 	else
 		scsi_adjust_queue_depth(sdp, 0, 1);
 	return 0;
 }
 
-/**
- * zfcp_scsi_command_fail - set result in scsi_cmnd and call scsi_done function
- * @scpnt: pointer to struct scsi_cmnd where result is set
- * @result: result to be set in scpnt (e.g. DID_ERROR)
- */
-static void
-zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
+static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(scpnt, result);
 	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
@@ -183,104 +68,13 @@ zfcp_scsi_command_fail(struct scsi_cmnd 
 	scpnt->scsi_done(scpnt);
 }
 
-/**
- * zfcp_scsi_command_async - worker for zfcp_scsi_queuecommand and
- *	zfcp_scsi_command_sync
- * @adapter: adapter where scsi command is issued
- * @unit: unit to which scsi command is sent
- * @scpnt: scsi command to be sent
- * @timer: timer to be started if request is successfully initiated
- *
- * Note: In scsi_done function must be set in scpnt.
- */
-int
-zfcp_scsi_command_async(struct zfcp_adapter *adapter, struct zfcp_unit *unit,
-			struct scsi_cmnd *scpnt, int use_timer)
-{
-	int tmp;
-	int retval;
-
-	retval = 0;
-
-	BUG_ON((adapter == NULL) || (adapter != unit->port->adapter));
-	BUG_ON(scpnt->scsi_done == NULL);
-
-	if (unlikely(NULL == unit)) {
-		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
-		goto out;
-	}
-
-	if (unlikely(
-	      atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status) ||
-	     !atomic_test_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status))) {
-		zfcp_scsi_command_fail(scpnt, DID_ERROR);
-		goto out;
-	}
-
-	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, use_timer,
-					     ZFCP_REQ_AUTO_CLEANUP);
-	if (unlikely(tmp == -EBUSY)) {
-		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
-		goto out;
-	}
-
-	if (unlikely(tmp < 0))
-		retval = SCSI_MLQUEUE_HOST_BUSY;
-
-out:
-	return retval;
-}
-
-static void
-zfcp_scsi_command_sync_handler(struct scsi_cmnd *scpnt)
-{
-	struct completion *wait = (struct completion *) scpnt->SCp.ptr;
-	complete(wait);
-}
-
-
-/**
- * zfcp_scsi_command_sync - send a SCSI command and wait for completion
- * @unit: unit where command is sent to
- * @scpnt: scsi command to be sent
- * @use_timer: indicates whether timer should be setup or not
- * Return: 0
- *
- * Errors are indicated in scpnt->result
- */
-int
-zfcp_scsi_command_sync(struct zfcp_unit *unit, struct scsi_cmnd *scpnt,
-		       int use_timer)
-{
-	int ret;
-	DECLARE_COMPLETION_ONSTACK(wait);
-
-	scpnt->SCp.ptr = (void *) &wait;  /* silent re-use */
-	scpnt->scsi_done = zfcp_scsi_command_sync_handler;
-	ret = zfcp_scsi_command_async(unit->port->adapter, unit, scpnt,
-				      use_timer);
-	if (ret == 0)
-		wait_for_completion(&wait);
-
-	scpnt->SCp.ptr = NULL;
-
-	return 0;
-}
-
-/*
- * function:	zfcp_scsi_queuecommand
- *
- * purpose:	enqueues a SCSI command to the specified target device
- *
- * returns:	0 - success, SCSI command enqueued
- *		!0 - failure
- */
-static int
-zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
-		       void (*done) (struct scsi_cmnd *))
+static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
+				  void (*done) (struct scsi_cmnd *))
 {
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter;
+	int    status;
+	int    ret;
 
 	/* reset the status for this request */
 	scpnt->result = 0;
@@ -292,44 +86,76 @@ zfcp_scsi_queuecommand(struct scsi_cmnd 
 	 * (stored there by zfcp_scsi_slave_alloc)
 	 */
 	adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
-	unit = (struct zfcp_unit *) scpnt->device->hostdata;
+	unit = scpnt->device->hostdata;
+
+	BUG_ON(!adapter || (adapter != unit->port->adapter));
+	BUG_ON(!scpnt->scsi_done);
+
+	if (unlikely(!unit)) {
+		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
+		return 0;
+	}
+
+	status = atomic_read(&unit->status);
+	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
+		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
+		zfcp_scsi_command_fail(scpnt, DID_ERROR);
+		return 0;;
+	}
+
+	ret = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, 0,
+					     ZFCP_REQ_AUTO_CLEANUP);
+	if (unlikely(ret == -EBUSY))
+		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
+	else if (unlikely(ret < 0))
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	return zfcp_scsi_command_async(adapter, unit, scpnt, 0);
+	return ret;
 }
 
-static struct zfcp_unit *
-zfcp_unit_lookup(struct zfcp_adapter *adapter, int channel, unsigned int id,
-		 unsigned int lun)
+static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *adapter,
+					  int channel, unsigned int id,
+					  unsigned int lun)
 {
 	struct zfcp_port *port;
-	struct zfcp_unit *unit, *retval = NULL;
+	struct zfcp_unit *unit;
 
 	list_for_each_entry(port, &adapter->port_list_head, list) {
 		if (!port->rport || (id != port->rport->scsi_target_id))
 			continue;
 		list_for_each_entry(unit, &port->unit_list_head, list)
-			if (lun == unit->scsi_lun) {
-				retval = unit;
-				goto out;
-			}
+			if (lun == unit->scsi_lun)
+				return unit;
 	}
- out:
+
+	return NULL;
+}
+
+static int zfcp_scsi_slave_alloc(struct scsi_device *sdp)
+{
+	struct zfcp_adapter *adapter;
+	struct zfcp_unit *unit;
+	unsigned long flags;
+	int retval = -ENXIO;
+
+	adapter = (struct zfcp_adapter *) sdp->host->hostdata[0];
+	if (!adapter)
+		goto out;
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	unit = zfcp_unit_lookup(adapter, sdp->channel, sdp->id, sdp->lun);
+	if (unit &&
+	    (atomic_read(&unit->status) & ZFCP_STATUS_UNIT_REGISTERED)) {
+		sdp->hostdata = unit;
+		unit->device = sdp;
+		zfcp_unit_get(unit);
+		retval = 0;
+	}
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+out:
 	return retval;
 }
 
-/**
- * zfcp_scsi_eh_abort_handler - abort the specified SCSI command
- * @scpnt: pointer to scsi_cmnd to be aborted
- * Return: SUCCESS - command has been aborted and cleaned up in internal
- *          bookkeeping, SCSI stack won't be called for aborted command
- *         FAILED - otherwise
- *
- * We do not need to care for a SCSI command which completes normally
- * but late during this abort routine runs.  We are allowed to return
- * late commands to the SCSI stack.  It tracks the state of commands and
- * will handle late commands.  (Usually, the normal completion of late
- * commands is ignored with respect to the running abort operation.)
- */
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
  	struct Scsi_Host *scsi_host;
@@ -337,30 +163,27 @@ static int zfcp_scsi_eh_abort_handler(st
 	struct zfcp_unit *unit;
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
-	unsigned long old_req_id;
+	unsigned long old_req_id = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS;
 
 	scsi_host = scpnt->device->host;
 	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
-	unit = (struct zfcp_unit *) scpnt->device->hostdata;
+	unit = scpnt->device->hostdata;
 
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
 	/* Check whether corresponding fsf_req is still pending */
 	spin_lock(&adapter->req_list_lock);
-	fsf_req = zfcp_reqlist_find(adapter,
-				    (unsigned long) scpnt->host_scribble);
+	fsf_req = zfcp_reqlist_find(adapter, old_req_id);
 	spin_unlock(&adapter->req_list_lock);
 	if (!fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, 0);
-		retval = SUCCESS;
-		goto out;
+		return retval;
 	}
 	fsf_req->data = 0;
 	fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
-	old_req_id = fsf_req->req_id;
 
 	/* don't access old fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
@@ -370,7 +193,7 @@ static int zfcp_scsi_eh_abort_handler(st
 		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
 					  old_req_id);
 		retval = FAILED;
-		goto out;
+		return retval;
 	}
 
 	__wait_event(fsf_req->completion_wq,
@@ -378,62 +201,30 @@ static int zfcp_scsi_eh_abort_handler(st
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED) {
 		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, fsf_req, 0);
-		retval = SUCCESS;
 	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED) {
 		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, fsf_req, 0);
-		retval = SUCCESS;
 	} else {
 		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, fsf_req, 0);
 		retval = FAILED;
 	}
 	zfcp_fsf_req_free(fsf_req);
- out:
-	return retval;
-}
-
-static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
-{
-	int retval;
-	struct zfcp_unit *unit = scpnt->device->hostdata;
 
-	if (!unit) {
-		WARN_ON(1);
-		return SUCCESS;
-	}
-	retval = zfcp_task_management_function(unit,
-					       FCP_LOGICAL_UNIT_RESET,
-					       scpnt);
-	return retval ? FAILED : SUCCESS;
-}
-
-static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
-{
-	int retval;
-	struct zfcp_unit *unit = scpnt->device->hostdata;
-
-	if (!unit) {
-		WARN_ON(1);
-		return SUCCESS;
-	}
-	retval = zfcp_task_management_function(unit, FCP_TARGET_RESET, scpnt);
-	return retval ? FAILED : SUCCESS;
+	return retval;
 }
 
-static int
-zfcp_task_management_function(struct zfcp_unit *unit, u8 tm_flags,
-			      struct scsi_cmnd *scpnt)
+static int zfcp_task_mgmt_function(struct zfcp_unit *unit, u8 tm_flags,
+					 struct scsi_cmnd *scpnt)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 	struct zfcp_fsf_req *fsf_req;
-	int retval = 0;
+	int retval = SUCCESS;
 
 	/* issue task management function */
 	fsf_req = zfcp_fsf_send_fcp_command_task_management
 		(adapter, unit, tm_flags, 0);
 	if (!fsf_req) {
 		zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit, scpnt);
-		retval = -ENOMEM;
-		goto out;
+		return FAILED;
 	}
 
 	__wait_event(fsf_req->completion_wq,
@@ -444,27 +235,46 @@ zfcp_task_management_function(struct zfc
 	 */
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
 		zfcp_scsi_dbf_event_devreset("fail", tm_flags, unit, scpnt);
-		retval = -EIO;
+		retval = FAILED;
 	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP) {
 		zfcp_scsi_dbf_event_devreset("nsup", tm_flags, unit, scpnt);
-		retval = -ENOTSUPP;
+		retval = FAILED;
 	} else
 		zfcp_scsi_dbf_event_devreset("okay", tm_flags, unit, scpnt);
 
 	zfcp_fsf_req_free(fsf_req);
- out:
+
 	return retval;
 }
 
-/**
- * zfcp_scsi_eh_host_reset_handler - handler for host reset
- */
+static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
+{
+	struct zfcp_unit *unit = scpnt->device->hostdata;
+
+	if (!unit) {
+		WARN_ON(1);
+		return SUCCESS;
+	}
+	return zfcp_task_mgmt_function(unit, FCP_LOGICAL_UNIT_RESET, scpnt);
+}
+
+static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
+{
+	struct zfcp_unit *unit = scpnt->device->hostdata;
+
+	if (!unit) {
+		WARN_ON(1);
+		return SUCCESS;
+	}
+	return zfcp_task_mgmt_function(unit, FCP_TARGET_RESET, scpnt);
+}
+
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter;
 
-	unit = (struct zfcp_unit*) scpnt->device->hostdata;
+	unit = scpnt->device->hostdata;
 	adapter = unit->port->adapter;
 	zfcp_erp_adapter_reopen(adapter, 0, 141, scpnt);
 	zfcp_erp_wait(adapter);
@@ -472,51 +282,43 @@ static int zfcp_scsi_eh_host_reset_handl
 	return SUCCESS;
 }
 
-int
-zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)
+int zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
-	static unsigned int unique_id = 0;
+	struct ccw_dev_id dev_id;
 
 	if (adapter->scsi_host)
-		goto out;
+		return 0;
 
+	ccw_device_get_id(adapter->ccw_device, &dev_id);
 	/* register adapter as SCSI host with mid layer of SCSI stack */
 	adapter->scsi_host = scsi_host_alloc(&zfcp_data.scsi_host_template,
 					     sizeof (struct zfcp_adapter *));
 	if (!adapter->scsi_host) {
 		dev_err(&adapter->ccw_device->dev,
 			"registration with SCSI stack failed.");
-		retval = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	/* tell the SCSI stack some characteristics of this adapter */
 	adapter->scsi_host->max_id = 1;
 	adapter->scsi_host->max_lun = 1;
 	adapter->scsi_host->max_channel = 0;
-	adapter->scsi_host->unique_id = unique_id++;	/* FIXME */
-	adapter->scsi_host->max_cmd_len = ZFCP_MAX_SCSI_CMND_LENGTH;
+	adapter->scsi_host->unique_id = dev_id.devno;
+	adapter->scsi_host->max_cmd_len = 255;
 	adapter->scsi_host->transportt = zfcp_data.scsi_transport_template;
 
-	/*
-	 * save a pointer to our own adapter data structure within
-	 * hostdata field of SCSI host data structure
-	 */
 	adapter->scsi_host->hostdata[0] = (unsigned long) adapter;
 
 	if (scsi_add_host(adapter->scsi_host, &adapter->ccw_device->dev)) {
 		scsi_host_put(adapter->scsi_host);
-		retval = -EIO;
-		goto out;
+		return -EIO;
 	}
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_REGISTERED, &adapter->status);
- out:
-	return retval;
+
+	return 0;
 }
 
-void
-zfcp_adapter_scsi_unregister(struct zfcp_adapter *adapter)
+void zfcp_adapter_scsi_unregister(struct zfcp_adapter *adapter)
 {
 	struct Scsi_Host *shost;
 	struct zfcp_port *port;
@@ -524,10 +326,12 @@ zfcp_adapter_scsi_unregister(struct zfcp
 	shost = adapter->scsi_host;
 	if (!shost)
 		return;
+
 	read_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (port->rport)
 			port->rport = NULL;
+
 	read_unlock_irq(&zfcp_data.config_lock);
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
@@ -538,9 +342,6 @@ zfcp_adapter_scsi_unregister(struct zfcp
 	return;
 }
 
-/*
- * Support functions for FC transport class
- */
 static struct fc_host_statistics*
 zfcp_init_fc_host_stats(struct zfcp_adapter *adapter)
 {
@@ -556,13 +357,12 @@ zfcp_init_fc_host_stats(struct zfcp_adap
 	return adapter->fc_stats;
 }
 
-static void
-zfcp_adjust_fc_host_stats(struct fc_host_statistics *fc_stats,
-			  struct fsf_qtcb_bottom_port *data,
-			  struct fsf_qtcb_bottom_port *old)
+static void zfcp_adjust_fc_host_stats(struct fc_host_statistics *fc_stats,
+				      struct fsf_qtcb_bottom_port *data,
+				      struct fsf_qtcb_bottom_port *old)
 {
-	fc_stats->seconds_since_last_reset = data->seconds_since_last_reset -
-		old->seconds_since_last_reset;
+	fc_stats->seconds_since_last_reset =
+		data->seconds_since_last_reset - old->seconds_since_last_reset;
 	fc_stats->tx_frames = data->tx_frames - old->tx_frames;
 	fc_stats->tx_words = data->tx_words - old->tx_words;
 	fc_stats->rx_frames = data->rx_frames - old->rx_frames;
@@ -573,26 +373,25 @@ zfcp_adjust_fc_host_stats(struct fc_host
 	fc_stats->dumped_frames = data->dumped_frames - old->dumped_frames;
 	fc_stats->link_failure_count = data->link_failure - old->link_failure;
 	fc_stats->loss_of_sync_count = data->loss_of_sync - old->loss_of_sync;
-	fc_stats->loss_of_signal_count = data->loss_of_signal -
-		old->loss_of_signal;
-	fc_stats->prim_seq_protocol_err_count = data->psp_error_counts -
-		old->psp_error_counts;
-	fc_stats->invalid_tx_word_count = data->invalid_tx_words -
-		old->invalid_tx_words;
+	fc_stats->loss_of_signal_count =
+		data->loss_of_signal - old->loss_of_signal;
+	fc_stats->prim_seq_protocol_err_count =
+		data->psp_error_counts - old->psp_error_counts;
+	fc_stats->invalid_tx_word_count =
+		data->invalid_tx_words - old->invalid_tx_words;
 	fc_stats->invalid_crc_count = data->invalid_crcs - old->invalid_crcs;
-	fc_stats->fcp_input_requests = data->input_requests -
-		old->input_requests;
-	fc_stats->fcp_output_requests = data->output_requests -
-		old->output_requests;
-	fc_stats->fcp_control_requests = data->control_requests -
-		old->control_requests;
+	fc_stats->fcp_input_requests =
+		data->input_requests - old->input_requests;
+	fc_stats->fcp_output_requests =
+		data->output_requests - old->output_requests;
+	fc_stats->fcp_control_requests =
+		data->control_requests - old->control_requests;
 	fc_stats->fcp_input_megabytes = data->input_mb - old->input_mb;
 	fc_stats->fcp_output_megabytes = data->output_mb - old->output_mb;
 }
 
-static void
-zfcp_set_fc_host_stats(struct fc_host_statistics *fc_stats,
-		       struct fsf_qtcb_bottom_port *data)
+static void zfcp_set_fc_host_stats(struct fc_host_statistics *fc_stats,
+				   struct fsf_qtcb_bottom_port *data)
 {
 	fc_stats->seconds_since_last_reset = data->seconds_since_last_reset;
 	fc_stats->tx_frames = data->tx_frames;
@@ -616,22 +415,14 @@ zfcp_set_fc_host_stats(struct fc_host_st
 	fc_stats->fcp_output_megabytes = data->output_mb;
 }
 
-/**
- * zfcp_get_fc_host_stats - provide fc_host_statistics for scsi_transport_fc
- *
- * assumption: scsi_transport_fc synchronizes calls of
- *             get_fc_host_stats and reset_fc_host_stats
- *             (XXX to be checked otherwise introduce locking)
- */
-static struct fc_host_statistics *
-zfcp_get_fc_host_stats(struct Scsi_Host *shost)
+static struct fc_host_statistics *zfcp_get_fc_host_stats(struct Scsi_Host *host)
 {
 	struct zfcp_adapter *adapter;
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *data;
 	int ret;
 
-	adapter = (struct zfcp_adapter *)shost->hostdata[0];
+	adapter = (struct zfcp_adapter *)host->hostdata[0];
 	fc_stats = zfcp_init_fc_host_stats(adapter);
 	if (!fc_stats)
 		return NULL;
@@ -643,26 +434,25 @@ zfcp_get_fc_host_stats(struct Scsi_Host 
 	ret = zfcp_fsf_exchange_port_data_sync(adapter, data);
 	if (ret) {
 		kfree(data);
-		return NULL; /* XXX return zeroed fc_stats? */
+		return NULL;
 	}
 
 	if (adapter->stats_reset &&
 	    ((jiffies/HZ - adapter->stats_reset) <
-	     data->seconds_since_last_reset)) {
+	     data->seconds_since_last_reset))
 		zfcp_adjust_fc_host_stats(fc_stats, data,
 					  adapter->stats_reset_data);
-	} else
+	else
 		zfcp_set_fc_host_stats(fc_stats, data);
 
 	kfree(data);
 	return fc_stats;
 }
 
-static void
-zfcp_reset_fc_host_stats(struct Scsi_Host *shost)
+static void zfcp_reset_fc_host_stats(struct Scsi_Host *shost)
 {
 	struct zfcp_adapter *adapter;
-	struct fsf_qtcb_bottom_port *data, *old_data;
+	struct fsf_qtcb_bottom_port *data;
 	int ret;
 
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
@@ -671,14 +461,13 @@ zfcp_reset_fc_host_stats(struct Scsi_Hos
 		return;
 
 	ret = zfcp_fsf_exchange_port_data_sync(adapter, data);
-	if (ret) {
+	if (ret)
 		kfree(data);
-	} else {
+	else {
 		adapter->stats_reset = jiffies/HZ;
-		old_data = adapter->stats_reset_data;
+		kfree(adapter->stats_reset_data);
 		adapter->stats_reset_data = data; /* finally freed in
-						     adater_dequeue */
-		kfree(old_data);
+						     adapter_dequeue */
 	}
 }
 
@@ -793,14 +582,6 @@ ZFCP_DEFINE_LATENCY_ATTR(read);
 ZFCP_DEFINE_LATENCY_ATTR(write);
 ZFCP_DEFINE_LATENCY_ATTR(cmd);
 
-/**
- * ZFCP_DEFINE_SCSI_ATTR
- * @_name:   name of show attribute
- * @_format: format string
- * @_value:  value to print
- *
- * Generates attribute for a unit.
- */
 #define ZFCP_DEFINE_SCSI_ATTR(_name, _format, _value)                    \
 static ssize_t zfcp_sysfs_scsi_##_name##_show(struct device *dev, struct device_attribute *attr,        \
                                               char *buf)                 \
@@ -815,7 +596,8 @@ static ssize_t zfcp_sysfs_scsi_##_name##
                                                                          \
 static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, NULL);
 
-ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n", zfcp_get_busid_by_unit(unit));
+ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
+	unit->port->adapter->ccw_device->dev.bus_id);
 ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
 ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);
 
@@ -835,8 +617,8 @@ static ssize_t zfcp_sysfs_adapter_util_s
 {
 	struct Scsi_Host *scsi_host = dev_to_shost(dev);
 	struct fsf_qtcb_bottom_port *qtcb_port;
-	int retval;
 	struct zfcp_adapter *adapter;
+	int retval;
 
 	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
 	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
@@ -857,17 +639,17 @@ static ssize_t zfcp_sysfs_adapter_util_s
 static int zfcp_sysfs_adapter_ex_config(struct device *dev,
 					struct fsf_statistics_info *stat_inf)
 {
-	int retval;
-	struct fsf_qtcb_bottom_config *qtcb_config;
 	struct Scsi_Host *scsi_host = dev_to_shost(dev);
+	struct fsf_qtcb_bottom_config *qtcb_config;
 	struct zfcp_adapter *adapter;
+	int retval;
 
 	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
 	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
 		return -EOPNOTSUPP;
 
 	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
-			       GFP_KERNEL);
+			      GFP_KERNEL);
 	if (!qtcb_config)
 		return -ENOMEM;
 
@@ -940,3 +722,28 @@ static struct device_attribute *zfcp_a_s
 	&dev_attr_seconds_active,
 	NULL
 };
+
+struct zfcp_data zfcp_data = {
+	.scsi_host_template = {
+		.name			 = "zfcp",
+		.module			 = THIS_MODULE,
+		.proc_name		 = "zfcp",
+		.slave_alloc		 = zfcp_scsi_slave_alloc,
+		.slave_configure	 = zfcp_scsi_slave_configure,
+		.slave_destroy		 = zfcp_scsi_slave_destroy,
+		.queuecommand		 = zfcp_scsi_queuecommand,
+		.eh_abort_handler	 = zfcp_scsi_eh_abort_handler,
+		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
+		.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
+		.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
+		.can_queue		 = 4096,
+		.this_id		 = -1,
+		.sg_tablesize		 = ZFCP_MAX_SBALES_PER_REQ,
+		.cmd_per_lun		 = 1,
+		.use_clustering		 = 1,
+		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
+		.max_sectors		 = (ZFCP_MAX_SBALES_PER_REQ * 8),
+		.shost_attrs		 = zfcp_a_stats_attrs,
+	},
+};
+
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:01:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:01:46.000000000 +0200
@@ -126,12 +126,6 @@ typedef unsigned int       fcp_dl_t;
 /* timeout for name-server lookup (in seconds) */
 #define ZFCP_NS_GID_PN_TIMEOUT		10
 
-/* largest SCSI command we can process */
-/* FCP-2 (FCP_CMND IU) allows up to (255-3+16) */
-#define ZFCP_MAX_SCSI_CMND_LENGTH	255
-/* maximum number of commands in LUN queue (tagged queueing) */
-#define ZFCP_CMND_PER_LUN               32
-
 /* task attribute values in FCP-2 FCP_CMND IU */
 #define SIMPLE_Q	0
 #define HEAD_OF_Q	1
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:01:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:01:46.000000000 +0200
@@ -102,13 +102,8 @@ extern void  zfcp_test_link(struct zfcp_
 extern int  zfcp_adapter_scsi_register(struct zfcp_adapter *);
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
 extern void zfcp_set_fcp_dl(struct fcp_cmnd_iu *, fcp_dl_t);
-extern char *zfcp_get_fcp_rsp_info_ptr(struct fcp_rsp_iu *);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
-extern fcp_dl_t zfcp_get_fcp_dl(struct fcp_cmnd_iu *);
 
-extern int zfcp_scsi_command_async(struct zfcp_adapter *,struct zfcp_unit *,
-				   struct scsi_cmnd *, int);
-extern int zfcp_scsi_command_sync(struct zfcp_unit *, struct scsi_cmnd *, int);
 extern struct fc_function_template zfcp_transport_functions;
 
 /******************************** ERP ****************************************/
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-30 11:01:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-30 11:01:46.000000000 +0200
@@ -1065,8 +1065,7 @@ static void zfcp_scsi_dbf_event(const ch
 			if (fsf_req != NULL) {
 				fcp_rsp = (struct fcp_rsp_iu *)
 				    &(fsf_req->qtcb->bottom.io.fcp_rsp);
-				fcp_rsp_info =
-				    zfcp_get_fcp_rsp_info_ptr(fcp_rsp);
+				fcp_rsp_info = (unsigned char *) &fcp_rsp[1];
 				fcp_sns_info =
 				    zfcp_get_fcp_sns_info_ptr(fcp_rsp);
 
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:01:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:01:46.000000000 +0200
@@ -3027,7 +3027,7 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
 	u32 sns_len;
-	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
+	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 	unsigned long flags;
 
 	read_lock_irqsave(&fsf_req->adapter->abort_lock, flags);
@@ -3145,7 +3145,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	int retval = 0;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
-	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
+	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;

-- 
