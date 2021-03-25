Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C38C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2988B61A23
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCYLdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 07:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhCYLb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 07:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE6F61A73;
        Thu, 25 Mar 2021 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671686;
        bh=nXoYognAgYL6klut8TMdNteBomnnKW3sKoRjwvaPPMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/BPTOPPKMla7f6lq3dGbI5XqJyPqe+TZ7CW1u8G2nlOBJyYEaH7WQRI4mP4sPT9f
         /eqcLclLXFhIk/Eo3CzzWdj6G2EWctU4j4t7fwiThi0X9/Pe9SDngNMxP8GKpvlevM
         ZDFvaEpJH0yfxwzMFUJpL9xLkldq0n2imfQWNYnUUtGrl2J9mpM4cJfoS9u1eEwdzm
         gafVGh1lqXDGN4SCbbjZYN9HBTUYK3sRVsUAq/eORObF9zUt3ztwzBJQ+TckYcVu1Q
         c79l2Hb49UZJTxhuecFcBXTTAnL+faf5ojrOvRIP86PT0gdX1h+uKgcNikPtUtERaT
         Sb8wdsqB4Obiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/16] scsi: st: Fix a use after free in st_open()
Date:   Thu, 25 Mar 2021 07:27:46 -0400
Message-Id: <20210325112751.1928421-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112751.1928421-1-sashal@kernel.org>
References: <20210325112751.1928421-1-sashal@kernel.org>
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
index 94e402ed30f6..6497a6f12a6f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1268,8 +1268,8 @@ static int st_open(struct inode *inode, struct file *filp)
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

