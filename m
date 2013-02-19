From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi: use 64-bit LUNs
Date: Tue, 19 Feb 2013 09:18:01 +0100
Message-ID: <1361261883-41467-3-git-send-email-hare@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab3BSISJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 03:18:09 -0500
In-Reply-To: <1361261883-41467-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>

The SCSI standard uses a 64-bit value for LUNs, and large arrays
employing large LUN numbers become more and more common.
So move the linux SCSI stack to use 64-bit LUN numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c               |    2 +-
 drivers/ata/libata.h                    |    2 +-
 drivers/message/fusion/mptscsih.c       |    2 +-
 drivers/scsi/NCR5380.c                  |    2 +-
 drivers/scsi/aacraid/linit.c            |    2 +-
 drivers/scsi/aha152x.c                  |    6 ++--
 drivers/scsi/aic7xxx/aic79xx.h          |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c      |    6 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |   11 +++---
 drivers/scsi/aic7xxx_old.c              |   21 ++++++------
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c        |    8 ++--
 drivers/scsi/csiostor/csio_scsi.c       |   24 +++++++-------
 drivers/scsi/dc395x.c                   |   40 +++++++++++-----------
 drivers/scsi/eata.c                     |    2 +-
 drivers/scsi/fnic/fnic_scsi.c           |    6 ++--
 drivers/scsi/hpsa.c                     |    2 +-
 drivers/scsi/libiscsi.c                 |    7 ++--
 drivers/scsi/libsas/sas_scsi_host.c     |   11 +++---
 drivers/scsi/lpfc/lpfc_scsi.c           |   44 ++++++++++++------------
 drivers/scsi/megaraid.c                 |    6 ++--
 drivers/scsi/megaraid/mega_common.h     |    2 +-
 drivers/scsi/pmcraid.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_def.h          |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h          |   10 +++---
 drivers/scsi/qla2xxx/qla_isr.c          |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c          |   12 +++---
 drivers/scsi/qla2xxx/qla_os.c           |   35 +++++++++++---------
 drivers/scsi/qla4xxx/ql4_glbl.h         |    4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c          |   22 ++++++------
 drivers/scsi/qla4xxx/ql4_mbx.c          |    8 ++--
 drivers/scsi/qla4xxx/ql4_os.c           |   18 +++++-----
 drivers/scsi/scsi.c                     |    8 ++--
 drivers/scsi/scsi_debug.c               |   15 ++++----
 drivers/scsi/scsi_priv.h                |    2 +-
 drivers/scsi/scsi_proc.c                |    2 +-
 drivers/scsi/scsi_scan.c                |   54 +++++++++++--------------------
 drivers/scsi/scsi_sysfs.c               |   14 ++++----
 drivers/scsi/scsi_transport_fc.c        |    4 +-
 drivers/scsi/scsi_transport_iscsi.c     |    4 +-
 drivers/scsi/scsi_transport_sas.c       |    2 +-
 drivers/scsi/sg.c                       |    4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c     |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h     |    2 +-
 drivers/target/loopback/tcm_loop.c      |    4 +-
 drivers/target/target_core_pscsi.c      |   12 +++---
 include/scsi/scsi.h                     |    2 +-
 include/scsi/scsi_device.h              |   22 ++++++------
 include/scsi/scsi_transport.h           |    2 +-
 50 files changed, 239 insertions(+), 247 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7c337e7..7e1fc76 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3886,7 +3886,7 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	Zero.
  */
 int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-		       unsigned int id, unsigned int lun)
+		       unsigned int id, uint64_t lun)
 {
 	struct ata_port *ap = ata_shost_to_port(shost);
 	unsigned long flags;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 7148a58..e003f70 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -147,7 +147,7 @@ extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
 extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun);
+			      unsigned int id, uint64_t lun);
 
 
 /* libata-eh.c */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 164afa7..2d55e5e 100644
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
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 450353e..04f0598 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -775,7 +775,7 @@ static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 
 static char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, (u8)cmd->device->lun);
 	SPRINTF("        command = ");
 	pos = lprint_command(cmd->cmnd, pos, buffer, length);
 	return (pos);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 408a42e..7e03794 100644
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
index a284be1..51f3fa7 100644
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
@@ -2985,7 +2985,7 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
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
index 9328121..985f42e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2142,7 +2142,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 	if (do_fallback) {
 		printk("%s: device overrun (status %x) on %d:%d:%d\n",
 		       ahd_name(ahd), status, cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		       cmd->device->id, (u8)cmd->device->lun);
 	}
 
 	ahd_cmd_set_transaction_status(cmd, new_status);
@@ -2258,13 +2258,13 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
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
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 5a477cd..93776e2 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2125,7 +2125,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 */
 		printk("%s:%d:%d:%d: Is not an active device\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		       (u8)cmd->device->lun);
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2133,11 +2133,11 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
@@ -2203,13 +2203,14 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..391fb5a 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -1033,8 +1033,8 @@ static struct aic7xxx_syncrate {
                         ((scb->hscb)->target_channel_lun & 0x07)
 
 #define CTL_OF_CMD(cmd) ((cmd->device->channel) & 0x01),  \
-                        ((cmd->device->id) & 0x0f), \
-                        ((cmd->device->lun) & 0x07)
+                        ((cmd->device->id) & 0x0f),               \
+                        (((u8)cmd->device->lun) & 0x07)
 
 #define TARGET_INDEX(cmd)  ((cmd)->device->id | ((cmd)->device->channel << 3))
 
@@ -3154,7 +3154,8 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       continue;
     if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
         printk(INFO_LEAD "Cleaning up status information "
-          "and delayed_scbs.\n", p->host_no, sd->channel, sd->id, sd->lun);
+          "and delayed_scbs.\n", p->host_no, sd->channel, sd->id,
+          (u8)sd->lun);
     aic_dev->flags &= ~BUS_DEVICE_RESET_PENDING;
     if ( tag == SCB_LIST_NULL )
     {
@@ -3165,7 +3166,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       aic_dev->flags = DEVICE_PRINT_DTR;
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
     }
-    tcl = (sd->id << 4) | (sd->channel << 3) | sd->lun;
+    tcl = (sd->id << 4) | (sd->channel << 3) | (u8)sd->lun;
     if ( (aic7xxx_index_busy_target(p, tcl, FALSE) == tag) ||
          (tag == SCB_LIST_NULL) )
       aic7xxx_index_busy_target(p, tcl, /* unbusy */ TRUE);
@@ -4260,7 +4261,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 memcpy(scb->sense_cmd, &generic_sense[0],
                        sizeof(generic_sense));
 
-                scb->sense_cmd[1] = (cmd->device->lun << 5);
+                scb->sense_cmd[1] = ((u8)cmd->device->lun << 5);
                 scb->sense_cmd[4] = SCSI_SENSE_BUFFERSIZE;
 
                 scb->sg_list[0].length = 
@@ -6284,7 +6285,7 @@ aic7xxx_handle_command_completion_intr(struct aic7xxx_host *p)
         continue;
       }
       aic7xxx_reset_device(p, scb->cmd->device->id, scb->cmd->device->channel,
-        scb->cmd->device->lun, scb->hscb->tag);
+        (u8)scb->cmd->device->lun, scb->hscb->tag);
       scb->flags &= ~(SCB_QUEUED_FOR_DONE | SCB_RESET | SCB_ABORT |
         SCB_QUEUED_ABORT);
       unpause_sequencer(p, FALSE);
@@ -6644,7 +6645,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
       if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
         printk(INFO_LEAD "Disconnection disabled, unable to "
              "enable tagged queueing.\n",
-             p->host_no, device->channel, device->id, device->lun);
+             p->host_no, device->channel, device->id, (u8)device->lun);
       tag_enabled = FALSE;
     }
     else
@@ -6689,7 +6690,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
     {
           printk(INFO_LEAD "Tagged queuing enabled, queue depth %d.\n",
             p->host_no, device->channel, device->id,
-            device->lun, aic_dev->max_q_depth);
+            (u8)device->lun, aic_dev->max_q_depth);
     }
     scsi_adjust_queue_depth(device, MSG_ORDERED_TAG, aic_dev->max_q_depth);
   }
@@ -6699,7 +6700,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
     {
           printk(INFO_LEAD "Tagged queuing disabled, queue depth %d.\n",
             p->host_no, device->channel, device->id,
-            device->lun, device->host->cmd_per_lun);
+            (u8)device->lun, device->host->cmd_per_lun);
     }
     scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
   }
@@ -10164,7 +10165,7 @@ static void aic7xxx_buildscb(struct aic7xxx_host *p, struct scsi_cmnd *cmd,
     scb->flags |= SCB_DTR_SCB;
   }
   hscb->target_channel_lun = ((cmd->device->id << 4) & 0xF0) |
-        ((cmd->device->channel & 0x01) << 3) | (cmd->device->lun & 0x07);
+        ((cmd->device->channel & 0x01) << 3) | ((u8)cmd->device->lun & 0x07);
 
   /*
    * The interpretation of request_buffer and request_bufflen
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
index b07e4f0..32dc43c13 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -262,7 +262,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
     sdptr = aic_dev->SDptr;
     tindex = sdptr->channel << 3 | sdptr->id;
     size += sprintf(BLS, "(scsi%d:%d:%d:%d)\n",
-        p->host_no, sdptr->channel, sdptr->id, sdptr->lun);
+        p->host_no, sdptr->channel, sdptr->id, (u8)sdptr->lun);
     size += sprintf(BLS, "  Device using %s/%s",
           (aic_dev->cur.width == MSG_EXT_WDTR_BUS_16_BIT) ?
           "Wide" : "Narrow",
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 33c52bc..4e70062 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2335,7 +2335,7 @@ static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 					" poll command abort successfully \n"
 					, acb->host->host_no
 					, ccb->pcmd->device->id
-					, ccb->pcmd->device->lun
+				       , (u32)ccb->pcmd->device->lun
 					, ccb);
 				ccb->pcmd->result = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
@@ -2399,7 +2399,7 @@ static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 					" poll command abort successfully \n"
 					,acb->host->host_no
 					,ccb->pcmd->device->id
-					,ccb->pcmd->device->lun
+				       ,(u32)ccb->pcmd->device->lun
 					,ccb);
 				ccb->pcmd->result = DID_ABORT << 16;
 				arcmsr_ccb_complete(ccb);
@@ -2456,7 +2456,7 @@ polling_hbc_ccb_retry:
 					" poll command abort successfully \n"
 					, acb->host->host_no
 					, pCCB->pcmd->device->id
-					, pCCB->pcmd->device->lun
+				       , (u32)pCCB->pcmd->device->lun
 					, pCCB);
 					pCCB->pcmd->result = DID_ABORT << 16;
 					arcmsr_ccb_complete(pCCB);
@@ -3059,7 +3059,7 @@ static int arcmsr_abort(struct scsi_cmnd *cmd)
 	int rtn = FAILED;
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d \n",
-		acb->host->host_no, cmd->device->id, cmd->device->lun);
+	       acb->host->host_no, cmd->device->id, (u32)cmd->device->lun);
 	acb->acb_flags |= ACB_F_ABORT;
 	acb->num_aborts++;
 	/*
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index ddd38e5..54a43f3 100644
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
index 865c64f..dfe90ce 100644
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
index 94de889..d20c8dd 100644
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
index c974961..de72c6b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -843,7 +843,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 						qd = t_sdev->host->cmd_per_lun;
 					shost_printk(KERN_INFO,
 						     fnic->lport->host,
-						     "scsi[%d:%d:%d:%d"
+						     "scsi[%d:%d:%d:%llu"
 						     "] queue full detected,"
 						     "new depth = %d\n",
 						     t_sdev->host->host_no,
@@ -1584,7 +1584,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	tag = sc->request->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
-		"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %x flags %x\n",
+		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
 		rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
 
 	CMD_FLAGS(sc) = FNIC_NO_FLAGS;
@@ -2006,7 +2006,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%x sc 0x%p\n",
+		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
 		      rport->port_id, sc->device->lun, sc);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f33806..5d5d355 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2584,7 +2584,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	memset(msg, 0, sizeof(msg));
 	ml += sprintf(msg+ml, "ABORT REQUEST on C%d:B%d:T%d:L%d ",
 		h->scsi_host->host_no, sc->device->channel,
-		sc->device->id, sc->device->lun);
+		sc->device->id, (u32)sc->device->lun);
 
 	/* Find the device of the command to be aborted */
 	dev = sc->device->hostdata;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..04bdd92 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -268,7 +268,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_tm *tmf = &conn->tmhdr;
-	unsigned int hdr_lun;
+	uint64_t hdr_lun;
 
 	if (conn->tmf_state == TMF_INITIAL)
 		return 0;
@@ -1813,7 +1813,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
  * Fail commands. session lock held and recv side suspended and xmit
  * thread flushed
  */
-static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
+static void fail_scsi_tasks(struct iscsi_conn *conn, uint64_t lun,
 			    int error)
 {
 	struct iscsi_task *task;
@@ -2233,7 +2233,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
+	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %llu]\n", sc,
+		     sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 6e795a1..16e467e 100644
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
+			   uint64_t lun, int wait)
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
index 98af07c..fd448ac 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -219,7 +219,7 @@ static void
 lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 		struct lpfc_vport  *vport,
 		struct lpfc_nodelist *ndlp,
-		uint32_t lun,
+		uint64_t lun,
 		uint32_t old_val,
 		uint32_t new_val)
 {
@@ -236,7 +236,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 		LPFC_EVENT_VARQUEDEPTH;
 
 	/* Report all luns with change in queue depth */
-	fast_path_evt->un.queue_depth_evt.scsi_event.lun = lun;
+	fast_path_evt->un.queue_depth_evt.scsi_event.lun = (u32)lun;
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwpn,
 			&ndlp->nlp_portname, sizeof(struct lpfc_name));
@@ -3354,7 +3354,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		fast_path_evt->un.scsi_evt.subcategory =
 		(cmnd->result == SAM_STAT_TASK_SET_FULL) ?
 		LPFC_EVENT_QFULL : LPFC_EVENT_DEVBSY;
-		fast_path_evt->un.scsi_evt.lun = cmnd->device->lun;
+		fast_path_evt->un.scsi_evt.lun = (u32)cmnd->device->lun;
 		memcpy(&fast_path_evt->un.scsi_evt.wwpn,
 			&pnode->nlp_portname, sizeof(struct lpfc_name));
 		memcpy(&fast_path_evt->un.scsi_evt.wwnn,
@@ -3369,7 +3369,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		fast_path_evt->un.check_cond_evt.scsi_event.subcategory =
 			LPFC_EVENT_CHECK_COND;
 		fast_path_evt->un.check_cond_evt.scsi_event.lun =
-			cmnd->device->lun;
+		    (u32)cmnd->device->lun;
 		memcpy(&fast_path_evt->un.check_cond_evt.scsi_event.wwpn,
 			&pnode->nlp_portname, sizeof(struct lpfc_name));
 		memcpy(&fast_path_evt->un.check_cond_evt.scsi_event.wwnn,
@@ -3398,7 +3398,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			&pnode->nlp_portname, sizeof(struct lpfc_name));
 		memcpy(&fast_path_evt->un.read_check_error.header.wwnn,
 			&pnode->nlp_nodename, sizeof(struct lpfc_name));
-		fast_path_evt->un.read_check_error.lun = cmnd->device->lun;
+		fast_path_evt->un.read_check_error.lun = (u32)cmnd->device->lun;
 		fast_path_evt->un.read_check_error.opcode = cmnd->cmnd[0];
 		fast_path_evt->un.read_check_error.fcpiparam =
 			fcpi_parm;
@@ -3479,7 +3479,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		if (rsplen != 0 && rsplen != 4 && rsplen != 8) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2719 Invalid response length: "
-				 "tgt x%x lun x%x cmnd x%x rsplen x%x\n",
+				 "tgt x%x lun x%llx cmnd x%x rsplen x%x\n",
 				 cmnd->device->id,
 				 cmnd->device->lun, cmnd->cmnd[0],
 				 rsplen);
@@ -3490,7 +3490,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2757 Protocol failure detected during "
 				 "processing of FCP I/O op: "
-				 "tgt x%x lun x%x cmnd x%x rspInfo3 x%x\n",
+				 "tgt x%x lun x%llx cmnd x%x rspInfo3 x%x\n",
 				 cmnd->device->id,
 				 cmnd->device->lun, cmnd->cmnd[0],
 				 fcprsp->rspInfo3);
@@ -3702,7 +3702,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		else
 			logit = LOG_FCP | LOG_FCP_UNDER;
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
-			 "9030 FCP cmd x%x failed <%d/%d> "
+			 "9030 FCP cmd x%x failed <%d/%lld> "
 			 "status: x%x result: x%x "
 			 "sid: x%x did: x%x oxid: x%x "
 			 "Data: x%x x%x\n",
@@ -3813,7 +3813,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "0710 Iodone <%d/%d> cmd %p, error "
+				 "0710 Iodone <%d/%llu> cmd %p, error "
 				 "x%x SNS x%x x%x Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
 				 cmd->result, *lp, *(lp + 3), cmd->retries,
@@ -4066,7 +4066,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 static int
 lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 			     struct lpfc_scsi_buf *lpfc_cmd,
-			     unsigned int lun,
+			     uint64_t lun,
 			     uint8_t task_mgmt_cmd)
 {
 	struct lpfc_iocbq *piocbq;
@@ -4460,7 +4460,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
-			 "x%x ID %d LUN %d\n",
+			 "x%x ID %d LUN %llu\n",
 			 SUCCESS, cmnd->device->id, cmnd->device->lun);
 		return SUCCESS;
 	}
@@ -4550,7 +4550,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
 				 "for abortng I/O (xri:x%x) to complete: "
-				 "ret %#x, ID %d, LUN %d\n",
+				 "ret %#x, ID %d, LUN %llu\n",
 				 iocb->sli4_xritag, ret,
 				 cmnd->device->id, cmnd->device->lun);
 	}
@@ -4561,7 +4561,7 @@ out_unlock:
 out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
-			 "LUN %d\n", ret, cmnd->device->id,
+			 "LUN %llu\n", ret, cmnd->device->id,
 			 cmnd->device->lun);
 	return ret;
 }
@@ -4606,8 +4606,8 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
  **/
 static int
 lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
-		    unsigned  tgt_id, unsigned int lun_id,
-		    uint8_t task_mgmt_cmd)
+		   unsigned  tgt_id, uint64_t lun_id,
+		   uint8_t task_mgmt_cmd)
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -4641,7 +4641,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 	}
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0702 Issue %s to TGT %d LUN %d "
+			 "0702 Issue %s to TGT %d LUN %llu "
 			 "rpi x%x nlp_flag x%x Data: x%x x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
 			 pnode->nlp_rpi, pnode->nlp_flag, iocbq->sli4_xritag,
@@ -4657,7 +4657,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 			ret = FAILED;
 		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d) "
+			 "0727 TMF %s to TGT %d LUN %llu failed (%d, %d) "
 			 "iocb_flag x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd),
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
@@ -4787,7 +4787,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
-	unsigned int lun_id = cmnd->device->lun;
+	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status, ret = SUCCESS;
 
@@ -4810,7 +4810,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 
 	scsi_event.event_type = FC_REG_SCSI_EVENT;
 	scsi_event.subcategory = LPFC_EVENT_LUNRESET;
-	scsi_event.lun = lun_id;
+	scsi_event.lun = (u32)lun_id;
 	memcpy(scsi_event.wwpn, &pnode->nlp_portname, sizeof(struct lpfc_name));
 	memcpy(scsi_event.wwnn, &pnode->nlp_nodename, sizeof(struct lpfc_name));
 
@@ -4821,7 +4821,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 						FCP_LUN_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0713 SCSI layer issued Device Reset (%d, %d) "
+			 "0713 SCSI layer issued Device Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
 	/*
@@ -4854,7 +4854,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
-	unsigned int lun_id = cmnd->device->lun;
+	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status, ret = SUCCESS;
 
@@ -4888,7 +4888,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 					FCP_TARGET_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0723 SCSI layer issued Target Reset (%d, %d) "
+			 "0723 SCSI layer issued Target Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
 	/*
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9504ec0..7a4e68f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1961,9 +1961,9 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	scb_t			*scb;
 
 	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
-	     (aor == SCB_ABORT)? "ABORTING":"RESET",
-	     cmd->cmnd[0], cmd->device->channel, 
-	     cmd->device->id, cmd->device->lun);
+	       (aor == SCB_ABORT)? "ABORTING":"RESET",
+	       cmd->cmnd[0], cmd->device->channel,
+	       cmd->device->id, (u32)cmd->device->lun);
 
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
index b46f5e9..c3e9004 100644
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
index 6e7727f..cb4849b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2352,8 +2352,8 @@ struct isp_operations {
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
index 2411d1a1..3be592d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -250,10 +250,10 @@ extern int
 qla2x00_abort_command(srb_t *);
 
 extern int
-qla2x00_abort_target(struct fc_port *, unsigned int, int);
+qla2x00_abort_target(struct fc_port *, uint64_t, int);
 
 extern int
-qla2x00_lun_reset(struct fc_port *, unsigned int, int);
+qla2x00_lun_reset(struct fc_port *, uint64_t, int);
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
@@ -323,12 +323,12 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
 
 extern int qla24xx_abort_command(srb_t *);
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
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 873c820..b086cb7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1581,7 +1581,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x301c,
-		    "Check condition Sense data, nexus%ld:%d:%d cmd=%p.\n",
+		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
 		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
@@ -2182,7 +2182,7 @@ out:
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
 		    "FCP command status: 0x%x-0x%x (0x%x) "
-		    "nexus=%ld:%d:%d portid=%02x%02x%02x oxid=0x%x "
+		    "nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x "
 		    "cdb=%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
 		    comp_status, scsi_status, res, vha->host_no,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 68c55ea..813eb0c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -936,7 +936,7 @@ qla2x00_abort_command(srb_t *sp)
 }
 
 int
-qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
+qla2x00_abort_target(struct fc_port *fcport, uint64_t l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -989,7 +989,7 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 }
 
 int
-qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
+qla2x00_lun_reset(struct fc_port *fcport, uint64_t l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -1011,7 +1011,7 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 		mcp->mb[1] = fcport->loop_id;
 	else
 		mcp->mb[1] = fcport->loop_id << 8;
-	mcp->mb[2] = l;
+	mcp->mb[2] = (u32)l;
 	mcp->mb[3] = 0;
 	mcp->mb[9] = vha->vp_idx;
 
@@ -2598,7 +2598,7 @@ struct tsk_mgmt_cmd {
 
 static int
 __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
-    unsigned int l, int tag)
+    uint64_t l, int tag)
 {
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
@@ -2692,7 +2692,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 }
 
 int
-qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
+qla24xx_abort_target(struct fc_port *fcport, uint64_t l, int tag)
 {
 	struct qla_hw_data *ha = fcport->vha->hw;
 
@@ -2703,7 +2703,7 @@ qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 }
 
 int
-qla24xx_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
+qla24xx_lun_reset(struct fc_port *fcport, uint64_t l, int tag)
 {
 	struct qla_hw_data *ha = fcport->vha->hw;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 10d23f8..71e6ddf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -929,7 +929,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
+	uint64_t lun;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -953,7 +954,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8002,
-	    "Aborting from RISC nexus=%ld:%d:%d sp=%p cmd=%p\n",
+	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p\n",
 	    vha->host_no, id, lun, sp, cmd);
 
 	/* Get a reference to the sp and drop the lock.*/
@@ -988,7 +989,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	ql_log(ql_log_info, vha, 0x801c,
-	    "Abort command issued nexus=%ld:%d:%d --  %d %x.\n",
+	    "Abort command issued nexus=%ld:%d:%llu --  %d %x.\n",
 	    vha->host_no, id, lun, wait, ret);
 
 	return ret;
@@ -996,7 +997,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-	unsigned int l, enum nexus_wait_type type)
+	uint64_t l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	unsigned long flags;
@@ -1053,7 +1054,7 @@ static char *reset_errors[] = {
 
 static int
 __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int, int))
+    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, int))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -1068,7 +1069,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		return err;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%d cmd=%p.\n", name, vha->host_no,
+	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
 	    cmd->device->id, cmd->device->lun, cmd);
 
 	err = 0;
@@ -1093,14 +1094,14 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
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
@@ -1147,7 +1148,8 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
-	unsigned int id, lun;
+	unsigned int id;
+	uint64_t lun;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -1162,7 +1164,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	ret = FAILED;
 
 	ql_log(ql_log_info, vha, 0x8012,
-	    "BUS RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
+	    "BUS RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, vha, 0x8013,
@@ -1186,7 +1188,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 
 eh_bus_reset_done:
 	ql_log(ql_log_warn, vha, 0x802b,
-	    "BUS RESET %s nexus=%ld:%d:%d.\n",
+	    "BUS RESET %s nexus=%ld:%d:%llu.\n",
 	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
@@ -1213,14 +1215,15 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
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
@@ -1262,7 +1265,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 eh_host_reset_lock:
 	ql_log(ql_log_info, vha, 0x8017,
-	    "ADAPTER RESET %s nexus=%ld:%d:%d.\n",
+	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
 	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
@@ -1391,7 +1394,7 @@ static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
 		return;
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0x3029,
-	    "Queue depth adjusted-down to %d for nexus=%ld:%d:%d.\n",
+	    "Queue depth adjusted-down to %d for nexus=%ld:%d:%llu.\n",
 	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
 }
 
@@ -1414,7 +1417,7 @@ static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
 
 	ql_dbg(ql_dbg_io, vha, 0x302a,
-	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%d.\n",
+	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%llu.\n",
 	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 982293e..718f5b2 100644
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
index 14fec97..c03bb70 100644
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
index 1b83dc2..b8c1eba 100644
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
index 81e738d..7bed97b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1105,7 +1105,7 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
 	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE) {
 		status = QLA_ERROR;
 
-		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%d: abort task FAILED: "
+		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%llu: abort task FAILED: "
 		    "mbx0=%04X, mb1=%04X, mb2=%04X, mb3=%04X, mb4=%04X\n",
 		    ha->host_no, cmd->device->id, cmd->device->lun, mbox_sts[0],
 		    mbox_sts[1], mbox_sts[2], mbox_sts[3], mbox_sts[4]));
@@ -1125,13 +1125,13 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
  * are valid before calling this routine.
  **/
 int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
-		      int lun)
+		      uint64_t lun)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 	int status = QLA_SUCCESS;
 
-	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
+	DEBUG2(printk("scsi%ld:%d:%llu: lun reset issued\n", ha->host_no,
 		      ddb_entry->fw_ddb_index, lun));
 
 	/*
@@ -1143,7 +1143,7 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 
 	mbox_cmd[0] = MBOX_CMD_LUN_RESET;
 	mbox_cmd[1] = ddb_entry->fw_ddb_index;
-	mbox_cmd[2] = lun << 8;
+	mbox_cmd[2] = (lun & 0xFFFFFFFF);
 	mbox_cmd[5] = 0x01;	/* Immediate Command Enable */
 
 	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6142729..a1492ce 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5783,14 +5783,14 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	unsigned int id = cmd->device->id;
-	unsigned int lun = cmd->device->lun;
+	uint64_t lun = cmd->device->lun;
 	unsigned long flags;
 	struct srb *srb = NULL;
 	int ret = SUCCESS;
 	int wait = 0;
 
 	ql4_printk(KERN_INFO, ha,
-	    "scsi%ld:%d:%d: Abort command issued cmd=%p\n",
+	    "scsi%ld:%d:%llu: Abort command issued cmd=%p\n",
 	    ha->host_no, id, lun, cmd);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -5803,11 +5803,11 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
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
@@ -5817,14 +5817,14 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
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
@@ -5852,7 +5852,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	ret = FAILED;
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
+		   "scsi%ld:%d:%d:%llu: DEVICE RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	DEBUG2(printk(KERN_INFO
@@ -5882,7 +5882,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		goto eh_dev_reset_done;
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
+		   "scsi(%ld:%d:%d:%llu): DEVICE RESET SUCCEEDED.\n",
 		   ha->host_no, cmd->device->channel, cmd->device->id,
 		   cmd->device->lun);
 
@@ -5999,7 +5999,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
+		   "scsi(%ld:%d:%d:%llu): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2c0d0ec..183025a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1243,7 +1243,7 @@ EXPORT_SYMBOL(__starget_for_each_device);
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
-						   uint lun)
+						   uint64_t lun)
 {
 	struct scsi_device *sdev;
 
@@ -1268,7 +1268,7 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
-						 uint lun)
+						 uint64_t lun)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, uint64_t lun)
 {
 	struct scsi_device *sdev;
 
@@ -1327,7 +1327,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, uint64_t lun)
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5cda11c..5e6625b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -225,9 +225,9 @@ struct sdebug_dev_info {
 	unsigned char sense_buff[SDEBUG_SENSE_LEN];	/* weak nexus */
 	unsigned int channel;
 	unsigned int target;
-	unsigned int lun;
+	uint64_t lun;
 	struct sdebug_host_info *sdbg_host;
-	unsigned int wlun;
+	uint64_t wlun;
 	char reset;
 	char stopped;
 	char used;
@@ -2247,7 +2247,8 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 			    struct sdebug_dev_info * devip)
 {
 	unsigned int alloc_len;
-	int lun_cnt, i, upper, num, n, wlun, lun;
+	int lun_cnt, i, upper, num, n;
+	uint64_t wlun, lun;
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
@@ -2430,7 +2431,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, sdp->request_queue);
 	return 0;
@@ -2441,7 +2442,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	struct sdebug_dev_info *devip;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
@@ -2464,7 +2465,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 		(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
+		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
 		/* make this slot available for re-use */
@@ -2676,7 +2677,7 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %u> "
+			printk(KERN_INFO "scsi_debug:    <%u %u %u %llu> "
 			       "non-zero result=0x%x\n", sdp->host->host_no,
 			       sdp->channel, sdp->id, sdp->lun, scsi_result);
 		}
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 8f9a0ca..b3916ec 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -112,7 +112,7 @@ extern void scsi_exit_procfs(void);
 /* scsi_scan.c */
 extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
-				   unsigned int, unsigned int, int);
+				   unsigned int, uint64_t, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index ad747dc..665cdfb 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -196,7 +196,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 
 	sdev = to_scsi_device(dev);
 	seq_printf(s,
-		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
+		"Host: scsi%d Channel: %02d Id: %02d Lun: %02llu\n  Vendor: ",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	for (i = 0; i < 8; i++) {
 		if (sdev->vendor[i] >= 0x20)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4f315f5..3e860a3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -224,7 +224,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
  *     scsi_Device pointer, or NULL on failure.
  **/
 static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
-					   unsigned int lun, void *hostdata)
+					   uint64_t lun, void *hostdata)
 {
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
@@ -1000,7 +1000,7 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
-				  uint lun, int *bflagsp,
+				  uint64_t lun, int *bflagsp,
 				  struct scsi_device **sdevp, int rescan,
 				  void *hostdata)
 {
@@ -1153,7 +1153,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
 				     int bflags, int scsi_level, int rescan)
 {
-	unsigned int sparse_lun, lun, max_dev_lun;
+	uint max_dev_lun;
+	uint64_t sparse_lun, lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
@@ -1234,10 +1235,10 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function
  *     returns the integer: 0x0b030a04
  **/
-int scsilun_to_int(struct scsi_lun *scsilun)
+uint64_t scsilun_to_int(struct scsi_lun *scsilun)
 {
 	int i;
-	unsigned int lun;
+	uint64_t lun;
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
@@ -1265,7 +1266,7 @@ EXPORT_SYMBOL(scsilun_to_int);
  *     scsi_lun of : struct scsi_lun of: 0a 04 0b 03 00 00 00 00
  *
  **/
-void int_to_scsilun(unsigned int lun, struct scsi_lun *scsilun)
+void int_to_scsilun(uint64_t lun, struct scsi_lun *scsilun)
 {
 	int i;
 
@@ -1305,7 +1306,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
-	unsigned int lun;
+	uint64_t lun;
 	unsigned int num_luns;
 	unsigned int retries;
 	int result;
@@ -1448,25 +1449,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
@@ -1480,8 +1464,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
@@ -1500,7 +1484,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 }
 
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
-				      uint id, uint lun, void *hostdata)
+				      uint id, uint64_t lun, void *hostdata)
 {
 	struct scsi_device *sdev = ERR_PTR(-ENODEV);
 	struct device *parent = &shost->shost_gendev;
@@ -1532,7 +1516,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 EXPORT_SYMBOL(__scsi_add_device);
 
 int scsi_add_device(struct Scsi_Host *host, uint channel,
-		    uint target, uint lun)
+		    uint target, uint64_t lun)
 {
 	struct scsi_device *sdev = 
 		__scsi_add_device(host, channel, target, lun, NULL);
@@ -1561,7 +1545,7 @@ void scsi_rescan_device(struct device *dev)
 EXPORT_SYMBOL(scsi_rescan_device);
 
 static void __scsi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+		unsigned int id, uint64_t lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1627,7 +1611,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  *     sequential scan of LUNs on the target id.
  **/
 void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+		      unsigned int id, uint64_t lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
@@ -1647,7 +1631,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun, int rescan)
+			      unsigned int id, uint64_t lun, int rescan)
 {
 	uint order_id;
 
@@ -1678,10 +1662,10 @@ static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
-			    unsigned int id, unsigned int lun, int rescan)
+			    unsigned int id, uint64_t lun, int rescan)
 {
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
-		"%s: <%u:%u:%u>\n",
+		"%s: <%u:%u:%llu>\n",
 		__func__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..6e98f05 100644
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
@@ -1110,13 +1110,13 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
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
index e894ca7..091210f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2093,7 +2093,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
  * on the rport.
  */
 static void
-fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
+fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint64_t lun)
 {
 	struct fc_rport *rport;
 	unsigned long flags;
@@ -2125,7 +2125,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
  * object as the parent.
  */
 static int
-fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lun)
+fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint64_t lun)
 {
 	uint chlo, chhi;
 	uint tgtlo, tgthi;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dac7f8d..79ea665 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -773,7 +773,7 @@ EXPORT_SYMBOL_GPL(iscsi_scan_finished);
 struct iscsi_scan_data {
 	unsigned int channel;
 	unsigned int id;
-	unsigned int lun;
+	uint64_t lun;
 };
 
 static int iscsi_user_scan_session(struct device *dev, void *data)
@@ -820,7 +820,7 @@ user_scan_exit:
 }
 
 static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
-			   uint id, uint lun)
+			   uint id, uint64_t lun)
 {
 	struct iscsi_scan_data scan_data;
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..e290dd9 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1706,7 +1706,7 @@ EXPORT_SYMBOL(scsi_is_sas_rphy);
  */
 
 static int sas_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, uint lun)
+		uint id, uint64_t lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index be2c9a6..271d23d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2492,7 +2492,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
-		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
+		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
@@ -2621,7 +2621,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			seq_printf(s, "detached pending close ");
 		else
 			seq_printf
-			    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+			    (s, "scsi%d chan=%d id=%d lun=%llu   em=%d",
 			     scsidp->host->host_no,
 			     scsidp->channel, scsidp->id,
 			     scsidp->lun,
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 5995682..c6e3870 100644
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
index 2d444b1..beef93e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -220,7 +220,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd;
 
-	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
+	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%llu got CDB: 0x%02x"
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
@@ -301,7 +301,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
-	if (transport_lookup_tmr_lun(se_cmd, sc->device->lun) < 0)
+	if (transport_lookup_tmr_lun(se_cmd, (u32)sc->device->lun) < 0)
 		goto release;
 	/*
 	 * Queue the TMR to TCM Core and sleep waiting for tcm_loop_queue_tm_rsp()
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 2bcfd79..0709713 100644
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
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..3715a32 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -378,7 +378,7 @@ struct scsi_lun {
 #define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
 #define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
 
-static inline int scsi_is_wlun(unsigned int lun)
+static inline int scsi_is_wlun(uint64_t lun)
 {
 	return (lun & 0xff00) == SCSI_W_LUN_BASE;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..02b354a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -91,8 +91,8 @@ struct scsi_device {
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
-	unsigned int id, lun, channel;
-
+	unsigned int id, channel;
+	uint64_t lun;
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
@@ -290,9 +290,9 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
-		uint, uint, uint, void *hostdata);
+		uint, uint, uint64_t, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
-			   uint target, uint lun);
+			   uint target, uint64_t lun);
 extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
@@ -300,13 +300,13 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-					      uint, uint, uint);
+					      uint, uint, uint64_t);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
-						uint, uint, uint);
+						uint, uint, uint64_t);
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
-							uint);
+							uint64_t);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
-							  uint);
+							  uint64_t);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
 extern void __starget_for_each_device(struct scsi_target *, void *,
@@ -379,13 +379,13 @@ extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+			     unsigned int id, uint64_t lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *, enum scsi_device_state);
 extern void scsi_remove_target(struct device *);
-extern void int_to_scsilun(unsigned int, struct scsi_lun *);
-extern int scsilun_to_int(struct scsi_lun *);
+extern void int_to_scsilun(uint64_t, struct scsi_lun *);
+extern uint64_t scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index af244f4..eb37b7c 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -35,7 +35,7 @@ struct scsi_transport_template {
 	/*
 	 * If set, called from sysfs and legacy procfs rescanning code.
 	 */
-	int (*user_scan)(struct Scsi_Host *, uint, uint, uint);
+	int (*user_scan)(struct Scsi_Host *, uint, uint, uint64_t);
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
-- 
1.7.4.2

