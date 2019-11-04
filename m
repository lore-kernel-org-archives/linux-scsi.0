Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB714CA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB52920656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfKDJCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:57148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727826AbfKDJCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E583B2BC;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/52] dc395x: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:08 +0100
Message-Id: <20191104090151.129140-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status codes and omit the explicit shift to convert
from linux-specific ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dc395x.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13fbb2eab842..a56893bc681e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -168,7 +168,6 @@
 #define RES_DRV			0xFF000000	/* DRIVER_ codes */
 
 #define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
-#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
 
 #define SET_RES_TARGET(who,tgt) { who &= ~RES_TARGET; who |= (int)(tgt); }
 #define SET_RES_TARGET_LNX(who,tgt) { who &= ~RES_TARGET_LNX; who |= (int)(tgt) << 1; }
@@ -3228,7 +3227,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		 */
 		srb->flag &= ~AUTO_REQSENSE;
 		srb->adapter_status = 0;
-		srb->target_status = CHECK_CONDITION << 1;
+		srb->target_status = SAM_STAT_CHECK_CONDITION;
 		if (debug_enabled(DBG_1)) {
 			switch (cmd->sense_buffer[2] & 0x0f) {
 			case NOT_READY:
@@ -3275,22 +3274,15 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 					*((unsigned int *)(cmd->sense_buffer + 3)));
 		}
 
-		if (status == (CHECK_CONDITION << 1)) {
+		if (status == SAM_STAT_CHECK_CONDITION) {
 			cmd->result = DID_BAD_TARGET << 16;
 			goto ckc_e;
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
-		if (srb->total_xfer_length
-		    && srb->total_xfer_length >= cmd->underflow)
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
-		/*SET_RES_DID(cmd->result,DID_OK) */
-		else
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
+		cmd->result =
+		    MK_RES(DRIVER_SENSE, DID_OK,
+			   srb->end_message, SAM_STAT_CHECK_CONDITION);
 
 		goto ckc_e;
 	}
-- 
2.16.4

