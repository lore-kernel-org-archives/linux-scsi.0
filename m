Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A781EC0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9C623406
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLGMuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:50:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:44226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgLGMui (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13260AEBB;
        Mon,  7 Dec 2020 12:48:32 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/35] dc395x: drop internal SCSI message definitions
Date:   Mon,  7 Dec 2020 13:48:04 +0100
Message-Id: <20201207124819.95822-21-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the internel SCSI message definitions and use the functions
provided by the SPI transport class.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/dc395x.c | 25 ++++++++++---------------
 drivers/scsi/dc395x.h | 22 ----------------------
 2 files changed, 10 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 7b522ff345d5..b1125012bee0 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "dc395x.h"
 
@@ -1281,11 +1282,7 @@ static void build_sdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	} else if (dcb->sync_offset == 0)
 		dcb->sync_offset = SYNC_NEGO_OFFSET;
 
-	*ptr++ = MSG_EXTENDED;	/* (01h) */
-	*ptr++ = 3;		/* length */
-	*ptr++ = EXTENDED_SDTR;	/* (01h) */
-	*ptr++ = dcb->min_nego_period;	/* Transfer period (in 4ns) */
-	*ptr++ = dcb->sync_offset;	/* Transfer period (max. REQ/ACK dist) */
+	spi_populate_sync_msg(ptr, dcb->min_nego_period, dcb->sync_offset);
 	srb->msg_count += 5;
 	srb->state |= SRB_DO_SYNC_NEGO;
 }
@@ -1305,10 +1302,7 @@ static void build_wdtr(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 			srb->msgout_buf[1]);
 		return;
 	}
-	*ptr++ = MSG_EXTENDED;	/* (01h) */
-	*ptr++ = 2;		/* length */
-	*ptr++ = EXTENDED_WDTR;	/* (03h) */
-	*ptr++ = wide;
+	spi_populate_width_msg(ptr, wide);
 	srb->msg_count += 4;
 	srb->state |= SRB_DO_WIDE_NEGO;
 }
@@ -1476,7 +1470,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 			return 1;
 		}
 		/* Send Tag id */
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_SIMPLE_QTAG);
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, SIMPLE_QUEUE_TAG);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, tag_number);
 		dcb->tag_mask |= tag_mask;
 		srb->tag_number = tag_number;
@@ -1732,8 +1726,9 @@ static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	if (!srb->msg_count) {
 		dprintkdbg(DBG_0, "msgout_phase1: (0x%p) NOP msg\n",
 			srb->cmd);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_NOP);
-		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, NOP);
+		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
+		/* it's important for atn stop */
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 		return;
 	}
@@ -1741,7 +1736,7 @@ static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	for (i = 0; i < srb->msg_count; i++)
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
 	srb->msg_count = 0;
-	if (srb->msgout_buf[0] == MSG_ABORT)
+	if (srb->msgout_buf[0] == ABORT_TASK_SET)
 		srb->state = SRB_ABORT_SENT;
 
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
@@ -2538,7 +2533,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 	srb = acb->tmp_srb;
 	srb->state = SRB_UNEXPECT_RESEL;
 	dcb->active_srb = srb;
-	srb->msgout_buf[0] = MSG_ABORT_TAG;
+	srb->msgout_buf[0] = ABORT_TASK;
 	srb->msg_count = 1;
 	DC395x_ENABLE_MSGOUT;
 	dprintkl(KERN_DEBUG, "msgin_qtag: Unknown tag %i - abort\n", tag);
@@ -2780,7 +2775,7 @@ static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 			msgin_reject(acb, srb);
 			break;
 
-		case MSG_IGNOREWIDE:
+		case IGNORE_WIDE_RESIDUE:
 			/* Discard  wide residual */
 			dprintkdbg(DBG_0, "msgin_phase0: Ignore Wide Residual!\n");
 			break;
diff --git a/drivers/scsi/dc395x.h b/drivers/scsi/dc395x.h
index a7786a6d462e..24a36c046d07 100644
--- a/drivers/scsi/dc395x.h
+++ b/drivers/scsi/dc395x.h
@@ -172,28 +172,6 @@
 
 #define SYNC_NEGO_OFFSET		15
 
-/* SCSI MSG BYTE */
-#define MSG_COMPLETE			0x00
-#define MSG_EXTENDED			0x01
-#define MSG_SAVE_PTR			0x02
-#define MSG_RESTORE_PTR			0x03
-#define MSG_DISCONNECT			0x04
-#define MSG_INITIATOR_ERROR		0x05
-#define MSG_ABORT			0x06
-#define MSG_REJECT_			0x07
-#define MSG_NOP				0x08
-#define MSG_PARITY_ERROR		0x09
-#define MSG_LINK_CMD_COMPL		0x0A
-#define MSG_LINK_CMD_COMPL_FLG		0x0B
-#define MSG_BUS_RESET			0x0C
-#define MSG_ABORT_TAG			0x0D
-#define MSG_SIMPLE_QTAG			0x20
-#define MSG_HEAD_QTAG			0x21
-#define MSG_ORDER_QTAG			0x22
-#define MSG_IGNOREWIDE			0x23
-#define MSG_IDENTIFY			0x80
-#define MSG_HOST_ID			0xC0
-
 /* cmd->result */
 #define STATUS_MASK_			0xFF
 #define MSG_MASK			0xFF00
-- 
2.16.4

