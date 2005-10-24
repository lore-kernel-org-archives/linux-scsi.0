From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 13/n] HCIL drivers update
Date: Mon, 24 Oct 2005 04:18:39 -0400
Message-ID: <20051024081839.GD7160@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45952 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750746AbVJXISk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 04:18:40 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 1708F1C0A7AF
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 04:18:40 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O8IdGc007389
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 04:18:39 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Convert more stuff to sfoo_printk()

 drivers/scsi/53c700.c              |   37 ++++++++--------
 drivers/scsi/53c700.h              |    8 +++
 drivers/scsi/NCR5380.c             |    4 +
 drivers/scsi/NCR53C9x.c            |   81 +++++++++++++++----------------------
 drivers/scsi/NCR53C9x.h            |   22 ++++++++--
 drivers/scsi/aha152x.c             |    4 -
 drivers/scsi/aha1542.c             |    4 -
 drivers/scsi/aic7xxx/aic79xx_osm.c |   26 ++++-------
 drivers/scsi/aic7xxx/aic7xxx_osm.c |   30 +++++--------
 9 files changed, 106 insertions(+), 110 deletions(-)

1d251738e8e0ce476d66010dadb5226f2a16ca3d
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 6cc3f2d..ed1cab5 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -832,8 +832,8 @@ process_extended_message(struct Scsi_Hos
 
 		} else {
 			/* SDTR message out of the blue, reject it */
-			printk(KERN_WARNING "scsi%d Unexpected SDTR msg\n",
-			       host->host_no);
+			shost_printk(KERN_WARNING, host,
+				"Unexpected SDTR msg\n");
 			hostdata->msgout[0] = A_REJECT_MSG;
 			dma_cache_sync(hostdata->msgout, 1, DMA_TO_DEVICE);
 			script_patch_16(hostdata->script, MessageCount, 1);
@@ -907,15 +907,17 @@ process_message(struct Scsi_Host *host,	
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION) {
 			/* rejected our first simple tag message */
-			printk(KERN_WARNING "scsi%d (%d:%d) Rejected first tag queue attempt, turning off tag queueing\n", host->host_no, pun, lun);
+			scmd_printk(KERN_WARNING, SCp,
+				"Rejected first tag queue attempt, turning off tag queueing\n");
 			/* we're done negotiating */
 			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
 			hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 			SCp->device->tagged_supported = 0;
 			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
 		} else {
-			printk(KERN_WARNING "scsi%d (%d:%d) Unexpected REJECT Message %s\n",
-			       host->host_no, pun, lun,
+			shost_printk(KERN_WARNING, host,
+				"(%d:%d) Unexpected REJECT Message %s\n",
+			       pun, lun,
 			       NCR_700_phase[(dsps & 0xf00) >> 8]);
 			/* however, just ignore it */
 		}
@@ -1118,14 +1120,14 @@ process_script_interrupt(__u32 dsps, __u
 			}
 
 			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
-			DEBUG(("53c700: %d:%d:%d, reselection is tag %d, slot %p(%d)\n",
-			       host->host_no, SDp->id, SDp->lun,
-			       hostdata->msgin[2], slot, slot->tag));
+			DDEBUG(KERN_DEBUG, SDp,
+				"reselection is tag %d, slot %p(%d)\n",
+				hostdata->msgin[2], slot, slot->tag);
 		} else {
 			struct scsi_cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
 			if(unlikely(SCp == NULL)) {
-				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for untagged cmd\n", 
-				       host->host_no, reselection_id, lun);
+				sdev_printk(KERN_ERR, SDp,
+					"no saved request for untagged cmd\n");
 				BUG();
 			}
 			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
@@ -1769,15 +1771,13 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	if(NCR_700_get_depth(SCp->device) != 0
 	   && (!(hostdata->tag_negotiated & (1<<scmd_id(SCp)))
 	       || !blk_rq_tagged(SCp->request))) {
-		DEBUG((KERN_ERR "scsi%d (%d:%d) has non zero depth %d\n",
-		       SCp->device->host->host_no, scmd_id(SCp), SCp->device->lun,
-		       NCR_700_get_depth(SCp->device)));
+		CDEBUG(KERN_ERR, SCp, "has non zero depth %d\n",
+		       NCR_700_get_depth(SCp->device));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	if(NCR_700_get_depth(SCp->device) >= SCp->device->queue_depth) {
-		DEBUG((KERN_ERR "scsi%d (%d:%d) has max tag depth %d\n",
-		       SCp->device->host->host_no, scmd_id(SCp), SCp->device->lun,
-		       NCR_700_get_depth(SCp->device)));
+		CDEBUG(KERN_ERR, SCp, "has max tag depth %d\n",
+		       NCR_700_get_depth(SCp->device));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
@@ -1823,9 +1823,8 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	if((hostdata->tag_negotiated &(1<<scmd_id(SCp)))
 	   && scsi_get_tag_type(SCp->device)) {
 		slot->tag = SCp->request->tag;
-		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
-		       SCp->device->host->host_no, scmd_id(SCp), SCp->device->lun, slot->tag,
-		       slot));
+		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
+		       slot->tag, slot);
 	} else {
 		slot->tag = SCSI_NO_TAG;
 		/* must populate current_cmnd for scsi_find_tag to work */
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e86012c..362d784 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -22,8 +22,14 @@
 
 #ifdef NCR_700_DEBUG
 #define DEBUG(x)	printk x
+#define DDEBUG(prefix, sdev, fmt, a...) \
+	sdev_printk(prefix, sdev, fmt, ##a)
+#define CDEBUG(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
-#define DEBUG(x)
+#define DEBUG(x)	do {} while (0)
+#define DDEBUG(prefix, scmd, fmt, a...) do {} while (0)
+#define CDEBUG(prefix, scmd, fmt, a...) do {} while (0)
 #endif
 
 /* The number of available command slots */
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index fb2400b..92ebb4a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -779,7 +779,9 @@ static char *lprint_Scsi_Cmnd(Scsi_Cmnd 
 {
 	char lunstr[SCSILUN_STR_LEN];
 
-	SPRINTF("scsi%d : destination target %d, lun %s\n", cmd->device->host->host_no, scmd_id(cmd), scsilun_to_str(&cmd->device->lun, lunstr));
+	SPRINTF("scsi%d : destination target %d, lun %s\n",
+		cmd->device->host->host_no, scmd_id(cmd),
+		scsilun_to_str(&cmd->device->lun, lunstr));
 	SPRINTF("        command = ");
 	pos = lprint_command(cmd->cmnd, pos, buffer, length);
 	return (pos);
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index b54c51f..157cada 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -1091,8 +1091,8 @@ do_sync_known:
 		 * to at least attempt allowing the device to
 		 * disconnect.
 		 */
-		ESPMISC(("esp: Selecting device for first time. target=%d "
-			 "lun=%d\n", target, SCptr->device->lun));
+		ESPMISC_C(KERN_DEBUG, SCptr,
+			"Selecting device for first time.\n");
 		if(!SDptr->borken && !esp_dev->disconnect)
 			esp_dev->disconnect = 1;
 
@@ -1165,8 +1165,8 @@ do_sync_known:
 		 */
 		if(((SDptr->scsi_level < 3) && (SDptr->type != TYPE_TAPE)) ||
 		   toshiba_cdrom_hwbug_wkaround || SDptr->borken) {
-			ESPMISC((KERN_INFO "esp%d: Disabling DISCONNECT for target %d "
-				 "lun %d\n", esp->esp_id, scmd_id(SCptr), SCptr->device->lun));
+			ESPMISC_C(KERN_INFO, SCptr,
+				"Disabling DISCONNECT for target\n");
 			esp_dev->disconnect = 0;
 			*cmdp++ = IDENTIFY(0, lun);
 		} else {
@@ -1248,8 +1248,8 @@ int esp_queue(Scsi_Cmnd *SCpnt, void (*d
 		esp->dma_led_on(esp);
 
 	/* We use the scratch area. */
-	ESPQUEUE(("esp_queue: target=%d lun=%d ", scmd_id(SCpnt), SCpnt->lun));
-	ESPDISC(("N<%02x,%02x>", scmd_id(SCpnt), SCpnt->lun));
+	ESPQUEUE_C(KERN_DEBUG, SCpnt, "esp_queue\n");
+	ESPDISC_C(KERN_DEBUG, SCpnt, "N\n");
 
 	esp_get_dmabufs(esp, SCpnt);
 	esp_save_pointers(esp, SCpnt); /* FIXME for tag queueing */
@@ -1277,14 +1277,9 @@ int esp_queue(Scsi_Cmnd *SCpnt, void (*d
 /* Dump driver state. */
 static void esp_dump_cmd(Scsi_Cmnd *SCptr)
 {
-	char lunstr[SCSILUN_STR_LEN];
-
-	ESPLOG(("[tgt<%02x> lun<%s> "
-		"pphase<%s> cphase<%s>]",
-		scmd_id(SCptr),
-		scsilun_to_str(&SCptr->device->lun, lunstr),
+	ESPLOG_C("", SCptr, "[pphase<%s> cphase<%s>]\n",
 		phase_string(SCptr->SCp.sent_command),
-		phase_string(SCptr->SCp.phase)));
+		phase_string(SCptr->SCp.phase));
 }
 
 static void esp_dump_state(struct NCR_ESP *esp, 
@@ -1327,17 +1322,17 @@ static void esp_dump_state(struct NCR_ES
 #endif /* (DEBUG_ESP_CMDS) */
 
 	if(SCptr) {
-		ESPLOG(("esp%d: current command ", esp->esp_id));
+		ESPLOG_C(KERN_INFO, SCptr, "command ");
 		esp_dump_cmd(SCptr);
 	}
-	ESPLOG(("\n"));
+	ESPLOG_C("", SCptr, "\n");
 	SCptr = esp->disconnected_SC;
-	ESPLOG(("esp%d: disconnected ", esp->esp_id));
+	ESPLOG_C(KERN_INFO, SCptr, "disconnected ");
 	while(SCptr) {
 		esp_dump_cmd(SCptr);
 		SCptr = (Scsi_Cmnd *) SCptr->host_scribble;
 	}
-	ESPLOG(("\n"));
+	ESPLOG_C("", SCptr, "\n");
 }
 
 /* Abort a command.  The host_lock is acquired by caller. */
@@ -2102,8 +2097,7 @@ static int esp_do_data_finale(struct NCR
 		ESPLOG(("esp%d: use_sg=%d ptr=%p this_residual=%d\n",
 			esp->esp_id,
 			SCptr->use_sg, SCptr->SCp.ptr, SCptr->SCp.this_residual));
-		ESPLOG(("esp%d: Forcing async for target %d\n", esp->esp_id, 
-			scmd_id(SCptr)));
+		ESPLOG_C(KERN_INFO, SCptr, "Forcing async for target\n");
 		SCptr->device->borken = 1;
 		esp_dev->sync = 0;
 		bytes_sent = 0;
@@ -2220,8 +2214,8 @@ static int esp_do_freebus(struct NCR_ESP
 			 * transfers until we are sure of the current target
 			 * state.
 			 */
-			ESPMISC(("esp: Status <%d> for target %d lun %d\n",
-				 SCptr->SCp.Status, scmd_id(SCptr), SCptr->device->lun));
+			ESPMISC_C(KERN_DEBUG, SCptr, "Status <%d>\n",
+				 SCptr->SCp.Status);
 
 			/* But don't do this when spinning up a disk at
 			 * boot time while we poll for completion as it
@@ -2232,14 +2226,14 @@ static int esp_do_freebus(struct NCR_ESP
 			if(esp_should_clear_sync(SCptr) != 0)
 				esp_dev->sync = 0;
 		}
-		ESPDISC(("F<%02x,%02x>", scmd_id(SCptr), SCptr->device->lun));
+		ESPDISC_C(KERN_DEBUG, SCptr, "F\n");
 		esp_done(esp, ((SCptr->SCp.Status & 0xff) |
 			       ((SCptr->SCp.Message & 0xff)<<8) |
 			       (DID_OK << 16)));
 	} else if(esp->prevmsgin == DISCONNECT) {
 		/* Normal disconnect. */
 		esp_cmd(esp, eregs, ESP_CMD_ESEL);
-		ESPDISC(("D<%02x,%02x>", scmd_id(SCptr), SCptr->device->lun));
+		ESPDISC_C(KERN_DEBUG, SCptr, "D\n");
 		append_SC(&esp->disconnected_SC, SCptr);
 		esp->current_SC = NULL;
 		if(esp->issue_SC)
@@ -2637,8 +2631,7 @@ static int esp_select_complete(struct NC
 			 * XXX spend the next second or so renegotiating
 			 * XXX for synchronous transfers.
 			 */
-			ESPLOG(("esp%d: STEP_ASEL for tgt %d\n",
-				esp->esp_id, scmd_id(SCptr)));
+			ESPLOG_C(KERN_INFO, SCptr, "STEP_ASEL\n");
 
 		case ESP_STEP_SID:
 			/* Arbitration won, target selected, went
@@ -2744,8 +2737,6 @@ static int esp_select_complete(struct NC
 
 	/* Did the target even make it? */
 	if(esp->ireg == ESP_INTR_DC) {
-		char lunstr[SCSILUN_STR_LEN];
-
 		/* wheee... nobody there or they didn't like
 		 * what we told it to do, clean up.
 		 */
@@ -2763,10 +2754,8 @@ static int esp_select_complete(struct NC
 		    SCptr->SCp.phase == in_slct_stop)) {
 			/* shit */
 			esp->snip = 0;
-			ESPLOG(("esp%d: Failed synchronous negotiation for target %d "
-				"lun %s\n", esp->esp_id,
-				scmd_id(SCptr),
-				scsilun_to_str(&SCptr->device->lun, lunstr)));
+			ESPLOG_C(KERN_WARNING, SCptr,
+				"Failed synchronous negotiation\n");
 			esp_dev->sync_max_offset = 0;
 			esp_dev->sync_min_period = 0;
 			esp_dev->sync = 1; /* so we don't negotiate again */
@@ -2793,8 +2782,9 @@ static int esp_select_complete(struct NC
 		 * But first make sure that is really what is happening.
 		 */
 		if(((1<<scmd_id(SCptr)) & esp->targets_present)) {
-			ESPLOG(("esp%d: Warning, live target %d not responding to "
-				"selection.\n", esp->esp_id, scmd_id(SCptr)));
+			ESPLOG_C(KERN_WARNING, SCptr,
+				"Warning, live target not responding to "
+				"selection.\n");
 
 			/* This _CAN_ happen.  The SCSI standard states that
 			 * the target is to _not_ respond to selection if
@@ -2805,9 +2795,8 @@ static int esp_select_complete(struct NC
 			esp_done(esp, (DID_PARITY << 16));
 		} else {
 			/* Else, there really isn't anyone there. */
-			ESPMISC(("esp: selection failure, maybe nobody there?\n"));
-			ESPMISC(("esp: target %d lun %d\n",
-				 scmd_id(SCptr), SCptr->device->lun));
+			ESPMISC_C(KERN_WARNING, SCptr,
+				"selection failure, maybe nobody there?\n");
 			esp_done(esp, (DID_BAD_TARGET << 16));
 		}
 		return do_intr_end;
@@ -2882,13 +2871,13 @@ static int check_singlebyte_msg(struct N
 	switch(esp->cur_msgin[0]) {
 	default:
 		/* We don't want to hear about it. */
-		ESPLOG(("esp%d: msg %02x which we don't know about\n", esp->esp_id,
-			esp->cur_msgin[0]));
+		ESPLOG_C(KERN_INFO, esp->current_SC,
+			"msg %02x which we don't know about\n",
+			esp->cur_msgin[0]);
 		return MESSAGE_REJECT;
 
 	case NOP:
-		ESPLOG(("esp%d: target %d sends a nop\n", esp->esp_id,
-			scmd_id(esp->current_SC)));
+		ESPLOG_C(KERN_INFO, esp->current_SC, "target sends a nop\n");
 		return 0;
 
 	case RESTORE_POINTERS:
@@ -2980,16 +2969,15 @@ static void sync_report(struct NCR_ESP *
 		 * again, it triggers a bug in our sparc64-gcc272
 		 * sibling call optimization.  -DaveM
 		 */
-		ESPLOG((KERN_INFO "esp%d: target %d ",
-			esp->esp_id, scmd_id(esp->current_SC)));
+		ESPLOG_C(KERN_INFO, esp->current_SC, " ");
 		ESPLOG(("[period %dns offset %d %d.%02dMHz ",
 			(int) msg3 * 4, (int) msg4,
 			integer, fraction));
 		ESPLOG(("%s SCSI%s]\n", type,
 			(((msg3 * 4) < 200) ? "-II" : "")));
 	} else {
-		ESPLOG((KERN_INFO "esp%d: target %d asynchronous\n",
-			esp->esp_id, scmd_id(esp->current_SC)));
+		ESPLOG_C(KERN_INFO, esp->current_SC,
+			"target asynchronous\n");
 	}
 }
 
@@ -3488,8 +3476,9 @@ void esp_handle(struct NCR_ESP *esp)
 			 * state now and ESP_CMD_TI is only allowed when
 			 * a nexus is alive on the bus.
 			 */
-			ESPLOG(("esp%d: Forcing async and disabling disconnect for "
-				"target %d\n", esp->esp_id, scmd_id(SCptr)));
+			ESPLOG_C(KERN_WARNING, SCptr,
+				"Forcing async and disabling disconnect for "
+				"target\n");
 			SCptr->device->borken = 1; /* foo on you */
 		}
 
diff --git a/drivers/scsi/NCR53C9x.h b/drivers/scsi/NCR53C9x.h
index 06e7edf..8105e32 100644
--- a/drivers/scsi/NCR53C9x.h
+++ b/drivers/scsi/NCR53C9x.h
@@ -43,8 +43,8 @@
 
 #define DEBUG_ESP
 /* #define DEBUG_ESP_DATA */
-/* #define DEBUG_ESP_QUEUE */
-/* #define DEBUG_ESP_DISCONNECT */
+#define DEBUG_ESP_QUEUE
+#define DEBUG_ESP_DISCONNECT
 /* #define DEBUG_ESP_STATUS */
 /* #define DEBUG_ESP_PHASES */
 /* #define DEBUG_ESP_WORKBUS */
@@ -58,12 +58,16 @@
  * suits you if combinations of the above become too verbose when
  * trying to track down a specific problem.
  */
-/* #define DEBUG_ESP_MISC */
+#define DEBUG_ESP_MISC
 
 #if defined(DEBUG_ESP)
 #define ESPLOG(foo)  printk foo
+#define ESPLOG_C(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
 #define ESPLOG(foo)
+#define ESPLOG_C(prefix, scmd, fmt, a...) \
+	do {} while (0)
 #endif /* (DEBUG_ESP) */
 
 #if defined(DEBUG_ESP_DATA)
@@ -74,14 +78,22 @@
 
 #if defined(DEBUG_ESP_QUEUE)
 #define ESPQUEUE(foo)  printk foo
+#define ESPQUEUE_C(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
 #define ESPQUEUE(foo)
+#define ESPQUEUE_C(prefix, scmd, fmt, a...) \
+	do {} while (0)
 #endif
 
 #if defined(DEBUG_ESP_DISCONNECT)
 #define ESPDISC(foo)  printk foo
+#define ESPDISC_C(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
 #define ESPDISC(foo)
+#define ESPDISC_C(prefix, scmd, fmt, a...) \
+	do {} while (0)
 #endif
 
 #if defined(DEBUG_ESP_STATUS)
@@ -116,8 +128,12 @@
 
 #if defined(DEBUG_ESP_MISC)
 #define ESPMISC(foo)  printk foo
+#define ESPMISC_C(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
 #define ESPMISC(foo)
+#define ESPMISC_C(prefix, scmd, fmt, a...) \
+	do {} while (0)
 #endif
 
 /*
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ebda58b..831bacd 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2922,9 +2922,7 @@ static void disp_enintr(struct Scsi_Host
  */
 static void show_command(Scsi_Cmnd *ptr)
 {
-	dev_printk(KERN_DEBUG, &ptr->device->sdev_gendev,
-		"0x%08x: cmnd=(",
-	       (unsigned int) ptr);
+	scmd_printk(KERN_DEBUG, ptr, "%p: cmnd=(", ptr);
 
 	__scsi_print_command(ptr->cmnd);
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 08551d7..5837149 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1405,8 +1405,8 @@ static int aha1542_dev_reset(Scsi_Cmnd *
 	 */
 	aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);
 
-	sdev_printk(KERN_WARNING, SCpnt->device,
-		"aha1542.c: Trying device reset for target\n");
+	scmd_printk(KERN_WARNING, SCpnt,
+		"Trying device reset for target\n");
 
 	return SUCCESS;
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 70ca02a..023c3c1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -532,7 +532,7 @@ ahd_linux_slave_alloc(struct scsi_device
 	struct ahd_linux_device *dev;
 
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Alloc\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Alloc\n");
 
 	BUG_ON(targ->sdev[scsilun_to_int(&sdev->lun)] != NULL);
 
@@ -564,7 +564,7 @@ ahd_linux_slave_configure(struct scsi_de
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Configure\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
 	ahd_linux_device_queue_depth(sdev);
 
@@ -584,7 +584,7 @@ ahd_linux_slave_destroy(struct scsi_devi
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Destroy\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Destroy\n");
 
 	BUG_ON(dev->active);
 
@@ -2068,7 +2068,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+	scmd_printk(KERN_INFO, cmd,
 	       "Attempting to queue a%s message:",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
@@ -2093,8 +2093,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-		       "Is not an active device\n");
+		scmd_printk(KERN_INFO, cmd, "Is not an active device\n");
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2121,8 +2120,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Command not found\n");
+		scmd_printk(KERN_INFO, cmd, "Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2145,8 +2143,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Command already completed\n");
+		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2163,8 +2160,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
-			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-				"Cmd aborted from QINFIFO\n");
+			scmd_printk(KERN_INFO, cmd, "Cmd aborted from QINFIFO\n");
 			retval = SUCCESS;
 			goto done;
 		}
@@ -2214,8 +2210,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Device is active, asserting ATN\n");
+		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2278,8 +2273,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Unable to deliver message\n");
+		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 120fc48..bf1af30 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -604,7 +604,7 @@ ahc_linux_slave_alloc(struct scsi_device
 	struct ahc_linux_device *dev;
 
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Alloc\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Alloc\n");
 
 	BUG_ON(targ->sdev[scsilun_to_int(&sdev->lun)] != NULL);
 
@@ -639,7 +639,7 @@ ahc_linux_slave_configure(struct scsi_de
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Configure\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
 	ahc_linux_device_queue_depth(sdev);
 
@@ -659,7 +659,7 @@ ahc_linux_slave_destroy(struct scsi_devi
 
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Destroy\n");
+		sdev_printk(KERN_INFO, sdev, "Slave Destroy\n");
 
 	BUG_ON(dev->active);
 
@@ -2117,8 +2117,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
-	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-		"Attempting to queue a%s message\n",
+	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
 	printf("CDB:");
@@ -2142,8 +2141,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Is not an active device\n");
+		scmd_printk(KERN_INFO, cmd, "Is not an active device\n");
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2153,8 +2151,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 				       scmd_channel(cmd) + 'A',
 				       scsilun_to_int(&cmd->device->lun),
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Command found on untagged queue\n");
+		scmd_printk(KERN_INFO, cmd, "Command found on untagged queue\n");
 		retval = SUCCESS;
 		goto done;
 	}
@@ -2180,8 +2177,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Command not found\n");
+		scmd_printk(KERN_INFO, cmd, "Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2203,8 +2199,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Command already completed\n");
+		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2220,8 +2215,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
-			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-				"Cmd aborted from QINFIFO\n");
+			scmd_printk(KERN_INFO, cmd, "Cmd aborted from QINFIFO\n");
 			retval = SUCCESS;
 			goto done;
 		}
@@ -2271,8 +2265,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahc_outb(ahc, MSG_OUT, HOST_MSG);
 		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Device is active, asserting ATN\n");
+		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2340,8 +2333,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-			"Unable to deliver message\n");
+		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
