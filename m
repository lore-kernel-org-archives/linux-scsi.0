From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] NCR5380 familly convert to accessors & !use_sg cleanup
Date: Mon, 05 Nov 2007 11:23:35 +0200
Message-ID: <472EE117.3000202@panasas.com>
References: <47276EB9.7070603@panasas.com> <1194118892.4230.1.camel@localhost.localdomain> <472EDDC9.6020109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18142 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419AbXKEJXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 04:23:38 -0500
In-Reply-To: <472EDDC9.6020109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  - This patch depends on:
      NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
  - convert to accessors and !use_sg cleanup
  - FIXME: Not sg-chain ready look for ++cmd->SCp.buffer

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/NCR5380.c       |   14 +++++++-------
 drivers/scsi/atari_NCR5380.c |   22 +++++++++++-----------
 drivers/scsi/sun3_NCR5380.c  |   22 +++++++++++-----------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2597209..1e9f828 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -295,16 +295,16 @@ static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
 	 * various queues are valid.
 	 */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_bufflen(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
 		cmd->SCp.buffer = NULL;
 		cmd->SCp.buffers_residual = 0;
-		cmd->SCp.ptr = (char *) cmd->request_buffer;
-		cmd->SCp.this_residual = cmd->request_bufflen;
+		cmd->SCp.ptr = NULL;
+		cmd->SCp.this_residual = 0;
 	}
 }
 
@@ -975,14 +975,14 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		case WRITE_6:
 		case WRITE_10:
 			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;
+			hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
 			hostdata->pendingw++;
 			break;
 		case READ:
 		case READ_6:
 		case READ_10:
 			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;
+			hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
 			hostdata->pendingr++;
 			break;
 	}
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index a9680b5..d2ca3fa 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -511,9 +511,9 @@ static inline void initialize_SCp(Scsi_Cmnd *cmd)
 	 * various queues are valid.
 	 */
 
-	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *)cmd->request_buffer;
-		cmd->SCp.buffers_residual = cmd->use_sg - 1;
+	if (scsi_bufflen(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 		/* ++roman: Try to merge some scatter-buffers if they are at
@@ -523,8 +523,8 @@ static inline void initialize_SCp(Scsi_Cmnd *cmd)
 	} else {
 		cmd->SCp.buffer = NULL;
 		cmd->SCp.buffers_residual = 0;
-		cmd->SCp.ptr = (char *)cmd->request_buffer;
-		cmd->SCp.this_residual = cmd->request_bufflen;
+		cmd->SCp.ptr = NULL;
+		cmd->SCp.this_residual = 0;
 	}
 }
 
@@ -936,21 +936,21 @@ static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 	}
 # endif
 # ifdef NCR5380_STAT_LIMIT
-	if (cmd->request_bufflen > NCR5380_STAT_LIMIT)
+	if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
 # endif
 		switch (cmd->cmnd[0]) {
 		case WRITE:
 		case WRITE_6:
 		case WRITE_10:
 			hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;
+			hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
 			hostdata->pendingw++;
 			break;
 		case READ:
 		case READ_6:
 		case READ_10:
 			hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-			hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;
+			hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
 			hostdata->pendingr++;
 			break;
 		}
@@ -1352,21 +1352,21 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd *cmd)
 {
 # ifdef NCR5380_STAT_LIMIT
-	if (cmd->request_bufflen > NCR5380_STAT_LIMIT)
+	if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
 # endif
 		switch (cmd->cmnd[0]) {
 		case WRITE:
 		case WRITE_6:
 		case WRITE_10:
 			hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
-			/*hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;*/
+			/*hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);*/
 			hostdata->pendingw--;
 			break;
 		case READ:
 		case READ_6:
 		case READ_10:
 			hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
-			/*hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;*/
+			/*hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);*/
 			hostdata->pendingr--;
 			break;
 		}
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 2dcde37..264f14a 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -515,9 +515,9 @@ static __inline__ void initialize_SCp(struct scsi_cmnd *cmd)
      * various queues are valid.
      */
 
-    if (cmd->use_sg) {
-	cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
-	cmd->SCp.buffers_residual = cmd->use_sg - 1;
+    if (scsi_bufflen(cmd)) {
+	cmd->SCp.buffer = scsi_sglist(cmd);
+	cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 	cmd->SCp.ptr = (char *) SGADDR(cmd->SCp.buffer);
 	cmd->SCp.this_residual = cmd->SCp.buffer->length;
 
@@ -528,8 +528,8 @@ static __inline__ void initialize_SCp(struct scsi_cmnd *cmd)
     } else {
 	cmd->SCp.buffer = NULL;
 	cmd->SCp.buffers_residual = 0;
-	cmd->SCp.ptr = (char *) cmd->request_buffer;
-	cmd->SCp.this_residual = cmd->request_bufflen;
+	cmd->SCp.ptr = NULL;
+	cmd->SCp.this_residual = 0;
     }
     
 }
@@ -935,7 +935,7 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
     }
 # endif
 # ifdef NCR5380_STAT_LIMIT
-    if (cmd->request_bufflen > NCR5380_STAT_LIMIT)
+    if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
 # endif
 	switch (cmd->cmnd[0])
 	{
@@ -943,14 +943,14 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
 	    case WRITE_6:
 	    case WRITE_10:
 		hostdata->time_write[cmd->device->id] -= (jiffies - hostdata->timebase);
-		hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;
+		hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);
 		hostdata->pendingw++;
 		break;
 	    case READ:
 	    case READ_6:
 	    case READ_10:
 		hostdata->time_read[cmd->device->id] -= (jiffies - hostdata->timebase);
-		hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;
+		hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);
 		hostdata->pendingr++;
 		break;
 	}
@@ -1345,7 +1345,7 @@ static void collect_stats(struct NCR5380_hostdata *hostdata,
 			  struct scsi_cmnd *cmd)
 {
 # ifdef NCR5380_STAT_LIMIT
-    if (cmd->request_bufflen > NCR5380_STAT_LIMIT)
+    if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
 # endif
 	switch (cmd->cmnd[0])
 	{
@@ -1353,14 +1353,14 @@ static void collect_stats(struct NCR5380_hostdata *hostdata,
 	    case WRITE_6:
 	    case WRITE_10:
 		hostdata->time_write[cmd->device->id] += (jiffies - hostdata->timebase);
-		/*hostdata->bytes_write[cmd->device->id] += cmd->request_bufflen;*/
+		/*hostdata->bytes_write[cmd->device->id] += scsi_bufflen(cmd);*/
 		hostdata->pendingw--;
 		break;
 	    case READ:
 	    case READ_6:
 	    case READ_10:
 		hostdata->time_read[cmd->device->id] += (jiffies - hostdata->timebase);
-		/*hostdata->bytes_read[cmd->device->id] += cmd->request_bufflen;*/
+		/*hostdata->bytes_read[cmd->device->id] += scsi_bufflen(cmd);*/
 		hostdata->pendingr--;
 		break;
 	}
-- 
1.5.3.1


