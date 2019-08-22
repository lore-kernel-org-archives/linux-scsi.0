Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3A8C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC60233FC
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389216AbfHVNlw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:41:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731907AbfHVNlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:41:52 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C5F04BD9821E702B9EEE;
        Thu, 22 Aug 2019 21:41:39 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:41:31 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/3] scsi: qla4xxx: remove set but not used variable 'func_number'
Date:   Thu, 22 Aug 2019 21:48:00 +0800
Message-ID: <1566481681-92765-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
References: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/qla4xxx/ql4_init.c: In function ql4xxx_set_mac_number:
drivers/scsi/qla4xxx/ql4_init.c:17:10: warning: variable func_number set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 2bf5e3e..2c14384 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -14,7 +14,6 @@
 static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 {
 	uint32_t value;
-	uint8_t func_number;
 	unsigned long flags;

 	/* Get the function number */
@@ -22,7 +21,6 @@ static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 	value = readw(&ha->reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);

-	func_number = (uint8_t) ((value >> 4) & 0x30);
 	switch (value & ISP_CONTROL_FN_MASK) {
 	case ISP_CONTROL_FN0_SCSI:
 		ha->mac_index = 1;
--
2.7.4

