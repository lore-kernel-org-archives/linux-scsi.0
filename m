Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25515C43457
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E522722272
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050991;
	bh=+Y0a2asrL7jAicrUGmb4DlOlW6Zj6PfPYrl0sTo8Acc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gYmdzenmsWwGz8XuB1hif9e8sg8AZCRQSsklKDkEG/JALOihiGBG/D4uSNU4YRAgN
	 OtDKS4LkWyIbQBkOafBJoh0hhAlZ+BLJIxlAKwSJFHNWBp/wZmpUlsJ74iJkdZ1DZ9
	 cktRpZmwDV0lllVbhuvX8lZtJA0HAwwwuubeQt9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgJRT40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgJRTTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4242422365;
        Sun, 18 Oct 2020 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048780;
        bh=+Y0a2asrL7jAicrUGmb4DlOlW6Zj6PfPYrl0sTo8Acc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCJWw70SK7lQn74zwJUFfDBMhTegj7Gg+ChqWOgeOItrKgYNlNxWawM+FZJxNSbE3
         nehzfA1I955pTTcEkO46kq1wq2zvano+V/JNDhUR/QLCIcF2elTMGbrNcgODuS/1qT
         SPE/CH/w6h9gzB5cf4hC+Ime+/rKVhWZBB2Rg3QA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
        Arun Easi <aeasi@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 077/111] scsi: qla2xxx: Warn if done() or free() are called on an already freed srb
Date:   Sun, 18 Oct 2020 15:17:33 -0400
Message-Id: <20201018191807.4052726-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c0014f94218ea3a312f6235febea0d626c5f2154 ]

Emit a warning when ->done or ->free are called on an already freed
srb. There is a hidden use-after-free bug in the driver which corrupts
the srb memory pool which originates from the cleanup callbacks.

An extensive search didn't bring any lights on the real problem. The
initial fix was to set both pointers to NULL and try to catch invalid
accesses. But instead the memory corruption was gone and the driver
didn't crash. Since not all calling places check for NULL pointer, add
explicitly default handlers. With this we workaround the memory
corruption and add a debug help.

Link: https://lore.kernel.org/r/20200908081516.8561-2-dwagner@suse.de
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c   | 10 ++++++++++
 drivers/scsi/qla2xxx/qla_inline.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0bd04a62af836..8d4b651e14422 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -63,6 +63,16 @@ void qla2x00_sp_free(srb_t *sp)
 	qla2x00_rel_sp(sp);
 }
 
+void qla2xxx_rel_done_warning(srb_t *sp, int res)
+{
+	WARN_ONCE(1, "Calling done() of an already freed srb %p object\n", sp);
+}
+
+void qla2xxx_rel_free_warning(srb_t *sp)
+{
+	WARN_ONCE(1, "Calling free() of an already freed srb %p object\n", sp);
+}
+
 /* Asynchronous Login/Logout Routines -------------------------------------- */
 
 unsigned long
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 861dc522723ce..2aa6f81f87c43 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -207,10 +207,15 @@ qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
 	return sp;
 }
 
+void qla2xxx_rel_done_warning(srb_t *sp, int res);
+void qla2xxx_rel_free_warning(srb_t *sp);
+
 static inline void
 qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
 {
 	sp->qpair = NULL;
+	sp->done = qla2xxx_rel_done_warning;
+	sp->free = qla2xxx_rel_free_warning;
 	mempool_free(sp, qpair->srb_mempool);
 	QLA_QPAIR_MARK_NOT_BUSY(qpair);
 }
-- 
2.25.1

