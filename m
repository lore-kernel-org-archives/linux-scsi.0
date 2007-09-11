From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 08/24] nsp_cs.c convert to data accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 02:56:45 +0300
Message-ID: <46E72B3D.7060408@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32314 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758771AbXIKX5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:57:24 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


  - use scsi data accessors
  - cleanup !use_sg code paths
  - TODO: use next_sg() for Jens's sglist branch. Look for 2
    places with "SCp.buffer++"

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/pcmcia/nsp_cs.c |   54 ++++++++++++++++++++++++++---------------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 445cfbb..e41908b 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -144,6 +144,11 @@ static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
 
 #define NSP_DEBUG_BUF_LEN		150
 
+static inline void nsp_inc_resid(struct scsi_cmnd *SCpnt, int residInc)
+{
+	scsi_set_resid(SCpnt, scsi_get_resid(SCpnt) + residInc);
+}
+
 static void nsp_cs_message(const char *func, int line, char *type, char *fmt, ...)
 {
 	va_list args;
@@ -201,8 +206,10 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
-	nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "SCpnt=0x%p target=%d lun=%d buff=0x%p bufflen=%d use_sg=%d",
-		   SCpnt, target, SCpnt->device->lun, SCpnt->request_buffer, SCpnt->request_bufflen, SCpnt->use_sg);
+	nsp_dbg(NSP_DEBUG_QUEUECOMMAND,
+		"SCpnt=0x%p target=%d lun=%d sglist=0x%p bufflen=%d sg_count=%d",
+		SCpnt, target, SCpnt->device->lun, scsi_sglist(SCpnt),
+		scsi_bufflen(SCpnt), scsi_sg_count(SCpnt));
 	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "before CurrentSC=0x%p", data->CurrentSC);
 
 	SCpnt->scsi_done	= done;
@@ -234,7 +241,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 	SCpnt->SCp.have_data_in = IO_UNKNOWN;
 	SCpnt->SCp.sent_command = 0;
 	SCpnt->SCp.phase	= PH_UNDETERMINED;
-	SCpnt->resid	        = SCpnt->request_bufflen;
+	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
 	/* setup scratch area
 	   SCp.ptr		: buffer pointer
@@ -242,14 +249,14 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 	   SCp.buffer		: next buffer
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase		: current state of the command */
-	if (SCpnt->use_sg) {
-		SCpnt->SCp.buffer	    = (struct scatterlist *) SCpnt->request_buffer;
+	if (scsi_bufflen(SCpnt)) {
+		SCpnt->SCp.buffer	    = scsi_sglist(SCpnt);
 		SCpnt->SCp.ptr		    = BUFFER_ADDR;
 		SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 	} else {
-		SCpnt->SCp.ptr		    = (char *) SCpnt->request_buffer;
-		SCpnt->SCp.this_residual    = SCpnt->request_bufflen;
+		SCpnt->SCp.ptr		    = NULL;
+		SCpnt->SCp.this_residual    = 0;
 		SCpnt->SCp.buffer	    = NULL;
 		SCpnt->SCp.buffers_residual = 0;
 	}
@@ -730,7 +737,9 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 	ocount = data->FifoCount;
 
 	nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=0x%p resid=%d ocount=%d ptr=0x%p this_residual=%d buffers=0x%p nbuf=%d",
-		SCpnt, SCpnt->resid, ocount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual, SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual);
+		SCpnt, scsi_get_resid(SCpnt), ocount, SCpnt->SCp.ptr,
+		SCpnt->SCp.this_residual, SCpnt->SCp.buffer,
+		SCpnt->SCp.buffers_residual);
 
 	time_out = 1000;
 
@@ -780,7 +789,7 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 			return;
 		}
 
-		SCpnt->resid	       	 -= res;
+		nsp_inc_resid(SCpnt, -res);
 		SCpnt->SCp.ptr		 += res;
 		SCpnt->SCp.this_residual -= res;
 		ocount			 += res;
@@ -804,10 +813,12 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 
 	if (time_out == 0) {
 		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
-			SCpnt->resid, SCpnt->SCp.this_residual, SCpnt->SCp.buffers_residual);
+			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
+			SCpnt->SCp.buffers_residual);
 	}
 	nsp_dbg(NSP_DEBUG_DATA_IO, "read ocount=0x%x", ocount);
-	nsp_dbg(NSP_DEBUG_DATA_IO, "r cmd=%d resid=0x%x\n", data->CmdId, SCpnt->resid);
+	nsp_dbg(NSP_DEBUG_DATA_IO, "r cmd=%d resid=0x%x\n", data->CmdId,
+	                                                scsi_get_resid(SCpnt));
 }
 
 /*
@@ -825,7 +836,9 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 	ocount	 = data->FifoCount;
 
 	nsp_dbg(NSP_DEBUG_DATA_IO, "in fifocount=%d ptr=0x%p this_residual=%d buffers=0x%p nbuf=%d resid=0x%x",
-		data->FifoCount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual, SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual, SCpnt->resid);
+		data->FifoCount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual,
+		SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual,
+		scsi_get_resid(SCpnt));
 
 	time_out = 1000;
 
@@ -839,7 +852,7 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 
 			nsp_dbg(NSP_DEBUG_DATA_IO, "phase changed stat=0x%x, res=%d\n", stat, res);
 			/* Put back pointer */
-			SCpnt->resid	       	 += res;
+			nsp_inc_resid(SCpnt, res);
 			SCpnt->SCp.ptr		 -= res;
 			SCpnt->SCp.this_residual += res;
 			ocount			 -= res;
@@ -875,7 +888,7 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 			break;
 		}
 
-		SCpnt->resid	       	 -= res;
+		nsp_inc_resid(SCpnt, -res);
 		SCpnt->SCp.ptr		 += res;
 		SCpnt->SCp.this_residual -= res;
 		ocount			 += res;
@@ -895,10 +908,12 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 	data->FifoCount = ocount;
 
 	if (time_out == 0) {
-		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x", SCpnt->resid);
+		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x",
+		                                        scsi_get_resid(SCpnt));
 	}
 	nsp_dbg(NSP_DEBUG_DATA_IO, "write ocount=0x%x", ocount);
-	nsp_dbg(NSP_DEBUG_DATA_IO, "w cmd=%d resid=0x%x\n", data->CmdId, SCpnt->resid);
+	nsp_dbg(NSP_DEBUG_DATA_IO, "w cmd=%d resid=0x%x\n", data->CmdId,
+	                                                scsi_get_resid(SCpnt));
 }
 #undef RFIFO_CRIT
 #undef WFIFO_CRIT
@@ -920,9 +935,8 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
 	nsp_index_write(base, SYNCREG,	sync->SyncRegister);
 	nsp_index_write(base, ACKWIDTH, sync->AckWidth);
 
-	if (SCpnt->use_sg    == 0        ||
-	    SCpnt->resid % 4 != 0        ||
-	    SCpnt->resid     <= PAGE_SIZE ) {
+	if (scsi_get_resid(SCpnt) % 4 != 0 ||
+	    scsi_get_resid(SCpnt) <= PAGE_SIZE ) {
 		data->TransferMode = MODE_IO8;
 	} else if (nsp_burst_mode == BURST_MEM32) {
 		data->TransferMode = MODE_MEM32;
-- 
1.5.3.1


