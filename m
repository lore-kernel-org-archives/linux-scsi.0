From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [2.5 patch] remove an unused function from NCR53c406a.c
Date: Mon, 07 Jul 2003 17:46:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030707080051.AD4242C2C6@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:25523 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264801AbTGGHqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 03:46:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@suse.de

From:  Adrian Bunk <bunk@fs.tum.de>

  The patch below removes an unused function from 
  drivers/scsi/NCR53c406a.c .
   
  I've tested the compilation with 2.5.72-mm2.
   

--- trivial-2.5.74-bk4/drivers/scsi/NCR53c406a.c.orig	2003-07-07 17:36:33.000000000 +1000
+++ trivial-2.5.74-bk4/drivers/scsi/NCR53c406a.c	2003-07-07 17:36:33.000000000 +1000
@@ -170,7 +170,6 @@
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
 static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
-static void wait_intr(void);
 static void chip_init(void);
 static void calc_port_addr(void);
 #ifndef IRQ_LEV
@@ -664,26 +663,6 @@
 	return (info_msg);
 }
 
-static void wait_intr(void)
-{
-	unsigned long i = jiffies + WATCHDOG;
-
-	while (time_after(i, jiffies) && !(inb(STAT_REG) & 0xe0)) {	/* wait for a pseudo-interrupt */
-		cpu_relax();
-		barrier();
-	}
-
-	if (time_before_eq(i, jiffies)) {	/* Timed out */
-		rtrc(0);
-		current_SC->result = DID_TIME_OUT << 16;
-		current_SC->SCp.phase = idle;
-		current_SC->scsi_done(current_SC);
-		return;
-	}
-
-	NCR53c406a_intr(0, NULL, NULL);
-}
-
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	int i;
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Adrian Bunk <bunk@fs.tum.de>: [2.5 patch] remove an unused function from NCR53c406a.c
