Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06512C41535
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 18:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E67611AF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 18:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353386AbhITSgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 14:36:07 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:58342
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352878AbhITSdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 14:33:36 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 230D040D43;
        Mon, 20 Sep 2021 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632162727;
        bh=rzsf7Jp4zHlHmSebOdtNBwl34AtYTI7DgNFSHbuOgVM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Qb8fYSlJ8nKGhRjg6/JFOAyLW8c2X/N7QD5K6NAHoo1fYZhPnH+yStMXyTq1detjR
         Ta5MLirQWbq9wT72eIZGXws+njLXTjI7AnGZ2wXFziTfsa0fcmZWXBMTwZ8G0pPxq6
         LKgTNhF0jndI0xjC2yAVmz4JQIim/Y/GzYwF4H05FbcBH7xwxe2QYq28hI06+qa8vW
         JtB7nt6ev9izRImzmjxyv+S0R8t9enTB3OgOj3Tws1YGoucISkjncx4U0sC/c9AgiK
         kVYa7tU+pLvKtLEdZxpi7Rgx3VtI8q0KwsGpWRueYisin86kBG9Xsc2ErM2mvntopA
         uM4za9dDg4syw==
From:   Colin King <colin.king@canonical.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: Fix spelling mistake "CONFLIFT" -> "CONFLICT"
Date:   Mon, 20 Sep 2021 19:32:06 +0100
Message-Id: <20210920183206.17477-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4b94b085625b..3829b61b56c1 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -269,7 +269,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->reservation_holder &&
 	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
-		pr_err("SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
+		pr_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
 			tpg->se_tpg_tfo->fabric_name);
 		pr_err("Original reserver LUN: %llu %s\n",
 			cmd->se_lun->unpacked_lun,
-- 
2.32.0

