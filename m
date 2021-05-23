Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396F3C47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1868B611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhEWLD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 07:03:57 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:36285 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhEWLD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 07:03:56 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d83 with ME
        id 8B2V2500121Fzsu03B2VuF; Sun, 23 May 2021 13:02:29 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 May 2021 13:02:29 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chad.dupuis@cavium.com,
        arun.easi@cavium.com, nilesh.javali@cavium.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] scsi: qedf: Fix an error handling path in 'qedf_alloc_global_queues()'
Date:   Sun, 23 May 2021 13:02:29 +0200
Message-Id: <4c9c67bcad414c1128d26fceb9d6b579cb39cdc9.1621765056.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
References: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If 'qedf_alloc_bdq()' fails, 'status' is known to be 0, so we report
success to the caller.

In fact going to 'mem_alloc_failure' is pointless here, because we try to
free some resources that have not been allocated yet.
This is however harmless because 'qedf_free_global_queues()' is robust
enough.

So make a direct return instead, as already done just a few lines above.

While at it, also do a direct return if '!qedf->p_cpuq'. Going to
'mem_alloc_failure' is also pointless here and mixing goto and direct
return is spurious. So make it clear that nothing has to be undone.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedf/qedf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7368a40ba649..ff3a1b183a7c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3022,9 +3022,8 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 * addresses of our queues
 	 */
 	if (!qedf->p_cpuq) {
-		status = 1;
 		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
-		goto mem_alloc_failure;
+		return 1;
 	}
 
 	qedf->global_queues = kzalloc((sizeof(struct global_queue *)
@@ -3041,7 +3040,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	rc = qedf_alloc_bdq(qedf);
 	if (rc) {
 		QEDF_ERR(&qedf->dbg_ctx, "Unable to allocate bdq.\n");
-		goto mem_alloc_failure;
+		return -ENOMEM;
 	}
 
 	/* Allocate a CQ and an associated PBL for each MSI-X vector */
-- 
2.30.2

