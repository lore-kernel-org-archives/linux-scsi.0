Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6BAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 05:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiEXF45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 01:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiEXF4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 01:56:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1B111A3D;
        Mon, 23 May 2022 22:56:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6D33D1F8EE;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653371805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=873GnXagFRTeGHOE7QPgVKo/qHNhHpn55oDQuuiQ+Gg=;
        b=sNCiSKk5KlMW8QtPYRhgow6/P8zLxnt4xcFjvwmbxMSlILER5qVkEN6WuNBHlS4fwEtl0C
        az/O7Cx0VsNJNtjWacKiy4x3FAVPkKqM9tH/Hkz7BnwhkAiyOXh1+utES6iCkMJKh5Y7FJ
        Ze7EuTrRM9xBIeSCnTmLLEyWKwdD5kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653371805;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=873GnXagFRTeGHOE7QPgVKo/qHNhHpn55oDQuuiQ+Gg=;
        b=X0kuB6fKDSR12byjFRAtgjBVp1DMhfhiipI6y4odTDVD4+zZE7Oua3GdRpLqom7tI3C6ul
        K58LhXUedlSNKcDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 620452C141;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 34AD15194634; Tue, 24 May 2022 07:56:45 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] block: document BLK_STS_AGAIN usage
Date:   Tue, 24 May 2022 07:56:30 +0200
Message-Id: <20220524055631.85480-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524055631.85480-1-hare@suse.de>
References: <20220524055631.85480-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BLK_STS_AGAIN should only be used if RQF_NOWAIT is set and the bio
would block. So we'd better document that to avoid accidental misuse.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/blk_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1973ef9bd40f..8fb8f79cb74e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -105,6 +105,10 @@ typedef u16 blk_short_t;
 /* hack for device mapper, don't use elsewhere: */
 #define BLK_STS_DM_REQUEUE    ((__force blk_status_t)11)
 
+/*
+ * BLK_STS_AGAIN should only be returned if RQF_NOWAIT is set
+ * and the bio would block (cf bio_wouldblock_error())
+ */
 #define BLK_STS_AGAIN		((__force blk_status_t)12)
 
 /*
-- 
2.29.2

