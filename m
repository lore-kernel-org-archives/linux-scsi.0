From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.31-rc5
Date: Tue, 04 Aug 2009 16:39:24 +0000
Message-ID: <1249403964.3939.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933065AbZHDQjx@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is basically a bundle of fixes, the largest swathe of which come
from s390 (zfcp).  The rest are miscellaneous handling and one update to
prevent nasty USB fallout from the extended inquiry changes to support
dif/dix.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Christof Schmitt (10):
      zfcp: Fix tracing of request id for abort requests
      zfcp: Add port only once to FC transport class
      zfcp: Recover from stalled outbound queue
      zfcp: Fix erp escalation procedure
      zfcp: Fix logic for physical port close
      zfcp: Use -EIO for SBAL allocation failures
      zfcp: Use unchained mode for small ct and els requests
      zfcp: Use correct flags for zfcp_erp_notify
      zfcp: Return -ENOMEM for allocation failures in zfcp_fsf
      zfcp: Acquire qdio_stat_lock when reading the queue utilization

Karen Higgins (4):
      qla4xxx: Remove hiwat code so scsi eh does not get escalated when we can make progress
      qla4xxx: Fix srb lookup in qla4xxx_eh_device_reset
      qla4xxx: Fix Driver Fault Recovery Completion
      qla4xxx: Correct Extended Sense Data Errors

Martin K. Petersen (1):
      sd: Avoid sending extended inquiry to legacy devices

Mike Christie (2):
      qla4xxx: add timeout handler
      libiscsi: disable bh in and abort handler.

Swen Schillig (3):
      zfcp: Fix wka port processing
      zfcp: avoid double notify in lowmem scenario
      zfcp: Fix invalid command order

Tom Peng (2):
      libsas: fix wide port hotplug issues
      libsas: reuse the original port when hotplugging phys in wide ports

Vasu Dev (1):
      libfc: fix a circular locking warning during sending RRQ

The diffstat is:

 drivers/s390/scsi/zfcp_erp.c       |   68 +++++++++--------
 drivers/s390/scsi/zfcp_fc.c        |    8 --
 drivers/s390/scsi/zfcp_fsf.c       |   56 +++++++++-----
 drivers/s390/scsi/zfcp_scsi.c      |   25 ++++--
 drivers/s390/scsi/zfcp_sysfs.c     |    7 +
 drivers/scsi/libfc/fc_exch.c       |   23 +++--
 drivers/scsi/libiscsi.c            |    4 -
 drivers/scsi/libsas/sas_expander.c |  147 ++++++++++++++++++++++++++-----------
 drivers/scsi/libsas/sas_port.c     |   19 +++-
 drivers/scsi/qla4xxx/ql4_dbg.c     |   15 +--
 drivers/scsi/qla4xxx/ql4_def.h     |    9 +-
 drivers/scsi/qla4xxx/ql4_fw.h      |    7 +
 drivers/scsi/qla4xxx/ql4_iocb.c    |  133 +++++++++++++++------------------
 drivers/scsi/qla4xxx/ql4_isr.c     |  145 +++++++++++++++++++++++++-----------
 drivers/scsi/qla4xxx/ql4_mbx.c     |   10 --
 drivers/scsi/qla4xxx/ql4_os.c      |   40 ++++++----
 drivers/scsi/qla4xxx/ql4_version.h |    2 
 drivers/scsi/sd.c                  |   20 ++++-
 18 files changed, 465 insertions(+), 273 deletions(-)

And the patch is below.

James

---

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 8030e25..c75d6f3 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -553,40 +553,35 @@ static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear,
 		_zfcp_erp_unit_reopen(unit, clear, id, ref);
 }
 
-static void zfcp_erp_strategy_followup_actions(struct zfcp_erp_action *act)
+static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
 {
-	struct zfcp_adapter *adapter = act->adapter;
-	struct zfcp_port *port = act->port;
-	struct zfcp_unit *unit = act->unit;
-	u32 status = act->status;
-
-	/* initiate follow-up actions depending on success of finished action */
 	switch (act->action) {
-
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen_all(adapter, 0, "ersfa_1", NULL);
-		else
-			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_2", NULL);
+		_zfcp_erp_adapter_reopen(act->adapter, 0, "ersff_1", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(port, 0, "ersfa_3", NULL);
-		else
-			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_4", NULL);
+		_zfcp_erp_port_forced_reopen(act->port, 0, "ersff_2", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_unit_reopen_all(port, 0, "ersfa_5", NULL);
-		else
-			_zfcp_erp_port_forced_reopen(port, 0, "ersfa_6", NULL);
+		_zfcp_erp_port_reopen(act->port, 0, "ersff_3", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (status != ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(unit->port, 0, "ersfa_7", NULL);
+		_zfcp_erp_unit_reopen(act->unit, 0, "ersff_4", NULL);
+		break;
+	}
+}
+
+static void zfcp_erp_strategy_followup_success(struct zfcp_erp_action *act)
+{
+	switch (act->action) {
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		_zfcp_erp_port_reopen_all(act->adapter, 0, "ersfs_1", NULL);
+		break;
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		_zfcp_erp_port_reopen(act->port, 0, "ersfs_2", NULL);
+		break;
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		_zfcp_erp_unit_reopen_all(act->port, 0, "ersfs_3", NULL);
 		break;
 	}
 }
@@ -801,7 +796,7 @@ static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
 			return ZFCP_ERP_FAILED;
 
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-		if (status & ZFCP_STATUS_PORT_PHYS_OPEN)
+		if (!(status & ZFCP_STATUS_PORT_PHYS_OPEN))
 			return ZFCP_ERP_SUCCEEDED;
 	}
 	return ZFCP_ERP_FAILED;
@@ -853,11 +848,17 @@ void zfcp_erp_port_strategy_open_lookup(struct work_struct *work)
 					      gid_pn_work);
 
 	retval = zfcp_fc_ns_gid_pn(&port->erp_action);
-	if (retval == -ENOMEM)
-		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_NOMEM);
-	port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
-	if (retval)
-		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_FAILED);
+	if (!retval) {
+		port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
+		goto out;
+	}
+	if (retval == -ENOMEM) {
+		zfcp_erp_notify(&port->erp_action, ZFCP_STATUS_ERP_LOWMEM);
+		goto out;
+	}
+	/* all other error condtions */
+	zfcp_erp_notify(&port->erp_action, 0);
+out:
 	zfcp_port_put(port);
 }
 
@@ -1289,7 +1290,10 @@ static int zfcp_erp_strategy(struct zfcp_erp_action *erp_action)
 	retval = zfcp_erp_strategy_statechange(erp_action, retval);
 	if (retval == ZFCP_ERP_EXIT)
 		goto unlock;
-	zfcp_erp_strategy_followup_actions(erp_action);
+	if (retval == ZFCP_ERP_SUCCEEDED)
+		zfcp_erp_strategy_followup_success(erp_action);
+	if (retval == ZFCP_ERP_FAILED)
+		zfcp_erp_strategy_followup_failed(erp_action);
 
  unlock:
 	write_unlock(&adapter->erp_lock);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 2f0705d..47daebf 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -79,11 +79,9 @@ static int zfcp_wka_port_get(struct zfcp_wka_port *wka_port)
 
 	mutex_unlock(&wka_port->mutex);
 
-	wait_event_timeout(
-		wka_port->completion_wq,
-		wka_port->status == ZFCP_WKA_PORT_ONLINE ||
-		wka_port->status == ZFCP_WKA_PORT_OFFLINE,
-		HZ >> 1);
+	wait_event(wka_port->completion_wq,
+		   wka_port->status == ZFCP_WKA_PORT_ONLINE ||
+		   wka_port->status == ZFCP_WKA_PORT_OFFLINE);
 
 	if (wka_port->status == ZFCP_WKA_PORT_ONLINE) {
 		atomic_inc(&wka_port->refcount);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c57658f..47795fb 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -670,8 +670,11 @@ static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
 			       zfcp_fsf_sbal_check(adapter), 5 * HZ);
 	if (ret > 0)
 		return 0;
-	if (!ret)
+	if (!ret) {
 		atomic_inc(&adapter->qdio_outb_full);
+		/* assume hanging outbound queue, try queue recovery */
+		zfcp_erp_adapter_reopen(adapter, 0, "fsrsg_1", NULL);
+	}
 
 	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;
@@ -722,7 +725,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
 		req = zfcp_fsf_alloc_qtcb(pool);
 
 	if (unlikely(!req))
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 
 	if (adapter->req_no == 0)
 		adapter->req_no++;
@@ -1010,6 +1013,23 @@ skip_fsfstatus:
 		send_ct->handler(send_ct->handler_data);
 }
 
+static void zfcp_fsf_setup_ct_els_unchained(struct qdio_buffer_element *sbale,
+					    struct scatterlist *sg_req,
+					    struct scatterlist *sg_resp)
+{
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
+	sbale[2].addr   = sg_virt(sg_req);
+	sbale[2].length = sg_req->length;
+	sbale[3].addr   = sg_virt(sg_resp);
+	sbale[3].length = sg_resp->length;
+	sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
+}
+
+static int zfcp_fsf_one_sbal(struct scatterlist *sg)
+{
+	return sg_is_last(sg) && sg->length <= PAGE_SIZE;
+}
+
 static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 				       struct scatterlist *sg_req,
 				       struct scatterlist *sg_resp,
@@ -1020,30 +1040,30 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 	int bytes;
 
 	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS)) {
-		if (sg_req->length > PAGE_SIZE || sg_resp->length > PAGE_SIZE ||
-		    !sg_is_last(sg_req) || !sg_is_last(sg_resp))
+		if (!zfcp_fsf_one_sbal(sg_req) || !zfcp_fsf_one_sbal(sg_resp))
 			return -EOPNOTSUPP;
 
-		sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
-		sbale[2].addr   = sg_virt(sg_req);
-		sbale[2].length = sg_req->length;
-		sbale[3].addr   = sg_virt(sg_resp);
-		sbale[3].length = sg_resp->length;
-		sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
+		zfcp_fsf_setup_ct_els_unchained(sbale, sg_req, sg_resp);
+		return 0;
+	}
+
+	/* use single, unchained SBAL if it can hold the request */
+	if (zfcp_fsf_one_sbal(sg_req) && zfcp_fsf_one_sbal(sg_resp)) {
+		zfcp_fsf_setup_ct_els_unchained(sbale, sg_req, sg_resp);
 		return 0;
 	}
 
 	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
-		return -ENOMEM;
+		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
 	req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
 
 	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	if (bytes <= 0)
-		return -ENOMEM;
+		return -EIO;
 	req->qtcb->bottom.support.resp_buf_length = bytes;
 
 	return 0;
@@ -1607,10 +1627,10 @@ static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 	case FSF_ACCESS_DENIED:
 		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 		break;
-	case FSF_PORT_ALREADY_OPEN:
-		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
+		/* fall through */
+	case FSF_PORT_ALREADY_OPEN:
 		wka_port->status = ZFCP_WKA_PORT_ONLINE;
 	}
 out:
@@ -1731,15 +1751,16 @@ static void zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *req)
 		zfcp_fsf_access_denied_port(req, port);
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, "fscpph2", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		list_for_each_entry(unit, &port->unit_list_head, list)
 			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 					  &unit->status);
+		zfcp_erp_port_boxed(port, "fscpph2", req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
+
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
@@ -2541,7 +2562,6 @@ struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 	bytes = zfcp_qdio_sbals_from_sg(req, direction, fsf_cfdc->sg,
 					FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
-		retval = -ENOMEM;
 		zfcp_fsf_req_free(req);
 		goto out;
 	}
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 967ede7..6925a17 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -167,20 +167,21 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
-	unsigned long old_req_id = (unsigned long) scpnt->host_scribble;
+	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS;
 	int retry = 3;
+	char *dbf_tag;
 
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
 	spin_lock(&adapter->req_list_lock);
-	old_req = zfcp_reqlist_find(adapter, old_req_id);
+	old_req = zfcp_reqlist_find(adapter, old_reqid);
 	spin_unlock(&adapter->req_list_lock);
 	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
-					  old_req_id);
+					  old_reqid);
 		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
@@ -189,7 +190,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 
 	while (retry--) {
-		abrt_req = zfcp_fsf_abort_fcp_command(old_req_id, unit);
+		abrt_req = zfcp_fsf_abort_fcp_command(old_reqid, unit);
 		if (abrt_req)
 			break;
 
@@ -197,7 +198,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
-						  old_req_id);
+						  old_reqid);
 			return SUCCESS;
 		}
 	}
@@ -208,13 +209,14 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		   abrt_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
 	if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED)
-		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "okay";
 	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
-		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "lte2";
 	else {
-		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "fail";
 		retval = FAILED;
 	}
+	zfcp_scsi_dbf_event_abort(dbf_tag, adapter, scpnt, abrt_req, old_reqid);
 	zfcp_fsf_req_free(abrt_req);
 	return retval;
 }
@@ -534,6 +536,9 @@ static void zfcp_scsi_rport_register(struct zfcp_port *port)
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 
+	if (port->rport)
+		return;
+
 	ids.node_name = port->wwnn;
 	ids.port_name = port->wwpn;
 	ids.port_id = port->d_id;
@@ -557,8 +562,10 @@ static void zfcp_scsi_rport_block(struct zfcp_port *port)
 {
 	struct fc_rport *rport = port->rport;
 
-	if (rport)
+	if (rport) {
 		fc_remote_port_delete(rport);
+		port->rport = NULL;
+	}
 }
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 3e51e64..0fe5cce 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -494,9 +494,14 @@ static ssize_t zfcp_sysfs_adapter_q_full_show(struct device *dev,
 	struct Scsi_Host *scsi_host = class_to_shost(dev);
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
+	u64 util;
+
+	spin_lock_bh(&adapter->qdio_stat_lock);
+	util = adapter->req_q_util;
+	spin_unlock_bh(&adapter->qdio_stat_lock);
 
 	return sprintf(buf, "%d %llu\n", atomic_read(&adapter->qdio_outb_full),
-		       (unsigned long long)adapter->req_q_util);
+		       (unsigned long long)util);
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 2bc22be..145ab9b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -415,9 +415,9 @@ static void fc_exch_timeout(struct work_struct *work)
 	e_stat = ep->esb_stat;
 	if (e_stat & ESB_ST_COMPLETE) {
 		ep->esb_stat = e_stat & ~ESB_ST_REC_QUAL;
+		spin_unlock_bh(&ep->ex_lock);
 		if (e_stat & ESB_ST_REC_QUAL)
 			fc_exch_rrq(ep);
-		spin_unlock_bh(&ep->ex_lock);
 		goto done;
 	} else {
 		resp = ep->resp;
@@ -1624,14 +1624,14 @@ static void fc_exch_rrq(struct fc_exch *ep)
 	struct fc_lport *lp;
 	struct fc_els_rrq *rrq;
 	struct fc_frame *fp;
-	struct fc_seq *rrq_sp;
 	u32 did;
 
 	lp = ep->lp;
 
 	fp = fc_frame_alloc(lp, sizeof(*rrq));
 	if (!fp)
-		return;
+		goto retry;
+
 	rrq = fc_frame_payload_get(fp, sizeof(*rrq));
 	memset(rrq, 0, sizeof(*rrq));
 	rrq->rrq_cmd = ELS_RRQ;
@@ -1647,13 +1647,20 @@ static void fc_exch_rrq(struct fc_exch *ep)
 		       fc_host_port_id(lp->host), FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
-	rrq_sp = fc_exch_seq_send(lp, fp, fc_exch_rrq_resp, NULL, ep,
-				  lp->e_d_tov);
-	if (!rrq_sp) {
-		ep->esb_stat |= ESB_ST_REC_QUAL;
-		fc_exch_timer_set_locked(ep, ep->r_a_tov);
+	if (fc_exch_seq_send(lp, fp, fc_exch_rrq_resp, NULL, ep, lp->e_d_tov))
+		return;
+
+retry:
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE)) {
+		spin_unlock_bh(&ep->ex_lock);
+		/* drop hold for rec qual */
+		fc_exch_release(ep);
 		return;
 	}
+	ep->esb_stat |= ESB_ST_REC_QUAL;
+	fc_exch_timer_set_locked(ep, ep->r_a_tov);
+	spin_unlock_bh(&ep->ex_lock);
 }
 
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 716cc34..a751f62 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1974,10 +1974,10 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * good and have never sent us a successful tmf response
 		 * then sent more data for the cmd.
 		 */
-		spin_lock(&session->lock);
+		spin_lock_bh(&session->lock);
 		fail_scsi_task(task, DID_ABORT);
 		conn->tmf_state = TMF_INITIAL;
-		spin_unlock(&session->lock);
+		spin_unlock_bh(&session->lock);
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 54fa1e4..b338195 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -766,6 +766,7 @@ static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,
 			    SAS_ADDR_SIZE) && ephy->port) {
 			sas_port_add_phy(ephy->port, phy->phy);
+			phy->port = ephy->port;
 			phy->phy_state = PHY_DEVICE_DISCOVERED;
 			return 0;
 		}
@@ -945,11 +946,21 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 			if (ex->ex_phy[i].phy_state == PHY_VACANT ||
 			    ex->ex_phy[i].phy_state == PHY_NOT_PRESENT)
 				continue;
-
+			/*
+			 * Due to races, the phy might not get added to the
+			 * wide port, so we add the phy to the wide port here.
+			 */
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
-			    SAS_ADDR(child->sas_addr))
+			    SAS_ADDR(child->sas_addr)) {
 				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
+				res = sas_ex_join_wide_port(dev, i);
+				if (!res)
+					SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
+						    i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
+
+			}
 		}
+		res = 0;
 	}
 
 	return res;
@@ -1598,7 +1609,7 @@ static int sas_get_phy_attached_sas_addr(struct domain_device *dev,
 }
 
 static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
-			      int from_phy)
+			      int from_phy, bool update)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int res = 0;
@@ -1611,7 +1622,9 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 		if (res)
 			goto out;
 		else if (phy_change_count != ex->ex_phy[i].phy_change_count) {
-			ex->ex_phy[i].phy_change_count = phy_change_count;
+			if (update)
+				ex->ex_phy[i].phy_change_count =
+					phy_change_count;
 			*phy_id = i;
 			return 0;
 		}
@@ -1653,31 +1666,52 @@ out:
 	kfree(rg_req);
 	return res;
 }
+/**
+ * sas_find_bcast_dev -  find the device issue BROADCAST(CHANGE).
+ * @dev:domain device to be detect.
+ * @src_dev: the device which originated BROADCAST(CHANGE).
+ *
+ * Add self-configuration expander suport. Suppose two expander cascading,
+ * when the first level expander is self-configuring, hotplug the disks in
+ * second level expander, BROADCAST(CHANGE) will not only be originated
+ * in the second level expander, but also be originated in the first level
+ * expander (see SAS protocol SAS 2r-14, 7.11 for detail), it is to say,
+ * expander changed count in two level expanders will all increment at least
+ * once, but the phy which chang count has changed is the source device which
+ * we concerned.
+ */
 
 static int sas_find_bcast_dev(struct domain_device *dev,
 			      struct domain_device **src_dev)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int ex_change_count = -1;
+	int phy_id = -1;
 	int res;
+	struct domain_device *ch;
 
 	res = sas_get_ex_change_count(dev, &ex_change_count);
 	if (res)
 		goto out;
-	if (ex_change_count != -1 &&
-	    ex_change_count != ex->ex_change_count) {
-		*src_dev = dev;
-		ex->ex_change_count = ex_change_count;
-	} else {
-		struct domain_device *ch;
-
-		list_for_each_entry(ch, &ex->children, siblings) {
-			if (ch->dev_type == EDGE_DEV ||
-			    ch->dev_type == FANOUT_DEV) {
-				res = sas_find_bcast_dev(ch, src_dev);
-				if (src_dev)
-					return res;
-			}
+	if (ex_change_count != -1 && ex_change_count != ex->ex_change_count) {
+		/* Just detect if this expander phys phy change count changed,
+		* in order to determine if this expander originate BROADCAST,
+		* and do not update phy change count field in our structure.
+		*/
+		res = sas_find_bcast_phy(dev, &phy_id, 0, false);
+		if (phy_id != -1) {
+			*src_dev = dev;
+			ex->ex_change_count = ex_change_count;
+			SAS_DPRINTK("Expander phy change count has changed\n");
+			return res;
+		} else
+			SAS_DPRINTK("Expander phys DID NOT change\n");
+	}
+	list_for_each_entry(ch, &ex->children, siblings) {
+		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
+			res = sas_find_bcast_dev(ch, src_dev);
+			if (src_dev)
+				return res;
 		}
 	}
 out:
@@ -1700,24 +1734,26 @@ static void sas_unregister_ex_tree(struct domain_device *dev)
 }
 
 static void sas_unregister_devs_sas_addr(struct domain_device *parent,
-					 int phy_id)
+					 int phy_id, bool last)
 {
 	struct expander_device *ex_dev = &parent->ex_dev;
 	struct ex_phy *phy = &ex_dev->ex_phy[phy_id];
 	struct domain_device *child, *n;
-
-	list_for_each_entry_safe(child, n, &ex_dev->children, siblings) {
-		if (SAS_ADDR(child->sas_addr) ==
-		    SAS_ADDR(phy->attached_sas_addr)) {
-			if (child->dev_type == EDGE_DEV ||
-			    child->dev_type == FANOUT_DEV)
-				sas_unregister_ex_tree(child);
-			else
-				sas_unregister_dev(child);
-			break;
+	if (last) {
+		list_for_each_entry_safe(child, n,
+			&ex_dev->children, siblings) {
+			if (SAS_ADDR(child->sas_addr) ==
+			    SAS_ADDR(phy->attached_sas_addr)) {
+				if (child->dev_type == EDGE_DEV ||
+				    child->dev_type == FANOUT_DEV)
+					sas_unregister_ex_tree(child);
+				else
+					sas_unregister_dev(child);
+				break;
+			}
 		}
+		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
-	sas_disable_routing(parent, phy->attached_sas_addr);
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	sas_port_delete_phy(phy->port, phy->phy);
 	if (phy->port->num_phys == 0)
@@ -1770,15 +1806,31 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	int res;
+	bool found = false;
+	int res, i;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
 	res = sas_ex_phy_discover(dev, phy_id);
 	if (res)
 		goto out;
+	/* to support the wide port inserted */
+	for (i = 0; i < dev->ex_dev.num_phys; i++) {
+		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
+		if (i == phy_id)
+			continue;
+		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
+		    SAS_ADDR(ex_phy->attached_sas_addr)) {
+			found = true;
+			break;
+		}
+	}
+	if (found) {
+		sas_ex_join_wide_port(dev, phy_id);
+		return 0;
+	}
 	res = sas_ex_discover_devices(dev, phy_id);
-	if (res)
+	if (!res)
 		goto out;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
@@ -1793,7 +1845,7 @@ out:
 	return res;
 }
 
-static int sas_rediscover_dev(struct domain_device *dev, int phy_id)
+static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
@@ -1804,11 +1856,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id)
 	switch (res) {
 	case SMP_RESP_NO_PHY:
 		phy->phy_state = PHY_NOT_PRESENT;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		goto out; break;
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state = PHY_VACANT;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		goto out; break;
 	case SMP_RESP_FUNC_ACC:
 		break;
@@ -1816,7 +1868,7 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id)
 
 	if (SAS_ADDR(attached_sas_addr) == 0) {
 		phy->phy_state = PHY_EMPTY;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 	} else if (SAS_ADDR(attached_sas_addr) ==
 		   SAS_ADDR(phy->attached_sas_addr)) {
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter\n",
@@ -1828,12 +1880,27 @@ out:
 	return res;
 }
 
+/**
+ * sas_rediscover - revalidate the domain.
+ * @dev:domain device to be detect.
+ * @phy_id: the phy id will be detected.
+ *
+ * NOTE: this process _must_ quit (return) as soon as any connection
+ * errors are encountered.  Connection recovery is done elsewhere.
+ * Discover process only interrogates devices in order to discover the
+ * domain.For plugging out, we un-register the device only when it is
+ * the last phy in the port, for other phys in this port, we just delete it
+ * from the port.For inserting, we do discovery when it is the
+ * first phy,for other phys in this port, we add it to the port to
+ * forming the wide-port.
+ */
 static int sas_rediscover(struct domain_device *dev, const int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
 	int res = 0;
 	int i;
+	bool last = true;	/* is this the last phy of the port */
 
 	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
@@ -1848,13 +1915,13 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 			    SAS_ADDR(changed_phy->attached_sas_addr)) {
 				SAS_DPRINTK("phy%d part of wide port with "
 					    "phy%d\n", phy_id, i);
-				goto out;
+				last = false;
+				break;
 			}
 		}
-		res = sas_rediscover_dev(dev, phy_id);
+		res = sas_rediscover_dev(dev, phy_id, last);
 	} else
 		res = sas_discover_new(dev, phy_id);
-out:
 	return res;
 }
 
@@ -1881,7 +1948,7 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 
 		do {
 			phy_id = -1;
-			res = sas_find_bcast_phy(dev, &phy_id, i);
+			res = sas_find_bcast_phy(dev, &phy_id, i, true);
 			if (phy_id == -1)
 				break;
 			res = sas_rediscover(dev, phy_id);
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e6ac59c..fe8b74c 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -56,7 +56,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		}
 	}
 
-	/* find a port */
+	/* see if the phy should be part of a wide port */
 	spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		port = sas_ha->sas_port[i];
@@ -69,12 +69,23 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
 				    port->id);
 			break;
-		} else if (*(u64 *) port->sas_addr == 0 && port->num_phys==0) {
-			memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);
-			break;
 		}
 		spin_unlock(&port->phy_list_lock);
 	}
+	/* The phy does not match any existing port, create a new one */
+	if (i == sas_ha->num_phys) {
+		for (i = 0; i < sas_ha->num_phys; i++) {
+			port = sas_ha->sas_port[i];
+			spin_lock(&port->phy_list_lock);
+			if (*(u64 *)port->sas_addr == 0
+				&& port->num_phys == 0) {
+				memcpy(port->sas_addr, phy->sas_addr,
+					SAS_ADDR_SIZE);
+				break;
+			}
+			spin_unlock(&port->phy_list_lock);
+		}
+	}
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index fcc184c..cbceb0e 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -15,19 +15,18 @@ void qla4xxx_dump_buffer(void *b, uint32_t size)
 	uint32_t cnt;
 	uint8_t *c = b;
 
-	printk(" 0   1	 2   3	 4   5	 6   7	 8   9	Ah  Bh	Ch  Dh	Eh  "
+	printk(" 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  "
 	       "Fh\n");
 	printk("------------------------------------------------------------"
 	       "--\n");
-	for (cnt = 0; cnt < size; cnt++, c++) {
-		printk(KERN_DEBUG "%02x", *c);
-		if (!(cnt % 16))
-			printk(KERN_DEBUG "\n");
+	for (cnt = 0; cnt < size; c++) {
+		printk(KERN_INFO "%02x", *c);
+		if (!(++cnt % 16))
+			printk(KERN_INFO "\n");
 
 		else
-			printk(KERN_DEBUG "  ");
+			printk(KERN_INFO "  ");
 	}
-	if (cnt % 16)
-		printk(KERN_DEBUG "\n");
+	printk(KERN_INFO "\n");
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b586f27..81b5f29 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -100,7 +100,6 @@
 #define MAX_SRBS		MAX_CMDS_TO_RISC
 #define MBOX_AEN_REG_COUNT	5
 #define MAX_INIT_RETRIES	5
-#define IOCB_HIWAT_CUSHION	16
 
 /*
  * Buffer sizes
@@ -184,6 +183,11 @@ struct srb {
 	uint16_t cc_stat;
 	u_long r_start;		/* Time we recieve a cmd from OS */
 	u_long u_start;		/* Time when we handed the cmd to F/W */
+
+	/* Used for extended sense / status continuation */
+	uint8_t *req_sense_ptr;
+	uint16_t req_sense_len;
+	uint16_t reserved2;
 };
 
 /*
@@ -302,7 +306,6 @@ struct scsi_qla_host {
 	uint32_t tot_ddbs;
 
 	uint16_t	iocb_cnt;
-	uint16_t	iocb_hiwat;
 
 	/* SRB cache. */
 #define SRB_MIN_REQ	128
@@ -436,6 +439,8 @@ struct scsi_qla_host {
 	/* Map ddb_list entry by FW ddb index */
 	struct ddb_entry *fw_ddb_index_map[MAX_DDB_ENTRIES];
 
+	/* Saved srb for status continuation entry processing */
+	struct srb *status_srb;
 };
 
 static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 1b667a7..9cd7a60 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -572,6 +572,7 @@ struct conn_event_log_entry {
  *************************************************************************/
 #define IOCB_MAX_CDB_LEN	    16	/* Bytes in a CBD */
 #define IOCB_MAX_SENSEDATA_LEN	    32	/* Bytes of sense data */
+#define IOCB_MAX_EXT_SENSEDATA_LEN  60  /* Bytes of extended sense data */
 
 /* IOCB header structure */
 struct qla4_header {
@@ -733,6 +734,12 @@ struct status_entry {
 
 };
 
+/* Status Continuation entry */
+struct status_cont_entry {
+       struct qla4_header hdr; /* 00-03 */
+       uint8_t ext_sense_data[IOCB_MAX_EXT_SENSEDATA_LEN]; /* 04-63 */
+};
+
 struct passthru0 {
 	struct qla4_header hdr;		       /* 00-03 */
 	uint32_t handle;	/* 04-07 */
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 912a674..e0c3215 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -10,9 +10,42 @@
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
 
-
 #include <scsi/scsi_tcq.h>
 
+static int
+qla4xxx_space_in_req_ring(struct scsi_qla_host *ha, uint16_t req_cnt)
+{
+	uint16_t cnt;
+
+	/* Calculate number of free request entries. */
+	if ((req_cnt + 2) >= ha->req_q_count) {
+		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+		if (ha->request_in < cnt)
+			ha->req_q_count = cnt - ha->request_in;
+		else
+			ha->req_q_count = REQUEST_QUEUE_DEPTH -
+						(ha->request_in - cnt);
+	}
+
+	/* Check if room for request in request ring. */
+	if ((req_cnt + 2) < ha->req_q_count)
+		return 1;
+	else
+		return 0;
+}
+
+static void qla4xxx_advance_req_ring_ptr(struct scsi_qla_host *ha)
+{
+	/* Advance request queue pointer */
+	if (ha->request_in == (REQUEST_QUEUE_DEPTH - 1)) {
+		ha->request_in = 0;
+		ha->request_ptr = ha->request_ring;
+	} else {
+		ha->request_in++;
+		ha->request_ptr++;
+	}
+}
+
 /**
  * qla4xxx_get_req_pkt - returns a valid entry in request queue.
  * @ha: Pointer to host adapter structure.
@@ -26,35 +59,18 @@
 static int qla4xxx_get_req_pkt(struct scsi_qla_host *ha,
 			       struct queue_entry **queue_entry)
 {
-	uint16_t request_in;
-	uint8_t status = QLA_SUCCESS;
-
-	*queue_entry = ha->request_ptr;
+	uint16_t req_cnt = 1;
 
-	/* get the latest request_in and request_out index */
-	request_in = ha->request_in;
-	ha->request_out = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
-
-	/* Advance request queue pointer and check for queue full */
-	if (request_in == (REQUEST_QUEUE_DEPTH - 1)) {
-		request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else {
-		request_in++;
-		ha->request_ptr++;
-	}
-
-	/* request queue is full, try again later */
-	if ((ha->iocb_cnt + 1) >= ha->iocb_hiwat) {
-		/* restore request pointer */
-		ha->request_ptr = *queue_entry;
-		status = QLA_ERROR;
-	} else {
-		ha->request_in = request_in;
+	if (qla4xxx_space_in_req_ring(ha, req_cnt)) {
+		*queue_entry = ha->request_ptr;
 		memset(*queue_entry, 0, sizeof(**queue_entry));
+
+		qla4xxx_advance_req_ring_ptr(ha);
+		ha->req_q_count -= req_cnt;
+		return QLA_SUCCESS;
 	}
 
-	return status;
+	return QLA_ERROR;
 }
 
 /**
@@ -100,21 +116,14 @@ exit_send_marker:
 	return status;
 }
 
-static struct continuation_t1_entry* qla4xxx_alloc_cont_entry(
-	struct scsi_qla_host *ha)
+static struct continuation_t1_entry *
+qla4xxx_alloc_cont_entry(struct scsi_qla_host *ha)
 {
 	struct continuation_t1_entry *cont_entry;
 
 	cont_entry = (struct continuation_t1_entry *)ha->request_ptr;
 
-	/* Advance request queue pointer */
-	if (ha->request_in == (REQUEST_QUEUE_DEPTH - 1)) {
-		ha->request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else {
-		ha->request_in++;
-		ha->request_ptr++;
-	}
+	qla4xxx_advance_req_ring_ptr(ha);
 
 	/* Load packet defaults */
 	cont_entry->hdr.entryType = ET_CONTINUE;
@@ -197,13 +206,10 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	struct scsi_cmnd *cmd = srb->cmd;
 	struct ddb_entry *ddb_entry;
 	struct command_t3_entry *cmd_entry;
-
 	int nseg;
 	uint16_t tot_dsds;
 	uint16_t req_cnt;
-
 	unsigned long flags;
-	uint16_t cnt;
 	uint32_t index;
 	char tag[2];
 
@@ -217,6 +223,19 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 
 	index = (uint32_t)cmd->request->tag;
 
+	/*
+	 * Check to see if adapter is online before placing request on
+	 * request queue.  If a reset occurs and a request is in the queue,
+	 * the firmware will still attempt to process the request, retrieving
+	 * garbage for pointers.
+	 */
+	if (!test_bit(AF_ONLINE, &ha->flags)) {
+		DEBUG2(printk("scsi%ld: %s: Adapter OFFLINE! "
+			      "Do not issue command.\n",
+			      ha->host_no, __func__));
+		goto queuing_error;
+	}
+
 	/* Calculate the number of request entries needed. */
 	nseg = scsi_dma_map(cmd);
 	if (nseg < 0)
@@ -224,17 +243,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	tot_dsds = nseg;
 
 	req_cnt = qla4xxx_calc_request_entries(tot_dsds);
-
-	if (ha->req_q_count < (req_cnt + 2)) {
-		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
-		if (ha->request_in < cnt)
-			ha->req_q_count = cnt - ha->request_in;
-		else
-			ha->req_q_count = REQUEST_QUEUE_DEPTH -
-				(ha->request_in - cnt);
-	}
-
-	if (ha->req_q_count < (req_cnt + 2))
+	if (!qla4xxx_space_in_req_ring(ha, req_cnt))
 		goto queuing_error;
 
 	/* total iocbs active */
@@ -286,32 +295,10 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 			break;
 		}
 
-
-	/* Advance request queue pointer */
-	ha->request_in++;
-	if (ha->request_in == REQUEST_QUEUE_DEPTH) {
-		ha->request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else
-		ha->request_ptr++;
-
-
+	qla4xxx_advance_req_ring_ptr(ha);
 	qla4xxx_build_scsi_iocbs(srb, cmd_entry, tot_dsds);
 	wmb();
 
-	/*
-	 * Check to see if adapter is online before placing request on
-	 * request queue.  If a reset occurs and a request is in the queue,
-	 * the firmware will still attempt to process the request, retrieving
-	 * garbage for pointers.
-	 */
-	if (!test_bit(AF_ONLINE, &ha->flags)) {
-		DEBUG2(printk("scsi%ld: %s: Adapter OFFLINE! "
-			      "Do not issue command.\n",
-			      ha->host_no, __func__));
-		goto queuing_error;
-	}
-
 	srb->cmd->host_scribble = (unsigned char *)srb;
 
 	/* update counters */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 799120f..8025ee1 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -11,6 +11,98 @@
 #include "ql4_inline.h"
 
 /**
+ * qla4xxx_copy_sense - copy sense data	into cmd sense buffer
+ * @ha: Pointer to host adapter structure.
+ * @sts_entry: Pointer to status entry structure.
+ * @srb: Pointer to srb structure.
+ **/
+static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
+                               struct status_entry *sts_entry,
+                               struct srb *srb)
+{
+	struct scsi_cmnd *cmd = srb->cmd;
+	uint16_t sense_len;
+
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	sense_len = le16_to_cpu(sts_entry->senseDataByteCnt);
+	if (sense_len == 0)
+		return;
+
+	/* Save total available sense length,
+	 * not to exceed cmd's sense buffer size */
+	sense_len = min_t(uint16_t, sense_len, SCSI_SENSE_BUFFERSIZE);
+	srb->req_sense_ptr = cmd->sense_buffer;
+	srb->req_sense_len = sense_len;
+
+	/* Copy sense from sts_entry pkt */
+	sense_len = min_t(uint16_t, sense_len, IOCB_MAX_SENSEDATA_LEN);
+	memcpy(cmd->sense_buffer, sts_entry->senseData, sense_len);
+
+	DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: %s: sense key = %x, "
+		"ASL= %02x, ASC/ASCQ = %02x/%02x\n", ha->host_no,
+		cmd->device->channel, cmd->device->id,
+		cmd->device->lun, __func__,
+		sts_entry->senseData[2] & 0x0f,
+		sts_entry->senseData[7],
+		sts_entry->senseData[12],
+		sts_entry->senseData[13]));
+
+	DEBUG5(qla4xxx_dump_buffer(cmd->sense_buffer, sense_len));
+	srb->flags |= SRB_GOT_SENSE;
+
+	/* Update srb, in case a sts_cont pkt follows */
+	srb->req_sense_ptr += sense_len;
+	srb->req_sense_len -= sense_len;
+	if (srb->req_sense_len != 0)
+		ha->status_srb = srb;
+	else
+		ha->status_srb = NULL;
+}
+
+/**
+ * qla4xxx_status_cont_entry - Process a Status Continuations entry.
+ * @ha: SCSI driver HA context
+ * @sts_cont: Entry pointer
+ *
+ * Extended sense data.
+ */
+static void
+qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
+			  struct status_cont_entry *sts_cont)
+{
+	struct srb *srb = ha->status_srb;
+	struct scsi_cmnd *cmd;
+	uint8_t sense_len;
+
+	if (srb == NULL)
+		return;
+
+	cmd = srb->cmd;
+	if (cmd == NULL) {
+		DEBUG2(printk(KERN_INFO "scsi%ld: %s: Cmd already returned "
+			"back to OS srb=%p srb->state:%d\n", ha->host_no,
+			__func__, srb, srb->state));
+		ha->status_srb = NULL;
+		return;
+	}
+
+	/* Copy sense data. */
+	sense_len = min_t(uint16_t, srb->req_sense_len,
+			  IOCB_MAX_EXT_SENSEDATA_LEN);
+	memcpy(srb->req_sense_ptr, sts_cont->ext_sense_data, sense_len);
+	DEBUG5(qla4xxx_dump_buffer(srb->req_sense_ptr, sense_len));
+
+	srb->req_sense_ptr += sense_len;
+	srb->req_sense_len -= sense_len;
+
+	/* Place command on done queue. */
+	if (srb->req_sense_len == 0) {
+		qla4xxx_srb_compl(ha, srb);
+		ha->status_srb = NULL;
+	}
+}
+
+/**
  * qla4xxx_status_entry - processes status IOCBs
  * @ha: Pointer to host adapter structure.
  * @sts_entry: Pointer to status entry structure.
@@ -23,7 +115,6 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	struct srb *srb;
 	struct ddb_entry *ddb_entry;
 	uint32_t residual;
-	uint16_t sensebytecnt;
 
 	srb = qla4xxx_del_from_active_array(ha, le32_to_cpu(sts_entry->handle));
 	if (!srb) {
@@ -92,24 +183,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			break;
 
 		/* Copy Sense Data into sense buffer. */
-		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
-		sensebytecnt = le16_to_cpu(sts_entry->senseDataByteCnt);
-		if (sensebytecnt == 0)
-			break;
-
-		memcpy(cmd->sense_buffer, sts_entry->senseData,
-		       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
-
-		DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
-			      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
-			      cmd->device->channel, cmd->device->id,
-			      cmd->device->lun, __func__,
-			      sts_entry->senseData[2] & 0x0f,
-			      sts_entry->senseData[12],
-			      sts_entry->senseData[13]));
-
-		srb->flags |= SRB_GOT_SENSE;
+		qla4xxx_copy_sense(ha, sts_entry, srb);
 		break;
 
 	case SCS_INCOMPLETE:
@@ -176,23 +250,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 				break;
 
 			/* Copy Sense Data into sense buffer. */
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
-			sensebytecnt =
-				le16_to_cpu(sts_entry->senseDataByteCnt);
-			if (sensebytecnt == 0)
-				break;
-
-			memcpy(cmd->sense_buffer, sts_entry->senseData,
-			       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
-
-			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
-				      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
-				      cmd->device->channel, cmd->device->id,
-				      cmd->device->lun, __func__,
-				      sts_entry->senseData[2] & 0x0f,
-				      sts_entry->senseData[12],
-				      sts_entry->senseData[13]));
+			qla4xxx_copy_sense(ha, sts_entry, srb);
 		} else {
 			/*
 			 * If RISC reports underrun and target does not
@@ -268,9 +326,10 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 status_entry_exit:
 
-	/* complete the request */
+	/* complete the request, if not waiting for status_continuation pkt */
 	srb->cc_stat = sts_entry->completionStatus;
-	qla4xxx_srb_compl(ha, srb);
+	if (ha->status_srb == NULL)
+		qla4xxx_srb_compl(ha, srb);
 }
 
 /**
@@ -305,10 +364,7 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 		/* process entry */
 		switch (sts_entry->hdr.entryType) {
 		case ET_STATUS:
-			/*
-			 * Common status - Single completion posted in single
-			 * IOSB.
-			 */
+			/* Common status */
 			qla4xxx_status_entry(ha, sts_entry);
 			break;
 
@@ -316,9 +372,8 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 			break;
 
 		case ET_STATUS_CONTINUATION:
-			/* Just throw away the status continuation entries */
-			DEBUG2(printk("scsi%ld: %s: Status Continuation entry "
-				      "- ignoring\n", ha->host_no, __func__));
+			qla4xxx_status_cont_entry(ha,
+				(struct status_cont_entry *) sts_entry);
 			break;
 
 		case ET_COMMAND:
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 051b0f5..09d6d4b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -385,16 +385,6 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 			      mbox_sts[0]));
 		return QLA_ERROR;
 	}
-
-	/* High-water mark of IOCBs */
-	ha->iocb_hiwat = mbox_sts[2];
-	if (ha->iocb_hiwat > IOCB_HIWAT_CUSHION)
-		ha->iocb_hiwat -= IOCB_HIWAT_CUSHION;
-	else
-		dev_info(&ha->pdev->dev, "WARNING!!!  You have less than %d "
-			   "firmware IOCBs available (%d).\n",
-			   IOCB_HIWAT_CUSHION, ha->iocb_hiwat);
-
 	return QLA_SUCCESS;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ec9da6c..40e3caf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -66,6 +66,7 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
+static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
 /*
  * SCSI host template entry points
@@ -89,6 +90,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
 	.eh_target_reset_handler = qla4xxx_eh_target_reset,
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
+	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
 	.slave_configure	= qla4xxx_slave_configure,
 	.slave_alloc		= qla4xxx_slave_alloc,
@@ -124,6 +126,21 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
+{
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry;
+
+	session = starget_to_session(scsi_target(sc->device));
+	ddb_entry = session->dd_data;
+
+	/* if we are not logged in then the LLD is going to clean up the cmd */
+	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
+		return BLK_EH_RESET_TIMER;
+	else
+		return BLK_EH_NOT_HANDLED;
+}
+
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 {
 	struct ddb_entry *ddb_entry = session->dd_data;
@@ -904,18 +921,17 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 	/* Flush any pending ddb changed AENs */
 	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 
+	qla4xxx_flush_active_srbs(ha);
+
 	/* Reset the firmware.	If successful, function
 	 * returns with ISP interrupts enabled.
 	 */
-	if (status == QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
-			      ha->host_no, __func__));
-		qla4xxx_flush_active_srbs(ha);
-		if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
-			status = qla4xxx_soft_reset(ha);
-		else
-			status = QLA_ERROR;
-	}
+	DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
+		      ha->host_no, __func__));
+	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
+		status = qla4xxx_soft_reset(ha);
+	else
+		status = QLA_ERROR;
 
 	/* Flush any pending ddb changed AENs */
 	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
@@ -1527,11 +1543,9 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
-	struct srb *sp;
 	int ret = FAILED, stat;
 
-	sp = (struct srb *) cmd->SCp.ptr;
-	if (!sp || !ddb_entry)
+	if (!ddb_entry)
 		return ret;
 
 	dev_info(&ha->pdev->dev,
@@ -1644,7 +1658,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
 
 	dev_info(&ha->pdev->dev,
-		   "scsi(%ld:%d:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no,
+		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index ab984cb..6980cb2 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,5 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.01.00-k8"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k9"
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5616cd7..b7b9fec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1840,6 +1840,18 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+static int sd_try_extended_inquiry(struct scsi_device *sdp)
+{
+	/*
+	 * Although VPD inquiries can go to SCSI-2 type devices,
+	 * some USB ones crash on receiving them, and the pages
+	 * we currently ask for are for SPC-3 and beyond
+	 */
+	if (sdp->scsi_level > SCSI_SPC_2)
+		return 1;
+	return 0;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1877,8 +1889,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-		sd_read_block_limits(sdkp);
-		sd_read_block_characteristics(sdkp);
+
+		if (sd_try_extended_inquiry(sdp)) {
+			sd_read_block_limits(sdkp);
+			sd_read_block_characteristics(sdkp);
+		}
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
