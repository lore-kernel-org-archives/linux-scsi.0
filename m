Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C0ECA9EB9
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 06:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882F120650
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 06:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbfJ2GQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:16:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5217 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727462AbfJ2GQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Oct 2019 02:16:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8A773CB0422BA7F5CC34;
        Tue, 29 Oct 2019 14:15:57 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Tue, 29 Oct 2019 14:15:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] scsi: csiostor: Remove set but not used variable 'rln'
Date:   Tue, 29 Oct 2019 06:15:30 +0000
Message-ID: <20191029061530.98197-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/csiostor/csio_lnode.c: In function 'csio_ln_init':
drivers/scsi/csiostor/csio_lnode.c:1995:21: warning:
 variable 'rln' set but not used [-Wunused-but-set-variable]

It is never used since introduction, so remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 23cbe4cda760..74ff8adc41f7 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -1992,7 +1992,7 @@ static int
 csio_ln_init(struct csio_lnode *ln)
 {
 	int rv = -EINVAL;
-	struct csio_lnode *rln, *pln;
+	struct csio_lnode *pln;
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 
 	csio_init_state(&ln->sm, csio_lns_uninit);
@@ -2022,7 +2022,6 @@ csio_ln_init(struct csio_lnode *ln)
 		 * THe rest is common for non-root physical and NPIV lnodes.
 		 * Just get references to all other modules
 		 */
-		rln = csio_root_lnode(ln);
 
 		if (csio_is_npiv_ln(ln)) {
 			/* NPIV */



