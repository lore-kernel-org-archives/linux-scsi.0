Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC257C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEFF22CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391014AbfHWNtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:49:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37056 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390369AbfHWNtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 09:49:50 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 19755288BC86CF44D9B2;
        Fri, 23 Aug 2019 21:49:41 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 21:49:33 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/2] scsi: csiostor: remove set but not used variable 'rln'
Date:   Fri, 23 Aug 2019 21:56:04 +0800
Message-ID: <1566568564-55636-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566568564-55636-1-git-send-email-zhengbin13@huawei.com>
References: <1566568564-55636-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/csiostor/csio_lnode.c: In function csio_ln_init:
drivers/scsi/csiostor/csio_lnode.c:1992:21: warning: variable rln set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 66e58f0..7d18e99 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -1989,7 +1989,7 @@ static int
 csio_ln_init(struct csio_lnode *ln)
 {
 	int rv = -EINVAL;
-	struct csio_lnode *rln, *pln;
+	struct csio_lnode *pln;
 	struct csio_hw *hw = csio_lnode_to_hw(ln);

 	csio_init_state(&ln->sm, csio_lns_uninit);
@@ -2019,7 +2019,6 @@ csio_ln_init(struct csio_lnode *ln)
 		 * THe rest is common for non-root physical and NPIV lnodes.
 		 * Just get references to all other modules
 		 */
-		rln = csio_root_lnode(ln);

 		if (csio_is_npiv_ln(ln)) {
 			/* NPIV */
--
2.7.4

