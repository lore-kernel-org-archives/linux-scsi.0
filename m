Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CF2C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 03:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C825B2312B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 03:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbhATC2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 21:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbhATB2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19C323139;
        Wed, 20 Jan 2021 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105978;
        bh=AZGLt3KmKZrVdXCGw2heQIM/ihKzET7N54NragBTGrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvRyVqV+RHZR0oFtnPexeGLb5Ijbz7YsSlsS8yh0DQHoKDLEN+W6dOQ/UoYpdQ9qR
         N1i5vkagv+eO5IqSoTG98xX2Jqs2kgZKKpNDhRLKOEoiBuN11G3fgA/MGD8DFyrbue
         LBOQcN7wUtDd3TKe20OKR/RJep7e3qTRstE1u5I0abpocGLA1VPGickIRj+icWlbMt
         GvZl/QJLGw4URE6AQchrlHnQL++E0NOLkxRwdt6LBSfxpz302m5UyXQxC3zcvcqRuF
         AwisvN3cDOwlwIFddXQQTB5DxsyYpFHffA3LEWuqHzje3sS1CGHGqHelnEajKXwNXU
         YXIHJsA/7VduA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/45] scsi: scsi_debug: Fix memleak in scsi_debug_init()
Date:   Tue, 19 Jan 2021 20:25:29 -0500
Message-Id: <20210120012602.769683-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 3b01d7ea4dae907d34fa0eeb3f17bacd714c6d0c ]

When sdeb_zbc_model does not match BLK_ZONED_NONE, BLK_ZONED_HA or
BLK_ZONED_HM, we should free sdebug_q_arr to prevent memleak. Also there is
no need to execute sdebug_erase_store() on failure of sdeb_zbc_model_str().

Link: https://lore.kernel.org/r/20201226061503.20050-1-dinghao.liu@zju.edu.cn
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24c0f7ec03511..4a08c450b756f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6740,7 +6740,7 @@ static int __init scsi_debug_init(void)
 		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
 		if (k < 0) {
 			ret = k;
-			goto free_vm;
+			goto free_q_arr;
 		}
 		sdeb_zbc_model = k;
 		switch (sdeb_zbc_model) {
@@ -6753,7 +6753,8 @@ static int __init scsi_debug_init(void)
 			break;
 		default:
 			pr_err("Invalid ZBC model\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_q_arr;
 		}
 	}
 	if (sdeb_zbc_model != BLK_ZONED_NONE) {
-- 
2.27.0

