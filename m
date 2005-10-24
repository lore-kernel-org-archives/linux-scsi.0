From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 11/n] HCIL drivers update
Date: Mon, 24 Oct 2005 04:16:00 -0400
Message-ID: <20051024081600.GB7160@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45184 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750722AbVJXIQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 04:16:01 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 6B4671C0A7AF
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 04:16:00 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O8G0hh007281
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 04:16:00 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Replace sdev_channel(cmd->device) with scmd_channel(cmd).


 drivers/block/cciss_scsi.c           |    3 +--
 drivers/message/fusion/mptscsih.c    |    7 +++----
 drivers/scsi/aacraid/aachba.c        |    8 ++++----
 drivers/scsi/aic7xxx/aic79xx_osm.c   |   10 +++++-----
 drivers/scsi/aic7xxx/aic7xxx_osm.c   |   20 ++++++++++----------
 drivers/scsi/aic7xxx_old.c           |   24 ++++++++++++------------
 drivers/scsi/atp870u.c               |    6 +++---
 drivers/scsi/dpt_i2o.c               |    8 ++++----
 drivers/scsi/eata.c                  |   12 ++++++------
 drivers/scsi/gdth.c                  |   10 +++++-----
 drivers/scsi/gdth_proc.c             |    6 +++---
 drivers/scsi/ipr.c                   |    2 +-
 drivers/scsi/ips.c                   |   16 ++++++++--------
 drivers/scsi/megaraid/mega_common.h  |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h |    2 +-
 drivers/scsi/qla1280.c               |    2 +-
 drivers/scsi/scsi_error.c            |    8 ++++----
 drivers/scsi/sg.c                    |    2 +-
 drivers/scsi/u14-34f.c               |   12 ++++++------
 drivers/usb/image/microtek.c         |    4 ++--
 20 files changed, 81 insertions(+), 83 deletions(-)

163302b968bfac500e7a44f55b2e4780499d727c
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e0277d9..9df7987 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1272,8 +1272,7 @@ cciss_scsi_queue_command (struct scsi_cm
 	c = (ctlr_info_t **) &cmd->device->host->hostdata[0];	
 	ctlr = (*c)->ctlr;
 
-	rc = lookup_scsi3addr(ctlr, sdev_channel(cmd->device),
-			scmd_id(cmd),
+	rc = lookup_scsi3addr(ctlr, scmd_channel(cmd), scmd_id(cmd),
 			&cmd->device->lun, scsi3addr);
 	if (rc != 0) {
 		/* the scsi nexus does not match any that we presented... */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0d54827..ced3739 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1801,8 +1801,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	hd->abortSCpnt = SCpnt;
 
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-		sdev_channel(SCpnt->device),
-		scmd_id(SCpnt),
+		scmd_channel(SCpnt), scmd_id(SCpnt),
 		&SCpnt->device->lun,
 		ctx2abort, 2 /* 2 second timeout */);
 
@@ -1854,7 +1853,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 
 	int_to_scsilun(0, &lun0);
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		sdev_channel(SCpnt->device), scmd_id(SCpnt),
+		scmd_channel(SCpnt), scmd_id(SCpnt),
 		&lun0, 0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
@@ -1905,7 +1904,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 
 	int_to_scsilun(0, &lun0);
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		sdev_channel(SCpnt->device), 0, &lun0,
+		scmd_channel(SCpnt), 0, &lun0,
 		0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 5540607..e792ae8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1447,7 +1447,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 	 *	itself.
 	 */
 	if (scmd_id(scsicmd) != host->this_id) {
-		if ((sdev_channel(scsicmd->device) == 0) ){
+		if ((scmd_channel(scsicmd) == 0) ){
 			if( (scmd_id(scsicmd) >= dev->maximum_num_containers) || (!scsilun_zero(&scsicmd->device->lun))){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
 				scsicmd->scsi_done(scsicmd);
@@ -1931,7 +1931,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(sdev_channel(scsicmd->device) == 2)) {
+					(scmd_channel(scsicmd) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
@@ -1975,7 +1975,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(sdev_channel(scsicmd->device) == 2)) {
+					(scmd_channel(scsicmd) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
@@ -2128,7 +2128,7 @@ static int aac_send_srb_fib(struct scsi_
 
 	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(sdev_channel(scsicmd->device)));
+	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scmd_channel(scsicmd)));
 	srbcmd->id   = cpu_to_le32(scmd_id(scsicmd));
 	srbcmd->lun      = cpu_to_le32(scsilun_to_int(&scsicmd->device->lun));
 	srbcmd->flags    = cpu_to_le32(flag);
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 233af25..70ca02a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -683,7 +683,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		       ahd_name(ahd), cmd);
 #endif
 	ahd_lock(ahd, &s);
-	found = ahd_reset_channel(ahd, sdev_channel(cmd->device) + 'A',
+	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_unlock(ahd, &s);
 
@@ -2113,7 +2113,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
 		  	if (ahd_match_scb(ahd, pending_scb,
 					  scmd_id(cmd),
-					  sdev_channel(cmd->device) + 'A',
+					  scmd_channel(cmd) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2158,7 +2158,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	if (flag == SCB_ABORT) {
 		if (ahd_search_qinfifo(ahd,
 				       scmd_id(cmd),
-				       sdev_channel(cmd->device) + 'A',
+				       scmd_channel(cmd) + 'A',
 				       scsilun_to_int(&cmd->device->lun), 
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
@@ -2170,7 +2170,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		}
 	} else if (ahd_search_qinfifo(ahd,
 				      scmd_id(cmd),
-				      sdev_channel(cmd->device) + 'A',
+				      scmd_channel(cmd) + 'A',
 				      scsilun_to_int(&cmd->device->lun),
 				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
@@ -2268,7 +2268,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		 */
 		ahd_search_qinfifo(ahd,
 				   scmd_id(cmd),
-				   sdev_channel(cmd->device) + 'A',
+				   scmd_channel(cmd) + 'A',
 				   scsilun_to_int(&cmd->device->lun),
 				   SCB_LIST_NULL, ROLE_INITIATOR,
 				   CAM_REQUEUE_REQ, SEARCH_COMPLETE);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d9fb5a4..120fc48 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -757,7 +757,7 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	ahc_lock(ahc, &flags);
-	found = ahc_reset_channel(ahc, sdev_channel(cmd->device) + 'A',
+	found = ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
 	ahc_unlock(ahc, &flags);
 
@@ -797,8 +797,8 @@ struct scsi_host_template aic7xxx_driver
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahc, cmd)						    \
 	(((scmd_id(cmd) << TID_SHIFT) & TID)			    \
-	| ((sdev_channel((cmd)->device) == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| ((sdev_channel((cmd)->device) == 0) ? 0 : TWIN_CHNLB))
+	| ((scmd_channel(cmd) == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
+	| ((scmd_channel(cmd) == 0) ? 0 : TWIN_CHNLB))
 
 /******************************** Bus DMA *************************************/
 int
@@ -1439,7 +1439,7 @@ ahc_linux_run_command(struct ahc_softc *
 	    && (ahc->features & AHC_SCB_BTT) == 0) {
 		int target_offset;
 
-		target_offset = scmd_id(cmd) + sdev_channel(cmd->device) * 8;
+		target_offset = scmd_id(cmd) + scmd_channel(cmd) * 8;
 		untagged_q = &(ahc->untagged_queues[target_offset]);
 		if (!TAILQ_EMPTY(untagged_q))
 			/* if we're already executing an untagged command
@@ -2150,7 +2150,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, scmd_id(cmd),
-				       sdev_channel(cmd->device) + 'A',
+				       scmd_channel(cmd) + 'A',
 				       scsilun_to_int(&cmd->device->lun),
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
 		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
@@ -2172,7 +2172,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		/* Any SCB for this device will do for a target reset */
 		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
 		  	if (ahc_match_scb(ahc, pending_scb, scmd_id(cmd),
-					  sdev_channel(cmd->device) + 'A',
+					  scmd_channel(cmd) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2215,7 +2215,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	disconnected = TRUE;
 	if (flag == SCB_ABORT) {
 		if (ahc_search_qinfifo(ahc, scmd_id(cmd),
-				       sdev_channel(cmd->device) + 'A',
+				       scmd_channel(cmd) + 'A',
 				       scsilun_to_int(&cmd->device->lun),
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
@@ -2226,7 +2226,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 			goto done;
 		}
 	} else if (ahc_search_qinfifo(ahc, scmd_id(cmd),
-				      sdev_channel(cmd->device) + 'A',
+				      scmd_channel(cmd) + 'A',
 				      scsilun_to_int(&cmd->device->lun),
 				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
@@ -2303,7 +2303,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * both the qinfifo and the disconnected list.
 		 */
 		ahc_search_disc_list(ahc, scmd_id(cmd),
-				     sdev_channel(cmd->device) + 'A',
+				     scmd_channel(cmd) + 'A',
 				     scsilun_to_int(&cmd->device->lun),
 				     pending_scb->hscb->tag,
 				     /*stop_on_first*/TRUE,
@@ -2329,7 +2329,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * to run.
 		 */
 		ahc_search_qinfifo(ahc, scmd_id(cmd),
-				   sdev_channel(cmd->device) + 'A',
+				   scmd_channel(cmd) + 'A',
 				   scsilun_to_int(&cmd->device->lun),
 				   SCB_LIST_NULL,
 				   ROLE_INITIATOR, CAM_REQUEUE_REQ,
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index e695daf..5d6e234 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -1035,12 +1035,12 @@ static struct aic7xxx_syncrate {
                         (((scb->hscb)->target_channel_lun >> 4) & 0xf), \
                         ((scb->hscb)->target_channel_lun & 0x07)
 
-#define CTL_OF_CMD(cmd) ((sdev_channel(cmd->device)) & 0x01),  \
+#define CTL_OF_CMD(cmd) ((scmd_channel(cmd)) & 0x01),  \
                         (scmd_id(cmd) & 0x0f), \
                         ((scsilun_to_int(&cmd->device->lun)) & 0x07)
 
 #define TARGET_INDEX(cmd) \
-	(scmd_id(cmd) | (sdev_channel((cmd)->device) << 3))
+	(scmd_id(cmd) | (scmd_channel(cmd) << 3))
 
 /*
  * A nice little define to make doing our printks a little easier
@@ -4936,7 +4936,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
   struct aic_dev_data *aic_dev;
 
   target = scmd_id(scb->cmd);
-  channel = sdev_channel(scb->cmd->device);
+  channel = scmd_channel(scb->cmd);
   lun = &scb->cmd->device->lun;
   reply = reject = done = FALSE;
   tindex = TARGET_INDEX(scb->cmd);
@@ -6029,14 +6029,14 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
       sd = aic_dev->SDptr;
       aic_dev->needppr = aic_dev->needppr_copy = 0;
       aic7xxx_set_width(p, scmd_id(scb->cmd),
-      			sdev_channel(scb->cmd->device),
+      			scmd_channel(scb->cmd),
       			&scb->cmd->device->lun,
                         MSG_EXT_WDTR_BUS_8_BIT,
                         (AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE),
 			aic_dev);
       aic7xxx_set_syncrate(p, NULL,
       			   scmd_id(scb->cmd),
-			   sdev_channel(scb->cmd->device), 0, 0,
+			   scmd_channel(scb->cmd), 0, 0,
                            0, AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
 			   aic_dev);
       aic_dev->goal.options = 0;
@@ -6315,7 +6315,7 @@ aic7xxx_handle_command_completion_intr(s
       }
       aic7xxx_reset_device(p,
         scmd_id(scb->cmd),
-	sdev_channel(scb->cmd->device),
+	scmd_channel(scb->cmd),
         &scb->cmd->device->lun, scb->hscb->tag);
       scb->flags &= ~(SCB_QUEUED_FOR_DONE | SCB_RESET | SCB_ABORT |
         SCB_QUEUED_ABORT);
@@ -10207,7 +10207,7 @@ aic7xxx_buildscb(struct aic7xxx_host *p,
     scb->flags |= SCB_DTR_SCB;
   }
   hscb->target_channel_lun = ((scmd_id(cmd) << 4) & 0xF0) |
-        ((sdev_channel(cmd->device) & 0x01) << 3) |
+        ((scmd_channel(cmd) & 0x01) << 3) |
 	(scsilun_to_int(&cmd->device->lun) & 0x07);
 
   /*
@@ -10447,7 +10447,7 @@ __aic7xxx_bus_device_reset(Scsi_Cmnd *cm
          aic_inb(p, STCNT));
   }
 
-  channel = sdev_channel(cmd->device);
+  channel = scmd_channel(cmd);
 
     /*
      * Send a Device Reset Message:
@@ -10514,7 +10514,7 @@ __aic7xxx_bus_device_reset(Scsi_Cmnd *cm
    * Check to see if the command is on the qinfifo.  If it is, then we will
    * not need to queue the command again since the card should start it soon
    */
-  if (aic7xxx_search_qinfifo(p, sdev_channel(cmd->device),
+  if (aic7xxx_search_qinfifo(p, scmd_channel(cmd),
   			scmd_id(cmd), &cmd->device->lun, hscb->tag,
 			  0, TRUE, NULL) == 0)
   {
@@ -10683,7 +10683,7 @@ __aic7xxx_abort(Scsi_Cmnd *cmd)
  *  We just checked the waiting_q, now for the QINFIFO
  */
   if ( ((found = aic7xxx_search_qinfifo(p, scmd_id(cmd),
-  			sdev_channel(cmd->device),
+  			scmd_channel(cmd),
                      	&cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
                      FALSE, NULL)) != 0) &&
                     (aic7xxx_verbose & VERBOSE_ABORT_PROCESS))
@@ -10907,10 +10907,10 @@ aic7xxx_reset(Scsi_Cmnd *cmd)
  *  By this point, we want to already know what we are going to do and
  *  only have the following code implement our course of action.
  */
-  aic7xxx_reset_channel(p, sdev_channel(cmd->device), TRUE);
+  aic7xxx_reset_channel(p, scmd_channel(cmd), TRUE);
   if (p->features & AHC_TWIN)
   {
-    aic7xxx_reset_channel(p, sdev_channel(cmd->device) ^ 0x01, TRUE);
+    aic7xxx_reset_channel(p, scmd_channel(cmd) ^ 0x01, TRUE);
     restart_sequencer(p);
   }
   aic_outb(p,  aic_inb(p, SIMODE1) & ~(ENREQINIT|ENBUSFREE), SIMODE1);
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 04a8ff7..adc4aad 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -622,10 +622,10 @@ static int atp870u_queuecommand(struct s
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
 
-	c = sdev_channel(req_p->device);
+	c = scmd_channel(req_p);
 	req_p->sense_buffer[0]=0;
 	req_p->resid = 0;
-	if (sdev_channel(req_p->device) > 1) {
+	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
 		done(req_p);
 #ifdef ED_DBGP		
@@ -3109,7 +3109,7 @@ static int atp870u_abort(struct scsi_cmn
 	host = SCpnt->device->host;
 
 	dev = (struct atp_unit *)&host->hostdata;
-	c = sdev_channel(SCpnt->device);
+	c = scmd_channel(SCpnt);
 	printk(" atp870u: abort Channel = %x \n", c);
 	printk("working=%x last_cmd=%x ", dev->working[c], dev->last_cmd[c]);
 	printk(" quhdu=%x quendu=%x ", dev->quhd[c], dev->quend[c]);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 346d28d..484e221 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -426,7 +426,7 @@ static int adpt_queue(struct scsi_cmnd *
 		 * command from scan_scsis_single.
 		 */
 		if ((pDev = adpt_find_device(pHba,
-			sdev_channel(cmd->device),
+			scmd_channel(cmd),
 			scmd_id(cmd),
 			scsilun_to_int(&cmd->device->lun))) == NULL) {
 			// TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response 
@@ -728,9 +728,9 @@ static int adpt_bus_reset(struct scsi_cm
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	memset(msg, 0, sizeof(msg));
 	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
-		"Bus reset: tid: %d\n", pHba->channel[sdev_channel(cmd->device)].tid );
+		"Bus reset: tid: %d\n", pHba->channel[scmd_channel(cmd)].tid );
 	msg[0] = FOUR_WORD_MSG_SIZE|SGL_OFFSET_0;
-	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[sdev_channel(cmd->device)].tid);
+	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[scmd_channel(cmd)].tid);
 	msg[2] = 0;
 	msg[3] = 0;
 	if(adpt_i2o_post_wait(pHba, msg,sizeof(msg), FOREVER) ){
@@ -749,7 +749,7 @@ static int __adpt_reset(struct scsi_cmnd
 	int rcode;
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
-		"Hba Reset: tid: %d\n", pHba->channel[sdev_channel(cmd->device)].tid );
+		"Hba Reset: tid: %d\n", pHba->channel[scmd_channel(cmd)].tid );
 	rcode =  adpt_hba_reset(pHba);
 	if(rcode == 0){
 		printk(KERN_WARNING"%s: HBA reset complete\n",pHba->name);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 1cad8a2..430133b 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1822,7 +1822,7 @@ static int eata2x_queuecommand(struct sc
 		cpp->hbaci = 1;
 #endif
 	cpp->one = 1;
-	cpp->channel = sdev_channel(SCpnt->device);
+	cpp->channel = scmd_channel(SCpnt);
 	cpp->target = scmd_id(SCpnt);
 	cpp->lun = scsilun_to_int(&SCpnt->device->lun);
 	cpp->SCpnt = SCpnt;
@@ -2445,7 +2445,7 @@ static irqreturn_t ihdlr(int irq, struct
 
 		/* If there was a bus reset, redo operation on each target */
 		else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-			 && ha->target_redo[scmd_id(SCpnt)][sdev_channel(SCpnt->device)])
+			 && ha->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)])
 			status = DID_BUS_BUSY << 16;
 
 		/* Works around a flaw in scsi.c */
@@ -2458,7 +2458,7 @@ static irqreturn_t ihdlr(int irq, struct
 			status = DID_OK << 16;
 
 		if (tstatus == GOOD)
-			ha->target_redo[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] = 0;
+			ha->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
@@ -2469,7 +2469,7 @@ static irqreturn_t ihdlr(int irq, struct
 			       SCpnt->pid,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
-		ha->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] = 0;
+		ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
 		if (ha->last_retried_pid == SCpnt->pid)
 			ha->retries = 0;
@@ -2478,11 +2478,11 @@ static irqreturn_t ihdlr(int irq, struct
 	case ASST:		/* Selection Time Out */
 	case 0x02:		/* Command Time Out   */
 
-		if (ha->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] > 1)
+		if (ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] > 1)
 			status = DID_ERROR << 16;
 		else {
 			status = DID_TIME_OUT << 16;
-			ha->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)]++;
+			ha->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)]++;
 		}
 
 		break;
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7524af9..c6e0c54 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2248,7 +2248,7 @@ static void gdth_putq(int hanum,Scsi_Cmn
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     scp->SCp.this_residual = (int)priority;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
     t = scmd_id(scp);
     if (priority >= DEFAULT_PRI) {
         if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
@@ -2308,7 +2308,7 @@ static void gdth_next(int hanum)
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : sdev_channel(nscp->device);
+        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : scmd_channel(nscp);
         t = scmd_id(nscp);
         l = scsilun_to_int(&nscp->device->lun);
         if (nscp->SCp.this_residual >= DEFAULT_PRI) {
@@ -3620,7 +3620,7 @@ static int gdth_sync_event(int hanum,int
         printk("\n");
 
     } else {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
         t = scmd_id(scp);
         if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
             ha->raw[BUS_L2P(ha,b)].io_cnt[t]--;
@@ -4712,14 +4712,14 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
     TRACE2(("gdth_eh_bus_reset()\n"));
 
     hanum = NUMDATA(scp->device->host)->hanum;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
     ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         cmnd = ha->cmd_tab[i].cmnd;
-        if (!SPECIAL_SCP(cmnd) && sdev_channel(cmnd->device) == b)
+        if (!SPECIAL_SCP(cmnd) && scmd_channel(cmnd) == b)
             ha->cmd_tab[i].cmnd = UNUSED_CMND;
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index a5a317f..dc8863b 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -951,7 +951,7 @@ static void gdth_wait_completion(int han
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
 
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
         t = scmd_id(scp);
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
@@ -976,7 +976,7 @@ static void gdth_stop_timeout(int hanum,
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
         t = scmd_id(scp);
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
@@ -997,7 +997,7 @@ static void gdth_start_timeout(int hanum
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scmd_channel(scp);
         t = scmd_id(scp);
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_start_timeout(): update_timeout()\n"));
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fdfbbeb..3027d9f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3762,7 +3762,7 @@ static void ipr_erp_start(struct ipr_ioa
 		 */
 		if (!res->resetting_device)
 			scsi_report_bus_reset(ioa_cfg->host,
-					      sdev_channel(scsi_cmd->device));
+					      scmd_channel(scsi_cmd));
 		scsi_cmd->result |= (DID_ERROR << 16);
 		res->needs_sync_complete = 1;
 		break;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index c752b6e..be6b13a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1125,8 +1125,8 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 		  SC->device->channel, SC->device->id, SC->device->lun);
 
 	/* Check for command to initiator IDs */
-	if ((sdev_channel(SC->device) > 0)
-	    && (scmd_id(SC) == ha->ha_id[sdev_channel(SC->device)])) {
+	if ((scmd_channel(SC) > 0)
+	    && (scmd_id(SC) == ha->ha_id[scmd_channel(SC)])) {
 		SC->result = DID_NO_CONNECT << 16;
 		done(SC);
 
@@ -1611,7 +1611,7 @@ ips_is_passthru(Scsi_Cmnd * SC)
 		return (0);
 
 	if ((SC->cmnd[0] == IPS_IOCTL_COMMAND) &&
-	    (sdev_channel(SC->device) == 0) &&
+	    (scmd_channel(SC) == 0) &&
 	    (scmd_id(SC) == IPS_ADAPTER_ID) &&
 	    (scsilun_zero(&SC->device->lun) == 0) && SC->request_buffer) {
 		if ((!SC->use_sg) && SC->request_bufflen &&
@@ -1969,7 +1969,7 @@ ips_flash_firmware(ips_ha_t * ha, ips_pa
 	/* FIX stuff that might be wrong */
 	scb->sg_list.list = sg_list.list;
 	scb->scb_busaddr = cmd_busaddr;
-	scb->bus = sdev_channel(scb->scsi_cmd->device);
+	scb->bus = scmd_channel(scb->scsi_cmd);
 	scb->target_id = scmd_id(scb->scsi_cmd);
 	scb->lun = scsilun_to_int(&scb->scsi_cmd->device->lun);
 	scb->sg_len = 0;
@@ -2038,7 +2038,7 @@ ips_usrcmd(ips_ha_t * ha, ips_passthru_t
 	/* FIX stuff that might be wrong */
 	scb->sg_list.list = sg_list.list;
 	scb->scb_busaddr = cmd_busaddr;
-	scb->bus = sdev_channel(scb->scsi_cmd->device);
+	scb->bus = scmd_channel(scb->scsi_cmd);
 	scb->target_id = scmd_id(scb->scsi_cmd);
 	scb->lun = scsilun_to_int(&scb->scsi_cmd->device->lun);
 	scb->sg_len = 0;
@@ -2830,9 +2830,9 @@ ips_next(ips_ha_t * ha, int intr)
 
 	p = ha->scb_waitlist.head;
 	while ((p) && (scb = ips_getscb(ha))) {
-		if ((sdev_channel(p->device) > 0)
+		if ((scmd_channel(p) > 0)
 		    && (ha->
-			dcdb_active[sdev_channel(p->device) -
+			dcdb_active[scmd_channel(p) -
 				    1] & (1 << scmd_id(p)))) {
 			ips_freescb(ha, scb);
 			p = (Scsi_Cmnd *) p->host_scribble;
@@ -2852,7 +2852,7 @@ ips_next(ips_ha_t * ha, int intr)
 
 		scb->target_id = scmd_id(SC);
 		scb->lun = scsilun_to_int(&SC->device->lun);
-		scb->bus = sdev_channel(SC->device);
+		scb->bus = scmd_channel(SC);
 		scb->scsi_cmd = SC;
 		scb->breakup = 0;
 		scb->data_len = 0;
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 81ce0c9..0aecc7b 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -199,7 +199,7 @@ typedef struct {
 // conversion from scsi command
 #define SCP2HOST(scp)			(scp)->device->host	// to host
 #define SCP2HOSTDATA(scp)		SCP2HOST(scp)->hostdata	// to soft state
-#define SCP2CHANNEL(scp)		sdev_channel((scp)->device) // to channel
+#define SCP2CHANNEL(scp)		scmd_channel(scp) // to channel
 #define SCP2TARGET(scp)			scmd_id(scp)	// to target
 #define SCP2LUN(scp)			scsilun_to_int(&(scp)->device->lun) // to LUN
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 0a8f227..3b5cf42 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1059,7 +1059,7 @@ struct megasas_instance {
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
-	(sdev_channel(scp->device) < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	(scmd_channel(scp) < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
 
 #define MEGASAS_DEV_INDEX(inst, scp)					\
 	((scmd_channel(scp) % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + \
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c829446..fe9623d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -617,7 +617,7 @@ __setup("qla1280=", qla1280_setup);
 #endif
 
 #define CMD_HOST(Cmnd)		Cmnd->device->host
-#define SCSI_BUS_32(Cmnd)	sdev_channel(Cmnd->device)
+#define SCSI_BUS_32(Cmnd)	scmd_channel(Cmnd)
 #define SCSI_TCN_32(Cmnd)	scmd_id(Cmnd)
 #define SCSI_LUN_32(Cmnd)	scsilun_to_int(&Cmnd->device->lun)
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 59e0f38..31602d0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1037,7 +1037,7 @@ static int scsi_try_bus_reset(struct scs
 			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host,
-				      sdev_channel(scmd->device));
+				      scmd_channel(scmd));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1066,7 +1066,7 @@ static int scsi_try_host_reset(struct sc
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host,
-				      sdev_channel(scmd->device));
+				      scmd_channel(scmd));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1096,7 +1096,7 @@ static int scsi_eh_bus_reset(struct Scsi
 	for (channel = 0; channel <= shost->max_channel; channel++) {
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (channel == sdev_channel(scmd->device)) {
+			if (channel == scmd_channel(scmd)) {
 				chan_scmd = scmd;
 				break;
 				/*
@@ -1114,7 +1114,7 @@ static int scsi_eh_bus_reset(struct Scsi
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (channel == sdev_channel(scmd->device))
+				if (channel == scmd_channel(scmd))
 					if (!scsi_device_online(scmd->device) ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9af8bbf..0287861 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -887,7 +887,7 @@ sg_ioctl(struct inode *inode, struct fil
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
-			__put_user((int) sdev_channel(sdp->device),
+			__put_user((int) scmd_channel(sdp),
 				   &sg_idp->channel);
 			__put_user((int) scmd_id(sdp), &sg_idp->scsi_id);
 			__put_user((int) tmp_lun, &sg_idp->lun);
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 013e817..a3bff57 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1295,7 +1295,7 @@ static int u14_34f_queuecommand(struct s
 		"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
 
    cpp->opcode = OP_SCSI;
-   cpp->channel = sdev_channel(SCpnt->device);
+   cpp->channel = scmd_channel(SCpnt);
    cpp->target = scmd_id(SCpnt);
    cpp->lun = scsilun_to_int(&SCpnt->device->lun);
    cpp->SCpnt = SCpnt;
@@ -1823,7 +1823,7 @@ static irqreturn_t ihdlr(int irq, unsign
 
          /* If there was a bus reset, redo operation on each target */
          else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-                  && HD(j)->target_redo[scmd_id(SCpnt)][sdev_channel(SCpnt->device)])
+                  && HD(j)->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)])
             status = DID_BUS_BUSY << 16;
 
          /* Works around a flaw in scsi.c */
@@ -1836,7 +1836,7 @@ static irqreturn_t ihdlr(int irq, unsign
             status = DID_OK << 16;
 
          if (tstatus == GOOD)
-            HD(j)->target_redo[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] = FALSE;
+            HD(j)->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)] = FALSE;
 
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
@@ -1846,18 +1846,18 @@ static irqreturn_t ihdlr(int irq, unsign
                    SCpnt->pid, spp->target_status,
                    SCpnt->sense_buffer[2]);
 
-         HD(j)->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] = 0;
+         HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
          if (HD(j)->last_retried_pid == SCpnt->pid) HD(j)->retries = 0;
 
          break;
       case ASST:     /* Selection Time Out */
 
-         if (HD(j)->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)] > 1)
+         if (HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] > 1)
             status = DID_ERROR << 16;
          else {
             status = DID_TIME_OUT << 16;
-            HD(j)->target_to[scmd_id(SCpnt)][sdev_channel(SCpnt->device)]++;
+            HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)]++;
             }
 
          break;
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 8b937ae..f3c1af6 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -593,12 +593,12 @@ int mts_scsi_queuecommand( Scsi_Cmnd *sr
 
 	if ( !scsilun_zero(&srb->device->lun) ||
 	     scmd_id(srb) ||
-	     sdev_channel(srb->device) ) {
+	     scmd_channel(srb) ) {
 
 		MTS_DEBUG("Command to LUN=%s ID=%d CHANNEL=%d from SCSI layer\n",
 			scsilun_to_str(&srb->device->lun, lunstr),
 			scmd_id(srb),
-			sdev_channel(srb->device) );
+			scmd_channel(srb) );
 
 		MTS_DEBUG("this device doesn't exist\n");
 
