From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] remove an unused function from NCR53c406a.c
Date: Sat, 21 Jun 2003 16:37:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621143734.GW29247@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:17392 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264437AbTFUOXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 10:23:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au

The patch below removes an unused function from 
drivers/scsi/NCR53c406a.c .
 
I've tested the compilation with 2.5.72-mm2.
 
--- linux-2.5.72-mm2/drivers/scsi/NCR53c406a.c.old	2003-06-21 16:34:54.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/NCR53c406a.c	2003-06-21 16:35:28.000000000 +0200
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


Please apply
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

