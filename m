Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB119C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4FFE61100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhHSJRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:17:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60598 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbhHSJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1ADEF220C4;
        Thu, 19 Aug 2021 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Oa5R4qC7wZVEInk4ooM8lcxb6YmdVs0y7XfwsdbdgY=;
        b=z0zSuoAg+ukSB0r14kDJNuCHFNZnM2ggpUGNGcf5KI+06kNCh/BEX5r71ZkxYWfjCPPCch
        bDu1bL+1pk/18iyQQON+N7Wx0gGzv0G9CKAOFDB7RdEclSHPfCg8q7QlLEi37oTHKj+2wf
        Ee15s3j/IAzLuwJ2Mlsr+5hHBrc740E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364600;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Oa5R4qC7wZVEInk4ooM8lcxb6YmdVs0y7XfwsdbdgY=;
        b=Wd8J2DNUojsotp1LsFXaqqJ7Sy0Mr3z7i4IkI0+pcMNw8L1MtNKVPXpJrOksLOOU+0gMyo
        CWCSi/+uuHfQIrBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 58B9CA3BA2;
        Thu, 19 Aug 2021 09:16:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 0BE9C518D294; Thu, 19 Aug 2021 11:16:40 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] megaraid: remove pointless bus_reset and device_reset handler
Date:   Thu, 19 Aug 2021 11:16:36 +0200
Message-Id: <20210819091636.94311-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091636.94311-1-hare@suse.de>
References: <20210819091636.94311-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both bus and device reset would be calling into the same function
as host reset, so remove them as host reset will always be called.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index b213ad62639d..ad0ea6dbd513 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4156,8 +4156,6 @@ static struct scsi_host_template megaraid_template = {
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

