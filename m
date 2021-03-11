Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D972C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B9164FBA
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCKSOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:14:47 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51088 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhCKSOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:14:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id ACE4E20426D;
        Thu, 11 Mar 2021 19:14:29 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PrDAsbfe9Umx; Thu, 11 Mar 2021 19:14:28 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 3B5EC204259;
        Thu, 11 Mar 2021 19:14:27 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        colin.king@canonical.com
Subject: [PATCH 1/4] sg: sg_rq_map_kern: fix uninitialized
Date:   Thu, 11 Mar 2021 13:14:20 -0500
Message-Id: <20210311181423.137646-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311181423.137646-1-dgilbert@interlog.com>
References: <20210311181423.137646-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable k should not be used in call to sg_mk_kern_bio().

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2d4bbc1a1727..7d4a0fd9ee32 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2987,7 +2987,7 @@ sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *
 		return 0;
 	if (rw_ind == WRITE)
 		op_flags = REQ_SYNC | REQ_IDLE;
-	bio = sg_mk_kern_bio(num_sgat - k);
+	bio = sg_mk_kern_bio(num_sgat);
 	if (!bio)
 		return -ENOMEM;
 	bio->bi_opf = req_op(rqq) | op_flags;
-- 
2.25.1

