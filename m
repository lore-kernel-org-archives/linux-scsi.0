From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Fri,  4 Jul 2014 13:54:34 +0200
Message-ID: <1404474875-109997-2-git-send-email-hare@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaGDLyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 07:54:40 -0400
In-Reply-To: <1404474875-109997-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

SCSI-2 defines only up to 256 LUNs with a flat namespace.
This patch introduces an accessor 'sdev_scsi2lun' which should be
used for these drivers to avoid problems when using 64-bit LUNs
internally.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 arch/ia64/hp/sim/simscsi.c          |  2 +-
 drivers/scsi/53c700.c               | 12 +++---
 drivers/scsi/BusLogic.c             |  2 +-
 drivers/scsi/NCR5380.c              | 32 +++++++-------
 drivers/scsi/NCR53c406a.c           |  2 +-
 drivers/scsi/a100u2w.c              |  4 +-
 drivers/scsi/advansys.c             | 16 +++----
 drivers/scsi/aha152x.c              | 13 +++---
 drivers/scsi/aha1542.c              |  4 +-
 drivers/scsi/aha1740.c              |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c  | 19 ++++----
 drivers/scsi/aic7xxx/aic79xx_proc.c |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 23 +++++-----
 drivers/scsi/aic7xxx/aic7xxx_proc.c |  2 +-
 drivers/scsi/arm/acornscsi.c        | 20 +++++----
 drivers/scsi/arm/fas216.c           | 15 ++++---
 drivers/scsi/arm/queue.c            |  8 ++--
 drivers/scsi/atari_NCR5380.c        | 81 ++++++++++++++++++----------------
 drivers/scsi/atp870u.c              |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c     |  4 +-
 drivers/scsi/ch.c                   | 16 +++----
 drivers/scsi/dc395x.c               | 73 +++++++++++++++----------------
 drivers/scsi/eata.c                 |  4 +-
 drivers/scsi/eata_pio.c             |  2 +-
 drivers/scsi/esp_scsi.c             |  6 +--
 drivers/scsi/g_NCR5380.c            |  2 +-
 drivers/scsi/gdth.c                 |  4 +-
 drivers/scsi/hptiop.c               |  6 +--
 drivers/scsi/in2000.c               | 36 +++++++++-------
 drivers/scsi/initio.c               |  4 +-
 drivers/scsi/megaraid.c             | 10 ++---
 drivers/scsi/mesh.c                 |  6 +--
 drivers/scsi/mvumi.c                |  2 +-
 drivers/scsi/ncr53c8xx.c            | 33 +++++++-------
 drivers/scsi/nsp32.c                | 14 +++---
 drivers/scsi/ps3rom.c               |  2 +-
 drivers/scsi/qlogicpti.c            |  6 +--
 drivers/scsi/scsi.c                 |  2 +-
 drivers/scsi/stex.c                 |  2 +-
 drivers/scsi/sun3_NCR5380.c         | 86 +++++++++++++++++++++----------------
 drivers/scsi/sym53c8xx_2/sym_glue.c | 19 ++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 10 ++---
 drivers/scsi/tmscsim.c              | 12 ++++--
 drivers/scsi/u14-34f.c              |  6 +--
 drivers/scsi/ufs/ufshcd.c           |  4 +-
 drivers/scsi/ultrastor.c            |  2 +-
 drivers/scsi/wd33c93.c              | 35 ++++++++-------
 drivers/scsi/wd7000.c               |  3 +-
 drivers/staging/rts5208/rtsx.c      |  4 +-
 include/scsi/scsi_device.h          |  5 +++
 50 files changed, 366 insertions(+), 315 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 3a428f1..3abd6fa 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -219,7 +219,7 @@ simscsi_queuecommand_lck (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *)
 
 	sc->result = DID_BAD_TARGET << 16;
 	sc->scsi_done = done;
-	if (target_id <= 15 && sc->device->lun == 0) {
+	if (target_id <= 15 && sdev_scsi2lun(sc->device) == 0) {
 		switch (sc->cmnd[0]) {
 		      case INQUIRY:
 			if (scsi_bufflen(sc) < 35) {
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a3adfb4..d91811d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -792,7 +792,7 @@ process_extended_message(struct Scsi_Host *host,
 
 	if(SCp != NULL) {
 		pun = SCp->device->id;
-		lun = SCp->device->lun;
+		lun = sdev_scsi2lun(SCp->device);
 	}
 
 	switch(hostdata->msgin[2]) {
@@ -875,7 +875,7 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 
 	if(SCp != NULL) {
 		pun = SCp->device->id;
-		lun = SCp->device->lun;
+		lun = sdev_scsi2lun(SCp->device);
 	}
 
 #ifdef NCR_700_DEBUG
@@ -962,7 +962,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 
 	if(SCp != NULL) {
 		pun = SCp->device->id;
-		lun = SCp->device->lun;
+		lun = sdev_scsi2lun(SCp->device);
 	}
 
 	if(dsps == A_GOOD_STATUS_AFTER_STATUS) {
@@ -1005,7 +1005,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 						 DMA_TO_DEVICE);
 
 				cmnd[0] = REQUEST_SENSE;
-				cmnd[1] = (SCp->device->lun & 0x7) << 5;
+				cmnd[1] = sdev_scsi2lun(SCp->device) << 5;
 				cmnd[2] = 0;
 				cmnd[3] = 0;
 				cmnd[4] = SCSI_SENSE_BUFFERSIZE;
@@ -1415,7 +1415,7 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 
 	hostdata->msgout[0] = NCR_700_identify((SCp->cmnd[0] != REQUEST_SENSE &&
 						slot->flags != NCR_700_FLAG_AUTOSENSE),
-					       SCp->device->lun);
+					       sdev_scsi2lun(SCp->device));
 	/* for INQUIRY or REQUEST_SENSE commands, we cannot be sure
 	 * if the negotiated transfer parameters still hold, so
 	 * always renegotiate them */
@@ -1528,7 +1528,7 @@ NCR_700_intr(int irq, void *dev_id)
 
 		if(SCp != NULL) {
 			pun = SCp->device->id;
-			lun = SCp->device->lun;
+			lun = sdev_scsi2lun(SCp->device);
 		}
 
 		if(sstat0 & SCSI_RESET_DETECTED) {
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 972f817..6dd99b6 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3032,7 +3032,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 	unsigned char *cdb = command->cmnd;
 	int cdblen = command->cmd_len;
 	int tgt_id = command->device->id;
-	int lun = command->device->lun;
+	int lun = sdev_scsi2lun(command->device);
 	int buflen = scsi_bufflen(command);
 	int count;
 	struct blogic_ccb *ccb;
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2893d6a..4e5440d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -762,7 +762,7 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 
 static void lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, struct seq_file *m)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, (u8)cmd->device->lun);
+	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
 	SPRINTF("        command = ");
 	lprint_command(cmd->cmnd, m);
 }
@@ -1039,9 +1039,9 @@ static void NCR5380_main(struct work_struct *work)
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], (u8)tmp->device->lun);
+					dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], sdev_scsi2lun(tmp->device));
 				/*  When we find one, remove it from the issue queue. */
-				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
+				if (!(hostdata->busy[tmp->device->id] & (1 << sdev_scsi2lun(tmp->device)))) {
 					if (prev) {
 						REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
 						prev->host_scribble = tmp->host_scribble;
@@ -1057,7 +1057,7 @@ static void NCR5380_main(struct work_struct *work)
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, (u8)tmp->device->lun);
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, sdev_scsi2lun(tmp->device));
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -1512,7 +1512,7 @@ part2:
 	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
-	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
+	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), sdev_scsi2lun(cmd->device));
 
 	len = 1;
 	cmd->tag = 0;
@@ -1524,7 +1524,7 @@ part2:
 	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
-	hostdata->busy[cmd->device->id] |= (1 << (cmd->device->lun & 0xFF));
+	hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 
 	initialize_SCp(cmd);
 
@@ -2210,14 +2210,14 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
 					 * available.
 					 */
 					if (!cmd->next_link) {
-					    printk("scsi%d : target %d lun %d linked command complete, no next_link\n" instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+						printk("scsi%d : target %d lun %d linked command complete, no next_link\n" instance->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
 						sink = 1;
 						do_abort(instance);
 						return;
@@ -2226,7 +2226,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2238,8 +2238,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
-					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
+					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
+					hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 
 					/* 
 					 * I'm not sure what the correct thing to do here is : 
@@ -2304,7 +2304,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					case ORDERED_QUEUE_TAG:
 					case SIMPLE_QUEUE_TAG:
 						cmd->device->simple_tags = 0;
-						hostdata->busy[cmd->device->id] |= (1 << (cmd->device->lun & 0xFF));
+						hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 						break;
 					default:
 						break;
@@ -2318,7 +2318,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, sdev_scsi2lun(cmd->device));
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2426,7 +2426,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
+					hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
 					collect_stats(hostdata, cmd);
@@ -2562,7 +2562,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 
 
 		for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble)
-			if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)
+			if ((target_mask == (1 << tmp->device->id)) && (lun == sdev_scsi2lun(tmp->device))
 			    ) {
 				if (prev) {
 					REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
@@ -2588,7 +2588,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, (u8)tmp->device->lun, tmp->tag);
+		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, sdev_scsi2lun(tmp->device), tmp->tag);
 	}
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..1e44137 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -698,7 +698,7 @@ static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	int i;
 
 	VDEB(printk("NCR53c406a_queue called\n"));
-	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->target, SCpnt->lun, scsi_bufflen(SCpnt)));
+	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->device->target, sdev_scsi2lun(SCpnt->device), scsi_bufflen(SCpnt)));
 
 #if 0
 	VDEB(for (i = 0; i < SCpnt->cmd_len; i++)
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 0163457..fe0596b 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -855,7 +855,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 	scb->opcode = ORC_EXECSCSI;
 	scb->flags = SCF_NO_DCHK;	/* Clear done bit               */
 	scb->target = cmd->device->id;
-	scb->lun = cmd->device->lun;
+	scb->lun = sdev_scsi2lun(cmd->device);
 	scb->reserved0 = 0;
 	scb->reserved1 = 0;
 	scb->sg_len = cpu_to_le32(0);
@@ -891,7 +891,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 		printk("max cdb length= %x\b", cmd->cmd_len);
 		scb->cdb_len = IMAX_CDB;
 	}
-	scb->ident = cmd->device->lun | DISC_ALLOW;
+	scb->ident = sdev_scsi2lun(cmd->device) | DISC_ALLOW;
 	if (cmd->device->tagged_supported) {	/* Tag Support                  */
 		scb->tag_msg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
 	} else {
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e716d0a..11a8ec5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7688,7 +7688,7 @@ advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
 	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
 	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
 
-	if (sdev->lun == 0) {
+	if (sdev_scsi2lun(sdev) == 0) {
 		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
 		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
 			asc_dvc->init_sdtr |= tid_bit;
@@ -7702,7 +7702,7 @@ advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
 
 	if (sdev->tagged_supported) {
 		if (asc_dvc->cfg->cmd_qng_enabled & tid_bit) {
-			if (sdev->lun == 0) {
+			if (sdev_scsi2lun(sdev) == 0) {
 				asc_dvc->cfg->can_tagged_qng |= tid_bit;
 				asc_dvc->use_tagged_qng |= tid_bit;
 			}
@@ -7710,14 +7710,14 @@ advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
 						asc_dvc->max_dvc_qng[sdev->id]);
 		}
 	} else {
-		if (sdev->lun == 0) {
+		if (sdev_scsi2lun(sdev) == 0) {
 			asc_dvc->cfg->can_tagged_qng &= ~tid_bit;
 			asc_dvc->use_tagged_qng &= ~tid_bit;
 		}
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
 
-	if ((sdev->lun == 0) &&
+	if ((sdev_scsi2lun(sdev) == 0) &&
 	    (orig_use_tagged_qng != asc_dvc->use_tagged_qng)) {
 		AscWriteLramByte(asc_dvc->iop_base, ASCV_DISC_ENABLE_B,
 				 asc_dvc->cfg->disc_enable);
@@ -7815,7 +7815,7 @@ advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
 	AdvPortAddr iop_base = adv_dvc->iop_base;
 	unsigned short tidmask = 1 << sdev->id;
 
-	if (sdev->lun == 0) {
+	if (sdev_scsi2lun(sdev) == 0) {
 		/*
 		 * Handle WDTR, SDTR, and Tag Queuing. If the feature
 		 * is enabled in the EEPROM and the device supports the
@@ -7907,9 +7907,9 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	asc_scsi_q->cdbptr = &scp->cmnd[0];
 	asc_scsi_q->q2.cdb_len = scp->cmd_len;
 	asc_scsi_q->q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
-	asc_scsi_q->q1.target_lun = scp->device->lun;
+	asc_scsi_q->q1.target_lun = sdev_scsi2lun(scp->device);
 	asc_scsi_q->q2.target_ix =
-	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
+		ASC_TIDLUN_TO_IX(scp->device->id, sdev_scsi2lun(scp->device));
 	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
 	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
 
@@ -8167,7 +8167,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	}
 
 	scsiqp->target_id = scp->device->id;
-	scsiqp->target_lun = scp->device->lun;
+	scsiqp->target_lun = sdev_scsi2lun(scp->device);
 
 	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
 	scsiqp->sense_len = SCSI_SENSE_BUFFERSIZE;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e77b72f..b08fa37 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -321,7 +321,7 @@ static LIST_HEAD(aha152x_host_list);
 #define CMDINFO(cmd) \
 			(cmd) ? ((cmd)->device->host->host_no) : -1, \
                         (cmd) ? ((cmd)->device->id & 0x0f) : -1, \
-			(cmd) ? ((u8)(cmd)->device->lun & 0x07) : -1
+			(cmd) ? (sdev_scsi2lun((cmd)->device)) : -1
 
 static inline void
 CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
@@ -730,7 +730,8 @@ static inline Scsi_Cmnd *remove_lun_SC(Scsi_Cmnd ** SC, int target, int lun)
 	Scsi_Cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
-	     ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
+	     ptr && ((ptr->device->id != target) ||
+		     sdev_scsi2lun(ptr->device) != lun));
 	     prev = ptr, ptr = SCNEXT(ptr))
 	     ;
 
@@ -1602,7 +1603,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #if defined(AHA152X_DEBUG)
 			int hostno=DONE_SC->device->host->host_no;
 			int id=DONE_SC->device->id & 0xf;
-			int lun=((u8)DONE_SC->device->lun) & 0x7;
+			int lun=(sdev_scsi2lun(DONE_SC->device)) & 0x7;
 #endif
 			Scsi_Cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
@@ -1686,7 +1687,7 @@ static void seldo_run(struct Scsi_Host *shpnt)
 
 	SETPORT(SSTAT0, CLRSELDO);
 	
-	ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
+	ADDMSGO(IDENTIFY(RECONNECT, sdev_scsi2lun(CURRENT_SC->device)));
 
 	if (CURRENT_SC->SCp.phase & aborting) {
 		ADDMSGO(ABORT);
@@ -2001,7 +2002,7 @@ static void msgo_init(struct Scsi_Host *shpnt)
 {
 	if(MSGOLEN==0) {
 		if((CURRENT_SC->SCp.phase & syncneg) && SYNCNEG==2 && SYNCRATE==0) {
-			ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
+			ADDMSGO(IDENTIFY(RECONNECT, sdev_scsi2lun(CURRENT_SC->device)));
 		} else {
 			printk(INFO_LEAD "unexpected MESSAGE OUT phase; rejecting\n", CMDINFO(CURRENT_SC));
 			ADDMSGO(MESSAGE_REJECT);
@@ -2984,7 +2985,7 @@ static void get_command(struct seq_file *m, Scsi_Cmnd * ptr)
 	int i;
 
 	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
-		ptr, ptr->device->id, (u8)ptr->device->lun);
+		ptr, ptr->device->id, sdev_scsi2lun(ptr->device));
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 770c48d..ae2bf2b 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -561,7 +561,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
 	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	unchar lun = sdev_scsi2lun(SCpnt->device);
 	unsigned long flags;
 	int bufflen = scsi_bufflen(SCpnt);
 	int mbo;
@@ -1228,7 +1228,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	unsigned long flags;
 	struct mailbox *mb;
 	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	unchar lun = sdev_scsi2lun(SCpnt->device);
 	int mbo;
 	struct ccb *ccb;
 	unchar ahacmd = CMD_START_SCSI;
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5f31017..a1646b4 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -417,7 +417,7 @@ static int aha1740_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *)
 		host->ecb[ecbno].datalen = 0;
 		host->ecb[ecbno].dataptr = 0;
 	}
-	host->ecb[ecbno].lun = SCpnt->device->lun;
+	host->ecb[ecbno].lun = sdev_scsi2lun(SCpnt->device);
 	host->ecb[ecbno].ses = 1; /* Suppress underrun errors */
 	host->ecb[ecbno].dir = direction;
 	host->ecb[ecbno].ars = 1; /* Yes, get the sense on an error */
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index ed333669..5611d4d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -838,7 +838,7 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
 	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
-	reset_scb->hscb->lun = cmd->device->lun;
+	reset_scb->hscb->lun = sdev_scsi2lun(cmd->device);
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
 	reset_scb->flags |= SCB_DEVICE_RESET|SCB_RECOVERY_SCB|SCB_ACTIVE;
@@ -1537,7 +1537,7 @@ ahd_linux_device_queue_depth(struct scsi_device *sdev)
 
 	ahd_compile_devinfo(&devinfo,
 			    ahd->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id, sdev_scsi2lun(sdev),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	tags = ahd_linux_user_tagdepth(ahd, &devinfo);
@@ -1584,7 +1584,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 		col_idx = AHD_NEVER_COL_IDX;
 	} else {
 		col_idx = AHD_BUILD_COL_IDX(cmd->device->id,
-					    cmd->device->lun);
+					    sdev_scsi2lun(cmd->device));
 	}
 	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
 		ahd->flags |= AHD_RESOURCE_SHORTAGE;
@@ -1603,7 +1603,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	 */
 	hscb->control = 0;
 	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-	hscb->lun = cmd->device->lun;
+	hscb->lun = sdev_scsi2lun(cmd->device);
 	scb->hscb->task_management = 0;
 	mask = SCB_GET_TARGET_MASK(ahd, scb);
 
@@ -1900,7 +1900,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 
 	ahd_compile_devinfo(&devinfo,
 			    ahd->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id, sdev_scsi2lun(sdev),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	
@@ -2137,7 +2137,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 	if (do_fallback) {
 		printk("%s: device overrun (status %x) on %d:%d:%d\n",
 		       ahd_name(ahd), status, cmd->device->channel,
-		       cmd->device->id, (u8)cmd->device->lun);
+		       cmd->device->id, sdev_scsi2lun(cmd->device));
 	}
 
 	ahd_cmd_set_transaction_status(cmd, new_status);
@@ -2253,13 +2253,13 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	disconnected = TRUE;
 	if (ahd_search_qinfifo(ahd, cmd->device->id, 
 			       cmd->device->channel + 'A',
-			       cmd->device->lun,
+			       sdev_scsi2lun(cmd->device),
 			       pending_scb->hscb->tag,
 			       ROLE_INITIATOR, CAM_REQ_ABORTED,
 			       SEARCH_COMPLETE) > 0) {
 		printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 		       ahd_name(ahd), cmd->device->channel, 
-		       cmd->device->id, (u8)cmd->device->lun);
+		       cmd->device->id, sdev_scsi2lun(cmd->device));
 		retval = SUCCESS;
 		goto done;
 	}
@@ -2346,7 +2346,8 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 		 * to run.
 		 */
 		ahd_search_qinfifo(ahd, cmd->device->id,
-				   cmd->device->channel + 'A', cmd->device->lun,
+				   cmd->device->channel + 'A',
+				   sdev_scsi2lun(cmd->device),
 				   SCB_LIST_NULL, ROLE_INITIATOR,
 				   CAM_REQUEUE_REQ, SEARCH_COMPLETE);
 		ahd_qinfifo_requeue_tail(ahd, pending_scb);
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
index 27dbfcc..2e1f92e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -197,7 +197,7 @@ ahd_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 
 	seq_printf(m, "\tChannel %c Target %d Lun %d Settings\n",
 		  sdev->sdev_target->channel + 'A',
-		   sdev->sdev_target->id, (u8)sdev->lun);
+		   sdev->sdev_target->id, sdev_scsi2lun(sdev));
 
 	seq_printf(m, "\t\tCommands Queued %ld\n", dev->commands_issued);
 	seq_printf(m, "\t\tCommands Active %d\n", dev->active);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d2c9bf3..1232e69 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1404,7 +1404,7 @@ ahc_linux_device_queue_depth(struct scsi_device *sdev)
 	ahc_compile_devinfo(&devinfo,
 			    sdev->sdev_target->channel == 0
 			  ? ahc->our_id : ahc->our_id_b,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id, sdev_scsi2lun(sdev),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	tags = ahc_linux_user_tagdepth(ahc, &devinfo);
@@ -1482,7 +1482,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	 */
 	hscb->control = 0;
 	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
-	hscb->lun = cmd->device->lun;
+	hscb->lun = sdev_scsi2lun(cmd->device);
 	mask = SCB_GET_TARGET_MASK(ahc, scb);
 	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
 				    SCB_GET_OUR_ID(scb),
@@ -1830,7 +1830,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 
 	ahc_compile_devinfo(&devinfo,
 			    ahc->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id, sdev_scsi2lun(sdev),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	
@@ -2110,7 +2110,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 */
 		printk("%s:%d:%d:%d: Is not an active device\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       (u8)cmd->device->lun);
+		       sdev_scsi2lun(cmd->device));
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2118,11 +2118,11 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
 				       cmd->device->channel + 'A',
-				       (u8)cmd->device->lun,
+				       sdev_scsi2lun(cmd->device),
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
 		printk("%s:%d:%d:%d: Command found on untagged queue\n",
 		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       (u8)cmd->device->lun);
+		       sdev_scsi2lun(cmd->device));
 		retval = SUCCESS;
 		goto done;
 	}
@@ -2182,19 +2182,19 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 	if (flag == SCB_ABORT) {
 		if (ahc_search_qinfifo(ahc, cmd->device->id,
 				       cmd->device->channel + 'A',
-				       cmd->device->lun,
+				       sdev_scsi2lun(cmd->device),
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
 			printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
 			       ahc_name(ahc), cmd->device->channel,
-			       cmd->device->id, (u8)cmd->device->lun);
+			       cmd->device->id, sdev_scsi2lun(cmd->device));
 			retval = SUCCESS;
 			goto done;
 		}
 	} else if (ahc_search_qinfifo(ahc, cmd->device->id,
 				      cmd->device->channel + 'A',
-				      cmd->device->lun,
+				      sdev_scsi2lun(cmd->device),
 				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
@@ -2270,7 +2270,8 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 */
 		ahc_search_disc_list(ahc, cmd->device->id,
 				     cmd->device->channel + 'A',
-				     cmd->device->lun, pending_scb->hscb->tag,
+				     sdev_scsi2lun(cmd->device),
+				     pending_scb->hscb->tag,
 				     /*stop_on_first*/TRUE,
 				     /*remove*/TRUE,
 				     /*save_state*/FALSE);
@@ -2295,7 +2296,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 */
 		ahc_search_qinfifo(ahc, cmd->device->id,
 				   cmd->device->channel + 'A',
-				   cmd->device->lun, SCB_LIST_NULL,
+				   sdev_scsi2lun(cmd->device), SCB_LIST_NULL,
 				   ROLE_INITIATOR, CAM_REQUEUE_REQ,
 				   SEARCH_COMPLETE);
 		ahc_qinfifo_requeue_tail(ahc, pending_scb);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
index 64eec6c..e7787c6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -175,7 +175,7 @@ ahc_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 
 	seq_printf(m, "\tChannel %c Target %d Lun %d Settings\n",
 		  sdev->sdev_target->channel + 'A',
-		   sdev->sdev_target->id, (u8)sdev->lun);
+		   sdev->sdev_target->id, sdev_scsi2lun(sdev));
 
 	seq_printf(m, "\t\tCommands Queued %ld\n", dev->commands_issued);
 	seq_printf(m, "\t\tCommands Active %d\n", dev->active);
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 2e797a3..e0336e7 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -760,7 +760,8 @@ intr_ret_t acornscsi_kick(AS_Host *host)
 	    SCpnt->tag = SCpnt->device->current_tag;
 	} else
 #endif
-	    set_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+		set_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device),
+			host->busyluns);
 
 	host->stats.removes += 1;
 
@@ -863,7 +864,8 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 	if (!SCpnt->scsi_done)
 	    panic("scsi%d.H: null scsi_done function in acornscsi_done", host->host->host_no);
 
-	clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+	clear_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device),
+		  host->busyluns);
 
 	SCpnt->scsi_done(SCpnt);
     } else
@@ -1576,7 +1578,7 @@ void acornscsi_message(AS_Host *host)
 	    printk(KERN_NOTICE "scsi%d.%c: disabling tagged queueing\n",
 		    host->host->host_no, acornscsi_target(host));
 	    host->SCpnt->device->simple_tags = 0;
-	    set_bit(host->SCpnt->device->id * 8 + host->SCpnt->device->lun, host->busyluns);
+	    set_bit(host->SCpnt->device->id * 8 + sdev_scsi2lun(host->SCpnt->device), host->busyluns);
 	    break;
 #endif
 	case EXTENDED_MESSAGE | (EXTENDED_SDTR << 8):
@@ -1688,7 +1690,7 @@ void acornscsi_buildmessages(AS_Host *host)
 
     msgqueue_addmsg(&host->scsi.msgs, 1,
 		     IDENTIFY(host->device[host->SCpnt->device->id].disconnect_ok,
-			     host->SCpnt->device->lun));
+			      sdev_scsi2lun(host->SCpnt->device)));
 
 #if 0
     /* does the device need the current command aborted */
@@ -1788,7 +1790,8 @@ int acornscsi_reconnect(AS_Host *host)
     host->scsi.reconnected.tag = 0;
 
     if (host->scsi.disconnectable && host->SCpnt &&
-	host->SCpnt->device->id == target && host->SCpnt->device->lun == lun)
+	host->SCpnt->device->id == target &&
+	sdev_scsi2lun(host->SCpnt->device) == lun)
 	ok = 1;
 
     if (!ok && queue_probetgtlun(&host->queues.disconnected, target, lun))
@@ -1826,7 +1829,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
     if (host->scsi.disconnectable && host->SCpnt) {
 	host->scsi.disconnectable = 0;
 	if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
-	    host->SCpnt->device->lun == host->scsi.reconnected.lun &&
+	    sdev_scsi2lun(host->SCpnt->device) == host->scsi.reconnected.lun &&
 	    host->SCpnt->tag         == host->scsi.reconnected.tag) {
 #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
 	    DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
@@ -2671,7 +2674,8 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 //#if (DEBUG & DEBUG_ABORT)
 		printk("clear ");
 //#endif
-		clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+		clear_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device),
+			  host->busyluns);
 
 	/*
 	 * We found the command, and cleared it out.  Either
@@ -2853,7 +2857,7 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
 
     shost_for_each_device(scd, instance) {
 	seq_printf(m, "Device/Lun TaggedQ      Sync\n");
-	seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
+	seq_printf(m, "     %d/%d   ", scd->id, sdev_scsi2lun(scd));
 	if (scd->tagged_supported)
 		seq_printf(m, "%3sabled(%3d) ",
 			     scd->simple_tags ? "en" : "dis",
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index b46a6f6..2dd52e7 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -989,7 +989,7 @@ fas216_reselected_intr(FAS216_Info *info)
 	if (info->scsi.disconnectable && info->SCpnt) {
 		info->scsi.disconnectable = 0;
 		if (info->SCpnt->device->id  == target &&
-		    info->SCpnt->device->lun == lun &&
+		    sdev_scsi2lun(info->SCpnt->device) == lun &&
 		    info->SCpnt->tag         == tag) {
 			fas216_log(info, LOG_CONNECT, "reconnected previously executing command");
 		} else {
@@ -1780,7 +1780,8 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 	 * build outgoing message bytes
 	 */
 	msgqueue_flush(&info->scsi.msgs);
-	msgqueue_addmsg(&info->scsi.msgs, 1, IDENTIFY(disconnect_ok, SCpnt->device->lun));
+	msgqueue_addmsg(&info->scsi.msgs, 1,
+			IDENTIFY(disconnect_ok, sdev_scsi2lun(SCpnt->device)));
 
 	/*
 	 * add tag message if required
@@ -1821,7 +1822,8 @@ static void fas216_allocate_tag(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 			SCpnt->tag = SCpnt->device->current_tag;
 	} else
 #endif
-		set_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+		set_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device),
+			info->busyluns);
 
 	info->stats.removes += 1;
 	switch (SCpnt->cmnd[0]) {
@@ -2171,7 +2173,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * status.
 	 */
 	info->device[SCpnt->device->id].parity_check = 0;
-	clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+	clear_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device), info->busyluns);
 
 	fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
 	fn(info, SCpnt, result);
@@ -2398,7 +2400,8 @@ static enum res_find fas216_find_command(FAS216_Info *info,
 		 * been set.
 		 */
 		info->origSCpnt = NULL;
-		clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+		clear_bit(SCpnt->device->id * 8 + sdev_scsi2lun(SCpnt->device),
+			  info->busyluns);
 		printk("waiting for execution ");
 		res = res_success;
 	} else
@@ -3000,7 +3003,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 
 	shost_for_each_device(scd, info->host) {
 		dev = &info->device[scd->id];
-		seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
+		seq_printf(m, "     %d/%d   ", scd->id, sdev_scsi2lun(scd));
 		if (scd->tagged_supported)
 			seq_printf(m, "%3sabled(%3d) ",
 				     scd->simple_tags ? "en" : "dis",
diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index cb11cce..d62b48e 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -167,7 +167,7 @@ struct scsi_cmnd *queue_remove_exclude(Queue_t *queue, unsigned long *exclude)
 	spin_lock_irqsave(&queue->queue_lock, flags);
 	list_for_each(l, &queue->head) {
 		QE_t *q = list_entry(l, QE_t, list);
-		if (!test_bit(q->SCpnt->device->id * 8 + q->SCpnt->device->lun, exclude)) {
+		if (!test_bit(q->SCpnt->device->id * 8 + sdev_scsi2lun(q->SCpnt->device), exclude)) {
 			SCpnt = __queue_remove(queue, l);
 			break;
 		}
@@ -215,7 +215,8 @@ struct scsi_cmnd *queue_remove_tgtluntag(Queue_t *queue, int target, int lun,
 	spin_lock_irqsave(&queue->queue_lock, flags);
 	list_for_each(l, &queue->head) {
 		QE_t *q = list_entry(l, QE_t, list);
-		if (q->SCpnt->device->id == target && q->SCpnt->device->lun == lun &&
+		if (q->SCpnt->device->id == target &&
+		    sdev_scsi2lun(q->SCpnt->device) == lun &&
 		    q->SCpnt->tag == tag) {
 			SCpnt = __queue_remove(queue, l);
 			break;
@@ -265,7 +266,8 @@ int queue_probetgtlun (Queue_t *queue, int target, int lun)
 	spin_lock_irqsave(&queue->queue_lock, flags);
 	list_for_each(l, &queue->head) {
 		QE_t *q = list_entry(l, QE_t, list);
-		if (q->SCpnt->device->id == target && q->SCpnt->device->lun == lun) {
+		if (q->SCpnt->device->id == target &&
+		    sdev_scsi2lun(q->SCpnt->device) == lun) {
 			found = 1;
 			break;
 		}
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 1814aa2..0542bfd 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -361,17 +361,18 @@ static void __init init_tags(void)
 
 static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
 {
+	u8 lun = sdev_scsi2lun(cmd->device);
 	SETUP_HOSTDATA(cmd->device->host);
 
-	if (hostdata->busy[cmd->device->id] & (1 << cmd->device->lun))
+	if (hostdata->busy[cmd->device->id] & (1 << lun))
 		return 1;
 	if (!should_be_tagged ||
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported)
 		return 0;
-	if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
-	    TagAlloc[cmd->device->id][cmd->device->lun].queue_size) {
+	if (TagAlloc[cmd->device->id][lun].nr_allocated >=
+	    TagAlloc[cmd->device->id][lun].queue_size) {
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
-			   H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->device->id, lun);
 		return 1;
 	}
 	return 0;
@@ -385,6 +386,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
 
 static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 {
+	u8 lun = sdev_scsi2lun(cmd->device);
 	SETUP_HOSTDATA(cmd->device->host);
 
 	/* If we or the target don't support tagged queuing, allocate the LUN for
@@ -393,11 +395,11 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 	if (!should_be_tagged ||
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
-		hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] |= (1 << lun);
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
-			   "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   "command\n", H_NO(cmd), cmd->device->id, lun);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
@@ -405,7 +407,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 		dprintk(NDEBUG_TAGS, "scsi%d: using tag %d for target %d lun %d "
 			   "(now %d tags in use)\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id,
-			   cmd->device->lun, ta->nr_allocated);
+			   lun, ta->nr_allocated);
 	}
 }
 
@@ -416,21 +418,22 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 
 static void cmd_free_tag(Scsi_Cmnd *cmd)
 {
+	u8 lun = sdev_scsi2lun(cmd->device);
 	SETUP_HOSTDATA(cmd->device->host);
 
 	if (cmd->tag == TAG_NONE) {
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << lun);
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d untagged cmd finished\n",
-			   H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->device->id, lun);
 	} else if (cmd->tag >= MAX_TAGS) {
 		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
 		       H_NO(cmd), cmd->tag);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
 		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
-			   H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->tag, cmd->device->id, lun);
 	}
 }
 
@@ -714,7 +717,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
 	int i, s;
 	unsigned char *command;
 	printk("scsi%d: destination target %d, lun %d\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
+	       H_NO(cmd), cmd->device->id, sdev_scsi2lun(cmd->device));
 	printk(KERN_CONT "        command = ");
 	command = cmd->cmnd;
 	printk(KERN_CONT "%2d (0x%02x)", command[0], command[0]);
@@ -760,7 +763,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 	int i, s;
 	unsigned char *command;
 	seq_printf(m, "scsi%d: destination target %d, lun %d\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
+		   H_NO(cmd), cmd->device->id, sdev_scsi2lun(cmd->device));
 	seq_printf(m, "        command = ");
 	command = cmd->cmnd;
 	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
@@ -1065,7 +1068,7 @@ static void NCR5380_main(struct work_struct *work)
 				if (prev != tmp)
 					printk("MAIN tmp=%p   target=%d   busy=%d lun=%d\n",
 					       tmp, tmp->device->id, hostdata->busy[tmp->device->id],
-					       tmp->device->lun);
+					       sdev_scsi2lun(tmp->device));
 #endif
 				/*  When we find one, remove it from the issue queue. */
 				/* ++guenther: possible race with Falcon locking */
@@ -1073,7 +1076,7 @@ static void NCR5380_main(struct work_struct *work)
 #ifdef SUPPORT_TAGS
 				    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
 #else
-				    !(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))
+				    !(hostdata->busy[tmp->device->id] & (1 << sdev_scsi2lun(tmp->device)))
 #endif
 				    ) {
 					/* ++guenther: just to be sure, this must be atomic */
@@ -1098,8 +1101,8 @@ static void NCR5380_main(struct work_struct *work)
 					 *   issue queue so we can keep trying.
 					 */
 					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-						    "lun %d removed from issue_queue\n",
-						    HOSTNO, tmp->device->id, tmp->device->lun);
+						"lun %d removed from issue_queue\n",
+						HOSTNO, tmp->device->id, sdev_scsi2lun(tmp->device));
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -1648,7 +1651,7 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd, int tag)
 
 	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 		   HOSTNO, cmd->device->id);
-	tmp[0] = IDENTIFY(1, cmd->device->lun);
+	tmp[0] = IDENTIFY(1, sdev_scsi2lun(cmd->device));
 
 #ifdef SUPPORT_TAGS
 	if (cmd->tag != TAG_NONE) {
@@ -1670,7 +1673,7 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd, int tag)
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 #endif
 
 	initialize_SCp(cmd);
@@ -1979,6 +1982,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
 	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+	u8 lun = sdev_scsi2lun(cmd->device);
 
 	while (1) {
 		tmp = NCR5380_read(STATUS_REG);
@@ -2062,7 +2066,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						 * polled-IO. */
 						printk(KERN_NOTICE "scsi%d: switching target %d "
 							   "lun %d to slow handshake\n", HOSTNO,
-							   cmd->device->id, cmd->device->lun);
+						           cmd->device->id, lun);
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 							ICR_ASSERT_ATN);
@@ -2114,7 +2118,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
-						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
+						   "complete.\n", HOSTNO, cmd->device->id, lun);
 
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -2127,7 +2131,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					if (!cmd->next_link) {
 						 printk(KERN_NOTICE "scsi%d: target %d lun %d "
 							"linked command complete, no next_link\n",
-							HOSTNO, cmd->device->id, cmd->device->lun);
+							HOSTNO, cmd->device->id, lun);
 						sink = 1;
 						do_abort(instance);
 						return;
@@ -2140,7 +2144,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
 					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 						   "done, calling scsi_done().\n",
-						   HOSTNO, cmd->device->id, cmd->device->lun);
+						   HOSTNO, cmd->device->id, lun);
 #ifdef NCR5380_STATS
 					collect_stats(hostdata, cmd);
 #endif
@@ -2156,7 +2160,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					falcon_dont_release++;
 					hostdata->connected = NULL;
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
-						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
+						  "completed\n", HOSTNO, cmd->device->id, lun);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
@@ -2168,16 +2172,16 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						 */
 						/* ++Andreas: the mid level code knows about
 						   QUEUE_FULL now. */
-						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 							   "QUEUE_FULL after %d commands\n",
-							   HOSTNO, cmd->device->id, cmd->device->lun,
+							   HOSTNO, cmd->device->id, lun,
 							   ta->nr_allocated);
 						if (ta->queue_size > ta->nr_allocated)
 							ta->nr_allocated = ta->queue_size;
 					}
 #else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -2265,12 +2269,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						 * the command is treated as untagged further on.
 						 */
 						cmd->device->tagged_supported = 0;
-						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+						hostdata->busy[cmd->device->id] |= (1 << lun);
 						cmd->tag = TAG_NONE;
 						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 							   "QUEUE_TAG message; tagged queuing "
 							   "disabled\n",
-							   HOSTNO, cmd->device->id, cmd->device->lun);
+							   HOSTNO, cmd->device->id, lun);
 						break;
 					}
 					break;
@@ -2287,7 +2291,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 						  "moved from connected to the "
 						  "disconnected_queue\n", HOSTNO,
-						  cmd->device->id, cmd->device->lun);
+						  cmd->device->id, lun);
 					/*
 					 * Restore phase bits to 0 so an interrupted selection,
 					 * arbitration can resume.
@@ -2386,13 +2390,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					} else if (tmp != EXTENDED_MESSAGE)
 						printk(KERN_DEBUG "scsi%d: rejecting unknown "
 						       "message %02x from target %d, lun %d\n",
-						       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
+						       HOSTNO, tmp, cmd->device->id, lun);
 					else
 						printk(KERN_DEBUG "scsi%d: rejecting unknown "
 						       "extended message "
 						       "code %02x, length %d from target %d, lun %d\n",
 						       HOSTNO, extended_msg[1], extended_msg[0],
-						       cmd->device->id, cmd->device->lun);
+						       cmd->device->id, lun);
 
 
 					msgout = MESSAGE_REJECT;
@@ -2409,7 +2413,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 #else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
@@ -2546,7 +2550,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL;
 	     tmp; prev = tmp, tmp = NEXT(tmp)) {
-		if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
+		if ((target_mask == (1 << tmp->device->id)) && (lun == sdev_scsi2lun(tmp->device))
 #ifdef SUPPORT_TAGS
 		    && (tag == tmp->tag)
 #endif
@@ -2589,7 +2593,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	hostdata->connected = tmp;
 	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
-		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
+		HOSTNO, tmp->device->id, sdev_scsi2lun(tmp->device), tmp->tag);
 	falcon_dont_release--;
 }
 
@@ -2618,6 +2622,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	SETUP_HOSTDATA(instance);
 	Scsi_Cmnd *tmp, **prev;
 	unsigned long flags;
+	u8 lun = sdev_scsi2lun(cmd->device);
 
 	printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
 	scsi_print_command(cmd);
@@ -2668,7 +2673,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 #ifdef SUPPORT_TAGS
 			cmd_free_tag(cmd);
 #else
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 			local_irq_restore(flags);
 			cmd->scsi_done(cmd);
@@ -2776,7 +2781,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(tmp);
 #else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 					local_irq_restore(flags);
 					tmp->scsi_done(tmp);
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a795d81..59e2a69 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -835,7 +835,7 @@ oktosend:
 		outb(workreq->cmnd[i], tmport++);
 	}
 	tmport = workport + 0x0f;
-	outb(workreq->device->lun, tmport);
+	outb(sdev_scsi2lun(workreq->device), tmport);
 	tmport += 0x02;
 	/*
 	 *	Write the target
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 32a5e0a..00db81d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1448,9 +1448,9 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct bnx2fc_cmd *cmd, *tmp;
-	int tm_lun = sc_cmd->device->lun;
+	u64 tm_lun = sc_cmd->device->lun;
+	u64 lun;
 	int rc = 0;
-	int lun;
 
 	/* called with tgt_lock held */
 	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_lun_reset_cmpl\n");
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ba1c3bf..6738578 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -251,7 +251,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
  retry:
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = READ_ELEMENT_STATUS;
-	cmd[1] = (ch->device->lun << 5) |
+	cmd[1] = (sdev_scsi2lun(ch->device) << 5) |
 		(ch->voltags ? 0x10 : 0) |
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
@@ -287,7 +287,7 @@ ch_init_elem(scsi_changer *ch)
 	VPRINTK(KERN_INFO, "INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = sdev_scsi2lun(ch->device) << 5;
 	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
@@ -307,7 +307,7 @@ ch_readconfig(scsi_changer *ch)
 
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = sdev_scsi2lun(ch->device) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
 	result = ch_do_scsi(ch, cmd, buffer, 255, DMA_FROM_DEVICE);
@@ -432,7 +432,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = POSITION_TO_ELEMENT;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = sdev_scsi2lun(ch->device) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (elem  >> 8) & 0xff;
@@ -451,7 +451,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = MOVE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = sdev_scsi2lun(ch->device) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -474,7 +474,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = EXCHANGE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = sdev_scsi2lun(ch->device) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -522,7 +522,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 		elem, tag);
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = SEND_VOLUME_TAG;
-	cmd[1] = (ch->device->lun << 5) |
+	cmd[1] = (sdev_scsi2lun(ch->device) << 5) |
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
 	cmd[3] = elem        & 0xff;
@@ -758,7 +758,7 @@ static long ch_ioctl(struct file *file,
 	voltag_retry:
 		memset(ch_cmd, 0, sizeof(ch_cmd));
 		ch_cmd[0] = READ_ELEMENT_STATUS;
-		ch_cmd[1] = (ch->device->lun << 5) |
+		ch_cmd[1] = (sdev_scsi2lun(ch->device) << 5) |
 			(ch->voltags ? 0x10 : 0) |
 			ch_elem_to_typecode(ch,elem);
 		ch_cmd[2] = (elem >> 8) & 0xff;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 0c6be0a..4fb10aa 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1087,31 +1087,31 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkdbg(DBG_0, "queue_command: (0x%p) <%02i-%i> cmnd=0x%02x\n",
-		cmd, cmd->device->id, (u8)cmd->device->lun, cmd->cmnd[0]);
+		   cmd, cmd->device->id, sdev_scsi2lun(cmd->device), cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
 
 	/* ignore invalid targets */
 	if (cmd->device->id >= acb->scsi_host->max_id ||
-	    cmd->device->lun >= acb->scsi_host->max_lun ||
-	    cmd->device->lun >31) {
+	    sdev_scsi2lun(cmd->device) >= acb->scsi_host->max_lun ||
+	    sdev_scsi2lun(cmd->device) >31) {
 		goto complete;
 	}
 
 	/* does the specified lun on the specified device exist */
-	if (!(acb->dcb_map[cmd->device->id] & (1 << cmd->device->lun))) {
+	if (!(acb->dcb_map[cmd->device->id] & (1 << sdev_scsi2lun(cmd->device)))) {
 		dprintkl(KERN_INFO, "queue_command: Ignore target <%02i-%i>\n",
-			cmd->device->id, (u8)cmd->device->lun);
+			 cmd->device->id, sdev_scsi2lun(cmd->device));
 		goto complete;
 	}
 
 	/* do we have a DCB for the device */
-	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
+	dcb = find_dcb(acb, cmd->device->id, sdev_scsi2lun(cmd->device));
 	if (!dcb) {
 		/* should never happen */
 		dprintkl(KERN_ERR, "queue_command: No such device <%02i-%i>",
-			cmd->device->id, (u8)cmd->device->lun);
+			 cmd->device->id, sdev_scsi2lun(cmd->device));
 		goto complete;
 	}
 
@@ -1205,9 +1205,9 @@ static void dump_register_info(struct AdapterCtlBlk *acb,
 		else
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p "
 				 "cmnd=0x%02x <%02i-%i>\n",
-				srb, srb->cmd,
-				srb->cmd->cmnd[0], srb->cmd->device->id,
-				(u8)srb->cmd->device->lun);
+				 srb, srb->cmd,
+				 srb->cmd->cmnd[0], srb->cmd->device->id,
+				 sdev_scsi2lun(srb->cmd->device));
 		printk("  sglist=%p cnt=%i idx=%i len=%zu\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
@@ -1302,7 +1302,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkl(KERN_INFO,
 		"eh_bus_reset: (0%p) target=<%02i-%i> cmd=%p\n",
-		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
+		cmd, cmd->device->id, sdev_scsi2lun(cmd->device), cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1369,9 +1369,9 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 	dprintkl(KERN_INFO, "eh_abort: (0x%p) target=<%02i-%i> cmd=%p\n",
-		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
+		 cmd, cmd->device->id, sdev_scsi2lun(cmd->device), cmd);
 
-	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
+	dcb = find_dcb(acb, cmd->device->id, sdev_scsi2lun(cmd->device));
 	if (!dcb) {
 		dprintkl(KERN_DEBUG, "eh_abort: No such device\n");
 		return FAILED;
@@ -1603,9 +1603,9 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		}
 		if (tag_number >= dcb->max_command) {
 			dprintkl(KERN_WARNING, "start_scsi: (0x%p) "
-				"Out of tags target=<%02i-%i>)\n",
-				srb->cmd, srb->cmd->device->id,
-				(u8)srb->cmd->device->lun);
+				 "Out of tags target=<%02i-%i>)\n",
+				 srb->cmd, srb->cmd->device->id,
+				 sdev_scsi2lun(srb->cmd->device));
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 				       DO_HWRESELECT);
@@ -1623,8 +1623,8 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (0x%p) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun,
-		srb->cmd->cmnd[0], srb->tag_number);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device),
+		   srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
@@ -2041,7 +2041,7 @@ static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2171,7 +2171,7 @@ static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2183,7 +2183,7 @@ static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 
 	dprintkdbg(DBG_0, "data_in_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2394,7 +2394,7 @@ static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2406,9 +2406,9 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (0x%p) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun,
-		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
-		srb->total_xfer_length, srb->sg_index, srb->sg_count);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device),
+		   ((io_dir & DMACMD_DIR) ? 'r' : 'w'),
+		   srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
 		dprintkl(KERN_ERR, "data_io_transfer: Using tmp_srb!\n");
 	if (srb->sg_index >= srb->sg_count) {
@@ -2579,7 +2579,7 @@ static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2593,7 +2593,7 @@ static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (0x%p) <%02i-%i>\n",
-		srb->cmd, srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd, srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -3318,7 +3318,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	int ckc_only = 1;
 
 	dprintkdbg(DBG_1, "srb_done: (0x%p) <%02i-%i>\n", srb->cmd,
-		srb->cmd->device->id, (u8)srb->cmd->device->lun);
+		   srb->cmd->device->id, sdev_scsi2lun(srb->cmd->device));
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		   srb, scsi_sg_count(cmd), srb->sg_index, srb->sg_count,
 		   scsi_sgtalbe(cmd));
@@ -3497,9 +3497,9 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	if (debug_enabled(DBG_KG)) {
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "
-				"cmnd=0x%02x Missed %i bytes\n",
-				cmd, cmd->device->id, (u8)cmd->device->lun,
-				cmd->cmnd[0], srb->total_xfer_length);
+				   "cmnd=0x%02x Missed %i bytes\n",
+				   cmd, cmd->device->id, sdev_scsi2lun(cmd->device),
+				   cmd->cmnd[0], srb->total_xfer_length);
 	}
 
 	srb_going_remove(dcb, srb);
@@ -3538,7 +3538,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("G:%p(%02i-%i) ", p,
-			       p->device->id, (u8)p->device->lun);
+			       p->device->id, sdev_scsi2lun(p->device));
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3568,7 +3568,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("W:%p<%02i-%i>", p, p->device->id,
-			       (u8)p->device->lun);
+			       sdev_scsi2lun(p->device));
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
 			p->result = result;
@@ -3677,7 +3677,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (0x%p) <%02i-%i>\n",
-		cmd, cmd->device->id, (u8)cmd->device->lun);
+		   cmd, cmd->device->id, sdev_scsi2lun(cmd->device));
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3905,7 +3905,7 @@ static int dc395x_slave_alloc(struct scsi_device *scsi_device)
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 
-	dcb = device_alloc(acb, scsi_device->id, scsi_device->lun);
+	dcb = device_alloc(acb, scsi_device->id, sdev_scsi2lun(scsi_device));
 	if (!dcb)
 		return -ENOMEM;
 	adapter_add_device(acb, dcb);
@@ -3923,7 +3923,8 @@ static int dc395x_slave_alloc(struct scsi_device *scsi_device)
 static void dc395x_slave_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
-	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
+	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id,
+					    sdev_scsi2lun(scsi_device));
 	if (dcb)
 		adapter_remove_and_free_device(acb, dcb);
 }
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 03372cf..aeefa93 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1812,7 +1812,7 @@ static int eata2x_queuecommand_lck(struct scsi_cmnd *SCpnt,
 	cpp->one = 1;
 	cpp->channel = SCpnt->device->channel;
 	cpp->target = SCpnt->device->id;
-	cpp->lun = SCpnt->device->lun;
+	cpp->lun = sdev_scsi2lun(SCpnt->device);
 	cpp->SCpnt = SCpnt;
 	memcpy(cpp->cdb, SCpnt->cmnd, SCpnt->cmd_len);
 
@@ -2449,7 +2449,7 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
-			       (u8)SCpnt->device->lun,
+			       sdev_scsi2lun(SCpnt->device),
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
 		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 8319d2b..65c3a8a 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -352,7 +352,7 @@ static int eata_pio_queue_lck(struct scsi_cmnd *cmd,
 	cp->reqlen = 0;
 
 	cp->cp_id = cmd->device->id;
-	cp->cp_lun = cmd->device->lun;
+	cp->cp_lun = sdev_scsi2lun(cmd->device);
 	cp->cp_dispri = 0;
 	cp->cp_identify = 1;
 	memcpy(cp->cp_cdb, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 55548dc..0f7ec18 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -600,7 +600,7 @@ static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
 	u8 *p, val;
 
 	tgt = dev->id;
-	lun = dev->lun;
+	lun = sdev_scsi2lun(dev);
 
 
 	if (!ent->sense_ptr) {
@@ -706,7 +706,7 @@ static void esp_maybe_execute_command(struct esp *esp)
 	cmd = ent->cmd;
 	dev = cmd->device;
 	tgt = dev->id;
-	lun = dev->lun;
+	lun = sdev_scsi2lun(dev);
 	tp = &esp->target[tgt];
 	lp = dev->hostdata;
 
@@ -857,7 +857,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 {
 	struct scsi_device *dev = cmd->device;
 	int tgt = dev->id;
-	int lun = dev->lun;
+	int lun = sdev_scsi2lun(dev);
 
 	esp->active_cmd = NULL;
 	esp_unmap_dma(esp, cmd);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index a1bc8ca..e537ac3 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -768,7 +768,7 @@ static void sprint_command(struct seq_file *m, unsigned char *command)
 
 static void sprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd * cmd)
 {
-	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
+	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP sdev_scsi2lun(cmd->device));
 	PRINTP("        command = ");
 	sprint_command(m, cmd->cmnd);
 }
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0f1ae13..c3438b0 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2047,7 +2047,7 @@ static void gdth_next(gdth_ha_str *ha)
         if (!nscp_cmndinfo->internal_command) {
             b = nscp->device->channel;
             t = nscp->device->id;
-            l = nscp->device->lun;
+            l = sdev_scsi2lun(nscp->device);
             if (nscp_cmndinfo->priority >= DEFAULT_PRI) {
                 if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                     (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock))
@@ -2606,7 +2606,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
     struct gdth_cmndinfo *cmndinfo;
 
     t = scp->device->id;
-    l = scp->device->lun;
+    l = sdev_scsi2lun(scp->device);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_raw_cmd() cmd 0x%x bus %d ID %d LUN %d\n",
            scp->cmnd[0],b,t,l));
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index ee196b3..b64b0e4 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1028,7 +1028,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 			"req_index=%d, req=%p\n",
 			scp,
 			host->host_no, scp->device->channel,
-			scp->device->id, scp->device->lun,
+			scp->device->id, sdev_scsi2lun(scp->device),
 			cpu_to_be32(((u32 *)scp->cmnd)[0]),
 			cpu_to_be32(((u32 *)scp->cmnd)[1]),
 			cpu_to_be32(((u32 *)scp->cmnd)[2]),
@@ -1037,7 +1037,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 
 	scp->result = 0;
 
-	if (scp->device->channel || scp->device->lun ||
+	if (scp->device->channel || sdev_scsi2lun(scp->device) ||
 			scp->device->id > hba->max_devices) {
 		scp->result = DID_BAD_TARGET << 16;
 		free_req(hba, _req);
@@ -1057,7 +1057,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 	req->dataxfer_length = cpu_to_le32(scsi_bufflen(scp));
 	req->channel = scp->device->channel;
 	req->target = scp->device->id;
-	req->lun = scp->device->lun;
+	req->lun = sdev_scsi2lun(scp->device);
 	req->header.size = cpu_to_le32(
 				sizeof(struct hpt_iop_request_scsi_command)
 				 - sizeof(struct hpt_iopsg)
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index b1c4d83..83af7f9 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -471,7 +471,7 @@ static void in2000_execute(struct Scsi_Host *instance)
 	cmd = (Scsi_Cmnd *) hostdata->input_Q;
 	prev = NULL;
 	while (cmd) {
-		if (!(hostdata->busy[cmd->device->id] & (1 << cmd->device->lun)))
+		if (!(hostdata->busy[cmd->device->id] & (1 << sdev_scsi2lun(cmd->device))))
 			break;
 		prev = cmd;
 		cmd = (Scsi_Cmnd *) cmd->host_scribble;
@@ -541,7 +541,7 @@ static void in2000_execute(struct Scsi_Host *instance)
 	if (!(hostdata->input_Q))	/* input_Q empty? */
 		goto no;
 	for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble) {
-		if ((prev->device->id != cmd->device->id) || (prev->device->lun != cmd->device->lun)) {
+		if ((prev->device->id != cmd->device->id) || prev->device->lun != cmd->device->lun)) {
 			for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble)
 				prev->SCp.phase = 1;
 			goto yes;
@@ -559,9 +559,9 @@ static void in2000_execute(struct Scsi_Host *instance)
       no:
 	write_3393(hostdata, WD_SOURCE_ID, ((cmd->SCp.phase) ? SRCID_ER : 0));
 
-	write_3393(hostdata, WD_TARGET_LUN, cmd->device->lun);
+	write_3393(hostdata, WD_TARGET_LUN, sdev_scsi2lun(cmd->device));
 	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[cmd->device->id]);
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 
 	if ((hostdata->level2 <= L2_NONE) || (hostdata->sync_stat[cmd->device->id] == SS_UNSET)) {
 
@@ -1075,7 +1075,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		}
 
 		cmd->result = DID_NO_CONNECT << 16;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
 
@@ -1097,7 +1097,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 		/* construct an IDENTIFY message with correct disconnect bit */
 
-		hostdata->outgoing_msg[0] = (0x80 | 0x00 | cmd->device->lun);
+		hostdata->outgoing_msg[0] = (0x80 | 0x00 | sdev_scsi2lun(cmd->device));
 		if (cmd->SCp.phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
@@ -1333,7 +1333,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 			lun = read_3393(hostdata, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
 			    hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 			hostdata->state = S_UNCONNECTED;
 			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
 				cmd->SCp.Status = lun;
@@ -1418,7 +1418,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		}
 		DB(DB_INTR, printk("UNEXP_DISC"))
 		    hostdata->connected = NULL;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->state = S_UNCONNECTED;
 		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
 			cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
@@ -1449,7 +1449,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		switch (hostdata->state) {
 		case S_PRE_CMP_DISC:
 			hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 			hostdata->state = S_UNCONNECTED;
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
 			    if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
@@ -1494,7 +1494,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 			if (hostdata->selecting) {
 				cmd = (Scsi_Cmnd *) hostdata->selecting;
 				hostdata->selecting = NULL;
-				hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+				hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 				cmd->host_scribble = (uchar *) hostdata->input_Q;
 				hostdata->input_Q = cmd;
 			}
@@ -1504,7 +1504,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 			if (cmd) {
 				if (phs == 0x00) {
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 					cmd->host_scribble = (uchar *) hostdata->input_Q;
 					hostdata->input_Q = cmd;
 				} else {
@@ -1536,7 +1536,8 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		cmd = (Scsi_Cmnd *) hostdata->disconnected_Q;
 		patch = NULL;
 		while (cmd) {
-			if (id == cmd->device->id && lun == cmd->device->lun)
+			if (id == cmd->device->id &&
+			    lun == sdev_scsi2lun(cmd->device))
 				break;
 			patch = cmd;
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
@@ -1757,7 +1758,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
 		sr = read_3393(hostdata, WD_SCSI_STATUS);
 		printk("asr=%02x, sr=%02x.", asr, sr);
 
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
 		cmd->result = DID_ABORT << 16;
@@ -2251,14 +2252,16 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%d(%02x)", cmd->device->id,
+				   sdev_scsi2lun(cmd->device), cmd->cmnd[0]);
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
 		seq_printf(m, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%d(%02x)", cmd->device->id,
+				   sdev_scsi2lun(cmd->device), cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
@@ -2266,7 +2269,8 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%d(%02x)", cmd->device->id,
+				   sdev_scsi2lun(cmd->device), cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e5dae7b..2ac878e 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2573,8 +2573,8 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 	cblk->opcode = ExecSCSI;
 	cblk->flags = SCF_POST;	/* After SCSI done, call post routine */
 	cblk->target = cmnd->device->id;
-	cblk->lun = cmnd->device->lun;
-	cblk->ident = cmnd->device->lun | DISC_ALLOW;
+	cblk->lun = sdev_scsi2lun(cmnd->device);
+	cblk->ident = sdev_scsi2lun(cmnd->device) | DISC_ALLOW;
 
 	cblk->flags |= SCF_SENSE;	/* Turn on auto request sense   */
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ac5d94c..eccbb75 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -583,7 +583,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 	if(islogical) {
 
 		/* have just LUN 0 for each target on virtual channels */
-		if (cmd->device->lun) {
+		if (sdev_scsi2lun(cmd->device)) {
 			cmd->result = (DID_BAD_TARGET << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
@@ -610,7 +610,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 
 	}
 	else {
-		if( cmd->device->lun > 7) {
+		if (sdev_scsi2lun(cmd->device) > 7) {
 			/*
 			 * Do not support lun >7 for physically accessed
 			 * devices
@@ -970,7 +970,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
 		(channel << 4) | target : target;
 
 	pthru->cdblen = cmd->cmd_len;
-	pthru->logdrv = cmd->device->lun;
+	pthru->logdrv = sdev_scsi2lun(cmd->device);
 
 	memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
 
@@ -1033,7 +1033,7 @@ mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
 		(channel << 4) | target : target;
 
 	epthru->cdblen = cmd->cmd_len;
-	epthru->logdrv = cmd->device->lun;
+	epthru->logdrv = sdev_scsi2lun(cmd->device);
 
 	memcpy(epthru->cdb, cmd->cmnd, cmd->cmd_len);
 
@@ -1942,7 +1942,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
 	     (aor == SCB_ABORT)? "ABORTING":"RESET",
 	     cmd->cmnd[0], cmd->device->channel,
-	     cmd->device->id, (u32)cmd->device->lun);
+	     cmd->device->id, sdev_scsi2lun(cmd->device));
 
 	if(list_empty(&adapter->pending_list))
 		return FALSE;
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e8a04ae..d69203a 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1228,11 +1228,11 @@ static void handle_msgin(struct mesh_state *ms)
 			if (cmd == NULL) {
 				do_abort(ms);
 				ms->msgphase = msg_out;
-			} else if (code != cmd->device->lun + IDENTIFY_BASE) {
+			} else if (code != sdev_scsi2lun(cmd->device) + IDENTIFY_BASE) {
 				printk(KERN_WARNING "mesh: lun mismatch "
 				       "(%d != %d) on reselection from "
 				       "target %d\n", code - IDENTIFY_BASE,
-				       cmd->device->lun, ms->conn_tgt);
+				       sdev_scsi2lun(cmd->device), ms->conn_tgt);
 			}
 			break;
 		}
@@ -1544,7 +1544,7 @@ static void cmd_complete(struct mesh_state *ms)
 		case selecting:
 			dlog(ms, "Selecting phase at command completion",0);
 			ms->msgout[0] = IDENTIFY(ALLOW_RESEL(ms->conn_tgt),
-						 (cmd? cmd->device->lun: 0));
+						 (cmd? sdev_scsi2lun(cmd->device): 0));
 			ms->n_msgout = 1;
 			ms->expect_reply = 0;
 			if (ms->aborting) {
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index edbee8d..59f6f06 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2071,7 +2071,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	cmd->cmd_status = REQ_STATUS_PENDING;
 	pframe = cmd->frame;
 	pframe->device_id = ((unsigned short) scmd->device->id) |
-				(((unsigned short) scmd->device->lun) << 8);
+		(sdev_scsi2lun(scmd->device) << 8);
 	pframe->cmd_flag = 0;
 
 	switch (scmd->sc_data_direction) {
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7d014b1..ba673a8 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4120,7 +4120,7 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct tcb *tp = &np->target[sdev->id];
-	struct lcb *lp = tp->lp[sdev->lun];
+	struct lcb *lp = tp->lp[sdev_scsi2lun(sdev)];
 	struct ccb *cp;
 
 	int	segments;
@@ -4135,9 +4135,9 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**---------------------------------------------
 	*/
-	if ((sdev->id == np->myaddr	  ) ||
-		(sdev->id >= MAX_TARGET) ||
-		(sdev->lun    >= MAX_LUN   )) {
+	if ((sdev->id == np->myaddr) ||
+	    (sdev->id >= MAX_TARGET) ||
+	    (sdev_scsi2lun(sdev) >= MAX_LUN)) {
 		return(DID_BAD_TARGET);
 	}
 
@@ -4189,7 +4189,7 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**----------------------------------------------------
 	*/
 
-	idmsg = IDENTIFY(0, sdev->lun);
+	idmsg = IDENTIFY(0, sdev_scsi2lun(sdev));
 
 	if (cp ->tag != NO_TAG ||
 		(cp != np->ccb && np->disc && !(tp->usrflag & UF_NODISC)))
@@ -4841,7 +4841,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 	cmd = cp->cmd;
 	cp->cmd = NULL;
 	tp = &np->target[cmd->device->id];
-	lp = tp->lp[cmd->device->lun];
+	lp = tp->lp[sdev_scsi2lun(cmd->device)];
 
 	/*
 	**	We donnot queue more than 1 ccb per target 
@@ -4935,7 +4935,8 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		**	Allocate the lcb if not yet.
 		*/
 		if (!lp)
-			ncr_alloc_lcb (np, cmd->device->id, cmd->device->lun);
+			ncr_alloc_lcb (np, cmd->device->id,
+				       sdev_scsi2lun(cmd->device));
 
 		tp->bytes     += cp->data_len;
 		tp->transfers ++;
@@ -5631,7 +5632,7 @@ static void ncr_setwide (struct ncb *np, struct ccb *cp, u_char wide, u_char ack
 
 static void ncr_setup_tags (struct ncb *np, struct scsi_device *sdev)
 {
-	unsigned char tn = sdev->id, ln = sdev->lun;
+	unsigned char tn = sdev->id, ln = sdev_scsi2lun(sdev);
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char   reqtags, maxdepth;
@@ -6542,7 +6543,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 {
 	struct scsi_cmnd *cmd	= cp->cmd;
 	struct tcb *tp	= &np->target[cmd->device->id];
-	struct lcb *lp	= tp->lp[cmd->device->lun];
+	struct lcb *lp	= tp->lp[sdev_scsi2lun(cmd->device)];
 	struct list_head *qp;
 	struct ccb *	cp2;
 	int		disc_cnt = 0;
@@ -6619,7 +6620,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		**
 		**	identify message
 		*/
-		cp->scsi_smsg2[0]	= IDENTIFY(0, cmd->device->lun);
+		cp->scsi_smsg2[0]	= IDENTIFY(0, sdev_scsi2lun(cmd->device));
 		cp->phys.smsg.addr	= cpu_to_scr(CCB_PHYS (cp, scsi_smsg2));
 		cp->phys.smsg.size	= cpu_to_scr(1);
 
@@ -6633,7 +6634,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		**	patch requested size into sense command
 		*/
 		cp->sensecmd[0]		= 0x03;
-		cp->sensecmd[1]		= cmd->device->lun << 5;
+		cp->sensecmd[1]		= (sdev_scsi2lun(cmd->device) & 0x7) << 5;
 		cp->sensecmd[4]		= sizeof(cp->sense_buf);
 
 		/*
@@ -7143,7 +7144,7 @@ out:
 static struct ccb *ncr_get_ccb(struct ncb *np, struct scsi_cmnd *cmd)
 {
 	u_char tn = cmd->device->id;
-	u_char ln = cmd->device->lun;
+	u_char ln = sdev_scsi2lun(cmd->device);
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char tag = NO_TAG;
@@ -7580,7 +7581,7 @@ fail:
 */
 static struct lcb *ncr_setup_lcb (struct ncb *np, struct scsi_device *sdev)
 {
-	unsigned char tn = sdev->id, ln = sdev->lun;
+	unsigned char tn = sdev->id, ln = sdev_scsi2lun(sdev);
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 
@@ -7975,7 +7976,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
 	struct tcb *tp = &np->target[device->id];
-	struct lcb *lp = tp->lp[device->lun];
+	struct lcb *lp = tp->lp[sdev_scsi2lun(device)];
 	int numtags, depth_to_use;
 
 	ncr_setup_lcb(np, device);
@@ -7986,7 +7987,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
 	**	Use at least 2.
 	**	Donnot use more than our maximum.
 	*/
-	numtags = device_queue_depth(np->unit, device->id, device->lun);
+	numtags = device_queue_depth(np->unit, device->id, sdev_scsi2lun(device));
 	if (numtags > tp->usrtags)
 		numtags = tp->usrtags;
 	if (!device->tagged_supported)
@@ -8019,7 +8020,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
 
 #ifdef DEBUG_NCR53C8XX
 	printk("ncr53c8xx_select_queue_depth: host=%d, id=%d, lun=%d, depth=%d\n",
-	       np->unit, device->id, device->lun, depth_to_use);
+	       np->unit, device->id, sdev_scsi2lun(device), depth_to_use);
 #endif
 
 	if (spi_support_sync(device->sdev_target) &&
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0665f9c..d6856c8 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -376,7 +376,7 @@ static void nsp32_build_identify(struct scsi_cmnd *SCpnt)
 		/* mode = TRUE; */
 	}
 
-	data->msgoutbuf[pos] = IDENTIFY(mode, SCpnt->device->lun); pos++;
+	data->msgoutbuf[pos] = IDENTIFY(mode, sdev_scsi2lun(SCpnt->device)); pos++;
 
 	data->msgout_len = pos;
 }
@@ -917,8 +917,10 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
-		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
-		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
+		  SCpnt->device->id, sdev_scsi2lun(SCpnt->device),
+		  SCpnt->cmnd[0], SCpnt->cmd_len,
+		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt),
+		  scsi_bufflen(SCpnt));
 
 	if (data->CurrentSC != NULL) {
 		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
@@ -937,7 +939,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	}
 
 	/* check target LUN is allowable value */
-	if (SCpnt->device->lun >= MAX_LUN) {
+	if (sdev_scsi2lun(SCpnt->device) >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
@@ -960,13 +962,13 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* initialize data */
 	data->msgout_len	= 0;
 	data->msgin_len		= 0;
-	cur_lunt		= &(data->lunt[SCpnt->device->id][SCpnt->device->lun]);
+	cur_lunt		= &(data->lunt[SCpnt->device->id][sdev_scsi2lun(SCpnt->device)]);
 	cur_lunt->SCpnt		= SCpnt;
 	cur_lunt->save_datp	= 0;
 	cur_lunt->msgin03	= FALSE;
 	data->cur_lunt		= cur_lunt;
 	data->cur_id		= SCpnt->device->id;
-	data->cur_lun		= SCpnt->device->lun;
+	data->cur_lun		= sdev_scsi2lun(SCpnt->device);
 
 	ret = nsp32_setup_sg_table(SCpnt);
 	if (ret == FALSE) {
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index e6e2a30..d790f4e 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -79,7 +79,7 @@ static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
 	struct ps3_storage_device *dev = priv->dev;
 
 	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %u, channel %u\n", __func__,
-		__LINE__, scsi_dev->id, scsi_dev->lun, scsi_dev->channel);
+		__LINE__, scsi_dev->id, sdev_scsi2lun(scsi_dev), scsi_dev->channel);
 
 	/*
 	 * ATAPI SFF8020 devices use MODE_SENSE_10,
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6d48d30..0422327 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -861,7 +861,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 	cmd->hdr.entry_cnt = 1;
 	cmd->hdr.entry_type = ENTRY_COMMAND;
 	cmd->target_id = Cmnd->device->id;
-	cmd->target_lun = Cmnd->device->lun;
+	cmd->target_lun = sdev_scsi2lun(Cmnd->device);
 	cmd->cdb_length = Cmnd->cmd_len;
 	cmd->control_flags = 0;
 	if (Cmnd->device->tagged_supported) {
@@ -1222,7 +1222,7 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
 	int i;
 
 	printk(KERN_WARNING "qlogicpti%d: Aborting cmd for tgt[%d] lun[%d]\n",
-	       qpti->qpti_id, (int)Cmnd->device->id, (int)Cmnd->device->lun);
+	       qpti->qpti_id, (int)Cmnd->device->id, sdev_scsi2lun(Cmnd->device));
 
 	qlogicpti_disable_irqs(qpti);
 
@@ -1235,7 +1235,7 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
 	cmd_cookie = i;
 
 	param[0] = MBOX_ABORT;
-	param[1] = (((u_short) Cmnd->device->id) << 8) | Cmnd->device->lun;
+	param[1] = (((u_short) Cmnd->device->id) << 8) | sdev_scsi2lun(Cmnd->device);
 	param[2] = cmd_cookie >> 16;
 	param[3] = cmd_cookie & 0xffff;
 	if (qlogicpti_mbox_command(qpti, param, 0) ||
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ce5b4e5..f56eb94 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -681,7 +681,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (cmd->device->scsi_level <= SCSI_2 &&
 	    cmd->device->scsi_level != SCSI_UNKNOWN) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
-			       (cmd->device->lun << 5 & 0xe0);
+			(sdev_scsi2lun(cmd->device) << 5 & 0xe0);
 	}
 
 	scsi_log_send(cmd);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1aa4bef..d7fcbdb 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -582,7 +582,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	host = cmd->device->host;
 	id = cmd->device->id;
-	lun = cmd->device->lun;
+	lun = sdev_scsi2lun(cmd->device);
 	hba = (struct st_hba *) &host->hostdata[0];
 
 	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 8822079..3c81d4a 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -355,17 +355,18 @@ static void __init init_tags( void )
 
 static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
+    u8 lun = sdev_scsi2lun(cmd->device);
     SETUP_HOSTDATA(cmd->device->host);
 
-    if (hostdata->busy[cmd->device->id] & (1 << cmd->device->lun))
+    if (hostdata->busy[cmd->device->id] & (1 << lun))
 	return( 1 );
     if (!should_be_tagged ||
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported)
 	return( 0 );
-    if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
-	TagAlloc[cmd->device->id][cmd->device->lun].queue_size ) {
+    if (TagAlloc[cmd->device->id][lun].nr_allocated >=
+	TagAlloc[cmd->device->id][lun].queue_size ) {
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d: no free tags\n",
-		    H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->device->id, lun );
 	return( 1 );
     }
     return( 0 );
@@ -379,6 +380,7 @@ static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 
 static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
+    u8 lun = sdev_scsi2lun(cmd->device);
     SETUP_HOSTDATA(cmd->device->host);
 
     /* If we or the target don't support tagged queuing, allocate the LUN for
@@ -387,19 +389,19 @@ static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
     if (!should_be_tagged ||
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 	cmd->tag = TAG_NONE;
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= (1 << lun);
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d now allocated by untagged "
-		    "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    "command\n", H_NO(cmd), cmd->device->id, lun );
     }
     else {
-	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 
 	cmd->tag = find_first_zero_bit( &ta->allocated, MAX_TAGS );
 	set_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated++;
 	dprintk(NDEBUG_TAGS,  "scsi%d: using tag %d for target %d lun %d "
 		    "(now %d tags in use)\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun,
+		    H_NO(cmd), cmd->tag, cmd->device->id, lun,
 		    ta->nr_allocated );
     }
 }
@@ -411,23 +413,24 @@ static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 
 static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
+    u8 lun = sdev_scsi2lun(cmd->device);
     SETUP_HOSTDATA(cmd->device->host);
 
     if (cmd->tag == TAG_NONE) {
-	hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] &= ~(1 << lun);
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d untagged cmd finished\n",
-		    H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->device->id, lun );
     }
     else if (cmd->tag >= MAX_TAGS) {
 	printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
 		H_NO(cmd), cmd->tag );
     }
     else {
-	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 	clear_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated--;
 	dprintk(NDEBUG_TAGS,  "scsi%d: freed tag %d for target %d lun %d\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->tag, cmd->device->id, lun );
     }
 }
 
@@ -660,7 +663,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
 	int i, s;
 	unsigned char *command;
 	printk("scsi%d: destination target %d, lun %d\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
+	       H_NO(cmd), cmd->device->id, sdev_scsi2lun(cmd->device));
 	printk(KERN_CONT "        command = ");
 	command = cmd->cmnd;
 	printk(KERN_CONT "%2d (0x%02x)", command[0], command[0]);
@@ -706,7 +709,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 	int i, s;
 	unsigned char *command;
 	seq_printf(m, "scsi%d: destination target %d, lun %d\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
+		   H_NO(cmd), cmd->device->id, sdev_scsi2lun(cmd->device));
 	seq_printf(m, "        command = ");
 	command = cmd->cmnd;
 	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
@@ -1007,14 +1010,18 @@ static void NCR5380_main (struct work_struct *bl)
 		 prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp) ) {
 
 		if (prev != tmp)
-			dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
+			dprintk(NDEBUG_LISTS,
+				"MAIN tmp=%p   target=%d   busy=%d lun=%d\n",
+				tmp, tmp->device->id,
+				hostdata->busy[tmp->device->id],
+				sdev_scsi2lun(tmp->device));
 		/*  When we find one, remove it from the issue queue. */
 		/* ++guenther: possible race with Falcon locking */
 		if (
 #ifdef SUPPORT_TAGS
 		    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
 #else
-		    !(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))
+		    !(hostdata->busy[tmp->device->id] & (1 << sdev_scsi2lun(tmp->device)))
 #endif
 		    ) {
 		    /* ++guenther: just to be sure, this must be atomic */
@@ -1038,8 +1045,8 @@ static void NCR5380_main (struct work_struct *bl)
 		     *   issue queue so we can keep trying.	
 		     */
 		    dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-				"lun %d removed from issue_queue\n",
-				HOSTNO, tmp->device->id, tmp->device->lun);
+			    "lun %d removed from issue_queue\n",
+			    HOSTNO, tmp->device->id, sdev_scsi2lun(tmp->device));
 		    /* 
 		     * REQUEST SENSE commands are issued without tagged
 		     * queueing, even on SCSI-II devices because the 
@@ -1589,7 +1596,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
 
     dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 	       HOSTNO, cmd->device->id);
-    tmp[0] = IDENTIFY(1, cmd->device->lun);
+    tmp[0] = IDENTIFY(1, sdev_scsi2lun(cmd->device));
 
 #ifdef SUPPORT_TAGS
     if (cmd->tag != TAG_NONE) {
@@ -1611,7 +1618,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
     /* XXX need to handle errors here */
     hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
-    hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+    hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 #endif    
 #ifdef SUN3_SCSI_VME
     dregs->csr |= CSR_INTR;
@@ -1909,6 +1916,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
     unsigned char *data;
     unsigned char phase, tmp, extended_msg[10], old_phase=0xff;
     struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
+    u8 lun = sdev_scsi2lun(cmd->device);
 
 #ifdef SUN3_SCSI_VME
     dregs->csr |= CSR_INTR;
@@ -2021,7 +2029,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			 * polled-IO. */ 
 			printk(KERN_NOTICE "scsi%d: switching target %d "
 			       "lun %d to slow handshake\n", HOSTNO,
-			       cmd->device->id, cmd->device->lun);
+			       cmd->device->id, lun);
 			cmd->device->borken = 1;
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | 
 			    ICR_ASSERT_ATN);
@@ -2079,7 +2087,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    
 		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
-			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
+			       "complete.\n", HOSTNO, cmd->device->id, lun);
 
 		    /* Enable reselect interrupts */
 		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -2092,7 +2100,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    if (!cmd->next_link) {
 			 printk(KERN_NOTICE "scsi%d: target %d lun %d "
 				"linked command complete, no next_link\n",
-				HOSTNO, cmd->device->id, cmd->device->lun);
+				HOSTNO, cmd->device->id, lun);
 			    sink = 1;
 			    do_abort (instance);
 			    return;
@@ -2105,7 +2113,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
 		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 			       "done, calling scsi_done().\n",
-			       HOSTNO, cmd->device->id, cmd->device->lun);
+			       HOSTNO, cmd->device->id, lun);
 #ifdef NCR5380_STATS
 		    collect_stats(hostdata, cmd);
 #endif
@@ -2119,7 +2127,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    hostdata->connected = NULL;
 		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
-			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
+			      "completed\n", HOSTNO, cmd->device->id, lun);
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
 		    if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
@@ -2131,16 +2139,16 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			 */
 			/* ++Andreas: the mid level code knows about
 			   QUEUE_FULL now. */
-			TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+			TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 				   "QUEUE_FULL after %d commands\n",
-				   HOSTNO, cmd->device->id, cmd->device->lun,
+				   HOSTNO, cmd->device->id, lun,
 				   ta->nr_allocated);
 			if (ta->queue_size > ta->nr_allocated)
 			    ta->nr_allocated = ta->queue_size;
 		    }
 #else
-		    hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		    hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 		    /* Enable reselect interrupts */
 		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -2226,12 +2234,12 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			 * the command is treated as untagged further on.
 			 */
 			cmd->device->tagged_supported = 0;
-			hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] |= (1 << lun);
 			cmd->tag = TAG_NONE;
 			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 				   "QUEUE_TAG message; tagged queuing "
 				   "disabled\n",
-				   HOSTNO, cmd->device->id, cmd->device->lun);
+				   HOSTNO, cmd->device->id, lun);
 			break;
 		    }
 		    break;
@@ -2248,7 +2256,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 			      "moved from connected to the "
 			      "disconnected_queue\n", HOSTNO, 
-			      cmd->device->id, cmd->device->lun);
+			      cmd->device->id, lun);
 		    /* 
 		     * Restore phase bits to 0 so an interrupted selection, 
 		     * arbitration can resume.
@@ -2350,13 +2358,13 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
 			       "message %02x from target %d, lun %d\n",
-			       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
+			       HOSTNO, tmp, cmd->device->id, lun);
 		    else
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
 			       "extended message "
 			       "code %02x, length %d from target %d, lun %d\n",
 			       HOSTNO, extended_msg[1], extended_msg[0],
-			       cmd->device->id, cmd->device->lun);
+			       cmd->device->id, lun);
    
 
 		    msgout = MESSAGE_REJECT;
@@ -2374,7 +2382,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
 #else
-		    hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		    hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 		    hostdata->connected = NULL;
 		    cmd->result = DID_ERROR << 16;
@@ -2493,7 +2501,8 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
 
     for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
 	 tmp; prev = tmp, tmp = NEXT(tmp) ) {
-	if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
+       if ((target_mask == (1 << tmp->device->id)) &&
+	   (lun == sdev_scsi2lun(tmp->device))
 #ifdef SUPPORT_TAGS
 	    && (tag == tmp->tag) 
 #endif
@@ -2577,7 +2586,7 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
     
     hostdata->connected = tmp;
     dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
-	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
+	    HOSTNO, tmp->device->id, sdev_scsi2lun(tmp->device), tmp->tag);
 }
 
 
@@ -2604,6 +2613,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
     SETUP_HOSTDATA(instance);
     struct scsi_cmnd *tmp, **prev;
     unsigned long flags;
+    u8 lun = sdev_scsi2lun(cmd->device);
 
     printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
     scsi_print_command(cmd);
@@ -2650,7 +2660,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 #ifdef SUPPORT_TAGS
 	  cmd_free_tag( cmd );
 #else
-	  hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+	  hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 	  local_irq_restore(flags);
 	  cmd->scsi_done(cmd);
@@ -2755,7 +2765,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( tmp );
 #else
-		    hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		    hostdata->busy[cmd->device->id] &= ~(1 << lun);
 #endif
 		    local_irq_restore(flags);
 		    tmp->scsi_done(tmp);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e59e6f9..2220684 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -313,7 +313,7 @@ static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
 	/*
 	 *  Select tagged/untagged.
 	 */
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, sdev_scsi2lun(sdev));
 	order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
 
 	/*
@@ -742,7 +742,8 @@ static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 	unsigned long flags;
 	int error;
 
-	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
+	if (sdev->id >= SYM_CONF_MAX_TARGET ||
+	    sdev_scsi2lun(sdev) >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
@@ -765,7 +766,7 @@ static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 	}
 
 	if (tp->usrflags & SYM_SCAN_LUNS_DISABLED) {
-		if (sdev->lun != 0) {
+		if (sdev_scsi2lun(sdev) != 0) {
 			error = -ENXIO;
 			goto out;
 		}
@@ -773,7 +774,7 @@ static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 				"Multiple LUNs disabled in NVRAM\n");
 	}
 
-	lp = sym_alloc_lcb(np, sdev->id, sdev->lun);
+	lp = sym_alloc_lcb(np, sdev->id, sdev_scsi2lun(sdev));
 	if (!lp) {
 		error = -ENOMEM;
 		goto out;
@@ -798,7 +799,7 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
-	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
+	struct sym_lcb *lp = sym_lp(tp, sdev_scsi2lun(sdev));
 	int reqtags, depth_to_use;
 
 	/*
@@ -824,7 +825,7 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 				sdev->tagged_supported ? MSG_SIMPLE_TAG : 0,
 				depth_to_use);
 	lp->s.scdev_depth = depth_to_use;
-	sym_tune_dev_queuing(tp, sdev->lun, reqtags);
+	sym_tune_dev_queuing(tp, sdev_scsi2lun(sdev), reqtags);
 
 	if (!spi_initial_dv(sdev->sdev_target))
 		spi_dv_device(sdev);
@@ -836,7 +837,7 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
-	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
+	struct sym_lcb *lp = sym_lp(tp, sdev_scsi2lun(sdev));
 	unsigned long flags;
 
 	/* if slave_alloc returned before allocating a sym_lcb, return */
@@ -851,11 +852,11 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 		 * so let's try to stop all on-going I/O.
 		 */
 		starget_printk(KERN_WARNING, tp->starget,
-			       "Removing busy LCB (%d)\n", (u8)sdev->lun);
+			       "Removing busy LCB (%d)\n", sdev_scsi2lun(sdev));
 		sym_reset_scsi_bus(np, 1);
 	}
 
-	if (sym_free_lcb(np, sdev->id, sdev->lun) == 0) {
+	if (sym_free_lcb(np, sdev->id, sdev_scsi2lun(sdev)) == 0) {
 		/*
 		 * It was the last unit for this target.
 		 */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 6b349e3..7204e51 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4650,7 +4650,7 @@ out_stuck:
 struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order)
 {
 	u_char tn = cmd->device->id;
-	u_char ln = cmd->device->lun;
+	u_char ln = sdev_scsi2lun(cmd->device);
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = sym_lp(tp, ln);
 	u_short tag = NO_TAG;
@@ -5159,14 +5159,14 @@ int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *
 	/*
 	 *  Retrieve the lun descriptor.
 	 */
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, sdev_scsi2lun(sdev));
 
 	can_disconnect = (cp->tag != NO_TAG) ||
 		(lp && (lp->curr_flags & SYM_DISC_ENABLED));
 
 	msgptr = cp->scsi_smsg;
 	msglen = 0;
-	msgptr[msglen++] = IDENTIFY(can_disconnect, sdev->lun);
+	msgptr[msglen++] = IDENTIFY(can_disconnect, sdev_scsi2lun(sdev));
 
 	/*
 	 *  Build the tag message if present.
@@ -5383,7 +5383,7 @@ void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
 	 *  Get target and lun pointers.
 	 */
 	tp = &np->target[cp->target];
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, sdev_scsi2lun(sdev));
 
 	/*
 	 *  Check for extended errors.
@@ -5414,7 +5414,7 @@ if (resid)
 	 *  not yet started by SCRIPTS.
 	 */
 	i = (INL(np, nc_scratcha) - np->squeue_ba) / 4;
-	i = sym_dequeue_from_squeue(np, i, cp->target, sdev->lun, -1);
+	i = sym_dequeue_from_squeue(np, i, cp->target, sdev_scsi2lun(sdev), -1);
 
 	/*
 	 *  Restart the SCRIPTS processor.
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index b006cf7..ea8b4c6 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -621,7 +621,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     {
 	dc390_freetag (pDCB, pSRB);
 	DEBUG0(printk ("DC390: Interrupt during Start SCSI (target %02i-%02i)\n",
-		scmd->device->id, scmd->device->lun));
+		       scmd->device->id, sdev_scsi2lun(scmd->device)));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
@@ -1726,7 +1726,9 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
-		DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+		DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n",
+				pcmd->cmnd[0], pcmd->device->id,
+				sdev_scsi2lun(pcmd->device)));
 		pSRB->TotalXferredLen = 0;
 		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	    }
@@ -1746,7 +1748,9 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	else if (status == SAM_STAT_TASK_SET_FULL)
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+	    DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n",
+			    pcmd->cmnd[0], pcmd->device->id,
+			    sdev_scsi2lun(pcmd->device)));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	}
@@ -2078,7 +2082,7 @@ static int dc390_slave_alloc(struct scsi_device *scsi_device)
 	struct dc390_acb *pACB = (struct dc390_acb*) scsi_device->host->hostdata;
 	struct dc390_dcb *pDCB, *pDCB2 = NULL;
 	uint id = scsi_device->id;
-	uint lun = scsi_device->lun;
+	uint lun = sdev_scsi2lun(scsi_device);
 
 	pDCB = kzalloc(sizeof(struct dc390_dcb), GFP_KERNEL);
 	if (!pDCB)
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5a03bb3..1ffede5 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1287,12 +1287,12 @@ static int u14_34f_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct
 
    if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d.\n",
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
-                        SCpnt->device->lun);
+                        sdev_scsi2lun(SCpnt->device));
 
    cpp->opcode = OP_SCSI;
    cpp->channel = SCpnt->device->channel;
    cpp->target = SCpnt->device->id;
-   cpp->lun = SCpnt->device->lun;
+   cpp->lun = sdev_scsi2lun(SCpnt->device);
    cpp->SCpnt = SCpnt;
    cpp->cdb_len = SCpnt->cmd_len;
    memcpy(cpp->cdb, SCpnt->cmnd, SCpnt->cmd_len);
@@ -1666,7 +1666,7 @@ static int reorder(unsigned int j, unsigned long cursec,
          printk("%s %d.%d:%d mb %d fc %d nr %d sec %ld ns %u"\
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
-                SCpnt->lun, k, flushcount, n_ready,
+                sdev_scsi2lun(SCpnt->device), k, flushcount, n_ready,
                 blk_rq_pos(SCpnt->request), blk_rq_sectors(SCpnt->request),
 		cursec, YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->xdir);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c28772..8a0e717 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -920,7 +920,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
-	lrbp->lun = cmd->device->lun;
+	lrbp->lun = sdev_scsi2lun(cmd->device);
 	lrbp->intr_cmd = false;
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
@@ -1976,7 +1976,7 @@ static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
 			 * Check if the outstanding command belongs
 			 * to the LUN which reported SAM_STAT_TASK_SET_FULL.
 			 */
-			if (cmd->device->lun == hba->lrb[i].lun)
+			if (sdev_scsi2lun(cmd->device) == hba->lrb[i].lun)
 				lun_qdepth++;
 		}
 	}
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 14e0c40..a34c297 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -735,7 +735,7 @@ static int ultrastor_queuecommand_lck(struct scsi_cmnd *SCpnt,
     my_mscp->ca = SCpnt->device->type != TYPE_TAPE;
     my_mscp->target_id = SCpnt->device->id;
     my_mscp->ch_no = 0;
-    my_mscp->lun = SCpnt->device->lun;
+    my_mscp->lun = sdev_scsi2lun(SCpnt->device);
     if (scsi_sg_count(SCpnt)) {
 	/* Set scatter/gather flag in SCSI command packet */
 	my_mscp->sg = TRUE;
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 41883a8..a9c2575 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -502,7 +502,8 @@ wd33c93_execute(struct Scsi_Host *instance)
 	cmd = (struct scsi_cmnd *) hostdata->input_Q;
 	prev = NULL;
 	while (cmd) {
-		if (!(hostdata->busy[cmd->device->id] & (1 << cmd->device->lun)))
+		if (!(hostdata->busy[cmd->device->id] &
+		      (1 << sdev_scsi2lun(cmd->device))))
 			break;
 		prev = cmd;
 		cmd = (struct scsi_cmnd *) cmd->host_scribble;
@@ -593,10 +594,10 @@ wd33c93_execute(struct Scsi_Host *instance)
 
 	write_wd33c93(regs, WD_SOURCE_ID, ((cmd->SCp.phase) ? SRCID_ER : 0));
 
-	write_wd33c93(regs, WD_TARGET_LUN, cmd->device->lun);
+	write_wd33c93(regs, WD_TARGET_LUN, sdev_scsi2lun(cmd->device));
 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
 		      hostdata->sync_xfer[cmd->device->id]);
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= (1 << sdev_scsi2lun(cmd->device));
 
 	if ((hostdata->level2 == L2_NONE) ||
 	    (hostdata->sync_stat[cmd->device->id] == SS_UNSET)) {
@@ -862,7 +863,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		}
 
 		cmd->result = DID_NO_CONNECT << 16;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
 
@@ -895,7 +896,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 
 		/* construct an IDENTIFY message with correct disconnect bit */
 
-		hostdata->outgoing_msg[0] = (0x80 | 0x00 | cmd->device->lun);
+		hostdata->outgoing_msg[0] = IDENTIFY(0, sdev_scsi2lun(cmd->device));
 		if (cmd->SCp.phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
@@ -1179,7 +1180,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			lun = read_wd33c93(regs, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
 			    hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 			hostdata->state = S_UNCONNECTED;
 			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
 				cmd->SCp.Status = lun;
@@ -1268,7 +1269,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		}
 		DB(DB_INTR, printk("UNEXP_DISC"))
 		    hostdata->connected = NULL;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->state = S_UNCONNECTED;
 		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
 			cmd->result =
@@ -1300,7 +1301,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		switch (hostdata->state) {
 		case S_PRE_CMP_DISC:
 			hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 			hostdata->state = S_UNCONNECTED;
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
 			    if (cmd->cmnd[0] == REQUEST_SENSE
@@ -1353,7 +1354,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			if (hostdata->selecting) {
 				cmd = (struct scsi_cmnd *) hostdata->selecting;
 				hostdata->selecting = NULL;
-				hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+				hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 				cmd->host_scribble =
 				    (uchar *) hostdata->input_Q;
 				hostdata->input_Q = cmd;
@@ -1365,7 +1366,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			if (cmd) {
 				if (phs == 0x00) {
 					hostdata->busy[cmd->device->id] &=
-					    ~(1 << cmd->device->lun);
+						~(1 << sdev_scsi2lun(cmd->device));
 					cmd->host_scribble =
 					    (uchar *) hostdata->input_Q;
 					hostdata->input_Q = cmd;
@@ -1448,7 +1449,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 		cmd = (struct scsi_cmnd *) hostdata->disconnected_Q;
 		patch = NULL;
 		while (cmd) {
-			if (id == cmd->device->id && lun == cmd->device->lun)
+			if (id == cmd->device->id &&
+			    lun == sdev_scsi2lun(cmd->device))
 				break;
 			patch = cmd;
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
@@ -1705,7 +1707,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		sr = read_wd33c93(regs, WD_SCSI_STATUS);
 		printk("asr=%02x, sr=%02x.", asr, sr);
 
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << sdev_scsi2lun(cmd->device));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
 		cmd->result = DID_ABORT << 16;
@@ -2170,7 +2172,8 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		if (hd->connected) {
 			cmd = (struct scsi_cmnd *) hd->connected;
 			seq_printf(m, " %d:%d(%02x)",
-				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				   cmd->device->id, sdev_scsi2lun(cmd->device),
+				   cmd->cmnd[0]);
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
@@ -2178,7 +2181,8 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
 			seq_printf(m, " %d:%d(%02x)",
-				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				   cmd->device->id, sdev_scsi2lun(cmd->device),
+				   cmd->cmnd[0]);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
@@ -2187,7 +2191,8 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
 			seq_printf(m, " %d:%d(%02x)",
-				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				   cmd->device->id, sdev_scsi2lun(cmd->device),
+				   cmd->cmnd[0]);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 3267423..56bf3bf 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1093,7 +1093,8 @@ static int wd7000_queuecommand_lck(struct scsi_cmnd *SCpnt,
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	cdblen = SCpnt->cmd_len;
-	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
+	idlun = ((SCpnt->device->id << 5) & 0xe0) |
+		(sdev_scsi2lun(SCpnt->device) & 7);
 	SCpnt->scsi_done = done;
 	SCpnt->SCp.phase = 1;
 	scb = alloc_scbs(SCpnt->device->host, 1);
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index c0a0e60..be0f91b 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -465,14 +465,14 @@ static int rtsx_control_thread(void *__dev)
 		else if (chip->srb->device->id) {
 			dev_err(&dev->pci->dev, "Bad target number (%d:%d)\n",
 				chip->srb->device->id,
-				chip->srb->device->lun);
+				sdev_scsi2lun(chip->srb->device));
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
 			dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
 				chip->srb->device->id,
-				chip->srb->device->lun);
+				sdev_scsi2lun(chip->srb->device));
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 816e8a2..e48c60d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -462,6 +462,11 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
 	return sdev->id;
 }
 
+static inline u8 sdev_scsi2lun(struct scsi_device *sdev)
+{
+	return (u8)(sdev->lun & 0xff);
+}
+
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
 
-- 
1.7.12.4

