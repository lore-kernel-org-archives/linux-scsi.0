From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 6/n] HCIL drivers update
Date: Sun, 23 Oct 2005 20:14:12 -0400
Message-ID: <20051024001412.GB21626@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:10474 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750835AbVJXAON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 20:14:13 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id A32BD1C09605
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 20:14:12 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O0ECMG021850
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 20:14:12 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


More driver work, cleaning up after sdev->{channel,id,lun} changes.

DO NOT APPLY.

 drivers/scsi/NCR5380.c      |   70 ++++++++++++++++++------------
 drivers/scsi/NCR53C9x.c     |  100 +++++++++++++++++++++++++-------------------
 drivers/scsi/NCR53c406a.c   |    2 
 drivers/scsi/cpqfcTSinit.c  |   12 +++--
 drivers/scsi/eata.c         |   88 +++++++++++++++++---------------------
 drivers/scsi/eata_pio.c     |   27 +++++++----
 drivers/scsi/g_NCR5380.c    |   14 +++---
 drivers/scsi/libata-scsi.c  |   12 ++---
 drivers/scsi/ncr53c8xx.c    |   75 ++++++++++++++++-----------------
 drivers/scsi/qla1280.c      |   16 +++----
 drivers/scsi/qlogicfas408.c |    4 -
 drivers/scsi/qlogicfc.c     |   21 ++++-----
 drivers/scsi/qlogicisp.c    |    4 -
 drivers/scsi/seagate.c      |   24 ++++++----
 drivers/scsi/sym53c416.c    |    2 
 drivers/scsi/wd7000.c       |    3 -
 16 files changed, 258 insertions(+), 216 deletions(-)

3b284cfbe9301b4d19620bd613acb99945cdf7d4
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d40ba0b..2de04d6 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -777,7 +777,9 @@ int NCR5380_proc_info(struct Scsi_Host *
 
 static char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	char lunstr[SCSILUN_STR_LEN];
+
+	SPRINTF("scsi%d : destination target %d, lun %s\n", cmd->device->host->host_no, sdev_id(cmd->device), scsilun_to_str(&cmd->device->lun, lunstr));
 	SPRINTF("        command = ");
 	pos = lprint_command(cmd->cmnd, pos, buffer, length);
 	return (pos);
@@ -976,15 +978,15 @@ static int NCR5380_queue_command(Scsi_Cm
 		case WRITE:
 		case WRITE_6:
 		case WRITE_10:
-			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;
+			hostdata->time_write[sdev_id(cmd->device)] -= (jiffies - hostdata->timebase);
+			hostdata->bytes_write[sdev_id(cmd->device)] += cmd->request_bufflen;
 			hostdata->pendingw++;
 			break;
 		case READ:
 		case READ_6:
 		case READ_10:
-			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;
+			hostdata->time_read[sdev_id(cmd->device)] -= (jiffies - hostdata->timebase);
+			hostdata->bytes_read[sdev_id(cmd->device)] += cmd->request_bufflen;
 			hostdata->pendingr++;
 			break;
 	}
@@ -1058,7 +1060,7 @@ static void NCR5380_main(void *p)
 				if (prev != tmp)
 					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->target, hostdata->busy[tmp->target], tmp->lun));
 				/*  When we find one, remove it from the issue queue. */
-				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
+				if (!(hostdata->busy[sdev_id(tmp->device)] & (1 << scsilun_to_int(&tmp->device->lun)))) {
 					if (prev) {
 						REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
 						prev->host_scribble = tmp->host_scribble;
@@ -1120,7 +1122,8 @@ static void NCR5380_main(void *p)
 				   this is needed for Mustek scanners, that
 				   do not respond to commands immediately
 				   after a scan */
-				printk(KERN_DEBUG "scsi%d: device %d did not respond in time\n", instance->host_no, tmp->device->id);
+				sdev_printk(KERN_DEBUG, tmp->device,
+					"device did not respond in time\n");
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 				hostdata->issue_queue = tmp;
@@ -1247,13 +1250,13 @@ static void collect_stats(struct NCR5380
 	case WRITE:
 	case WRITE_6:
 	case WRITE_10:
-		hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
+		hostdata->time_write[sdev_id(cmd->device)] += (jiffies - hostdata->timebase);
 		hostdata->pendingw--;
 		break;
 	case READ:
 	case READ_6:
 	case READ_10:
-		hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
+		hostdata->time_read[sdev_id(cmd->device)] += (jiffies - hostdata->timebase);
 		hostdata->pendingr--;
 		break;
 	}
@@ -1385,7 +1388,7 @@ static int NCR5380_select(struct Scsi_Ho
 	 * the host and target ID's on the SCSI bus.
 	 */
 
-	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << cmd->device->id)));
+	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << sdev_id(cmd->device))));
 
 	/* 
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
@@ -1430,7 +1433,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, cmd->device->id));
+	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, sdev_id(cmd->device)));
 
 	/* 
 	 * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1483,7 +1486,7 @@ part2:
 
 	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if (hostdata->targets_present & (1 << cmd->device->id)) {
+		if (hostdata->targets_present & (1 << sdev_id(cmd->device))) {
 			printk(KERN_DEBUG "scsi%d : weirdness\n", instance->host_no);
 			if (hostdata->restart_select)
 				printk(KERN_DEBUG "\trestart select\n");
@@ -1499,7 +1502,7 @@ part2:
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
-	hostdata->targets_present |= (1 << cmd->device->id);
+	hostdata->targets_present |= (1 << sdev_id(cmd->device));
 
 	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL 
@@ -1528,8 +1531,8 @@ part2:
 		goto failed;
 	}
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id));
-	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
+	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, sdev_id(cmd->device)));
+	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), &cmd->device->lun);
 
 	len = 1;
 	cmd->tag = 0;
@@ -1541,7 +1544,7 @@ part2:
 	dprintk(NDEBUG_SELECTION, ("scsi%d : nexus established.\n", instance->host_no));
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[sdev_id(cmd->device)] |= (1 << scsilun_to_int(&cmd->device->lun));
 
 	if (cmd->SCp.ptr != (char *)cmd->sense_buffer) {
 		initialize_SCp(cmd);
@@ -2105,6 +2108,9 @@ static void NCR5380_information_transfer
 	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
 	/* RvC: we need to set the end of the polling time */
 	unsigned long poll_time = jiffies + USLEEP_POLL;
+	char lunstr[SCSILUN_STR_LEN];
+
+	(void) lunstr; /* kill unused-var warning, if debug disabled */
 
 	NCR5380_setup(instance);
 
@@ -2190,7 +2196,9 @@ static void NCR5380_information_transfer
 						 * If the watchdog timer fires, all future accesses to this
 						 * device will use the polled-IO.
 						 */
-						printk("scsi%d : switching target %d lun %d to slow handshake\n", instance->host_no, cmd->device->id, cmd->device->lun);
+						sdev_printk(KERN_INFO,
+							    cmd->device,
+							    "switching to slow handshake\n");
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 						sink = 1;
@@ -2227,14 +2235,16 @@ static void NCR5380_information_transfer
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked command complete.\n", instance->host_no, sdev_id(cmd->device), cmd->device->lun));
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
 					 * available.
 					 */
 					if (!cmd->next_link) {
-						printk("scsi%d : target %d lun %d linked command complete, no next_link\n" instance->host_no, cmd->device->id, cmd->device->lun);
+						sdev_printk(KERN_INFO,
+							cmd->device,
+							"linked command complete, no next_link\n");
 						sink = 1;
 						do_abort(instance);
 						return;
@@ -2243,7 +2253,7 @@ static void NCR5380_information_transfer
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, sdev_id(cmd->device), cmd->device->lun));
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2255,8 +2265,8 @@ static void NCR5380_information_transfer
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, cmd->device->lun));
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d, lun %s completed\n", instance->host_no, sdev_id(cmd->device), scsilun_to_str(&cmd->device->lun, lunstr)));
+					hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 
 					/* 
 					 * I'm not sure what the correct thing to do here is : 
@@ -2324,7 +2334,7 @@ static void NCR5380_information_transfer
 					case ORDERED_QUEUE_TAG:
 					case SIMPLE_QUEUE_TAG:
 						cmd->device->simple_tags = 0;
-						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+						hostdata->busy[sdev_id(cmd->device)] |= (1 << scsilun_to_int(&cmd->device->lun));
 						break;
 					default:
 						break;
@@ -2338,7 +2348,7 @@ static void NCR5380_information_transfer
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun));
+						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, sdev_id(cmd->device), cmd->device->lun));
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2429,9 +2439,13 @@ static void NCR5380_information_transfer
 						scsi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
-						printk("scsi%d: rejecting unknown message %02x from target %d, lun %d\n", instance->host_no, tmp, cmd->device->id, cmd->device->lun);
+						sdev_printk(KERN_INFO,
+							cmd->device,
+							"rejecting unknown message %02x\n",tmp);
 					else
-						printk("scsi%d: rejecting unknown extended message code %02x, length %d from target %d, lun %d\n", instance->host_no, extended_msg[1], extended_msg[0], cmd->device->id, cmd->device->lun);
+						sdev_printk(KERN_INFO,
+							cmd->device,
+							"rejecting unknown extended message code %02x, length %d\n", extended_msg[1], extended_msg[0]);
 
 					msgout = MESSAGE_REJECT;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -2444,7 +2458,7 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
 					collect_stats(hostdata, cmd);
@@ -2580,7 +2594,7 @@ static void NCR5380_reselect(struct Scsi
 
 
 		for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble)
-			if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
+			if ((target_mask == (1 << sdev_id(tmp->device))) && (lun == scsilun_to_int(&tmp->device->lun))
 			    ) {
 				if (prev) {
 					REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 6ceabbd..63b02f2 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -352,12 +352,14 @@ static inline Scsi_Cmnd *remove_first_SC
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, int target, int lun)
+static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, int target,
+				const struct scsi_lun *lun)
 {
 	Scsi_Cmnd *ptr, *prev;
 
 	for(ptr = *SC, prev = NULL;
-	    ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
+	    ptr && ((sdev_id(ptr->device) != target) ||
+	    		(!scsilun_eq(&ptr->device->lun, lun)));
 	    prev = ptr, ptr = (Scsi_Cmnd *) ptr->host_scribble)
 		;
 	if(ptr) {
@@ -871,7 +873,7 @@ static int esp_host_info(struct NCR_ESP 
 
 	shost_for_each_device(sdev, esp->ehost) {
 		struct esp_device *esp_dev = sdev->hostdata;
-		uint id = sdev->id;
+		uint id = sdev_id(sdev);
 
 		if (!(esp->targets_present & (1 << id)))
 			continue;
@@ -936,7 +938,7 @@ static void esp_release_dmabufs(struct N
 
 static void esp_restore_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	struct esp_pointers *ep = &esp->data_pointers[sdev_id(sp->device)];
 
 	sp->SCp.ptr = ep->saved_ptr;
 	sp->SCp.buffer = ep->saved_buffer;
@@ -946,7 +948,7 @@ static void esp_restore_pointers(struct 
 
 static void esp_save_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	struct esp_pointers *ep = &esp->data_pointers[sdev_id(sp->device)];
 
 	ep->saved_ptr = sp->SCp.ptr;
 	ep->saved_buffer = sp->SCp.buffer;
@@ -1009,7 +1011,8 @@ static void esp_exec_cmd(struct NCR_ESP 
 	Scsi_Device *SDptr;
 	volatile unchar *cmdp = esp->esp_command;
 	unsigned char the_esp_command;
-	int lun, target;
+	int target;
+	const struct scsi_lun *lun;
 	int i;
 
 	/* Hold off if we have disconnected commands and
@@ -1027,8 +1030,8 @@ static void esp_exec_cmd(struct NCR_ESP 
 
 	SDptr = SCptr->device;
 	esp_dev = SDptr->hostdata;
-	lun = SCptr->device->lun;
-	target = SCptr->device->id;
+	lun = &SCptr->device->lun;
+	target = sdev_id(SCptr->device);
 
 	esp->snip = 0;
 	esp->msgout_len = 0;
@@ -1163,7 +1166,7 @@ do_sync_known:
 		if(((SDptr->scsi_level < 3) && (SDptr->type != TYPE_TAPE)) ||
 		   toshiba_cdrom_hwbug_wkaround || SDptr->borken) {
 			ESPMISC((KERN_INFO "esp%d: Disabling DISCONNECT for target %d "
-				 "lun %d\n", esp->esp_id, SCptr->device->id, SCptr->device->lun));
+				 "lun %d\n", esp->esp_id, sdev_id(SCptr->device), SCptr->device->lun));
 			esp_dev->disconnect = 0;
 			*cmdp++ = IDENTIFY(0, lun);
 		} else {
@@ -1245,8 +1248,8 @@ int esp_queue(Scsi_Cmnd *SCpnt, void (*d
 		esp->dma_led_on(esp);
 
 	/* We use the scratch area. */
-	ESPQUEUE(("esp_queue: target=%d lun=%d ", SCpnt->device->id, SCpnt->lun));
-	ESPDISC(("N<%02x,%02x>", SCpnt->device->id, SCpnt->lun));
+	ESPQUEUE(("esp_queue: target=%d lun=%d ", sdev_id(SCpnt->device), SCpnt->lun));
+	ESPDISC(("N<%02x,%02x>", sdev_id(SCpnt->device), SCpnt->lun));
 
 	esp_get_dmabufs(esp, SCpnt);
 	esp_save_pointers(esp, SCpnt); /* FIXME for tag queueing */
@@ -1274,9 +1277,12 @@ int esp_queue(Scsi_Cmnd *SCpnt, void (*d
 /* Dump driver state. */
 static void esp_dump_cmd(Scsi_Cmnd *SCptr)
 {
-	ESPLOG(("[tgt<%02x> lun<%02x> "
+	char lunstr[SCSILUN_STR_LEN];
+
+	ESPLOG(("[tgt<%02x> lun<%s> "
 		"pphase<%s> cphase<%s>]",
-		SCptr->device->id, SCptr->device->lun,
+		sdev_id(SCptr->device),
+		scsilun_to_str(&SCptr->device->lun, lunstr),
 		phase_string(SCptr->SCp.sent_command),
 		phase_string(SCptr->SCp.phase)));
 }
@@ -1693,13 +1699,13 @@ static inline void esp_connect(struct NC
 	if(esp->prev_soff  != esp_dev->sync_max_offset ||
 	   esp->prev_stp   != esp_dev->sync_min_period ||
 	   (esp->erev > esp100a &&
-	    esp->prev_cfg3 != esp->config3[sp->device->id])) {
+	    esp->prev_cfg3 != esp->config3[sdev_id(sp->device)])) {
 		esp->prev_soff = esp_dev->sync_max_offset;
 		esp_write(eregs->esp_soff, esp->prev_soff);
 		esp->prev_stp = esp_dev->sync_min_period;
 		esp_write(eregs->esp_stp, esp->prev_stp);
 		if(esp->erev > esp100a) {
-			esp->prev_cfg3 = esp->config3[sp->device->id];
+			esp->prev_cfg3 = esp->config3[sdev_id(sp->device)];
 			esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 		} 
 	}
@@ -2097,7 +2103,7 @@ static int esp_do_data_finale(struct NCR
 			esp->esp_id,
 			SCptr->use_sg, SCptr->SCp.ptr, SCptr->SCp.this_residual));
 		ESPLOG(("esp%d: Forcing async for target %d\n", esp->esp_id, 
-			SCptr->device->id));
+			sdev_id(SCptr->device)));
 		SCptr->device->borken = 1;
 		esp_dev->sync = 0;
 		bytes_sent = 0;
@@ -2205,7 +2211,7 @@ static int esp_do_freebus(struct NCR_ESP
 
 		if(SCptr->SCp.Status != GOOD &&
 		   SCptr->SCp.Status != CONDITION_GOOD &&
-		   ((1<<SCptr->device->id) & esp->targets_present) &&
+		   ((1<<sdev_id(SCptr->device)) & esp->targets_present) &&
 		   esp_dev->sync && esp_dev->sync_max_offset) {
 			/* SCSI standard says that the synchronous capabilities
 			 * should be renegotiated at this point.  Most likely
@@ -2215,7 +2221,7 @@ static int esp_do_freebus(struct NCR_ESP
 			 * state.
 			 */
 			ESPMISC(("esp: Status <%d> for target %d lun %d\n",
-				 SCptr->SCp.Status, SCptr->device->id, SCptr->device->lun));
+				 SCptr->SCp.Status, sdev_id(SCptr->device), SCptr->device->lun));
 
 			/* But don't do this when spinning up a disk at
 			 * boot time while we poll for completion as it
@@ -2226,14 +2232,14 @@ static int esp_do_freebus(struct NCR_ESP
 			if(esp_should_clear_sync(SCptr) != 0)
 				esp_dev->sync = 0;
 		}
-		ESPDISC(("F<%02x,%02x>", SCptr->device->id, SCptr->device->lun));
+		ESPDISC(("F<%02x,%02x>", sdev_id(SCptr->device), SCptr->device->lun));
 		esp_done(esp, ((SCptr->SCp.Status & 0xff) |
 			       ((SCptr->SCp.Message & 0xff)<<8) |
 			       (DID_OK << 16)));
 	} else if(esp->prevmsgin == DISCONNECT) {
 		/* Normal disconnect. */
 		esp_cmd(esp, eregs, ESP_CMD_ESEL);
-		ESPDISC(("D<%02x,%02x>", SCptr->device->id, SCptr->device->lun));
+		ESPDISC(("D<%02x,%02x>", sdev_id(SCptr->device), SCptr->device->lun));
 		append_SC(&esp->disconnected_SC, SCptr);
 		esp->current_SC = NULL;
 		if(esp->issue_SC)
@@ -2256,6 +2262,7 @@ static int esp_do_freebus(struct NCR_ESP
 static int esp_bad_reconnect(struct NCR_ESP *esp)
 {
 	Scsi_Cmnd *sp;
+	char lunstr[SCSILUN_STR_LEN];
 
 	ESPLOG(("esp%d: Eieeee, reconnecting unknown command!\n",
 		esp->esp_id));
@@ -2263,21 +2270,24 @@ static int esp_bad_reconnect(struct NCR_
 	sp = esp->issue_SC;
 	ESPLOG(("esp%d: issue_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
+		ESPLOG(("<%02x,%s>", sdev_id(sp->device),
+			scsilun_to_str(&sp->device->lun, lunstr)));
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->current_SC;
 	ESPLOG(("esp%d: current_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
+		ESPLOG(("<%02x,%s>", sdev_id(sp->device),
+			scsilun_to_str(&sp->device->lun, lunstr)));
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->disconnected_SC;
 	ESPLOG(("esp%d: disconnected_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
+		ESPLOG(("<%02x,%s>", sdev_id(sp->device),
+			scsilun_to_str(&sp->device->lun, lunstr)));
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
@@ -2290,6 +2300,7 @@ static int esp_do_reconnect(struct NCR_E
 {
 	int lun, target;
 	Scsi_Cmnd *SCptr;
+	struct scsi_lun __lun;
 
 	/* Check for all bogus conditions first. */
 	target = reconnect_target(esp, eregs);
@@ -2311,7 +2322,8 @@ static int esp_do_reconnect(struct NCR_E
 		return do_reset_bus;
 	esp_cmd(esp, eregs, ESP_CMD_NULL);
 
-	SCptr = remove_SC(&esp->disconnected_SC, (unchar) target, (unchar) lun);
+	int_to_scsilun(lun, &__lun);
+	SCptr = remove_SC(&esp->disconnected_SC, (unchar) target, &__lun);
 	if(!SCptr)
 		return esp_bad_reconnect(esp);
 
@@ -2597,7 +2609,7 @@ static int esp_select_complete(struct NC
 	 */
 	if(esp->ireg == (ESP_INTR_FDONE | ESP_INTR_BSERV)) {
 		/* target speaks... */
-		esp->targets_present |= (1<<SCptr->device->id);
+		esp->targets_present |= (1<<sdev_id(SCptr->device));
 
 		/* What if the target ignores the sdtr? */
 		if(esp->snip)
@@ -2626,7 +2638,7 @@ static int esp_select_complete(struct NC
 			 * XXX for synchronous transfers.
 			 */
 			ESPLOG(("esp%d: STEP_ASEL for tgt %d\n",
-				esp->esp_id, SCptr->device->id));
+				esp->esp_id, sdev_id(SCptr->device)));
 
 		case ESP_STEP_SID:
 			/* Arbitration won, target selected, went
@@ -2732,6 +2744,8 @@ static int esp_select_complete(struct NC
 
 	/* Did the target even make it? */
 	if(esp->ireg == ESP_INTR_DC) {
+		char lunstr[SCSILUN_STR_LEN];
+
 		/* wheee... nobody there or they didn't like
 		 * what we told it to do, clean up.
 		 */
@@ -2743,14 +2757,16 @@ static int esp_select_complete(struct NC
 		if(esp->disconnected_SC)
 			esp_cmd(esp, eregs, ESP_CMD_ESEL);
 
-		if(((1<<SCptr->device->id) & esp->targets_present) &&
+		if(((1<<sdev_id(SCptr->device)) & esp->targets_present) &&
 		   esp->seqreg && esp->cur_msgout[0] == EXTENDED_MESSAGE &&
 		   (SCptr->SCp.phase == in_slct_msg ||
 		    SCptr->SCp.phase == in_slct_stop)) {
 			/* shit */
 			esp->snip = 0;
 			ESPLOG(("esp%d: Failed synchronous negotiation for target %d "
-				"lun %d\n", esp->esp_id, SCptr->device->id, SCptr->device->lun));
+				"lun %s\n", esp->esp_id,
+				sdev_id(SCptr->device),
+				scsilun_to_str(&SCptr->device->lun, lunstr)));
 			esp_dev->sync_max_offset = 0;
 			esp_dev->sync_min_period = 0;
 			esp_dev->sync = 1; /* so we don't negotiate again */
@@ -2776,9 +2792,9 @@ static int esp_select_complete(struct NC
 		 * or whenever when we are scanning the bus for targets.
 		 * But first make sure that is really what is happening.
 		 */
-		if(((1<<SCptr->device->id) & esp->targets_present)) {
+		if(((1<<sdev_id(SCptr->device)) & esp->targets_present)) {
 			ESPLOG(("esp%d: Warning, live target %d not responding to "
-				"selection.\n", esp->esp_id, SCptr->device->id));
+				"selection.\n", esp->esp_id, sdev_id(SCptr->device)));
 
 			/* This _CAN_ happen.  The SCSI standard states that
 			 * the target is to _not_ respond to selection if
@@ -2791,7 +2807,7 @@ static int esp_select_complete(struct NC
 			/* Else, there really isn't anyone there. */
 			ESPMISC(("esp: selection failure, maybe nobody there?\n"));
 			ESPMISC(("esp: target %d lun %d\n",
-				 SCptr->device->id, SCptr->device->lun));
+				 sdev_id(SCptr->device), SCptr->device->lun));
 			esp_done(esp, (DID_BAD_TARGET << 16));
 		}
 		return do_intr_end;
@@ -2872,7 +2888,7 @@ static int check_singlebyte_msg(struct N
 
 	case NOP:
 		ESPLOG(("esp%d: target %d sends a nop\n", esp->esp_id,
-			esp->current_SC->device->id));
+			sdev_id(esp->current_SC->device)));
 		return 0;
 
 	case RESTORE_POINTERS:
@@ -2965,7 +2981,7 @@ static void sync_report(struct NCR_ESP *
 		 * sibling call optimization.  -DaveM
 		 */
 		ESPLOG((KERN_INFO "esp%d: target %d ",
-			esp->esp_id, esp->current_SC->device->id));
+			esp->esp_id, sdev_id(esp->current_SC->device)));
 		ESPLOG(("[period %dns offset %d %d.%02dMHz ",
 			(int) msg3 * 4, (int) msg4,
 			integer, fraction));
@@ -2973,7 +2989,7 @@ static void sync_report(struct NCR_ESP *
 			(((msg3 * 4) < 200) ? "-II" : "")));
 	} else {
 		ESPLOG((KERN_INFO "esp%d: target %d asynchronous\n",
-			esp->esp_id, esp->current_SC->device->id));
+			esp->esp_id, sdev_id(esp->current_SC->device)));
 	}
 }
 
@@ -3050,10 +3066,10 @@ static int check_multibyte_msg(struct NC
 				else
 					bit = ESP_CONFIG3_FSCSI;
 				if(period < 50)
-					esp->config3[SCptr->device->id] |= bit;
+					esp->config3[sdev_id(SCptr->device)] |= bit;
 				else
-					esp->config3[SCptr->device->id] &= ~bit;
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
+					esp->config3[sdev_id(SCptr->device)] &= ~bit;
+				esp->prev_cfg3 = esp->config3[sdev_id(SCptr->device)];
 				esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 			}
 			esp->prev_soff = esp_dev->sync_min_period;
@@ -3064,7 +3080,7 @@ static int check_multibyte_msg(struct NC
 			ESPSDTR(("soff=%2x stp=%2x cfg3=%2x\n",
 				esp_dev->sync_max_offset,
 				esp_dev->sync_min_period,
-				esp->config3[SCptr->device->id]));
+				esp->config3[sdev_id(SCptr->device)]));
 
 			esp->snip = 0;
 		} else if(esp_dev->sync_max_offset) {
@@ -3083,8 +3099,8 @@ static int check_multibyte_msg(struct NC
 					bit = ESP_CONFIG3_FAST;
 				else
 					bit = ESP_CONFIG3_FSCSI;
-				esp->config3[SCptr->device->id] &= ~bit;
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
+				esp->config3[sdev_id(SCptr->device)] &= ~bit;
+				esp->prev_cfg3 = esp->config3[sdev_id(SCptr->device)];
 				esp_write(eregs->esp_cfg3, esp->prev_cfg3);
 			}
 		}
@@ -3473,7 +3489,7 @@ void esp_handle(struct NCR_ESP *esp)
 			 * a nexus is alive on the bus.
 			 */
 			ESPLOG(("esp%d: Forcing async and disabling disconnect for "
-				"target %d\n", esp->esp_id, SCptr->device->id));
+				"target %d\n", esp->esp_id, sdev_id(SCptr->device)));
 			SCptr->device->borken = 1; /* foo on you */
 		}
 
@@ -3621,7 +3637,7 @@ void esp_slave_destroy(Scsi_Device *SDpt
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SDptr->host->hostdata;
 
-	esp->targets_present &= ~(1 << SDptr->id);
+	esp->targets_present &= ~(1 << sdev_id(SDptr));
 	kfree(SDptr->hostdata);
 	SDptr->hostdata = NULL;
 }
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index e1f2246..dc44e85 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -710,7 +710,7 @@ static int NCR53c406a_queue(Scsi_Cmnd * 
 
 	/* We are locked here already by the mid layer */
 	REG0;
-	outb(SCpnt->device->id, DEST_ID);	/* set destination */
+	outb(sdev_id(SCpnt->device), DEST_ID);	/* set destination */
 	outb(FLUSH_FIFO, CMD_REG);	/* reset the fifos */
 
 	for (i = 0; i < SCpnt->cmd_len; i++) {
diff --git a/drivers/scsi/cpqfcTSinit.c b/drivers/scsi/cpqfcTSinit.c
index 3fda8d4..7ec54d1 100644
--- a/drivers/scsi/cpqfcTSinit.c
+++ b/drivers/scsi/cpqfcTSinit.c
@@ -974,9 +974,11 @@ int cpqfcTS_proc_info (struct Scsi_Host 
   }
   copy_info(&info, "WWN database: (\"port_id: 000000\" means disconnected)\n");
   for ( Chan=0; Chan <= host->max_channel; Chan++) {
-    DumCmnd->device->channel = Chan;
+    /* FIXME XXX is this right? */
+    DumCmnd->device->sdev_target->channel = Chan;
     for (Targ=0; Targ <= host->max_id; Targ++) {
-      DumCmnd->device->id = Targ;
+      /* FIXME XXX is this right? */
+      DumCmnd->device->sdev_target->id = Targ;
       if ((pLoggedInPort = fcFindLoggedInPort( fcChip,
 	    			DumCmnd,  // search Scsi Nexus
     				0,        // DON'T search list for FC port id
@@ -1368,9 +1370,11 @@ int cpqfcTS_queuecommand(Scsi_Cmnd *Cmnd
 //    printk(" @Q bad targ cmnd %p@ ", Cmnd);
       QueBadTargetCmnd( cpqfcHBAdata, Cmnd);
     }
-    else if (Cmnd->device->lun >= CPQFCTS_MAX_LUN)
+    else if (scsilun_to_int(&Cmnd->device->lun) >= CPQFCTS_MAX_LUN)
     {
-      printk(KERN_WARNING "cpqfc: Invalid LUN: %d\n", Cmnd->device->lun);
+      char lunstr[SCSILUN_STR_LEN];
+      printk(KERN_WARNING "cpqfc: Invalid LUN: %s\n",
+      		scsilun_to_str(&Cmnd->device->lun, lunstr));
       QueBadTargetCmnd( cpqfcHBAdata, Cmnd);
     } 
 
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index c10e45b..c76a9f0 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -941,8 +941,6 @@ static int eata2x_slave_configure(struct
 {
 	int tqd, utqd;
 	char *tag_suffix, *link_suffix;
-	struct Scsi_Host *shost = dev->host;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
 	utqd = MAX_CMD_PER_LUN;
 	tqd = max_queue_depth;
@@ -973,8 +971,8 @@ static int eata2x_slave_configure(struct
 	else
 		link_suffix = "";
 
-	printk("%s: scsi%d, channel %d, id %d, lun %d, cmds/lun %d%s%s.\n",
-	       ha->board_name, shost->host_no, dev->channel, dev->id, dev->lun,
+	sdev_printk(KERN_INFO, dev,
+		"cmds/lun %d%s%s.\n",
 	       dev->queue_depth, link_suffix, tag_suffix);
 
 	return 0;
@@ -1813,9 +1811,9 @@ static int eata2x_queuecommand(struct sc
 	SCpnt->host_scribble = (unsigned char *)&cpp->cpp_index;
 
 	if (do_trace)
-		printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
-		       ha->board_name, i, SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid);
+		sdev_printk(KERN_INFO, SCpnt->device,
+			"qcomm, mbox %d, pid %ld.\n",
+		       i, SCpnt->pid);
 
 	cpp->reqsen = 1;
 	cpp->dispri = 1;
@@ -1824,9 +1822,9 @@ static int eata2x_queuecommand(struct sc
 		cpp->hbaci = 1;
 #endif
 	cpp->one = 1;
-	cpp->channel = SCpnt->device->channel;
-	cpp->target = SCpnt->device->id;
-	cpp->lun = SCpnt->device->lun;
+	cpp->channel = sdev_channel(SCpnt->device);
+	cpp->target = sdev_id(SCpnt->device);
+	cpp->lun = scsilun_to_int(&SCpnt->device->lun);
 	cpp->SCpnt = SCpnt;
 	memcpy(cpp->cdb, SCpnt->cmnd, SCpnt->cmd_len);
 
@@ -1847,9 +1845,9 @@ static int eata2x_queuecommand(struct sc
 	if (do_dma(shost->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
-		printk("%s: qcomm, target %d.%d:%d, pid %ld, adapter busy.\n",
-		       ha->board_name, SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid);
+		sdev_printk(KERN_INFO, SCpnt->device,
+			"qcomm, pid %ld, adapter busy.\n",
+		       SCpnt->pid);
 		return 1;
 	}
 
@@ -1864,16 +1862,16 @@ static int eata2x_eh_abort(struct scsi_c
 	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
-		printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
-		       ha->board_name, SCarg->device->channel, SCarg->device->id,
-		       SCarg->device->lun, SCarg->pid);
+		sdev_printk(KERN_INFO, SCarg->device,
+			"abort, pid %ld inactive.\n",
+		       SCarg->pid);
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
-	printk("%s: abort, mbox %d, target %d.%d:%d, pid %ld.\n",
-	       ha->board_name, i, SCarg->device->channel, SCarg->device->id,
-	       SCarg->device->lun, SCarg->pid);
+	sdev_printk(KERN_WARNING, SCarg->device,
+		"abort, mbox %d, pid %ld.\n",
+	       i, SCarg->pid);
 
 	if (i >= shost->can_queue)
 		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
@@ -1934,9 +1932,9 @@ static int eata2x_eh_host_reset(struct s
 	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
-	       ha->board_name, SCarg->device->channel, SCarg->device->id,
-	       SCarg->device->lun, SCarg->pid);
+	sdev_printk(KERN_INFO, SCarg->device,
+		"reset, enter, pid %ld.\n",
+	       SCarg->pid);
 
 	spin_lock_irq(shost->host_lock);
 
@@ -2253,12 +2251,11 @@ static int reorder(struct hostdata *ha, 
 			k = il[n];
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
-			printk
-			    ("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %ld"
+			sdev_printk(KERN_INFO, SCpnt->device,
+			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %ld"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->device->channel, SCpnt->device->id,
-			     SCpnt->device->lun, SCpnt->pid, k, flushcount,
+			     SCpnt->pid, k, flushcount,
 			     n_ready, SCpnt->request->sector,
 			     SCpnt->request->nr_sectors, cursec, YESNO(s),
 			     YESNO(r), YESNO(rev), YESNO(input_only),
@@ -2301,12 +2298,11 @@ static void flush_dev(struct scsi_device
 		SCpnt = cpp->SCpnt;
 
 		if (do_dma(dev->host->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
-			printk
-			    ("%s: %s, target %d.%d:%d, pid %ld, mbox %d, adapter"
-			     " busy, will abort.\n", ha->board_name,
+			sdev_printk(KERN_INFO, SCpnt->device,
+			    "%s, pid %ld, mbox %d, adapter"
+			     " busy, will abort.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->device->channel, SCpnt->device->id,
-			     SCpnt->device->lun, SCpnt->pid, k);
+			     SCpnt->pid, k);
 			ha->cp_stat[k] = ABORTING;
 			continue;
 		}
@@ -2449,9 +2445,7 @@ static irqreturn_t ihdlr(int irq, struct
 
 		/* If there was a bus reset, redo operation on each target */
 		else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-			 && ha->target_redo[SCpnt->device->id][SCpnt->
-								  device->
-								  channel])
+			 && ha->target_redo[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)])
 			status = DID_BUS_BUSY << 16;
 
 		/* Works around a flaw in scsi.c */
@@ -2464,20 +2458,18 @@ static irqreturn_t ihdlr(int irq, struct
 			status = DID_OK << 16;
 
 		if (tstatus == GOOD)
-			ha->target_redo[SCpnt->device->id][SCpnt->device->
-							      channel] = 0;
+			ha->target_redo[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] = 0;
 
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
 		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-			printk("%s: ihdlr, target %d.%d:%d, pid %ld, "
+			sdev_printk(KERN_INFO, SCpnt->device,
+				"ihdlr, pid %ld, "
 			       "target_status 0x%x, sense key 0x%x.\n",
-			       ha->board_name,
-			       SCpnt->device->channel, SCpnt->device->id,
-			       SCpnt->device->lun, SCpnt->pid,
+			       SCpnt->pid,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
-		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
+		ha->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] = 0;
 
 		if (ha->last_retried_pid == SCpnt->pid)
 			ha->retries = 0;
@@ -2486,12 +2478,11 @@ static irqreturn_t ihdlr(int irq, struct
 	case ASST:		/* Selection Time Out */
 	case 0x02:		/* Command Time Out   */
 
-		if (ha->target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
+		if (ha->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] > 1)
 			status = DID_ERROR << 16;
 		else {
 			status = DID_TIME_OUT << 16;
-			ha->target_to[SCpnt->device->id][SCpnt->device->
-							    channel]++;
+			ha->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)]++;
 		}
 
 		break;
@@ -2542,11 +2533,10 @@ static irqreturn_t ihdlr(int irq, struct
 	     spp->adapter_status != ASST && ha->iocount <= 1000) ||
 	    do_trace || msg_byte(spp->target_status))
 #endif
-		printk("%s: ihdlr, mbox %2d, err 0x%x:%x,"
-		       " target %d.%d:%d, pid %ld, reg 0x%x, count %d.\n",
-		       ha->board_name, i, spp->adapter_status, spp->target_status,
-		       SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid, reg, ha->iocount);
+		sdev_printk(KERN_INFO, SCpnt->device, "ihdlr, mbox %2d, err 0x%x:%x,"
+		       " pid %ld, reg 0x%x, count %d.\n",
+		       i, spp->adapter_status, spp->target_status,
+		       SCpnt->pid, reg, ha->iocount);
 
 	unmap_dma(i, ha);
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 42c6e35..ed92f6a 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -384,7 +384,9 @@ static int eata_pio_queue(struct scsi_cm
 
 	cp->status = USED;	/* claim free slot */
 
-	DBG(DBG_QUEUE, printk(KERN_DEBUG "eata_pio_queue pid %ld, target: %x, lun:" " %x, y %d\n", cmd->pid, cmd->device->id, cmd->device->lun, y));
+	DBG(DBG_QUEUE, sdev_printk(KERN_DEBUG, cmd->device,
+		"eata_pio_queue pid %ld, y %d\n",
+		cmd->pid, y));
 
 	cmd->scsi_done = (void *) done;
 
@@ -393,14 +395,14 @@ static int eata_pio_queue(struct scsi_cm
 	else
 		cp->DataIn = 0;	/* Input mode  */
 
-	cp->Interpret = (cmd->device->id == hd->hostid);
+	cp->Interpret = (sdev_id(cmd->device) == hd->hostid);
 	cp->cp_datalen = htonl((unsigned long) cmd->request_bufflen);
 	cp->Auto_Req_Sen = 0;
 	cp->cp_reqDMA = htonl(0);
 	cp->reqlen = 0;
 
-	cp->cp_id = cmd->device->id;
-	cp->cp_lun = cmd->device->lun;
+	cp->cp_id = sdev_id(cmd->device);
+	cp->cp_lun = scsilun_to_int(&cmd->device->lun);
 	cp->cp_dispri = 0;
 	cp->cp_identify = 1;
 	memcpy(cp->cp_cdb, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
@@ -427,7 +429,9 @@ static int eata_pio_queue(struct scsi_cm
 
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP)) {
 		cmd->result = DID_BUS_BUSY << 16;
-		printk(KERN_NOTICE "eata_pio_queue target %d, pid %ld, HBA busy, " "returning DID_BUS_BUSY, done.\n", cmd->device->id, cmd->pid);
+		sdev_printk(KERN_NOTICE, cmd->device,
+			"eata_pio_queue pid %ld, HBA busy, "
+			"returning DID_BUS_BUSY, done.\n", cmd->pid);
 		done(cmd);
 		cp->status = FREE;
 		return (0);
@@ -440,7 +444,9 @@ static int eata_pio_queue(struct scsi_cm
 	for (x = 0; x < hd->cppadlen; x++)
 		outw(0, base + HA_RDATA);
 
-	DBG(DBG_QUEUE, printk(KERN_DEBUG "Queued base %#.4lx pid: %ld target: %x " "lun: %x slot %d irq %d\n", (long) sh->base, cmd->pid, cmd->device->id, cmd->device->lun, y, sh->irq));
+	DBG(DBG_QUEUE, sdev_printk(KERN_DEBUG, cmd->device,
+		"Queued base %#.4lx pid: %ld "
+		"slot %d irq %d\n", (long) sh->base, cmd->pid, y, sh->irq));
 
 	return (0);
 }
@@ -449,8 +455,9 @@ static int eata_pio_abort(struct scsi_cm
 {
 	uint loop = HZ;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_abort called pid: %ld " "target: %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
-
+	DBG(DBG_ABNORM, sdev_printk(KERN_WARNING, cmd->device,
+		"eata_pio_abort called pid: %ld\n",
+		cmd->pid));
 
 	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
 		if (--loop == 0) {
@@ -484,7 +491,9 @@ static int eata_pio_host_reset(struct sc
 	struct scsi_cmnd *sp;
 	struct Scsi_Host *host = cmd->device->host;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
+	DBG(DBG_ABNORM, sdev_printk(KERN_WARNING, cmd->device,
+		"eata_pio_reset called pid:%ld\n",
+		cmd->pid));
 
 	spin_lock_irq(host->host_lock);
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index a3aa729..38186b5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -765,7 +765,9 @@ static int sprint_command(char *buffer, 
 static int sprint_Scsi_Cmnd(char *buffer, int len, Scsi_Cmnd * cmd)
 {
 	int start = len;
-	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
+	char lunstr[SCSILUN_STR_LEN];
+
+	PRINTP("host number %d destination target %d, lun %s\n" ANDP cmd->device->host->host_no ANDP sdev_id(cmd->device) ANDP scsilun_to_str(&cmd->device->lun, lunstr));
 	PRINTP("        command = ");
 	len += sprint_command(buffer, len, cmd->cmnd);
 	return len - start;
@@ -834,12 +836,12 @@ static int generic_NCR5380_proc_info(str
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
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index 104fd9a..1f75860 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -344,12 +344,12 @@ int ata_scsi_slave_config(struct scsi_de
 
 	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
 
-	if (sdev->id < ATA_MAX_DEVICES) {
+	if (sdev_id(sdev) < ATA_MAX_DEVICES) {
 		struct ata_port *ap;
 		struct ata_device *dev;
 
 		ap = (struct ata_port *) &sdev->host->hostdata[0];
-		dev = &ap->device[sdev->id];
+		dev = &ap->device[sdev_id(sdev)];
 
 		/* TODO: 1024 is an arbitrary number, not the
 		 * hardware maximum.  This should be increased to
@@ -1458,13 +1458,13 @@ ata_scsi_find_dev(struct ata_port *ap, s
 	struct ata_device *dev;
 
 	/* skip commands not addressed to targets we simulate */
-	if (likely(scsidev->id < ATA_MAX_DEVICES))
-		dev = &ap->device[scsidev->id];
+	if (likely(sdev_id(scsidev) < ATA_MAX_DEVICES))
+		dev = &ap->device[sdev_id(scsidev)];
 	else
 		return NULL;
 
-	if (unlikely((scsidev->channel != 0) ||
-		     (scsidev->lun != 0)))
+	if (unlikely((sdev_channel(scsidev) != 0) ||
+		     (!scsilun_zero(&scsidev->lun))))
 		return NULL;
 
 	if (unlikely(!ata_dev_present(dev)))
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 519486d..68c41e0 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1209,13 +1209,13 @@ struct scripth {
 **==========================================================
 */
 
-static	void	ncr_alloc_ccb	(struct ncb *np, u_char tn, u_char ln);
+static	void	ncr_alloc_ccb	(struct ncb *np, u_char tn, const struct scsi_lun *ln);
 static	void	ncr_complete	(struct ncb *np, struct ccb *cp);
 static	void	ncr_exception	(struct ncb *np);
 static	void	ncr_free_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_tcb	(struct ncb *np, u_char tn);
-static	struct lcb *	ncr_alloc_lcb	(struct ncb *np, u_char tn, u_char ln);
+static	struct lcb *	ncr_alloc_lcb	(struct ncb *np, u_char tn, const struct scsi_lun *ln);
 static	struct lcb *	ncr_setup_lcb	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_getclock	(struct ncb *np, int mult);
 static	void	ncr_selectclock	(struct ncb *np, u_char scntl3);
@@ -3429,8 +3429,8 @@ static int ncr_prepare_nego(struct ncb *
 static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
-	struct tcb *tp = &np->target[sdev->id];
-	struct lcb *lp = tp->lp[sdev->lun];
+	struct tcb *tp = &np->target[sdev_id(sdev)];
+	struct lcb *lp = tp->lp[scsilun_to_int(&sdev->lun)];
 	struct ccb *cp;
 
 	int	segments;
@@ -3445,9 +3445,9 @@ static int ncr_queue_command (struct ncb
 	**
 	**---------------------------------------------
 	*/
-	if ((sdev->id == np->myaddr	  ) ||
-		(sdev->id >= MAX_TARGET) ||
-		(sdev->lun    >= MAX_LUN   )) {
+	if ((sdev_id(sdev) == np->myaddr	  ) ||
+		(sdev_id(sdev) >= MAX_TARGET) ||
+		(scsilun_to_int(&sdev->lun)    >= MAX_LUN   )) {
 		return(DID_BAD_TARGET);
 	}
 
@@ -3499,7 +3499,7 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 
-	idmsg = M_IDENTIFY | sdev->lun;
+	idmsg = M_IDENTIFY | scsilun_to_int(&sdev->lun);
 
 	if (cp ->tag != NO_TAG ||
 		(cp != np->ccb && np->disc && !(tp->usrflag & UF_NODISC)))
@@ -3669,7 +3669,7 @@ static int ncr_queue_command (struct ncb
 	/*
 	**	select
 	*/
-	cp->phys.select.sel_id		= sdev->id;
+	cp->phys.select.sel_id		= sdev_id(sdev);
 	cp->phys.select.sel_scntl3	= tp->wval;
 	cp->phys.select.sel_sxfer	= tp->sval;
 	/*
@@ -4150,8 +4150,8 @@ void ncr_complete (struct ncb *np, struc
 
 	cmd = cp->cmd;
 	cp->cmd = NULL;
-	tp = &np->target[cmd->device->id];
-	lp = tp->lp[cmd->device->lun];
+	tp = &np->target[sdev_id(cmd->device)];
+	lp = tp->lp[scsilun_to_int(&cmd->device->lun)];
 
 	/*
 	**	We donnot queue more than 1 ccb per target 
@@ -4245,7 +4245,7 @@ void ncr_complete (struct ncb *np, struc
 		**	Allocate the lcb if not yet.
 		*/
 		if (!lp)
-			ncr_alloc_lcb (np, cmd->device->id, cmd->device->lun);
+			ncr_alloc_lcb (np, sdev_id(cmd->device), &cmd->device->lun);
 
 		tp->bytes     += cp->data_len;
 		tp->transfers ++;
@@ -4820,7 +4820,7 @@ static void ncr_set_sync_wide_status (st
 	*/
 	for (cp = np->ccb; cp; cp = cp->link_ccb) {
 		if (!cp->cmd) continue;
-		if (cp->cmd->device->id != target) continue;
+		if (sdev_id(cp->cmd->device) != target) continue;
 #if 0
 		cp->sync_status = tp->sval;
 		cp->wide_status = tp->wval;
@@ -4844,7 +4844,7 @@ static void ncr_setsync (struct ncb *np,
 	u_char target = INB (nc_sdid) & 0x0f;
 	u_char idiv;
 
-	BUG_ON(target != (cmd->device->id & 0xf));
+	BUG_ON(target != (sdev_id(cmd->device) & 0xf));
 
 	tp = &np->target[target];
 
@@ -4902,7 +4902,7 @@ static void ncr_setwide (struct ncb *np,
 	u_char	scntl3;
 	u_char	sxfer;
 
-	BUG_ON(target != (cmd->device->id & 0xf));
+	BUG_ON(target != (sdev_id(cmd->device) & 0xf));
 
 	tp = &np->target[target];
 	tp->widedone  =  wide+1;
@@ -4941,7 +4941,7 @@ static void ncr_setwide (struct ncb *np,
 
 static void ncr_setup_tags (struct ncb *np, struct scsi_device *sdev)
 {
-	unsigned char tn = sdev->id, ln = sdev->lun;
+	unsigned char tn = sdev_id(sdev), ln = scsilun_to_int(&sdev->lun);
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char   reqtags, maxdepth;
@@ -5851,8 +5851,8 @@ reset_all:
 static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 {
 	struct scsi_cmnd *cmd	= cp->cmd;
-	struct tcb *tp	= &np->target[cmd->device->id];
-	struct lcb *lp	= tp->lp[cmd->device->lun];
+	struct tcb *tp	= &np->target[sdev_id(cmd->device)];
+	struct lcb *lp	= tp->lp[scsilun_to_int(&cmd->device->lun)];
 	struct list_head *qp;
 	struct ccb *	cp2;
 	int		disc_cnt = 0;
@@ -5929,7 +5929,7 @@ static void ncr_sir_to_redo(struct ncb *
 		**
 		**	identify message
 		*/
-		cp->scsi_smsg2[0]	= IDENTIFY(0, cmd->device->lun);
+		cp->scsi_smsg2[0]	= IDENTIFY(0, &cmd->device->lun);
 		cp->phys.smsg.addr	= cpu_to_scr(CCB_PHYS (cp, scsi_smsg2));
 		cp->phys.smsg.size	= cpu_to_scr(1);
 
@@ -5943,7 +5943,7 @@ static void ncr_sir_to_redo(struct ncb *
 		**	patch requested size into sense command
 		*/
 		cp->sensecmd[0]		= 0x03;
-		cp->sensecmd[1]		= cmd->device->lun << 5;
+		cp->sensecmd[1]		= scsilun_to_int(&cmd->device->lun) << 5;
 		cp->sensecmd[4]		= sizeof(cp->sense_buf);
 
 		/*
@@ -6459,10 +6459,10 @@ out:
 
 static struct ccb *ncr_get_ccb(struct ncb *np, struct scsi_cmnd *cmd)
 {
-	u_char tn = cmd->device->id;
-	u_char ln = cmd->device->lun;
+	u_char tn = sdev_id(cmd->device);
+	const struct scsi_lun *ln = &cmd->device->lun;
 	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
+	struct lcb *lp = tp->lp[scsilun_to_int(ln)];
 	u_char tag = NO_TAG;
 	struct ccb *cp = NULL;
 
@@ -6550,7 +6550,7 @@ static struct ccb *ncr_get_ccb(struct nc
 	*/
 	cp->tag	   = tag;
 	cp->target = tn;
-	cp->lun    = ln;
+	cp->lun    = scsilun_to_int(ln);
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
 		PRINT_ADDR(cmd, "ccb @%p using tag %d.\n", cp, tag);
@@ -6669,10 +6669,10 @@ static void ncr_init_ccb(struct ncb *np,
 **------------------------------------------------------------------------
 **------------------------------------------------------------------------
 */
-static void ncr_alloc_ccb(struct ncb *np, u_char tn, u_char ln)
+static void ncr_alloc_ccb(struct ncb *np, u_char tn, const struct scsi_lun *ln)
 {
 	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
+	struct lcb *lp = tp->lp[scsilun_to_int(ln)];
 	struct ccb *cp = NULL;
 
 	/*
@@ -6805,12 +6805,12 @@ static void ncr_init_tcb (struct ncb *np
 **	command has been successfully completed for this target/lun.
 **------------------------------------------------------------------------
 */
-static struct lcb *ncr_alloc_lcb (struct ncb *np, u_char tn, u_char ln)
+static struct lcb *ncr_alloc_lcb (struct ncb *np, u_char tn, const struct scsi_lun *ln)
 {
 	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
+	struct lcb *lp = tp->lp[scsilun_to_int(ln)];
 	ncrcmd copy_4 = np->features & FE_PFEN ? SCR_COPY(4) : SCR_COPY_F(4);
-	int lh = ln & 3;
+	int lh = scsilun_to_int(ln) & 3;
 
 	/*
 	**	Already done, return.
@@ -6825,7 +6825,7 @@ static struct lcb *ncr_alloc_lcb (struct
 	if (!lp)
 		goto fail;
 	memset(lp, 0, sizeof(*lp));
-	tp->lp[ln] = lp;
+	tp->lp[scsilun_to_int(ln)] = lp;
 
 	/*
 	**	Initialize the target control block if not yet.
@@ -6861,7 +6861,7 @@ static struct lcb *ncr_alloc_lcb (struct
 	**	JUMP @script(resel_notag)
 	*/
 	lp->jump_lcb.l_cmd   =
-		cpu_to_scr((SCR_JUMP ^ IFFALSE (MASK (0x80+ln, 0xff))));
+		cpu_to_scr((SCR_JUMP ^ IFFALSE (MASK (0x80+scsilun_to_int(ln), 0xff))));
 	lp->jump_lcb.l_paddr = tp->jump_lcb[lh].l_paddr;
 
 	lp->load_jump_ccb[0] = cpu_to_scr(copy_4);
@@ -6897,9 +6897,10 @@ fail:
 */
 static struct lcb *ncr_setup_lcb (struct ncb *np, struct scsi_device *sdev)
 {
-	unsigned char tn = sdev->id, ln = sdev->lun;
+	unsigned char tn = sdev_id(sdev);
+	const struct scsi_lun *ln = &sdev->lun;
 	struct tcb *tp = &np->target[tn];
-	struct lcb *lp = tp->lp[ln];
+	struct lcb *lp = tp->lp[scsilun_to_int(ln)];
 
 	/* If no lcb, try to allocate it.  */
 	if (!lp && !(lp = ncr_alloc_lcb(np, tn, ln)))
@@ -7305,7 +7306,7 @@ static int ncr53c8xx_slave_alloc(struct 
 {
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
-	struct tcb *tp = &np->target[device->id];
+	struct tcb *tp = &np->target[sdev_id(device)];
 	tp->starget = device->sdev_target;
 
 	return 0;
@@ -7315,8 +7316,8 @@ static int ncr53c8xx_slave_configure(str
 {
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
-	struct tcb *tp = &np->target[device->id];
-	struct lcb *lp = tp->lp[device->lun];
+	struct tcb *tp = &np->target[sdev_id(device)];
+	struct lcb *lp = tp->lp[scsilun_to_int(&device->lun)];
 	int numtags, depth_to_use;
 
 	ncr_setup_lcb(np, device);
@@ -7327,7 +7328,7 @@ static int ncr53c8xx_slave_configure(str
 	**	Use at least 2.
 	**	Donnot use more than our maximum.
 	*/
-	numtags = device_queue_depth(np->unit, device->id, device->lun);
+	numtags = device_queue_depth(np->unit, sdev_id(device), scsilun_to_int(&device->lun));
 	if (numtags > tp->usrtags)
 		numtags = tp->usrtags;
 	if (!device->tagged_supported)
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 637fb65..0a91866 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -617,9 +617,9 @@ __setup("qla1280=", qla1280_setup);
 #endif
 
 #define CMD_HOST(Cmnd)		Cmnd->device->host
-#define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
-#define SCSI_TCN_32(Cmnd)	Cmnd->device->id
-#define SCSI_LUN_32(Cmnd)	Cmnd->device->lun
+#define SCSI_BUS_32(Cmnd)	sdev_channel(Cmnd->device)
+#define SCSI_TCN_32(Cmnd)	sdev_id(Cmnd->device)
+#define SCSI_LUN_32(Cmnd)	scsilun_to_int(&Cmnd->device->lun)
 
 
 /*****************************************/
@@ -1393,8 +1393,8 @@ qla1280_slave_configure(struct scsi_devi
 {
 	struct scsi_qla_host *ha;
 	int default_depth = 3;
-	int bus = device->channel;
-	int target = device->id;
+	int bus = sdev_channel(device);
+	int target = sdev_id(device);
 	int status = 0;
 	struct nvram *nv;
 	unsigned long flags;
@@ -4250,9 +4250,9 @@ qla1280_get_target_parameters(struct scs
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int bus, target, lun;
 
-	bus = device->channel;
-	target = device->id;
-	lun = device->lun;
+	bus = sdev_channel(device);
+	target = sdev_id(device);
+	lun = scsilun_to_int(&device->lun);
 
 
 	mb[0] = MBC_GET_TARGET_PARAMETERS;
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index cb75e0b..12ddc76 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -243,7 +243,7 @@ static void ql_icmd(Scsi_Cmnd * cmd)
 	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
 	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
 /*	outb(0x99, qbase + 5);	*/
-	outb(cmd->device->id, qbase + 4);
+	outb(sdev_id(cmd->device), qbase + 4);
 
 	for (i = 0; i < cmd->cmd_len; i++)
 		outb(cmd->cmnd[i], qbase + 2);
@@ -450,7 +450,7 @@ irqreturn_t qlogicfas408_ihandl(int irq,
 int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
-	if (cmd->device->id == priv->qinitid) {
+	if (sdev_id(cmd->device) == priv->qinitid) {
 		cmd->result = DID_BAD_TARGET << 16;
 		done(cmd);
 		return 0;
diff --git a/drivers/scsi/qlogicfc.c b/drivers/scsi/qlogicfc.c
index a4b3b3f..a4e9603 100644
--- a/drivers/scsi/qlogicfc.c
+++ b/drivers/scsi/qlogicfc.c
@@ -1247,10 +1247,10 @@ static int isp2x00_queuecommand(Scsi_Cmn
 
 	cmd->hdr.entry_type = ENTRY_COMMAND;
 	cmd->hdr.entry_cnt = 1;
-	cmd->target_lun = Cmnd->device->lun;
-	cmd->expanded_lun = cpu_to_le16(Cmnd->device->lun);
+	cmd->target_lun = scsilun_to_int(&Cmnd->device->lun);
+	cmd->expanded_lun = cpu_to_le16(scsilun_to_int(&Cmnd->device->lun));
 #if ISP2x00_PORTDB
-	cmd->target_id = hostdata->port_db[Cmnd->device->id].loop_id;
+	cmd->target_id = hostdata->port_db[sdev_id(Cmnd->device)].loop_id;
 #else
 	cmd->target_id = Cmnd->target;
 #endif
@@ -1325,9 +1325,9 @@ static int isp2x00_queuecommand(Scsi_Cmn
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
 
 	if (Cmnd->device->tagged_supported) {
-		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * ISP_TIMEOUT)) {
+		if ((jiffies - hostdata->tag_ages[sdev_id(Cmnd->device)]) > (2 * ISP_TIMEOUT)) {
 			cmd->control_flags |= cpu_to_le16(CFLAG_ORDERED_TAG);
-			hostdata->tag_ages[Cmnd->device->id] = jiffies;
+			hostdata->tag_ages[sdev_id(Cmnd->device)] = jiffies;
 		} else
 			switch (Cmnd->tag) {
 			case HEAD_OF_QUEUE_TAG:
@@ -1396,8 +1396,9 @@ static void redo_port_db(unsigned long a
 		}
 		
 	        for (i = 0; i < QLOGICFC_REQ_QUEUE_LEN; i++){ 
-		        if (hostdata->handle_ptrs[i] && (hostdata->port_db[hostdata->handle_ptrs[i]->device->id].loop_id > QLOGICFC_MAX_LOOP_ID || hostdata->adapter_state & AS_REDO_LOOP_PORTDB)){
-                                if (hostdata->port_db[hostdata->handle_ptrs[i]->device->id].loop_id != hostdata->port_db[0].loop_id){
+		        if (hostdata->handle_ptrs[i] &&
+			    (hostdata->port_db[sdev_id(hostdata->handle_ptrs[i]->device)].loop_id > QLOGICFC_MAX_LOOP_ID || hostdata->adapter_state & AS_REDO_LOOP_PORTDB)){
+                                if (hostdata->port_db[sdev_id(hostdata->handle_ptrs[i]->device)].loop_id != hostdata->port_db[0].loop_id){
 					Scsi_Cmnd *Cmnd = hostdata->handle_ptrs[i];
 
 					 if (Cmnd->use_sg)
@@ -1596,7 +1597,7 @@ void isp2x00_intr_handler(int irq, void 
 				 * the device may well be back in a couple of
 				 * seconds.
 				 */
-				if ((hostdata->adapter_state == AS_LOOP_DOWN || sts->completion_status == cpu_to_le16(CS_PORT_UNAVAILABLE) || sts->completion_status == cpu_to_le16(CS_PORT_LOGGED_OUT) || sts->completion_status == cpu_to_le16(CS_PORT_CONFIG_CHANGED)) && hostdata->port_db[Cmnd->device->id].wwn){
+				if ((hostdata->adapter_state == AS_LOOP_DOWN || sts->completion_status == cpu_to_le16(CS_PORT_UNAVAILABLE) || sts->completion_status == cpu_to_le16(CS_PORT_LOGGED_OUT) || sts->completion_status == cpu_to_le16(CS_PORT_CONFIG_CHANGED)) && hostdata->port_db[sdev_id(Cmnd->device)].wwn){
 					outw(out_ptr, host->io_port + MBOX5);
 					continue;
 				}
@@ -1739,9 +1740,9 @@ static int isp2x00_abort(Scsi_Cmnd * Cmn
 
 	param[0] = MBOX_ABORT_IOCB;
 #if ISP2x00_PORTDB
-	param[1] = (((u_short) hostdata->port_db[Cmnd->device->id].loop_id) << 8) | Cmnd->device->lun;
+	param[1] = (((u_short) hostdata->port_db[sdev_id(Cmnd->device)].loop_id) << 8) | scsilun_to_int(&Cmnd->device->lun);
 #else
-	param[1] = (((u_short) Cmnd->target) << 8) | Cmnd->lun;
+	param[1] = (((u_short) Cmnd->target) << 8) | scsilun_to_int(&Cmnd->device->lun);
 #endif
 	param[2] = i & 0xffff;
 	param[3] = i >> 16;
diff --git a/drivers/scsi/qlogicisp.c b/drivers/scsi/qlogicisp.c
index 6c9266b..8f48859 100644
--- a/drivers/scsi/qlogicisp.c
+++ b/drivers/scsi/qlogicisp.c
@@ -861,8 +861,8 @@ static int isp1020_queuecommand(Scsi_Cmn
 	cmd->hdr.entry_type = ENTRY_COMMAND;
 	cmd->hdr.entry_cnt = 1;
 
-	cmd->target_lun = Cmnd->device->lun;
-	cmd->target_id = Cmnd->device->id;
+	cmd->target_lun = scsilun_to_int(&Cmnd->device->lun);
+	cmd->target_id = sdev_id(Cmnd->device);
 	cmd->cdb_length = cpu_to_le16(Cmnd->cmd_len);
 	cmd->control_flags = cpu_to_le16(CFLAG_READ | CFLAG_WRITE);
 	cmd->time_out = cpu_to_le16(30);
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index a0cace9..d5ad93e 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -228,7 +228,7 @@ extern volatile int seagate_st0x_timeout
 #define ST0X_ID_STR	"Seagate ST-01/ST-02"
 #define FD_ID_STR	"TMC-8XX/TMC-950"
 
-static int internal_command (unsigned char target, unsigned char lun,
+static int internal_command (unsigned char target, const struct scsi_lun *lun,
 			     const void *cmnd,
 			     void *buff, int bufflen, int reselect);
 
@@ -568,7 +568,8 @@ static const char *seagate_st0x_info (st
  * waiting for a reconnect
  */
 
-static unsigned char current_target, current_lun;
+static unsigned char current_target;
+static struct scsi_lun current_lun;
 static unsigned char *current_cmnd, *current_data;
 static int current_nobuffs;
 static struct scatterlist *current_buffer;
@@ -582,7 +583,8 @@ static int current_bufflen;
  */
 
 static int linked_connected = 0;
-static unsigned char linked_target, linked_lun;
+static unsigned char linked_target;
+static strict scsi_lun linked_lun;
 #endif
 
 static void (*done_fn) (Scsi_Cmnd *) = NULL;
@@ -645,7 +647,7 @@ static void seagate_reconnect_intr (int 
 		DPRINTK (PHASE_RESELECT, "scsi%d : internal_command(%d, %08x, %08x, RECONNECT_NOW\n", 
 			hostno, current_target, current_data, current_bufflen);
 
-		temp = internal_command (current_target, current_lun, current_cmnd, current_data, current_bufflen, RECONNECT_NOW);
+		temp = internal_command (current_target, &current_lun, current_cmnd, current_data, current_bufflen, RECONNECT_NOW);
 
 		if (msg_byte(temp) != DISCONNECT) {
 			if (done_fn) {
@@ -682,8 +684,8 @@ static int seagate_st0x_queue_command (S
 
 	DANY ("seagate: que_command");
 	done_fn = done;
-	current_target = SCpnt->device->id;
-	current_lun = SCpnt->device->lun;
+	current_target = sdev_id(SCpnt->device);
+	scsilun_cp(&current_lun, &SCpnt->device->lun);
 	current_cmnd = SCpnt->cmnd;
 	current_data = (unsigned char *) SCpnt->request_buffer;
 	current_bufflen = SCpnt->request_bufflen;
@@ -700,7 +702,8 @@ static int seagate_st0x_queue_command (S
 		current_cmnd[SCpnt->cmd_len] |= 0x01;
 		if (linked_connected) {
 			DPRINTK (DEBUG_LINKED, "scsi%d : using linked commands, current I_T_L nexus is ", hostno);
-			if (linked_target == current_target && linked_lun == current_lun) 
+			if (linked_target == current_target &&
+			    scsilun_eq(&linked_lun, &current_lun))
 			{
 				DPRINTK(DEBUG_LINKED, "correct\n");
 				reconnect = LINKED_RIGHT;
@@ -712,8 +715,9 @@ static int seagate_st0x_queue_command (S
 #endif				/* LINKED */
 			reconnect = CAN_RECONNECT;
 
-		result = internal_command(SCint->device->id, SCint->device->lun, SCint->cmnd,
-				      SCint->request_buffer, SCint->request_bufflen, reconnect);
+		result = internal_command(sdev_id(SCint->device),
+			&SCint->device->lun, SCint->cmnd,
+		        SCint->request_buffer, SCint->request_bufflen, reconnect);
 		if (msg_byte(result) == DISCONNECT)
 			break;
 		SCtmp = SCint;
@@ -726,7 +730,7 @@ static int seagate_st0x_queue_command (S
 	return 0;
 }
 
-static int internal_command (unsigned char target, unsigned char lun,
+static int internal_command (unsigned char target, const struct scsi_lun *lun,
 		  const void *cmnd, void *buff, int bufflen, int reselect)
 {
 	unsigned char *data = NULL;
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index ef19adc..b515d77 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -773,7 +773,7 @@ int sym53c416_queuecommand(Scsi_Cmnd *SC
 	current_command->SCp.Message = 0;
 
 	spin_lock_irqsave(&sym53c416_lock, flags);
-	outb(SCpnt->device->id, base + DEST_BUS_ID); /* Set scsi id target        */
+	outb(sdev_id(SCpnt->device), base + DEST_BUS_ID); /* Set scsi id target        */
 	outb(FLUSH_FIFO, base + COMMAND_REG);    /* Flush SCSI and PIO FIFO's */
 	/* Write SCSI command into the SCSI fifo */
 	for(i = 0; i < SCpnt->cmd_len; i++)
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index fb54a87..0becb6d 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1094,7 +1094,8 @@ static int wd7000_queuecommand(struct sc
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	cdblen = SCpnt->cmd_len;
-	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
+	idlun = ((sdev_id(SCpnt->device) << 5) & 0xe0) |
+		 (scsilun_to_int(&SCpnt->device->lun) & 7);
 	SCpnt->scsi_done = done;
 	SCpnt->SCp.phase = 1;
 	scb = alloc_scbs(SCpnt->device->host, 1);
