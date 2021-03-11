Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B756FC43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A2064FEE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCKSOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:14:46 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51117 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhCKSOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:14:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7C26D204196;
        Thu, 11 Mar 2021 19:14:33 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YHp8UwdTcNLZ; Thu, 11 Mar 2021 19:14:32 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id B8E22204259;
        Thu, 11 Mar 2021 19:14:29 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        colin.king@canonical.com
Subject: [PATCH 3/4] sg: sg_rq_end_io: set SG_FRQ_ISSUED
Date:   Thu, 11 Mar 2021 13:14:22 -0500
Message-Id: <20210311181423.137646-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311181423.137646-1-dgilbert@interlog.com>
References: <20210311181423.137646-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SG_FRQ_ISSUED flag should be set when the driver knows the
block layer has issued a request with blk_execute_rq_nowait().
This flag was set on the line following that nowait() call.
However with blk_poll() the request may have already invoked
the completion call-back (sg_rq_end_io()) so set this flag
there as well.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 77fec70b7c2f..b6e06e039d5b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2624,6 +2624,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
 		}
 	}
+	set_bit(SG_FRQ_ISSUED, srp->frq_bm);
 	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		int num = atomic_inc_return(&sfp->waiting);
 
-- 
2.25.1

