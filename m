From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some warning fixes
Date: Thu, 8 May 2003 21:04:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508210410.B28294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:38159 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261969AbTEHSvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 14:51:35 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org



--- 1.32/drivers/scsi/advansys.c	Sun May  4 05:56:43 2003
+++ edited/drivers/scsi/advansys.c	Thu May  8 18:31:08 2003
@@ -4303,7 +4303,6 @@
     int                 leftlen;
     char                *curbuf;
     off_t               advoffset;
-    Scsi_Device         *scd;
 #ifdef ADVANSYS_STATS
     int                 tgt_id;
 #endif /* ADVANSYS_STATS */
===== drivers/scsi/aha1542.c 1.26 vs edited =====
--- 1.26/drivers/scsi/aha1542.c	Sun May  4 05:56:43 2003
+++ edited/drivers/scsi/aha1542.c	Thu May  8 18:24:14 2003
@@ -67,7 +67,7 @@
 		       int nseg,
 		       int badseg)
 {
-	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%x length %d\n",
+	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%x length %ld\n",
 	       badseg, nseg,
 	       page_address(sgpnt[badseg].page) + sgpnt[badseg].offset,
 	       SCSI_SG_PA(&sgpnt[badseg]),
===== drivers/scsi/eata_pio.c 1.16 vs edited =====
--- 1.16/drivers/scsi/eata_pio.c	Sat Apr 26 10:28:20 2003
+++ edited/drivers/scsi/eata_pio.c	Thu May  8 18:24:14 2003
@@ -106,7 +106,6 @@
 			      int length, int hostno, int rw)
 {
     struct Scsi_Host *shost;
-    struct scsi_device *sdev;
     static u8 buff[512];
     int size, len = 0;
     off_t begin = 0, pos = 0;
===== drivers/scsi/fd_mcs.c 1.12 vs edited =====
--- 1.12/drivers/scsi/fd_mcs.c	Sun May  4 05:56:43 2003
+++ edited/drivers/scsi/fd_mcs.c	Thu May  8 18:24:14 2003
@@ -740,7 +740,7 @@
 #if DEBUG_RACE
 		in_interrupt_flag = 0;
 #endif
-		return;
+		return IRQ_HANDLED;
 	} else if (current_SC->SCp.phase & in_selection) {
 		status = inb(SCSI_Status_port);
 		if (!(status & 0x01)) {
--- 1.10/drivers/scsi/nsp32.c	Sat Apr 26 10:28:25 2003
+++ edited/drivers/scsi/nsp32.c	Thu May  8 18:24:14 2003
@@ -2420,7 +2420,6 @@
 static void nsp32_msgout_occur(nsp32_hw_data *data)
 {
 	unsigned int base = data->BaseAddress;
-	unsigned short command;
 	long new_sgtp;
 	int i;
 	
--- 1.27/drivers/scsi/u14-34f.c	Sun May  4 05:56:46 2003
+++ edited/drivers/scsi/u14-34f.c	Thu May  8 18:24:15 2003
@@ -1897,7 +1897,8 @@
    unsigned long spin_flags;
 
    /* Check if the interrupt must be processed by this handler */
-   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards) return;
+   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
+	   return IRQ_NONE;
 
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
    ihdlr(irq, j);
===== drivers/scsi/ultrastor.c 1.17 vs edited =====
--- 1.17/drivers/scsi/ultrastor.c	Sun May  4 05:56:46 2003
+++ edited/drivers/scsi/ultrastor.c	Thu May  8 18:24:15 2003
@@ -252,7 +252,7 @@
 #if ULTRASTOR_MAX_CMDS == 1
   unsigned char mscp_busy;
 #else
-  unsigned short mscp_free;
+  unsigned long mscp_free;
 #endif
   volatile unsigned char aborted[ULTRASTOR_MAX_CMDS];
   struct mscp mscp[ULTRASTOR_MAX_CMDS];
===== drivers/scsi/wd7000.c 1.23 vs edited =====
--- 1.23/drivers/scsi/wd7000.c	Sun Apr 27 05:12:47 2003
+++ edited/drivers/scsi/wd7000.c	Thu May  8 18:24:15 2003
@@ -1375,7 +1375,6 @@
 static int wd7000_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
 {
 	struct Scsi_Host *host = NULL;
-	Scsi_Device *scd;
 	Adapter *adapter;
 	unsigned long flags;
 	char *pos = buffer;
