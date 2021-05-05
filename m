Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F37AC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794D061182
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhEETCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 15:02:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35565 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbhEETCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 15:02:07 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1leMlc-0007o1-Hf; Wed, 05 May 2021 19:01:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-exynos: make a const array static, makes object smaller
Date:   Wed,  5 May 2021 20:01:04 +0100
Message-Id: <20210505190104.70112-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array granularity_tbl on the stack but instead it
static. Makes the object code smaller by 190 bytes:

Before:
   text    data     bss     dec     hex filename
  25563    6908       0   32471    7ed7 ./drivers/scsi/ufs/ufs-exynos.o

After:
   text    data     bss     dec     hex filename
  25213    7068       0   32281    7e19 ./drivers/scsi/ufs/ufs-exynos.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 70647eacf195..f2f342d496c7 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1048,7 +1048,7 @@ static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, u8 enter)
 		exynos_ufs_ungate_clks(ufs);
 
 		if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) {
-			const unsigned int granularity_tbl[] = {
+			static const unsigned int granularity_tbl[] = {
 				1, 4, 8, 16, 32, 100
 			};
 			int h8_time = attr->pa_hibern8time *
-- 
2.30.2

