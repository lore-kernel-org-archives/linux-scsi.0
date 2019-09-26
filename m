Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA0BC432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 07:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F27221A4A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 07:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfIZHqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 03:46:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:39942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfIZHqm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 03:46:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5056FAF38;
        Thu, 26 Sep 2019 07:46:40 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()
Date:   Thu, 26 Sep 2019 09:46:37 +0200
Message-Id: <20190926074637.77721-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not
called from the completion path") introduced the WARN_ON_ONCE in
qla2x00_status_cont_entry(). The assumption was that there is only one
status continuations element. According to the firmware documentation
it is possible that multiple status continuations are emitted by the
firmware.

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4c26630c1c3e..009fd5a33fcd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2837,8 +2837,6 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
 		sp->done(sp, cp->result);
-	} else {
-		WARN_ON_ONCE(true);
 	}
 }
 
-- 
2.16.4

