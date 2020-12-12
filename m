Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66084C1B0D9
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 16:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 268F9207B6
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 16:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439453AbgLLQKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439443AbgLLQKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:21 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 16/23] scsi: mpt3sas: Increase IOCInit request timeout to 30s
Date:   Sat, 12 Dec 2020 11:07:57 -0500
Message-Id: <20201212160804.2334982-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 85dad327d9b58b4c9ce08189a2707167de392d23 ]

Currently the IOCInit request message timeout is set to 10s. This is not
sufficient in some scenarios such as during HBA FW downgrade operations.

Increase the IOCInit request timeout to 30s.

Link: https://lore.kernel.org/r/20201130082733.26120-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 87d05c1950870..d62c1aaf53fbd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6441,7 +6441,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
 		ioc_err(ioc, "%s: handshake failed (r=%d)\n", __func__, r);
-- 
2.27.0

