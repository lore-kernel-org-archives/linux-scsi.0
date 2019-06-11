From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] NCR5380: Support chained sg lists
Date: Tue, 11 Jun 2019 13:25:09 +1000
Message-ID: <739c214bafcb9af3f6d5037cc03f57f692966675.1560223509.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

My understanding is that support for chained scatterlists is to
become mandatory for LLDs.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d9fa9cf2fd8b..536426f25e86 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -149,12 +149,10 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
 
 	if (scsi_bufflen(cmd)) {
 		cmd->SCp.buffer = scsi_sglist(cmd);
-		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
 		cmd->SCp.buffer = NULL;
-		cmd->SCp.buffers_residual = 0;
 		cmd->SCp.ptr = NULL;
 		cmd->SCp.this_residual = 0;
 	}
@@ -163,6 +161,17 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
 	cmd->SCp.Message = 0;
 }
 
+static inline void advance_sg_buffer(struct scsi_cmnd *cmd)
+{
+	struct scatterlist *s = cmd->SCp.buffer;
+
+	if (!cmd->SCp.this_residual && s && !sg_is_last(s)) {
+		cmd->SCp.buffer = sg_next(s);
+		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+		cmd->SCp.this_residual = cmd->SCp.buffer->length;
+	}
+}
+
 /**
  * NCR5380_poll_politely2 - wait for two chip register values
  * @hostdata: host private data
@@ -1670,12 +1679,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 			    sun3_dma_setup_done != cmd) {
 				int count;
 
-				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
-					++cmd->SCp.buffer;
-					--cmd->SCp.buffers_residual;
-					cmd->SCp.this_residual = cmd->SCp.buffer->length;
-					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-				}
+				advance_sg_buffer(cmd);
 
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);
 
@@ -1725,15 +1729,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				 * scatter-gather list, move onto the next one.
 				 */
 
-				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
-					++cmd->SCp.buffer;
-					--cmd->SCp.buffers_residual;
-					cmd->SCp.this_residual = cmd->SCp.buffer->length;
-					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-					dsprintk(NDEBUG_INFORMATION, instance, "%d bytes and %d buffers left\n",
-					         cmd->SCp.this_residual,
-					         cmd->SCp.buffers_residual);
-				}
+				advance_sg_buffer(cmd);
+				dsprintk(NDEBUG_INFORMATION, instance,
+					"this residual %d, sg ents %d\n",
+					cmd->SCp.this_residual,
+					sg_nents(cmd->SCp.buffer));
 
 				/*
 				 * The preferred transfer method is going to be
@@ -2126,12 +2126,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	if (sun3_dma_setup_done != tmp) {
 		int count;
 
-		if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
-			++tmp->SCp.buffer;
-			--tmp->SCp.buffers_residual;
-			tmp->SCp.this_residual = tmp->SCp.buffer->length;
-			tmp->SCp.ptr = sg_virt(tmp->SCp.buffer);
-		}
+		advance_sg_buffer(tmp);
 
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);
 
-- 
2.21.0
