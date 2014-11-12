From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 11/37] ncr5380: Remove NCR5380_STATS
Date: Wed, 12 Nov 2014 16:11:57 +1100
Message-ID: <20141112051149.115467994@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40976 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaKLFnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:10 -0500
Content-Disposition: inline; filename=ncr5380-remove-NCR5380_STATS
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The NCR5380_STATS option is only enabled by g_NCR5380 yet it adds
clutter to all three core drivers. The atari_NCR5380.c and sun3_NCR5380.c
core drivers have a slightly different implementation of the
NCR5380_STATS option.

Out of all ten NCR5380 drivers, only one of them (g_NCR5380) actually
has the code to report on the collected stats. Aside from being unreadable,
that code seems to be broken because there's no initialization of timebase.
sun3_NCR5380.c and atari_NCR5380.c have the timebase initialization but
lack the code to report the stats.

Remove all of this code to improve readability and reduce divergence
between the three core drivers.

This patch and the next one completely eliminate the PRINTP and ANDP
pre-processor abuse.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   64 ---------------------------------------
 drivers/scsi/NCR5380.h       |    9 -----
 drivers/scsi/atari_NCR5380.c |   65 ----------------------------------------
 drivers/scsi/g_NCR5380.c     |   45 ----------------------------
 drivers/scsi/sun3_NCR5380.c  |   69 -------------------------------------------
 5 files changed, 252 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-11-12 16:11:02.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-11-12 16:11:04.000000000 +1100
@@ -833,18 +833,6 @@ static int NCR5380_init(struct Scsi_Host
 	
 	INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
 	
-#ifdef NCR5380_STATS
-	for (i = 0; i < 8; ++i) {
-		hostdata->time_read[i] = 0;
-		hostdata->time_write[i] = 0;
-		hostdata->bytes_read[i] = 0;
-		hostdata->bytes_write[i] = 0;
-	}
-	hostdata->timebase = 0;
-	hostdata->pendingw = 0;
-	hostdata->pendingr = 0;
-#endif
-
 	/* The CHECK code seems to break the 53C400. Will check it later maybe */
 	if (flags & FLAG_NCR53C400)
 		hostdata->flags = FLAG_HAS_LAST_BYTE_SENT | flags;
@@ -943,25 +931,6 @@ static int NCR5380_queue_command_lck(Scs
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
 
-#ifdef NCR5380_STATS
-	switch (cmd->cmnd[0]) {
-		case WRITE:
-		case WRITE_6:
-		case WRITE_10:
-			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
-			hostdata->pendingw++;
-			break;
-		case READ:
-		case READ_6:
-		case READ_10:
-			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
-			hostdata->pendingr++;
-			break;
-	}
-#endif
-
 	/* 
 	 * We use the host_scribble field as a pointer to the next command  
 	 * in a queue 
@@ -1207,35 +1176,6 @@ static irqreturn_t NCR5380_intr(int dumm
 
 #endif 
 
-/**
- *	collect_stats		-	collect stats on a scsi command
- *	@hostdata: adapter 
- *	@cmd: command being issued
- *
- *	Update the statistical data by parsing the command in question
- */
- 
-static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd) 
-{
-#ifdef NCR5380_STATS
-	switch (cmd->cmnd[0]) {
-	case WRITE:
-	case WRITE_6:
-	case WRITE_10:
-		hostdata->time_write[scmd_id(cmd)] += (jiffies - hostdata->timebase);
-		hostdata->pendingw--;
-		break;
-	case READ:
-	case READ_6:
-	case READ_10:
-		hostdata->time_read[scmd_id(cmd)] += (jiffies - hostdata->timebase);
-		hostdata->pendingr--;
-		break;
-	}
-#endif
-}
-
-
 /* 
  * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
  *
@@ -1464,7 +1404,6 @@ part2:
 			return -1;
 		}
 		cmd->result = DID_BAD_TARGET << 16;
-		collect_stats(hostdata, cmd);
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n", instance->host_no);
@@ -2216,7 +2155,6 @@ static void NCR5380_information_transfer
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
 					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
 					break;
@@ -2268,7 +2206,6 @@ static void NCR5380_information_transfer
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
 						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
 					} else {
-						collect_stats(hostdata, cmd);
 						cmd->scsi_done(cmd);
 					}
 
@@ -2415,7 +2352,6 @@ static void NCR5380_information_transfer
 					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
-					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:11:02.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:11:04.000000000 +1100
@@ -272,15 +272,6 @@ struct NCR5380_hostdata {
 	int select_time;			/* timer in select for target response */
 	volatile Scsi_Cmnd *selecting;
 	struct delayed_work coroutine;		/* our co-routine */
-#ifdef NCR5380_STATS
-	unsigned timebase;			/* Base for time calcs */
-	long time_read[8];			/* time to do reads */
-	long time_write[8];			/* time to do writes */
-	unsigned long bytes_read[8];		/* bytes read */
-	unsigned long bytes_write[8];		/* bytes written */
-	unsigned pendingr;
-	unsigned pendingw;
-#endif
 	struct scsi_eh_save ses;
 };
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:10:57.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:04.000000000 +1100
@@ -888,34 +888,6 @@ static int NCR5380_queue_command_lck(Scs
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
-#ifdef NCR5380_STATS
-# if 0
-	if (!hostdata->connected && !hostdata->issue_queue &&
-	    !hostdata->disconnected_queue) {
-		hostdata->timebase = jiffies;
-	}
-# endif
-# ifdef NCR5380_STAT_LIMIT
-	if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
-# endif
-		switch (cmd->cmnd[0]) {
-		case WRITE:
-		case WRITE_6:
-		case WRITE_10:
-			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
-			hostdata->pendingw++;
-			break;
-		case READ:
-		case READ_6:
-		case READ_10:
-			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
-			hostdata->pendingr++;
-			break;
-		}
-#endif
-
 	/*
 	 * We use the host_scribble field as a pointer to the next command
 	 * in a queue
@@ -1309,31 +1281,6 @@ static irqreturn_t NCR5380_intr(int irq,
 	return IRQ_RETVAL(handled);
 }
 
-#ifdef NCR5380_STATS
-static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd *cmd)
-{
-# ifdef NCR5380_STAT_LIMIT
-	if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
-# endif
-		switch (cmd->cmnd[0]) {
-		case WRITE:
-		case WRITE_6:
-		case WRITE_10:
-			hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
-			/*hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);*/
-			hostdata->pendingw--;
-			break;
-		case READ:
-		case READ_6:
-		case READ_10:
-			hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
-			/*hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);*/
-			hostdata->pendingr--;
-			break;
-		}
-}
-#endif
-
 /*
  * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
  *
@@ -1598,9 +1545,6 @@ static int NCR5380_select(struct Scsi_Ho
 			return -1;
 		}
 		cmd->result = DID_BAD_TARGET << 16;
-#ifdef NCR5380_STATS
-		collect_stats(hostdata, cmd);
-#endif
 #ifdef SUPPORT_TAGS
 		cmd_free_tag(cmd);
 #endif
@@ -2127,9 +2071,6 @@ static void NCR5380_information_transfer
 					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
 						   "done, calling scsi_done().\n",
 						   HOSTNO, cmd->device->id, cmd->device->lun);
-#ifdef NCR5380_STATS
-					collect_stats(hostdata, cmd);
-#endif
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
 					break;
@@ -2209,9 +2150,6 @@ static void NCR5380_information_transfer
 						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
 					} else {
-#ifdef NCR5380_STATS
-						collect_stats(hostdata, cmd);
-#endif
 						cmd->scsi_done(cmd);
 					}
 
@@ -2396,9 +2334,6 @@ static void NCR5380_information_transfer
 #endif
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
-#ifdef NCR5380_STATS
-					collect_stats(hostdata, cmd);
-#endif
 					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					falcon_release_lock_if_possible(hostdata);
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-11-12 16:11:02.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-11-12 16:11:04.000000000 +1100
@@ -69,8 +69,6 @@
 #define NCR53C400_PSEUDO_DMA 1
 #define PSEUDO_DMA
 #define NCR53C400
-#define NCR5380_STATS
-#undef NCR5380_STAT_LIMIT
 #endif
 
 #include <asm/io.h>
@@ -779,9 +777,6 @@ static int generic_NCR5380_show_info(str
 	int i;
 	Scsi_Cmnd *ptr;
 	struct NCR5380_hostdata *hostdata;
-#ifdef NCR5380_STATS
-	struct scsi_device *dev;
-#endif
 
 	NCR5380_setup(scsi_ptr);
 	hostdata = (struct NCR5380_hostdata *) scsi_ptr->hostdata;
@@ -805,46 +800,6 @@ static int generic_NCR5380_show_info(str
 	else
 		PRINTP("on interrupt %d\n" ANDP scsi_ptr->irq);
 
-#ifdef NCR5380_STATS
-	if (hostdata->connected || hostdata->issue_queue || hostdata->disconnected_queue)
-		PRINTP("There are commands pending, transfer rates may be crud\n");
-	if (hostdata->pendingr)
-		PRINTP("  %d pending reads" ANDP hostdata->pendingr);
-	if (hostdata->pendingw)
-		PRINTP("  %d pending writes" ANDP hostdata->pendingw);
-	if (hostdata->pendingr || hostdata->pendingw)
-		PRINTP("\n");
-	shost_for_each_device(dev, scsi_ptr) {
-		unsigned long br = hostdata->bytes_read[dev->id];
-		unsigned long bw = hostdata->bytes_write[dev->id];
-		long tr = hostdata->time_read[dev->id] / HZ;
-		long tw = hostdata->time_write[dev->id] / HZ;
-
-		PRINTP("  T:%d %s " ANDP dev->id ANDP scsi_device_type(dev->type));
-		for (i = 0; i < 8; i++)
-			if (dev->vendor[i] >= 0x20)
-				seq_putc(m, dev->vendor[i]);
-		seq_putc(m, ' ');
-		for (i = 0; i < 16; i++)
-			if (dev->model[i] >= 0x20)
-				seq_putc(m, dev->model[i]);
-		seq_putc(m, ' ');
-		for (i = 0; i < 4; i++)
-			if (dev->rev[i] >= 0x20)
-				seq_putc(m, dev->rev[i]);
-		seq_putc(m, ' ');
-
-		PRINTP("\n%10ld kb read    in %5ld secs" ANDP br / 1024 ANDP tr);
-		if (tr)
-			PRINTP(" @ %5ld bps" ANDP br / tr);
-
-		PRINTP("\n%10ld kb written in %5ld secs" ANDP bw / 1024 ANDP tw);
-		if (tw)
-			PRINTP(" @ %5ld bps" ANDP bw / tw);
-		PRINTP("\n");
-	}
-#endif
-
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
 		PRINTP("REQ not asserted, phase unknown.\n");
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:10:57.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:11:04.000000000 +1100
@@ -836,36 +836,6 @@ static int NCR5380_queue_command_lck(str
     }
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
-
-#ifdef NCR5380_STATS
-# if 0
-    if (!hostdata->connected && !hostdata->issue_queue &&
-	!hostdata->disconnected_queue) {
-	hostdata->timebase = jiffies;
-    }
-# endif
-# ifdef NCR5380_STAT_LIMIT
-    if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
-# endif
-	switch (cmd->cmnd[0])
-	{
-	    case WRITE:
-	    case WRITE_6:
-	    case WRITE_10:
-		hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-		hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
-		hostdata->pendingw++;
-		break;
-	    case READ:
-	    case READ_6:
-	    case READ_10:
-		hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-		hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
-		hostdata->pendingr++;
-		break;
-	}
-#endif
-
     /* 
      * We use the host_scribble field as a pointer to the next command  
      * in a queue 
@@ -1246,33 +1216,6 @@ static irqreturn_t NCR5380_intr (int irq
     return IRQ_RETVAL(handled);
 }
 
-#ifdef NCR5380_STATS
-static void collect_stats(struct NCR5380_hostdata *hostdata,
-			  struct scsi_cmnd *cmd)
-{
-# ifdef NCR5380_STAT_LIMIT
-    if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
-# endif
-	switch (cmd->cmnd[0])
-	{
-	    case WRITE:
-	    case WRITE_6:
-	    case WRITE_10:
-		hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
-		/*hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);*/
-		hostdata->pendingw--;
-		break;
-	    case READ:
-	    case READ_6:
-	    case READ_10:
-		hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
-		/*hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);*/
-		hostdata->pendingr--;
-		break;
-	}
-}
-#endif
-
 /* 
  * Function : int NCR5380_select(struct Scsi_Host *instance,
  *				 struct scsi_cmnd *cmd)
@@ -1538,9 +1481,6 @@ static int NCR5380_select(struct Scsi_Ho
 	    return -1;
 	}
 	cmd->result = DID_BAD_TARGET << 16;
-#ifdef NCR5380_STATS
-	collect_stats(hostdata, cmd);
-#endif
 #ifdef SUPPORT_TAGS
 	cmd_free_tag( cmd );
 #endif
@@ -2090,9 +2030,6 @@ static void NCR5380_information_transfer
 		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
 			       "done, calling scsi_done().\n",
 			       HOSTNO, cmd->device->id, cmd->device->lun);
-#ifdef NCR5380_STATS
-		    collect_stats(hostdata, cmd);
-#endif
 		    cmd->scsi_done(cmd);
 		    cmd = hostdata->connected;
 		    break;
@@ -2174,9 +2111,6 @@ static void NCR5380_information_transfer
 			dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 				  "issue queue\n", H_NO(cmd));
 		   } else {
-#ifdef NCR5380_STATS
-		       collect_stats(hostdata, cmd);
-#endif
 		       cmd->scsi_done(cmd);
 		    }
 
@@ -2359,9 +2293,6 @@ static void NCR5380_information_transfer
 #endif
 		    hostdata->connected = NULL;
 		    cmd->result = DID_ERROR << 16;
-#ifdef NCR5380_STATS
-		    collect_stats(hostdata, cmd);
-#endif
 		    cmd->scsi_done(cmd);
 		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		    return;


