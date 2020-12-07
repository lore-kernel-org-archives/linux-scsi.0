Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206ACC2BBCF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7EFB23406
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgLGMu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:50:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:43224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgLGMu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 906F6B21D;
        Mon,  7 Dec 2020 12:48:32 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/35] ncr53c8xx: Use SAM status values
Date:   Mon,  7 Dec 2020 13:48:19 +0100
Message-Id: <20201207124819.95822-36-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use SAM status values instead of the driver-defined ones.
This also fixes a potential bug as the driver-defined values
declare 'COMMAND TERMINATED' with a value of 0x20, whereas
SCSI-II defines it with a value of 0x22.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ncr53c8xx.c | 83 +++++++++++++++++++++++++++---------------------
 drivers/scsi/ncr53c8xx.h | 16 ----------
 2 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 03d70138ad58..71e97384102a 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -148,6 +148,11 @@ static int ncr_debug = SCSI_NCR_DEBUG_FLAGS;
 	#define DEBUG_FLAGS	SCSI_NCR_DEBUG_FLAGS
 #endif
 
+/*
+ * Locally used status flag
+ */
+#define SAM_STAT_ILLEGAL	0xff
+
 static inline struct list_head *ncr_list_pop(struct list_head *head)
 {
 	if (!list_empty(head)) {
@@ -998,8 +1003,6 @@ typedef u32 tagmap_t;
 **	Other definitions
 */
 
-#define ScsiResult(host_code, scsi_code) (((host_code) << 16) + ((scsi_code) & 0x7f))
-
 #define initverbose (driver_setup.verbose)
 #define bootverbose (np->verbose)
 
@@ -2430,7 +2433,7 @@ static	struct script script0 __initdata = {
 	*/
 	SCR_FROM_REG (SS_REG),
 		0,
-	SCR_CALL ^ IFFALSE (DATA (S_GOOD)),
+	SCR_CALL ^ IFFALSE (DATA (SAM_STAT_GOOD)),
 		PADDRH (bad_status),
 
 #ifndef	SCSI_NCR_CCB_DONE_SUPPORT
@@ -2879,7 +2882,7 @@ static	struct scripth scripth0 __initdata = {
 		8,
 	SCR_TO_REG (HS_REG),
 		0,
-	SCR_LOAD_REG (SS_REG, S_GOOD),
+	SCR_LOAD_REG (SS_REG, SAM_STAT_GOOD),
 		0,
 	SCR_JUMP,
 		PADDR (cleanup_ok),
@@ -3341,15 +3344,15 @@ static	struct scripth scripth0 __initdata = {
 		PADDRH (reset),
 }/*-------------------------< BAD_STATUS >-----------------*/,{
 	/*
-	**	If command resulted in either QUEUE FULL,
+	**	If command resulted in either TASK_SET FULL,
 	**	CHECK CONDITION or COMMAND TERMINATED,
 	**	call the C code.
 	*/
-	SCR_INT ^ IFTRUE (DATA (S_QUEUE_FULL)),
+	SCR_INT ^ IFTRUE (DATA (SAM_STAT_TASK_SET_FULL)),
 		SIR_BAD_STATUS,
-	SCR_INT ^ IFTRUE (DATA (S_CHECK_COND)),
+	SCR_INT ^ IFTRUE (DATA (SAM_STAT_CHECK_CONDITION)),
 		SIR_BAD_STATUS,
-	SCR_INT ^ IFTRUE (DATA (S_TERMINATED)),
+	SCR_INT ^ IFTRUE (DATA (SAM_STAT_COMMAND_TERMINATED)),
 		SIR_BAD_STATUS,
 	SCR_RETURN,
 		0,
@@ -4371,7 +4374,7 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	*/
 	cp->actualquirks		= 0;
 	cp->host_status			= cp->nego_status ? HS_NEGOTIATE : HS_BUSY;
-	cp->scsi_status			= S_ILLEGAL;
+	cp->scsi_status			= SAM_STAT_ILLEGAL;
 	cp->parity_status		= 0;
 
 	cp->xerr_status			= XE_OK;
@@ -4602,7 +4605,7 @@ static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd, int sync_reset)
  * in order to keep it alive.
  */
 	if (!found && sync_reset && !retrieve_from_waiting_list(0, np, cmd)) {
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		ncr_queue_done_cmd(np, cmd);
 	}
 
@@ -4630,7 +4633,7 @@ static int ncr_abort_command (struct ncb *np, struct scsi_cmnd *cmd)
  * First, look for the scsi command in the waiting list
  */
 	if (remove_from_waiting_list(np, cmd)) {
-		cmd->result = ScsiResult(DID_ABORT, 0);
+		set_host_byte(cmd, DID_ABORT);
 		ncr_queue_done_cmd(np, cmd);
 		return SCSI_ABORT_SUCCESS;
 	}
@@ -4895,7 +4898,8 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 	**	Print out any error for debugging purpose.
 	*/
 	if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
-		if (cp->host_status!=HS_COMPLETE || cp->scsi_status!=S_GOOD) {
+		if (cp->host_status != HS_COMPLETE ||
+		    cp->scsi_status != SAM_STAT_GOOD) {
 			PRINT_ADDR(cmd, "ERROR: cmd=%x host_status=%x "
 					"scsi_status=%x\n", cmd->cmnd[0],
 					cp->host_status, cp->scsi_status);
@@ -4905,15 +4909,16 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 	/*
 	**	Check the status.
 	*/
+	cmd->result = 0;
 	if (   (cp->host_status == HS_COMPLETE)
-		&& (cp->scsi_status == S_GOOD ||
-		    cp->scsi_status == S_COND_MET)) {
+		&& (cp->scsi_status == SAM_STAT_GOOD ||
+		    cp->scsi_status == SAM_STAT_CONDITION_MET)) {
 		/*
 		 *	All went well (GOOD status).
-		 *	CONDITION MET status is returned on 
+		 *	CONDITION MET status is returned on
 		 *	`Pre-Fetch' or `Search data' success.
 		 */
-		cmd->result = ScsiResult(DID_OK, cp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
 
 		/*
 		**	@RESID@
@@ -4944,11 +4949,11 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 			}
 		}
 	} else if ((cp->host_status == HS_COMPLETE)
-		&& (cp->scsi_status == S_CHECK_COND)) {
+		&& (cp->scsi_status == SAM_STAT_CHECK_CONDITION)) {
 		/*
 		**   Check condition code
 		*/
-		cmd->result = DID_OK << 16 | S_CHECK_COND;
+		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 
 		/*
 		**	Copy back sense data to caller's buffer.
@@ -4965,20 +4970,20 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 			printk (".\n");
 		}
 	} else if ((cp->host_status == HS_COMPLETE)
-		&& (cp->scsi_status == S_CONFLICT)) {
+		&& (cp->scsi_status == SAM_STAT_RESERVATION_CONFLICT)) {
 		/*
 		**   Reservation Conflict condition code
 		*/
-		cmd->result = DID_OK << 16 | S_CONFLICT;
-	
+		set_status_byte(cmd, SAM_STAT_RESERVATION_CONFLICT);
+
 	} else if ((cp->host_status == HS_COMPLETE)
-		&& (cp->scsi_status == S_BUSY ||
-		    cp->scsi_status == S_QUEUE_FULL)) {
+		&& (cp->scsi_status == SAM_STAT_BUSY ||
+		    cp->scsi_status == SAM_STAT_TASK_SET_FULL)) {
 
 		/*
 		**   Target is busy.
 		*/
-		cmd->result = ScsiResult(DID_OK, cp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
 
 	} else if ((cp->host_status == HS_SEL_TIMEOUT)
 		|| (cp->host_status == HS_TIMEOUT)) {
@@ -4986,21 +4991,24 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		/*
 		**   No response
 		*/
-		cmd->result = ScsiResult(DID_TIME_OUT, cp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
+		set_host_byte(cmd, DID_TIME_OUT);
 
 	} else if (cp->host_status == HS_RESET) {
 
 		/*
 		**   SCSI bus reset
 		*/
-		cmd->result = ScsiResult(DID_RESET, cp->scsi_status);
+		set_status_byte(cmd, sp->scsi_status);
+		set_host_byte(cmd, DID_RESET);
 
 	} else if (cp->host_status == HS_ABORTED) {
 
 		/*
 		**   Transfer aborted
 		*/
-		cmd->result = ScsiResult(DID_ABORT, cp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
+		set_host_byte(cmd, DID_ABORT);
 
 	} else {
 
@@ -5010,7 +5018,8 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		PRINT_ADDR(cmd, "COMMAND FAILED (%x %x) @%p.\n",
 			cp->host_status, cp->scsi_status, cp);
 
-		cmd->result = ScsiResult(DID_ERROR, cp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
+		set_host_byte(cmd, DID_ERROR);
 	}
 
 	/*
@@ -5026,10 +5035,10 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 
 		if (cp->host_status==HS_COMPLETE) {
 			switch (cp->scsi_status) {
-			case S_GOOD:
+			case SAM_STAT_GOOD:
 				printk ("  GOOD");
 				break;
-			case S_CHECK_COND:
+			case SAM_STAT_CHECK_CONDITION:
 				printk ("  SENSE:");
 				p = (u_char*) &cmd->sense_buffer;
 				for (i=0; i<14; i++)
@@ -6564,7 +6573,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 
 	switch(s_status) {
 	default:	/* Just for safety, should never happen */
-	case S_QUEUE_FULL:
+	case SAM_STAT_TASK_SET_FULL:
 		/*
 		**	Decrease number of tags to the number of 
 		**	disconnected commands.
@@ -6588,15 +6597,15 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		*/
 		cp->phys.header.savep = cp->startp;
 		cp->host_status = HS_BUSY;
-		cp->scsi_status = S_ILLEGAL;
+		cp->scsi_status = SAM_STAT_ILLEGAL;
 
 		ncr_put_start_queue(np, cp);
 		if (disc_cnt)
 			INB (nc_ctest2);		/* Clear SIGP */
 		OUTL_DSP (NCB_SCRIPT_PHYS (np, reselect));
 		return;
-	case S_TERMINATED:
-	case S_CHECK_COND:
+	case SAM_STAT_COMMAND_TERMINATED:
+	case SAM_STAT_CHECK_CONDIION:
 		/*
 		**	If we were requesting sense, give up.
 		*/
@@ -6646,7 +6655,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		cp->phys.header.wlastp	= startp;
 
 		cp->host_status = HS_BUSY;
-		cp->scsi_status = S_ILLEGAL;
+		cp->scsi_status = SAM_STAT_ILLEGAL;
 		cp->auto_sense	= s_status;
 
 		cp->start.schedule.l_paddr =
@@ -8035,7 +8044,7 @@ printk("ncr53c8xx_queue_command\n");
      spin_lock_irqsave(&np->smp_lock, flags);
 
      if ((sts = ncr_queue_command(np, cmd)) != DID_OK) {
-	  cmd->result = sts << 16;
+	     set_host_byte(cmd, sts;
 #ifdef DEBUG_NCR53C8XX
 printk("ncr53c8xx : command not queued - result=%d\n", sts);
 #endif
@@ -8226,7 +8235,7 @@ static void process_waiting_list(struct ncb *np, int sts)
 #ifdef DEBUG_WAITING_LIST
 	printk("%s: cmd %lx done forced sts=%d\n", ncr_name(np), (u_long) wcmd, sts);
 #endif
-			wcmd->result = sts << 16;
+			set_host_byte(wcmd, sts);
 			ncr_queue_done_cmd(np, wcmd);
 		}
 	}
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 8326f5f01e07..fa14b5ca8783 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -1238,22 +1238,6 @@ struct scr_tblsel {
 **-----------------------------------------------------------
 */
 
-/*
-**	Status
-*/
-
-#define	S_GOOD		(0x00)
-#define	S_CHECK_COND	(0x02)
-#define	S_COND_MET	(0x04)
-#define	S_BUSY		(0x08)
-#define	S_INT		(0x10)
-#define	S_INT_COND_MET	(0x14)
-#define	S_CONFLICT	(0x18)
-#define	S_TERMINATED	(0x20)
-#define	S_QUEUE_FULL	(0x28)
-#define	S_ILLEGAL	(0xff)
-#define	S_SENSE		(0x80)
-
 /*
  * End of ncrreg from FreeBSD
  */
-- 
2.16.4

