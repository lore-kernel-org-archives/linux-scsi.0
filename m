Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63A7C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C555420658
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598027134;
	bh=5CE2VeFnJFV+DsK2+ilItzzAgkQ63gk5C0GCI9RpE+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=etOWiSK1rKpGsz4nhzMKv2/eaKD68RRkaONzUMC21GtVjc0nds55eX+hX2lg7vfO9
	 LIk7vgR7gMTF5ivZvMqOw2eWslipZHTFVv7aOZsAerXgksHDScNV2B65qeEm6ZguAM
	 1hgG9FVJ78v0mhl7IRFbreGVp8tfIJc1mp1aKRGQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgHUQYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgHUQVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6FB22DCC;
        Fri, 21 Aug 2020 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026839;
        bh=5CE2VeFnJFV+DsK2+ilItzzAgkQ63gk5C0GCI9RpE+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRHiyHZzfIoed2RBjNRNKjcMcIIEJAmHSRV/wHg45GgIBgzMGlovqaM+xwJhq576H
         dr++7pHbhuDJQVERcvbZhFXf8o7pJwENCnwt8b5/GjtYbAQeqpCaHYCNca6uHTH9XW
         GaBA0htNXhVEKu01xEvtnwoWg1YcAtbRdwK4QyPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/22] scsi: iscsi: Do not put host in iscsi_set_flashnode_param()
Date:   Fri, 21 Aug 2020 12:20:11 -0400
Message-Id: <20200821162014.349506-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 68e12e5f61354eb42cfffbc20a693153fc39738e ]

If scsi_host_lookup() fails we will jump to put_host which may cause a
panic. Jump to exit_set_fnode instead.

Link: https://lore.kernel.org/r/20200615081226.183068-1-jingxiangfeng@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index de10b461ec7ef..4903640316480 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3192,7 +3192,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_set_fnode;
 	}
 
 	idx = ev->u.set_flashnode.flashnode_idx;
-- 
2.25.1

