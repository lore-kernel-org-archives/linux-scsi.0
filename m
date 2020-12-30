Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2350DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 08:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E239621919
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 08:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgL3ISh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 03:18:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9703 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgL3ISg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 03:18:36 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D5PJg4rVszky3c;
        Wed, 30 Dec 2020 16:16:51 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 30 Dec 2020 16:17:47 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <skashyap@marvell.com>, <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] scsi: qedf: Use kzalloc for allocating only one thing
Date:   Wed, 30 Dec 2020 16:18:26 +0800
Message-ID: <20201230081826.460-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 46d185cb9ea8..3713d3c386a0 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2752,7 +2752,7 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 	for (id = 0; id < qedf->num_queues; id++) {
 		fp = &(qedf->fp_array[id]);
 		fp->sb_id = QEDF_SB_ID_NULL;
-		fp->sb_info = kcalloc(1, sizeof(*fp->sb_info), GFP_KERNEL);
+		fp->sb_info = kzalloc(sizeof(*fp->sb_info), GFP_KERNEL);
 		if (!fp->sb_info) {
 			QEDF_ERR(&(qedf->dbg_ctx), "SB info struct "
 				  "allocation failed.\n");
-- 
2.22.0

