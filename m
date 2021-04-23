Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EBAC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BF861445
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbhDWLlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:47136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242261AbhDWLkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8399EB1D0;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/39] nsp32: do not set message byte
Date:   Fri, 23 Apr 2021 13:39:28 +0200
Message-Id: <20210423113944.42672-24-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The message byte always devolves to COMMAND_COMPLETE, so there
is no point in setting it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/nsp32.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 6d29908017f0..56009eb248a7 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -948,7 +948,6 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt,
 	SCpnt->scsi_done     = done;
 	data->CurrentSC      = SCpnt;
 	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
-	SCpnt->SCp.Message   = 0;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
 	SCpnt->SCp.ptr		    = (char *)scsi_sglist(SCpnt);
@@ -1690,12 +1689,10 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
 
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
-		SCpnt->SCp.Message = 0;
 		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
 		SCpnt->result = (DID_OK << 16) |
-			(SCpnt->SCp.Message << 8) |
 			(SCpnt->SCp.Status << 0);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
@@ -1703,7 +1700,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 	} else if (execph & MSGIN_04_VALID) {
 		/* MsgIn 04: Disconnect */
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
-		SCpnt->SCp.Message = 4;
 
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
@@ -1712,7 +1708,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		nsp32_msg(KERN_WARNING, "unexpected bus free occurred");
 
 		/* DID_ERROR? */
-		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Message << 8) | (SCpnt->SCp.Status << 0);
+		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Status << 0);
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
-- 
2.29.2

