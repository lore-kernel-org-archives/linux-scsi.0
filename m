From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 6/8] cciss: change SCSI error handling routines to work with interrupts enabled.
Date: Mon, 8 Jun 2009 16:07:45 -0500
Message-ID: <20090608210745.GL23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:48987 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZFHVHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:07:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Change cciss scsi error handling routines to work with interrupts enabled.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

---


diff -puN drivers/block/cciss.c~cciss_scsi_err_handler_intr_enabled drivers/block/cciss.c
--- linux-next/drivers/block/cciss.c~cciss_scsi_err_handler_intr_enabled	2009-06-08 12:59:02.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.c	2009-06-08 12:59:02.000000000 -0500
@@ -184,6 +184,9 @@ static int sendcmd(__u8 cmd, int ctlr, v
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
 			int cmd_type);
+static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
+	int attempt_retry);
+static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
 
 static void fail_all_cmds(unsigned long ctlr);
 static int scan_thread(void *data);
diff -puN drivers/block/cciss_scsi.c~cciss_scsi_err_handler_intr_enabled drivers/block/cciss_scsi.c
--- linux-next/drivers/block/cciss_scsi.c~cciss_scsi_err_handler_intr_enabled	2009-06-08 12:59:02.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss_scsi.c	2009-06-08 12:59:02.000000000 -0500
@@ -49,8 +49,6 @@ static int fill_cmd(CommandList_struct *
 	__u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
-static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c);
-
 static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
 static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
 
@@ -1601,11 +1599,10 @@ static int wait_for_device_to_become_rea
 		/* Send the Test Unit Ready */
 		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0,
 			lunaddr, TYPE_CMD);
-		if (rc == 0) {
-			rc = sendcmd_core(h, c);
-			/* sendcmd turned off interrupts, turn 'em back on. */
-			h->access.set_intr_mask(h, CCISS_INTR_ON);
-		}
+		if (rc == 0)
+			rc = sendcmd_withirq_core(h, c, 0);
+
+		(void) process_sendcmd_error(h, c);
 
 		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
 			break;
@@ -1663,10 +1660,8 @@ static int cciss_eh_device_reset_handler
 		return FAILED;
 	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
+	rc = sendcmd_withirq(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
-	/* sendcmd turned off interrupts on the board, turn 'em back on. */
-	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
 	if (rc == 0 && wait_for_device_to_become_ready(*c, lunaddr) == 0)
 		return SUCCESS;
 	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
@@ -1677,6 +1672,7 @@ static int  cciss_eh_abort_handler(struc
 {
 	int rc;
 	CommandList_struct *cmd_to_abort;
+	unsigned char lunaddr[8];
 	ctlr_info_t **c;
 	int ctlr;
 
@@ -1691,11 +1687,9 @@ static int  cciss_eh_abort_handler(struc
 	cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_to_abort == NULL) /* paranoia */
 		return FAILED;
-	rc = sendcmd(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag, 0, 0,
-		(unsigned char *) &cmd_to_abort->Header.LUN.LunAddrBytes[0], 
-		TYPE_MSG);
-	/* sendcmd turned off interrupts on the board, turn 'em back on. */
-	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
+	memcpy(lunaddr, &cmd_to_abort->Header.LUN.LunAddrBytes[0], 8);
+	rc = sendcmd_withirq(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag,
+		0, 0, lunaddr, TYPE_MSG);
 	if (rc == 0)
 		return SUCCESS;
 	return FAILED;
_
