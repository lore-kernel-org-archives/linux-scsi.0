Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85953C47E48
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 19:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 721D960240
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 19:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbhGNT5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 15:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241125AbhGNTw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Jul 2021 15:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C4261412;
        Wed, 14 Jul 2021 19:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292126;
        bh=EOn9u7CR6/zKn+iKpJ5wP4mwdhdoEP+PkurRyOi8y00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpiYSKLtz60+k0nuV34sK+KqUhgF+hE6ru8PafTBY84OqMV29QjcUp41UImhreH70
         N4ef8rMLKzUt0bdKzZxcsCyEXa4vmF2oSpo+JNM/BVAie92vUMw9FCMnKcAXGE0D+M
         Z8EisE9PMpta7ZoYIgszL5C+nejtuufVhc5StlGphW1ZUl/CTCfjzR6gh4kAxee1BV
         NV0xZA3nNRS3RnpuwosYgIscjlCGT1OXno/5skJcwsJ01K9OM25CDr+ji570VKiO24
         Z/v2OiWWkwGcp7EPP/wqwq91YAIyGxxgXS8YcXVOJ+Bo8uEHdj81xhjEOhi/tYV0nf
         5ueHGBxMsdTXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/10] scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
Date:   Wed, 14 Jul 2021 15:48:32 -0400
Message-Id: <20210714194833.56197-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194833.56197-1-sashal@kernel.org>
References: <20210714194833.56197-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 332a9dd1d86f1e7203fc7f0fd7e82f0b304200fe ]

The shifting of the u8 integer returned fom ahc_inb(ahc, port+3) by 24 bits
to the left will be promoted to a 32 bit signed int and then sign-extended
to a u64. In the event that the top bit of the u8 is set then all then all
the upper 32 bits of the u64 end up as also being set because of the
sign-extension. Fix this by casting the u8 values to a u64 before the 24
bit left shift.

[ This dates back to 2002, I found the offending commit from the git
history git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git,
commit f58eb66c0b0a ("Update aic7xxx driver to 6.2.10...") ]

Link: https://lore.kernel.org/r/20210621151727.20667-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Addresses-Coverity: ("Unintended sign extension")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index def3208dd290..9b5832b46dec 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -500,7 +500,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
 	return ((ahc_inb(ahc, port))
 	      | (ahc_inb(ahc, port+1) << 8)
 	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
+	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
 	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
 	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
 	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
-- 
2.30.2

