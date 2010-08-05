From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvfc: Fix terminate_rport_io
Date: Thu, 05 Aug 2010 16:38:34 -0500
Message-ID: <201008052138.o75LcXIW012942@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60219 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab0HEVim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 17:38:42 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o75LSmUJ001364
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:28:48 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o75LcZrS129900
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o75LcYFD013037
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver was incorrectly obtaining a scsi_target pointer
from an fc_rport. The way it is coded ensures that ibmvfc's
terminate_rport_io handler does absolutely nothing. Fix this up
to iterate through affected devices differently, sending cancel
and abort task set as appropriate. Without this patch,
fast_io_fail_tmo is broken for ibmvfc.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |  372 ++++++++++++++++++++++-------------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 
 2 files changed, 204 insertions(+), 169 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_terminate_io_fixup2 drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_terminate_io_fixup2	2010-08-05 12:52:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-08-05 12:53:16.000000000 -0500
@@ -2039,95 +2039,108 @@ static int ibmvfc_reset_device(struct sc
 }
 
 /**
- * ibmvfc_abort_task_set - Abort outstanding commands to the device
- * @sdev:	scsi device to abort commands
- *
- * This sends an Abort Task Set to the VIOS for the specified device. This does
- * NOT send any cancel to the VIOS. That must be done separately.
+ * ibmvfc_match_rport - Match function for specified remote port
+ * @evt:	ibmvfc event struct
+ * @device:	device to match (rport)
  *
  * Returns:
- *	0 on success / other on failure
+ *	1 if event matches rport / 0 if event does not match rport
  **/
-static int ibmvfc_abort_task_set(struct scsi_device *sdev)
+static int ibmvfc_match_rport(struct ibmvfc_event *evt, void *rport)
 {
-	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	struct ibmvfc_cmd *tmf;
-	struct ibmvfc_event *evt, *found_evt;
-	union ibmvfc_iu rsp_iu;
-	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.rsp;
-	int rsp_rc = -EBUSY;
-	unsigned long flags;
-	int rsp_code = 0;
-
-	spin_lock_irqsave(vhost->host->host_lock, flags);
-	found_evt = NULL;
-	list_for_each_entry(evt, &vhost->sent, queue) {
-		if (evt->cmnd && evt->cmnd->device == sdev) {
-			found_evt = evt;
-			break;
-		}
-	}
-
-	if (!found_evt) {
-		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
-			sdev_printk(KERN_INFO, sdev, "No events found to abort\n");
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		return 0;
-	}
-
-	if (vhost->state == IBMVFC_ACTIVE) {
-		evt = ibmvfc_get_event(vhost);
-		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
-
-		tmf = &evt->iu.cmd;
-		memset(tmf, 0, sizeof(*tmf));
-		tmf->resp.va = (u64)evt->crq.ioba + offsetof(struct ibmvfc_cmd, rsp);
-		tmf->resp.len = sizeof(tmf->rsp);
-		tmf->frame_type = IBMVFC_SCSI_FCP_TYPE;
-		tmf->payload_len = sizeof(tmf->iu);
-		tmf->resp_len = sizeof(tmf->rsp);
-		tmf->cancel_key = (unsigned long)sdev->hostdata;
-		tmf->tgt_scsi_id = rport->port_id;
-		int_to_scsilun(sdev->lun, &tmf->iu.lun);
-		tmf->flags = (IBMVFC_NO_MEM_DESC | IBMVFC_TMF);
-		tmf->iu.tmf_flags = IBMVFC_ABORT_TASK_SET;
-		evt->sync_iu = &rsp_iu;
+	struct fc_rport *cmd_rport;
 
-		init_completion(&evt->comp);
-		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
+	if (evt->cmnd) {
+		cmd_rport = starget_to_rport(scsi_target(evt->cmnd->device));
+		if (cmd_rport == rport)
+			return 1;
 	}
+	return 0;
+}
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+/**
+ * ibmvfc_match_target - Match function for specified target
+ * @evt:	ibmvfc event struct
+ * @device:	device to match (starget)
+ *
+ * Returns:
+ *	1 if event matches starget / 0 if event does not match starget
+ **/
+static int ibmvfc_match_target(struct ibmvfc_event *evt, void *device)
+{
+	if (evt->cmnd && scsi_target(evt->cmnd->device) == device)
+		return 1;
+	return 0;
+}
 
-	if (rsp_rc != 0) {
-		sdev_printk(KERN_ERR, sdev, "Failed to send abort. rc=%d\n", rsp_rc);
-		return -EIO;
-	}
+/**
+ * ibmvfc_match_lun - Match function for specified LUN
+ * @evt:	ibmvfc event struct
+ * @device:	device to match (sdev)
+ *
+ * Returns:
+ *	1 if event matches sdev / 0 if event does not match sdev
+ **/
+static int ibmvfc_match_lun(struct ibmvfc_event *evt, void *device)
+{
+	if (evt->cmnd && evt->cmnd->device == device)
+		return 1;
+	return 0;
+}
 
-	sdev_printk(KERN_INFO, sdev, "Aborting outstanding commands\n");
-	wait_for_completion(&evt->comp);
+/**
+ * ibmvfc_wait_for_ops - Wait for ops to complete
+ * @vhost:	ibmvfc host struct
+ * @device:	device to match (starget or sdev)
+ * @match:	match function
+ *
+ * Returns:
+ *	SUCCESS / FAILED
+ **/
+static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
+			       int (*match) (struct ibmvfc_event *, void *))
+{
+	struct ibmvfc_event *evt;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	int wait;
+	unsigned long flags;
+	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
 
-	if (rsp_iu.cmd.status)
-		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+	ENTER;
+	do {
+		wait = 0;
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		list_for_each_entry(evt, &vhost->sent, queue) {
+			if (match(evt, device)) {
+				evt->eh_comp = &comp;
+				wait++;
+			}
+		}
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	if (rsp_code) {
-		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
-			rsp_code = fc_rsp->data.info.rsp_code;
+		if (wait) {
+			timeout = wait_for_completion_timeout(&comp, timeout);
 
-		sdev_printk(KERN_ERR, sdev, "Abort failed: %s (%x:%x) "
-			    "flags: %x fcp_rsp: %x, scsi_status: %x\n",
-			    ibmvfc_get_cmd_error(rsp_iu.cmd.status, rsp_iu.cmd.error),
-			    rsp_iu.cmd.status, rsp_iu.cmd.error, fc_rsp->flags, rsp_code,
-			    fc_rsp->scsi_status);
-		rsp_rc = -EIO;
-	} else
-		sdev_printk(KERN_INFO, sdev, "Abort successful\n");
+			if (!timeout) {
+				wait = 0;
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				list_for_each_entry(evt, &vhost->sent, queue) {
+					if (match(evt, device)) {
+						evt->eh_comp = NULL;
+						wait++;
+					}
+				}
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				if (wait)
+					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
+				LEAVE;
+				return wait ? FAILED : SUCCESS;
+			}
+		}
+	} while (wait);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
-	ibmvfc_free_event(evt);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	return rsp_rc;
+	LEAVE;
+	return SUCCESS;
 }
 
 /**
@@ -2215,88 +2228,130 @@ static int ibmvfc_cancel_all(struct scsi
 }
 
 /**
- * ibmvfc_match_target - Match function for specified target
+ * ibmvfc_match_key - Match function for specified cancel key
  * @evt:	ibmvfc event struct
- * @device:	device to match (starget)
+ * @key:	cancel key to match
  *
  * Returns:
- *	1 if event matches starget / 0 if event does not match starget
+ *	1 if event matches key / 0 if event does not match key
  **/
-static int ibmvfc_match_target(struct ibmvfc_event *evt, void *device)
+static int ibmvfc_match_key(struct ibmvfc_event *evt, void *key)
 {
-	if (evt->cmnd && scsi_target(evt->cmnd->device) == device)
-		return 1;
-	return 0;
-}
+	unsigned long cancel_key = (unsigned long)key;
 
-/**
- * ibmvfc_match_lun - Match function for specified LUN
- * @evt:	ibmvfc event struct
- * @device:	device to match (sdev)
- *
- * Returns:
- *	1 if event matches sdev / 0 if event does not match sdev
- **/
-static int ibmvfc_match_lun(struct ibmvfc_event *evt, void *device)
-{
-	if (evt->cmnd && evt->cmnd->device == device)
+	if (evt->crq.format == IBMVFC_CMD_FORMAT &&
+	    evt->iu.cmd.cancel_key == cancel_key)
 		return 1;
 	return 0;
 }
 
 /**
- * ibmvfc_wait_for_ops - Wait for ops to complete
- * @vhost:	ibmvfc host struct
- * @device:	device to match (starget or sdev)
- * @match:	match function
+ * ibmvfc_abort_task_set - Abort outstanding commands to the device
+ * @sdev:	scsi device to abort commands
+ *
+ * This sends an Abort Task Set to the VIOS for the specified device. This does
+ * NOT send any cancel to the VIOS. That must be done separately.
  *
  * Returns:
- *	SUCCESS / FAILED
+ *	0 on success / other on failure
  **/
-static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
-			       int (*match) (struct ibmvfc_event *, void *))
+static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 {
-	struct ibmvfc_event *evt;
-	DECLARE_COMPLETION_ONSTACK(comp);
-	int wait;
-	unsigned long flags;
-	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct ibmvfc_cmd *tmf;
+	struct ibmvfc_event *evt, *found_evt;
+	union ibmvfc_iu rsp_iu;
+	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.rsp;
+	int rc, rsp_rc = -EBUSY;
+	unsigned long flags, timeout = IBMVFC_ABORT_TIMEOUT;
+	int rsp_code = 0;
 
-	ENTER;
-	do {
-		wait = 0;
-		spin_lock_irqsave(vhost->host->host_lock, flags);
-		list_for_each_entry(evt, &vhost->sent, queue) {
-			if (match(evt, device)) {
-				evt->eh_comp = &comp;
-				wait++;
-			}
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	found_evt = NULL;
+	list_for_each_entry(evt, &vhost->sent, queue) {
+		if (evt->cmnd && evt->cmnd->device == sdev) {
+			found_evt = evt;
+			break;
 		}
+	}
+
+	if (!found_evt) {
+		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
+			sdev_printk(KERN_INFO, sdev, "No events found to abort\n");
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return 0;
+	}
 
-		if (wait) {
-			timeout = wait_for_completion_timeout(&comp, timeout);
+	if (vhost->state == IBMVFC_ACTIVE) {
+		evt = ibmvfc_get_event(vhost);
+		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
 
-			if (!timeout) {
-				wait = 0;
-				spin_lock_irqsave(vhost->host->host_lock, flags);
-				list_for_each_entry(evt, &vhost->sent, queue) {
-					if (match(evt, device)) {
-						evt->eh_comp = NULL;
-						wait++;
-					}
-				}
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
-				if (wait)
-					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
-				LEAVE;
-				return wait ? FAILED : SUCCESS;
-			}
+		tmf = &evt->iu.cmd;
+		memset(tmf, 0, sizeof(*tmf));
+		tmf->resp.va = (u64)evt->crq.ioba + offsetof(struct ibmvfc_cmd, rsp);
+		tmf->resp.len = sizeof(tmf->rsp);
+		tmf->frame_type = IBMVFC_SCSI_FCP_TYPE;
+		tmf->payload_len = sizeof(tmf->iu);
+		tmf->resp_len = sizeof(tmf->rsp);
+		tmf->cancel_key = (unsigned long)sdev->hostdata;
+		tmf->tgt_scsi_id = rport->port_id;
+		int_to_scsilun(sdev->lun, &tmf->iu.lun);
+		tmf->flags = (IBMVFC_NO_MEM_DESC | IBMVFC_TMF);
+		tmf->iu.tmf_flags = IBMVFC_ABORT_TASK_SET;
+		evt->sync_iu = &rsp_iu;
+
+		init_completion(&evt->comp);
+		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
+	}
+
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	if (rsp_rc != 0) {
+		sdev_printk(KERN_ERR, sdev, "Failed to send abort. rc=%d\n", rsp_rc);
+		return -EIO;
+	}
+
+	sdev_printk(KERN_INFO, sdev, "Aborting outstanding commands\n");
+	timeout = wait_for_completion_timeout(&evt->comp, timeout);
+
+	if (!timeout) {
+		rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+		if (!rc) {
+			rc = ibmvfc_wait_for_ops(vhost, sdev->hostdata, ibmvfc_match_key);
+			if (rc == SUCCESS)
+				rc = 0;
 		}
-	} while (wait);
 
-	LEAVE;
-	return SUCCESS;
+		if (rc) {
+			sdev_printk(KERN_INFO, sdev, "Cancel failed, resetting host\n");
+			ibmvfc_reset_host(vhost);
+			rsp_rc = 0;
+			goto out;
+		}
+	}
+
+	if (rsp_iu.cmd.status)
+		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+
+	if (rsp_code) {
+		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
+			rsp_code = fc_rsp->data.info.rsp_code;
+
+		sdev_printk(KERN_ERR, sdev, "Abort failed: %s (%x:%x) "
+			    "flags: %x fcp_rsp: %x, scsi_status: %x\n",
+			    ibmvfc_get_cmd_error(rsp_iu.cmd.status, rsp_iu.cmd.error),
+			    rsp_iu.cmd.status, rsp_iu.cmd.error, fc_rsp->flags, rsp_code,
+			    fc_rsp->scsi_status);
+		rsp_rc = -EIO;
+	} else
+		sdev_printk(KERN_INFO, sdev, "Abort successful\n");
+
+out:
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	ibmvfc_free_event(evt);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	return rsp_rc;
 }
 
 /**
@@ -2354,18 +2409,6 @@ static int ibmvfc_eh_device_reset_handle
 }
 
 /**
- * ibmvfc_dev_cancel_all_abts - Device iterated cancel all function
- * @sdev:	scsi device struct
- * @data:	return code
- *
- **/
-static void ibmvfc_dev_cancel_all_abts(struct scsi_device *sdev, void *data)
-{
-	unsigned long *rc = data;
-	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
-}
-
-/**
  * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
  * @sdev:	scsi device struct
  * @data:	return code
@@ -2378,18 +2421,6 @@ static void ibmvfc_dev_cancel_all_reset(
 }
 
 /**
- * ibmvfc_dev_abort_all - Device iterated abort task set function
- * @sdev:	scsi device struct
- * @data:	return code
- *
- **/
-static void ibmvfc_dev_abort_all(struct scsi_device *sdev, void *data)
-{
-	unsigned long *rc = data;
-	*rc |= ibmvfc_abort_task_set(sdev);
-}
-
-/**
  * ibmvfc_eh_target_reset_handler - Reset the target
  * @cmd:	scsi command struct
  *
@@ -2443,19 +2474,22 @@ static int ibmvfc_eh_host_reset_handler(
  **/
 static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 {
-	struct scsi_target *starget = to_scsi_target(&rport->dev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	unsigned long cancel_rc = 0;
-	unsigned long abort_rc = 0;
-	int rc = FAILED;
+	struct fc_rport *dev_rport;
+	struct scsi_device *sdev;
+	unsigned long rc;
 
 	ENTER;
-	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_abts);
-	starget_for_each_device(starget, &abort_rc, ibmvfc_dev_abort_all);
+	shost_for_each_device(sdev, shost) {
+		dev_rport = starget_to_rport(scsi_target(sdev));
+		if (dev_rport != rport)
+			continue;
+		ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+		ibmvfc_abort_task_set(sdev);
+	}
 
-	if (!cancel_rc && !abort_rc)
-		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
+	rc = ibmvfc_wait_for_ops(vhost, rport, ibmvfc_match_rport);
 
 	if (rc == FAILED)
 		ibmvfc_issue_fc_host_lip(shost);
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_terminate_io_fixup2 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_terminate_io_fixup2	2010-08-05 12:52:56.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-08-05 12:53:16.000000000 -0500
@@ -38,6 +38,7 @@
 #define IBMVFC_ADISC_PLUS_CANCEL_TIMEOUT	\
 		(IBMVFC_ADISC_TIMEOUT + IBMVFC_ADISC_CANCEL_TIMEOUT)
 #define IBMVFC_INIT_TIMEOUT		120
+#define IBMVFC_ABORT_TIMEOUT		8
 #define IBMVFC_ABORT_WAIT_TIMEOUT	40
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
_
