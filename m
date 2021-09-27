Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9212DC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DD8610FC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbhI0WlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237501AbhI0WlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 18:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB006103B;
        Mon, 27 Sep 2021 22:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632782384;
        bh=jQsMfUi7sijCHy0O5BfSM8V3P+BdbGszL5QX7pxZXXY=;
        h=Date:From:To:Cc:Subject:From;
        b=DYKF/8qpc/4F6ifKfma2hGmYUvK8dtjn5mwyLzcvwOY72cajp0EDGXKyRFkUgldQr
         8ANrq+f8cWJd3YEkqpS9MlwC0y4a6/z3jFa/igq+ITLSRbeueg0JHjbFxWDyhBbT2h
         zTlM3r5DGSxbZuUmgMIJhZxyKWId0vFPmhYMzANwUWHhwYSGqcMgLe194FSkRxoKFp
         7vACCxL1P1ReQqesKH0ivhPiYkApZ+XVqW/vetmg7AzBY0U3rCuxRSkbnh82slAJiW
         Ran+iHz+qbxFEGLSgCeaO8FryeDJJKI/puwy1vOLQ9g8RJDedASXs8+tXGwAdS01Fn
         30Qfyq2tfRP7A==
Date:   Mon, 27 Sep 2021 17:43:44 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: target: tcmu: Use struct_size() helper in
 kmalloc()
Message-ID: <20210927224344.GA190701@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows
that, in the worst scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/target/target_core_user.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9f552f48084c..dc220fad06fa 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1255,7 +1255,6 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 {
 	int i = 0, cmd_cnt = 0;
 	bool unqueued = false;
-	uint16_t *cmd_ids = NULL;
 	struct tcmu_cmd *cmd;
 	struct se_cmd *se_cmd;
 	struct tcmu_tmr *tmr;
@@ -1292,7 +1291,7 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
 
-	tmr = kmalloc(sizeof(*tmr) + cmd_cnt * sizeof(*cmd_ids), GFP_NOIO);
+	tmr = kmalloc(struct_size(tmr, tmr_cmd_ids, cmd_cnt), GFP_NOIO);
 	if (!tmr)
 		goto unlock;
 
-- 
2.27.0

