Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A128C43462
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AE7261409
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbhDURvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245067AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D63F6B2E1;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/42] nsp32: do not set message byte
Date:   Wed, 21 Apr 2021 19:47:32 +0200
Message-Id: <20210421174749.11221-26-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The message byte always devolves to COMMAND_COMPLETE, so there
is no point in setting it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/nsp32.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index abecbcefc382..b75844c76f3a 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1696,7 +1696,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
-		set_msg_byte(SCpnt, SCpnt->SCp.Message);
 		set_status_byte(SCpnt, SCpnt->SCp.Status);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
-- 
2.29.2

