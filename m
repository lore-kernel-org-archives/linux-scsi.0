From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 15/24] fd_mcs.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:04:40 +0300
Message-ID: <46E72D18.9030403@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9020 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186AbXILAFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:05:18 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - convert to accessors and !use_sg cleanup
 - Not ready for sg-chaining

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/fd_mcs.c |   36 +++++++++++-------------------------
 1 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 668569e..3a5df96 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1017,24 +1017,6 @@ static irqreturn_t fd_mcs_intr(int irq, void *dev_id)
 		printk(" ** IN DONE %d ** ", current_SC->SCp.have_data_in);
 #endif
 
-#if ERRORS_ONLY
-		if (current_SC->cmnd[0] == REQUEST_SENSE && !current_SC->SCp.Status) {
-			if ((unsigned char) (*((char *) current_SC->request_buffer + 2)) & 0x0f) {
-				unsigned char key;
-				unsigned char code;
-				unsigned char qualifier;
-
-				key = (unsigned char) (*((char *) current_SC->request_buffer + 2)) & 0x0f;
-				code = (unsigned char) (*((char *) current_SC->request_buffer + 12));
-				qualifier = (unsigned char) (*((char *) current_SC->request_buffer + 13));
-
-				if (key != UNIT_ATTENTION && !(key == NOT_READY && code == 0x04 && (!qualifier || qualifier == 0x02 || qualifier == 0x01))
-				    && !(key == ILLEGAL_REQUEST && (code == 0x25 || code == 0x24 || !code)))
-
-					printk("fd_mcs: REQUEST SENSE " "Key = %x, Code = %x, Qualifier = %x\n", key, code, qualifier);
-			}
-		}
-#endif
 #if EVERY_ACCESS
 		printk("BEFORE MY_DONE. . .");
 #endif
@@ -1097,7 +1079,9 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		panic("fd_mcs: fd_mcs_queue() NOT REENTRANT!\n");
 	}
 #if EVERY_ACCESS
-	printk("queue: target = %d cmnd = 0x%02x pieces = %d size = %u\n", SCpnt->target, *(unsigned char *) SCpnt->cmnd, SCpnt->use_sg, SCpnt->request_bufflen);
+	printk("queue: target = %d cmnd = 0x%02x pieces = %d size = %u\n",
+		SCpnt->target, *(unsigned char *) SCpnt->cmnd,
+		scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
 #endif
 
 	fd_mcs_make_bus_idle(shpnt);
@@ -1107,14 +1091,14 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 	/* Initialize static data */
 
-	if (current_SC->use_sg) {
-		current_SC->SCp.buffer = (struct scatterlist *) current_SC->request_buffer;
+	if (scsi_bufflen(current_SC)) {
+		current_SC->SCp.buffer = scsi_sglist(current_SC);
 		current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
 		current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
-		current_SC->SCp.buffers_residual = current_SC->use_sg - 1;
+		current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
 	} else {
-		current_SC->SCp.ptr = (char *) current_SC->request_buffer;
-		current_SC->SCp.this_residual = current_SC->request_bufflen;
+		current_SC->SCp.ptr = NULL;
+		current_SC->SCp.this_residual = 0;
 		current_SC->SCp.buffer = NULL;
 		current_SC->SCp.buffers_residual = 0;
 	}
@@ -1166,7 +1150,9 @@ static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 		break;
 	}
 
-	printk("(%d), target = %d cmnd = 0x%02x pieces = %d size = %u\n", SCpnt->SCp.phase, SCpnt->device->id, *(unsigned char *) SCpnt->cmnd, SCpnt->use_sg, SCpnt->request_bufflen);
+	printk("(%d), target = %d cmnd = 0x%02x pieces = %d size = %u\n",
+		SCpnt->SCp.phase, SCpnt->device->id, *(unsigned char *) SCpnt->cmnd,
+		scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
 	printk("sent_command = %d, have_data_in = %d, timeout = %d\n", SCpnt->SCp.sent_command, SCpnt->SCp.have_data_in, SCpnt->timeout);
 #if DEBUG_RACE
 	printk("in_interrupt_flag = %d\n", in_interrupt_flag);
-- 
1.5.3.1


