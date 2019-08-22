Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFC3C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFD121743
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbfHVNcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:32:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfHVNcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:32:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6CADEDFFD864F510C8F0;
        Thu, 22 Aug 2019 21:32:51 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:32:44 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/2] scsi: megaraid: remove set but not used variables 'debugBlk','fusion'
Date:   Thu, 22 Aug 2019 21:39:14 +0800
Message-ID: <1566481154-47760-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566481154-47760-1-git-send-email-zhengbin13@huawei.com>
References: <1566481154-47760-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/megaraid/megaraid_sas_fp.c: In function MR_GetSpanBlock:
drivers/scsi/megaraid/megaraid_sas_fp.c:400:16: warning: variable debugBlk set but not used [-Wunused-but-set-variable]
drivers/scsi/megaraid/megaraid_sas_fp.c: In function mr_spanset_get_phy_params:
drivers/scsi/megaraid/megaraid_sas_fp.c:713:25: warning: variable fusion set but not used [-Wunused-but-set-variable]
drivers/scsi/megaraid/megaraid_sas_fp.c: In function MR_GetPhyParams:
drivers/scsi/megaraid/megaraid_sas_fp.c:815:25: warning: variable fusion set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 50b8c1b..89c3685 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -386,9 +386,8 @@ u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 				le64_to_cpu(quad->logEnd) && (mega_mod64(row - le64_to_cpu(quad->logStart),
 				le32_to_cpu(quad->diff))) == 0) {
 				if (span_blk != NULL) {
-					u64  blk, debugBlk;
+					u64  blk;
 					blk =  mega_div64_32((row-le64_to_cpu(quad->logStart)), le32_to_cpu(quad->diff));
-					debugBlk = blk;

 					blk = (blk + le64_to_cpu(quad->offsetInSpan)) << raid->stripeShift;
 					*span_blk = blk;
@@ -699,9 +698,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	__le16	*pDevHandle = &io_info->devHandle;
 	u8	*pPdInterface = &io_info->pd_interface;
 	u32	logArm, rowMod, armQ, arm;
-	struct fusion_context *fusion;

-	fusion = instance->ctrl_context;
 	*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);

 	/*Get row and span from io_info for Uneven Span IO.*/
@@ -801,9 +798,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	u64	    *pdBlock = &io_info->pdBlock;
 	__le16	    *pDevHandle = &io_info->devHandle;
 	u8	    *pPdInterface = &io_info->pd_interface;
-	struct fusion_context *fusion;

-	fusion = instance->ctrl_context;
 	*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);

 	row =  mega_div64_32(stripRow, raid->rowDataSize);
--
2.7.4

