From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove an unused function from NC53c406a
Date: Wed, 19 May 2004 22:34:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519203430.GB10507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:7580 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264530AbUESUed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 16:34:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.25/drivers/scsi/NCR53c406a.c	Thu Jul 31 16:32:16 2003
+++ edited/drivers/scsi/NCR53c406a.c	Wed May 19 17:46:14 2004
@@ -170,7 +170,6 @@
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
 static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
-static void wait_intr(void);
 static void chip_init(void);
 static void calc_port_addr(void);
 #ifndef IRQ_LEV
@@ -663,26 +662,6 @@
 {
 	DEB(printk("NCR53c406a_info called\n"));
 	return (info_msg);
-}
-
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
 }
 
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
