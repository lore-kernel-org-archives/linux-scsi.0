Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16C0C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A93AB60EE4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhHQJRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47422 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C7FE220013;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DlDhx/qFtGavyP4HP0CZPaT7DeM3oruXXgo9tmPTz2M=;
        b=L0fZMI8h9McgS7DhANGsLC3BjVxm066Qw3Qxg+Cczt5XzCf4r+7zphfcmQqv6h5oOpbars
        rMjWzR3bgrlXdD0vM8C6QGut+HOoJLw+XjBUieObjpK+JSQqR7LzD16rKG8G4qemgDkNX+
        lZAEZ6wYKD31UCVhGXHiKgF1sC03DC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DlDhx/qFtGavyP4HP0CZPaT7DeM3oruXXgo9tmPTz2M=;
        b=MxHtAau1e/BCuq78S5lP6+Psncl3fzYIiuirin+eEhtkFKYgmO1xd/SI3llGDMCqCwmR3p
        jqRmEV+bshRLNvAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C22CAA3B99;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BF52F518CE6D; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 07/51] megaraid: pass in NULL scb for host reset
Date:   Tue, 17 Aug 2021 11:14:12 +0200
Message-Id: <20210817091456.73342-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid.c | 42 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 56910e94dbf2..7c53933fb1b4 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1905,7 +1905,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 	spin_lock_irq(&adapter->lock);
 
-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
+	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
 
 	/*
 	 * This is required here to complete any completed requests
@@ -1944,7 +1944,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 
 		scb = list_entry(pos, scb_t, list);
 
-		if (scb->cmd == cmd) { /* Found command */
+		if (!cmd || scb->cmd == cmd) { /* Found command */
 
 			scb->state |= aor;
 
@@ -1963,31 +1963,23 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 
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
 
@@ -4135,8 +4127,6 @@ static struct scsi_host_template megaraid_template = {
 	.sg_tablesize			= MAX_SGLIST,
 	.cmd_per_lun			= DEF_CMD_PER_LUN,
 	.eh_abort_handler		= megaraid_abort,
-	.eh_device_reset_handler	= megaraid_reset,
-	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
 	.no_write_same			= 1,
 };
-- 
2.29.2

