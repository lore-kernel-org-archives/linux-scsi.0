Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBF1ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 08:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiINIsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 04:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiINIsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 04:48:22 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FE6A487
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 01:48:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VPmeSKn_1663145290;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VPmeSKn_1663145290)
          by smtp.aliyun-inc.com;
          Wed, 14 Sep 2022 16:48:14 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] scsi: megaraid_sas: correct the parameter of scsi_device_lookup
Date:   Wed, 14 Sep 2022 16:47:59 +0800
Message-Id: <1663145283-4872-2-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
References: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a delete event is received, find the scsi_device and remove it,
the scsi_device_lookup`s parameter id should be "ld_target_id %
MEGASAS_MAX_DEV_PER_CHANNEL".

Fixes: ae6874ba4b43 ("scsi: megaraid_sas: Early detection of VD deletion through RaidMap update")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>

---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7f8632c..44d5e93 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8922,7 +8922,7 @@ void megasas_add_remove_devices(struct megasas_instance *instance,
 			sdev1 = scsi_device_lookup(instance->host,
 						   MEGASAS_MAX_PD_CHANNELS +
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
-						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
+						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
 			dev_info(&instance->pdev->dev, "Debug_lgx: ld_target_id:%u, sdev1:%p.\n",
                                ld_target_id, sdev1);
-- 
1.8.3.1

