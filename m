Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0F7C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0535A60720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhHQJRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47562 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 26D442001D;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDa4b0uMMZpqGGQWu3VRWsZgnZ7b1VfFjaPKU4/hGIY=;
        b=Ssa7jyl3v0EoLLfXvGomFVo6jFTgbLZaiW2bImcr9jg7XMx/WZvusXfI055+eQR2Vh9miZ
        O5GELxcAimrQDngNdvdDKT9E1Mz0UIXT+G+7oLbthXHdDMnXOv1OCjCG++AXPLhZ60o3Er
        /+DvtfWcxsJlIa60R9C0+zQ1m5X/mkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDa4b0uMMZpqGGQWu3VRWsZgnZ7b1VfFjaPKU4/hGIY=;
        b=1uUok/TqPve1xnzo6I2L4ryDQ54+aejSE3Gi7NztMT2B7e3ysIxJtGx4yqpg3hYueD9Zt1
        pqVPhZebKel+YTAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1FB45A3BA7;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 1C84C518CE87; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 20/51] ncr53c8xx: Remove unused code
Date:   Tue, 17 Aug 2021 11:14:25 +0200
Message-Id: <20210817091456.73342-21-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ncr53c8xx.c | 163 ---------------------------------------
 1 file changed, 163 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 1c1f5df83dca..e7115cba4b28 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1453,11 +1453,6 @@ struct head {
 #define  xerr_status   phys.xerr_st
 #define  nego_status   phys.nego_st
 
-#if 0
-#define  sync_status   phys.sync_st
-#define  wide_status   phys.wide_st
-#endif
-
 /*==========================================================
 **
 **      Declaration of structs:     Data structure block
@@ -1980,9 +1975,6 @@ static inline char *ncr_name (struct ncb *np)
 #define	RELOC_SOFTC	0x40000000
 #define	RELOC_LABEL	0x50000000
 #define	RELOC_REGISTER	0x60000000
-#if 0
-#define	RELOC_KVAR	0x70000000
-#endif
 #define	RELOC_LABELH	0x80000000
 #define	RELOC_MASK	0xf0000000
 
@@ -1991,21 +1983,7 @@ static inline char *ncr_name (struct ncb *np)
 #define PADDRH(label)   (RELOC_LABELH | offsetof(struct scripth, label))
 #define	RADDR(label)	(RELOC_REGISTER | REG(label))
 #define	FADDR(label,ofs)(RELOC_REGISTER | ((REG(label))+(ofs)))
-#if 0
-#define	KVAR(which)	(RELOC_KVAR | (which))
-#endif
 
-#if 0
-#define	SCRIPT_KVAR_JIFFIES	(0)
-#define	SCRIPT_KVAR_FIRST		SCRIPT_KVAR_JIFFIES
-#define	SCRIPT_KVAR_LAST		SCRIPT_KVAR_JIFFIES
-/*
- * Kernel variables referenced in the scripts.
- * THESE MUST ALL BE ALIGNED TO A 4-BYTE BOUNDARY.
- */
-static void *script_kvars[] __initdata =
-	{ (void *)&jiffies };
-#endif
 
 static	struct script script0 __initdata = {
 /*--------------------------< START >-----------------------*/ {
@@ -2162,11 +2140,6 @@ static	struct script script0 __initdata = {
 	SCR_COPY (1),
 		RADDR (scratcha),
 		NADDR (msgout),
-#if 0
-	SCR_COPY (1),
-		RADDR (scratcha),
-		NADDR (msgin),
-#endif
 	/*
 	**	Anticipate the COMMAND phase.
 	**	This is the normal case for initial selection.
@@ -4378,10 +4351,6 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	cp->parity_status		= 0;
 
 	cp->xerr_status			= XE_OK;
-#if 0
-	cp->sync_status			= tp->sval;
-	cp->wide_status			= tp->wval;
-#endif
 
 	/*----------------------------------------------------
 	**
@@ -4580,89 +4549,6 @@ static int ncr_reset_bus (struct ncb *np)
 	return SUCCESS;
 }
 
-#if 0 /* unused and broken.. */
-/*==========================================================
-**
-**
-**	Abort an SCSI command.
-**	This is called from the generic SCSI driver.
-**
-**
-**==========================================================
-*/
-static int ncr_abort_command (struct ncb *np, struct scsi_cmnd *cmd)
-{
-/*	struct scsi_device        *device    = cmd->device; */
-	struct ccb *cp;
-	int found;
-	int retv;
-
-/*
- * First, look for the scsi command in the waiting list
- */
-	if (remove_from_waiting_list(np, cmd)) {
-		set_host_byte(cmd, DID_ABORT);
-		ncr_queue_done_cmd(np, cmd);
-		return SCSI_ABORT_SUCCESS;
-	}
-
-/*
- * Then, look in the wakeup list
- */
-	for (found=0, cp=np->ccb; cp; cp=cp->link_ccb) {
-		/*
-		**	look for the ccb of this command.
-		*/
-		if (cp->host_status == HS_IDLE) continue;
-		if (cp->cmd == cmd) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		return SCSI_ABORT_NOT_RUNNING;
-	}
-
-	if (np->settle_time) {
-		return SCSI_ABORT_SNOOZE;
-	}
-
-	/*
-	**	If the CCB is active, patch schedule jumps for the 
-	**	script to abort the command.
-	*/
-
-	switch(cp->host_status) {
-	case HS_BUSY:
-	case HS_NEGOTIATE:
-		printk ("%s: abort ccb=%p (cancel)\n", ncr_name (np), cp);
-			cp->start.schedule.l_paddr =
-				cpu_to_scr(NCB_SCRIPTH_PHYS (np, cancel));
-		retv = SCSI_ABORT_PENDING;
-		break;
-	case HS_DISCONNECT:
-		cp->restart.schedule.l_paddr =
-				cpu_to_scr(NCB_SCRIPTH_PHYS (np, abort));
-		retv = SCSI_ABORT_PENDING;
-		break;
-	default:
-		retv = SCSI_ABORT_NOT_RUNNING;
-		break;
-
-	}
-
-	/*
-	**      If there are no requests, the script
-	**      processor will sleep on SEL_WAIT_RESEL.
-	**      Let's wake it up, since it may have to work.
-	*/
-	OUTB (nc_istat, SIGP);
-
-	return retv;
-}
-#endif
-
 static void ncr_detach(struct ncb *np)
 {
 	struct ccb *cp;
@@ -5421,27 +5307,6 @@ static void ncr_getsync(struct ncb *np, u_char sfac, u_char *fakp, u_char *scntl
 	*/
 	fak = (kpc - 1) / div_10M[div] + 1;
 
-#if 0	/* This optimization does not seem very useful */
-
-	per = (fak * div_10M[div]) / clk;
-
-	/*
-	**	Why not to try the immediate lower divisor and to choose 
-	**	the one that allows the fastest output speed ?
-	**	We don't want input speed too much greater than output speed.
-	*/
-	if (div >= 1 && fak < 8) {
-		u_long fak2, per2;
-		fak2 = (kpc - 1) / div_10M[div-1] + 1;
-		per2 = (fak2 * div_10M[div-1]) / clk;
-		if (per2 < per && fak2 <= 8) {
-			fak = fak2;
-			per = per2;
-			--div;
-		}
-	}
-#endif
-
 	if (fak < 4) fak = 4;	/* Should never happen, too bad ... */
 
 	/*
@@ -5479,10 +5344,6 @@ static void ncr_set_sync_wide_status (struct ncb *np, u_char target)
 	for (cp = np->ccb; cp; cp = cp->link_ccb) {
 		if (!cp->cmd) continue;
 		if (scmd_id(cp->cmd) != target) continue;
-#if 0
-		cp->sync_status = tp->sval;
-		cp->wide_status = tp->wval;
-#endif
 		cp->phys.select.sel_scntl3 = tp->wval;
 		cp->phys.select.sel_sxfer  = tp->sval;
 	}
@@ -8104,30 +7965,6 @@ static int ncr53c8xx_bus_reset(struct scsi_cmnd *cmd)
 	return sts;
 }
 
-#if 0 /* unused and broken */
-static int ncr53c8xx_abort(struct scsi_cmnd *cmd)
-{
-	struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
-	int sts;
-	unsigned long flags;
-	struct scsi_cmnd *done_list;
-
-	printk("ncr53c8xx_abort\n");
-
-	NCR_LOCK_NCB(np, flags);
-
-	sts = ncr_abort_command(np, cmd);
-out:
-	done_list     = np->done_list;
-	np->done_list = NULL;
-	NCR_UNLOCK_NCB(np, flags);
-
-	ncr_flush_done_cmds(done_list);
-
-	return sts;
-}
-#endif
-
 
 /*
 **	Scsi command waiting list management.
-- 
2.29.2

