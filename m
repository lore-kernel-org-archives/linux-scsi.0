From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 14/n] more dev_printk driver work
Date: Mon, 24 Oct 2005 13:41:15 -0400
Message-ID: <20051024174115.GA27673@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45961 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751190AbVJXRlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:41:17 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 239051C0A7AC
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 13:41:16 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OHfFWL027840
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 13:41:15 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Took a pass through all scsi code in my temp repository, making two changes:
* convert sdev_printk(cmd->device,...) to scmd_printk(cmd,...)
* find any remaining printk/debug message statements that had to be
  changed due to sdev->{channel,id,lun} changes, and make sure they
  get converted to some variant of dev_printk.

Use of dev_printk and variants seems to be quite successful in killing a
ton of HCIL address usage.

 drivers/message/fusion/mptbase.h        |    4 +++
 drivers/message/fusion/mptscsih.c       |    8 -------
 drivers/scsi/53c700.c                   |   25 +++++++++++-------------
 drivers/scsi/NCR5380.c                  |   31 ++++++++++++++++--------------
 drivers/scsi/NCR5380.h                  |    8 +++++++
 drivers/scsi/NCR53C9x.c                 |   10 ++-------
 drivers/scsi/aacraid/aacraid.h          |    5 ++++
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    5 ----
 drivers/scsi/atp870u.c                  |   11 ++++------
 drivers/scsi/dc395x.c                   |   22 +++++++--------------
 drivers/scsi/dpt_i2o.c                  |   12 +++++------
 drivers/scsi/eata.c                     |   33 +++++++++++++-------------------
 drivers/scsi/eata_pio.c                 |   10 ++++-----
 drivers/scsi/ibmmca.c                   |    8 +++----
 drivers/scsi/ide-scsi.c                 |    3 --
 drivers/scsi/in2000.c                   |    2 -
 drivers/scsi/megaraid/megaraid_sas.c    |    3 --
 drivers/scsi/qla2xxx/qla_dbg.c          |    8 +++----
 drivers/scsi/scsi_error.c               |    3 --
 drivers/scsi/scsi_scan.c                |    6 ++---
 drivers/scsi/sg.c                       |    7 +-----
 drivers/scsi/tmscsim.c                  |    2 -
 drivers/scsi/u14-34f.c                  |   19 ++++++++----------
 23 files changed, 116 insertions(+), 129 deletions(-)

465c62e08c7a40fd53b966ba7f05cad6894ed419
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 7510527..3a56d58 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -654,8 +654,12 @@ typedef struct _mpt_sge {
  */
 #ifdef MPT_DEBUG
 #define dprintk(x)  printk x
+#define dcwprintk(scmd, fmt, a...) \
+	scmd_printk(KERN_WARNING, scmd, "WARNING - " fmt, ##a)
 #else
 #define dprintk(x)
+#define dcwprintk(scmd, fmt, a...) \
+	do {} while (0)
 #endif
 
 #ifdef MPT_DEBUG_INIT
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ced3739..7e4d6a8 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -975,13 +975,7 @@ mptscsih_report_queue_full(struct scsi_c
 		return;
 
 	if (time - hd->last_queue_full > 10 * HZ) {
-		char lunstr[SCSILUN_STR_LEN];
-
-		(void) lunstr; /* kill unused-var warning, if debug disabled */
-
-		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%s) reported QUEUE_FULL!\n",
-				hd->ioc->name, 0, scmd_id(sc),
-				scsilun_to_str(&sc->device->lun, lunstr)));
+		dcwprintk(sc, "Device QUEUE_FULL!\n");
 		hd->last_queue_full = time;
 	}
 }
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index ed1cab5..c273d20 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -986,7 +986,8 @@ process_script_interrupt(__u32 dsps, __u
 			if(SCp->cmnd[0] == REQUEST_SENSE) {
 				/* OOPS: bad device, returning another
 				 * contingent allegiance condition */
-				printk(KERN_ERR "scsi%d (%d:%d) broken device is looping in contingent allegiance: ignoring\n", host->host_no, pun, lun);
+				scmd_printk(KERN_ERR, SCp,
+					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
 #ifdef NCR_DEBUG
@@ -1050,7 +1051,8 @@ process_script_interrupt(__u32 dsps, __u
 			//			    SCp->request_bufflen,
 			//			    DMA_FROM_DEVICE);
 			//	if(((char *)SCp->request_buffer)[7] & 0x02) {
-			//		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", host->host_no, pun, lun);
+			//		scmd_printk(KERN_INFO, SCp,
+			//		     "Enabling Tag Command Queuing\n");
 			//		hostdata->tag_negotiated |= (1<<scmd_id(SCp));
 			//		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
 			//	} else {
@@ -1063,11 +1065,11 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff0f0) == A_UNEXPECTED_PHASE) {
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		printk(KERN_ERR "scsi%d: (%d:%d), UNEXPECTED PHASE %s (%s)\n",
-		       host->host_no, pun, lun,
+		scmd_printk(KERN_ERR, SCp, "UNEXPECTED PHASE %s (%s)\n",
 		       NCR_700_phase[i],
 		       sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
-		printk(KERN_ERR "         len = %d, cmd =", SCp->cmd_len);
+		scmd_printk(KERN_ERR, SCp, "         len = %d, cmd =",
+			SCp->cmd_len);
 		scsi_print_command(SCp);
 
 		NCR_700_internal_bus_reset(host);
@@ -1801,8 +1803,7 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	if(blk_rq_tagged(SCp->request)
 	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp))) == 0
 	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
-		sdev_printk(KERN_ERR, SCp->device,
-			"Enabling Tag Command Queuing\n");
+		scmd_printk(KERN_ERR, SCp, "Enabling Tag Command Queuing\n");
 		hostdata->tag_negotiated |= (1<<scmd_id(SCp));
 		NCR_700_set_tag_neg_state(SCp->device, NCR_700_DURING_TAG_NEGOTIATION);
 	}
@@ -1815,8 +1816,7 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * */
 	if(!blk_rq_tagged(SCp->request)
 	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp)))) {
-		sdev_printk(KERN_INFO, SCp->device,
-			"Disabling Tag Command Queuing\n");
+		scmd_printk(KERN_INFO, SCp, "Disabling Tag Command Queuing\n");
 		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 	}
 
@@ -1924,7 +1924,7 @@ NCR_700_abort(struct scsi_cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
 
-	sdev_printk(KERN_INFO, SCp->device,
+	scmd_printk(KERN_INFO, SCp,
 		"New error handler wants to abort command\n\t");
 	scsi_print_command(SCp);
 
@@ -1958,7 +1958,7 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 
-	sdev_printk(KERN_INFO, SCp->device,
+	scmd_printk(KERN_INFO, SCp,
 		"New error handler wants BUS reset, cmd %p\n\t", SCp);
 	scsi_print_command(SCp);
 
@@ -1991,8 +1991,7 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 STATIC int
 NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
-	sdev_printk(KERN_INFO, SCp->device,
-		"New error handler wants HOST reset\n\t");
+	scmd_printk(KERN_INFO, SCp, "New error handler wants HOST reset\n\t");
 	scsi_print_command(SCp);
 
 	spin_lock_irq(SCp->device->host->host_lock);
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 92ebb4a..0db23ae 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1124,7 +1124,7 @@ static void NCR5380_main(void *p)
 				   this is needed for Mustek scanners, that
 				   do not respond to commands immediately
 				   after a scan */
-				sdev_printk(KERN_DEBUG, tmp->device,
+				scmd_printk(KERN_DEBUG, tmp,
 					"device did not respond in time\n");
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
@@ -1533,7 +1533,8 @@ part2:
 		goto failed;
 	}
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, scmd_id(cmd)));
+	ddprintk(KERN_DEBUG, cmd,
+		"target selected, going into MESSAGE OUT phase.\n");
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), &cmd->device->lun);
 
 	len = 1;
@@ -2198,8 +2199,7 @@ static void NCR5380_information_transfer
 						 * If the watchdog timer fires, all future accesses to this
 						 * device will use the polled-IO.
 						 */
-						sdev_printk(KERN_INFO,
-							    cmd->device,
+						scmd_printk(KERN_INFO, cmd,
 							    "switching to slow handshake\n");
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -2237,15 +2237,15 @@ static void NCR5380_information_transfer
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked command complete.\n", instance->host_no, scmd_id(cmd), cmd->device->lun));
+					ddprintk(KERN_DEBUG, cmd,
+						 "linked command complete.\n");
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
 					 * available.
 					 */
 					if (!cmd->next_link) {
-						sdev_printk(KERN_INFO,
-							cmd->device,
+						scmd_printk(KERN_INFO, cmd,
 							"linked command complete, no next_link\n");
 						sink = 1;
 						do_abort(instance);
@@ -2255,7 +2255,8 @@ static void NCR5380_information_transfer
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, scmd_id(cmd), cmd->device->lun));
+					ddprintk(KERN_DEBUG, cmd,
+						"linked request done, calling scsi_done().\n");
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2267,7 +2268,8 @@ static void NCR5380_information_transfer
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d, lun %s completed\n", instance->host_no, scmd_id(cmd), scsilun_to_str(&cmd->device->lun, lunstr)));
+					ddprintk(KERN_DEBUG, cmd,
+						"command completed\n");
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 
 					/* 
@@ -2350,7 +2352,10 @@ static void NCR5380_information_transfer
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, scmd_id(cmd), cmd->device->lun));
+						ddprintk(KERN_DEBUG, cmd,
+						"command for target was moved from connected to"
+						"  the disconnected_queue\n");
+
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2441,12 +2446,10 @@ static void NCR5380_information_transfer
 						scsi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
-						sdev_printk(KERN_INFO,
-							cmd->device,
+						scmd_printk(KERN_INFO, cmd,
 							"rejecting unknown message %02x\n",tmp);
 					else
-						sdev_printk(KERN_INFO,
-							cmd->device,
+						scmd_printk(KERN_INFO, cmd,
 							"rejecting unknown extended message code %02x, length %d\n", extended_msg[1], extended_msg[0]);
 
 					msgout = MESSAGE_REJECT;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index c3462e3..298b2df 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -289,6 +289,14 @@ struct NCR5380_hostdata {
 #define NCR5380_dprint(a,b)		do {} while(0)
 #define NCR5380_dprint_phase(a,b)	do {} while(0)
 
+#if 0
+#define ddprintk(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
+#else
+#define ddprintk(prefix, scmd, fmt, a...) \
+	do {} while (0)
+#endif
+
 #if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
 #endif
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 157cada..477656b 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -2256,7 +2256,6 @@ static int esp_do_freebus(struct NCR_ESP
 static int esp_bad_reconnect(struct NCR_ESP *esp)
 {
 	Scsi_Cmnd *sp;
-	char lunstr[SCSILUN_STR_LEN];
 
 	ESPLOG(("esp%d: Eieeee, reconnecting unknown command!\n",
 		esp->esp_id));
@@ -2264,24 +2263,21 @@ static int esp_bad_reconnect(struct NCR_
 	sp = esp->issue_SC;
 	ESPLOG(("esp%d: issue_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%s>", scmd_id(sp),
-			scsilun_to_str(&sp->device->lun, lunstr)));
+		ESPLOG_C(KERN_DEBUG, sp, ".. ");
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->current_SC;
 	ESPLOG(("esp%d: current_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%s>", scmd_id(sp),
-			scsilun_to_str(&sp->device->lun, lunstr)));
+		ESPLOG_C(KERN_DEBUG, sp, ".. ");
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->disconnected_SC;
 	ESPLOG(("esp%d: disconnected_SC[", esp->esp_id));
 	while(sp) {
-		ESPLOG(("<%02x,%s>", scmd_id(sp),
-			scsilun_to_str(&sp->device->lun, lunstr)));
+		ESPLOG_C(KERN_DEBUG, sp, ".. ");
 		sp = (Scsi_Cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 57ae0db..27a23e3 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1,3 +1,6 @@
+#ifndef __AACRAID_AACRAID_H__
+#define __AACRAID_AACRAID_H__
+
 #if (!defined(dprintk))
 # define dprintk(x)
 #endif
@@ -1788,3 +1791,5 @@ int probe_container(struct aac_dev *dev,
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
+
+#endif /* __AACRAID_AACRAID_H__ */
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
index af4f7fe..48393b3 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -89,7 +89,6 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
   int    size = 0;
   unsigned char i;
   unsigned char tindex;
-  char lunstr[SCSILUN_STR_LEN];
 
   for(p=first_aic7xxx; p && p->host != HBAptr; p=p->next)
     ;
@@ -263,9 +262,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
   {
     sdptr = aic_dev->SDptr;
     tindex = sdev_channel(sdptr) << 3 | sdev_id(sdptr);
-    size += sprintf(BLS, "(scsi%d:%d:%d:%s)\n",
-        p->host_no, sdev_channel(sdptr), sdev_id(sdptr),
-	scsilun_to_str(&sdptr->lun, lunstr));
+    size += sprintf(BLS, "(scsi%s)\n", sdptr->sdev_gendev.bus_id);
     size += sprintf(BLS, "  Device using %s/%s",
           (aic_dev->cur.width == MSG_EXT_WDTR_BUS_16_BIT) ?
           "Wide" : "Narrow",
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index adc4aad..1511d54 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -297,11 +297,10 @@ stop_dma:
 			}
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
-			printk(KERN_DEBUG "Channel = %d ID = %d LUN = %d CDB",c,scmd_id(workreq),workreq->device->lun);
-			for(l=0;l<workreq->cmd_len;l++)
-			{
+			scmd_printk(KERN_DEBUG, workreq, "CDB");
+			for (l = 0; l < workreq->cmd_len; l++)
 				printk(KERN_DEBUG " %x",workreq->cmnd[l]);
-			}
+			printk("\n");
 #endif	
 			
 			tmport = workport + 0x0f;
@@ -787,11 +786,11 @@ abortsnd:
 oktosend:
 #ifdef ED_DBGP
 	printk("OK to Send\n");
-	printk("CDB");
+	scmd_printk(KERN_DEBUG, workreq, "CDB");
 	for(i=0;i<workreq->cmd_len;i++) {
 		printk(" %x",workreq->cmnd[i]);
 	}
-	printk("\nChannel = %d ID = %d LUN = %d\n",c,scmd_id(workreq),workreq->device->lun);
+	printk("\n");
 #endif	
 	if (dev->dev_id == ATP885_DEVID) {
 		j = inb(dev->baseport + 0x29) & 0xfe;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 212393d..67758b5 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1116,8 +1116,7 @@ static int dc395x_queue_command(struct s
 
 	/* does the specified lun on the specified device exist */
 	if (!(acb->dcb_map[scmd_id(cmd)] & (1 << lun))) {
-		sdev_printk(KERN_INFO, cmd->device,
-			"queue_command: Ignore target\n");
+		scmd_printk(KERN_INFO, cmd, "queue_command: Ignore target\n");
 		goto complete;
 	}
 
@@ -1125,8 +1124,7 @@ static int dc395x_queue_command(struct s
 	dcb = find_dcb(acb, scmd_id(cmd), &cmd->device->lun);
 	if (!dcb) {
 		/* should never happen */
-		sdev_printk(KERN_INFO, cmd->device,
-			"queue_command: No such device\n");
+		scmd_printk(KERN_INFO, cmd, "queue_command: No such device\n");
 		goto complete;
 	}
 
@@ -1217,7 +1215,7 @@ static void dump_register_info(struct Ad
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p OOOPS!\n",
 				srb, srb->cmd);
 		else
-			sdev_printk(KERN_INFO, srb->cmd->device,
+			scmd_printk(KERN_INFO, srb->cmd,
 				"dump: srb=%p cmd=%p (pid#%li) "
 				 "cmnd=0x%02x\n",
 			    	srb, srb->cmd, srb->cmd->pid,
@@ -1314,7 +1312,7 @@ static int __dc395x_eh_bus_reset(struct 
 {
 	struct AdapterCtlBlk *acb =
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
-	sdev_printk(KERN_INFO, cmd->device,
+	scmd_printk(KERN_INFO, cmd,
 		"eh_bus_reset: (pid#%li) cmd=%p\n", cmd->pid, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
@@ -1381,7 +1379,7 @@ static int dc395x_eh_abort(struct scsi_c
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
-	sdev_printk(KERN_INFO, cmd->device,
+	scmd_printk(KERN_INFO, cmd,
 		"eh_abort: (pid#%li) cmd=%p\n", cmd->pid, cmd);
 
 	dcb = find_dcb(acb, scmd_id(cmd), &cmd->device->lun);
@@ -1616,7 +1614,7 @@ static u8 start_scsi(struct AdapterCtlBl
 			tag_number++;
 		}
 		if (tag_number >= dcb->max_command) {
-			sdev_printk(KERN_WARNING, srb->cmd->device,
+			scmd_printk(KERN_WARNING, srb->cmd,
 				"start_scsi: (pid#%li) "
 				"Out of tags)\n", srb->cmd->pid);
 			srb->state = SRB_READY;
@@ -3529,7 +3527,6 @@ static void doing_srb_done(struct Adapte
 		struct scsi_cmnd *cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
-	char lunstr[SCSILUN_STR_LEN];
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
 
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
@@ -3544,9 +3541,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("G:%li(%02i-%s) ", p->pid,
-			       scmd_id(p),
-			       scsilun_to_str(&p->device->lun, lunstr));
+			scmd_printk(KERN_INFO, p, "G:%li ", p->pid);
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3575,8 +3570,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li<%02i-%s>", p->pid, scmd_id(p),
-			       scsilun_to_str(&p->device->lun, lunstr));
+			scmd_printk(KERN_INFO, p, "W:%li", p->pid);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
 			p->result = result;
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 484e221..5818bd8 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -727,7 +727,7 @@ static int adpt_bus_reset(struct scsi_cm
 
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	memset(msg, 0, sizeof(msg));
-	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+	scmd_printk(KERN_WARNING, cmd,
 		"Bus reset: tid: %d\n", pHba->channel[scmd_channel(cmd)].tid );
 	msg[0] = FOUR_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[scmd_channel(cmd)].tid);
@@ -748,7 +748,7 @@ static int __adpt_reset(struct scsi_cmnd
 	adpt_hba* pHba;
 	int rcode;
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
-	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+	scmd_printk(KERN_WARNING, cmd,
 		"Hba Reset: tid: %d\n", pHba->channel[scmd_channel(cmd)].tid );
 	rcode =  adpt_hba_reset(pHba);
 	if(rcode == 0){
@@ -2261,7 +2261,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		case I2O_SCSI_DSC_COMMAND_TIMEOUT:
 		case I2O_SCSI_DSC_NO_ADAPTER:
 		case I2O_SCSI_DSC_RESOURCE_UNAVAILABLE:
-			dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+			scmd_printk(KERN_WARNING, cmd,
 				"SCSI Timeout-Device hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
 				hba_status, dev_status, cmd->cmnd[0]);
 			cmd->result = (DID_TIME_OUT << 16);
@@ -2302,7 +2302,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		case I2O_SCSI_DSC_QUEUE_FROZEN:
 		case I2O_SCSI_DSC_REQUEST_INVALID:
 		default:
-			dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+			scmd_printk(KERN_WARNING, cmd,
 				"SCSI error %0x-Device hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
 				detailed_status & I2O_SCSI_DSC_MASK,
 			       hba_status, dev_status, cmd->cmnd[0]);
@@ -2321,7 +2321,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 			   cmd->sense_buffer[2] == DATA_PROTECT ){
 				/* This is to handle an array failed */
 				cmd->result = (DID_TIME_OUT << 16);
-				dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+				scmd_printk(KERN_WARNING, cmd,
 					"SCSI Data Protect-Device hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
 					hba_status, dev_status, cmd->cmnd[0]);
 
@@ -2333,7 +2333,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		 * for a limitted number of retries.
 		 */
 		cmd->result = (DID_TIME_OUT << 16);
-		dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+		scmd_printk(KERN_WARNING, cmd,
 			"I2O MSG_FAIL - Device tid=%d, cmd=0x%x\n",
 			((struct adpt_device*)(cmd->device->hostdata))->tid, cmd->cmnd[0]);
 	}
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 430133b..b8bd8e7 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1811,9 +1811,8 @@ static int eata2x_queuecommand(struct sc
 	SCpnt->host_scribble = (unsigned char *)&cpp->cpp_index;
 
 	if (do_trace)
-		sdev_printk(KERN_INFO, SCpnt->device,
-			"qcomm, mbox %d, pid %ld.\n",
-		       i, SCpnt->pid);
+		scmd_printk(KERN_INFO, SCpnt,
+			"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
 
 	cpp->reqsen = 1;
 	cpp->dispri = 1;
@@ -1845,9 +1844,8 @@ static int eata2x_queuecommand(struct sc
 	if (do_dma(shost->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
-		sdev_printk(KERN_INFO, SCpnt->device,
-			"qcomm, pid %ld, adapter busy.\n",
-		       SCpnt->pid);
+		scmd_printk(KERN_INFO, SCpnt,
+			"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
 		return 1;
 	}
 
@@ -1862,16 +1860,14 @@ static int eata2x_eh_abort(struct scsi_c
 	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
-		sdev_printk(KERN_INFO, SCarg->device,
-			"abort, pid %ld inactive.\n",
-		       SCarg->pid);
+		scmd_printk(KERN_INFO, SCarg,
+			"abort, pid %ld inactive.\n", SCarg->pid);
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
-	sdev_printk(KERN_WARNING, SCarg->device,
-		"abort, mbox %d, pid %ld.\n",
-	       i, SCarg->pid);
+	scmd_printk(KERN_WARNING, SCarg,
+		"abort, mbox %d, pid %ld.\n", i, SCarg->pid);
 
 	if (i >= shost->can_queue)
 		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
@@ -1932,9 +1928,8 @@ static int eata2x_eh_host_reset(struct s
 	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	sdev_printk(KERN_INFO, SCarg->device,
-		"reset, enter, pid %ld.\n",
-	       SCarg->pid);
+	scmd_printk(KERN_INFO, SCarg,
+		"reset, enter, pid %ld.\n", SCarg->pid);
 
 	spin_lock_irq(shost->host_lock);
 
@@ -2251,7 +2246,7 @@ static int reorder(struct hostdata *ha, 
 			k = il[n];
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
-			sdev_printk(KERN_INFO, SCpnt->device,
+			scmd_printk(KERN_INFO, SCpnt,
 			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %ld"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
@@ -2298,7 +2293,7 @@ static void flush_dev(struct scsi_device
 		SCpnt = cpp->SCpnt;
 
 		if (do_dma(dev->host->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
-			sdev_printk(KERN_INFO, SCpnt->device,
+			scmd_printk(KERN_INFO, SCpnt,
 			    "%s, pid %ld, mbox %d, adapter"
 			     " busy, will abort.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
@@ -2463,7 +2458,7 @@ static irqreturn_t ihdlr(int irq, struct
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
 		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-			sdev_printk(KERN_INFO, SCpnt->device,
+			scmd_printk(KERN_INFO, SCpnt,
 				"ihdlr, pid %ld, "
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       SCpnt->pid,
@@ -2533,7 +2528,7 @@ static irqreturn_t ihdlr(int irq, struct
 	     spp->adapter_status != ASST && ha->iocount <= 1000) ||
 	    do_trace || msg_byte(spp->target_status))
 #endif
-		sdev_printk(KERN_INFO, SCpnt->device, "ihdlr, mbox %2d, err 0x%x:%x,"
+		scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"
 		       " pid %ld, reg 0x%x, count %d.\n",
 		       i, spp->adapter_status, spp->target_status,
 		       SCpnt->pid, reg, ha->iocount);
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 3a7455a..537aecf 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -384,7 +384,7 @@ static int eata_pio_queue(struct scsi_cm
 
 	cp->status = USED;	/* claim free slot */
 
-	DBG(DBG_QUEUE, sdev_printk(KERN_DEBUG, cmd->device,
+	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
 		"eata_pio_queue pid %ld, y %d\n",
 		cmd->pid, y));
 
@@ -429,7 +429,7 @@ static int eata_pio_queue(struct scsi_cm
 
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP)) {
 		cmd->result = DID_BUS_BUSY << 16;
-		sdev_printk(KERN_NOTICE, cmd->device,
+		scmd_printk(KERN_NOTICE, cmd,
 			"eata_pio_queue pid %ld, HBA busy, "
 			"returning DID_BUS_BUSY, done.\n", cmd->pid);
 		done(cmd);
@@ -444,7 +444,7 @@ static int eata_pio_queue(struct scsi_cm
 	for (x = 0; x < hd->cppadlen; x++)
 		outw(0, base + HA_RDATA);
 
-	DBG(DBG_QUEUE, sdev_printk(KERN_DEBUG, cmd->device,
+	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
 		"Queued base %#.4lx pid: %ld "
 		"slot %d irq %d\n", (long) sh->base, cmd->pid, y, sh->irq));
 
@@ -455,7 +455,7 @@ static int eata_pio_abort(struct scsi_cm
 {
 	uint loop = HZ;
 
-	DBG(DBG_ABNORM, sdev_printk(KERN_WARNING, cmd->device,
+	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
 		"eata_pio_abort called pid: %ld\n",
 		cmd->pid));
 
@@ -491,7 +491,7 @@ static int eata_pio_host_reset(struct sc
 	struct scsi_cmnd *sp;
 	struct Scsi_Host *host = cmd->device->host;
 
-	DBG(DBG_ABNORM, sdev_printk(KERN_WARNING, cmd->device,
+	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
 		"eata_pio_reset called pid:%ld\n",
 		cmd->pid));
 
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index da44f0e..e769bfd 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -674,7 +674,7 @@ static irqreturn_t interrupt_handler(int
 #ifdef IM_DEBUG_TIMEOUT
 	if (cmd) {
 		if ((cmd->target == TIMEOUT_PUN) && (scsilun_to_int(&cmd->device->lun) == TIMEOUT_LUN)) {
-			sdev_printk(KERN_INFO, cmd->device,
+			scmd_printk(KERN_INFO, cmd,
 				"IBM MCA SCSI: Ignoring interrupt\n");
 			return IRQ_HANDLED;
 		}
@@ -1861,7 +1861,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 					next_ldn(host_index) = 7;
 				if (current_ldn == next_ldn(host_index)) {	/* One circle done ? */
 					/* no non-processing ldn found */
-					sdev_printk(KERN_WARNING, cmd->device,
+					scmd_printk(KERN_WARNING, cmd,
 	"IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n"
 	"              On ldn 7-14 SCSI-commands everywhere in progress.\n"
 	"              Reporting DID_NO_CONNECT for device.\n");
@@ -1925,7 +1925,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 			local_checking_phase_flag(host_index) = 0;
 #ifdef IM_DEBUG_PROBE
 			/* Information on syslog terminal */
-			sdev_printk(KERN_INFO, cmd->device,
+			scmd_printk(KERN_INFO, cmd,
 				"IBM MCA SCSI: ldn=0x%x dynamically reassigned to device.\n", ldn);
 #endif
 			/* increase next_ldn for next dynamical assignment */
@@ -2173,7 +2173,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 		target = scmd_id(cmd);
 
 	/* get logical device number, and disable system interrupts */
-	sdev_printk(KERN_WARNING, cmd->device,
+	scmd_printk(KERN_WARNING, cmd,
 		"IBM MCA SCSI: Sending abort to device.\n");
 	ldn = get_ldn(host_index)[target][scsilun_to_int(&cmd->device->lun)];
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 269cfbe..01f8ebf 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -893,8 +893,7 @@ static int idescsi_queue (struct scsi_cm
 	idescsi_pc_t *pc = NULL;
 
 	if (!drive) {
-		sdev_printk (KERN_ERR, cmd->device,
-			"ide-scsi: drive not present\n");
+		scmd_printk (KERN_ERR, cmd, "drive not present\n");
 		goto abort;
 	}
 	scsi = drive_to_idescsi(drive);
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 4442183..18c95d3 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -343,7 +343,7 @@ static int in2000_queuecommand(Scsi_Cmnd
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
-	DB(DB_QUEUE_COMMAND, sdev_printk(KERN_DEBUG, cmd->device, "Q-%02x-%ld(", cmd->cmnd[0], cmd->pid))
+	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x-%ld(", cmd->cmnd[0], cmd->pid))
 
 /* Set up a few fields in the Scsi_Cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 07bd25c..0b4bed4 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -758,8 +758,7 @@ static int megasas_generic_reset(struct 
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	dev_printk(KERN_NOTICE, &scmd->device->sdev_gendev,
-		"megasas: RESET -%ld cmd=%x\n",
+	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x\n",
 	       scmd->serial_number, scmd->cmnd[0]);
 
 	if (instance->hw_crit_error) {
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 3590a46..128c17f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1985,11 +1985,11 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
 
 	sp = (srb_t *) cmd->SCp.ptr;
-	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+	scmd_printk(KERN_INFO, cmd,
 		"SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
-	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
-		"  cmd_len=0x%02x\n",
-	    cmd->cmd_len);
+	scmd_printk(KERN_INFO, cmd,
+		"  cmd_len=0x%02x\n", cmd->cmd_len);
+
 	printk(" CDB: ");
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 31602d0..32e9ead 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -675,8 +675,7 @@ static int scsi_eh_get_sense(struct list
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO,
-						  scmd->device,
+		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
 		rtn = scsi_request_sense(scmd);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a3c546a..abf4e42 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1411,9 +1411,9 @@ int scsi_scan_host_selected(struct Scsi_
 {
 	char lunstr[SCSILUN_STR_LEN];
 
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%s>\n",
-		__FUNCTION__, shost->host_no, channel, id,
-		scsilun_to_str(lun, lunstr)));
+	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
+		"%s: <%u:%u:%s>\n",
+		__FUNCTION__, channel, id, scsilun_to_str(lun, lunstr)));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)))
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0287861..d7cee61 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3003,14 +3003,11 @@ static int sg_proc_seq_show_dev(struct s
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
-	char lunstr[SCSILUN_STR_LEN];
 
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
-		seq_printf(s, "%d\t%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\n",
-			      scsidp->host->host_no, sdev_channel(scsidp),
-			      sdev_id(scsidp),
-			      scsilun_to_str(&scsidp->lun, lunstr),
+		seq_printf(s, "%s\t%d\t%d\t%d\t%d\t%d\n",
+			      scsidp->sdev_gendev.bus_id,
 			      (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a624127..75c6b14 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2079,7 +2079,7 @@ static int DC390_abort(struct scsi_cmnd 
 	struct dc390_acb *pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
-	sdev_printk(KERN_WARNING, cmd->device,
+	scmd_printk(KERN_WARNING, cmd,
 		"DC390: Abort command (pid %li)\n", cmd->pid);
 
 	/* abort() is too stupid for already sent commands at the moment. 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index a3bff57..927eac4 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1291,7 +1291,7 @@ static int u14_34f_queuecommand(struct s
    SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
 
    if (do_trace)
-   	sdev_printk(KERN_INFO, SCpnt->device,
+   	scmd_printk(KERN_INFO, SCpnt,
 		"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
 
    cpp->opcode = OP_SCSI;
@@ -1318,7 +1318,7 @@ static int u14_34f_queuecommand(struct s
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
       unmap_dma(i, j);
       SCpnt->host_scribble = NULL;
-      sdev_printk(KERN_INFO, SCpnt->device, 
+      scmd_printk(KERN_INFO, SCpnt,
       		"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
       return 1;
       }
@@ -1339,13 +1339,13 @@ static int u14_34f_eh_abort(struct scsi_
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
 
    if (SCarg->host_scribble == NULL) {
-      sdev_printk(KERN_INFO, SCarg->device, "abort, pid %ld inactive.\n",
+      scmd_printk(KERN_INFO, SCarg, "abort, pid %ld inactive.\n",
              SCarg->pid);
       return SUCCESS;
       }
 
    i = *(unsigned int *)SCarg->host_scribble;
-   sdev_printk(KERN_INFO, SCarg->device, "abort, mbox %d, pid %ld.\n",
+   scmd_printk(KERN_INFO, SCarg, "abort, mbox %d, pid %ld.\n",
 	       i, SCarg->pid);
 
    if (i >= sh[j]->can_queue)
@@ -1404,8 +1404,7 @@ static int u14_34f_eh_host_reset(struct 
    struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   sdev_printk(KERN_INFO, SCarg->device,
-   	"reset, enter, pid %ld.\n", SCarg->pid);
+   scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->pid);
 
    spin_lock_irq(sh[j]->host_lock);
 
@@ -1708,8 +1707,8 @@ static void flush_dev(struct scsi_device
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
 
       if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
-         sdev_printk(KERN_INFO, SCpnt->device,
-	 	"%s, pid %ld, mbox %d, adapter"\
+         scmd_printk(KERN_INFO, SCpnt,
+	 	"%s, pid %ld, mbox %d, adapter"
                 " busy, will abort.\n", (ihdlr ? "ihdlr" : "qcomm"),
                 SCpnt->pid, k);
          HD(j)->cp_stat[k] = ABORTING;
@@ -1841,7 +1840,7 @@ static irqreturn_t ihdlr(int irq, unsign
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
                (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-            sdev_printk(KERN_INFO, SCpnt->device,
+            scmd_printk(KERN_INFO, SCpnt,
 	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
                    SCpnt->pid, spp->target_status,
                    SCpnt->sense_buffer[2]);
@@ -1913,7 +1912,7 @@ static irqreturn_t ihdlr(int irq, unsign
         spp->adapter_status != ASST && HD(j)->iocount <= 1000) ||
         do_trace || msg_byte(spp->target_status))
 #endif
-      sdev_printk(KERN_INFO, SCpnt->device, "ihdlr, mbox %2d, err 0x%x:%x,"\
+      scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"\
              " pid %ld, reg 0x%x, count %d.\n",
              i, spp->adapter_status, spp->target_status, SCpnt->pid,
              reg, HD(j)->iocount);
