From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: ide-scsi emulation hangs the kernel?
Date: Thu, 11 Dec 2003 09:13:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031211091352.U21958@vienna.EGENERA.COM>
References: <1071099386.28943.45.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:50916 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S264962AbTLKOOz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 09:14:55 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by coyote.egenera.com (Postfix) with ESMTP id 741AFA0531
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2003 09:05:16 -0500 (EST)
Received: from coyote.egenera.com ([127.0.0.1])
 by localhost (coyote.egenera.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 15119-06 for <linux-scsi@vger.kernel.org>;
 Thu, 11 Dec 2003 09:05:15 -0500 (EST)
Received: from vienna.egenera.com (southeast.egenera.com [63.160.166.4])
	by coyote.egenera.com (Postfix) with ESMTP id 3B5C5A052A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2003 09:05:15 -0500 (EST)
Received: (from pauld@localhost)
	by vienna.egenera.com (8.11.6/8.11.6) id hBBEDr116581
	for linux-scsi@vger.kernel.org; Thu, 11 Dec 2003 09:13:53 -0500
Content-Disposition: inline
In-Reply-To: <1071099386.28943.45.camel@patibmrh9>; from p.lavarre@ieee.org on Wed, Dec 10, 2003 at 04:36:26PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Rumor has it that on Wed, Dec 10, 2003 at 04:36:26PM -0700 Pat LaVarre said:
> > Could anybody please tell me what's wrong with
> > the ide-scsi emulation in 2.4.21?
> 

I didn't see the original email, but have had this problem in the past. 
I hit this with a TOSHIBA DVD-ROM SD-C2612 and serverworks CSB5 IDE chip.

There is no timeout handling in ide-scsi. And once it times out the 
command gets re-issued with a timeout that can go off immediately. This 
patch fixes the problem on my system. It's for 2.4.9 but from the sound 
of it should be applicable to later kernels. Your milage may vary.

Cheers,

Phil


diff -ruN -X ../patches/dontdiff linux-clean/drivers/scsi/ide-scsi.c linux-cblade/drivers/scsi/ide-scsi.c
--- linux-clean/drivers/scsi/ide-scsi.c	Fri Aug 29 10:15:16 2003
+++ linux-cblade/drivers/scsi/ide-scsi.c	Fri Aug 29 10:23:25 2003
@@ -77,6 +77,7 @@
 #define PC_DMA_IN_PROGRESS		0	/* 1 while DMA in progress */
 #define PC_WRITING			1	/* Data direction */
 #define PC_TRANSFORM			2	/* transform SCSI commands */
+#define PC_TIMEDOUT                    3       /* command timed out */
 
 /*
  *	SCSI command transformation layer
@@ -113,6 +114,11 @@
 #define IDESCSI_IREASON_COD	0x1		/* Information transferred is command */
 #define IDESCSI_IREASON_IO	0x2		/* The device requests us to read */
 
+/* 
+ *      Timeout less than given scsi cmd timeout to use.
+ */
+#define IDESCSI_TIMEOUT_DELTA     (2 * HZ)
+
 static void idescsi_discard_data (ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
@@ -279,7 +285,12 @@
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
 		if (log)
 			printk ("ide-scsi: %s: check condition for %lu\n", drive->name, pc->scsi_cmd->serial_number);
-	} else {
+	} else  if (test_bit(PC_TIMEDOUT, &pc->flags)){
+		pc->scsi_cmd->result = DID_TIME_OUT << 16;
+		if (log)
+			printk ("ide-scsi: %s: timed out  for %lu\n", drive->name, pc->scsi_cmd->serial_number);
+	}
+	else {
 		pc->scsi_cmd->result = DID_OK << 16;
 		idescsi_transform_pc2 (drive, pc);
 		if (log) {
@@ -301,7 +312,21 @@
 
 static inline unsigned long get_timeout(idescsi_pc_t *pc)
 {
-	return IDE_MAX(WAIT_CMD, pc->timeout - jiffies);
+	return IDE_MAX(WAIT_CMD, (signed long) (pc->timeout -jiffies));
+}
+
+/* timeout handler. Mark command as having timed out. 
+ */
+int idescsi_expiry (ide_drive_t *drive){
+	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_pc_t *pc=scsi->pc;
+
+#if IDESCSI_DEBUG_LOG
+	printk(KERN_INFO "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
+#endif
+	set_bit(PC_TIMEDOUT, &pc->flags);
+
+	return 0;
 }
 
 /*
@@ -320,6 +345,15 @@
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
 #endif /* IDESCSI_DEBUG_LOG */
 
+	if (test_bit(PC_TIMEDOUT, &pc->flags)){
+#if IDESCSI_DEBUG_LOG
+		printk("idescsi_pc_intr: got timed out packet  %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
+#endif
+		/* end this request now - scsi should retry it*/
+		idescsi_end_request (0, HWGROUP(drive));
+		return ide_do_reset (drive);
+	}
+
 	if (test_and_clear_bit (PC_DMA_IN_PROGRESS, &pc->flags)) {
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
@@ -363,7 +397,7 @@
 				pc->actually_transferred += temp;
 				pc->current_position += temp;
 				idescsi_discard_data (drive,bcount - temp);
-				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), NULL);
+				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
 #if IDESCSI_DEBUG_LOG
@@ -387,7 +421,7 @@
 	pc->actually_transferred+=bcount;				/* Update the current position */
 	pc->current_position+=bcount;
 
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), NULL);	/* And set the interrupt handler again */
+	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);	/* And set the interrupt handler again */
 	return ide_started;
 }
 
@@ -407,7 +441,7 @@
 		printk (KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while issuing a packet command\n");
 		return ide_do_reset (drive);
 	}
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), NULL);	/* Set the interrupt routine */
+	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);	/* Set the interrupt routine */
 	atapi_output_bytes (drive, scsi->pc->c, 12);			/* Send the actual packet */
 	return ide_started;
 }
@@ -442,7 +476,7 @@
 		(void) (HWIF(drive)->dmaproc(ide_dma_begin, drive));
 	}
 	if (test_bit (IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		ide_set_handler (drive, &idescsi_transfer_pc, get_timeout(pc), NULL);
+		ide_set_handler (drive, &idescsi_transfer_pc, get_timeout(pc), idescsi_expiry);
 		OUT_BYTE (WIN_PACKETCMD, IDE_COMMAND_REG);		/* Issue the packet command */
 		return ide_started;
 	} else {
@@ -776,7 +810,7 @@
 	pc->request_transfer = pc->buffer_size = cmd->request_bufflen;
 	pc->scsi_cmd = cmd;
 	pc->done = done;
-	pc->timeout = jiffies + cmd->timeout_per_command;
+	pc->timeout = jiffies + cmd->timeout_per_command - IDESCSI_TIMEOUT_DELTA;
 
 	if (should_transform(drive, cmd))
 		set_bit(PC_TRANSFORM, &pc->flags);


-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Principal Software Engineer                   165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
