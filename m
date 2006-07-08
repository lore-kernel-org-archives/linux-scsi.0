From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] aha152x: stop poking at saved scsi_cmnd members
Date: Sat, 8 Jul 2006 20:39:30 +0200
Message-ID: <20060708183930.GA7655@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41704 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964953AbWGHSjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jul 2006 14:39:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, fischer@norbit.de
Cc: linux-scsi@vger.kernel.org

Stop poking into the old_ & co scsi_cmnd fields that should only be used
in the EH code.  Untested, but this is required to move ahead with the
EH fixes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aha152x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aha152x.c	2006-07-07 21:21:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aha152x.c	2006-07-08 13:38:13.000000000 +0200
@@ -551,6 +551,11 @@
 struct aha152x_scdata {
 	Scsi_Cmnd *next;	/* next sc in queue */
 	struct semaphore *sem;	/* semaphore to block on */
+	unsigned char cmd_len;
+	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned short use_sg;
+	unsigned request_bufflen;
+	void *request_buffer;
 };
 
 
@@ -1006,11 +1011,20 @@
 			return FAILED;
 		}
 	} else {
+		struct aha152x_scdata *sc;
+
 		SCpnt->host_scribble = kmalloc(sizeof(struct aha152x_scdata), GFP_ATOMIC);
 		if(SCpnt->host_scribble==0) {
 			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
 			return FAILED;
 		}
+
+		sc = SCDATA(SCpnt);
+		memcpy(sc->cmnd, SCpnt->cmnd, sizeof(sc->cmnd));
+		sc->request_buffer  = SCpnt->request_buffer;
+		sc->request_bufflen = SCpnt->request_bufflen;
+		sc->use_sg          = SCpnt->use_sg;
+		sc->cmd_len         = SCpnt->cmd_len;
 	}
 
 	SCNEXT(SCpnt)		= NULL;
@@ -1569,6 +1583,9 @@
 #endif
 
 		if(DONE_SC->SCp.phase & check_condition) {
+			struct scsi_cmnd *cmd = HOSTDATA(shpnt)->done_SC;
+			struct aha152x_scdata *sc = SCDATA(cmd);
+
 #if 0
 			if(HOSTDATA(shpnt)->debug & debug_eh) {
 				printk(ERR_LEAD "received sense: ", CMDINFO(DONE_SC));
@@ -1577,13 +1594,13 @@
 #endif
 
 			/* restore old command */
-			memcpy((void *) DONE_SC->cmnd, (void *) DONE_SC->data_cmnd, sizeof(DONE_SC->data_cmnd));
-			DONE_SC->request_buffer  = DONE_SC->buffer;
-			DONE_SC->request_bufflen = DONE_SC->bufflen;
-			DONE_SC->use_sg          = DONE_SC->old_use_sg;
-			DONE_SC->cmd_len         = DONE_SC->old_cmd_len;
+			memcpy(cmd->cmnd, sc->cmnd, sizeof(sc->cmnd));
+			cmd->request_buffer  = sc->request_buffer;
+			cmd->request_bufflen = sc->request_bufflen;
+			cmd->use_sg          = sc->use_sg;
+			cmd->cmd_len         = sc->cmd_len;
 
-			DONE_SC->SCp.Status = 0x02;
+			cmd->SCp.Status = 0x02;
 
 			HOSTDATA(shpnt)->commands--;
 			if (!HOSTDATA(shpnt)->commands)
