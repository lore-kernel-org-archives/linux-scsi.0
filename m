Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBA8C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC5461100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhHSJRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:17:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60592 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbhHSJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 188AA220C3;
        Thu, 19 Aug 2021 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STixL47ffdF9sySPgG+6VmdgUgsejDsntDn0lQaiB/U=;
        b=QkzFlAhv+bdJaiBxHYJcqcLo23w3tkdEJrw/t3kYYiM7T4G4jaifKIL1jX6WoTh4fGxqL8
        IQyl8sk7V334S1cmHa3iQaUau6/KmeN2F6nLYMT3I2M4LYynkAMhZrtdvrl7sLPYRpjMMC
        jnFCizwfWAqdlTEWu033cz5g/hG/Sws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364600;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STixL47ffdF9sySPgG+6VmdgUgsejDsntDn0lQaiB/U=;
        b=XN+gTjT9Z1wHa9kmGnE+rCctYqAREHgXUQbD0bLWMCpAdEO3Q/rVKZ7XqL36VB76q7aFxw
        xk+PDiNfz1RPf4Dw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 54B00A3BA1;
        Thu, 19 Aug 2021 09:16:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 05567518D292; Thu, 19 Aug 2021 11:16:40 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] megaraid: rename megaraid_abort_and_reset() to __megaraid_abort()
Date:   Thu, 19 Aug 2021 11:16:35 +0200
Message-Id: <20210819091636.94311-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091636.94311-1-hare@suse.de>
References: <20210819091636.94311-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

megaraid_abort_and_reset() now only tries to abort / complete a
single command, so rename it to __megaraid_abort() to signal the
change in functionality.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid.c | 26 ++++++++------------------
 drivers/scsi/megaraid.h |  2 +-
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 10c1793d4b6d..b213ad62639d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1870,7 +1870,7 @@ megaraid_abort(struct scsi_cmnd *cmd)
 
 	adapter = (adapter_t *)cmd->device->host->hostdata;
 
-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_ABORT);
+	rval =  __megaraid_abort(adapter, cmd);
 
 	/*
 	 * This is required here to complete any completed requests
@@ -1949,22 +1949,20 @@ megaraid_reset(struct scsi_cmnd *cmd)
 }
 
 /**
- * megaraid_abort_and_reset()
+ * __megaraid_abort()
  * @adapter: megaraid soft state
  * @cmd: scsi command to be aborted or reset
- * @aor: abort or reset flag
  *
  * Try to locate the scsi command in the pending queue. If found and is not
  * issued to the controller, abort/reset it. Otherwise return failure
  */
 static int
-megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
+__megaraid_abort(adapter_t *adapter, struct scsi_cmnd *cmd)
 {
 	struct list_head	*pos, *next;
 	scb_t			*scb;
 
-	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
-	     (aor == SCB_ABORT)? "ABORTING":"RESET",
+	dev_warn(&adapter->dev->dev, "ABORTING cmd=%x <c=%d t=%d l=%d>\n",
 	     cmd->cmnd[0], cmd->device->channel,
 	     cmd->device->id, (u32)cmd->device->lun);
 
@@ -1977,7 +1975,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 
 		if (scb->cmd == cmd) { /* Found command */
 
-			scb->state |= aor;
+			scb->state |= SCB_ABORT;
 
 			/*
 			 * Check if this command has firmware ownership. If
@@ -1988,8 +1986,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 			if( scb->state & SCB_ISSUED ) {
 
 				dev_warn(&adapter->dev->dev,
-					"%s[%x], fw owner\n",
-					(aor==SCB_ABORT) ? "ABORTING":"RESET",
+					"ABORTING[%x], fw owner\n",
 					scb->idx);
 
 				return FAILED;
@@ -2001,18 +1998,11 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 				 * list
 				 */
 				dev_warn(&adapter->dev->dev,
-					"%s-[%x], driver owner\n",
-					(aor==SCB_ABORT) ? "ABORTING":"RESET",
+					"ABORTING[%x], driver owner\n",
 					scb->idx);
 
 				mega_free_scb(adapter, scb);
-
-				if( aor == SCB_ABORT ) {
-					cmd->result = (DID_ABORT << 16);
-				}
-				else {
-					cmd->result = (DID_RESET << 16);
-				}
+				cmd->result = (DID_ABORT << 16);
 
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index cce23a086fbe..8188c7f90faf 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -953,7 +953,7 @@ static void mega_free_scb(adapter_t *, scb_t *);
 
 static int megaraid_abort(struct scsi_cmnd *);
 static int megaraid_reset(struct scsi_cmnd *);
-static int megaraid_abort_and_reset(adapter_t *, struct scsi_cmnd *, int);
+static int __megaraid_abort(adapter_t *, struct scsi_cmnd *);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
 
-- 
2.29.2

