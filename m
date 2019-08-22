Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCD8C3A5A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4290521743
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbfHVNc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:32:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfHVNc4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:32:56 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7253A4A23F94D1A11603;
        Thu, 22 Aug 2019 21:32:51 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:32:43 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 1/2] scsi: megaraid: remove set but not used variable 'reg_set'
Date:   Thu, 22 Aug 2019 21:39:13 +0800
Message-ID: <1566481154-47760-2-git-send-email-zhengbin13@huawei.com>
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

drivers/scsi/megaraid/megaraid_sas_fusion.c: In function megasas_fusion_update_can_queue:
drivers/scsi/megaraid/megaraid_sas_fusion.c:311:39: warning: variable reg_set set but not used [-Wunused-but-set-variable]]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 120e3c4..fdf6559 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -323,9 +323,6 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 {
 	u16 cur_max_fw_cmds = 0;
 	u16 ldio_threshold = 0;
-	struct megasas_register_set __iomem *reg_set;
-
-	reg_set = instance->reg_set;

 	/* ventura FW does not fill outbound_scratch_pad_2 with queue depth */
 	if (instance->adapter_type < VENTURA_SERIES)
--
2.7.4

