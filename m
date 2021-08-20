Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB4EC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 15:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628546103D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 15:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhHTPTP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 11:19:15 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48014
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234323AbhHTPTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 11:19:15 -0400
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net [80.193.200.194])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F08E73F359;
        Fri, 20 Aug 2021 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629472716;
        bh=2y4JX8nWM9/z4xlhCMBctS5hhey+EW6iTHOPrc38Ugk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=EidheyWAH6xXtFZTJRd3DF6qMtC84raAWLT30+fFGzxv/j4aLR7tIl2TtGW6gQYQ4
         3ssQP5VTIhjfzewzsu2hErFFVOFQfCbHaHlWSQamBpQOPHlqTr814jogdgG958Yft1
         AYUdlENuNgCczIuZE/2tCp4SfUP9tWGd7CgZOdfnZEpg4FdOA37bty4UreNKcpovBD
         t5CGQjN1ur4oEKI0xhH7kZLJEdquSCtlKvw//yH36opl2ac91aPFeqMUXteKvxqWmj
         jHMi1b/XGRSQdHtEHg3dvLA9CErslc6QxzqKtj5fk3qvapnrrh+nM/ty5a826l8dEl
         ajfcU5Mf3rZNQ==
From:   Colin King <colin.king@canonical.com>
To:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: snic: Fix spelling mistake "progres" -> "progress"
Date:   Fri, 20 Aug 2021 16:18:35 +0100
Message-Id: <20210820151835.59804-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a SNIC_HOST_INFO message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/snic/snic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 95740caa1eb0..43a950185e24 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2335,7 +2335,7 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	spin_lock_irqsave(&snic->snic_lock, flags);
 	if (snic_get_state(snic) == SNIC_FWRESET) {
 		spin_unlock_irqrestore(&snic->snic_lock, flags);
-		SNIC_HOST_INFO(shost, "reset:prev reset is in progres\n");
+		SNIC_HOST_INFO(shost, "reset:prev reset is in progress\n");
 
 		msleep(SNIC_HOST_RESET_TIMEOUT);
 		ret = SUCCESS;
-- 
2.32.0

