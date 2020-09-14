Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AEBC2D0A7
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 02:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 686E421897
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 02:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgINCbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 22:31:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgINCbk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Sep 2020 22:31:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 59480422421C14DEE23F;
        Mon, 14 Sep 2020 10:31:38 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 10:31:27 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <martin.petersen@oracle.com>, <bvanassche@acm.org>,
        <michael.christie@oracle.com>, <mlombard@redhat.com>,
        <sudhakar.panneerselvam@oracle.com>, <ddiss@suse.de>,
        <gustavoars@kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: target: remove redundant assignment to variable 'ret'
Date:   Mon, 14 Sep 2020 10:32:07 +0800
Message-ID: <20200914023207.113792-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable ret has been initialized with a value '0'. The assignment
in switch-case is redundant. So remove it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cd045dc75a58..f5272ac18b16 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4516,7 +4516,6 @@ int iscsit_logout_post_handler(
 			iscsit_logout_post_handler_closesession(conn);
 			break;
 		}
-		ret = 0;
 		break;
 	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
 		if (conn->cid == cmd->logout_cid) {
@@ -4527,7 +4526,6 @@ int iscsit_logout_post_handler(
 				iscsit_logout_post_handler_samecid(conn);
 				break;
 			}
-			ret = 0;
 		} else {
 			switch (cmd->logout_response) {
 			case ISCSI_LOGOUT_SUCCESS:
-- 
2.17.1

