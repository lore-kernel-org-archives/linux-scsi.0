Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D64BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABC4222B6
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAVJ1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 04:27:40 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41729 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727378AbhAVJSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 04:18:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMW2Lur_1611306989;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMW2Lur_1611306989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 17:16:41 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH 1/2] scsi: qla2xxx: remove redundant NULL check
Date:   Fri, 22 Jan 2021 17:16:26 +0800
Message-Id: <1611306987-103954-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings reported by coccicheck:
./drivers/scsi/qla2xxx/qla_init.c:3371:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla2xxx/qla_init.c:7855:5-10: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla2xxx/qla_init.c:7916:2-7: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla2xxx/qla_init.c:8113:4-18: WARNING: NULL check before
some freeing functions is not needed.
./drivers/scsi/qla2xxx/qla_init.c:8174:2-7: WARNING: NULL check before
some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dcc0f0d8..edd5dd1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3371,8 +3371,7 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
 				    "Re-Allocated (%d KB) and save firmware dump.\n",
 				    dump_size / 1024);
 			} else {
-				if (ha->fw_dump)
-					vfree(ha->fw_dump);
+				vfree(ha->fw_dump);
 				ha->fw_dump = fw_dump;
 
 				ha->fw_dump_len = ha->fw_dump_alloc_len =
@@ -7855,8 +7854,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
 	templates = (risc_attr & BIT_9) ? 2 : 1;
 	ql_dbg(ql_dbg_init, vha, 0x0160, "-> templates = %u\n", templates);
 	for (j = 0; j < templates; j++, fwdt++) {
-		if (fwdt->template)
-			vfree(fwdt->template);
+		vfree(fwdt->template);
 		fwdt->template = NULL;
 		fwdt->length = 0;
 
@@ -7916,8 +7914,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
 	return QLA_SUCCESS;
 
 failed:
-	if (fwdt->template)
-		vfree(fwdt->template);
+	vfree(fwdt->template);
 	fwdt->template = NULL;
 	fwdt->length = 0;
 
@@ -8113,8 +8110,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
 	templates = (risc_attr & BIT_9) ? 2 : 1;
 	ql_dbg(ql_dbg_init, vha, 0x0170, "-> templates = %u\n", templates);
 	for (j = 0; j < templates; j++, fwdt++) {
-		if (fwdt->template)
-			vfree(fwdt->template);
+		vfree(fwdt->template);
 		fwdt->template = NULL;
 		fwdt->length = 0;
 
@@ -8174,8 +8170,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
 	return QLA_SUCCESS;
 
 failed:
-	if (fwdt->template)
-		vfree(fwdt->template);
+	vfree(fwdt->template);
 	fwdt->template = NULL;
 	fwdt->length = 0;
 
-- 
1.8.3.1

