From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] scsi: use 64-bit LUNs
Date: Sat, 31 May 2014 11:01:16 +0200
Message-ID: <1401526878-119472-5-git-send-email-hare@suse.de>
References: <1401526878-119472-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbaEaJBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 May 2014 05:01:24 -0400
In-Reply-To: <1401526878-119472-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The SCSI standard defines 64-bit values for LUNs, and large arrays
employing large or hierarchical LUN numbers become more and more
common.

So update the linux SCSI stack to use 64-bit LUN numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Ewan Milne <emilne@redhat.com>
---
 drivers/ata/libata-scsi.c           |  2 +-
 drivers/ata/libata.h                |  2 +-
 drivers/message/fusion/mptscsih.c   |  2 +-
 drivers/message/i2o/i2o_scsi.c      | 11 ++++----
 drivers/s390/scsi/zfcp_dbf.c        |  3 ++-
 drivers/s390/scsi/zfcp_unit.c       |  4 +--
 drivers/scsi/NCR5380.c              |  2 +-
 drivers/scsi/aacraid/linit.c        |  2 +-
 drivers/scsi/aha152x.c              |  6 ++---
 drivers/scsi/aic7xxx/aic79xx.h      |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  6 ++---
 drivers/scsi/aic7xxx/aic79xx_proc.c |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 11 ++++----
 drivers/scsi/aic7xxx/aic7xxx_proc.c |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c    |  8 +++---
 drivers/scsi/csiostor/csio_scsi.c   | 24 ++++++++---------
 drivers/scsi/dc395x.c               | 40 +++++++++++++--------------
 drivers/scsi/eata.c                 |  2 +-
 drivers/scsi/fnic/fnic_scsi.c       |  4 +--
 drivers/scsi/hpsa.c                 |  2 +-
 drivers/scsi/libiscsi.c             |  8 +++---
 drivers/scsi/libsas/sas_scsi_host.c | 11 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c       | 36 ++++++++++++-------------
 drivers/scsi/megaraid.c             |  4 +--
 drivers/scsi/megaraid/mega_common.h |  2 +-
 drivers/scsi/pmcraid.c              |  2 +-
 drivers/scsi/qla2xxx/qla_def.h      |  6 ++---
 drivers/scsi/qla2xxx/qla_gbl.h      | 16 +++++------
 drivers/scsi/qla2xxx/qla_iocb.c     | 11 ++++----
 drivers/scsi/qla2xxx/qla_isr.c      |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c      | 12 ++++-----
 drivers/scsi/qla2xxx/qla_mr.c       |  8 +++---
 drivers/scsi/qla2xxx/qla_os.c       | 35 +++++++++++++-----------
 drivers/scsi/qla4xxx/ql4_glbl.h     |  4 +--
 drivers/scsi/qla4xxx/ql4_iocb.c     |  2 +-
 drivers/scsi/qla4xxx/ql4_isr.c      | 22 +++++++--------
 drivers/scsi/qla4xxx/ql4_mbx.c      |  6 ++---
 drivers/scsi/qla4xxx/ql4_os.c       | 20 +++++++-------
 drivers/scsi/scsi.c                 |  8 +++---
 drivers/scsi/scsi_debug.c           | 15 ++++++-----
 drivers/scsi/scsi_priv.h            |  2 +-
 drivers/scsi/scsi_proc.c            |  2 +-
 drivers/scsi/scsi_scan.c            | 54 +++++++++++++------------------------
 drivers/scsi/scsi_sysfs.c           | 14 +++++-----
 drivers/scsi/scsi_transport_fc.c    |  4 +--
 drivers/scsi/scsi_transport_iscsi.c |  4 +--
 drivers/scsi/scsi_transport_sas.c   |  2 +-
 drivers/scsi/sg.c                   |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h |  2 +-
 drivers/target/loopback/tcm_loop.c  |  2 +-
 drivers/target/target_core_pscsi.c  | 12 ++++-----
 drivers/usb/storage/sddr09.c        |  4 +--
 drivers/usb/storage/usb.c           | 10 ++++---
 include/scsi/scsi.h                 |  2 +-
 include/scsi/scsi_device.h          | 22 +++++++--------
 include/scsi/scsi_transport.h       |  2 +-
 57 files changed, 252 insertions(+), 261 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef8567d..1ea1a04 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3941,7 +3941,7 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	Zero.
  */
 int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-		       unsigned int id, unsigned int lun)
+		       unsigned int id, u64 lun)
 {
 	struct ata_port *ap = ata_shost_to_port(shost);
 	unsigned long flags;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 45b5ab3..5f4e0cc 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -144,7 +144,7 @@ extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
 extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun);
+			      unsigned int id, u64 lun);
 
 
 /* libata-eh.c */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..fc55da7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -692,7 +692,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		 */
 		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
 		    pScsiReply->ResponseInfo) {
-			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
+			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%llu] "
 			"FCP_ResponseInfo=%08xh\n", ioc->name,
 			sc->device->host->host_no, sc->device->channel,
 			sc->device->id, sc->device->lun,
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1d31d72..e7de92c 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -78,7 +78,7 @@ static unsigned int i2o_scsi_max_lun = 255;
 struct i2o_scsi_host {
 	struct Scsi_Host *scsi_host;	/* pointer to the SCSI host */
 	struct i2o_controller *iop;	/* pointer to the I2O controller */
-	unsigned int lun;	/* lun's used for block devices */
+	u64 lun;	/* lun's used for block devices */
 	struct i2o_device *channel[0];	/* channel->i2o_dev mapping table */
 };
 
@@ -287,9 +287,8 @@ static int i2o_scsi_probe(struct device *dev)
 	}
 
 	if (le64_to_cpu(lun) >= scsi_host->max_lun) {
-		osm_warn("SCSI device lun (%lu) >= max_lun of I2O host (%d)",
-			 (long unsigned int)le64_to_cpu(lun),
-			 scsi_host->max_lun);
+		osm_warn("SCSI device lun (%llu) >= max_lun of I2O host (%d)",
+			 le64_to_cpu(lun), scsi_host->max_lun);
 		return -EFAULT;
 	}
 
@@ -308,9 +307,9 @@ static int i2o_scsi_probe(struct device *dev)
 	if (rc)
 		goto err;
 
-	osm_info("device added (TID: %03x) channel: %d, id: %d, lun: %ld\n",
+	osm_info("device added (TID: %03x) channel: %d, id: %d, lun: %llu\n",
 		 i2o_dev->lct_data.tid, channel, le32_to_cpu(id),
-		 (long unsigned int)le64_to_cpu(lun));
+		 le64_to_cpu(lun));
 
 	return 0;
 
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 0ca6448..5d7fbe4 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -418,7 +418,8 @@ void zfcp_dbf_scsi(char *tag, struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf)
 	rec->scsi_retries = sc->retries;
 	rec->scsi_allowed = sc->allowed;
 	rec->scsi_id = sc->device->id;
-	rec->scsi_lun = sc->device->lun;
+	/* struct zfcp_dbf_scsi needs to be updated to handle 64bit LUNs */
+	rec->scsi_lun = (u32)sc->device->lun;
 	rec->host_scribble = (unsigned long)sc->host_scribble;
 
 	memcpy(rec->scsi_opcode, sc->cmnd,
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 39f5446..157d3d2 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -21,7 +21,7 @@
 void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
 {
 	struct fc_rport *rport = unit->port->rport;
-	unsigned int lun;
+	u64 lun;
 
 	lun = scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
 
@@ -188,7 +188,7 @@ struct scsi_device *zfcp_unit_sdev(struct zfcp_unit *unit)
 {
 	struct Scsi_Host *shost;
 	struct zfcp_port *port;
-	unsigned int lun;
+	u64 lun;
 
 	lun = scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
 	port = unit->port;
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index bcd2238..f21d193 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -771,7 +771,7 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 
 static void lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, struct seq_file *m)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, (u8)cmd->device->lun);
 	SPRINTF("        command = ");
 	lprint_command(cmd->cmnd, m);
 }
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4921ed1..63f576c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -551,7 +551,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	int count;
 	int ret = FAILED;
 
-	printk(KERN_ERR "%s: Host adapter abort request (%d,%d,%d,%d)\n",
+	printk(KERN_ERR "%s: Host adapter abort request (%d,%d,%d,%llu)\n",
 		AAC_DRIVERNAME,
 		host->host_no, sdev_channel(dev), sdev_id(dev), dev->lun);
 	switch (cmd->cmnd[0]) {
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e86eb6a..e77b72f 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -321,7 +321,7 @@ static LIST_HEAD(aha152x_host_list);
 #define CMDINFO(cmd) \
 			(cmd) ? ((cmd)->device->host->host_no) : -1, \
                         (cmd) ? ((cmd)->device->id & 0x0f) : -1, \
-			(cmd) ? ((cmd)->device->lun & 0x07) : -1
+			(cmd) ? ((u8)(cmd)->device->lun & 0x07) : -1
 
 static inline void
 CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
@@ -1602,7 +1602,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #if defined(AHA152X_DEBUG)
 			int hostno=DONE_SC->device->host->host_no;
 			int id=DONE_SC->device->id & 0xf;
-			int lun=DONE_SC->device->lun & 0x7;
+			int lun=((u8)DONE_SC->device->lun) & 0x7;
 #endif
 			Scsi_Cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
@@ -2984,7 +2984,7 @@ static void get_command(struct seq_file *m, Scsi_Cmnd * ptr)
 	int i;
 
 	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
-		ptr, ptr->device->id, ptr->device->lun);
+		ptr, ptr->device->id, (u8)ptr->device->lun);
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 9b05942..cc85da2 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -115,7 +115,7 @@ struct scb_platform_data;
 #endif
 
 #define AHD_BUILD_COL_IDX(target, lun)				\
-	(((lun) << 4) | target)
+	((((u8)lun) << 4) | target)
 
 #define AHD_GET_SCB_COL_IDX(ahd, scb)				\
 	((SCB_GET_LUN(scb) << 4) | SCB_GET_TARGET(ahd, scb))
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 69d5c43..ed333669 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2137,7 +2137,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 	if (do_fallback) {
 		printk("%s: device overrun (status %x) on %d:%d:%d\n",
 		       ahd_name(ahd), status, cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		       cmd->device->id, (u8)cmd->device->lun);
 	}
 
 	ahd_cmd_set_transaction_status(cmd, new_status);
@@ -2253,13 +2253,13 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	disconnected = TRUE;
 	if (ahd_search_qinfifo(ahd, cmd->device->id, 
 			       cmd->device->channel + 'A',
-			       cmd->device->lun, 
+			       cmd->device->lun,
 			       pending_scb->hscb->tag,
 			       ROLE_INITIATOR, CAM_REQ_ABORTED,
 			       SEARCH_COMPLETE) > 0) {
 		printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 		       ahd_name(ahd), cmd->device->channel, 
-		       cmd->device->id, cmd->device->lun);
+		       cmd->device->id, (u8)cmd->device->lun);
 		retval = SUCCESS;
 		goto done;
 	}
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
index e9778b4..27dbfcc 100644
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -197,7 +197,7 @@ ahd_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 
 	seq_printf(m, "\tChannel %c Target %d Lun %d Settings\n",
 		  sdev->sdev_target->channel + 'A',
-		  sdev->sdev_target->id, sdev->lun);
+		   sdev->sdev_target->id, (u8)sdev->lun);
 
 	seq_printf(m, "\t\tCommands Queued %ld\n", dev->commands_issued);
 	seq_printf(m, "\t\tCommands Active %d\n", dev->active);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index c0c6258..d2b17fc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2120,7 +2120,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 */
 		printk("%s:%d:%d:%d: Is not an active device\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		       (u8)cmd->device->lun);
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2128,11 +2128,11 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
 				       cmd->device->channel + 'A',
-				       cmd->device->lun,
+				       (u8)cmd->device->lun,
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
 		printk("%s:%d:%d:%d: Command found on untagged queue\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		       (u8)cmd->device->lun);
 		retval = SUCCESS;
 		goto done;
 	}
@@ -2198,13 +2198,14 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 				       SEARCH_COMPLETE) > 0) {
 			printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 			       ahc_name(ahc), cmd->device->channel,
-					cmd->device->id, cmd->device->lun);
+			       cmd->device->id, (u8)cmd->device->lun);
 			retval = SUCCESS;
 			goto done;
 		}
 	} else if (ahc_search_qinfifo(ahc, cmd->device->id,
 				      cmd->device->channel + 'A',
-				      cmd->device->lun, pending_scb->hscb->tag,
+				      cmd->device->lun,
+				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
 		disconnected = FALSE;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
index 383a3d1..64eec6c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -175,7 +175,7 @@ ahc_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 
 	seq_printf(m, "\tChannel %c Target %d Lun %d Settings\n",
 		  sdev->sdev_target->channel + 'A',
-		  sdev->sdev_target->id, sdev->lun);
+		   sdev->sdev_target->id, (u8)sdev->lun);
 
 	seq_printf(m, "\t\tCommands Queued %ld\n", dev->commands_issued);
 	seq_printf(m, "\t\tCommands Active %d\n", dev->active);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 652b41b..b13764c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2335,7 +2335,7 @@ static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 					" poll command abort successfully \n"
 					, acb->host->host_no
 					, ccb->pcmd->device->id
-					, ccb->pcmd->device->lun
+					, (u32)ccb->pcmd->device->lun
 					, ccb);
 				ccb->pcmd->result = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
@@ -2399,7 +2399,7 @@ static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 					" poll command abort successfully \n"
 					,acb->host->host_no
 					,ccb->pcmd->device->id
-					,ccb->pcmd->device->lun
+					,(u32)ccb->pcmd->device->lun
 					,ccb);
 				ccb->pcmd->result = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
@@ -2456,7 +2456,7 @@ polling_hbc_ccb_retry:
 					" poll command abort successfully \n"
 					, acb->host->host_no
 					, pCCB->pcmd->device->id
-					, pCCB->pcmd->device->lun
+					, (u32)pCCB->pcmd->device->lun
 					, pCCB);
 					pCCB->pcmd->result = DID_ABORT << 16;
 					arcmsr_ccb_complete(pCCB);
@@ -3058,7 +3058,7 @@ static int arcmsr_abort(struct scsi_cmnd *cmd)
 	int rtn = FAILED;
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d \n",
-		acb->host->host_no, cmd->device->id, cmd->device->lun);
+		acb->host->host_no, cmd->device->id, (u32)cmd->device->lun);
 	acb->acb_flags |= ACB_F_ABORT;
 	acb->num_aborts++;
 	/*
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 7494e4b..86103c8 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1657,7 +1657,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	case FW_SCSI_UNDER_FLOW_ERR:
 		csio_warn(hw,
 			  "Under-flow error,cmnd:0x%x expected"
-			  " len:0x%x resid:0x%x lun:0x%x ssn:0x%x\n",
+			  " len:0x%x resid:0x%x lun:0x%llx ssn:0x%x\n",
 			  cmnd->cmnd[0], scsi_bufflen(cmnd),
 			  scsi_get_resid(cmnd), cmnd->device->lun,
 			  rn->flowid);
@@ -1957,7 +1957,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 
 	csio_dbg(hw,
 		 "Request to abort ioreq:%p cmd:%p cdb:%08llx"
-		 " ssni:0x%x lun:%d iq:0x%x\n",
+		 " ssni:0x%x lun:%llu iq:0x%x\n",
 		ioreq, cmnd, *((uint64_t *)cmnd->cmnd), rn->flowid,
 		cmnd->device->lun, csio_q_physiqid(hw, ioreq->iq_idx));
 
@@ -2015,13 +2015,13 @@ inval_scmnd:
 	/* FW successfully aborted the request */
 	if (host_byte(cmnd->result) == DID_REQUEUE) {
 		csio_info(hw,
-			"Aborted SCSI command to (%d:%d) serial#:0x%lx\n",
+			"Aborted SCSI command to (%d:%llu) serial#:0x%lx\n",
 			cmnd->device->id, cmnd->device->lun,
 			cmnd->serial_number);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
-			"Failed to abort SCSI command, (%d:%d) serial#:0x%lx\n",
+			"Failed to abort SCSI command, (%d:%llu) serial#:0x%lx\n",
 			cmnd->device->id, cmnd->device->lun,
 			cmnd->serial_number);
 		return FAILED;
@@ -2100,13 +2100,13 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (!rn)
 		goto fail;
 
-	csio_dbg(hw, "Request to reset LUN:%d (ssni:0x%x tgtid:%d)\n",
+	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
 
 	if (!csio_is_lnode_ready(ln)) {
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
-			 " local node vnpi:0x%x (LUN:%d)\n",
+			 " local node vnpi:0x%x (LUN:%llu)\n",
 			 ln->vnp_flowid, cmnd->device->lun);
 		goto fail;
 	}
@@ -2126,7 +2126,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (fc_remote_port_chkready(rn->rport)) {
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
-			 " remote node ssni:0x%x (LUN:%d)\n",
+			 " remote node ssni:0x%x (LUN:%llu)\n",
 			 rn->flowid, cmnd->device->lun);
 		goto fail;
 	}
@@ -2168,7 +2168,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = (uint64_t)cmnd->device->lun;
+	sld.oslun = cmnd->device->lun;
 
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
@@ -2190,7 +2190,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 
 	/* LUN reset timed-out */
 	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
-		csio_err(hw, "LUN reset (%d:%d) timed out\n",
+		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
 			 cmnd->device->id, cmnd->device->lun);
 
 		spin_lock_irq(&hw->lock);
@@ -2203,7 +2203,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 
 	/* LUN reset returned, check cached status */
 	if (cmnd->SCp.Status != FW_SUCCESS) {
-		csio_err(hw, "LUN reset failed (%d:%d), status: %d\n",
+		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
 			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
 		goto fail;
 	}
@@ -2223,7 +2223,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	/* Aborts may have timed out */
 	if (retval != 0) {
 		csio_err(hw,
-			 "Attempt to abort I/Os during LUN reset of %d"
+			 "Attempt to abort I/Os during LUN reset of %llu"
 			 " returned %d\n", cmnd->device->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
@@ -2234,7 +2234,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 
 	CSIO_INC_STATS(rn, n_lun_rst);
 
-	csio_info(hw, "LUN reset occurred (%d:%d)\n",
+	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
 		  cmnd->device->id, cmnd->device->lun);
 
 	return SUCCESS;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index ad7bee0..dff461f 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1087,7 +1087,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkdbg(DBG_0, "queue_command: (0x%p) <%02i-%i> cmnd=0x%02x\n",
-		cmd, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+		cmd, cmd->device->id, (u8)cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
@@ -1102,7 +1102,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 	/* does the specified lun on the specified device exist */
 	if (!(acb->dcb_map[cmd->device->id] & (1 << cmd->device->lun))) {
 		dprintkl(KERN_INFO, "queue_command: Ignore target <%02i-%i>\n",
-			cmd->device->id, cmd->device->lun);
+			cmd->device->id, (u8)cmd->device->lun);
 		goto complete;
 	}
 
@@ -1111,7 +1111,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 	if (!dcb) {
 		/* should never happen */
 		dprintkl(KERN_ERR, "queue_command: No such device <%02i-%i>",
-			cmd->device->id, cmd->device->lun);
+			cmd->device->id, (u8)cmd->device->lun);
 		goto complete;
 	}
 
@@ -1207,7 +1207,7 @@ static void dump_register_info(struct AdapterCtlBlk *acb,
 				 "cmnd=0x%02x <%02i-%i>\n",
 				srb, srb->cmd,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
-			       	srb->cmd->device->lun);
+				(u8)srb->cmd->device->lun);
 		printk("  sglist=%p cnt=%i idx=%i len=%zu\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
@@ -1302,7 +1302,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkl(KERN_INFO,
 		"eh_bus_reset: (0%p) target=<%02i-%i> cmd=%p\n",
-		cmd, cmd->device->id, cmd->device->lun, cmd);
+		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1369,7 +1369,7 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 	dprintkl(KERN_INFO, "eh_abort: (0x%p) target=<%02i-%i> cmd=%p\n",
-		cmd, cmd->device->id, cmd->device->lun, cmd);
+		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
 
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
@@ -1605,7 +1605,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 			dprintkl(KERN_WARNING, "start_scsi: (0x%p) "
 				"Out of tags target=<%02i-%i>)\n",
 				srb->cmd, srb->cmd->device->id,
-				srb->cmd->device->lun);
+				(u8)srb->cmd->device->lun);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 				       DO_HWRESELECT);
@@ -1623,7 +1623,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (0x%p) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -2041,7 +2041,7 @@ static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2171,7 +2171,7 @@ static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2183,7 +2183,7 @@ static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 
 	dprintkdbg(DBG_0, "data_in_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2394,7 +2394,7 @@ static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2406,7 +2406,7 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (0x%p) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2579,7 +2579,7 @@ static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2593,7 +2593,7 @@ static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -3318,7 +3318,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	int ckc_only = 1;
 
 	dprintkdbg(DBG_1, "srb_done: (0x%p) <%02i-%i>\n", srb->cmd,
-		srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->device->id, (u8)srb->cmd->device->lun);
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		   srb, scsi_sg_count(cmd), srb->sg_index, srb->sg_count,
 		   scsi_sgtalbe(cmd));
@@ -3498,7 +3498,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd, cmd->device->id, cmd->device->lun,
+				cmd, cmd->device->id, (u8)cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3538,7 +3538,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("G:%p(%02i-%i) ", p,
-			       p->device->id, p->device->lun);
+			       p->device->id, (u8)p->device->lun);
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3568,7 +3568,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("W:%p<%02i-%i>", p, p->device->id,
-			       p->device->lun);
+			       (u8)p->device->lun);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
 			p->result = result;
@@ -3677,7 +3677,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (0x%p) <%02i-%i>\n",
-		cmd, cmd->device->id, cmd->device->lun);
+		cmd, cmd->device->id, (u8)cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index ebf5736..0f27ac1 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2449,7 +2449,7 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
-			       SCpnt->device->lun,
+			       (u8)SCpnt->device->lun,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
 		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0521436..11e987d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1751,7 +1751,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	tag = sc->request->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
-		"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %x flags %x\n",
+		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
 		rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
 
 	CMD_FLAGS(sc) = FNIC_NO_FLAGS;
@@ -2206,7 +2206,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%x sc 0x%p\n",
+		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
 		      rport->port_id, sc->device->lun, sc);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9a6e4a2..a3d7f69 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4582,7 +4582,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "ABORT REQUEST on C%d:B%d:T%d:L%d ",
+	ml += sprintf(msg+ml, "ABORT REQUEST on C%d:B%d:T%d:L%llu ",
 		h->scsi_host->host_no, sc->device->channel,
 		sc->device->id, sc->device->lun);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 26dc005b..14776d5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -260,7 +260,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_tm *tmf = &conn->tmhdr;
-	unsigned int hdr_lun;
+	u64 hdr_lun;
 
 	if (conn->tmf_state == TMF_INITIAL)
 		return 0;
@@ -1859,8 +1859,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
  * Fail commands. session lock held and recv side suspended and xmit
  * thread flushed
  */
-static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
-			    int error)
+static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 {
 	struct iscsi_task *task;
 	int i;
@@ -2279,7 +2278,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
+	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %llu]\n", sc,
+		     sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 25d0f12..7d02a19 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -404,7 +404,7 @@ static int sas_recover_lu(struct domain_device *dev, struct scsi_cmnd *cmd)
 
 	int_to_scsilun(cmd->device->lun, &lun);
 
-	SAS_DPRINTK("eh: device %llx LUN %x has the task\n",
+	SAS_DPRINTK("eh: device %llx LUN %llx has the task\n",
 		    SAS_ADDR(dev->sas_addr),
 		    cmd->device->lun);
 
@@ -490,7 +490,8 @@ static void sas_wait_eh(struct domain_device *dev)
 }
 EXPORT_SYMBOL(sas_wait_eh);
 
-static int sas_queue_reset(struct domain_device *dev, int reset_type, int lun, int wait)
+static int sas_queue_reset(struct domain_device *dev, int reset_type,
+			   u64 lun, int wait)
 {
 	struct sas_ha_struct *ha = dev->port->ha;
 	int scheduled = 0, tries = 100;
@@ -689,7 +690,7 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
  reset:
 			tmf_resp = sas_recover_lu(task->dev, cmd);
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
-				SAS_DPRINTK("dev %016llx LU %x is "
+				SAS_DPRINTK("dev %016llx LU %llx is "
 					    "recovered\n",
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
@@ -742,7 +743,7 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 			 * of effort could recover from errors.  Quite
 			 * possibly the HA just disappeared.
 			 */
-			SAS_DPRINTK("error from  device %llx, LUN %x "
+			SAS_DPRINTK("error from  device %llx, LUN %llx "
 				    "couldn't be recovered in any way\n",
 				    SAS_ADDR(task->dev->sas_addr),
 				    cmd->device->lun);
@@ -941,7 +942,7 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 		scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
 		scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
 	} else {
-		SAS_DPRINTK("device %llx, LUN %x doesn't support "
+		SAS_DPRINTK("device %llx, LUN %llx doesn't support "
 			    "TCQ\n", SAS_ADDR(dev->sas_addr),
 			    scsi_dev->lun);
 		scsi_dev->tagged_supported = 0;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 462453e..0f18b64 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -258,7 +258,7 @@ static void
 lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 		struct lpfc_vport  *vport,
 		struct lpfc_nodelist *ndlp,
-		uint32_t lun,
+		uint64_t lun,
 		uint32_t old_val,
 		uint32_t new_val)
 {
@@ -3823,7 +3823,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		if (rsplen != 0 && rsplen != 4 && rsplen != 8) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2719 Invalid response length: "
-				 "tgt x%x lun x%x cmnd x%x rsplen x%x\n",
+				 "tgt x%x lun x%llx cmnd x%x rsplen x%x\n",
 				 cmnd->device->id,
 				 cmnd->device->lun, cmnd->cmnd[0],
 				 rsplen);
@@ -3834,7 +3834,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2757 Protocol failure detected during "
 				 "processing of FCP I/O op: "
-				 "tgt x%x lun x%x cmnd x%x rspInfo3 x%x\n",
+				 "tgt x%x lun x%llx cmnd x%x rspInfo3 x%x\n",
 				 cmnd->device->id,
 				 cmnd->device->lun, cmnd->cmnd[0],
 				 fcprsp->rspInfo3);
@@ -4045,7 +4045,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		else
 			logit = LOG_FCP | LOG_FCP_UNDER;
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
-			 "9030 FCP cmd x%x failed <%d/%d> "
+			 "9030 FCP cmd x%x failed <%d/%lld> "
 			 "status: x%x result: x%x "
 			 "sid: x%x did: x%x oxid: x%x "
 			 "Data: x%x x%x\n",
@@ -4157,7 +4157,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "0710 Iodone <%d/%d> cmd %p, error "
+				 "0710 Iodone <%d/%llu> cmd %p, error "
 				 "x%x SNS x%x x%x Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
 				 cmd->result, *lp, *(lp + 3), cmd->retries,
@@ -4389,7 +4389,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 static int
 lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 			     struct lpfc_scsi_buf *lpfc_cmd,
-			     unsigned int lun,
+			     uint64_t lun,
 			     uint8_t task_mgmt_cmd)
 {
 	struct lpfc_iocbq *piocbq;
@@ -4718,12 +4718,12 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		atomic_dec(&ndlp->cmd_pending);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "3376 FCP could not issue IOCB err %x"
-				 "FCP cmd x%x <%d/%d> "
+				 "FCP cmd x%x <%d/%llu> "
 				 "sid: x%x did: x%x oxid: x%x "
 				 "Data: x%x x%x x%x x%x\n",
 				 err, cmnd->cmnd[0],
 				 cmnd->device ? cmnd->device->id : 0xffff,
-				 cmnd->device ? cmnd->device->lun : 0xffff,
+				 cmnd->device ? cmnd->device->lun : (u64) -1,
 				 vport->fc_myDID, ndlp->nlp_DID,
 				 phba->sli_rev == LPFC_SLI_REV4 ?
 				 lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
@@ -4804,7 +4804,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
-			 "x%x ID %d LUN %d\n",
+			 "x%x ID %d LUN %llu\n",
 			 SUCCESS, cmnd->device->id, cmnd->device->lun);
 		return SUCCESS;
 	}
@@ -4897,7 +4897,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
 				 "for abortng I/O (xri:x%x) to complete: "
-				 "ret %#x, ID %d, LUN %d\n",
+				 "ret %#x, ID %d, LUN %llu\n",
 				 iocb->sli4_xritag, ret,
 				 cmnd->device->id, cmnd->device->lun);
 	}
@@ -4908,7 +4908,7 @@ out_unlock:
 out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
-			 "LUN %d\n", ret, cmnd->device->id,
+			 "LUN %llu\n", ret, cmnd->device->id,
 			 cmnd->device->lun);
 	return ret;
 }
@@ -5020,7 +5020,7 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
  **/
 static int
 lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
-		    unsigned  tgt_id, unsigned int lun_id,
+		    unsigned  tgt_id, uint64_t lun_id,
 		    uint8_t task_mgmt_cmd)
 {
 	struct lpfc_hba   *phba = vport->phba;
@@ -5056,7 +5056,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 	iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0702 Issue %s to TGT %d LUN %d "
+			 "0702 Issue %s to TGT %d LUN %llu "
 			 "rpi x%x nlp_flag x%x Data: x%x x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
 			 pnode->nlp_rpi, pnode->nlp_flag, iocbq->sli4_xritag,
@@ -5067,7 +5067,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 	if ((status != IOCB_SUCCESS) ||
 	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d) "
+			 "0727 TMF %s to TGT %d LUN %llu failed (%d, %d) "
 			 "iocb_flag x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd),
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
@@ -5210,7 +5210,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
-	unsigned int lun_id = cmnd->device->lun;
+	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
@@ -5245,7 +5245,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 						FCP_LUN_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0713 SCSI layer issued Device Reset (%d, %d) "
+			 "0713 SCSI layer issued Device Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
 	/*
@@ -5280,7 +5280,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
-	unsigned int lun_id = cmnd->device->lun;
+	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
@@ -5315,7 +5315,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 					FCP_TARGET_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0723 SCSI layer issued Target Reset (%d, %d) "
+			 "0723 SCSI layer issued Target Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
 	/*
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index b777051..6bb2b52 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1941,8 +1941,8 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 
 	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
 	     (aor == SCB_ABORT)? "ABORTING":"RESET",
-	     cmd->cmnd[0], cmd->device->channel, 
-	     cmd->device->id, cmd->device->lun);
+	     cmd->cmnd[0], cmd->device->channel,
+	     cmd->device->id, (u32)cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
 		return FALSE;
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 5ead128..1d037ed 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -204,7 +204,7 @@ typedef struct {
 #define SCP2HOSTDATA(scp)		SCP2HOST(scp)->hostdata	// to soft state
 #define SCP2CHANNEL(scp)		(scp)->device->channel	// to channel
 #define SCP2TARGET(scp)			(scp)->device->id	// to target
-#define SCP2LUN(scp)			(scp)->device->lun	// to LUN
+#define SCP2LUN(scp)			(u32)(scp)->device->lun	// to LUN
 
 // generic macro to convert scsi command and host to controller's soft state
 #define SCSIHOST2ADAP(host)	(((caddr_t *)(host->hostdata))[0])
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..017f8b9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -237,7 +237,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 		     scsi_dev->host->unique_id,
 		     scsi_dev->channel,
 		     scsi_dev->id,
-		     scsi_dev->lun);
+		     (u8)scsi_dev->lun);
 
 	if (RES_IS_GSCSI(res->cfg_entry)) {
 		scsi_dev->allow_restart = 1;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6a10613..6eb7fd9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -320,8 +320,8 @@ struct srb_iocb {
 			 * defined in tsk_mgmt_entry struct
 			 * for control_flags field in qla_fw.h.
 			 */
+			uint64_t lun;
 			uint32_t flags;
-			uint32_t lun;
 			uint32_t data;
 			struct completion comp;
 			__le16 comp_status;
@@ -2510,8 +2510,8 @@ struct isp_operations {
 	void (*disable_intrs) (struct qla_hw_data *);
 
 	int (*abort_command) (srb_t *);
-	int (*target_reset) (struct fc_port *, unsigned int, int);
-	int (*lun_reset) (struct fc_port *, unsigned int, int);
+	int (*target_reset) (struct fc_port *, uint64_t, int);
+	int (*lun_reset) (struct fc_port *, uint64_t, int);
 	int (*fabric_login) (struct scsi_qla_host *, uint16_t, uint8_t,
 		uint8_t, uint8_t, uint16_t *, uint8_t);
 	int (*fabric_logout) (struct scsi_qla_host *, uint16_t, uint8_t,
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e665e81..8f9ef8c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -212,7 +212,7 @@ extern void qla2x00_build_scsi_iocbs_64(srb_t *, cmd_entry_t *, uint16_t);
 extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
-						uint16_t, uint16_t, uint8_t);
+						uint16_t, uint64_t, uint8_t);
 extern int qla2x00_start_sp(srb_t *);
 extern int qla24xx_dif_start_scsi(srb_t *);
 extern int qla2x00_start_bidir(srb_t *, struct scsi_qla_host *, uint32_t);
@@ -255,10 +255,10 @@ extern int
 qla2x00_abort_command(srb_t *);
 
 extern int
-qla2x00_abort_target(struct fc_port *, unsigned int, int);
+qla2x00_abort_target(struct fc_port *, uint64_t, int);
 
 extern int
-qla2x00_lun_reset(struct fc_port *, unsigned int, int);
+qla2x00_lun_reset(struct fc_port *, uint64_t, int);
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
@@ -332,12 +332,12 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
 extern int qla24xx_abort_command(srb_t *);
 extern int qla24xx_async_abort_command(srb_t *);
 extern int
-qla24xx_abort_target(struct fc_port *, unsigned int, int);
+qla24xx_abort_target(struct fc_port *, uint64_t, int);
 extern int
-qla24xx_lun_reset(struct fc_port *, unsigned int, int);
+qla24xx_lun_reset(struct fc_port *, uint64_t, int);
 extern int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *, unsigned int,
-	unsigned int, enum nexus_wait_type);
+	uint64_t, enum nexus_wait_type);
 extern int
 qla2x00_system_error(scsi_qla_host_t *);
 
@@ -605,8 +605,8 @@ extern char *qlafx00_fw_version_str(struct scsi_qla_host *, char *);
 extern irqreturn_t qlafx00_intr_handler(int, void *);
 extern void qlafx00_enable_intrs(struct qla_hw_data *);
 extern void qlafx00_disable_intrs(struct qla_hw_data *);
-extern int qlafx00_abort_target(fc_port_t *, unsigned int, int);
-extern int qlafx00_lun_reset(fc_port_t *, unsigned int, int);
+extern int qlafx00_abort_target(fc_port_t *, uint64_t, int);
+extern int qlafx00_lun_reset(fc_port_t *, uint64_t, int);
 extern int qlafx00_start_scsi(srb_t *);
 extern int qlafx00_abort_isp(scsi_qla_host_t *);
 extern int qlafx00_iospace_config(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e607568..a3a1dfa 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -520,7 +520,7 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 static int
 __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 			struct rsp_que *rsp, uint16_t loop_id,
-			uint16_t lun, uint8_t type)
+			uint64_t lun, uint8_t type)
 {
 	mrk_entry_t *mrk;
 	struct mrk_entry_24xx *mrk24 = NULL;
@@ -543,14 +543,13 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 		if (IS_FWI2_CAPABLE(ha)) {
 			mrk24 = (struct mrk_entry_24xx *) mrk;
 			mrk24->nport_handle = cpu_to_le16(loop_id);
-			mrk24->lun[1] = LSB(lun);
-			mrk24->lun[2] = MSB(lun);
+			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
 			mrk24->vp_index = vha->vp_idx;
 			mrk24->handle = MAKE_HANDLE(req->id, mrk24->handle);
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
-			mrk->lun = cpu_to_le16(lun);
+			mrk->lun = cpu_to_le16((uint16_t)lun);
 		}
 	}
 	wmb();
@@ -562,7 +561,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 
 int
 qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
-		struct rsp_que *rsp, uint16_t loop_id, uint16_t lun,
+		struct rsp_que *rsp, uint16_t loop_id, uint64_t lun,
 		uint8_t type)
 {
 	int ret;
@@ -1983,7 +1982,7 @@ static void
 qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 {
 	uint32_t flags;
-	unsigned int lun;
+	uint64_t lun;
 	struct fc_port *fcport = sp->fcport;
 	scsi_qla_host_t *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 95314ef..a208569 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1659,7 +1659,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x301c,
-		    "Check condition Sense data, nexus%ld:%d:%d cmd=%p.\n",
+		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
 		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
@@ -2279,7 +2279,7 @@ check_scsi_status:
 out:
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
-		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d "
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu "
 		    "portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
 		    comp_status, scsi_status, res, vha->host_no,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2528709..9e5264f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -947,7 +947,7 @@ qla2x00_abort_command(srb_t *sp)
 }
 
 int
-qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
+qla2x00_abort_target(struct fc_port *fcport, uint64_t l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -1000,7 +1000,7 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 }
 
 int
-qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
+qla2x00_lun_reset(struct fc_port *fcport, uint64_t l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -1022,7 +1022,7 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 		mcp->mb[1] = fcport->loop_id;
 	else
 		mcp->mb[1] = fcport->loop_id << 8;
-	mcp->mb[2] = l;
+	mcp->mb[2] = (u32)l;
 	mcp->mb[3] = 0;
 	mcp->mb[9] = vha->vp_idx;
 
@@ -2664,7 +2664,7 @@ struct tsk_mgmt_cmd {
 
 static int
 __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
-    unsigned int l, int tag)
+    uint64_t l, int tag)
 {
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
@@ -2758,7 +2758,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 }
 
 int
-qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
+qla24xx_abort_target(struct fc_port *fcport, uint64_t l, int tag)
 {
 	struct qla_hw_data *ha = fcport->vha->hw;
 
@@ -2769,7 +2769,7 @@ qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 }
 
 int
-qla24xx_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
+qla24xx_lun_reset(struct fc_port *fcport, uint64_t l, int tag)
 {
 	struct qla_hw_data *ha = fcport->vha->hw;
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 0aaf6a9..8f8036a 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -686,13 +686,13 @@ qlafx00_disable_intrs(struct qla_hw_data *ha)
 }
 
 int
-qlafx00_abort_target(fc_port_t *fcport, unsigned int l, int tag)
+qlafx00_abort_target(fc_port_t *fcport, uint64_t l, int tag)
 {
 	return qla2x00_async_tm_cmd(fcport, TCF_TARGET_RESET, l, tag);
 }
 
 int
-qlafx00_lun_reset(fc_port_t *fcport, unsigned int l, int tag)
+qlafx00_lun_reset(fc_port_t *fcport, uint64_t l, int tag)
 {
 	return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
 }
@@ -2119,7 +2119,7 @@ qlafx00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3039,
-		    "Check condition Sense data, nexus%ld:%d:%d cmd=%p.\n",
+		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
 		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x3049,
@@ -2484,7 +2484,7 @@ check_scsi_status:
 
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3058,
-		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d "
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu "
 		    "tgt_id: 0x%x lscsi_status: 0x%x cdb=%10phN len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x sense_len=0x%x, "
 		    "par_sense_len=0x%x, rsp_info_len=0x%x\n",
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 264d97e..666cca5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -943,7 +943,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
+	uint64_t lun;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -967,7 +968,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8002,
-	    "Aborting from RISC nexus=%ld:%d:%d sp=%p cmd=%p\n",
+	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p\n",
 	    vha->host_no, id, lun, sp, cmd);
 
 	/* Get a reference to the sp and drop the lock.*/
@@ -1002,7 +1003,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	ql_log(ql_log_info, vha, 0x801c,
-	    "Abort command issued nexus=%ld:%d:%d --  %d %x.\n",
+	    "Abort command issued nexus=%ld:%d:%llu --  %d %x.\n",
 	    vha->host_no, id, lun, wait, ret);
 
 	return ret;
@@ -1010,7 +1011,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-	unsigned int l, enum nexus_wait_type type)
+	uint64_t l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	unsigned long flags;
@@ -1067,7 +1068,7 @@ static char *reset_errors[] = {
 
 static int
 __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int, int))
+    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, int))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -1082,7 +1083,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		return err;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%d cmd=%p.\n", name, vha->host_no,
+	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
 	    cmd->device->id, cmd->device->lun, cmd);
 
 	err = 0;
@@ -1107,14 +1108,14 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "%s RESET SUCCEEDED nexus:%ld:%d:%d cmd=%p.\n", name,
+	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n", name,
 	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "%s RESET FAILED: %s nexus=%ld:%d:%d cmd=%p.\n", name,
+	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n", name,
 	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
 	    cmd);
 	return FAILED;
@@ -1161,7 +1162,8 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
-	unsigned int id, lun;
+	unsigned int id;
+	uint64_t lun;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -1176,7 +1178,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	ret = FAILED;
 
 	ql_log(ql_log_info, vha, 0x8012,
-	    "BUS RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
+	    "BUS RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, vha, 0x8013,
@@ -1200,7 +1202,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 
 eh_bus_reset_done:
 	ql_log(ql_log_warn, vha, 0x802b,
-	    "BUS RESET %s nexus=%ld:%d:%d.\n",
+	    "BUS RESET %s nexus=%ld:%d:%llu.\n",
 	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
@@ -1227,14 +1229,15 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
-	unsigned int id, lun;
+	unsigned int id;
+	uint64_t lun;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
 	ql_log(ql_log_info, vha, 0x8018,
-	    "ADAPTER RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
+	    "ADAPTER RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
 
 	if (qla2x00_wait_for_reset_ready(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
@@ -1276,7 +1279,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 eh_host_reset_lock:
 	ql_log(ql_log_info, vha, 0x8017,
-	    "ADAPTER RESET %s nexus=%ld:%d:%d.\n",
+	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
 	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
@@ -1412,7 +1415,7 @@ static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
 		return;
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0x3029,
-	    "Queue depth adjusted-down to %d for nexus=%ld:%d:%d.\n",
+	    "Queue depth adjusted-down to %d for nexus=%ld:%d:%llu.\n",
 	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
 }
 
@@ -1435,7 +1438,7 @@ static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
 
 	ql_dbg(ql_dbg_io, vha, 0x302a,
-	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%d.\n",
+	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%llu.\n",
 	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index b1a19cd..a064ad9 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -23,7 +23,7 @@ void qla4xxx_process_aen(struct scsi_qla_host *ha, uint8_t process_aen);
 int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host *ha);
 int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reset_lun(struct scsi_qla_host *ha, struct ddb_entry *ddb_entry,
-		      int lun);
+		      uint64_t lun);
 int qla4xxx_reset_target(struct scsi_qla_host *ha,
 			 struct ddb_entry *ddb_entry);
 int qla4xxx_get_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
@@ -76,7 +76,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		uint32_t state, uint32_t conn_error);
 void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
-	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
+	struct ddb_entry *ddb_entry, uint64_t lun, uint16_t mrkr_mod);
 int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t length, uint32_t options);
 int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index e5697ab..08ab6da 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -83,7 +83,7 @@ static int qla4xxx_get_req_pkt(struct scsi_qla_host *ha,
  * This routine issues a marker IOCB.
  **/
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
-	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod)
+	struct ddb_entry *ddb_entry, uint64_t lun, uint16_t mrkr_mod)
 {
 	struct qla4_marker_entry *marker_entry;
 	unsigned long flags = 0;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index b1925d1..7177cbf 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -26,7 +26,7 @@ static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	sense_len = le16_to_cpu(sts_entry->senseDataByteCnt);
 	if (sense_len == 0) {
-		DEBUG2(ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d:%d: %s:"
+		DEBUG2(ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d:%llu: %s:"
 				  " sense len 0\n", ha->host_no,
 				  cmd->device->channel, cmd->device->id,
 				  cmd->device->lun, __func__));
@@ -43,7 +43,7 @@ static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
 	sense_len = min_t(uint16_t, sense_len, IOCB_MAX_SENSEDATA_LEN);
 	memcpy(cmd->sense_buffer, sts_entry->senseData, sense_len);
 
-	DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: %s: sense key = %x, "
+	DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%llu: %s: sense key = %x, "
 		"ASL= %02x, ASC/ASCQ = %02x/%02x\n", ha->host_no,
 		cmd->device->channel, cmd->device->id,
 		cmd->device->lun, __func__,
@@ -169,7 +169,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 				cmd->result = DID_ERROR << 16;
 
-				DEBUG2(printk("scsi%ld:%d:%d:%d: %s: "
+				DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: "
 					"Mid-layer Data underrun0, "
 					"xferlen = 0x%x, "
 					"residual = 0x%x\n", ha->host_no,
@@ -197,7 +197,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		break;
 
 	case SCS_RESET_OCCURRED:
-		DEBUG2(printk("scsi%ld:%d:%d:%d: %s: Device RESET occurred\n",
+		DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: Device RESET occurred\n",
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
@@ -205,7 +205,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		break;
 
 	case SCS_ABORTED:
-		DEBUG2(printk("scsi%ld:%d:%d:%d: %s: Abort occurred\n",
+		DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: Abort occurred\n",
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
@@ -213,7 +213,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		break;
 
 	case SCS_TIMEOUT:
-		DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: Timeout\n",
+		DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%llu: Timeout\n",
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun));
 
@@ -232,7 +232,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_DATA_OVERRUN:
 		if ((sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) ||
 		     (sts_entry->completionStatus == SCS_DATA_OVERRUN)) {
-			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: " "Data overrun\n",
+			DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: " "Data overrun\n",
 				      ha->host_no,
 				      cmd->device->channel, cmd->device->id,
 				      cmd->device->lun, __func__));
@@ -259,7 +259,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			if (!scsi_status && (scsi_bufflen(cmd) - residual) <
 			    cmd->underflow) {
 				DEBUG2(ql4_printk(KERN_INFO, ha,
-						  "scsi%ld:%d:%d:%d: %s: Mid-layer Data underrun, xferlen = 0x%x,residual = 0x%x\n",
+						  "scsi%ld:%d:%d:%llu: %s: Mid-layer Data underrun, xferlen = 0x%x,residual = 0x%x\n",
 						   ha->host_no,
 						   cmd->device->channel,
 						   cmd->device->id,
@@ -291,7 +291,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			 */
 
 			DEBUG2(ql4_printk(KERN_INFO, ha,
-					  "scsi%ld:%d:%d:%d: %s: Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
+					  "scsi%ld:%d:%d:%llu: %s: Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 					  ha->host_no,
 					  cmd->device->channel,
 					  cmd->device->id,
@@ -313,7 +313,7 @@ check_scsi_status:
 
 	case SCS_DEVICE_LOGGED_OUT:
 	case SCS_DEVICE_UNAVAILABLE:
-		DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: SCS_DEVICE "
+		DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%llu: SCS_DEVICE "
 		    "state: 0x%x\n", ha->host_no,
 		    cmd->device->channel, cmd->device->id,
 		    cmd->device->lun, sts_entry->completionStatus));
@@ -333,7 +333,7 @@ check_scsi_status:
 		 * SCSI Mid-Layer handles device queue full
 		 */
 		cmd->result = DID_OK << 16 | sts_entry->scsiStatus;
-		DEBUG2(printk("scsi%ld:%d:%d: %s: QUEUE FULL detected "
+		DEBUG2(printk("scsi%ld:%d:%llu: %s: QUEUE FULL detected "
 			      "compl=%02x, scsi=%02x, state=%02x, iFlags=%02x,"
 			      " iResp=%02x\n", ha->host_no, cmd->device->id,
 			      cmd->device->lun, __func__,
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0a6b782..6080295 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1205,7 +1205,7 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
 	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE) {
 		status = QLA_ERROR;
 
-		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%d: abort task FAILED: "
+		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%llu: abort task FAILED: "
 		    "mbx0=%04X, mb1=%04X, mb2=%04X, mb3=%04X, mb4=%04X\n",
 		    ha->host_no, cmd->device->id, cmd->device->lun, mbox_sts[0],
 		    mbox_sts[1], mbox_sts[2], mbox_sts[3], mbox_sts[4]));
@@ -1225,14 +1225,14 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
  * are valid before calling this routine.
  **/
 int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
-		      int lun)
+		      uint64_t lun)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 	uint32_t scsi_lun[2];
 	int status = QLA_SUCCESS;
 
-	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
+	DEBUG2(printk("scsi%ld:%d:%llu: lun reset issued\n", ha->host_no,
 		      ddb_entry->fw_ddb_index, lun));
 
 	/*
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 459b9f7..5afdbbf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9228,20 +9228,20 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	unsigned int id = cmd->device->id;
-	unsigned int lun = cmd->device->lun;
+	uint64_t lun = cmd->device->lun;
 	unsigned long flags;
 	struct srb *srb = NULL;
 	int ret = SUCCESS;
 	int wait = 0;
 
-	ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d: Abort command issued cmd=%p, cdb=0x%x\n",
+	ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Abort command issued cmd=%p, cdb=0x%x\n",
 		   ha->host_no, id, lun, cmd, cmd->cmnd[0]);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	srb = (struct srb *) CMD_SP(cmd);
 	if (!srb) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d: Specified command has already completed.\n",
+		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Specified command has already completed.\n",
 			   ha->host_no, id, lun);
 		return SUCCESS;
 	}
@@ -9249,11 +9249,11 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (qla4xxx_abort_task(ha, srb) != QLA_SUCCESS) {
-		DEBUG3(printk("scsi%ld:%d:%d: Abort_task mbx failed.\n",
+		DEBUG3(printk("scsi%ld:%d:%llu: Abort_task mbx failed.\n",
 		    ha->host_no, id, lun));
 		ret = FAILED;
 	} else {
-		DEBUG3(printk("scsi%ld:%d:%d: Abort_task mbx success.\n",
+		DEBUG3(printk("scsi%ld:%d:%llu: Abort_task mbx success.\n",
 		    ha->host_no, id, lun));
 		wait = 1;
 	}
@@ -9263,14 +9263,14 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	/* Wait for command to complete */
 	if (wait) {
 		if (!qla4xxx_eh_wait_on_command(ha, cmd)) {
-			DEBUG2(printk("scsi%ld:%d:%d: Abort handler timed out\n",
+			DEBUG2(printk("scsi%ld:%d:%llu: Abort handler timed out\n",
 			    ha->host_no, id, lun));
 			ret = FAILED;
 		}
 	}
 
 	ql4_printk(KERN_INFO, ha,
-	    "scsi%ld:%d:%d: Abort command - %s\n",
+	    "scsi%ld:%d:%llu: Abort command - %s\n",
 	    ha->host_no, id, lun, (ret == SUCCESS) ? "succeeded" : "failed");
 
 	return ret;
@@ -9298,7 +9298,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	ret = FAILED;
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
+		   "scsi%ld:%d:%d:%llu: DEVICE RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	DEBUG2(printk(KERN_INFO
@@ -9328,7 +9328,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		goto eh_dev_reset_done;
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
+		   "scsi(%ld:%d:%d:%llu): DEVICE RESET SUCCEEDED.\n",
 		   ha->host_no, cmd->device->channel, cmd->device->id,
 		   cmd->device->lun);
 
@@ -9445,7 +9445,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
+		   "scsi(%ld:%d:%d:%llu): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..9750e22 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1291,7 +1291,7 @@ EXPORT_SYMBOL(__starget_for_each_device);
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
-						   uint lun)
+						   u64 lun)
 {
 	struct scsi_device *sdev;
 
@@ -1316,7 +1316,7 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
-						 uint lun)
+						 u64 lun)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -1349,7 +1349,7 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, u64 lun)
 {
 	struct scsi_device *sdev;
 
@@ -1375,7 +1375,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, u64 lun)
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f3e9cc0..eeaa5a2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -227,9 +227,9 @@ struct sdebug_dev_info {
 	unsigned char sense_buff[SDEBUG_SENSE_LEN];	/* weak nexus */
 	unsigned int channel;
 	unsigned int target;
-	unsigned int lun;
+	u64 lun;
 	struct sdebug_host_info *sdbg_host;
-	unsigned int wlun;
+	u64 wlun;
 	char reset;
 	char stopped;
 	char used;
@@ -2277,7 +2277,8 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 			    struct sdebug_dev_info * devip)
 {
 	unsigned int alloc_len;
-	int lun_cnt, i, upper, num, n, wlun, lun;
+	int lun_cnt, i, upper, num, n;
+	u64 wlun, lun;
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
@@ -2461,7 +2462,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, sdp->request_queue);
 	return 0;
@@ -2472,7 +2473,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	struct sdebug_dev_info *devip;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
@@ -2495,7 +2496,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 		(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
 		/* make this slot available for re-use */
@@ -2707,7 +2708,7 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %u> "
+			printk(KERN_INFO "scsi_debug:    <%u %u %u %llu> "
 			       "non-zero result=0x%x\n", sdp->host->host_no,
 			       sdp->channel, sdp->id, sdp->lun, scsi_result);
 		}
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 48e5b65..a45d1c2 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -115,7 +115,7 @@ extern void scsi_exit_procfs(void);
 extern char scsi_scan_type[];
 extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
-				   unsigned int, unsigned int, int);
+				   unsigned int, u64, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 86f0c5d..6fcefa2 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -185,7 +185,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 
 	sdev = to_scsi_device(dev);
 	seq_printf(s,
-		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
+		"Host: scsi%d Channel: %02d Id: %02d Lun: %02llu\n  Vendor: ",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	for (i = 0; i < 8; i++) {
 		if (sdev->vendor[i] >= 0x20)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a02f7b0..1a71547 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -220,7 +220,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
  *     scsi_Device pointer, or NULL on failure.
  **/
 static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
-					   unsigned int lun, void *hostdata)
+					   u64 lun, void *hostdata)
 {
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
@@ -1028,7 +1028,7 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
-				  uint lun, int *bflagsp,
+				  u64 lun, int *bflagsp,
 				  struct scsi_device **sdevp, int rescan,
 				  void *hostdata)
 {
@@ -1181,7 +1181,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
 				     int bflags, int scsi_level, int rescan)
 {
-	unsigned int sparse_lun, lun, max_dev_lun;
+	uint max_dev_lun;
+	u64 sparse_lun, lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
@@ -1271,10 +1272,10 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-int scsilun_to_int(struct scsi_lun *scsilun)
+u64 scsilun_to_int(struct scsi_lun *scsilun)
 {
 	int i;
-	unsigned int lun;
+	u64 lun;
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
@@ -1302,7 +1303,7 @@ EXPORT_SYMBOL(scsilun_to_int);
  *     scsi_lun of : struct scsi_lun of: 0a 04 0b 03 00 00 00 00
  *
  **/
-void int_to_scsilun(unsigned int lun, struct scsi_lun *scsilun)
+void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
 {
 	int i;
 
@@ -1342,7 +1343,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
-	unsigned int lun;
+	u64 lun;
 	unsigned int num_luns;
 	unsigned int retries;
 	int result;
@@ -1485,25 +1486,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
 		lun = scsilun_to_int(lunp);
 
-		/*
-		 * Check if the unused part of lunp is non-zero, and so
-		 * does not fit in lun.
-		 */
-		if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4)) {
-			int i;
-
-			/*
-			 * Output an error displaying the LUN in byte order,
-			 * this differs from what linux would print for the
-			 * integer LUN value.
-			 */
-			printk(KERN_WARNING "scsi: %s lun 0x", devname);
-			data = (char *)lunp->scsi_lun;
-			for (i = 0; i < sizeof(struct scsi_lun); i++)
-				printk("%02x", data[i]);
-			printk(" has a LUN larger than currently supported.\n");
-		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
+		if (lun > sdev->host->max_lun) {
+			printk(KERN_WARNING "scsi: %s lun%llu has a LUN larger"
 			       " than allowed by the host adapter\n",
 			       devname, lun);
 		} else {
@@ -1517,8 +1501,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				 */
 				sdev_printk(KERN_ERR, sdev,
 					"Unexpected response"
-				        " from lun %d while scanning, scan"
-				        " aborted\n", lun);
+					" from lun %llu while scanning, scan"
+					" aborted\n", (unsigned long long)lun);
 				break;
 			}
 		}
@@ -1537,7 +1521,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 }
 
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
-				      uint id, uint lun, void *hostdata)
+				      uint id, u64 lun, void *hostdata)
 {
 	struct scsi_device *sdev = ERR_PTR(-ENODEV);
 	struct device *parent = &shost->shost_gendev;
@@ -1573,7 +1557,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 EXPORT_SYMBOL(__scsi_add_device);
 
 int scsi_add_device(struct Scsi_Host *host, uint channel,
-		    uint target, uint lun)
+		    uint target, u64 lun)
 {
 	struct scsi_device *sdev = 
 		__scsi_add_device(host, channel, target, lun, NULL);
@@ -1602,7 +1586,7 @@ void scsi_rescan_device(struct device *dev)
 EXPORT_SYMBOL(scsi_rescan_device);
 
 static void __scsi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+		unsigned int id, u64 lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1670,7 +1654,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  *     sequential scan of LUNs on the target id.
  **/
 void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+		      unsigned int id, u64 lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
@@ -1690,7 +1674,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun, int rescan)
+			      unsigned int id, u64 lun, int rescan)
 {
 	uint order_id;
 
@@ -1721,10 +1705,10 @@ static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
-			    unsigned int id, unsigned int lun, int rescan)
+			    unsigned int id, u64 lun, int rescan)
 {
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
-		"%s: <%u:%u:%u>\n",
+		"%s: <%u:%u:%llu>\n",
 		__func__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 074e8cc..5f36788 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -80,7 +80,7 @@ const char *scsi_host_state_name(enum scsi_host_state state)
 	return name;
 }
 
-static int check_set(unsigned int *val, char *src)
+static int check_set(unsigned long long *val, char *src)
 {
 	char *last;
 
@@ -90,7 +90,7 @@ static int check_set(unsigned int *val, char *src)
 		/*
 		 * Doesn't check for int overflow
 		 */
-		*val = simple_strtoul(src, &last, 0);
+		*val = simple_strtoull(src, &last, 0);
 		if (*last != '\0')
 			return 1;
 	}
@@ -99,11 +99,11 @@ static int check_set(unsigned int *val, char *src)
 
 static int scsi_scan(struct Scsi_Host *shost, const char *str)
 {
-	char s1[15], s2[15], s3[15], junk;
-	unsigned int channel, id, lun;
+	char s1[15], s2[15], s3[17], junk;
+	unsigned long long channel, id, lun;
 	int res;
 
-	res = sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
+	res = sscanf(str, "%10s %10s %16s %c", s1, s2, s3, &junk);
 	if (res != 3)
 		return -EINVAL;
 	if (check_set(&channel, s1))
@@ -1230,13 +1230,13 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
-	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%d",
+	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
 	device_initialize(&sdev->sdev_dev);
 	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
 	sdev->sdev_dev.class = &sdev_class;
-	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
+	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
 	transport_setup_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f80908f..6b65b03 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2089,7 +2089,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
  * on the rport.
  */
 static void
-fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
+fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 {
 	struct fc_rport *rport;
 	unsigned long flags;
@@ -2121,7 +2121,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
  * object as the parent.
  */
 static int
-fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lun)
+fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 {
 	uint chlo, chhi;
 	uint tgtlo, tgthi;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0102a2d..126bf26 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1780,7 +1780,7 @@ EXPORT_SYMBOL_GPL(iscsi_scan_finished);
 struct iscsi_scan_data {
 	unsigned int channel;
 	unsigned int id;
-	unsigned int lun;
+	u64 lun;
 };
 
 static int iscsi_user_scan_session(struct device *dev, void *data)
@@ -1827,7 +1827,7 @@ user_scan_exit:
 }
 
 static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
-			   uint id, uint lun)
+			   uint id, u64 lun)
 {
 	struct iscsi_scan_data scan_data;
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..331fa70 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1706,7 +1706,7 @@ EXPORT_SYMBOL(scsi_is_sas_rphy);
  */
 
 static int sas_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, uint lun)
+		uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..fc0b126 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2484,7 +2484,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
-		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
+		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
@@ -2613,7 +2613,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			seq_printf(s, "detached pending close ");
 		else
 			seq_printf
-			    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+			    (s, "scsi%d chan=%d id=%d lun=%llu   em=%d",
 			     scsidp->host->host_no,
 			     scsidp->channel, scsidp->id,
 			     scsidp->lun,
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6d3ee1a..e59e6f9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -851,7 +851,7 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 		 * so let's try to stop all on-going I/O.
 		 */
 		starget_printk(KERN_WARNING, tp->starget,
-			       "Removing busy LCB (%d)\n", sdev->lun);
+			       "Removing busy LCB (%d)\n", (u8)sdev->lun);
 		sym_reset_scsi_bus(np, 1);
 	}
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 5a80cba..a141b17 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -581,7 +581,7 @@ struct sym_pmc {
 #define sym_lp(tp, lun) (!lun) ? (tp)->lun0p : NULL
 #else
 #define sym_lp(tp, lun) \
-	(!lun) ? (tp)->lun0p : (tp)->lunmp ? (tp)->lunmp[(lun)] : NULL
+	(!lun) ? (tp)->lun0p : (tp)->lunmp ? (tp)->lunmp[((u8)lun)] : NULL
 #endif
 
 /*
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c886ad1..4f76536 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -242,7 +242,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd;
 
-	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
+	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%llu got CDB: 0x%02x"
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0f199f6..b484077 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -312,7 +312,7 @@ static int pscsi_add_device_to_list(struct se_device *dev,
 	if (!sd->queue_depth) {
 		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
 
-		pr_err("Set broken SCSI Device %d:%d:%d"
+		pr_err("Set broken SCSI Device %d:%d:%llu"
 			" queue_depth to %d\n", sd->channel, sd->id,
 				sd->lun, sd->queue_depth);
 	}
@@ -375,7 +375,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	int ret;
 
 	if (scsi_device_get(sd)) {
-		pr_err("scsi_device_get() failed for %d:%d:%d:%d\n",
+		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return -EIO;
@@ -401,7 +401,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 		return ret;
 	}
 
-	pr_debug("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d:%llu\n",
 		phv->phv_host_id, sh->host_no, sd->channel, sd->id, sd->lun);
 	return 0;
 }
@@ -417,7 +417,7 @@ static int pscsi_create_type_rom(struct se_device *dev, struct scsi_device *sd)
 	int ret;
 
 	if (scsi_device_get(sd)) {
-		pr_err("scsi_device_get() failed for %d:%d:%d:%d\n",
+		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return -EIO;
@@ -429,7 +429,7 @@ static int pscsi_create_type_rom(struct se_device *dev, struct scsi_device *sd)
 		scsi_device_put(sd);
 		return ret;
 	}
-	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%llu\n",
 		phv->phv_host_id, scsi_device_type(sd->type), sh->host_no,
 		sd->channel, sd->id, sd->lun);
 
@@ -452,7 +452,7 @@ static int pscsi_create_type_other(struct se_device *dev,
 	if (ret)
 		return ret;
 
-	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%llu\n",
 		phv->phv_host_id, scsi_device_type(sd->type), sh->host_no,
 		sd->channel, sd->id, sd->lun);
 	return 0;
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 073a2c3..38a4504 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -1498,7 +1498,7 @@ static int dpcm_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	int ret;
 
-	usb_stor_dbg(us, "LUN=%d\n", srb->device->lun);
+	usb_stor_dbg(us, "LUN=%d\n", (u8)srb->device->lun);
 
 	switch (srb->device->lun) {
 	case 0:
@@ -1524,7 +1524,7 @@ static int dpcm_transport(struct scsi_cmnd *srb, struct us_data *us)
 		break;
 
 	default:
-		usb_stor_dbg(us, "Invalid LUN %d\n", srb->device->lun);
+	    usb_stor_dbg(us, "Invalid LUN %d\n", (u8)srb->device->lun);
 		ret = USB_STOR_TRANSPORT_ERROR;
 		break;
 	}
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index f1c9626..cedb292 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -347,14 +347,16 @@ static int usb_stor_control_thread(void * __us)
 		 */
 		else if (us->srb->device->id &&
 				!(us->fflags & US_FL_SCM_MULT_TARG)) {
-			usb_stor_dbg(us, "Bad target number (%d:%d)\n",
-				     us->srb->device->id, us->srb->device->lun);
+			usb_stor_dbg(us, "Bad target number (%d:%llu)\n",
+				     us->srb->device->id,
+				     us->srb->device->lun);
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (us->srb->device->lun > us->max_lun) {
-			usb_stor_dbg(us, "Bad LUN (%d:%d)\n",
-				     us->srb->device->id, us->srb->device->lun);
+			usb_stor_dbg(us, "Bad LUN (%d:%llu)\n",
+				     us->srb->device->id,
+				     us->srb->device->lun);
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 0a4edfe..91e2e42 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -385,7 +385,7 @@ struct scsi_lun {
 #define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
 #define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
 
-static inline int scsi_is_wlun(unsigned int lun)
+static inline int scsi_is_wlun(u64 lun)
 {
 	return (lun & 0xff00) == SCSI_W_LUN_BASE;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5853c91..816e8a2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -98,8 +98,8 @@ struct scsi_device {
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
-	unsigned int id, lun, channel;
-
+	unsigned int id, channel;
+	u64 lun;
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
@@ -320,9 +320,9 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
-		uint, uint, uint, void *hostdata);
+		uint, uint, u64, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
-			   uint target, uint lun);
+			   uint target, u64 lun);
 extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
@@ -331,13 +331,13 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-					      uint, uint, uint);
+					      uint, uint, u64);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
-						uint, uint, uint);
+						uint, uint, u64);
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
-							uint);
+							u64);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
-							  uint);
+							  u64);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
 extern void __starget_for_each_device(struct scsi_target *, void *,
@@ -410,13 +410,13 @@ extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+			     unsigned int id, u64 lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *, enum scsi_device_state);
 extern void scsi_remove_target(struct device *);
-extern void int_to_scsilun(unsigned int, struct scsi_lun *);
-extern int scsilun_to_int(struct scsi_lun *);
+extern void int_to_scsilun(u64, struct scsi_lun *);
+extern u64 scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index af244f4..8129239 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -35,7 +35,7 @@ struct scsi_transport_template {
 	/*
 	 * If set, called from sysfs and legacy procfs rescanning code.
 	 */
-	int (*user_scan)(struct Scsi_Host *, uint, uint, uint);
+	int (*user_scan)(struct Scsi_Host *, uint, uint, u64);
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
-- 
1.7.12.4

