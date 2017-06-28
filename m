From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/47] scsi: Use scsi_target as argument for eh_target_reset_handler()
Date: Wed, 28 Jun 2017 10:32:58 +0200
Message-ID: <1498638793-44672-33-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53815 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751782AbdF1IdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:24 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The target reset function should only depend on the scsi target,
not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptsas.c             | 10 +++++-
 drivers/message/fusion/mptscsih.c           | 27 +++++++----------
 drivers/message/fusion/mptscsih.h           |  2 +-
 drivers/message/fusion/mptspi.c             |  8 ++++-
 drivers/s390/scsi/zfcp_scsi.c               | 20 ++++++++++--
 drivers/scsi/aacraid/linit.c                |  9 +++---
 drivers/scsi/be2iscsi/be_main.c             |  4 +--
 drivers/scsi/bfa/bfad_im.c                  |  3 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  4 +--
 drivers/scsi/esas2r/esas2r.h                |  2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 38 ++++++++++++-----------
 drivers/scsi/ibmvscsi/ibmvfc.c              |  3 +-
 drivers/scsi/libiscsi.c                     |  4 +--
 drivers/scsi/libsas/sas_scsi_host.c         |  9 +++---
 drivers/scsi/lpfc/lpfc_scsi.c               | 10 +++---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 10 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 47 +++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 35 +++++++++++----------
 drivers/scsi/pmcraid.c                      | 24 +++++++++++----
 drivers/scsi/qedf/qedf_main.c               |  3 +-
 drivers/scsi/qla2xxx/qla_os.c               | 18 +++++------
 drivers/scsi/qla4xxx/ql4_os.c               | 41 ++++++++++++++-----------
 drivers/scsi/scsi_debug.c                   | 21 ++++---------
 drivers/scsi/scsi_error.c                   |  5 +--
 drivers/scsi/scsi_transport_iscsi.c         |  6 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  3 +-
 drivers/target/loopback/tcm_loop.c          |  9 +++---
 include/scsi/libiscsi.h                     |  2 +-
 include/scsi/libsas.h                       |  2 +-
 include/scsi/scsi_host.h                    |  2 +-
 include/scsi/scsi_transport_iscsi.h         |  2 +-
 33 files changed, 214 insertions(+), 174 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f6308ad..bdb420b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1970,6 +1970,14 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
+static int mptsas_eh_target_reset(struct scsi_target *starget)
+{
+	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+	MPT_ADAPTER *ioc = rphy_to_ioc(rphy);
+
+	return mptscsih_target_reset(ioc->sh, starget);
+}
+
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
@@ -1985,7 +1993,7 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_timed_out			= mptsas_eh_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptsas_eh_target_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SAS_CAN_QUEUE,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ca79982..0f25a2a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1852,48 +1852,43 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_target_reset(struct scsi_cmnd * SCpnt)
+mptscsih_target_reset(struct Scsi_Host *shost, struct scsi_target * starget)
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
-	VirtDevice	 *vdevice;
+	VirtTarget	 *vtarget;
 	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": target reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
+	if ((hd = shost_priv(shost)) == NULL){
+		printk(KERN_ERR MYNAM ": target reset: Can't locate host!\n");
 		return FAILED;
 	}
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting target reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
-
-	vdevice = SCpnt->device->hostdata;
-	if (!vdevice || !vdevice->vtarget) {
+	printk(MYIOC_s_INFO_FMT "attempting target reset!\n", ioc->name);
+	vtarget = starget->hostdata;
+	if (!vtarget) {
 		retval = 0;
 		goto out;
 	}
 
 	/* Target reset to hidden raid component is not supported
 	 */
-	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
+	if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 		retval = FAILED;
 		goto out;
 	}
 
 	retval = mptscsih_IssueTaskMgmt(hd,
 				MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-				vdevice->vtarget->channel,
-				vdevice->vtarget->id, 0, 0,
+				vtarget->channel, vtarget->id, 0, 0,
 				mptscsih_get_tm_timeout(ioc));
 
  out:
-	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk (MYIOC_s_INFO_FMT "target reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	if (retval == 0)
 		return SUCCESS;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 54f2604..a5069a84 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,7 +120,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct Scsi_Host *, struct scsi_target *);
 extern int mptscsih_bus_reset(struct Scsi_Host *, int);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 9a336a1..af4dc93 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -825,6 +825,12 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	mptscsih_slave_destroy(sdev);
 }
 
+static int mptspi_eh_target_reset(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	return mptscsih_target_reset(shost, starget);
+}
+
 static struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
@@ -839,7 +845,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptspi_eh_target_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index dd7bea0..92a3902 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -309,9 +309,25 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
 }
 
-static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
+/*
+ * Note: We need to select a LUN as the storage array doesn't
+ * necessarily supports LUN 0 and might refuse the target reset.
+ */
+static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
 {
-	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_TGT_RESET);
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct scsi_device *sdev = NULL, *tmp_sdev;
+
+	shost_for_each_device(tmp_sdev, shost) {
+		if (tmp_sdev->id == starget->id) {
+			sdev = tmp_sdev;
+			break;
+		}
+	}
+	if (!sdev)
+		return FAILED;
+	return zfcp_task_mgmt_function(sdev, FCP_TMF_TGT_RESET);
 }
 
 static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1e157c6..7214600 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -947,10 +947,9 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
  *	@scsi_cmd:	SCSI command block causing the reset
  *
  */
-static int aac_eh_target_reset(struct scsi_cmnd *cmd)
+static int aac_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
+	struct Scsi_Host * host = dev_to_shost(&starget->dev);
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	struct aac_hba_map_info *info;
 	int count;
@@ -960,8 +959,8 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(starget->channel);
+	cid = starget->id;
 	info = &aac->hba_map[bus][cid];
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
 	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b5a88ce..2b0d14c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -363,11 +363,11 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	return rc;
 }
 
-static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_session_reset(struct scsi_target *starget)
 {
 	struct iscsi_cls_session *cls_session;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(starget);
 	return iscsi_eh_session_reset(cls_session);
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index ae77ba1..6613ef3 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -373,9 +373,8 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
  * Scsi_Host template entry, resets the target and abort all commands.
  */
 static int
-bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
+bfad_im_reset_target_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmnd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct bfad_itnim_data_s *itnim_data;
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b9c101f..d115281 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -540,7 +540,7 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
-int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt);
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
 				struct fc_rport_priv *rport,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 3be742a..7b8de5e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1058,9 +1058,9 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
  * Set from SCSI host template to send task mgmt command to the target
  *	and wait for the response
  */
-int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
+int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport *rport = starget_to_rport(sc_tgt);
 	struct fc_lport *lport = shost_priv(rport_to_shost(rport));
 
 	return bnx2fc_initiate_tmf(lport, rport, 0, FCP_TMF_TGT_RESET);
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index b63bab9..3ed1aca 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -979,7 +979,7 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
 int esas2r_device_reset(struct scsi_cmnd *cmd);
 int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct Scsi_Host *shost, int channel);
-int esas2r_target_reset(struct scsi_cmnd *cmd);
+int esas2r_target_reset(struct scsi_target *starget);
 
 /* Internal functions */
 int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 606bb82..f0aa2d4 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1164,10 +1164,11 @@ int esas2r_bus_reset(struct Scsi_Host *shost, int channel)
 	return esas2r_host_bus_reset(shost, false);
 }
 
-static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
+static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
+				 bool target_reset)
 {
 	struct esas2r_adapter *a =
-		(struct esas2r_adapter *)cmd->device->host->hostdata;
+		(struct esas2r_adapter *)shost->hostdata;
 	struct esas2r_request *rq;
 	u8 task_management_status = RS_PENDING;
 	bool completed;
@@ -1181,34 +1182,30 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 		if (target_reset) {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "target reset (%d)!",
-				   cmd->device->id);
+				   "target reset (%d)!", id);
 		} else {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "device reset (%d:%llu)!",
-				   cmd->device->id,
-				   cmd->device->lun);
+				   "device reset (%d:%llu)!", id, lun);
 		}
 
 
 		return FAILED;
 	}
 
-	rq->target_id = cmd->device->id;
-	rq->vrq->scsi.flags |= cpu_to_le32(cmd->device->lun);
+	rq->target_id = id;
+	rq->vrq->scsi.flags |= cpu_to_le32(lun);
 	rq->req_stat = RS_PENDING;
 
 	rq->comp_cb = complete_task_management_request;
 	rq->task_management_status_ptr = &task_management_status;
 
 	if (target_reset) {
-		esas2r_debug("issuing target reset (%p) to id %d", rq,
-			     cmd->device->id);
+		esas2r_debug("issuing target reset (%p) to id %d", rq, id);
 		completed = esas2r_send_task_mgmt(a, rq, 0x20);
 	} else {
-		esas2r_debug("issuing device reset (%p) to id %d lun %d", rq,
-			     cmd->device->id, cmd->device->lun);
+		esas2r_debug("issuing device reset (%p) to id %d lun %llu", rq,
+			     id, lun);
 		completed = esas2r_send_task_mgmt(a, rq, 0x10);
 	}
 
@@ -1242,17 +1239,22 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 
 int esas2r_device_reset(struct scsi_cmnd *cmd)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "device_reset (%p)", cmd);
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+
+	esas2r_log(ESAS2R_LOG_INFO, "device_reset");
 
-	return esas2r_dev_targ_reset(cmd, false);
+	return esas2r_dev_targ_reset(shost, sdev->id, sdev->lun, false);
 
 }
 
-int esas2r_target_reset(struct scsi_cmnd *cmd)
+int esas2r_target_reset(struct scsi_target *starget)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "target_reset (%p)", cmd);
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+
+	esas2r_log(ESAS2R_LOG_INFO, "target_reset");
 
-	return esas2r_dev_targ_reset(cmd, true);
+	return esas2r_dev_targ_reset(shost, starget->id, 0, true);
 }
 
 void esas2r_log_request_failure(struct esas2r_adapter *a,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 2e2a613..f7b9601 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2482,9 +2482,8 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
  * Returns:
  *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
-static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct ibmvfc_host *vhost = shost_priv(shost);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5bc685c..d51c9ba 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2521,12 +2521,12 @@ static int iscsi_eh_target_reset(struct iscsi_cls_session *cls_session)
  * This will attempt to send a warm target reset. If that fails,
  * we will escalate to ERL0 session recovery.
  */
-int iscsi_eh_recover_target(struct scsi_cmnd *sc)
+int iscsi_eh_recover_target(struct scsi_target *starget)
 {
 	struct iscsi_cls_session *cls_session;
 	int rc;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(starget);
 	rc = iscsi_eh_target_reset(cls_session);
 	if (rc == FAILED)
 		rc = iscsi_eh_session_reset(cls_session);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3c51da8..2001a6e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -526,11 +526,12 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	return FAILED;
 }
 
-int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
+int sas_eh_target_reset_handler(struct scsi_target *starget)
 {
 	int res;
-	struct Scsi_Host *host = cmd->device->host;
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct domain_device *dev = starget_to_domain_dev(starget);
+	struct sas_rphy *rphy = dev->rphy;
+	struct Scsi_Host *host = dev_to_shost(rphy->dev.parent);
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
 	if (current != host->ehandler)
@@ -562,7 +563,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 
 try_target_reset:
 	if (shost->hostt->eh_target_reset_handler)
-		return shost->hostt->eh_target_reset_handler(cmd);
+		return shost->hostt->eh_target_reset_handler(scsi_target(cmd->device));
 
 	return FAILED;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 107c0f6..573bd43 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5226,16 +5226,16 @@ void lpfc_poll_timeout(unsigned long ptr)
  *  0x2002 - Success
  **/
 static int
-lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_target_reset_handler(struct scsi_target *starget)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host  *shost = rport_to_shost(rport);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
-	unsigned tgt_id = cmnd->device->id;
-	uint64_t lun_id = cmnd->device->lun;
+	unsigned tgt_id = starget->id;
+	uint64_t lun_id = 0;
 	struct lpfc_scsi_event_header scsi_event;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int status;
 
 	rdata = rport->dd_data;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2b209bb..37f92a4 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2485,7 +2485,8 @@ void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
 void megasas_update_sdev_properties(struct scsi_device *sdev);
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
-int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
+int megasas_reset_target_fusion(struct Scsi_Host *shost,
+				struct scsi_target *starget);
 u32 mega_mod64(u64 dividend, u32 divisor);
 int megasas_alloc_fusion_context(struct megasas_instance *instance);
 void megasas_free_fusion_context(struct megasas_instance *instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 89e3fd6..0784f06 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2821,17 +2821,19 @@ static int megasas_task_abort(struct scsi_cmnd *scmd)
  *                        (supported only for fusion adapters)
  * @scmd:                 SCSI command pointer
  */
-static int megasas_reset_target(struct scsi_cmnd *scmd)
+static int megasas_reset_target(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret;
 	struct megasas_instance *instance;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 
 	if (instance->ctrl_context)
-		ret = megasas_reset_target_fusion(scmd);
+		ret = megasas_reset_target_fusion(shost, starget);
 	else {
-		sdev_printk(KERN_NOTICE, scmd->device, "TARGET RESET not supported\n");
+		starget_printk(KERN_NOTICE, starget,
+			       "TARGET RESET not supported\n");
 		ret = FAILED;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f990ab4d..db40ddf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4010,26 +4010,28 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 /*
  * megasas_reset_target_fusion : target reset function for fusion adapters
- * scmd: SCSI command pointer
+ * shost: SCSI host pointer
+ * starget: SCSI target pointer
  *
  * Returns SUCCESS if all commands associated with target aborted else FAILED
  */
 
-int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
+int megasas_reset_target_fusion(struct Scsi_Host *shost,
+				struct scsi_target *starget)
 {
 
 	struct megasas_instance *instance;
+	struct scsi_device *sdev;
 	int ret = FAILED;
 	u16 devhandle;
 	struct fusion_context *fusion;
-	struct MR_PRIV_DEVICE *mr_device_priv_data;
-	mr_device_priv_data = scmd->device->hostdata;
+	struct MR_PRIV_DEVICE *mr_device_priv_data = NULL;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 	fusion = instance->ctrl_context;
 
-	sdev_printk(KERN_INFO, scmd->device,
-		    "target reset called for scmd(%p)\n", scmd);
+	starget_printk(KERN_INFO, starget,
+		    "target reset called\n");
 
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
@@ -4038,42 +4040,43 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 		return ret;
 	}
 
+	shost_for_each_device(sdev, shost) {
+		if (!sdev->hostdata)
+			continue;
+		mr_device_priv_data = sdev->hostdata;
+		if (mr_device_priv_data->is_tm_capable) {
+			devhandle = megasas_get_tm_devhandle(sdev);
+			break;
+		}
+	}
+
 	if (!mr_device_priv_data) {
-		sdev_printk(KERN_INFO, scmd->device, "device been deleted! "
-			"scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
 		ret = SUCCESS;
 		goto out;
-	}
-
-
-	if (!mr_device_priv_data->is_tm_capable) {
+	} else if (!mr_device_priv_data->is_tm_capable) {
 		ret = FAILED;
 		goto out;
 	}
 
 	mutex_lock(&instance->reset_mutex);
-	devhandle = megasas_get_tm_devhandle(scmd->device);
-
 	if (devhandle == (u16)ULONG_MAX) {
 		ret = SUCCESS;
-		sdev_printk(KERN_INFO, scmd->device,
+		starget_printk(KERN_INFO, starget,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
 		goto out;
 	}
 
-	sdev_printk(KERN_INFO, scmd->device,
-		"attempting target reset! scmd(%p) tm_dev_handle 0x%x\n",
-		scmd, devhandle);
+	starget_printk(KERN_INFO, starget,
+		"attempting target reset! tm_dev_handle 0x%x\n", devhandle);
 	mr_device_priv_data->tm_busy = 1;
 	ret = megasas_issue_tm(instance, devhandle,
-			scmd->device->channel, scmd->device->id, 0,
+			starget->channel, starget->id, 0,
 			MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET);
 	mr_device_priv_data->tm_busy = 0;
 	mutex_unlock(&instance->reset_mutex);
 out:
-	scmd_printk(KERN_NOTICE, scmd, "megasas: target reset %s!!\n",
+	starget_printk(KERN_NOTICE, starget, "megasas: target reset %s!!\n",
 		(ret == SUCCESS) ? "SUCCESS" : "FAILED");
 
 	return ret;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ecf672..f3c2310 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2580,26 +2580,30 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_target_reset(struct scsi_cmnd *scmd)
+scsih_target_reset(struct scsi_target *starget)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_device *sdev = NULL, *tmp_sdev;
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct _sas_device *sas_device = NULL;
 	u16	handle;
 	int r;
-	struct scsi_target *starget = scmd->device->sdev_target;
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
-	starget_printk(KERN_INFO, starget, "attempting target reset! scmd(%p)\n",
-		scmd);
-	_scsih_tm_display_info(ioc, scmd);
+	starget_printk(KERN_INFO, starget, "attempting target reset!\n");
 
-	sas_device_priv_data = scmd->device->hostdata;
+	shost_for_each_device(tmp_sdev, shost) {
+		if (scsi_target(tmp_sdev) == starget) {
+			if (!tmp_sdev->hostdata)
+				continue;
+			sdev = tmp_sdev;
+			break;
+		}
+	}
+	sas_device_priv_data = sdev->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
-		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
-			scmd);
-		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		starget_printk(KERN_INFO, starget, "target been deleted!\n");
 		r = SUCCESS;
 		goto out;
 	}
@@ -2616,18 +2620,17 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, starget->channel,
+	    starget->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 	    30);
 
  out:
-	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
-	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	starget_printk(KERN_INFO, starget, "target reset: %s\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	if (sas_device)
 		sas_device_put(sas_device);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 35a6e34..289edfe 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2738,6 +2738,7 @@ static int pmcraid_reset_device(
 	u8 modifier
 )
 {
+	struct Scsi_Host *shost = scsi_dev->host;
 	struct pmcraid_cmd *cmd;
 	struct pmcraid_instance *pinstance;
 	struct pmcraid_resource_entry *res;
@@ -2745,10 +2746,9 @@ static int pmcraid_reset_device(
 	unsigned long lock_flags;
 	u32 ioasc;
 
-	pinstance =
-		(struct pmcraid_instance *)scsi_dev->host->hostdata;
-	res = scsi_dev->hostdata;
+	pinstance = (struct pmcraid_instance *)shost->hostdata;
 
+	res = scsi_dev->hostdata;
 	if (!res) {
 		sdev_printk(KERN_ERR, scsi_dev,
 			    "reset_device: NULL resource pointer\n");
@@ -3106,11 +3106,23 @@ static int pmcraid_eh_bus_reset_handler(struct Scsi_Host *host, int channel)
 				    RESET_DEVICE_BUS);
 }
 
-static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
 {
-	scmd_printk(KERN_INFO, scmd,
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_device *scsi_dev = NULL, *tmp;
+
+	shost_for_each_device(tmp, shost) {
+		if ((tmp->channel == starget->channel) &&
+		    (tmp->id == starget->id)) {
+			scsi_dev = tmp;
+			break;
+		}
+	}
+	if (!scsi_dev)
+		return FAILED;
+	sdev_printk(KERN_INFO, scsi_dev,
 		    "Doing target reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd->device,
+	return pmcraid_reset_device(scsi_dev,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
 }
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a0853ac..5ccfb14 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -617,9 +617,8 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	return rc;
 }
 
-static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
+static int qedf_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(sc_cmd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 
 	QEDF_ERR(NULL, "TARGET RESET Issued...");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c068041..2345695 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -273,7 +273,7 @@
 static int qla2xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
-static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_target_reset(struct scsi_target *);
 static int qla2xxx_eh_bus_reset(struct Scsi_Host *, int);
 static int qla2xxx_eh_host_reset(struct Scsi_Host *);
 
@@ -1446,10 +1446,9 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 }
 
 static int
-qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_device *sdev = cmd->device;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct fc_rport *rport = starget_to_rport(starget);
 	scsi_qla_host_t *vha = shost_priv(rport_to_shost(rport));
 	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport = (struct fc_port *) rport->dd_data;
@@ -1473,7 +1472,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "TARGET RESET ISSUED nexus=%ld:%d:0.\n", vha->host_no,
-	    cmd->device->id);
+	    starget->id);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
@@ -1482,13 +1481,14 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		goto eh_reset_failed;
 	}
 	err = 2;
-	if (ha->isp_ops->target_reset(fcport, 0, smp_processor_id() + 1)
+	if (ha->isp_ops->target_reset(fcport, starget->id,
+				      smp_processor_id() + 1)
 	    != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c, "do_reset failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+	if (qla2x00_eh_wait_for_pending_commands(vha, starget->id,
 		0, WAIT_TARGET) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
 		       "wait for pending cmds failed.\n");
@@ -1497,14 +1497,14 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 	ql_log(ql_log_info, vha, 0x800e,
 	    "TARGET RESET SUCCEEDED nexus:%ld:%d:0.\n",
-	    vha->host_no, sdev->id);
+	    vha->host_no, starget->id);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
 	    "TARGET RESET FAILED: %s nexus=%ld:%d:0\n",
-	    reset_errors[err], vha->host_no, sdev->id);
+	    reset_errors[err], vha->host_no, starget->id);
 	return FAILED;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 11bd2da..0ce84d6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -159,7 +159,7 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void  *data,
 static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_target_reset(struct scsi_target *starget);
 static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
@@ -9241,13 +9241,15 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	struct iscsi_cls_session *session;
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
 	int ret = FAILED, stat;
 
 	if (!ddb_entry)
 		return ret;
 
-	ret = iscsi_block_scsi_eh(cmd);
+	session = starget_to_session(scsi_target(cmd->device));
+	ret = iscsi_block_scsi_eh(session);
 	if (ret)
 		return ret;
 	ret = FAILED;
@@ -9300,53 +9302,56 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
  *
  * This routine is called by the Linux OS to reset the target.
  **/
-static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
+static int qla4xxx_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
-	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct iscsi_cls_session *cls_session = starget_to_session(starget);
+	struct iscsi_session *sess;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry;
 	int stat, ret;
 
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
 	if (!ddb_entry)
 		return FAILED;
+	ha = ddb_entry->ha;
 
-	ret = iscsi_block_scsi_eh(cmd);
+	ret = iscsi_block_scsi_eh(cls_session);
 	if (ret)
 		return ret;
 
-	starget_printk(KERN_INFO, scsi_target(cmd->device),
+	starget_printk(KERN_INFO, starget,
 		       "WARM TARGET RESET ISSUED.\n");
 
 	DEBUG2(printk(KERN_INFO
-		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
-		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
-		      ha->host_no, cmd, jiffies, cmd->request->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      "scsi%ld: TARGET_DEVICE_RESET jiffies = 0x%lx, "
+		      "dpc_flags=%lx\n",
+		      ha->host_no, jiffies, ha->dpc_flags));
 
 	stat = qla4xxx_reset_target(ha, ddb_entry);
 	if (stat != QLA_SUCCESS) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET RESET FAILED.\n");
 		return FAILED;
 	}
 
-	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
-					 NULL)) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+	if (qla4xxx_eh_wait_for_commands(ha, starget, NULL)) {
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
 			       "waiting for commands.\n");
 		return FAILED;
 	}
 
 	/* Send marker. */
-	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, 0,
 		MM_TGT_WARM_RESET) != QLA_SUCCESS) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
 			       "marker iocb failed.\n");
 		return FAILED;
 	}
 
-	starget_printk(KERN_INFO, scsi_target(cmd->device),
+	starget_printk(KERN_INFO, starget,
 		       "WARM TARGET RESET SUCCEEDED.\n");
 	return SUCCESS;
 }
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1e89598..37e511f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3809,39 +3809,30 @@ static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_target_reset(struct scsi_target *starget)
 {
+	struct Scsi_Host *hp = dev_to_shost(&starget->dev);
 	struct sdebug_host_info *sdbg_host;
 	struct sdebug_dev_info *devip;
-	struct scsi_device *sdp;
-	struct Scsi_Host *hp;
 	int k = 0;
 
 	++num_target_resets;
-	if (!SCpnt)
-		goto lie;
-	sdp = SCpnt->device;
-	if (!sdp)
-		goto lie;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-	hp = sdp->host;
-	if (!hp)
-		goto lie;
+		starget_printk(KERN_INFO, starget, "%s\n", __func__);
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
 	if (sdbg_host) {
 		list_for_each_entry(devip,
 				    &sdbg_host->dev_info_list,
 				    dev_list)
-			if (devip->target == sdp->id) {
+			if (devip->target == starget->id) {
 				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
 				++k;
 			}
 	}
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp,
+		starget_printk(KERN_INFO, starget,
 			    "%s: %d device(s) found in target\n", __func__, k);
-lie:
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9dd51ed..368a961 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -810,14 +810,15 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 	int rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
+	struct scsi_target *starget = scsi_target(scmd->device);
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_target_reset_handler(scmd);
+	rtn = hostt->eh_target_reset_handler(starget);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(scsi_target(scmd->device), NULL,
+		__starget_for_each_device(starget, NULL,
 					  __scsi_report_device_reset);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eae..88269f8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1855,17 +1855,15 @@ static void iscsi_scan_session(struct work_struct *work)
 
 /**
  * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
- * @cmd: scsi cmd passed to scsi eh handler
+ * @session: session to be blocked
  *
  * If the session is down this function will wait for the recovery
  * timer to fire or for the session to be logged back in. If the
  * recovery timer fires then FAST_IO_FAIL is returned. The caller
  * should pass this error value to the scsi eh.
  */
-int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
+int iscsi_block_scsi_eh(struct iscsi_cls_session *session)
 {
-	struct iscsi_cls_session *session =
-			starget_to_session(scsi_target(cmd->device));
 	unsigned long flags;
 	int ret = 0;
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6afebc4..757add6 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -641,9 +641,8 @@ static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
 }
 
-static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmd->device);
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 5091b31..1a10270 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -328,24 +328,25 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-static int tcm_loop_target_reset(struct scsi_cmnd *sc)
+static int tcm_loop_target_reset(struct scsi_target *starget)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 
 	/*
 	 * Locate the tcm_loop_hba_t pointer
 	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(shost);
 	if (!tl_hba) {
 		pr_err("Unable to perform device reset without"
 				" active I_T Nexus\n");
 		return FAILED;
 	}
 	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
+	 * Locate the tl_tpg pointer from TargetID in starget->id
 	 */
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	tl_tpg = &tl_hba->tl_hba_tpgs[starget->id];
 	if (tl_tpg) {
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
 		return SUCCESS;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d34daf8..a8fff96 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -381,7 +381,7 @@ struct iscsi_host {
  * scsi host template
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
-extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
+extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e7c012c..5953bcb 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -714,7 +714,7 @@ extern int sas_bios_param(struct scsi_device *,
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0c5ce78..33bc523 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -146,7 +146,7 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
-	int (* eh_target_reset_handler)(struct scsi_cmnd *);
+	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 6183d20..9e541d5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -444,7 +444,7 @@ extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
-extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
+extern int iscsi_block_scsi_eh(struct iscsi_cls_session *session);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
 					      uint32_t iface_type,
-- 
1.8.5.6
