Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757ADC2BB54
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C6F20719
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgDGJaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:30:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35594 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728092AbgDGJaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 05:30:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8FD3BE39F893B674DDD2;
        Tue,  7 Apr 2020 17:30:03 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Apr 2020
 17:29:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/4] scsi: megaraid: make some symbols static in megaraid_sas_fp.c
Date:   Tue, 7 Apr 2020 17:28:25 +0800
Message-ID: <20200407092827.18074-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200407092827.18074-1-yanaijie@huawei.com>
References: <20200407092827.18074-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/megaraid/megaraid_sas_fp.c:88:5: warning: symbol
'mega_div64_32' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fp.c:370:5: warning: symbol
'MR_GetSpanBlock' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fp.c:420:5: warning: symbol
'mr_spanset_get_span_block' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fp.c:645:4: warning: symbol 'get_arm'
was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fp.c:788:4: warning: symbol
'MR_GetPhyParams' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fp.c:1345:4: warning: symbol
'megasas_get_best_arm_pd' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 89c3685f5163..3b3d04d7671f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -85,7 +85,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
  *
  * @return quotient
  **/
-u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u32 remainder;
 	u64 d;
@@ -367,7 +367,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 	return 1;
 }
 
-u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
+static u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 		    struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct MR_SPAN_BLOCK_INFO *pSpanBlock = MR_LdSpanInfoGet(ld, map);
@@ -417,7 +417,7 @@ u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 *    div_error	   - Devide error code.
 */
 
-u32 mr_spanset_get_span_block(struct megasas_instance *instance,
+static u32 mr_spanset_get_span_block(struct megasas_instance *instance,
 		u32 ld, u64 row, u64 *span_blk, struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct fusion_context *fusion = instance->ctrl_context;
@@ -642,7 +642,7 @@ static u32 get_arm_from_strip(struct megasas_instance *instance,
 }
 
 /* This Function will return Phys arm */
-u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
+static u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
 		struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
@@ -785,7 +785,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 *    span          - Span number
 *    block         - Absolute Block number in the physical disk
 */
-u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
+static u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		u16 stripRef, struct IO_REQUEST_INFO *io_info,
 		struct RAID_CONTEXT *pRAID_Context,
 		struct MR_DRV_RAID_MAP_ALL *map)
@@ -1342,7 +1342,7 @@ void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *drv_map,
 	}
 }
 
-u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
+static u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 			   struct LD_LOAD_BALANCE_INFO *lbInfo,
 			   struct IO_REQUEST_INFO *io_info,
 			   struct MR_DRV_RAID_MAP_ALL *drv_map)
-- 
2.17.2

