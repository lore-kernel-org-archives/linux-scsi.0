Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3C0C7EE22
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 19:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjEDT4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 15:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjEDTzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 15:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293C41CFEB;
        Thu,  4 May 2023 12:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E03863802;
        Thu,  4 May 2023 19:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEC3C433EF;
        Thu,  4 May 2023 19:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683229737;
        bh=sxrXFG9zskyTrjrIVOYCIzQ7hBRzHxYT6ADBMRecYQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo39o4u+LAHjnXR2id9fNBCkbVBUWBu3IekohGEoBjFmZYqGn7w2cmKC/NZ2pw3ZM
         WL7tfQGNOr8XzrXvpFIiuwaRwO6pXAIT+CJLtRL5rVTguVcj8vkFF1GqEoCzjSZp+o
         5p9rAYFHh7ZoQ2Wzx8nhEEtF/QLgtjvo+MIMe5cv//FYGLCQuf5P6udkDFm1XrSWnT
         EdVbvnOzPQI4wWi6J91mo3Kr5abxPkC6XoU8RLKyD7vhWcqUXyKlLHrZQVRXE86F6X
         chpRAWAN7WuZOSqkjExkQfQSP10QQK4wHH42g6SJN+gyPsZ+HNFXlxgtbmGl1q+goV
         I+eAqF9gg/yAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/30] scsi: message: mptlan: Fix use after free bug in mptlan_remove() due to race condition
Date:   Thu,  4 May 2023 15:48:05 -0400
Message-Id: <20230504194824.3808028-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194824.3808028-1-sashal@kernel.org>
References: <20230504194824.3808028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit f486893288f3e9b171b836f43853a6426515d800 ]

mptlan_probe() calls mpt_register_lan_device() which initializes the
&priv->post_buckets_task workqueue. A call to
mpt_lan_wake_post_buckets_task() will subsequently start the work.

During driver unload in mptlan_remove() the following race may occur:

CPU0                  CPU1

                    |mpt_lan_post_receive_buckets_work()
mptlan_remove()     |
  free_netdev()     |
    kfree(dev);     |
                    |
                    | dev->mtu
                    |   //use

Fix this by finishing the work prior to cleaning up in mptlan_remove().

[mkp: we really should remove mptlan instead of attempting to fix it]

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Link: https://lore.kernel.org/r/20230318081635.796479-1-zyytlz.wz@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 3261cac762def..ec3ee356078db 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1427,7 +1427,9 @@ mptlan_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct net_device	*dev = ioc->netdev;
+	struct mpt_lan_priv *priv = netdev_priv(dev);
 
+	cancel_delayed_work_sync(&priv->post_buckets_task);
 	if(dev != NULL) {
 		unregister_netdev(dev);
 		free_netdev(dev);
-- 
2.39.2

