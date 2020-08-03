Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DBEC433E3
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 16:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB1A2067D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 16:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHCQXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 12:23:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:59228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgHCQXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Aug 2020 12:23:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 86EC3AB7A;
        Mon,  3 Aug 2020 16:23:18 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Reset done and free callback pointer on release
Date:   Mon,  3 Aug 2020 18:23:01 +0200
Message-Id: <20200803162301.103927-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reset ->done and ->free when releasing the srb. There is a hidden
use-after-free bug in the driver which corrupts the srb memory pool
which originates from the cleanup callbacks. By explicitly resetting
the callbacks to NULL, we workaround the memory corruption.

An extensive search didn't bring any lights on the real problem. The
initial idea was to set both pointers to NULL and try to catch invalid
accesses. But instead the memory corruption was gone and the driver
didn't crash.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

Hi,

Although I would prefer to fix the real problem, it's propably better
to go with this workaround until we can fix it properly. I still
hope to find the use-after-free with KASAN...

Thanks,
Daniel

 drivers/scsi/qla2xxx/qla_inline.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 861dc522723c..6d41d758fc17 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -211,6 +211,8 @@ static inline void
 qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
 {
 	sp->qpair = NULL;
+	sp->done = NULL;
+	sp->free = NULL;
 	mempool_free(sp, qpair->srb_mempool);
 	QLA_QPAIR_MARK_NOT_BUSY(qpair);
 }
-- 
2.16.4

