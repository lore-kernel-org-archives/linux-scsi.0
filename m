Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F20FC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2B760FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhHQJRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33306 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239267AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1E81921D3B;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMCpDwdQuHGWQIUjkeyKrf/jcFqbs6U8/UihLkQVXnA=;
        b=f1NajFg/1uDBJosVsQXF8kHyqK9HhkxXfBs09itbXFSZwFx3nENsXYoDteKIQDnPEf7sM+
        lm0nZlws4psJDo01eRQWOkpAtUCML+ChgIjDevynMDK/UcK/qMQsoZHEE7ltT1nJckS/57
        EQrf0m/QKA5kohXsUXg0tf6P7rzLFP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMCpDwdQuHGWQIUjkeyKrf/jcFqbs6U8/UihLkQVXnA=;
        b=H26uADHFx906L5xMsHp4ud0yeC59UPPMz14CgDRVsFGtAiKAoViCupC0QLbft+jii6Jf8/
        C8GH02/CTtX5wHAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 12E6CA3BA5;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 102CB518CE83; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 18/51] ncr53c8xx: remove 'sync_reset' argument from ncr_reset_bus()
Date:   Tue, 17 Aug 2021 11:14:23 +0200
Message-Id: <20210817091456.73342-19-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Always '1', so we can remove it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ncr53c8xx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..3d2daaf2368c 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4553,7 +4553,7 @@ static void ncr_start_reset(struct ncb *np)
 **
 **==========================================================
 */
-static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd, int sync_reset)
+static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd)
 {
 /*	struct scsi_device        *device    = cmd->device; */
 	struct ccb *cp;
@@ -4600,11 +4600,10 @@ static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd, int sync_reset)
 	ncr_wakeup(np, HS_RESET);
 /*
  * If the involved command was not in a driver queue, and the 
- * scsi driver told us reset is synchronous, and the command is not 
- * currently in the waiting list, complete it with DID_RESET status,
- * in order to keep it alive.
+ * command is not currently in the waiting list, complete it
+ * with DID_RESET status in order to keep it alive.
  */
-	if (!found && sync_reset && !retrieve_from_waiting_list(0, np, cmd)) {
+	if (!found && !retrieve_from_waiting_list(0, np, cmd)) {
 		set_host_byte(cmd, DID_RESET);
 		ncr_queue_done_cmd(np, cmd);
 	}
@@ -8125,7 +8124,7 @@ static int ncr53c8xx_bus_reset(struct scsi_cmnd *cmd)
 	 */
 
 	spin_lock_irqsave(&np->smp_lock, flags);
-	sts = ncr_reset_bus(np, cmd, 1);
+	sts = ncr_reset_bus(np, cmd);
 
 	done_list     = np->done_list;
 	np->done_list = NULL;
-- 
2.29.2

