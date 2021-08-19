Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F85C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649BA6113E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhHSIku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:40:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58194 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhHSIkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 04:40:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D96D3200B2;
        Thu, 19 Aug 2021 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629362412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x81QRyVofb8llimHJeWiHDdTMN7phUtK0/hE3ySUgkY=;
        b=GGJB8rMLeD0dFq8mc8A/MxdlsW1s0Ni1p04/rTxkTYTedTXOF1vyH64i1Bcl0ou3smQc5p
        bXTpTUqxM62U6GjLBH4XZjpMH2MvW81uSIktdbZ5zq3wD94YJfS8DnXOknDXLk2Esx6MyC
        eirvw1nIq9hPQSjAYn/fMJgJCMQzQOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629362412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x81QRyVofb8llimHJeWiHDdTMN7phUtK0/hE3ySUgkY=;
        b=Jl5HB4BMMVscF9b1jR9nlD/DcAIz5tlDaSf466W4v9gZJ5n/U8jo8egGOarclQo96Adr/J
        e373TPHPgehhfBAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 28274A3B9A;
        Thu, 19 Aug 2021 08:40:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 789CC518D265; Thu, 19 Aug 2021 10:40:12 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi: remove 'current_tag'
Date:   Thu, 19 Aug 2021 10:40:07 +0200
Message-Id: <20210819084007.79233-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819084007.79233-1-hare@suse.de>
References: <20210819084007.79233-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'current_tag' field in struct scsi_device is unused now; remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_device.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..b97e142a7ca9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -146,7 +146,6 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
-	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
-- 
2.29.2

