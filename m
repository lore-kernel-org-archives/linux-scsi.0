From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 10:35:30 -0400
Message-ID: <20060911143530.GB13318@havoc.gtf.org>
References: <20060911143406.GA12991@havoc.gtf.org> <20060911143458.GA13318@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:43911 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751252AbWIKOfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 10:35:31 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id CDDE71C24E8A
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 10:35:30 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id k8BEZUif013403
	for linux-scsi@vger.kernel.org; Mon, 11 Sep 2006 10:35:30 -0400
Content-Disposition: inline
In-Reply-To: <20060911143458.GA13318@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


DO NOT APPLY.

Not-signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/3w-xxxx.c                |   22 ++++++++++++--------
 drivers/scsi/BusLogic.c               |    6 ++---
 drivers/scsi/NCR5380.c                |    8 +++----
 drivers/scsi/NCR53C9x.c               |   12 +++++------
 drivers/scsi/advansys.c               |   23 +++++++++++----------
 drivers/scsi/aha152x.c                |    6 ++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    8 +++----
 drivers/scsi/dc395x.c                 |   24 +++++++++++-----------
 drivers/scsi/eata.c                   |    9 ++------
 drivers/scsi/g_NCR5380.c              |   10 ++++-----
 drivers/scsi/gdth_proc.c              |   12 +++++------
 drivers/scsi/in2000.c                 |   36 +++++++++++++++++-----------------
 drivers/scsi/initio.c                 |    2 -
 drivers/scsi/ipr.c                    |    3 +-
 drivers/scsi/libata-scsi.c            |    2 -
 drivers/scsi/megaraid/mega_common.h   |    2 -
 drivers/scsi/megaraid/megaraid_mbox.c |    6 ++---
 drivers/scsi/megaraid/megaraid_sas.h  |    6 ++---
 drivers/scsi/ncr53c8xx.c              |    2 -
 drivers/scsi/nsp32.c                  |    4 +--
 drivers/scsi/pcmcia/nsp_cs.c          |    2 -
 drivers/scsi/psi240i.c                |    2 -
 drivers/scsi/sym53c8xx_2/sym_glue.c   |    6 ++---
 23 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index f3a5f42..f8f2e5e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1547,7 +1547,8 @@ static int tw_scsiop_inquiry_complete(TW
 	request_buffer[2] = 0;	       /* No ansi/iso compliance */
 	request_buffer[4] = 31;	       /* Additional length */
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
-	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
+	sprintf(&request_buffer[16], "Logical Disk %-2d ",
+		scmd_id(tw_dev->srb[request_id]));
 	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
 	tw_transfer_internal(tw_dev, request_id, request_buffer,
 			     sizeof(request_buffer));
@@ -1559,10 +1560,10 @@ static int tw_scsiop_inquiry_complete(TW
 	}
 	is_unit_present = &(param->data[0]);
 
-	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
+	if (is_unit_present[scmd_id(tw_dev->srb[request_id])] & TW_UNIT_ONLINE) {
+		tw_dev->is_unit_present[scmd_id(tw_dev->srb[request_id])] = 1;
 	} else {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
+		tw_dev->is_unit_present[scmd_id(tw_dev->srb[request_id])] = 0;
 		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
 		return TW_ISR_DONT_RESULT;
 	}
@@ -1613,7 +1614,8 @@ static int tw_scsiop_mode_sense(TW_Devic
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + tw_dev->srb[request_id]->device->id;
+	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE +
+		scmd_id(tw_dev->srb[request_id]);
 	param->parameter_id = 7; /* unit flags */
 	param->parameter_size_bytes = 1;
 	param_value = tw_dev->alignment_physical_address[request_id];
@@ -1690,7 +1692,8 @@ static int tw_scsiop_read_capacity(TW_De
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 	command_packet->size = 4;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->unit__hostid =
+		TW_UNITHOST_IN(0, scmd_id(tw_dev->srb[request_id]));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 	command_packet->byte6.block_count = 1;
@@ -1703,7 +1706,7 @@ static int tw_scsiop_read_capacity(TW_De
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
 	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + 
-	tw_dev->srb[request_id]->device->id;
+		scmd_id(tw_dev->srb[request_id]);
 	param->parameter_id = 4;	/* unitcapacity parameter */
 	param->parameter_size_bytes = 4;
 	param_value = tw_dev->alignment_physical_address[request_id];
@@ -1803,7 +1806,7 @@ static int tw_scsiop_read_write(TW_Devic
 
 	command_packet->size = 3;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, srb->device->id);
+	command_packet->unit__hostid = TW_UNITHOST_IN(0, scmd_id(srb));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 
@@ -1908,7 +1911,8 @@ static int tw_scsiop_synchronize_cache(T
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(0, TW_OP_FLUSH_CACHE);
 	command_packet->size = 2;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->unit__hostid =
+		TW_UNITHOST_IN(0, scmd_id(tw_dev->srb[request_id]));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 	command_packet->byte6.parameter_count = 1;
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 16a12a3..87f347b 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2140,7 +2140,7 @@ static void __init BusLogic_InitializeHo
 static int BusLogic_SlaveConfigure(struct scsi_device *Device)
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Device->host->hostdata;
-	int TargetID = Device->id;
+	int TargetID = sdev_id(Device);
 	int QueueDepth = HostAdapter->QueueDepth[TargetID];
 
 	if (HostAdapter->TargetFlags[TargetID].TaggedQueuingSupported && (HostAdapter->TaggedQueuingPermitted & (1 << TargetID))) {
@@ -2746,7 +2746,7 @@ static int BusLogic_host_reset(struct sc
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) SCpnt->device->host->hostdata;
 
-	unsigned int id = SCpnt->device->id;
+	unsigned int id = scmd_id(SCpnt);
 	struct BusLogic_TargetStatistics *stats = &HostAdapter->TargetStatistics[id];
 	int rc;
 
@@ -2962,7 +2962,7 @@ static int BusLogic_AbortCommand(struct 
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
 
-	int TargetID = Command->device->id;
+	int TargetID = scmd_id(Command);
 	struct BusLogic_CCB *CCB;
 	BusLogic_IncrementErrorCounter(&HostAdapter->TargetStatistics[TargetID].CommandAbortsRequested);
 	/*
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 060a3bb..d8b95a5 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -974,15 +974,15 @@ #ifdef NCR5380_STATS
 		case WRITE:
 		case WRITE_6:
 		case WRITE_10:
-			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;
+			hostdata->time_write[scmd_id(cmd)] -= (jiffies - hostdata->timebase);
+			hostdata->bytes_write[scmd_id(cmd)] += cmd->request_bufflen;
 			hostdata->pendingw++;
 			break;
 		case READ:
 		case READ_6:
 		case READ_10:
-			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;
+			hostdata->time_read[scmd_id(cmd)] -= (jiffies - hostdata->timebase);
+			hostdata->bytes_read[scmd_id(cmd)] += cmd->request_bufflen;
 			hostdata->pendingr++;
 			break;
 	}
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index bdc6bb2..eeabc10 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -870,7 +870,7 @@ static int esp_host_info(struct NCR_ESP 
 
 	shost_for_each_device(sdev, esp->ehost) {
 		struct esp_device *esp_dev = sdev->hostdata;
-		uint id = sdev->id;
+		uint id = sdev_id(sdev);
 
 		if (!(esp->targets_present & (1 << id)))
 			continue;
@@ -3044,10 +3044,10 @@ static int check_multibyte_msg(struct NC
 				else
 					bit = ESP_CONFIG3_FSCSI;
 				if(period < 50)
-					esp->config3[SCptr->device->id] |= bit;
+					esp->config3[scmd_id(SCptr)] |= bit;
 				else
-					esp->config3[SCptr->device->id] &= ~bit;
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
+					esp->config3[scmd_id(SCptr)] &= ~bit;
+				esp->prev_cfg3 = esp->config3[scmd_id(SCptr)];
 				esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 			}
 			esp->prev_soff = esp_dev->sync_min_period;
@@ -3077,8 +3077,8 @@ static int check_multibyte_msg(struct NC
 					bit = ESP_CONFIG3_FAST;
 				else
 					bit = ESP_CONFIG3_FSCSI;
-				esp->config3[SCptr->device->id] &= ~bit;
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
+				esp->config3[scmd_id(SCptr)] &= ~bit;
+				esp->prev_cfg3 = esp->config3[scmd_id(SCptr)];
 				esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 			}
 		}
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e32b4ab..431a4c4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3522,7 +3522,7 @@ #define DRIVER_BYTE(byte)   ((byte) << 2
 typedef struct scsi_cmnd     REQ, *REQP;
 #define REQPNEXT(reqp)       ((REQP) ((reqp)->host_scribble))
 #define REQPNEXTP(reqp)      ((REQP *) &((reqp)->host_scribble))
-#define REQPTID(reqp)        ((reqp)->device->id)
+#define REQPTID(reqp)        (scmd_id(reqp))
 #define REQPTIME(reqp)       ((reqp)->SCp.this_residual)
 #define REQTIMESTAMP()       (jiffies)
 
@@ -6238,7 +6238,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
         (ulong) scp, (ulong) scp->scsi_done);
 
     boardp = ASC_BOARDP(scp->device->host);
-    device = boardp->device[scp->device->id];
+    device = boardp->device[scmd_id(scp)];
 
     if (ASC_NARROW_BOARD(boardp)) {
         /*
@@ -6273,7 +6273,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
              * Increment monotonically increasing per device successful
              * request counter. Wrapping doesn't matter.
              */
-            boardp->reqcnt[scp->device->id]++;
+            boardp->reqcnt[scmd_id(scp)]++;
             asc_enqueue(&boardp->active, scp, ASC_BACK);
             ASC_DBG(1,
                 "asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR\n");
@@ -6353,7 +6353,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
              * Increment monotonically increasing per device successful
              * request counter. Wrapping doesn't matter.
              */
-            boardp->reqcnt[scp->device->id]++;
+            boardp->reqcnt[scmd_id(scp)]++;
             asc_enqueue(&boardp->active, scp, ASC_BACK);
             ASC_DBG(1,
                 "asc_execute_scsi_cmnd: AdvExeScsiQueue(), ASC_NOERROR\n");
@@ -6446,8 +6446,8 @@ asc_build_req(asc_board_t *boardp, struc
      * started request.
      *
      */
-    if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
-        (boardp->reqcnt[scp->device->id] % 255) == 0) {
+    if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scmd_id(scp)] > 0) &&
+        (boardp->reqcnt[scmd_id(scp)] % 255) == 0) {
         asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
     } else {
         asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
@@ -6957,10 +6957,10 @@ asc_isr_callback(ASC_DVC_VAR *asc_dvc_va
      * current request finished normally, then set the bit for the target
      * to indicate that a device is present.
      */
-    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scmd_id(scp))) == 0 &&
         qdonep->d3.done_stat == QD_NO_ERROR &&
         qdonep->d3.host_stat == QHSTA_NO_ERROR) {
-        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scmd_id(scp));
     }
 
     /*
@@ -7136,10 +7136,10 @@ adv_isr_callback(ADV_DVC_VAR *adv_dvc_va
      * current request finished normally, then set the bit for the target
      * to indicate that a device is present.
      */
-    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scmd_id(scp))) == 0 &&
         scsiqp->done_status == QD_NO_ERROR &&
         scsiqp->host_status == QHSTA_NO_ERROR) {
-        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scmd_id(scp));
     }
 
     /*
@@ -7379,7 +7379,8 @@ #ifdef ADVANSYS_STATS
         {
             REQP reqp;
             for (reqp = firstp; reqp; reqp = REQPNEXT(reqp)) {
-                REQTIMESTAT("asc_dequeue_list", ascq, reqp, reqp->device->id);
+                REQTIMESTAT("asc_dequeue_list", ascq, reqp,
+			    scmd_id(reqp));
             }
         }
 #endif /* ADVANSYS_STATS */
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f974869..3b55c9f 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -592,8 +592,8 @@ #define ADDMSGI(x)		(MSGILEN<256 ? (void
 
 #define DATA_LEN		(HOSTDATA(shpnt)->data_len)
 
-#define SYNCRATE		(HOSTDATA(shpnt)->syncrate[CURRENT_SC->device->id])
-#define SYNCNEG			(HOSTDATA(shpnt)->syncneg[CURRENT_SC->device->id])
+#define SYNCRATE		(HOSTDATA(shpnt)->syncrate[scmd_id(CURRENT_SC)])
+#define SYNCNEG			(HOSTDATA(shpnt)->syncneg[scmd_id(CURRENT_SC)])
 
 #define DELAY			(HOSTDATA(shpnt)->delay)
 #define EXT_TRANS		(HOSTDATA(shpnt)->ext_trans)
@@ -1690,7 +1690,7 @@ #endif
 		/* clear selection timeout */
 		SETPORT(SSTAT1, SELTO);
 
-		SETPORT(SCSIID, (shpnt->this_id << OID_) | CURRENT_SC->device->id);
+		SETPORT(SCSIID, (shpnt->this_id << OID_) | scmd_id(CURRENT_SC));
 		SETPORT(SXFRCTL1, (PARITY ? ENSPCHK : 0 ) | ENSTIMER);
 		SETPORT(SCSISEQ, ENSELO | ENAUTOATNO | (DISCONNECTED_SC ? ENRESELI : 0));
 	} else {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index aa4be8a..176f789 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -790,9 +790,9 @@ #endif
 
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahc, cmd)						    \
-	((((cmd)->device->id << TID_SHIFT) & TID)			    \
-	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
+	(((scmd_id(cmd) << TID_SHIFT) & TID)			    \
+	| ((scmd_channel(cmd) == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
+	| ((scmd_channel(cmd) == 0) ? 0 : TWIN_CHNLB))
 
 /******************************** Bus DMA *************************************/
 int
@@ -1437,7 +1437,7 @@ ahc_linux_run_command(struct ahc_softc *
 	    && (ahc->features & AHC_SCB_BTT) == 0) {
 		int target_offset;
 
-		target_offset = cmd->device->id + cmd->device->channel * 8;
+		target_offset = scmd_id(cmd) + scmd_channel(cmd) * 8;
 		untagged_q = &(ahc->untagged_queues[target_offset]);
 		if (!TAILQ_EMPTY(untagged_q))
 			/* if we're already executing an untagged command
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index ff2b179..77c018d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1635,7 +1635,7 @@ #endif
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -2056,7 +2056,7 @@ static void data_out_phase0(struct Adapt
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2186,7 +2186,7 @@ static void data_out_phase1(struct Adapt
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2198,7 +2198,7 @@ static void data_in_phase0(struct Adapte
 	u16 scsi_status = *pscsi_status;
 
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2415,7 +2415,7 @@ static void data_in_phase1(struct Adapte
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2427,7 +2427,7 @@ static void data_io_transfer(struct Adap
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2606,7 +2606,7 @@ static void status_phase0(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2620,7 +2620,7 @@ static void status_phase1(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, scmd_id(srb->cmd), srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -3543,7 +3543,7 @@ static void srb_done(struct AdapterCtlBl
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd->pid, cmd->device->id, cmd->device->lun,
+				cmd->pid, scmd_id(cmd), cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3722,7 +3722,7 @@ static void request_sense(struct Adapter
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
-		cmd->pid, cmd->device->id, cmd->device->lun);
+		cmd->pid, scmd_id(cmd), cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3950,7 +3950,7 @@ static int dc395x_slave_alloc(struct scs
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 
-	dcb = device_alloc(acb, scsi_device->id, scsi_device->lun);
+	dcb = device_alloc(acb, sdev_id(scsi_device), scsi_device->lun);
 	if (!dcb)
 		return -ENOMEM;
 	adapter_add_device(acb, dcb);
@@ -3968,7 +3968,7 @@ static int dc395x_slave_alloc(struct scs
 static void dc395x_slave_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
-	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
+	struct DeviceCtlBlk *dcb = find_dcb(acb, sdev_id(scsi_device), scsi_device->lun);
 	if (dcb)
 		adapter_remove_and_free_device(acb, dcb);
 }
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index dda36f5..e1751ae 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2440,9 +2440,7 @@ #endif
 
 		/* If there was a bus reset, redo operation on each target */
 		else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-			 && ha->target_redo[SCpnt->device->id][SCpnt->
-								  device->
-								  channel])
+			 && ha->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)])
 			status = DID_BUS_BUSY << 16;
 
 		/* Works around a flaw in scsi.c */
@@ -2475,12 +2473,11 @@ #endif
 	case ASST:		/* Selection Time Out */
 	case 0x02:		/* Command Time Out   */
 
-		if (ha->target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
+		if (ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] > 1)
 			status = DID_ERROR << 16;
 		else {
 			status = DID_TIME_OUT << 16;
-			ha->target_to[SCpnt->device->id][SCpnt->device->
-							    channel]++;
+			ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)]++;
 		}
 
 		break;
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 67f1100..f598416 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -846,12 +846,12 @@ #ifdef NCR5380_STATS
 	if (hostdata->pendingr || hostdata->pendingw)
 		PRINTP("\n");
 	shost_for_each_device(dev, scsi_ptr) {
-		unsigned long br = hostdata->bytes_read[dev->id];
-		unsigned long bw = hostdata->bytes_write[dev->id];
-		long tr = hostdata->time_read[dev->id] / HZ;
-		long tw = hostdata->time_write[dev->id] / HZ;
+		unsigned long br = hostdata->bytes_read[sdev_id(dev)];
+		unsigned long bw = hostdata->bytes_write[sdev_id(dev)];
+		long tr = hostdata->time_read[sdev_id(dev)] / HZ;
+		long tw = hostdata->time_write[sdev_id(dev)] / HZ;
 
-		PRINTP("  T:%d %s " ANDP dev->id ANDP(dev->type < MAX_SCSI_DEVICE_CODE) ? scsi_device_types[(int) dev->type] : "Unknown");
+		PRINTP("  T:%d %s " ANDP sdev_id(dev) ANDP(dev->type < MAX_SCSI_DEVICE_CODE) ? scsi_device_types[(int) dev->type] : "Unknown");
 		for (i = 0; i < 8; i++)
 			if (dev->vendor[i] >= 0x20)
 				*(buffer + (len++)) = dev->vendor[i];
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 32982eb..5449c48 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -780,8 +780,8 @@ static void gdth_wait_completion(int han
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
 
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
+        t = scmd_id(scp);
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
             scp->SCp.have_data_in = 0;
@@ -807,8 +807,8 @@ static void gdth_stop_timeout(int hanum,
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
         if (scp->done != gdth_scsi_done) {
             b = virt_ctr ?
-                NUMDATA(scp->device->host)->busnum : scp->device->channel;
-            t = scp->device->id;
+                NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
+            t = scmd_id(scp);
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
                 scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
@@ -831,8 +831,8 @@ static void gdth_start_timeout(int hanum
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
         if (scp->done != gdth_scsi_done) {
             b = virt_ctr ?
-                NUMDATA(scp->device->host)->busnum : scp->device->channel;
-            t = scp->device->id;
+                NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
+            t = scmd_id(scp);
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_start_timeout(): update_timeout()\n"));
                 gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 59a4097..d8c7fb6 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -493,7 +493,7 @@ static void in2000_execute(struct Scsi_H
 		hostdata->input_Q = (Scsi_Cmnd *) cmd->host_scribble;
 
 #ifdef PROC_STATISTICS
-	hostdata->cmd_cnt[cmd->device->id]++;
+	hostdata->cmd_cnt[scmd_id(cmd)]++;
 #endif
 
 /*
@@ -501,9 +501,9 @@ #endif
  */
 
 	if (is_dir_out(cmd))
-		write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id);
+		write_3393(hostdata, WD_DESTINATION_ID, scmd_id(cmd));
 	else
-		write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id | DSTID_DPD);
+		write_3393(hostdata, WD_DESTINATION_ID, scmd_id(cmd) | DSTID_DPD);
 
 /* Now we need to figure out whether or not this command is a good
  * candidate for disconnect/reselect. We guess to the best of our
@@ -584,11 +584,11 @@ #endif
  * unless we don't want to even _try_ synchronous transfers: In this
  * case we set SS_SET to make the defaults final.
  */
-		if (hostdata->sync_stat[cmd->device->id] == SS_UNSET) {
-			if (hostdata->sync_off & (1 << cmd->device->id))
-				hostdata->sync_stat[cmd->device->id] = SS_SET;
+		if (hostdata->sync_stat[scmd_id(cmd)] == SS_UNSET) {
+			if (hostdata->sync_off & (1 << scmd_id(cmd)))
+				hostdata->sync_stat[scmd_id(cmd)] = SS_SET;
 			else
-				hostdata->sync_stat[cmd->device->id] = SS_FIRST;
+				hostdata->sync_stat[scmd_id(cmd)] = SS_FIRST;
 		}
 		hostdata->state = S_SELECTING;
 		write_3393_count(hostdata, 0);	/* this guarantees a DATA_PHASE interrupt */
@@ -769,7 +769,7 @@ static void transfer_bytes(Scsi_Cmnd * c
 
 /* Set up hardware registers */
 
-	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[cmd->device->id]);
+	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[scmd_id(cmd)]);
 	write_3393_count(hostdata, cmd->SCp.this_residual);
 	write_3393(hostdata, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_BUS);
 	write1_io(0, IO_FIFO_WRITE);	/* zero counter, assume write */
@@ -1224,8 +1224,8 @@ #endif
 #ifdef SYNC_DEBUG
 			    printk("-REJ-");
 #endif
-			if (hostdata->sync_stat[cmd->device->id] == SS_WAITING)
-				hostdata->sync_stat[cmd->device->id] = SS_SET;
+			if (hostdata->sync_stat[scmd_id(cmd)] == SS_WAITING)
+				hostdata->sync_stat[scmd_id(cmd)] = SS_SET;
 			write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_CONNECTED;
 			break;
@@ -1245,7 +1245,7 @@ #endif
 				switch (ucp[2]) {	/* what's the EXTENDED code? */
 				case EXTENDED_SDTR:
 					id = calc_sync_xfer(ucp[3], ucp[4]);
-					if (hostdata->sync_stat[cmd->device->id] != SS_WAITING) {
+					if (hostdata->sync_stat[scmd_id(cmd)] != SS_WAITING) {
 
 /* A device has sent an unsolicited SDTR message; rather than go
  * through the effort of decoding it and then figuring out what
@@ -1263,14 +1263,14 @@ #endif
 						hostdata->outgoing_msg[3] = hostdata->default_sx_per / 4;
 						hostdata->outgoing_msg[4] = 0;
 						hostdata->outgoing_len = 5;
-						hostdata->sync_xfer[cmd->device->id] = calc_sync_xfer(hostdata->default_sx_per / 4, 0);
+						hostdata->sync_xfer[scmd_id(cmd)] = calc_sync_xfer(hostdata->default_sx_per / 4, 0);
 					} else {
-						hostdata->sync_xfer[cmd->device->id] = id;
+						hostdata->sync_xfer[scmd_id(cmd)] = id;
 					}
 #ifdef SYNC_DEBUG
-					printk("sync_xfer=%02x", hostdata->sync_xfer[cmd->device->id]);
+					printk("sync_xfer=%02x", hostdata->sync_xfer[scmd_id(cmd)]);
 #endif
-					hostdata->sync_stat[cmd->device->id] = SS_SET;
+					hostdata->sync_stat[scmd_id(cmd)] = SS_SET;
 					write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 					hostdata->state = S_CONNECTED;
 					break;
@@ -1465,7 +1465,7 @@ #endif
 			hostdata->state = S_UNCONNECTED;
 
 #ifdef PROC_STATISTICS
-			hostdata->disc_done_cnt[cmd->device->id]++;
+			hostdata->disc_done_cnt[scmd_id(cmd)]++;
 #endif
 
 			break;
@@ -1562,9 +1562,9 @@ #endif
 		 */
 
 		if (is_dir_out(cmd))
-			write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id);
+			write_3393(hostdata, WD_DESTINATION_ID, scmd_id(cmd));
 		else
-			write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id | DSTID_DPD);
+			write_3393(hostdata, WD_DESTINATION_ID, scmd_id(cmd) | DSTID_DPD);
 		if (hostdata->level2 >= L2_RESELECT) {
 			write_3393_count(hostdata, 0);	/* we want a DATA_PHASE interrupt */
 			write_3393(hostdata, WD_COMMAND_PHASE, 0x45);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9e10dac..4d9610f 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -3018,7 +3018,7 @@ static int i91u_biosparam(struct scsi_de
 	TCS *pTcb;
 
 	pHcb = (HCS *) sdev->host->base;
-	pTcb = &pHcb->HCS_Tcs[sdev->id];
+	pTcb = &pHcb->HCS_Tcs[sdev_id(sdev)];
 
 	if (pTcb->TCS_DrvHead) {
 		info_array[0] = pTcb->TCS_DrvHead;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 01080b3..c263fbf 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4169,7 +4169,8 @@ static void ipr_erp_start(struct ipr_ioa
 		 * will give CC/UA the next command.
 		 */
 		if (!res->resetting_device)
-			scsi_report_bus_reset(ioa_cfg->host, scsi_cmd->device->channel);
+			scsi_report_bus_reset(ioa_cfg->host,
+					      scmd_channel(scsi_cmd));
 		scsi_cmd->result |= (DID_ERROR << 16);
 		if (!ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index e92c31d..d7bd4e0 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -2490,7 +2490,7 @@ static struct ata_device * __ata_scsi_fi
 	if (unlikely(scsidev->channel || scsidev->lun))
 		return NULL;
 
-	return ata_find_dev(ap, scsidev->id);
+	return ata_find_dev(ap, sdev_id(scsidev));
 }
 
 /**
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 8cd0bd1..1fd3ed8 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -226,7 +226,7 @@ #define MRAID_IS_LOGICAL(adp, scp)	\
 	(SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0
 
 #define MRAID_IS_LOGICAL_SDEV(adp, sdev)	\
-	(sdev->channel == (adp)->max_channel) ? 1 : 0
+	(sdev_channel(sdev) == (adp)->max_channel) ? 1 : 0
 
 #define MRAID_GET_DEVICE_MAP(adp, scp, p_chan, target, islogical)	\
 	/*								\
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index cd982c8..ee874cb 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -4104,15 +4104,15 @@ megaraid_sysfs_show_ldnum(struct device 
 
 			for (i = 0; i < MAX_LOGICAL_DRIVES_40LD; i++) {
 
-				mapped_sdev_id = sdev->id;
+				mapped_sdev_id = sdev_id(sdev);
 
-				if (sdev->id > adapter->init_id) {
+				if (sdev_id(sdev) > adapter->init_id) {
 					mapped_sdev_id -= 1;
 				}
 
 				if (raid_dev->curr_ldmap[i] == mapped_sdev_id) {
 
-					scsi_id = sdev->id;
+					scsi_id = sdev_id(sdev);
 
 					logical_drv = i;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3531a14..704c6f7 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1095,11 +1095,11 @@ struct megasas_instance {
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
-	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	(scmd_channel(scp) < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
 
 #define MEGASAS_DEV_INDEX(inst, scp)					\
-	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
-	scp->device->id
+	((scmd_channel(scp) % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + \
+	scmd_id(scp)
 
 struct megasas_cmd {
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index b28712d..35c3a58 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4956,7 +4956,7 @@ void ncr_complete (struct ncb *np, struc
 		**	Allocate the lcb if not yet.
 		*/
 		if (!lp)
-			ncr_alloc_lcb (np, cmd->device->id, cmd->device->lun);
+			ncr_alloc_lcb (np, scmd_id(cmd), cmd->device->lun);
 
 		tp->bytes     += cp->data_len;
 		tp->transfers ++;
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index bfb4f49..8b8fac0 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -962,7 +962,7 @@ static int nsp32_queuecommand(struct scs
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
-		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
+		  scmd_id(SCpnt), SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  SCpnt->use_sg, SCpnt->request_buffer, SCpnt->request_bufflen);
 
 	if (data->CurrentSC != NULL) {
@@ -1075,7 +1075,7 @@ static int nsp32_queuecommand(struct scs
 
 	nsp32_dbg(NSP32_DEBUG_TARGETFLAG,
 		  "target: %d sync_flag: 0x%x syncreg: 0x%x ackwidth: 0x%x",
-		  SCpnt->device->id, target->sync_flag, target->syncreg,
+		  scmd_id(SCpnt), target->sync_flag, target->syncreg,
 		  target->ackwidth);
 
 	/* Selection */
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 0d4c04e..746d374 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1048,7 +1048,7 @@ static irqreturn_t nspintr(int irq, void
 	}
 
 	tmpSC    = data->CurrentSC;
-	target   = tmpSC->device->id;
+	target   = scmd_id(tmpSC);
 	lun      = tmpSC->device->lun;
 	sync_neg = &(data->Sync[target].SyncNegotiation);
 
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 5c2cdf5..e04a9a4 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -394,7 +394,7 @@ static int Psi240i_QueueCommand (Scsi_Cm
 	{
 	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
 	PADAPTER240I	padapter = HOSTDATA (SCpnt->device->host); 			// Pointer to adapter control structure
-	POUR_DEVICE 		pdev	 = &padapter->device [SCpnt->device->id];// Pointer to device information
+	POUR_DEVICE 		pdev	 = &padapter->device [scmd_id(SCpnt)];// Pointer to device information
 	UCHAR			rc;											// command return code
 
 	SCpnt->scsi_done = done;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 739d3ef..b8c947d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -302,7 +302,7 @@ #endif
 			 * condition otherwise the device will always return
 			 * BUSY.  Use a big stick.
 			 */
-			sym_reset_scsi_target(np, cmd->device->id);
+			sym_reset_scsi_target(np, scmd_id(cmd));
 			cam_status = DID_ERROR;
 		}
 	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */
@@ -415,7 +415,7 @@ static int sym_queue_command(struct sym_
 	 *  Minimal checkings, so that we will not 
 	 *  go outside our tables.
 	 */
-	if (sdev->id == np->myaddr) {
+	if (sdev_id(sdev) == np->myaddr) {
 		sym_xpt_done2(np, cmd, DID_NO_CONNECT);
 		return 0;
 	}
@@ -751,7 +751,7 @@ static int sym_eh_handler(int op, char *
 		sts = sym_abort_scsiio(np, cmd, 1);
 		break;
 	case SYM_EH_DEVICE_RESET:
-		sts = sym_reset_scsi_target(np, cmd->device->id);
+		sts = sym_reset_scsi_target(np, scmd_id(cmd));
 		break;
 	case SYM_EH_BUS_RESET:
 		sym_reset_scsi_bus(np, 1);
