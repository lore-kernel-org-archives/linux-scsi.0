Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252EAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD0D6113D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbhHSIkw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:40:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58218 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbhHSIkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 04:40:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E06BE200B4;
        Thu, 19 Aug 2021 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629362412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ldGkK913Rj64Mlsn7o1hfsbnYOOJnxnecHMWVEdKTN4=;
        b=hKVFLVO6lQm5RwyKyPhy2xIBbquIiorTNB30ykoVPCGzF3TBdxVIH2BVgEIGkQFIAbJ5KH
        gCEH/kh8XqMSQPQRr7g984p2mHS2/dCo7CGbSkFOgYqor2Op7762bdPN1tCGdTpbcUxXF+
        0gjbw4nzfchRFlaUaES5rELlXRr+qAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629362412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ldGkK913Rj64Mlsn7o1hfsbnYOOJnxnecHMWVEdKTN4=;
        b=VxxI6SzbGmST8YJtpGJh1AeiwnHllmCAFGT/7p451mIkSbld9z3IblflI750gDTdx/SrUv
        uyiD407zu+D68/CA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 28543A3B9C;
        Thu, 19 Aug 2021 08:40:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6710C518D25F; Thu, 19 Aug 2021 10:40:12 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: Introduct scsi_cmd_to_tag()
Date:   Thu, 19 Aug 2021 10:40:04 +0200
Message-Id: <20210819084007.79233-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819084007.79233-1-hare@suse.de>
References: <20210819084007.79233-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce a wrapper to get the tag from a SCSI command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_cmnd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index eaf04c9a1dfc..f3cc3aa0eb04 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -165,6 +165,13 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)rq->rq_disk->private_data;
 }
 
+static inline u32 scsi_cmd_to_tag(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	return rq->tag;
+}
+
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
2.29.2

