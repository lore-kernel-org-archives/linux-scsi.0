Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFF2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A854061A30
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhCYLgD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 07:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhCYLdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 07:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BA061A90;
        Thu, 25 Mar 2021 11:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671720;
        bh=kPHWAkUxrG8FymUtRS+p4OnqtwHyUCmrfDk9wyyS04Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMXrhOLTEQuzUiyQyAGRmmALsADrnfr58iIKwZ+vqU/bHQpzhVKLiXYlUf/Bxg379
         nM2oIm/8zu8a/MH/REsQS5EpxaR0Y5vAPjw1+596gCet4DSRXdYgc3V/GcxYTyhHGU
         H3qIm8URRk9GGvZSU3EFg33GYC+VeNrhw4pc5j5PzUaLLQVOKcqxpLhb7uhOSjgCrb
         rAVObXdpwI9Fl6DsNiU9nr4s1JZSOcXUrycSXJCwAlIpT2GSy63PESLKWED0GwTihF
         yQLTVIJRn0oNtFwBi5AwhrohszXXC0HslhYQBN3LrjAxEuy0lB6ZoWsq0kcI9CSeD9
         FjZDc63YtQ1sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/10] scsi: st: Fix a use after free in st_open()
Date:   Thu, 25 Mar 2021 07:28:27 -0400
Message-Id: <20210325112832.1928898-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112832.1928898-1-sashal@kernel.org>
References: <20210325112832.1928898-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit c8c165dea4c8f5ad67b1240861e4f6c5395fa4ac ]

In st_open(), if STp->in_use is true, STp will be freed by
scsi_tape_put(). However, STp is still used by DEBC_printk() after. It is
better to DEBC_printk() before scsi_tape_put().

Link: https://lore.kernel.org/r/20210311064636.10522-1-lyl2019@mail.ustc.edu.cn
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 088a68ab4246..3a3876091a9d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1267,8 +1267,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	spin_lock(&st_use_lock);
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
-		scsi_tape_put(STp);
 		DEBC_printk(STp, "Device already in use.\n");
+		scsi_tape_put(STp);
 		return (-EBUSY);
 	}
 
-- 
2.30.1

