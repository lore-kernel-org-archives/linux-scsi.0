From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.28-rc7
Date: Tue, 02 Dec 2008 10:58:56 -0600
Message-ID: <1228237136.3331.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50986 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbYLBQ64 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 11:58:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is quite a hefty update for so late. It includes a slew of block
timer related fixes (we moved to using block timers when the 2.6.28
merge window opened).  The bad news is that I still don't think we have
all the block timer related bugs caught and fixed.  There's also a slew
of zfcp (s390 driver) fixes and a few miscellaneous others (including
another regression bugzilla fix, the hang in starved list processing).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Christof Schmitt (1):
      zfcp: Fix opening of wka ports

James Bottomley (5):
      stex: switch to block timeout
      make scsi_eh_try_stu use block timeout
      megaraid_sas: switch to block timeout
      ibmvscsi: switch to block timeout
      aacraid: switch to block timeout

James Smart (1):
      fc_transport: fix old bug on bitflag definitions

Martin Petermann (1):
      zfcp: fix remote port status check

Mike Christie (1):
      Fix hang in starved list processing

Swen Schillig (5):
      zfcp: prevent double decrement on host_busy while being busy
      zfcp: fix deadlock between wq triggered port scan and ERP
      zfcp: eliminate race between validation and locking
      zfcp: verify for correct rport state before scanning for SCSI devs
      zfcp: returning an ERR_PTR where a NULL value is expected

And the diffstat:

 drivers/s390/scsi/zfcp_erp.c         |    7 +++++--
 drivers/s390/scsi/zfcp_fc.c          |    7 +++----
 drivers/s390/scsi/zfcp_fsf.c         |   20 ++++++++++++++------
 drivers/s390/scsi/zfcp_scsi.c        |    2 +-
 drivers/scsi/aacraid/linit.c         |    4 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c     |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c |    3 ++-
 drivers/scsi/scsi_error.c            |    3 +--
 drivers/scsi/scsi_lib.c              |   23 +++++++++++------------
 drivers/scsi/stex.c                  |    2 +-
 include/scsi/scsi_transport_fc.h     |    2 +-
 11 files changed, 42 insertions(+), 33 deletions(-)

The entire diff is below.

James

---

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 35364f6..c557ba3 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -720,7 +720,6 @@ static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *act,
 		goto failed_openfcp;
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &act->adapter->status);
-	schedule_work(&act->adapter->scan_work);
 
 	return ZFCP_ERP_SUCCEEDED;
 
@@ -1186,7 +1185,9 @@ static void zfcp_erp_scsi_scan(struct work_struct *work)
 		container_of(work, struct zfcp_erp_add_work, work);
 	struct zfcp_unit *unit = p->unit;
 	struct fc_rport *rport = unit->port->rport;
-	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+
+	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
+		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
 			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
 	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	zfcp_unit_put(unit);
@@ -1282,6 +1283,8 @@ static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (result != ZFCP_ERP_SUCCEEDED)
 			zfcp_erp_rports_del(adapter);
+		else
+			schedule_work(&adapter->scan_work);
 		zfcp_adapter_put(adapter);
 		break;
 	}
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 1a7c80a..8aab309 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -50,7 +50,8 @@ static int zfcp_wka_port_get(struct zfcp_wka_port *wka_port)
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
 
-	if (wka_port->status != ZFCP_WKA_PORT_ONLINE) {
+	if (wka_port->status == ZFCP_WKA_PORT_OFFLINE ||
+	    wka_port->status == ZFCP_WKA_PORT_CLOSING) {
 		wka_port->status = ZFCP_WKA_PORT_OPENING;
 		if (zfcp_fsf_open_wka_port(wka_port))
 			wka_port->status = ZFCP_WKA_PORT_OFFLINE;
@@ -125,8 +126,7 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
-		/* FIXME: ZFCP_STATUS_PORT_DID_DID check is racy */
-		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_DID_DID))
+		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_PHYS_OPEN))
 			/* Try to connect to unused ports anyway. */
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -610,7 +610,6 @@ int zfcp_scan_ports(struct zfcp_adapter *adapter)
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
 
-	zfcp_erp_wait(adapter); /* wait until adapter is finished with ERP */
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index d024442..dc03676 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -930,8 +930,10 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				  req_flags, adapter->pool.fsf_req_abort);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		req = NULL;
 		goto out;
+	}
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
@@ -1584,6 +1586,7 @@ static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 		break;
 	case FSF_PORT_ALREADY_OPEN:
+		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
 		wka_port->status = ZFCP_WKA_PORT_ONLINE;
@@ -2113,18 +2116,21 @@ static inline void zfcp_fsf_trace_latency(struct zfcp_fsf_req *fsf_req)
 
 static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 {
-	struct scsi_cmnd *scpnt = req->data;
+	struct scsi_cmnd *scpnt;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(req->qtcb->bottom.io.fcp_rsp);
 	u32 sns_len;
 	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 	unsigned long flags;
 
-	if (unlikely(!scpnt))
-		return;
-
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
 
+	scpnt = req->data;
+	if (unlikely(!scpnt)) {
+		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
+		return;
+	}
+
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
 		set_host_byte(scpnt, DID_SOFT_ERROR);
 		set_driver_byte(scpnt, SUGGEST_RETRY);
@@ -2442,8 +2448,10 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *adapter,
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		req = NULL;
 		goto out;
+	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
 	req->data = unit;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index e46fd3e..468c880 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -88,7 +88,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	ret = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, 0,
 					     ZFCP_REQ_AUTO_CLEANUP);
 	if (unlikely(ret == -EBUSY))
-		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (unlikely(ret < 0))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9aa301c..162cd92 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -427,8 +427,8 @@ static int aac_slave_configure(struct scsi_device *sdev)
 		 * Firmware has an individual device recovery time typically
 		 * of 35 seconds, give us a margin.
 		 */
-		if (sdev->timeout < (45 * HZ))
-			sdev->timeout = 45 * HZ;
+		if (sdev->request_queue->rq_timeout < (45 * HZ))
+			blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
 		for (cid = 0; cid < aac->maximum_num_containers; ++cid)
 			if (aac->fsa_dev[cid].valid)
 				++num_lsu;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 87e09f3..6cad175 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1442,7 +1442,7 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
-		sdev->timeout = 60 * HZ;
+		blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 	}
 	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index a454f94..17ce7ab 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1016,7 +1016,8 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	 * The RAID firmware may require extended timeouts.
 	 */
 	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-		sdev->timeout = MEGASAS_DEFAULT_CMD_TIMEOUT * HZ;
+		blk_queue_rq_timeout(sdev->request_queue,
+				     MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3863617..edfaf24 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -932,8 +932,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 		int i, rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
-			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
-						scmd->device->timeout, 0);
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
 
 		if (rtn == SUCCESS)
 			return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..fa45a1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -567,15 +567,18 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
+	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
+	LIST_HEAD(starved_list);
 	unsigned long flags;
 
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost)) {
+	list_splice_init(&shost->starved_list, &starved_list);
+
+	while (!list_empty(&starved_list)) {
 		int flagset;
 
 		/*
@@ -588,24 +591,18 @@ static void scsi_run_queue(struct request_queue *q)
 		 * scsi_request_fn must get the host_lock before checking
 		 * or modifying starved_list or starved_entry.
 		 */
-		sdev = list_entry(shost->starved_list.next,
-					  struct scsi_device, starved_entry);
-		/*
-		 * The *queue_ready functions can add a device back onto the
-		 * starved list's tail, so we must check for a infinite loop.
-		 */
-		if (sdev == starved_head)
+		if (scsi_host_is_busy(shost))
 			break;
-		if (!starved_head)
-			starved_head = sdev;
 
+		sdev = list_entry(starved_list.next,
+				  struct scsi_device, starved_entry);
+		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
 			list_move_tail(&sdev->starved_entry,
 				       &shost->starved_list);
 			continue;
 		}
 
-		list_del_init(&sdev->starved_entry);
 		spin_unlock(shost->host_lock);
 
 		spin_lock(sdev->request_queue->queue_lock);
@@ -621,6 +618,8 @@ static void scsi_run_queue(struct request_queue *q)
 
 		spin_lock(shost->host_lock);
 	}
+	/* put any unprocessed entries back */
+	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	blk_run_queue(q);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 3790906..2fa830c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -477,7 +477,7 @@ stex_slave_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
-	sdev->timeout = 60 * HZ;
+	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 	sdev->tagged_supported = 1;
 
 	return 0;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 49d8913..6e04e6f 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -357,7 +357,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 /* bit field values for struct fc_rport "flags" field: */
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
-#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x03
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)


