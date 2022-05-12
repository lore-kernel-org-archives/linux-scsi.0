Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70B8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353055AbiELLNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353038AbiELLM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AFA633A7
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 66CE621CE3;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CmwjCAFTKb09mluTpIDTzQnRQK20LBQvMw4M4SmLP4=;
        b=AZP1bR+ZNlMp3jIOZZCE8JIZwv0d9SvIyYqq0u6zxQQSFfTVyHs4gxnifqJfNQwV2wZAuw
        uzr2AWyGsc4bIQ+WTJpjiR10vw1HP4A/064Q7f+2VC/dltfz4d/s05eBqnsm9re0Qqb95Z
        IcAucOBWzcv7K+AXVOXtccqHgv5aNxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CmwjCAFTKb09mluTpIDTzQnRQK20LBQvMw4M4SmLP4=;
        b=L7DSWuOem7GRVXuY/LlSunxsFb3AP1ninTA5Y6Fi9ZU1SJoJpWVroHd0w9/P25xnQ5cQ7I
        Hvo+AlG6Q928EKCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 597F02C162;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3D6035194400; Thu, 12 May 2022 13:12:46 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 20/20] megaraid: pass in NULL scb for host reset
Date:   Thu, 12 May 2022 13:12:36 +0200
Message-Id: <20220512111236.109851-21-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220512111236.109851-1-hare@suse.de>
References: <20220512111236.109851-1-hare@suse.de>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

