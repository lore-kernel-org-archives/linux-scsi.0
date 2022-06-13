Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D4C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 01:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbiFMBnt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 21:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiFMBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 21:43:30 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE1403EE;
        Sun, 12 Jun 2022 18:43:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VG8Kp4F_1655084602;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VG8Kp4F_1655084602)
          by smtp.aliyun-inc.com;
          Mon, 13 Jun 2022 09:43:23 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: target: iscsi: Fix NULL pointer dereference in iscsi_conn_auth_required()
Date:   Mon, 13 Jun 2022 09:43:21 +0800
Message-Id: <20220613014321.107045-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix following coccicheck error:
./drivers/target/iscsi/iscsi_target_nego.c:831:13-26: ERROR: se_nacl is
NULL but dereferenced.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 9ce35a59962b..fb93a1173954 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -827,8 +827,7 @@ static bool iscsi_conn_auth_required(struct iscsit_conn *conn)
 	 */
 	se_nacl = conn->sess->se_sess->se_node_acl;
 	if (!se_nacl) {
-		pr_debug("Unknown ACL %s is trying to connect\n",
-			 se_nacl->initiatorname);
+		pr_debug("Unknown ACL is trying to connect\n");
 		return true;
 	}
 
-- 
2.20.1.7.g153144c

