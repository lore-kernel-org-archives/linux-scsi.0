From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 07/13] libfc: remove os_lun
Date: Sun, 29 Jun 2008 13:23:57 -0500
Message-ID: <1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-7-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

The FC layer is primarily concerned with the transport, so the os_lun
tracking is a little akward because if we want to track something at the
device level then scsi-ml should do this.

Some of those errors, like dropped packets, it handled seemed like it
would could be handled better at the port level. This would also be useful
if we put it in the fc class so we could have port level erros for lpfc
and qla2xxx too (could use it to fix the underrun type of errors that
get reported when frames are dropped, but we want to retry on
the same path).

This patch also has us use int_to_scsilun instead of the htonl and
shift junk.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/fcoe/fcoe_if.c  |    1 -
 drivers/scsi/libfc/fc_scsi.c |  146 ++++++------------------------------------
 include/scsi/libfc/libfc.h   |    8 +--
 3 files changed, 22 insertions(+), 133 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_if.c b/drivers/scsi/fcoe/fcoe_if.c
index 1f32743..a955994 100644
--- a/drivers/scsi/fcoe/fcoe_if.c
+++ b/drivers/scsi/fcoe/fcoe_if.c
@@ -268,7 +268,6 @@ static struct scsi_host_template fcoe_driver_template = {
 	.eh_host_reset_handler = fc_eh_host_reset,
 	.slave_configure = fc_slave_configure,
 	.slave_alloc = fc_slave_alloc,
-	.slave_destroy = fc_slave_destroy,
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index b9487bf..e9a704d 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -45,25 +45,6 @@ int openfc_debug;
 #define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
 #define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
 
-enum os_lun_state {
-	FC_LUN_READY,
-	FC_LUN_OFFLINE,		/* taken offline by user */
-	FC_LUN_ERR,
-	FC_LUN_UNKNW,
-};
-
-/*
- * Openfc data struct per lun
- */
-struct os_lun {
-	struct scsi_device *sdev;
-	struct fc_remote_port *rp;		/* pointer to the target */
-	uint32_t	lun_number;	/* lun number */
-	enum os_lun_state state;
-	int		error_cnt;	/* consecutive error count */
-	unsigned long	avg_time;	/* average read/write time */
-};
-
 /*
  * scsi request structure, one for each scsi request
  */
@@ -79,7 +60,6 @@ struct fc_scsi_pkt {
 	/*
 	 * SCSI I/O related stuff
 	 */
-	uint64_t	lun;
 	void		(*done) (struct fc_scsi_pkt *);
 	struct scsi_cmnd *cmd;		/* scsi command pointer */
 	/*
@@ -119,7 +99,6 @@ struct fc_scsi_pkt {
 	 */
 	struct fc_remote_port *rp;	/* remote port pointer */
 	struct fc_seq	*seq_ptr;	/* current sequence pointer */
-	struct os_lun	*disk;		/* ptr to the Lun structure */
 	/*
 	 * Error Processing
 	 */
@@ -663,7 +642,6 @@ static void fc_scsi_recv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	struct fc_cmdq *qp;
 	struct fc_lport *lp;
 	struct fc_frame_header *fh;
-	struct os_lun *lun;
 	struct fc_data_desc *dd;
 	u8 r_ctl;
 	u8 sg_supp;
@@ -682,12 +660,6 @@ static void fc_scsi_recv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		goto out;
 	fsp->last_pkt_time = jiffies;
 
-	lun = fsp->disk;
-	if (lun && lun->error_cnt) {
-		lun->state = FC_LUN_READY;
-		lun->error_cnt = 0;
-	}
-
 	if (r_ctl == FC_RCTL_DD_DATA_DESC) {
 		/*
 		 * received XFER RDY from the target
@@ -972,8 +944,8 @@ static int fc_scsi_pkt_send(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 	p = xchg(&((CMD_SP(fsp->cmd))), &si->outstandingcmd[i]);
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_flags = fsp->req_flags & ~FCP_CFL_LEN_MASK;
-
-	*((__be64 *) fsp->cdb_cmd.fc_lun) =  htonll(fsp->lun << 48);
+	int_to_scsilun(fsp->cmd->device->lun,
+		       (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
 	memcpy(fsp->cdb_cmd.fc_cdb, fsp->cmd->cmnd, fsp->cmd->cmd_len);
 	return fc_scsi_send_cmd(fsp);
 }
@@ -1139,8 +1111,8 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 	fsp->idx = 0;
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
-	*((__be64 *) fsp->cdb_cmd.fc_lun) = htonll(fsp->lun << 48);
-
+	int_to_scsilun(fsp->cmd->device->lun,
+		       (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
 	fsp->wait_for_comp = 1;
 	init_completion(&fsp->tm_done);
 
@@ -1159,7 +1131,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 	 * Acquire the list lock
 	 */
 	tid = fsp->cmd->device->id;
-	lun = fsp->lun;
+	lun = fsp->cmd->device->lun;
 	spin_lock_irqsave(&si->outstandingcmd_lock, flags);
 	for (idx = 1; idx < FC_MAX_OUTSTANDING_COMMANDS; idx++) {
 		spin_lock(&si->outstandingcmd[idx].scsi_pkt_lock);
@@ -1309,7 +1281,7 @@ static void fc_scsi_timeout(struct fc_scsi_pkt *fsp)
 		return;
 	cdb_op = fsp->cdb_cmd.fc_cdb[0];
 
-	if (fsp->disk->rp->tgt_flags & FC_TGT_REC_SUPPORTED)
+	if (fsp->rp->tgt_flags & FC_TGT_REC_SUPPORTED)
 		fc_scsi_rec(fsp);
 	else if (jiffies - fsp->last_pkt_time < FC_SCSI_ER_TIMEOUT / 2)
 		fc_scsi_timer_set(fsp, FC_SCSI_ER_TIMEOUT);
@@ -1419,7 +1391,7 @@ static void fc_scsi_rec_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		case ELS_RJT_UNSUP:
 			if (openfc_debug)
 				FC_DBG("device does not support REC\n");
-			fsp->disk->rp->tgt_flags &= ~FC_TGT_REC_SUPPORTED;
+			fsp->rp->tgt_flags &= ~FC_TGT_REC_SUPPORTED;
 			/* fall through */
 
 		case ELS_RJT_LOGIC:
@@ -1567,7 +1539,6 @@ out:
  */
 static void fc_timeout_error(struct fc_scsi_pkt *fsp)
 {
-	struct os_lun *lun;
 	struct fc_cmdq *qp;
 	struct fc_lport *lp = fsp->lp;
 	struct fc_scsi_internal *si = fc_get_scsi_internal(lp);
@@ -1586,50 +1557,33 @@ static void fc_timeout_error(struct fc_scsi_pkt *fsp)
 	fsp->status_code = FC_CMD_TIME_OUT;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
-	lun = fsp->disk;
-	lun->error_cnt++;
-	/*
-	 * if we get 5 consecutive errors
-	 * for the same command then offline the device.
-	 */
-	if (lun->error_cnt >= FC_MAX_ERROR_CNT) {
-		lun->state = FC_LUN_ERR;
-		fsp->status_code = FC_HRD_ERROR;
-	} else {
-		fsp->io_status = (SUGGEST_RETRY << 24);
-	}
+
 	if (fsp->done)
 		fsp->done(fsp);
 }
 
 /*
  * Retry command.
- * An abort isn't needed.  This is presumably due to cmd packet loss.
+ * An abort isn't needed.
  *
- * If we deliver an error persistently on the same LUN, then report it
- * as a hard error.
+ * We treat it like a timeout because the command did not complete -
+ * presumably due to cmd packet loss. We will fail the command and
+ * have scsi-ml decide if we should retry or not.
+ *
+ * TODO: Instead we could continue to retry the command until the scsi
+ * command fires, or add port level counters to determine
+ * when to mark it as failed (the latter would be useful in the class eh
+ * for lpfc and qla2xxx).
  */
 static void fc_scsi_retry_cmd(struct fc_scsi_pkt *fsp)
 {
-	struct os_lun *lun;
-
 	if (fsp->seq_ptr) {
 		fsp->lp->tt.seq_exch_complete(fsp->seq_ptr);
 		fsp->seq_ptr = NULL;
 	}
-	lun = fsp->disk;
-	lun->error_cnt++;
 
-	/*
-	 * if we get 5 consecutive errors
-	 * for the same command then offline the device.
-	 */
-	if (lun->error_cnt >= FC_MAX_ERROR_CNT) {
-		fsp->status_code = FC_HRD_ERROR;
-		fc_scsi_complete(fsp);
-	} else {
-		fc_scsi_send_cmd(fsp);
-	}
+	fsp->status_code = FC_CMD_TIME_OUT;
+	fc_scsi_complete(fsp);
 }
 
 /*
@@ -1769,7 +1723,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_scsi_pkt *sp;
 	struct fc_remote_port *rp;
-	struct os_lun *disk;
 	int rval;
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
@@ -1816,17 +1769,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		done(sc_cmd);
 		goto out;
 	}
-	disk = sc_cmd->device->hostdata;
-	if (!disk) {
-		sc_cmd->result = DID_NO_CONNECT << 16;
-		done(sc_cmd);
-		goto out;
-	}
-	if (disk->state == FC_LUN_OFFLINE) {
-		sc_cmd->result = DID_NO_CONNECT << 16;
-		done(sc_cmd);
-		goto out;
-	}
 
 	/* after finding target we wil release the lock */
 	spin_unlock_irq(lp->host->host_lock);
@@ -1843,7 +1785,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	sp->cmd = sc_cmd;	/* save the cmd */
 	sp->lp = lp;	/* save the softc ptr */
 	sp->rp = rp;	/* set the remote port ptr */
-	sp->disk = (void *)disk;
 	sc_cmd->scsi_done = done;
 
 	/*
@@ -1853,9 +1794,8 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	sp->xfer_len = 0;
 
 	/*
-	 * setup the lun number and data direction
+	 * setup the data direction
 	 */
-	sp->lun = sc_cmd->device->lun;
 	stats = lp->dev_stats[smp_processor_id()];
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		sp->req_flags = FC_SRB_READ;
@@ -1994,7 +1934,7 @@ static void fc_io_compl(struct fc_scsi_pkt *sp)
 		sc_cmd->result = (DID_ABORT << 16) | sp->io_status;
 		break;
 	case FC_CMD_TIME_OUT:
-		sc_cmd->result = (DID_TIME_OUT << 16) | sp->io_status;
+		sc_cmd->result = (DID_BUS_BUSY << 16) | sp->io_status;
 		break;
 	case FC_CMD_RESET:
 		sc_cmd->result = (DID_RESET << 16);
@@ -2106,8 +2046,6 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 		sp->lp = lp;	/* save the softc ptr */
 		sp->rp = rp;	/* set the remote port ptr */
 
-		sp->lun = sc_cmd->device->lun;
-
 		/*
 		 * flush outstanding commands
 		 */
@@ -2163,56 +2101,14 @@ EXPORT_SYMBOL(fc_slave_configure);
 
 int fc_slave_alloc(struct scsi_device *sdev)
 {
-	struct fc_remote_port *rp;
-	struct os_lun *disk;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
-
-	rp = rport->dd_data;
-	disk = kzalloc(sizeof(struct os_lun), GFP_KERNEL);
-	if (!disk) {
-		FC_DBG("could not allocate lun structure\n");
-		return -ENOMEM;
-	}
-	disk->lun_number = sdev->lun;
-	disk->state = FC_LUN_READY;
-	sdev->hostdata = disk;
-	disk->rp = rp;
-	disk->sdev = sdev;
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);
 
-void fc_slave_destroy(struct scsi_device *sdev)
-{
-	struct fc_remote_port *rp;
-	struct os_lun *disk;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-
-	if (rport) {
-		rp = rport->dd_data;
-		if (!rp) {
-			/*
-			 * we should not be here
-			 * Most likely RSCN cleaned up the
-			 * target structure. so return;
-			 */
-			sdev->hostdata = NULL;
-			return;
-		}
-		disk = sdev->hostdata;
-		if (!disk)
-			return;
-
-		sdev->hostdata = NULL;
-		kfree(disk);
-	}
-}
-EXPORT_SYMBOL(fc_slave_destroy);
-
-
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
diff --git a/include/scsi/libfc/libfc.h b/include/scsi/libfc/libfc.h
index 68ea82f..55ccace 100644
--- a/include/scsi/libfc/libfc.h
+++ b/include/scsi/libfc/libfc.h
@@ -705,7 +705,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
 
 /*
- * Create a os_lun object and set its state to READY.
+ * Check rport status.
  */
 int fc_slave_alloc(struct scsi_device *sdev);
 
@@ -715,12 +715,6 @@ int fc_slave_alloc(struct scsi_device *sdev);
 int fc_slave_configure(struct scsi_device *sdev);
 
 /*
- * Free the memory allocated for a os_lun object created
- * by fc_slave_alloc().
- */
-void fc_slave_destroy(struct scsi_device *sdev);
-
-/*
  * Adjust the queue depth.
  */
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth);
-- 
1.5.4.1
