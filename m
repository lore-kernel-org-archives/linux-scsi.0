From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/47] scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
Date: Wed, 28 Jun 2017 10:32:41 +0200
Message-ID: <1498638793-44672-16-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53767 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751573AbdF1IdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:20 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

fc_block_scsi_eh() works on a remote port, so we should be using
that as an argument, and not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/scsi/zfcp_scsi.c     |  6 ++++--
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  4 ++--
 drivers/scsi/csiostor/csio_scsi.c |  4 ++--
 drivers/scsi/fnic/fnic_scsi.c     | 18 ++++++++++++------
 drivers/scsi/ibmvscsi/ibmvfc.c    |  9 ++++++---
 drivers/scsi/libfc/fc_fcp.c       |  5 +++--
 drivers/scsi/lpfc/lpfc_scsi.c     | 10 +++++++---
 drivers/scsi/qla2xxx/qla_os.c     | 21 +++++++++++++--------
 drivers/scsi/scsi_transport_fc.c  |  7 +++----
 include/scsi/scsi_transport_fc.h  |  2 +-
 10 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index d7d4a63..e3160fc 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -150,6 +150,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
 	struct zfcp_fsf_req *old_req, *abrt_req;
+	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
 	unsigned long flags;
 	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS, ret;
@@ -176,7 +177,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 			break;
 
 		zfcp_erp_wait(adapter);
-		ret = fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(rport);
 		if (ret) {
 			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
 			return ret;
@@ -262,6 +263,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct fc_port *rport = zfcp_sdev->port->rport;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
@@ -272,7 +274,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 			break;
 
 		zfcp_erp_wait(adapter);
-		ret = fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(rport);
 		if (ret)
 			return ret;
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 5b6153f..266a92e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -691,7 +691,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	}
 	rp = rport->dd_data;
 
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_scsi_eh(rport);
 	if (rc)
 		return rc;
 
@@ -1119,7 +1119,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct bnx2fc_rport *tgt;
 	int rc;
 
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_scsi_eh(rport);
 	if (rc)
 		return rc;
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index a1ff75f..93b6891 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1920,7 +1920,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	int rv;
 	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
 
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(rn->rport);
 	if (ret)
 		return ret;
 
@@ -2087,7 +2087,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(rn->rport);
 	if (ret)
 		return ret;
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2716222..731ec87 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1818,7 +1818,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	spinlock_t *io_lock;
 	unsigned long flags;
 	unsigned long start_time = 0;
-	int ret = SUCCESS;
+	int ret;
 	u32 task_req = 0;
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
@@ -1830,8 +1830,12 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	rport = starget_to_rport(scsi_target(sc->device));
+	ret = fc_block_scsi_eh(rport);
+	if (ret)
+		return ret;
 
+	ret = SUCCESS;
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
 
@@ -1840,7 +1844,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	abts_stats = &fnic->fnic_stats.abts_stats;
 	term_stats = &fnic->fnic_stats.term_stats;
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	tag = sc->request->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
@@ -2336,7 +2339,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct fnic_io_req *io_req = NULL;
 	struct fc_rport *rport;
 	int status;
-	int ret = FAILED;
+	int ret;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	unsigned long start_time = 0;
@@ -2349,8 +2352,12 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	bool new_sc = 0;
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	rport = starget_to_rport(scsi_target(sc->device));
+	ret = fc_block_scsi_eh(rport);
+	if (ret)
+		return ret;
 
+	ret = FAILED;
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
 
@@ -2360,7 +2367,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	atomic64_inc(&reset_stats->device_resets);
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
 		      rport->port_id, sc->device->lun, sc);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 5dccf07..21f7e88 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2406,11 +2406,12 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	int cancel_rc, block_rc;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
@@ -2439,11 +2440,12 @@ static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
@@ -2497,13 +2499,14 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct scsi_target *starget = scsi_target(sdev);
+	struct fc_rport *rport = starget_to_rport(starget);
 	int block_rc;
 	int reset_rc = 0;
 	int rc = FAILED;
 	unsigned long cancel_rc = 0;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_scsi_eh(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 2ec903a..ef6c8bc 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2118,11 +2118,12 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_fcp_pkt *fsp;
 	struct fc_lport *lport;
 	struct fc_fcp_internal *si;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	int rc = FAILED;
 	unsigned long flags;
 	int rval;
 
-	rval = fc_block_scsi_eh(sc_cmd);
+	rval = fc_block_scsi_eh(rport);
 	if (rval)
 		return rval;
 
@@ -2174,7 +2175,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 	int rval;
 
-	rval = fc_block_scsi_eh(sc_cmd);
+	rval = fc_block_scsi_eh(rport);
 	if (rval)
 		return rval;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 79981b9..db2716a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4696,6 +4696,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
 	struct lpfc_sli_ring *pring_s4;
@@ -4703,7 +4704,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	unsigned long flags, iflags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5166,6 +5167,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	unsigned tgt_id = cmnd->device->id;
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
@@ -5176,7 +5178,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5237,6 +5239,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	unsigned tgt_id = cmnd->device->id;
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
@@ -5246,7 +5249,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5294,6 +5297,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
+_scsi_eh
  * lpfc_host_reset_handler - scsi_host_template eh_host_reset_handler entry pt
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fe2ff0a..35180aa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1247,6 +1247,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	srb_t *sp;
 	int ret;
 	unsigned int id;
@@ -1263,7 +1264,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
-	ret = fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(rport);
 	if (ret != 0)
 		return ret;
 	ret = SUCCESS;
@@ -1394,9 +1395,11 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		return FAILED;
 	}
 
-	err = fc_block_scsi_eh(cmd);
-	if (err != 0)
-		return err;
+	if (fcport->rport) {
+		err = fc_block_scsi_eh(fcport->rport);
+		if (err != 0)
+			return err;
+	}
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
@@ -1507,10 +1510,12 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		return ret;
 	}
 
-	ret = fc_block_scsi_eh(cmd);
-	if (ret != 0)
-		return ret;
-	ret = FAILED;
+	if (fcport->rport) {
+		ret = fc_block_scsi_eh(fcport->rport);
+		if (ret != 0)
+			return ret;
+		ret = FAILED;
+	}
 
 	ql_log(ql_log_info, vha, 0x8012,
 	    "BUS RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 6dd0922..f83e512 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3273,7 +3273,7 @@ struct fc_rport *
 
 /**
  * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
- * @cmnd: SCSI command that scsi_eh is trying to recover
+ * @rport: remote port to be checked
  *
  * This routine can be called from a FC LLD scsi_eh callback. It
  * blocks the scsi_eh thread until the fc_rport leaves the
@@ -3285,10 +3285,9 @@ struct fc_rport *
  *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
  *	    passed back to scsi_eh.
  */
-int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
+int fc_block_scsi_eh(struct fc_rport *rport)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	struct Scsi_Host *shost = rport_to_shost(rport);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e308cd5..5b26943 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -804,7 +804,7 @@ void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_block_scsi_eh(struct fc_rport *rport);
 enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
 
 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
-- 
1.8.5.6
