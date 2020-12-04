Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC45C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2E6227C3
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387910AbgLDKDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:03:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:51206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387842AbgLDKDa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Dec 2020 05:03:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2AC23AF24;
        Fri,  4 Dec 2020 10:01:48 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/37] initio: drop internal SCSI message definition
Date:   Fri,  4 Dec 2020 11:01:24 +0100
Message-Id: <20201204100140.140863-22-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201204100140.140863-1-hare@suse.de>
References: <20201204100140.140863-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the standard SCSI message definitions instead of the
driver-internal ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/initio.c | 64 ++++++++++++++++++++++++++-------------------------
 drivers/scsi/initio.h | 25 --------------------
 2 files changed, 33 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index ca16ef45d8dc..814acc57069d 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -1315,15 +1315,15 @@ static int initio_state_1(struct initio_host * host)
 		}
 		if ((active_tc->flags & (TCF_WDTR_DONE | TCF_NO_WDTR)) == 0) {
 			active_tc->flags |= TCF_WDTR_DONE;
-			outb(MSG_EXTEND, host->addr + TUL_SFifo);
+			outb(EXTENDED_MESSAGE, host->addr + TUL_SFifo);
 			outb(2, host->addr + TUL_SFifo);	/* Extended msg length */
-			outb(3, host->addr + TUL_SFifo);	/* Sync request */
+			outb(EXTENDED_SDTR, host->addr + TUL_SFifo);	/* Sync request */
 			outb(1, host->addr + TUL_SFifo);	/* Start from 16 bits */
 		} else if ((active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {
 			active_tc->flags |= TCF_SYNC_DONE;
-			outb(MSG_EXTEND, host->addr + TUL_SFifo);
+			outb(EXTENDED_MESSAGE, host->addr + TUL_SFifo);
 			outb(3, host->addr + TUL_SFifo);	/* extended msg length */
-			outb(1, host->addr + TUL_SFifo);	/* sync request */
+			outb(EXTENDED_SDTR, host->addr + TUL_SFifo);	/* sync request */
 			outb(initio_rate_tbl[active_tc->flags & TCF_SCSI_RATE], host->addr + TUL_SFifo);
 			outb(MAX_OFFSET, host->addr + TUL_SFifo);	/* REQ/ACK offset */
 		}
@@ -1409,16 +1409,16 @@ static int initio_state_3(struct initio_host * host)
 
 		case MSG_OUT:	/* Message out phase            */
 			if (active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) {
-				outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+				outb(NOP, host->addr + TUL_SFifo);		/* msg nop */
 				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 				if (wait_tulip(host) == -1)
 					return -1;
 			} else {
 				active_tc->flags |= TCF_SYNC_DONE;
 
-				outb(MSG_EXTEND, host->addr + TUL_SFifo);
+				outb(EXTENDED_MESSAGE, host->addr + TUL_SFifo);
 				outb(3, host->addr + TUL_SFifo);	/* ext. msg len */
-				outb(1, host->addr + TUL_SFifo);	/* sync request */
+				outb(EXTENDED_SDTR, host->addr + TUL_SFifo);	/* sync request */
 				outb(initio_rate_tbl[active_tc->flags & TCF_SCSI_RATE], host->addr + TUL_SFifo);
 				outb(MAX_OFFSET, host->addr + TUL_SFifo);	/* REQ/ACK offset */
 				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
@@ -1479,7 +1479,7 @@ static int initio_state_4(struct initio_host * host)
 					return -1;
 				return 6;
 			} else {
-				outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+				outb(NOP, host->addr + TUL_SFifo);		/* msg nop */
 				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 				if (wait_tulip(host) == -1)
 					return -1;
@@ -1616,7 +1616,7 @@ static int initio_state_6(struct initio_host * host)
 			break;
 
 		case MSG_OUT:	/* Message out phase            */
-			outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+			outb(NOP, host->addr + TUL_SFifo);		/* msg nop */
 			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 			if (wait_tulip(host) == -1)
 				return -1;
@@ -1789,9 +1789,9 @@ int initio_status_msg(struct initio_host * host)
 
 	if (host->phase == MSG_OUT) {
 		if (host->jsstatus0 & TSS_PAR_ERROR)
-			outb(MSG_PARITY, host->addr + TUL_SFifo);
+			outb(MSG_PARITY_ERROR, host->addr + TUL_SFifo);
 		else
-			outb(MSG_NOP, host->addr + TUL_SFifo);
+			outb(NOP, host->addr + TUL_SFifo);
 		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 		return wait_tulip(host);
 	}
@@ -1802,7 +1802,7 @@ int initio_status_msg(struct initio_host * host)
 				return -1;
 			if (host->phase != MSG_OUT)
 				return initio_bad_seq(host);
-			outb(MSG_PARITY, host->addr + TUL_SFifo);
+			outb(MSG_PARITY_ERROR, host->addr + TUL_SFifo);
 			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 			return wait_tulip(host);
 		}
@@ -1815,7 +1815,8 @@ int initio_status_msg(struct initio_host * host)
 			return initio_wait_done_disc(host);
 
 		}
-		if (msg == MSG_LINK_COMP || msg == MSG_LINK_FLAG) {
+		if (msg == LINKED_CMD_COMPLETE ||
+		    msg == LINKED_FLG_CMD_COMPLETE) {
 			if ((scb->tastat & 0x18) == 0x10)
 				return initio_msgin_accept(host);
 		}
@@ -1930,7 +1931,8 @@ int int_initio_resel(struct initio_host * host)
 			return -1;
 		msg = inb(host->addr + TUL_SFifo);	/* Read Tag Message    */
 
-		if (msg < MSG_STAG || msg > MSG_OTAG)		/* Is simple Tag      */
+		if (msg < SIMPLE_QUEUE_TAG || msg > ORDERED_QUEUE_TAG)
+			/* Is simple Tag      */
 			goto no_tag;
 
 		if (initio_msgin_accept(host) == -1)
@@ -2010,7 +2012,7 @@ static int initio_msgout_abort_targ(struct initio_host * host)
 	if (host->phase != MSG_OUT)
 		return initio_bad_seq(host);
 
-	outb(MSG_ABORT, host->addr + TUL_SFifo);
+	outb(ABORT_TASK_SET, host->addr + TUL_SFifo);
 	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 
 	return initio_wait_disc(host);
@@ -2033,7 +2035,7 @@ static int initio_msgout_abort_tag(struct initio_host * host)
 	if (host->phase != MSG_OUT)
 		return initio_bad_seq(host);
 
-	outb(MSG_ABORT_TAG, host->addr + TUL_SFifo);
+	outb(ABORT_TASK, host->addr + TUL_SFifo);
 	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 
 	return initio_wait_disc(host);
@@ -2059,15 +2061,15 @@ static int initio_msgin(struct initio_host * host)
 			return -1;
 
 		switch (inb(host->addr + TUL_SFifo)) {
-		case MSG_DISC:	/* Disconnect msg */
+		case DISCONNECT:	/* Disconnect msg */
 			outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
 			return initio_wait_disc(host);
-		case MSG_SDP:
-		case MSG_RESTORE:
-		case MSG_NOP:
+		case SAVE_POINTERS:
+		case RESTORE_POINTERS:
+		case NOP:
 			initio_msgin_accept(host);
 			break;
-		case MSG_REJ:	/* Clear ATN first              */
+		case MESSAGE_REJECT:	/* Clear ATN first              */
 			outb((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)),
 				host->addr + TUL_SSignal);
 			active_tc = host->active_tc;
@@ -2076,13 +2078,13 @@ static int initio_msgin(struct initio_host * host)
 					host->addr + TUL_SSignal);
 			initio_msgin_accept(host);
 			break;
-		case MSG_EXTEND:	/* extended msg */
+		case EXTENDED_MESSAGE:	/* extended msg */
 			initio_msgin_extend(host);
 			break;
-		case MSG_IGNOREWIDE:
+		case IGNORE_WIDE_RESIDUE:
 			initio_msgin_accept(host);
 			break;
-		case MSG_COMP:
+		case COMMAND_COMPLETE:
 			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 			outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
 			return initio_wait_done_disc(host);
@@ -2104,7 +2106,7 @@ static int initio_msgout_reject(struct initio_host * host)
 		return -1;
 
 	if (host->phase == MSG_OUT) {
-		outb(MSG_REJ, host->addr + TUL_SFifo);		/* Msg reject           */
+		outb(MESSAGE_REJECT, host->addr + TUL_SFifo);		/* Msg reject           */
 		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 		return wait_tulip(host);
 	}
@@ -2113,7 +2115,7 @@ static int initio_msgout_reject(struct initio_host * host)
 
 static int initio_msgout_ide(struct initio_host * host)
 {
-	outb(MSG_IDE, host->addr + TUL_SFifo);		/* Initiator Detected Error */
+	outb(INITIATOR_ERROR, host->addr + TUL_SFifo);		/* Initiator Detected Error */
 	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 	return wait_tulip(host);
 }
@@ -2167,9 +2169,9 @@ static int initio_msgin_extend(struct initio_host * host)
 
 		initio_sync_done(host);
 
-		outb(MSG_EXTEND, host->addr + TUL_SFifo);
+		outb(EXTENDED_MESSAGE, host->addr + TUL_SFifo);
 		outb(3, host->addr + TUL_SFifo);
-		outb(1, host->addr + TUL_SFifo);
+		outb(EXTENDED_SDTR, host->addr + TUL_SFifo);
 		outb(host->msg[2], host->addr + TUL_SFifo);
 		outb(host->msg[3], host->addr + TUL_SFifo);
 		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
@@ -2199,9 +2201,9 @@ static int initio_msgin_extend(struct initio_host * host)
 	if (initio_msgin_accept(host) != MSG_OUT)
 		return host->phase;
 	/* WDTR msg out                 */
-	outb(MSG_EXTEND, host->addr + TUL_SFifo);
+	outb(EXTENDED_MESSAGE, host->addr + TUL_SFifo);
 	outb(2, host->addr + TUL_SFifo);
-	outb(3, host->addr + TUL_SFifo);
+	outb(EXTENDED_WDTR, host->addr + TUL_SFifo);
 	outb(host->msg[2], host->addr + TUL_SFifo);
 	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 	return wait_tulip(host);
@@ -2391,7 +2393,7 @@ int initio_bus_device_reset(struct initio_host * host)
 		}
 		tmp = tmp->next;
 	}
-	outb(MSG_DEVRST, host->addr + TUL_SFifo);
+	outb(TARGET_RESET, host->addr + TUL_SFifo);
 	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 	return initio_wait_disc(host);
 
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index 219b901bdc25..9fd010cf1f8a 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -433,31 +433,6 @@ struct scsi_ctrl_blk {
 #define TARGET_BUSY     0x08
 #define INI_QUEUE_FULL	0x28
 
-/* SCSI MESSAGE */
-#define MSG_COMP        0x00
-#define MSG_EXTEND      0x01
-#define MSG_SDP         0x02
-#define MSG_RESTORE     0x03
-#define MSG_DISC        0x04
-#define MSG_IDE         0x05
-#define MSG_ABORT       0x06
-#define MSG_REJ         0x07
-#define MSG_NOP         0x08
-#define MSG_PARITY      0x09
-#define MSG_LINK_COMP   0x0A
-#define MSG_LINK_FLAG   0x0B
-#define MSG_DEVRST      0x0C
-#define MSG_ABORT_TAG   0x0D
-
-/* Queue tag msg: Simple_quque_tag, Head_of_queue_tag, Ordered_queue_tag */
-#define MSG_STAG        0x20
-#define MSG_HTAG        0x21
-#define MSG_OTAG        0x22
-
-#define MSG_IGNOREWIDE  0x23
-
-#define MSG_IDENT   0x80
-
 /***********************************************************************
 		Target Device Control Structure
 **********************************************************************/
-- 
2.16.4

