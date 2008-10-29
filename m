From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ibmvfc: Error handling fixes
Date: Wed, 29 Oct 2008 08:46:41 -0500
Message-ID: <200810291347.m9TDl92d027333@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47788 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbYJ2NrX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 09:47:23 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9TDlBiu015654
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:11 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDlLOO065946
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:21 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDlC6O027434
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Due to an ambiguity in the VIOS VFC interface specification, abort/cancel
handling is not done correctly and can result in double completion of
commands. In order to cancel all outstanding commands to a device, a cancel
must be sent, followed by an abort task set. After the responses are received
for these commands, there may still be commands outstanding, in the process
of getting flushed back, in which case, we need to wait for them. This patch
removes the assumption that if the abort and the cancel both complete successfully
that the device queue has been flushed and waits for all the responses to
come back.


Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |  207 +++++++++++++++++++++++++++++------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 
 2 files changed, 148 insertions(+), 61 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_fixes drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_fixes	2008-10-24 08:41:00.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-10-27 09:44:08.000000000 -0500
@@ -758,6 +758,9 @@ static void ibmvfc_scsi_eh_done(struct i
 		cmnd->scsi_done(cmnd);
 	}
 
+	if (evt->eh_comp)
+		complete(evt->eh_comp);
+
 	ibmvfc_free_event(evt);
 }
 
@@ -1245,6 +1248,7 @@ static void ibmvfc_init_event(struct ibm
 	evt->sync_iu = NULL;
 	evt->crq.format = format;
 	evt->done = done;
+	evt->eh_comp = NULL;
 }
 
 /**
@@ -1485,6 +1489,9 @@ static void ibmvfc_scsi_done(struct ibmv
 		cmnd->scsi_done(cmnd);
 	}
 
+	if (evt->eh_comp)
+		complete(evt->eh_comp);
+
 	ibmvfc_free_event(evt);
 }
 
@@ -1785,7 +1792,8 @@ static int ibmvfc_abort_task_set(struct 
 static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
 {
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct scsi_target *starget = scsi_target(sdev);
+	struct fc_rport *rport = starget_to_rport(starget);
 	struct ibmvfc_tmf *tmf;
 	struct ibmvfc_event *evt, *found_evt;
 	union ibmvfc_iu rsp;
@@ -1823,7 +1831,7 @@ static int ibmvfc_cancel_all(struct scsi
 		int_to_scsilun(sdev->lun, &tmf->lun);
 		tmf->flags = (type | IBMVFC_TMF_LUA_VALID);
 		tmf->cancel_key = (unsigned long)sdev->hostdata;
-		tmf->my_cancel_key = (IBMVFC_TMF_CANCEL_KEY | (unsigned long)sdev->hostdata);
+		tmf->my_cancel_key = (unsigned long)starget->hostdata;
 
 		evt->sync_iu = &rsp;
 		init_completion(&evt->comp);
@@ -1855,6 +1863,91 @@ static int ibmvfc_cancel_all(struct scsi
 }
 
 /**
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
+
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
+
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
+	signed long timeout = init_timeout * HZ;
+
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
+
+		if (wait) {
+			timeout = wait_for_completion_timeout(&comp, timeout);
+
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
+
+	LEAVE;
+	return SUCCESS;
+}
+
+/**
  * ibmvfc_eh_abort_handler - Abort a command
  * @cmd:	scsi command to abort
  *
@@ -1863,29 +1956,21 @@ static int ibmvfc_cancel_all(struct scsi
  **/
 static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
-	struct ibmvfc_event *evt, *pos;
+	struct scsi_device *sdev = cmd->device;
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, abort_rc;
-	unsigned long flags;
+	int rc = FAILED;
 
 	ENTER;
 	ibmvfc_wait_while_resetting(vhost);
-	cancel_rc = ibmvfc_cancel_all(cmd->device, IBMVFC_TMF_ABORT_TASK_SET);
-	abort_rc = ibmvfc_abort_task_set(cmd->device);
+	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+	abort_rc = ibmvfc_abort_task_set(sdev);
 
-	if (!cancel_rc && !abort_rc) {
-		spin_lock_irqsave(vhost->host->host_lock, flags);
-		list_for_each_entry_safe(evt, pos, &vhost->sent, queue) {
-			if (evt->cmnd && evt->cmnd->device == cmd->device)
-				ibmvfc_fail_request(evt, DID_ABORT);
-		}
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		LEAVE;
-		return SUCCESS;
-	}
+	if (!cancel_rc && !abort_rc)
+		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
 
 	LEAVE;
-	return FAILED;
+	return rc;
 }
 
 /**
@@ -1897,29 +1982,21 @@ static int ibmvfc_eh_abort_handler(struc
  **/
 static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
-	struct ibmvfc_event *evt, *pos;
+	struct scsi_device *sdev = cmd->device;
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, reset_rc;
-	unsigned long flags;
+	int rc = FAILED;
 
 	ENTER;
 	ibmvfc_wait_while_resetting(vhost);
-	cancel_rc = ibmvfc_cancel_all(cmd->device, IBMVFC_TMF_LUN_RESET);
-	reset_rc = ibmvfc_reset_device(cmd->device, IBMVFC_LUN_RESET, "LUN");
+	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
+	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
 
-	if (!cancel_rc && !reset_rc) {
-		spin_lock_irqsave(vhost->host->host_lock, flags);
-		list_for_each_entry_safe(evt, pos, &vhost->sent, queue) {
-			if (evt->cmnd && evt->cmnd->device == cmd->device)
-				ibmvfc_fail_request(evt, DID_ABORT);
-		}
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		LEAVE;
-		return SUCCESS;
-	}
+	if (!cancel_rc && !reset_rc)
+		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
 
 	LEAVE;
-	return FAILED;
+	return rc;
 }
 
 /**
@@ -1955,31 +2032,23 @@ static void ibmvfc_dev_abort_all(struct 
  **/
 static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
-	struct scsi_target *starget = scsi_target(cmd->device);
-	struct ibmvfc_event *evt, *pos;
+	struct scsi_device *sdev = cmd->device;
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct scsi_target *starget = scsi_target(sdev);
 	int reset_rc;
+	int rc = FAILED;
 	unsigned long cancel_rc = 0;
-	unsigned long flags;
 
 	ENTER;
 	ibmvfc_wait_while_resetting(vhost);
 	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all);
-	reset_rc = ibmvfc_reset_device(cmd->device, IBMVFC_TARGET_RESET, "target");
+	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
 
-	if (!cancel_rc && !reset_rc) {
-		spin_lock_irqsave(vhost->host->host_lock, flags);
-		list_for_each_entry_safe(evt, pos, &vhost->sent, queue) {
-			if (evt->cmnd && scsi_target(evt->cmnd->device) == starget)
-				ibmvfc_fail_request(evt, DID_ABORT);
-		}
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		LEAVE;
-		return SUCCESS;
-	}
+	if (!cancel_rc && !reset_rc)
+		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
 
 	LEAVE;
-	return FAILED;
+	return rc;
 }
 
 /**
@@ -2009,23 +2078,18 @@ static void ibmvfc_terminate_rport_io(st
 	struct scsi_target *starget = to_scsi_target(&rport->dev);
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	struct ibmvfc_event *evt, *pos;
 	unsigned long cancel_rc = 0;
 	unsigned long abort_rc = 0;
-	unsigned long flags;
+	int rc = FAILED;
 
 	ENTER;
 	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all);
 	starget_for_each_device(starget, &abort_rc, ibmvfc_dev_abort_all);
 
-	if (!cancel_rc && !abort_rc) {
-		spin_lock_irqsave(shost->host_lock, flags);
-		list_for_each_entry_safe(evt, pos, &vhost->sent, queue) {
-			if (evt->cmnd && scsi_target(evt->cmnd->device) == starget)
-				ibmvfc_fail_request(evt, DID_ABORT);
-		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
-	} else
+	if (!cancel_rc && !abort_rc)
+		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
+
+	if (rc == FAILED)
 		ibmvfc_issue_fc_host_lip(shost);
 	LEAVE;
 }
@@ -2259,6 +2323,28 @@ static int ibmvfc_slave_alloc(struct scs
 }
 
 /**
+ * ibmvfc_target_alloc - Setup the target's task set value
+ * @starget:	struct scsi_target
+ *
+ * Set the target's task set value so that error handling works as
+ * expected.
+ *
+ * Returns:
+ *	0 on success / -ENXIO if device does not exist
+ **/
+static int ibmvfc_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ibmvfc_host *vhost = shost_priv(shost);
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget->hostdata = (void *)(unsigned long)vhost->task_set++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return 0;
+}
+
+/**
  * ibmvfc_slave_configure - Configure the device
  * @sdev:	struct scsi_device device to configure
  *
@@ -2537,6 +2623,7 @@ static struct scsi_host_template driver_
 	.eh_host_reset_handler = ibmvfc_eh_host_reset_handler,
 	.slave_alloc = ibmvfc_slave_alloc,
 	.slave_configure = ibmvfc_slave_configure,
+	.target_alloc = ibmvfc_target_alloc,
 	.scan_finished = ibmvfc_scan_finished,
 	.change_queue_depth = ibmvfc_change_queue_depth,
 	.change_queue_type = ibmvfc_change_queue_type,
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_abort_fixes drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_abort_fixes	2008-10-24 08:41:00.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-10-27 09:44:08.000000000 -0500
@@ -337,7 +337,6 @@ struct ibmvfc_tmf {
 #define IBMVFC_TMF_LUA_VALID		0x40
 	u32 cancel_key;
 	u32 my_cancel_key;
-#define IBMVFC_TMF_CANCEL_KEY		0x80000000
 	u32 pad;
 	u64 reserved[2];
 }__attribute__((packed, aligned (8)));
@@ -606,6 +605,7 @@ struct ibmvfc_event {
 	struct srp_direct_buf *ext_list;
 	dma_addr_t ext_list_token;
 	struct completion comp;
+	struct completion *eh_comp;
 	struct timer_list timer;
 };
 
_
