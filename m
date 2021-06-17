Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8709C49EA2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A5861403
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhFQLp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:45:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44213 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhFQLp4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 07:45:56 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1ltqR2-0002gS-4l; Thu, 17 Jun 2021 11:43:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target/iscsi: remove redundant continue statement
Date:   Thu, 17 Jun 2021 12:43:47 +0100
Message-Id: <20210617114347.10247-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a loop has no effect,
remove it.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index cd670cb9b8fb..0dd52f484fec 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -871,8 +871,6 @@ int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 
 		if (iscsit_execute_cmd(cmd, 1) < 0)
 			return -1;
-
-		continue;
 	}
 
 	return ooo_count;
-- 
2.31.1

