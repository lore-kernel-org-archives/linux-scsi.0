From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix wd7000 for scsi command block changes
Date: Mon, 10 Feb 2003 09:01:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030210090140.A11628@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.16/drivers/scsi/wd7000.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/wd7000.c	Thu Feb  6 11:54:19 2003
@@ -1122,13 +1122,13 @@
 	register unchar *cdb = (unchar *) SCpnt->cmnd;
 	register unchar idlun;
 	register short cdblen;
-	Adapter *host = (Adapter *) SCpnt->host->hostdata;
+	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	cdblen = SCpnt->cmd_len;
-	idlun = ((SCpnt->target << 5) & 0xe0) | (SCpnt->lun & 7);
+	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
 	SCpnt->scsi_done = done;
 	SCpnt->SCp.phase = 1;
-	scb = alloc_scbs(SCpnt->host, 1);
+	scb = alloc_scbs(SCpnt->device->host, 1);
 	scb->idlun = idlun;
 	memcpy(scb->cdb, cdb, cdblen);
 	scb->direc = 0x40;	/* Disable direction check */
@@ -1141,7 +1141,7 @@
 		struct scatterlist *sg = (struct scatterlist *) SCpnt->request_buffer;
 		unsigned i;
 
-		if (SCpnt->host->sg_tablesize == SG_NONE) {
+		if (SCpnt->device->host->sg_tablesize == SG_NONE) {
 			panic("wd7000_queuecommand: scatter/gather not supported.\n");
 		}
 		dprintk("Using scatter/gather with %d elements.\n", SCpnt->use_sg);
@@ -1646,7 +1646,7 @@
  */
 static int wd7000_abort(Scsi_Cmnd * SCpnt)
 {
-	Adapter *host = (Adapter *) SCpnt->host->hostdata;
+	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	if (inb(host->iobase + ASC_STAT) & INT_IM) {
 		printk("wd7000_abort: lost interrupt\n");
@@ -1677,7 +1677,7 @@
 
 static int wd7000_host_reset(Scsi_Cmnd * SCpnt)
 {
-	Adapter *host = (Adapter *) SCpnt->host->hostdata;
+	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	if (wd7000_adapter_reset(host) < 0)
 		return FAILED;
