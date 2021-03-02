Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1D8C4332D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB80560201
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835231AbhCBSvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446886AbhCBMNu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Mar 2021 07:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B82C164F74;
        Tue,  2 Mar 2021 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686264;
        bh=fgO6rlGEA85f12uoYpym1dOfKQoHAyJO7jnjAJHEIW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+aMN4AkdIgYE5aFLGfNd57gTy5pd30J9nGnWSnuDjcJCSzdMIsOfe9Zt7zDou9Mo
         JAC6c9mkyck6WBS/m/n1rxsC05YhW6jd+gYsrDZqCrEWusx78Xc9/kOCDk8lmLJ/Xv
         NyWPd13Wq5NV9qp24w1HDa9kcVRPBG2+DQzxtjMmzF3cbBsh48UQULYD80Is3kGT7D
         2zc5pjxCW11fjPf/Qzh/J3QpPY0P/kHKxBVdXaD4AeeaHNk5iEHs4gbMn3ygxK2iHY
         GyoYR5P5aeFq5+g/88uzQupxIHHiYNvBjaoecpRR+ElLHVMJlOk/evkgIVFN/V4IzU
         diXbL9p/DiKYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 44/47] scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling
Date:   Tue,  2 Mar 2021 06:56:43 -0500
Message-Id: <20210302115646.62291-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit d28d48c699779973ab9a3bd0e5acfa112bd4fdef ]

If iscsi_prep_scsi_cmd_pdu() fails we try to add it back to the cmdqueue,
but we leave it partially setup. We don't have functions that can undo the
pdu and init task setup. We only have cleanup_task which can clean up both
parts. So this has us just fail the cmd and go through the standard cleanup
routine and then have the SCSI midlayer retry it like is done when it fails
in the queuecommand path.

Link: https://lore.kernel.org/r/20210207044608.27585-2-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9314f1393fb..ee0786bab4fc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1532,14 +1532,9 @@ check_mgmt:
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
-			if (rc == -ENOMEM || rc == -EACCES) {
-				spin_lock_bh(&conn->taskqueuelock);
-				list_add_tail(&conn->task->running,
-					      &conn->cmdqueue);
-				conn->task = NULL;
-				spin_unlock_bh(&conn->taskqueuelock);
-				goto done;
-			} else
+			if (rc == -ENOMEM || rc == -EACCES)
+				fail_scsi_task(conn->task, DID_IMM_RETRY);
+			else
 				fail_scsi_task(conn->task, DID_ABORT);
 			spin_lock_bh(&conn->taskqueuelock);
 			continue;
-- 
2.30.1

