Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF63DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A06261051
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhIJBNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:13:32 -0400
Received: from mail-m17642.qiye.163.com ([59.111.176.42]:15870 "EHLO
        mail-m17642.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhIJBM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 21:12:59 -0400
Received: from localhost.localdomain (unknown [113.116.176.115])
        by mail-m17642.qiye.163.com (Hmail) with ESMTPA id 530C2220112;
        Fri, 10 Sep 2021 09:03:00 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH 2/3] scsi: libiscsi: fix invalid pointer dereference in iscsi_eh_session_reset
Date:   Fri, 10 Sep 2021 09:02:19 +0800
Message-Id: <20210910010220.24073-3-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210910010220.24073-1-dinghui@sangfor.com.cn>
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRpNTh5WQk9OTElCTBkaTE
        JJVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OFE6Hyo5Qj4SLB43PS0fSAMr
        NAIaFAtVSlVKTUhKSUhOTENLQklMVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpNVUpMTVVKSk5ZV1kIAVlBSUhLSjcG
X-HM-Tid: 0a7bcd3aafe2d998kuws530c2220112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

like commit 5db6dd14b313 ("scsi: libiscsi: Fix NULL pointer dereference in
iscsi_eh_session_reset"), access conn->persistent_address here is not safe
too.

The persistent_address is independent of conn refcount, so maybe
already freed by iscsi_conn_teardown(), also we put the refcount of conn
above, the conn pointer may be invalid.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 712a45368385..69b3b2148328 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2531,8 +2531,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN) {
 		ISCSI_DBG_EH(session,
-			     "session reset succeeded for %s,%s\n",
-			     session->targetname, conn->persistent_address);
+			     "session reset succeeded for %s\n",
+			     session->targetname);
 	} else
 		goto failed;
 	spin_unlock_bh(&session->frwd_lock);
-- 
2.17.1

