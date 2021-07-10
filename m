Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549FBC11F6D
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 02:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43853613D1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 02:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhGJC0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 22:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhGJCZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0039661416;
        Sat, 10 Jul 2021 02:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883773;
        bh=5uGHoFbxC057inXKnuUYBivDyaNYMVwoUbIjXcXUV6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkBLE7WLJs+vbilk2T+xFlg24mVxG0MD4pF9bU3374SwYbtyIwH26uCcJTTEcwxWG
         5kcM96F5IlkFrL5TZcOhUdu2oe5eYqWYC/5kXcEE7wZapfFoqs8pJmvZSjmESklbVm
         YZbld5Trm9lqXXKg385L9ZFPnBilLhy0czcTaiF3VUToEhZPf96JdBmHQTqevp2jzC
         bLKRlNvn0PlXwQFnBsT8/q08Uh5nm0dRfQxxkWGof/3EMKqua+3J6OyGAzQrR/H6Sn
         OAagx8NTueNEXAyOI4sl95r0UP6Q0H4uI0rrErOEQ4gl3VLk6AcPOq1Yj9zCq1PVta
         Dc4VE/RAB4cFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 043/104] scsi: qedi: Fix null ref during abort handling
Date:   Fri,  9 Jul 2021 22:20:55 -0400
Message-Id: <20210710022156.3168825-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5777b7f0f03ce49372203b6521631f62f2810c8f ]

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Link: https://lore.kernel.org/r/20210525181821.7617-20-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.30.2

