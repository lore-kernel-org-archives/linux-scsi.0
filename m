From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 4/5] NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon, 10 Sep 2007 22:37:45 +0300
Message-ID: <46E59D09.1070907@panasas.com>
References: <46E59760.9020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30015 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965245AbXIJTiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 15:38:12 -0400
In-Reply-To: <46E59760.9020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/NCR5380.c       |   23 +++++++++--------------
 drivers/scsi/NCR5380.h       |    7 +++++++
 drivers/scsi/atari_NCR5380.c |   23 ++++++++---------------
 drivers/scsi/sun3_NCR5380.c  |   18 +++++++-----------
 4 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index f8e449a..575c715 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1542,9 +1542,7 @@ part2:
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 
-	if (cmd->SCp.ptr != (char *)cmd->sense_buffer) {
-		initialize_SCp(cmd);
-	}
+	initialize_SCp(cmd);
 
 	return 0;
 
@@ -2280,19 +2278,16 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
 #ifdef AUTOSENSE
+					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
+						hostdata->ses.cmd_len) {
+						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+						hostdata->ses.cmd_len = 0 ;
+					}
+
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+
 						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
-						cmd->cmnd[0] = REQUEST_SENSE;
-						cmd->cmnd[1] &= 0xe0;
-						cmd->cmnd[2] = 0;
-						cmd->cmnd[3] = 0;
-						cmd->cmnd[4] = sizeof(cmd->sense_buffer);
-						cmd->cmnd[5] = 0;
-
-						cmd->SCp.buffer = NULL;
-						cmd->SCp.buffers_residual = 0;
-						cmd->SCp.ptr = (char *) cmd->sense_buffer;
-						cmd->SCp.this_residual = sizeof(cmd->sense_buffer);
 
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index bccf13f..f9587e6 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -30,6 +30,10 @@
 
 #include <linux/interrupt.h>
 
+#ifdef AUTOSENSE
+#include <scsi/scsi_eh.h>
+#endif
+
 #define NCR5380_PUBLIC_RELEASE 7
 #define NCR53C400_PUBLIC_RELEASE 2
 
@@ -281,6 +285,9 @@ struct NCR5380_hostdata {
 	unsigned pendingr;
 	unsigned pendingw;
 #endif
+#ifdef AUTOSENSE
+	struct scsi_eh_save ses;
+#endif
 };
 
 #ifdef __KERNEL__
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 03dbe60..b253d37 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2235,24 +2235,17 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
 #ifdef AUTOSENSE
+					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
+						hostdata->ses.cmd_len) {
+						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+						hostdata->ses.cmd_len = 0 ;
+					}
+
 					if ((cmd->cmnd[0] != REQUEST_SENSE) &&
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+
 						ASEN_PRINTK("scsi%d: performing request sense\n", HOSTNO);
-						cmd->cmnd[0] = REQUEST_SENSE;
-						cmd->cmnd[1] &= 0xe0;
-						cmd->cmnd[2] = 0;
-						cmd->cmnd[3] = 0;
-						cmd->cmnd[4] = sizeof(cmd->sense_buffer);
-						cmd->cmnd[5] = 0;
-						cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
-
-						cmd->use_sg = 0;
-						/* this is initialized from initialize_SCp
-						cmd->SCp.buffer = NULL;
-						cmd->SCp.buffers_residual = 0;
-						*/
-						cmd->request_buffer = (char *) cmd->sense_buffer;
-						cmd->request_bufflen = sizeof(cmd->sense_buffer);
 
 						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 98e3fe1..74081dd 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2254,25 +2254,21 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 		    
 #ifdef AUTOSENSE
+		    if ((cmd->cmnd[0] == REQUEST_SENSE) &&
+			                        hostdata->ses.cmd_len) {
+			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+			hostdata->ses.cmd_len = 0 ;
+		    }
+
 		    if ((cmd->cmnd[0] != REQUEST_SENSE) && 
 			(status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 			ASEN_PRINTK("scsi%d: performing request sense\n",
 				    HOSTNO);
-			cmd->cmnd[0] = REQUEST_SENSE;
-			cmd->cmnd[1] &= 0xe0;
-			cmd->cmnd[2] = 0;
-			cmd->cmnd[3] = 0;
-			cmd->cmnd[4] = sizeof(cmd->sense_buffer);
-			cmd->cmnd[5] = 0;
-			cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
-
-			cmd->use_sg = 0;
 			/* this is initialized from initialize_SCp 
 			cmd->SCp.buffer = NULL;
 			cmd->SCp.buffers_residual = 0;
 			*/
-			cmd->request_buffer = (char *) cmd->sense_buffer;
-			cmd->request_bufflen = sizeof(cmd->sense_buffer);
 
 			local_irq_save(flags);
 			LIST(cmd,hostdata->issue_queue);
-- 
1.5.3.1


