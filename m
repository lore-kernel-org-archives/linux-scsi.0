Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF153C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 07:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEBA020872
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 07:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfI0Haf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 03:30:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:53104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfI0Haf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Sep 2019 03:30:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9963B5FE;
        Fri, 27 Sep 2019 07:30:33 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2] scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()
Date:   Fri, 27 Sep 2019 09:30:31 +0200
Message-Id: <20190927073031.62296-1-dwagner@suse.de>
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

Fixes: 88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not
called from the completion path")
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---

changes v2:
 - add Fixes and Reviewed-by tags

 drivers/scsi/qla2xxx/qla_isr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 30fd2d355f3a..acef3d73983c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2858,8 +2858,6 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
 		sp->done(sp, cp->result);
-	} else {
-		WARN_ON_ONCE(true);
 	}
 }
 
-- 
2.16.4

