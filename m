Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95430C2BBCA
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 463B5233CF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLPNRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:17:41 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35813 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726217AbgLPNRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 08:17:41 -0500
X-UUID: 74454a7c0ee540eaa7cab07c15eccdae-20201216
X-UUID: 74454a7c0ee540eaa7cab07c15eccdae-20201216
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1045623662; Wed, 16 Dec 2020 21:16:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 21:16:40 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 21:16:39 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 4/4] scsi: ufs: Fix build warning by incorrect function description
Date:   Wed, 16 Dec 2020 21:16:39 +0800
Message-ID: <20201216131639.4128-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201216131639.4128-1-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix build warnings as below due to incorrect function description
of ufshcd_try_to_abort_task().

ufshcd.c:6651: warning: Function parameter or member 'hba' not described in 'ufshcd_try_to_abort_task'
ufshcd.c:6651: warning: Function parameter or member 'tag' not described in 'ufshcd_try_to_abort_task'
ufshcd.c:6651: warning: Excess function parameter 'cmd' description in 'ufshcd_try_to_abort_task'

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ce0528f2e2ed..79287fdd049b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6652,7 +6652,8 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 
 /**
  * ufshcd_try_to_abort_task - abort a specific task
- * @cmd: SCSI command pointer
+ * @hba: per adapter instance
+ * @tag: position of the bit to be aborted
  *
  * Abort the pending command in device by sending UFS_ABORT_TASK task management
  * command, and in host controller by clearing the door-bell register. There can
-- 
2.18.0

