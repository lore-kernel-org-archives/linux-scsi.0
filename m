Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E600C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 22:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11865223E4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 22:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgLCWcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgLCWcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 17:32:23 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Date:   Thu,  3 Dec 2020 23:31:26 +0100
Message-Id: <20201203223137.1205933-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang complains about a possible code path in which a variable is
used without an initialization:

drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
                BUG_ON(1);
                ^~~~~~~~~
include/asm-generic/bug.h:63:36: note: expanded from macro 'BUG_ON'
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
                                   ^~~~~~~~~~~~~~~~~~~

Turn the BUG_ON(1) into an unconditional BUG() that makes it clear
to clang that this code path is never hit.

Fixes: 4f3e900b6282 ("scsi: ufs: Clear UAC for FFU and RPMB LUNs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f165baee937f..b4f7c4263334 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7687,7 +7687,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	else if (wlun == UFS_UPIU_RPMB_WLUN)
 		sdp = hba->sdev_rpmb;
 	else
-		BUG_ON(1);
+		BUG();
 	if (sdp) {
 		ret = scsi_device_get(sdp);
 		if (!ret && !scsi_device_online(sdp)) {
-- 
2.27.0

