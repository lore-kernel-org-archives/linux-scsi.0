Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925EDC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E6D610FE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhHSJRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:17:23 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60586 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbhHSJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1568B220C2;
        Thu, 19 Aug 2021 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0aRMmkTwktttqMojm8KH72XYQX+Owv/UcXWiXj0Uc9s=;
        b=ymWbRdXszg2Z1HAvQTE/BEs+dYr3u0qnm8XtTv9/hoY4+myDVtATV/pJM79hUTCNoRSgUc
        FQSkiOV9IhXfabx8cLkznsYzrLSrbUrntzW0PL19GrCcnLHjkHn2OpXA7V/SvhvoBhEzgk
        31fEwfZUzrPT6DDMIurEpKNXjDEjRBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364600;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0aRMmkTwktttqMojm8KH72XYQX+Owv/UcXWiXj0Uc9s=;
        b=iDblHK9Zxh+71DjObjMTQOOTJwhMvqdaAvmoJXq2oNGJsm6rKBxlt92uVon33cvRX/vZFm
        RKQVeIllVz7dbaDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 542F4A3B9F;
        Thu, 19 Aug 2021 09:16:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F3D9A518D290; Thu, 19 Aug 2021 11:16:39 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] megaraid: complete all commands in megaraid_reset()
Date:   Thu, 19 Aug 2021 11:16:34 +0200
Message-Id: <20210819091636.94311-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091636.94311-1-hare@suse.de>
References: <20210819091636.94311-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When calling host reset all commands need to be completed, not
just that one triggering SCSI EH.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 56910e94dbf2..10c1793d4b6d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1887,7 +1887,8 @@ megaraid_reset(struct scsi_cmnd *cmd)
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
-	int		rval;
+	int		rval = SUCCESS;
+	struct list_head	*pos, *next;
 
 	adapter = (adapter_t *)cmd->device->host->hostdata;
 
@@ -1905,7 +1906,37 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 	spin_lock_irq(&adapter->lock);
 
-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
+	dev_warn(&adapter->dev->dev, "RESET HBA\n");
+
+	list_for_each_safe(pos, next, &adapter->pending_list) {
+		scb_t *scb = list_entry(pos, scb_t, list);
+
+		scb->state |= SCB_RESET;
+
+		/*
+		 * Check if this command has firmware ownership. If
+		 * yes, we cannot reset this command. Whenever f/w
+		 * completes this command, we will return appropriate
+		 * status from ISR.
+		 */
+		if( scb->state & SCB_ISSUED ) {
+			dev_warn(&adapter->dev->dev,
+				 "RESET[%x], fw owner\n",
+				 scb->idx);
+			rval = FAILED;
+			break;
+		}
+		/*
+		 * Not yet issued! Remove from the pending
+		 * list
+		 */
+		dev_warn(&adapter->dev->dev,
+			 "RESET[%x], driver owner\n", scb->idx);
+		scb->cmd->result = (DID_RESET << 16);
+		list_add_tail(SCSI_LIST(scb->cmd),
+			      &adapter->completed_list);
+		mega_free_scb(adapter, scb);
+	}
 
 	/*
 	 * This is required here to complete any completed requests
-- 
2.29.2

