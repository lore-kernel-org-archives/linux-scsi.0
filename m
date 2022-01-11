Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1ADC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jan 2022 05:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiAKFyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jan 2022 00:54:54 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:23714 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiAKFyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2022 00:54:53 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 00:54:52 EST
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id A0537C02C0;
        Tue, 11 Jan 2022 13:48:04 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH] target: make sure the np under each tpg is unique
Date:   Tue, 11 Jan 2022 13:47:42 +0800
Message-Id: <20220111054742.19582-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRlKS09WTkMYSExPSEJPTk
        5IVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBg6Vgw4QzIwLz85SEstKygq
        PgwaCVZVSlVKTU9KQ0NLS0NOSk1IVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSk1OTTcG
X-HM-Tid: 0a7e47ade1b1841ekuqwa0537c02c0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

iscsit_tpg_check_network_portal() has two-layer for loop, and
should return true When a match is found. Then, the tpg loop
will still continue after break the tpg_np loop. If this tpg_np
is not the last, the match value will be changed.

This patch break all loops after finding a match, and make sure
the np under each tpg is unique.

Signed-off-by: ZouMingzhe <mingzhe.zou@easystack.cn>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 8075f60fd02c..2d5cf1714ae0 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -443,6 +443,9 @@ static bool iscsit_tpg_check_network_portal(
 				break;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
+
+		if (match)
+			break;
 	}
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-- 
2.17.1

