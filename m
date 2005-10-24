From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 9/9] use scmd_id(), scmd_channel() throughout code
Date: Mon, 24 Oct 2005 18:05:09 -0400
Message-ID: <20051024220509.GI10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:53135 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751345AbVJXWFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:05:10 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 180441C0A7BA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:05:10 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM59e2010857
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:05:10 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 02fe57d2a30f420698743b6602c953f2ec3a9039
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 17:46:24 2005 -0400

    [SCSI] use scmd_id(), scmd_channel() throughout code
    
    Wrap a highly common idiom.  Makes the code easier to read, helps pave
    the way for sdev->{id,channel} removal, and adds a token that can easily
    by grepped-for in the future.
    
    There are a couple sdev_id() and scmd_printk() updates thrown in as well.

 drivers/scsi/53c700.c              |    6 +++---
 drivers/scsi/NCR5380.c             |   12 ++++++------
 drivers/scsi/NCR53C9x.c            |   16 ++++++++--------
 drivers/scsi/NCR53c406a.c          |    2 +-
 drivers/scsi/a100u2w.c             |    2 +-
 drivers/scsi/aacraid/aachba.c      |    6 +++---
 drivers/scsi/aha1740.c             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c |   11 ++++++-----
 drivers/scsi/aic7xxx/aic7xxx_osm.c |   10 +++++-----
 drivers/scsi/atp870u.c             |   22 +++++++++++-----------
 drivers/scsi/fd_mcs.c              |    4 ++--
 drivers/scsi/fdomain.c             |    4 ++--
 drivers/scsi/imm.c                 |    2 +-
 drivers/scsi/ips.c                 |   10 +++++-----
 drivers/scsi/ncr53c8xx.c           |    8 ++++----
 drivers/scsi/nsp32.c               |    8 ++++----
 drivers/scsi/pcmcia/nsp_cs.c       |   10 +++++-----
 drivers/scsi/pcmcia/sym53c500_cs.c |    2 +-
 drivers/scsi/ppa.c                 |    2 +-
 drivers/scsi/psi240i.c             |    2 +-
 drivers/scsi/qlogicfas408.c        |    4 ++--
 drivers/scsi/scsi_debug.c          |    2 +-
 drivers/scsi/scsi_error.c          |   16 +++++++++-------
 drivers/scsi/sym53c416.c           |    2 +-
 drivers/scsi/u14-34f.c             |   15 +++++++--------
 25 files changed, 91 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 523d2a9..e7ad269 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1427,7 +1427,7 @@ NCR_700_start_command(struct scsi_cmnd *
 	 * If a contingent allegiance condition exists, the device
 	 * will refuse all tags, so send the request sense as untagged
 	 * */
-	if((hostdata->tag_negotiated & (1<<SCp->device->id))
+	if((hostdata->tag_negotiated & (1<<scmd_id(SCp)))
 	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
 		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
 	}
@@ -1446,7 +1446,7 @@ NCR_700_start_command(struct scsi_cmnd *
 
 
 	script_patch_ID(hostdata->script,
-			Device_ID, 1<<SCp->device->id);
+			Device_ID, 1<<scmd_id(SCp));
 
 	script_patch_32_abs(hostdata->script, CommandAddress, 
 			    slot->pCmd);
@@ -2111,7 +2111,7 @@ static int NCR_700_change_queue_type(str
 		/* shift back to the default unqueued number of commands
 		 * (the user can still raise this) */
 		scsi_deactivate_tcq(SDp, SDp->host->cmd_per_lun);
-		hostdata->tag_negotiated &= ~(1 << SDp->id);
+		hostdata->tag_negotiated &= ~(1 << sdev_id(SDp));
 	} else {
 		/* Here, we cleared the negotiation flag above, so this
 		 * will force the driver to renegotiate */
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 4368767..cc9ecb3 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1247,13 +1247,13 @@ static void collect_stats(struct NCR5380
 	case WRITE:
 	case WRITE_6:
 	case WRITE_10:
-		hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
+		hostdata->time_write[scmd_id(cmd)] += (jiffies - hostdata->timebase);
 		hostdata->pendingw--;
 		break;
 	case READ:
 	case READ_6:
 	case READ_10:
-		hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
+		hostdata->time_read[scmd_id(cmd)] += (jiffies - hostdata->timebase);
 		hostdata->pendingr--;
 		break;
 	}
@@ -1385,7 +1385,7 @@ static int NCR5380_select(struct Scsi_Ho
 	 * the host and target ID's on the SCSI bus.
 	 */
 
-	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << cmd->device->id)));
+	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << scmd_id(cmd))));
 
 	/* 
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
@@ -1430,7 +1430,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, cmd->device->id));
+	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd)));
 
 	/* 
 	 * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1483,7 +1483,7 @@ part2:
 
 	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if (hostdata->targets_present & (1 << cmd->device->id)) {
+		if (hostdata->targets_present & (1 << scmd_id(cmd))) {
 			printk(KERN_DEBUG "scsi%d : weirdness\n", instance->host_no);
 			if (hostdata->restart_select)
 				printk(KERN_DEBUG "\trestart select\n");
@@ -1499,7 +1499,7 @@ part2:
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
-	hostdata->targets_present |= (1 << cmd->device->id);
+	hostdata->targets_present |= (1 << scmd_id(cmd));
 
 	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL 
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 6ceabbd..26146a4 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -936,7 +936,7 @@ static void esp_release_dmabufs(struct N
 
 static void esp_restore_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	struct esp_pointers *ep = &esp->data_pointers[scmd_id(sp)];
 
 	sp->SCp.ptr = ep->saved_ptr;
 	sp->SCp.buffer = ep->saved_buffer;
@@ -946,7 +946,7 @@ static void esp_restore_pointers(struct 
 
 static void esp_save_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	struct esp_pointers *ep = &esp->data_pointers[scmd_id(sp)];
 
 	ep->saved_ptr = sp->SCp.ptr;
 	ep->saved_buffer = sp->SCp.buffer;
@@ -1693,13 +1693,13 @@ static inline void esp_connect(struct NC
 	if(esp->prev_soff  != esp_dev->sync_max_offset ||
 	   esp->prev_stp   != esp_dev->sync_min_period ||
 	   (esp->erev > esp100a &&
-	    esp->prev_cfg3 != esp->config3[sp->device->id])) {
+	    esp->prev_cfg3 != esp->config3[scmd_id(sp)])) {
 		esp->prev_soff = esp_dev->sync_max_offset;
 		esp_write(eregs->esp_soff, esp->prev_soff);
 		esp->prev_stp = esp_dev->sync_min_period;
 		esp_write(eregs->esp_stp, esp->prev_stp);
 		if(esp->erev > esp100a) {
-			esp->prev_cfg3 = esp->config3[sp->device->id];
+			esp->prev_cfg3 = esp->config3[scmd_id(sp)];
 			esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 		} 
 	}
@@ -2205,7 +2205,7 @@ static int esp_do_freebus(struct NCR_ESP
 
 		if(SCptr->SCp.Status != GOOD &&
 		   SCptr->SCp.Status != CONDITION_GOOD &&
-		   ((1<<SCptr->device->id) & esp->targets_present) &&
+		   ((1<<scmd_id(SCptr)) & esp->targets_present) &&
 		   esp_dev->sync && esp_dev->sync_max_offset) {
 			/* SCSI standard says that the synchronous capabilities
 			 * should be renegotiated at this point.  Most likely
@@ -2597,7 +2597,7 @@ static int esp_select_complete(struct NC
 	 */
 	if(esp->ireg == (ESP_INTR_FDONE | ESP_INTR_BSERV)) {
 		/* target speaks... */
-		esp->targets_present |= (1<<SCptr->device->id);
+		esp->targets_present |= (1<<scmd_id(SCptr));
 
 		/* What if the target ignores the sdtr? */
 		if(esp->snip)
@@ -3064,7 +3064,7 @@ static int check_multibyte_msg(struct NC
 			ESPSDTR(("soff=%2x stp=%2x cfg3=%2x\n",
 				esp_dev->sync_max_offset,
 				esp_dev->sync_min_period,
-				esp->config3[SCptr->device->id]));
+				esp->config3[scmd_id(SCptr)]));
 
 			esp->snip = 0;
 		} else if(esp_dev->sync_max_offset) {
@@ -3621,7 +3621,7 @@ void esp_slave_destroy(Scsi_Device *SDpt
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SDptr->host->hostdata;
 
-	esp->targets_present &= ~(1 << SDptr->id);
+	esp->targets_present &= ~(1 << sdev_id(SDptr));
 	kfree(SDptr->hostdata);
 	SDptr->hostdata = NULL;
 }
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index e1f2246..1353769 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -710,7 +710,7 @@ static int NCR53c406a_queue(Scsi_Cmnd * 
 
 	/* We are locked here already by the mid layer */
 	REG0;
-	outb(SCpnt->device->id, DEST_ID);	/* set destination */
+	outb(scmd_id(SCpnt), DEST_ID);	/* set destination */
 	outb(FLUSH_FIFO, CMD_REG);	/* reset the fifos */
 
 	for (i = 0; i < SCpnt->cmd_len; i++) {
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index c34403c..9f45ae1 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -923,7 +923,7 @@ static int inia100_device_reset(struct s
 {				/* I need Host Control Block Information */
 	ORC_HCS *pHCB;
 	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
-	return orc_device_reset(pHCB, SCpnt, SCpnt->device->id);
+	return orc_device_reset(pHCB, SCpnt, scmd_id(SCpnt));
 
 }
 
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 93416f7..39b628b 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1541,7 +1541,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
-		if (scsicmd->device->id == host->this_id) {
+		if (scmd_id(scsicmd) == host->this_id) {
 			setinqstr(cardtype, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
@@ -1931,7 +1931,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(scsicmd->device->channel == 2)) {
+					(scmd_channel(scsicmd) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
@@ -1975,7 +1975,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(scsicmd->device->channel == 2)) {
+					(scmd_channel(scsicmd) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 73f33e7..8f85dcc 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -347,7 +347,7 @@ static int aha1740_queuecommand(Scsi_Cmn
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
-	unchar target = SCpnt->device->id;
+	unchar target = scmd_id(SCpnt);
 	struct aha1740_hostdata *host = HOSTDATA(SCpnt->device->host);
 	unsigned long flags;
 	void *buff = SCpnt->request_buffer;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 5e023dc..cfb46c2 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -398,7 +398,7 @@ ahd_linux_unmap_scb(struct ahd_softc *ah
 
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahd, cmd)						\
-	((((cmd)->device->id << TID_SHIFT) & TID) | (ahd)->our_id)
+	(((scmd_id(cmd) << TID_SHIFT) & TID) | (ahd)->our_id)
 
 /*
  * Return a string describing the driver.
@@ -685,7 +685,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		       ahd_name(ahd), cmd);
 #endif
 	ahd_lock(ahd, &s);
-	found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
+	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_unlock(ahd, &s);
 
@@ -2110,8 +2110,9 @@ ahd_linux_queue_recovery_cmd(struct scsi
 
 		/* Any SCB for this device will do for a target reset */
 		LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
-		  	if (ahd_match_scb(ahd, pending_scb, cmd->device->id,
-					  cmd->device->channel + 'A',
+		  	if (ahd_match_scb(ahd, pending_scb,
+					  scmd_id(cmd),
+					  scmd_channel(cmd) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2198,7 +2199,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	if (last_phase != P_BUSFREE
 	 && (SCB_GET_TAG(pending_scb) == active_scbptr
 	     || (flag == SCB_DEVICE_RESET
-		 && SCSIID_TARGET(ahd, saved_scsiid) == cmd->device->id))) {
+		 && SCSIID_TARGET(ahd, saved_scsiid) == scmd_id(cmd)))) {
 
 		/*
 		 * We're active on the bus, so assert ATN
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 7074ab9..1861407 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -686,7 +686,7 @@ ahc_linux_biosparam(struct scsi_device *
 	u_int	 channel;
 
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
-	channel = sdev->channel;
+	channel = sdev_channel(sdev);
 
 	bh = scsi_bios_ptable(bdev);
 	if (bh) {
@@ -759,7 +759,7 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	ahc_lock(ahc, &flags);
-	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
+	found = ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
 				  /*initiate reset*/TRUE);
 	ahc_unlock(ahc, &flags);
 
@@ -2172,8 +2172,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 
 		/* Any SCB for this device will do for a target reset */
 		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
-		  	if (ahc_match_scb(ahc, pending_scb, cmd->device->id,
-					  cmd->device->channel + 'A',
+		  	if (ahc_match_scb(ahc, pending_scb, scmd_id(cmd),
+					  scmd_channel(cmd) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2260,7 +2260,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	if (last_phase != P_BUSFREE
 	 && (pending_scb->hscb->tag == active_scb_index
 	  || (flag == SCB_DEVICE_RESET
-	   && SCSIID_TARGET(ahc, saved_scsiid) == cmd->device->id))) {
+	   && SCSIID_TARGET(ahc, saved_scsiid) == scmd_id(cmd)))) {
 
 		/*
 		 * We're active on the bus, so assert ATN
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b150bd8..5227a77 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -621,10 +621,10 @@ static int atp870u_queuecommand(struct s
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
 
-	c = req_p->device->channel;	
+	c = scmd_channel(req_p);
 	req_p->sense_buffer[0]=0;
 	req_p->resid = 0;
-	if (req_p->device->channel > 1) {
+	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
 		done(req_p);
 #ifdef ED_DBGP		
@@ -639,7 +639,7 @@ static int atp870u_queuecommand(struct s
 
 		
 	m = 1;
-	m = m << req_p->device->id;
+	m = m << scmd_id(req_p);
 
 	/*
 	 *      Fake a timeout for missing targets
@@ -757,9 +757,9 @@ static void send_s870(struct atp_unit *d
 		dev->quhd[c] = 0;
 	}
 	workreq = dev->quereq[c][dev->quhd[c]];
-	if (dev->id[c][workreq->device->id].curr_req == 0) {	
-		dev->id[c][workreq->device->id].curr_req = workreq;
-		dev->last_cmd[c] = workreq->device->id;
+	if (dev->id[c][scmd_id(workreq)].curr_req == 0) {	
+		dev->id[c][scmd_id(workreq)].curr_req = workreq;
+		dev->last_cmd[c] = scmd_id(workreq);
 		goto cmd_subp;
 	}	
 	dev->quhd[c] = j;
@@ -786,16 +786,16 @@ abortsnd:
 oktosend:
 #ifdef ED_DBGP
 	printk("OK to Send\n");
-	printk("CDB");
+	scmd_printk(KERN_DEBUG, workreq, "CDB");
 	for(i=0;i<workreq->cmd_len;i++) {
 		printk(" %x",workreq->cmnd[i]);
 	}
-	printk("\nChannel = %d ID = %d LUN = %d\n",c,workreq->device->id,workreq->device->lun);
+	printk("\n");
 #endif	
 	if (dev->dev_id == ATP885_DEVID) {
 		j = inb(dev->baseport + 0x29) & 0xfe;
 		outb(j, dev->baseport + 0x29);
-		dev->r1f[c][workreq->device->id] = 0;
+		dev->r1f[c][scmd_id(workreq)] = 0;
 	}
 	
 	if (workreq->cmnd[0] == READ_CAPACITY) {
@@ -809,7 +809,7 @@ oktosend:
 
 	tmport = workport + 0x1b;
 	j = 0;
-	target_id = workreq->device->id;
+	target_id = scmd_id(workreq);
 
 	/*
 	 *	Wide ?
@@ -3108,7 +3108,7 @@ static int atp870u_abort(struct scsi_cmn
 	host = SCpnt->device->host;
 
 	dev = (struct atp_unit *)&host->hostdata;
-	c=SCpnt->device->channel;
+	c = scmd_channel(SCpnt);
 	printk(" atp870u: abort Channel = %x \n", c);
 	printk("working=%x last_cmd=%x ", dev->working[c], dev->last_cmd[c]);
 	printk(" quhdu=%x quendu=%x ", dev->quhd[c], dev->quend[c]);
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index d59d449..6d44602 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -671,7 +671,7 @@ static irqreturn_t fd_mcs_intr(int irq, 
 		outb(0x40 | FIFO_COUNT, Interrupt_Cntl_port);
 
 		outb(0x82, SCSI_Cntl_port);	/* Bus Enable + Select */
-		outb(adapter_mask | (1 << current_SC->device->id), SCSI_Data_NoACK_port);
+		outb(adapter_mask | (1 << scmd_id(current_SC)), SCSI_Data_NoACK_port);
 
 		/* Stop arbitration and enable parity */
 		outb(0x10 | PARITY_MASK, TMC_Cntl_port);
@@ -683,7 +683,7 @@ static irqreturn_t fd_mcs_intr(int irq, 
 		status = inb(SCSI_Status_port);
 		if (!(status & 0x01)) {
 			/* Try again, for slow devices */
-			if (fd_mcs_select(shpnt, current_SC->device->id)) {
+			if (fd_mcs_select(shpnt, scmd_id(current_SC))) {
 #if EVERY_ACCESS
 				printk(" SFAIL ");
 #endif
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 3b2a5bf..7334244 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1154,7 +1154,7 @@ static irqreturn_t do_fdomain_16x0_intr(
       outb(0x40 | FIFO_COUNT, port_base + Interrupt_Cntl);
 
       outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
-      outb(adapter_mask | (1 << current_SC->device->id), port_base + SCSI_Data_NoACK);
+      outb(adapter_mask | (1 << scmd_id(current_SC)), port_base + SCSI_Data_NoACK);
       
       /* Stop arbitration and enable parity */
       outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
@@ -1166,7 +1166,7 @@ static irqreturn_t do_fdomain_16x0_intr(
       status = inb(port_base + SCSI_Status);
       if (!(status & 0x01)) {
 	 /* Try again, for slow devices */
-	 if (fdomain_select( current_SC->device->id )) {
+	 if (fdomain_select( scmd_id(current_SC) )) {
 #if EVERY_ACCESS
 	    printk( " SFAIL " );
 #endif
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 65e8456..fc0f30a 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -830,7 +830,7 @@ static int imm_engine(imm_struct *dev, s
 
 		/* Phase 2 - We are now talking to the scsi bus */
 	case 2:
-		if (!imm_select(dev, cmd->device->id)) {
+		if (!imm_select(dev, scmd_id(cmd))) {
 			imm_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 4cdd891..eeae7cc 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1125,8 +1125,8 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 		  SC->device->channel, SC->device->id, SC->device->lun);
 
 	/* Check for command to initiator IDs */
-	if ((SC->device->channel > 0)
-	    && (SC->device->id == ha->ha_id[SC->device->channel])) {
+	if ((scmd_channel(SC) > 0)
+	    && (scmd_id(SC) == ha->ha_id[scmd_channel(SC)])) {
 		SC->result = DID_NO_CONNECT << 16;
 		done(SC);
 
@@ -2830,10 +2830,10 @@ ips_next(ips_ha_t * ha, int intr)
 
 	p = ha->scb_waitlist.head;
 	while ((p) && (scb = ips_getscb(ha))) {
-		if ((p->device->channel > 0)
+		if ((scmd_channel(p) > 0)
 		    && (ha->
-			dcdb_active[p->device->channel -
-				    1] & (1 << p->device->id))) {
+			dcdb_active[scmd_channel(p) -
+				    1] & (1 << scmd_id(p)))) {
 			ips_freescb(ha, scb);
 			p = (Scsi_Cmnd *) p->host_scribble;
 			continue;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 519486d..8cf9a10 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -3669,7 +3669,7 @@ static int ncr_queue_command (struct ncb
 	/*
 	**	select
 	*/
-	cp->phys.select.sel_id		= sdev->id;
+	cp->phys.select.sel_id		= sdev_id(sdev);
 	cp->phys.select.sel_scntl3	= tp->wval;
 	cp->phys.select.sel_sxfer	= tp->sval;
 	/*
@@ -4820,7 +4820,7 @@ static void ncr_set_sync_wide_status (st
 	*/
 	for (cp = np->ccb; cp; cp = cp->link_ccb) {
 		if (!cp->cmd) continue;
-		if (cp->cmd->device->id != target) continue;
+		if (scmd_id(cp->cmd) != target) continue;
 #if 0
 		cp->sync_status = tp->sval;
 		cp->wide_status = tp->wval;
@@ -4844,7 +4844,7 @@ static void ncr_setsync (struct ncb *np,
 	u_char target = INB (nc_sdid) & 0x0f;
 	u_char idiv;
 
-	BUG_ON(target != (cmd->device->id & 0xf));
+	BUG_ON(target != (scmd_id(cmd) & 0xf));
 
 	tp = &np->target[target];
 
@@ -4902,7 +4902,7 @@ static void ncr_setwide (struct ncb *np,
 	u_char	scntl3;
 	u_char	sxfer;
 
-	BUG_ON(target != (cmd->device->id & 0xf));
+	BUG_ON(target != (scmd_id(cmd) & 0xf));
 
 	tp = &np->target[target];
 	tp->widedone  =  wide+1;
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 6367f00..e4ff4f0 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -481,7 +481,7 @@ static int nsp32_selection_autopara(stru
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
 	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	unsigned char	target  = scmd_id(SCpnt);
 	nsp32_autoparam *param  = data->autoparam;
 	unsigned char	phase;
 	int		i, ret;
@@ -612,7 +612,7 @@ static int nsp32_selection_autoscsi(stru
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
 	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	unsigned char	target  = scmd_id(SCpnt);
 	unsigned char	phase;
 	int		status;
 	unsigned short	command	= 0;
@@ -973,7 +973,7 @@ static int nsp32_queuecommand(struct scs
 	}
 
 	/* check target ID is not same as this initiator ID */
-	if (SCpnt->device->id == SCpnt->device->host->this_id) {
+	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
@@ -1028,7 +1028,7 @@ static int nsp32_queuecommand(struct scs
 	 * (target don't have SDTR_DONE and SDTR_INITIATOR), sync
 	 * message SDTR is needed to do synchronous transfer.
 	 */
-	target = &data->target[SCpnt->device->id];
+	target = &data->target[scmd_id(SCpnt)];
 	data->cur_target = target;
 
 	if (!(target->sync_flag & (SDTR_DONE | SDTR_INITIATOR | SDTR_TARGET))) {
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 3cd3b40..3d2f710 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -201,7 +201,7 @@ static int nsp_queuecommand(Scsi_Cmnd *S
 #ifdef NSP_DEBUG
 	/*unsigned int host_id = SCpnt->device->host->this_id;*/
 	/*unsigned int base    = SCpnt->device->host->io_port;*/
-	unsigned char target = SCpnt->device->id;
+	unsigned char target = scmd_id(SCpnt);
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -373,7 +373,7 @@ static int nsphw_start_selection(Scsi_Cm
 {
 	unsigned int  host_id	 = SCpnt->device->host->this_id;
 	unsigned int  base	 = SCpnt->device->host->io_port;
-	unsigned char target	 = SCpnt->device->id;
+	unsigned char target	 = scmd_id(SCpnt);
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	int	      time_out;
 	unsigned char phase, arbit;
@@ -452,7 +452,7 @@ static struct nsp_sync_table nsp_sync_ta
  */
 static int nsp_analyze_sdtr(Scsi_Cmnd *SCpnt)
 {
-	unsigned char	       target = SCpnt->device->id;
+	unsigned char	       target = scmd_id(SCpnt);
 //	unsigned char	       lun    = SCpnt->device->lun;
 	nsp_hw_data           *data   = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	sync_data	      *sync   = &(data->Sync[target]);
@@ -677,7 +677,7 @@ static int nsp_reselected(Scsi_Cmnd *SCp
 		target++;
 	}
 
-	if (SCpnt->device->id != target) {
+	if (scmd_id(SCpnt) != target) {
 		nsp_msg(KERN_ERR, "XXX: reselect ID must be %d in this implementation.", target);
 	}
 
@@ -912,7 +912,7 @@ static void nsp_pio_write(Scsi_Cmnd *SCp
 static int nsp_nexus(Scsi_Cmnd *SCpnt)
 {
 	unsigned int   base   = SCpnt->device->host->io_port;
-	unsigned char  target = SCpnt->device->id;
+	unsigned char  target = scmd_id(SCpnt);
 //	unsigned char  lun    = SCpnt->device->lun;
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	sync_data     *sync   = &(data->Sync[target]);
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index b4b3a1a..98b64b2 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -610,7 +610,7 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt,
 
 	/* We are locked here already by the mid layer */
 	REG0(port_base);
-	outb(SCpnt->device->id, port_base + DEST_ID);	/* set destination */
+	outb(scmd_id(SCpnt), port_base + DEST_ID);	/* set destination */
 	outb(FLUSH_FIFO, port_base + CMD_REG);	/* reset the fifos */
 
 	for (i = 0; i < SCpnt->cmd_len; i++) {
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index fafcf5d..05347ee 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -740,7 +740,7 @@ static int ppa_engine(ppa_struct *dev, s
 		}
 
 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
-		if (!ppa_select(dev, cmd->device->id)) {
+		if (!ppa_select(dev, scmd_id(cmd))) {
 			ppa_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 0f576d4..4322c95 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -659,7 +659,7 @@ static int Psi240i_BiosParam (struct scs
 	{
 	POUR_DEVICE	pdev;
 
-	pdev = &(HOSTDATA(sdev->host)->device[sdev->id]);
+	pdev = &(HOSTDATA(sdev->host)->device[sdev_id(sdev)]);
 
 	geom[0] = pdev->heads;
 	geom[1] = pdev->sectors;
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index cb75e0b..52fb2ec 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -243,7 +243,7 @@ static void ql_icmd(Scsi_Cmnd * cmd)
 	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
 	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
 /*	outb(0x99, qbase + 5);	*/
-	outb(cmd->device->id, qbase + 4);
+	outb(scmd_id(cmd), qbase + 4);
 
 	for (i = 0; i < cmd->cmd_len; i++)
 		outb(cmd->cmnd[i], qbase + 2);
@@ -450,7 +450,7 @@ irqreturn_t qlogicfas408_ihandl(int irq,
 int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
-	if (cmd->device->id == priv->qinitid) {
+	if (scmd_id(cmd) == priv->qinitid) {
 		cmd->result = DID_BAD_TARGET << 16;
 		done(cmd);
 		return 0;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index add190e..aadf051 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -283,7 +283,7 @@ int scsi_debug_queuecommand(struct scsi_
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int block, upper_blk, num, k;
 	int errsts = 0;
-	int target = SCpnt->device->id;
+	int target = scmd_id(SCpnt);
 	struct sdebug_dev_info * devip = NULL;
 	int inj_recovered = 0;
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bbb65ff..6d48c58 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1033,7 +1033,8 @@ static int scsi_try_bus_reset(struct scs
 		if (!scmd->device->host->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
+		scsi_report_bus_reset(scmd->device->host,
+				      scmd_channel(scmd));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1061,7 +1062,8 @@ static int scsi_try_host_reset(struct sc
 		if (!scmd->device->host->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
+		scsi_report_bus_reset(scmd->device->host,
+				      scmd_channel(scmd));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1091,7 +1093,7 @@ static int scsi_eh_bus_reset(struct Scsi
 	for (channel = 0; channel <= shost->max_channel; channel++) {
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (channel == scmd->device->channel) {
+			if (channel == scmd_channel(scmd)) {
 				chan_scmd = scmd;
 				break;
 				/*
@@ -1109,7 +1111,7 @@ static int scsi_eh_bus_reset(struct Scsi
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (channel == scmd->device->channel)
+				if (channel == scmd_channel(scmd))
 					if (!scsi_device_online(scmd->device) ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
@@ -1674,7 +1676,7 @@ void scsi_report_bus_reset(struct Scsi_H
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev->channel) {
+		if (channel == sdev_channel(sdev)) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
 		}
@@ -1709,8 +1711,8 @@ void scsi_report_device_reset(struct Scs
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev->channel &&
-		    target == sdev->id) {
+		if (channel == sdev_channel(sdev) &&
+		    target == sdev_id(sdev)) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
 		}
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index ef19adc..93dc7b6 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -773,7 +773,7 @@ int sym53c416_queuecommand(Scsi_Cmnd *SC
 	current_command->SCp.Message = 0;
 
 	spin_lock_irqsave(&sym53c416_lock, flags);
-	outb(SCpnt->device->id, base + DEST_BUS_ID); /* Set scsi id target        */
+	outb(scmd_id(SCpnt), base + DEST_BUS_ID); /* Set scsi id target        */
 	outb(FLUSH_FIFO, base + COMMAND_REG);    /* Flush SCSI and PIO FIFO's */
 	/* Write SCSI command into the SCSI fifo */
 	for(i = 0; i < SCpnt->cmd_len; i++)
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index e778e17..cfab8f1 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1822,7 +1822,7 @@ static irqreturn_t ihdlr(int irq, unsign
 
          /* If there was a bus reset, redo operation on each target */
          else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-                  && HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel])
+                  && HD(j)->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)])
             status = DID_BUS_BUSY << 16;
 
          /* Works around a flaw in scsi.c */
@@ -1835,29 +1835,28 @@ static irqreturn_t ihdlr(int irq, unsign
             status = DID_OK << 16;
 
          if (tstatus == GOOD)
-            HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel] = FALSE;
+            HD(j)->target_redo[scmd_id(SCpnt)][scmd_channel(SCpnt)] = FALSE;
 
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
                (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-            printk("%s: ihdlr, target %d.%d:%d, pid %ld, "\
-                   "target_status 0x%x, sense key 0x%x.\n", BN(j),
-                   SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
+            scmd_printk(KERN_INFO, SCpnt,
+	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
                    SCpnt->pid, spp->target_status,
                    SCpnt->sense_buffer[2]);
 
-         HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
+         HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
          if (HD(j)->last_retried_pid == SCpnt->pid) HD(j)->retries = 0;
 
          break;
       case ASST:     /* Selection Time Out */
 
-         if (HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
+         if (HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] > 1)
             status = DID_ERROR << 16;
          else {
             status = DID_TIME_OUT << 16;
-            HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel]++;
+            HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)]++;
             }
 
          break;
