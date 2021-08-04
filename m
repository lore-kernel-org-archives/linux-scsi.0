Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076BEC4320A
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C9560F43
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhHDNc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:32:56 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:54146
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237941AbhHDNcz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 09:32:55 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id AF01A3F04C;
        Wed,  4 Aug 2021 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628083961;
        bh=sFRnlrCxX4UfbV0wRKIURUJvUdmMhm6lKn2cYdUX8LI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=wLuaugkFgbJ2PegPAOA1YAQW3RXBSRnIBRsjNG5RN5mDOjZ/yj1gSBGYTqh8G2z9s
         m3RbPWgoNGwZImFRismYTa3B5Yxn/YJ3ue7MbrMXxk6kBrJo0AvUKz5sRBQFCreMWZ
         r/O4j16cMMyMozxLqFSWW32TArl3AdfJxmczKAZDfqAqyBHmtZLrYz1RQtIqImWykJ
         LbOpWaQQGgxHD3P9qOQuJCNY0Uv8K0ME5yK+0rhBCI+RvQZaKDFY744SIz3zKk3EQz
         vH7WtqtJ7r3PItpNAurcGE8ZMDHe8VphG+DoIliIy5MA51uV70I5/926ZtPId9iwjP
         KroMCOzF078eQ==
From:   Colin King <colin.king@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshpb: Remove redundant initialization of variable lba
Date:   Wed,  4 Aug 2021 14:32:41 +0100
Message-Id: <20210804133241.113509-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable lba is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 40d371f6e147..e3cd033b6885 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -371,7 +371,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	u64 lba = -1;
+	u64 lba;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
-- 
2.31.1

