Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCC7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jan 2022 05:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347323AbiAKFyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jan 2022 00:54:54 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:23724 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiAKFyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2022 00:54:53 -0500
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 10C0EC00D6;
        Tue, 11 Jan 2022 13:45:49 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] target: make sure the np under each tpg is unique
Date:   Tue, 11 Jan 2022 13:45:48 +0800
Message-Id: <20220111054548.19479-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUNPHhhWQk9JHRlMSB8ZHk
        MfVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PEk6TSo4NjIyDT8SMQwPKEw*
        VjoKFAtVSlVKTU9KQ0xCQk9CT01NVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSk5MTTcG
X-HM-Tid: 0a7e47abcf86841ekuqw10c0ec00d6
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

