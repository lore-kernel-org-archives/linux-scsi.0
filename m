Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FE5C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF25F206C0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBGR0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:17:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10753 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgIBGR0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 02:17:26 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0B82DEA5C11E8D626663;
        Wed,  2 Sep 2020 14:17:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 14:17:13 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <willy@infradead.org>, <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: sym53c8xx_2: Delete useless if-else in sym_xerr_cam_status
Date:   Wed, 2 Sep 2020 14:16:46 +0800
Message-ID: <20200902061646.576966-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only (x_status & XE_PARITY_ERR) is true we set cam_status = DID_PARITY,
other condition we set cam_status = DID_ERROR. So delete useless if-else.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 28edb6e53ea2..d9a045f9858c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -156,12 +156,8 @@ void sym_xpt_async_bus_reset(struct sym_hcb *np)
 static int sym_xerr_cam_status(int cam_status, int x_status)
 {
 	if (x_status) {
-		if	(x_status & XE_PARITY_ERR)
+		if (x_status & XE_PARITY_ERR)
 			cam_status = DID_PARITY;
-		else if	(x_status &(XE_EXTRA_DATA|XE_SODL_UNRUN|XE_SWIDE_OVRUN))
-			cam_status = DID_ERROR;
-		else if	(x_status & XE_BAD_PHASE)
-			cam_status = DID_ERROR;
 		else
 			cam_status = DID_ERROR;
 	}
-- 
2.25.4

