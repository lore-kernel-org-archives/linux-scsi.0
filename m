From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
Date: Fri, 27 Jun 2014 08:27:03 +0200
Message-ID: <1403850425-89297-6-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaF0G1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:10 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Smart <james.smart@emulex.com>

fc_block_scsi_eh() works on a remote port, so we should be using
that as an argument and not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@emulex.com>
---
 drivers/s390/scsi/zfcp_scsi.c     |  9 ++++++---
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  4 ++--
 drivers/scsi/csiostor/csio_scsi.c |  4 ++--
 drivers/scsi/fnic/fnic_scsi.c     | 18 ++++++++++++------
 drivers/scsi/ibmvscsi/ibmvfc.c    |  9 ++++++---
 drivers/scsi/libfc/fc_fcp.c       |  5 +++--
 drivers/scsi/lpfc/lpfc_scsi.c     | 12 ++++++++----
 drivers/scsi/qla2xxx/qla_os.c     | 21 +++++++++++++--------
 drivers/scsi/scsi_transport_fc.c  |  7 +++----
 include/scsi/scsi_transport_fc.h  |  2 +-
 10 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 7b35364..dc42c93 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -173,6 +173,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
 	struct zfcp_fsf_req *old_req, *abrt_req;
+	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
 	unsigned long flags;
 	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS, ret;
@@ -199,7 +200,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 			break;
 
 		zfcp_erp_wait(adapter);
-		ret = fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(rport);
 		if (ret) {
 			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
 			return ret;
@@ -234,6 +235,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct fc_port *rport = zfcp_sdev->port->rport;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
@@ -244,7 +246,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 			break;
 
 		zfcp_erp_wait(adapter);
-		ret = fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(rport);
 		if (ret)
 			return ret;
 
@@ -283,11 +285,12 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct fc_rport *rport = zfcp_sdev->port->rport;
 	int ret;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	ret = fc_block_scsi_eh(scpnt);
+	ret = fc_block_scsi_eh(rport);
 	if (ret)
 		return ret;
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 32a5e0a..4833c50 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -716,7 +716,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	}
 	rp = rport->dd_data;
 
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_scsi_eh(rport);
 	if (rc)
 		return rc;
 
@@ -1165,7 +1165,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 
 
-	rc = fc_block_scsi_eh(sc_cmd);
+	rc = fc_block_scsi_eh(rport);
 	if (rc)
 		return rc;
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 86103c8..fe7046d 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1944,7 +1944,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 	int rv;
 	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
 
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(rn->rport);
 	if (ret)
 		return ret;
 
@@ -2112,7 +2112,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(rn->rport);
 	if (ret)
 		return ret;
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 3f88f56..1fa1a87 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1728,7 +1728,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	spinlock_t *io_lock;
 	unsigned long flags;
 	unsigned long start_time = 0;
-	int ret = SUCCESS;
+	int ret;
 	u32 task_req = 0;
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
@@ -1739,8 +1739,12 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
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
 
@@ -1749,7 +1753,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	abts_stats = &fnic->fnic_stats.abts_stats;
 	term_stats = &fnic->fnic_stats.term_stats;
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	tag = sc->request->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
@@ -2182,7 +2185,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct fnic_io_req *io_req = NULL;
 	struct fc_rport *rport;
 	int status;
-	int ret = FAILED;
+	int ret;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	unsigned long start_time = 0;
@@ -2194,8 +2197,12 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	rport = starget_to_rport(scsi_target(sc->device));
+	ret = fc_block_scsi_eh(rport);
+	if (ret)
+		return ret;
 
+	ret = FAILED;
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
 
@@ -2205,7 +2212,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	atomic64_inc(&reset_stats->device_resets);
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
 		      rport->port_id, sc->device->lun, sc);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index e258594..fee80fa 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2405,11 +2405,12 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
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
@@ -2438,11 +2439,12 @@ static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
@@ -2496,13 +2498,14 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
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
index 89749d8..40f26ea 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2021,11 +2021,12 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
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
 
@@ -2077,7 +2078,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 	int rval;
 
-	rval = fc_block_scsi_eh(sc_cmd);
+	rval = fc_block_scsi_eh(rport);
 	if (rval)
 		return rval;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7862c55..832cb9f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4781,6 +4781,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
 	struct lpfc_sli_ring *pring_s4;
@@ -4788,7 +4789,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	unsigned long flags, iflags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5240,6 +5241,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	unsigned tgt_id = cmnd->device->id;
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
@@ -5249,7 +5251,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5310,6 +5312,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	unsigned tgt_id = cmnd->device->id;
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
@@ -5319,7 +5322,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
@@ -5376,6 +5379,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_nodelist *ndlp = NULL;
 	struct lpfc_scsi_event_header scsi_event;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int match;
 	int ret = SUCCESS, status, i;
 
@@ -5388,7 +5392,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(rport);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be9698d..cd30445 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -918,6 +918,7 @@ static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	srb_t *sp;
 	int ret;
 	unsigned int id;
@@ -929,7 +930,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
-	ret = fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(rport);
 	if (ret != 0)
 		return ret;
 	ret = SUCCESS;
@@ -1071,9 +1072,11 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
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
@@ -1165,10 +1168,12 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
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
index 6b65b03..f9939c8 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3293,7 +3293,7 @@ fc_scsi_scan_rport(struct work_struct *work)
 
 /**
  * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
- * @cmnd: SCSI command that scsi_eh is trying to recover
+ * @rport: remote port to be checked
  *
  * This routine can be called from a FC LLD scsi_eh callback. It
  * blocks the scsi_eh thread until the fc_rport leaves the
@@ -3305,10 +3305,9 @@ fc_scsi_scan_rport(struct work_struct *work)
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
index 8c79980..4d4f21f 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -851,6 +851,6 @@ void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_block_scsi_eh(struct fc_rport *rport);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.7.12.4

