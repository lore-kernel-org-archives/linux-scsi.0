Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D01C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB3620678
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgIHIPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 04:15:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:37128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgIHIPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 04:15:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B48DB691;
        Tue,  8 Sep 2020 08:15:24 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v3 2/4] qla2xxx: Simplify return value logic in qla2x00_get_sp_from_handle()
Date:   Tue,  8 Sep 2020 10:15:14 +0200
Message-Id: <20200908081516.8561-3-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200908081516.8561-1-dwagner@suse.de>
References: <20200908081516.8561-1-dwagner@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Refactor qla2x00_get_sp_from_handle() to avoid the unecessary
goto if early returns are used. With this we can also avoid
preinitilzing the sp pointer.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 27bcd346af7c..5d278155e4e7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1716,7 +1716,7 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 {
 	struct qla_hw_data *ha = vha->hw;
 	sts_entry_t *pkt = iocb;
-	srb_t *sp = NULL;
+	srb_t *sp;
 	uint16_t index;
 
 	index = LSW(pkt->handle);
@@ -1728,13 +1728,13 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		goto done;
+		return NULL;
 	}
 	sp = req->outstanding_cmds[index];
 	if (!sp) {
 		ql_log(ql_log_warn, vha, 0x5032,
 		    "Invalid completion handle (%x) -- timed-out.\n", index);
-		return sp;
+		return NULL;
 	}
 	if (sp->handle != index) {
 		ql_log(ql_log_warn, vha, 0x5033,
@@ -1743,8 +1743,6 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	}
 
 	req->outstanding_cmds[index] = NULL;
-
-done:
 	return sp;
 }
 
-- 
2.16.4

