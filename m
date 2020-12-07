Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3225C0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E0723403
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgLGMt5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:49:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:43246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgLGMt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:49:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AFE40AE61;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/35] nsp32: fixup status handling
Date:   Mon,  7 Dec 2020 13:47:55 +0100
Message-Id: <20201207124819.95822-12-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCp.status is always the SAM-defined status value, not the linux
ones. Fixup the one wrong definition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index da814c2da16d..e44b1a0f6709 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -935,7 +935,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 
 	SCpnt->scsi_done     = done;
 	data->CurrentSC      = SCpnt;
-	SCpnt->SCp.Status    = CHECK_CONDITION;
+	SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
 	SCpnt->SCp.Message   = 0;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
-- 
2.16.4

