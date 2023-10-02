Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86917E748ED
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbjJBP7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbjJBP73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:59:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05D103
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:59:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA0EC1F750;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696262357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYyrhuN85pVIDrzbT1zvlZQ0yzU+JWFzOSk5AZYWmak=;
        b=PSE8bTd5QmaaA38LW0ueFVDTt6mQwBz2fW3xaAsjkrJd9v/A0iw5zanSv5xrDOA5aw8kNc
        cv4bhlBFIwerQ745A8w/V0nXefOUitASl0fX3QN0LhJDca9Pz6Pxxdl6ENvz40UpeWcPo2
        tuKyKVcXkQeSdDNBIeXIMvUAfxLRfDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696262357;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYyrhuN85pVIDrzbT1zvlZQ0yzU+JWFzOSk5AZYWmak=;
        b=2COSZWsauKrC+8/yLHBWzd7n2rnX7rz+GonTLc9qVwjCXmbq+A6hvuSKgc+knBaHoGOsPo
        GFm1QQocZNpaFDAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 856292C14F;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8AB6951E758A; Mon,  2 Oct 2023 17:59:17 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
Date:   Mon,  2 Oct 2023 17:59:14 +0200
Message-Id: <20231002155915.109359-7-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
References: <20231002155915.109359-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c  | 2 --
 include/scsi/scsi_cmnd.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ca5eb058d5c7..6525fe10b0ee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1619,8 +1619,6 @@ static void scsi_done_internal(struct scsi_cmnd *cmd, bool complete_directly)
 		break;
 	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
 		return scsi_eh_done(cmd);
-	case SUBMITTED_BY_SCSI_RESET_IOCTL:
-		return;
 	}
 
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 526def14e7fb..d681510724aa 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -68,7 +68,6 @@ struct scsi_pointer {
 enum scsi_cmnd_submitter {
 	SUBMITTED_BY_BLOCK_LAYER = 0,
 	SUBMITTED_BY_SCSI_ERROR_HANDLER = 1,
-	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
 struct scsi_cmnd {
-- 
2.35.3

