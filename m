Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC7BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiECUL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiECUKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0B726AE3
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7685421881;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgBLwKqCdIBIR8UF851m+PNnlD2mIXnnT5PFXmQDzvs=;
        b=nt7g7Hu8BOHWcDHYe76Q83ZlZnrzlcrLkJ01zP6yqT8qXf/6DnsWoqw1hzCVrmUAF3SkRW
        qTX9BQYBSDBiUsJXe+EUShUZ8e7qYQ+4IWo7275QxNWbtPEgbja2i//fF7fo0hYmXjA1Zw
        DVVsHHNpu/Fhcgydl/BLFBG0sk3J7F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgBLwKqCdIBIR8UF851m+PNnlD2mIXnnT5PFXmQDzvs=;
        b=LZUMEjTqkP4lvDhXS62Qkdi8fMklzo0O7qywZ7CKKH0yuefszSiwf3N7+0jN5QZlurAeSE
        lCbgwKaBuSVb5UDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 5D6402C172;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6DCCD51941F4; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/24] megaraid: pass in NULL scb for host reset
Date:   Tue,  3 May 2022 22:07:03 +0200
Message-Id: <20220503200704.88003-24-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When calling a host reset we shouldn't rely on the command triggering
the reset, so allow megaraid_abort_and_reset() to be called with a
NULL scb.
And drop the pointless 'bus_reset' and 'target_reset' handlers, which
just call the same function as host_reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid.c | 42 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index a5d8cee2d510..9484632ffed6 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1897,7 +1897,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 	spin_lock_irq(&adapter->lock);
 
-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
+	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
 
 	/*
 	 * This is required here to complete any completed requests
@@ -1936,7 +1936,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 
 		scb = list_entry(pos, scb_t, list);
 
-		if (scb->cmd == cmd) { /* Found command */
+		if (!cmd || scb->cmd == cmd) { /* Found command */
 
 			scb->state |= aor;
 
@@ -1955,31 +1955,23 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 
 				return FAILED;
 			}
-			else {
-
-				/*
-				 * Not yet issued! Remove from the pending
-				 * list
-				 */
-				dev_warn(&adapter->dev->dev,
-					"%s-[%x], driver owner\n",
-					(aor==SCB_ABORT) ? "ABORTING":"RESET",
-					scb->idx);
-
-				mega_free_scb(adapter, scb);
-
-				if( aor == SCB_ABORT ) {
-					cmd->result = (DID_ABORT << 16);
-				}
-				else {
-					cmd->result = (DID_RESET << 16);
-				}
+			/*
+			 * Not yet issued! Remove from the pending
+			 * list
+			 */
+			dev_warn(&adapter->dev->dev,
+				 "%s-[%x], driver owner\n",
+				 (cmd) ? "ABORTING":"RESET",
+				 scb->idx);
+			mega_free_scb(adapter, scb);
 
+			if (cmd) {
+				cmd->result = (DID_ABORT << 16);
 				list_add_tail(SCSI_LIST(cmd),
-						&adapter->completed_list);
-
-				return SUCCESS;
+					      &adapter->completed_list);
 			}
+
+			return SUCCESS;
 		}
 	}
 
@@ -4113,8 +4105,6 @@ static struct scsi_host_template megaraid_template = {
 	.sg_tablesize			= MAX_SGLIST,
 	.cmd_per_lun			= DEF_CMD_PER_LUN,
 	.eh_abort_handler		= megaraid_abort,
-	.eh_device_reset_handler	= megaraid_reset,
-	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
 	.no_write_same			= 1,
 	.cmd_size			= sizeof(struct megaraid_cmd_priv),
-- 
2.29.2

