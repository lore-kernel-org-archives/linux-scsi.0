Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B095EC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 05:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiEXF4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 01:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbiEXF4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 01:56:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0A011148;
        Mon, 23 May 2022 22:56:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6DD9921A38;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653371805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CsI9UcXu38qZrN6Sl5v7D5+zXoVikP48mnfhQAqpJzw=;
        b=mnoHlAIH7gTQShLQzRuwzn3ibIO769AsKATHFg8+eM+LDC/aV7WEl3PxUVgQ05UMcZ/Y9T
        JtrB4IyHM1/Hj95WyD5b84q4UmLoppE+ybeHTMtnQweX8PkVugCeNyj0ms3s9gW3gHefu3
        KF01Kg2eeagwy64+HMqAfJzB9GF0eKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653371805;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CsI9UcXu38qZrN6Sl5v7D5+zXoVikP48mnfhQAqpJzw=;
        b=G4Hgl7JY1ZqTHWquyruSbHdNpuCAfl2PI1ZiGvqZfDKDw78oEHpYR3AzxO1n9zQZjM12Kp
        1rWot3gBZ5xuebCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 64A032C143;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 392835194636; Tue, 24 May 2022 07:56:45 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi: return BLK_STS_TRANSPORT for ALUA transitioning
Date:   Tue, 24 May 2022 07:56:31 +0200
Message-Id: <20220524055631.85480-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524055631.85480-1-hare@suse.de>
References: <20220524055631.85480-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the 'ALUA state transitioning' sense code is returned we
cannot use BLK_STS_AGAIN, as this has a very specific use-case.
So return BLK_STS_TRANSPORT here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d18cc7e510e..a55deb5caa34 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -779,7 +779,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
-					blk_stat = BLK_STS_AGAIN;
+					blk_stat = BLK_STS_TRANSPORT;
 					fallthrough;
 				default:
 					action = ACTION_FAIL;
-- 
2.29.2

