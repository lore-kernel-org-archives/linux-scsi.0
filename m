Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68EDC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25F020678
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgIHIPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 04:15:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:37140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbgIHIPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 04:15:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D708B6CD;
        Tue,  8 Sep 2020 08:15:24 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v3 3/4] qla2xxx: Log calling function name in qla2x00_get_sp_from_handle()
Date:   Tue,  8 Sep 2020 10:15:15 +0200
Message-Id: <20200908081516.8561-4-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200908081516.8561-1-dwagner@suse.de>
References: <20200908081516.8561-1-dwagner@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 7c3df1320e5e ("[SCSI] qla2xxx: Code changes to support new
dynamic logging infrastructure.") removed the use of the func
argument. Let's add it back.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d278155e4e7..b0b6dd2b608d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1722,8 +1722,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
 		ql_log(ql_log_warn, vha, 0x5031,
-			   "Invalid command index (%x) type %8ph.\n",
-			   index, iocb);
+			   "%s: Invalid command index (%x) type %8ph.\n",
+			   func, index, iocb);
 		if (IS_P3P_TYPE(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
@@ -1733,12 +1733,14 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	sp = req->outstanding_cmds[index];
 	if (!sp) {
 		ql_log(ql_log_warn, vha, 0x5032,
-		    "Invalid completion handle (%x) -- timed-out.\n", index);
+			"%s: Invalid completion handle (%x) -- timed-out.\n",
+			func, index);
 		return NULL;
 	}
 	if (sp->handle != index) {
 		ql_log(ql_log_warn, vha, 0x5033,
-		    "SRB handle (%x) mismatch %x.\n", sp->handle, index);
+			"%s: SRB handle (%x) mismatch %x.\n", func,
+			sp->handle, index);
 		return NULL;
 	}
 
-- 
2.16.4

