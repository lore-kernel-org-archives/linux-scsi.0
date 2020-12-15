Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E38CC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C69612226A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgLOJki (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:40:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:59050 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727775AbgLOJkb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:40:31 -0500
X-UUID: b036cac9ae994ddabf219e5524b0ba96-20201215
X-UUID: b036cac9ae994ddabf219e5524b0ba96-20201215
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1662855156; Tue, 15 Dec 2020 17:39:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:39:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:39:36 +0800
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
Subject: [PATCH v1 4/4] scsi: ufs: Fix build warning by incorrect function description
Date:   Tue, 15 Dec 2020 17:39:34 +0800
Message-ID: <20201215093934.21223-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201215093934.21223-1-stanley.chu@mediatek.com>
References: <20201215093934.21223-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BEEA38C008BEBCA6B551BFFEBDBFC0668C4DB8595B9FDBFD0C06C02EE25BEEBB2000:8
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
index 15e5877411b3..dd1ca22264da 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6637,7 +6637,8 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 
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

