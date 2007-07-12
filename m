From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 4/4] aha152x.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 13:09:13 +0300
Message-ID: <4695FDC9.6090905@panasas.com>
References: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13238 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757914AbXGLKJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 06:09:33 -0400
In-Reply-To: <4695F76F.5000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  And finally this is the regular !use_sg cleanup
  and use of accessors.
---
 drivers/scsi/aha152x.c |   91 +++++++++++++++++++++++++-----------------------
 1 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index c2f4823..e1330a4 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -322,6 +322,12 @@ static LIST_HEAD(aha152x_host_list);
                         (cmd) ? ((cmd)->device->id & 0x0f) : -1, \
 			(cmd) ? ((cmd)->device->lun & 0x07) : -1
 
+static inline void
+CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
+{
+	scsi_set_resid(cmd, scsi_get_resid(cmd) + inc);
+}
+
 #define DELAY_DEFAULT 1000
 
 #if defined(PCMCIA)
@@ -975,13 +981,13 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 #if defined(AHA152X_DEBUG)
 	if (HOSTDATA(shpnt)->debug & debug_queue) {
 		printk(INFO_LEAD "queue: %p; cmd_len=%d pieces=%d size=%u cmnd=",
-		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len, SCpnt->use_sg, SCpnt->request_bufflen);
+		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len,
+		       scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
 		__scsi_print_command(SCpnt->cmnd);
 	}
 #endif
 
 	SCpnt->scsi_done	= done;
-	SCpnt->resid 		= SCpnt->request_bufflen;
 	SCpnt->SCp.phase	= not_issued | phase;
 	SCpnt->SCp.Status	= 0x1; /* Ilegal status by SCSI standard */
 	SCpnt->SCp.Message	= 0;
@@ -1011,30 +1017,24 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase            : current state of the command */
 
-	if (phase & (check_condition|resetting)) {
+	if ((phase & (check_condition|resetting)) || !scsi_sglist(SCpnt)) {
 		if (phase & check_condition) {
 			SCpnt->SCp.ptr           = SCpnt->sense_buffer;
 			SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
-			SCpnt->resid             = sizeof(SCpnt->sense_buffer);
+			scsi_set_resid(SCpnt, sizeof(SCpnt->sense_buffer));
 		} else {
 			SCpnt->SCp.ptr           = NULL;
 			SCpnt->SCp.this_residual = 0;
-			SCpnt->resid             = 0;
+			scsi_set_resid(SCpnt, 0);
 		}
 		SCpnt->SCp.buffer           = NULL;
 		SCpnt->SCp.buffers_residual = 0;
 	} else {
-	if (SCpnt->use_sg) {
-		SCpnt->SCp.buffer           = (struct scatterlist *) SCpnt->request_buffer;
+		scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
+		SCpnt->SCp.buffer           = scsi_sglist(SCpnt);
 		SCpnt->SCp.ptr              = SG_ADDRESS(SCpnt->SCp.buffer);
 		SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
-	} else {
-		SCpnt->SCp.ptr              = (char *) SCpnt->request_buffer;
-		SCpnt->SCp.this_residual    = SCpnt->request_bufflen;
-		SCpnt->SCp.buffer           = NULL;
-		SCpnt->SCp.buffers_residual = 0;
-	}
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 	}
 
 	DO_LOCK(flags);
@@ -1520,8 +1520,8 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			/* target sent DISCONNECT */
 			DPRINTK(debug_selection, DEBUG_LEAD "target disconnected at %d/%d\n",
 				CMDINFO(CURRENT_SC),
-				CURRENT_SC->resid,
-				CURRENT_SC->request_bufflen);
+				scsi_get_resid(CURRENT_SC),
+				scsi_bufflen(CURRENT_SC));
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->disconnections++;
 #endif
@@ -1559,7 +1559,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			/* restore old command */
 			memcpy(cmd->cmnd, sc->aha_orig_cmnd, sizeof(cmd->cmnd));
 			cmd->cmd_len = sc->aha_orig_cmd_len;
-			cmd->resid = sc->aha_orig_resid;
+			scsi_set_resid(cmd, sc->aha_orig_resid);
 
 			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
 
@@ -1589,7 +1589,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 				memcpy(sc->aha_orig_cmnd, ptr->cmnd,
 				                            sizeof(ptr->cmnd));
 				sc->aha_orig_cmd_len = ptr->cmd_len;
-				sc->aha_orig_resid = ptr->resid;
+				sc->aha_orig_resid = scsi_get_resid(ptr);
 
 				ptr->cmnd[0]         = REQUEST_SENSE;
 				ptr->cmnd[1]         = 0;
@@ -2174,7 +2174,8 @@ static void datai_init(struct Scsi_Host *shpnt)
 	DATA_LEN=0;
 	DPRINTK(debug_datai,
 		DEBUG_LEAD "datai_init: request_bufflen=%d resid=%d\n",
-		CMDINFO(CURRENT_SC), CURRENT_SC->request_bufflen, CURRENT_SC->resid);
+		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
+		scsi_get_resid(CURRENT_SC));
 }
 
 static void datai_run(struct Scsi_Host *shpnt)
@@ -2287,11 +2288,12 @@ static void datai_run(struct Scsi_Host *shpnt)
 
 static void datai_end(struct Scsi_Host *shpnt)
 {
-	CURRENT_SC->resid -= GETSTCNT();
+	CMD_INC_RESID(CURRENT_SC, -GETSTCNT());
 
 	DPRINTK(debug_datai,
 		DEBUG_LEAD "datai_end: request_bufflen=%d resid=%d stcnt=%d\n",
-		CMDINFO(CURRENT_SC), CURRENT_SC->request_bufflen, CURRENT_SC->resid, GETSTCNT());
+		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
+		scsi_get_resid(CURRENT_SC), GETSTCNT());
 
 	SETPORT(SXFRCTL0, CH1|CLRSTCNT);
 	SETPORT(DMACNTRL0, 0);
@@ -2312,11 +2314,12 @@ static void datao_init(struct Scsi_Host *shpnt)
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, ENSCSIPERR | ENSCSIRST | ENPHASEMIS | ENBUSFREE );
 
-	DATA_LEN = CURRENT_SC->resid;
+	DATA_LEN = scsi_get_resid(CURRENT_SC);
 
 	DPRINTK(debug_datao,
 		DEBUG_LEAD "datao_init: request_bufflen=%d; resid=%d\n",
-		CMDINFO(CURRENT_SC), CURRENT_SC->request_bufflen, CURRENT_SC->resid);
+		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
+		scsi_get_resid(CURRENT_SC));
 }
 
 static void datao_run(struct Scsi_Host *shpnt)
@@ -2340,7 +2343,7 @@ static void datao_run(struct Scsi_Host *shpnt)
 			SETPORT(DMACNTRL0,WRITE_READ|ENDMA|_8BIT);
 			SETPORT(DATAPORT, *CURRENT_SC->SCp.ptr++);
 			CURRENT_SC->SCp.this_residual--;
-			CURRENT_SC->resid--;
+			CMD_INC_RESID(CURRENT_SC, -1);
 			SETPORT(DMACNTRL0,WRITE_READ|ENDMA);
 		}
 
@@ -2349,7 +2352,7 @@ static void datao_run(struct Scsi_Host *shpnt)
 			outsw(DATAPORT, CURRENT_SC->SCp.ptr, data_count);
 			CURRENT_SC->SCp.ptr           += 2 * data_count;
 			CURRENT_SC->SCp.this_residual -= 2 * data_count;
-			CURRENT_SC->resid             -= 2 * data_count;
+			CMD_INC_RESID(CURRENT_SC, -2 * data_count);
 	  	}
 
 		if(CURRENT_SC->SCp.this_residual==0 && CURRENT_SC->SCp.buffers_residual>0) {
@@ -2375,35 +2378,34 @@ static void datao_run(struct Scsi_Host *shpnt)
 static void datao_end(struct Scsi_Host *shpnt)
 {
 	if(TESTLO(DMASTAT, DFIFOEMP)) {
-		int data_count = (DATA_LEN - CURRENT_SC->resid) - GETSTCNT();
+		int data_count = (DATA_LEN - scsi_get_resid(CURRENT_SC)) -
+		                                                    GETSTCNT();
 
 		DPRINTK(debug_datao, DEBUG_LEAD "datao: %d bytes to resend (%d written, %d transferred)\n",
 			CMDINFO(CURRENT_SC),
 			data_count,
-			DATA_LEN-CURRENT_SC->resid,
+			DATA_LEN - scsi_get_resid(CURRENT_SC),
 			GETSTCNT());
 
-		CURRENT_SC->resid += data_count;
+		CMD_INC_RESID(CURRENT_SC, data_count);
 
-		if(CURRENT_SC->use_sg) {
-			data_count -= CURRENT_SC->SCp.ptr - SG_ADDRESS(CURRENT_SC->SCp.buffer);
-			while(data_count>0) {
-				CURRENT_SC->SCp.buffer--;
-				CURRENT_SC->SCp.buffers_residual++;
-				data_count -= CURRENT_SC->SCp.buffer->length;
-			}
-			CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer) - data_count;
-			CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length + data_count;
-		} else {
-			CURRENT_SC->SCp.ptr           -= data_count;
-			CURRENT_SC->SCp.this_residual += data_count;
+		data_count -= CURRENT_SC->SCp.ptr -
+		                             SG_ADDRESS(CURRENT_SC->SCp.buffer);
+		while(data_count>0) {
+			CURRENT_SC->SCp.buffer--;
+			CURRENT_SC->SCp.buffers_residual++;
+			data_count -= CURRENT_SC->SCp.buffer->length;
 		}
+		CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) -
+		                                                     data_count;
+		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length +
+		                                                     data_count;
 	}
 
 	DPRINTK(debug_datao, DEBUG_LEAD "datao_end: request_bufflen=%d; resid=%d; stcnt=%d\n",
 		CMDINFO(CURRENT_SC),
-		CURRENT_SC->request_bufflen,
-		CURRENT_SC->resid,
+		scsi_bufflen(CURRENT_SC),
+		scsi_get_resid(CURRENT_SC),
 		GETSTCNT());
 
 	SETPORT(SXFRCTL0, CH1|CLRCH1|CLRSTCNT);
@@ -2930,7 +2932,7 @@ static void show_command(Scsi_Cmnd *ptr)
 	__scsi_print_command(ptr->cmnd);
 
 	printk(KERN_DEBUG "); request_bufflen=%d; resid=%d; phase |",
-	       ptr->request_bufflen, ptr->resid);
+	       scsi_bufflen(ptr), scsi_get_resid(ptr));
 
 	if (ptr->SCp.phase & not_issued)
 		printk("not issued|");
@@ -3000,7 +3002,8 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
 
 	SPRINTF("); resid=%d; residual=%d; buffers=%d; phase |",
-		ptr->resid, ptr->SCp.this_residual, ptr->SCp.buffers_residual);
+		scsi_get_resid(ptr), ptr->SCp.this_residual,
+		ptr->SCp.buffers_residual);
 
 	if (ptr->SCp.phase & not_issued)
 		SPRINTF("not issued|");
-- 
1.5.2.2.249.g45fd


