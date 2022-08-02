Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81580C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 07:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiHBHTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 03:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiHBHTQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 03:19:16 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B197049B48
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 00:19:10 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VLAavtl_1659424740;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VLAavtl_1659424740)
          by smtp.aliyun-inc.com;
          Tue, 02 Aug 2022 15:19:05 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: remove unnecessary kfree
Date:   Tue,  2 Aug 2022 15:19:00 +0800
Message-Id: <1659424740-46918-1-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When alloc ctrl mem fail, the reply_map will be free in
megasas_free_ctrl_mem(), no need to free in megasas_alloc_ctrl_mem().

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a3e117a..f6c37a9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7153,22 +7153,18 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
 	switch (instance->adapter_type) {
 	case MFI_SERIES:
 		if (megasas_alloc_mfi_ctrl_mem(instance))
-			goto fail;
+			return -ENOMEM;
 		break;
 	case AERO_SERIES:
 	case VENTURA_SERIES:
 	case THUNDERBOLT_SERIES:
 	case INVADER_SERIES:
 		if (megasas_alloc_fusion_context(instance))
-			goto fail;
+			return -ENOMEM;
 		break;
 	}
 
 	return 0;
- fail:
-	kfree(instance->reply_map);
-	instance->reply_map = NULL;
-	return -ENOMEM;
 }
 
 /*
-- 
1.8.3.1

