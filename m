Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE67C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FBD207DE
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050401;
	bh=rv4AEcROxj8BAs2llGk0xVhlp4UVGLDxwUVC5kEsDUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LNHMstosYktIZkpEbNLoJDvPRSVc/0DR9Uxn8VXfdM4pBHYU7W55VFfYWNd2kCkn6
	 HOvO1iCkSYzFLrrG6LXvUK7QPSUtpEpppRlCQUH189Lym2NvIYJs66/DM4XESybajy
	 zzMkNPLTJKQT64SoAHbfuds23jY61IePhf1dP4O0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733074AbgJRTqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbgJRTXO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D650D20791;
        Sun, 18 Oct 2020 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048994;
        bh=rv4AEcROxj8BAs2llGk0xVhlp4UVGLDxwUVC5kEsDUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTyS6Inbarx26+Aynm0AbfALhy8kU+z+IQBSfHykuIfREaLaJ7mDriwBtRbCDzG8p
         hOO6/c165RHvmLAPaSXyQW59LRfm8IYOlz2Q5ZE730olif4qv4QBJQPtWn2dwcYhT5
         2xICIg2/IRBvPmnety+o6CRsTEpTJuPjiAoxRS9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/80] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Sun, 18 Oct 2020 15:21:43 -0400
Message-Id: <20201018192231.4054535-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 055f15ab2cb4a5cbc4c0a775ef3d0066e0fa9b34 ]

Return PTR_ERR() from the error handling case instead of 0.

Link: https://lore.kernel.org/r/20200910123848.93649-1-jingxiangfeng@huawei.com
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvumi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c43..0354898d7cac1 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2425,6 +2425,7 @@ static int mvumi_io_attach(struct mvumi_hba *mhba)
 	if (IS_ERR(mhba->dm_thread)) {
 		dev_err(&mhba->pdev->dev,
 			"failed to create device scan thread\n");
+		ret = PTR_ERR(mhba->dm_thread);
 		mutex_unlock(&mhba->sas_discovery_mutex);
 		goto fail_create_thread;
 	}
-- 
2.25.1

