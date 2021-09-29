Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A7CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBA560F6E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbhI2HDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:03:20 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55788 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S244462AbhI2HDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 03:03:14 -0400
X-UUID: 0e11f859e6b942f9a53cafb6eecbf6ad-20210929
X-UUID: 0e11f859e6b942f9a53cafb6eecbf6ad-20210929
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1143022976; Wed, 29 Sep 2021 15:01:29 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 29 Sep 2021 15:01:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Sep 2021 15:01:27 +0800
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <wsd_upstream@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH 2/2] scsi: ufs: fix TM request timeout
Date:   Wed, 29 Sep 2021 15:00:47 +0800
Message-ID: <20210929070047.4223-3-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210929070047.4223-1-powen.kao@mediatek.com>
References: <20210929070047.4223-1-powen.kao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TM command issued by ufshcd_issue_tm_cmd() inevitably timeout since
interrupt handler iterates wrong request list for completion.

The issue is fixed by iterating static_rqs instead of rqs to find
requests with new interface blk_mq_drv_tagset_busy_iter().

Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..7a1ea42302b8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6428,7 +6428,7 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ci.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	blk_mq_drv_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
-- 
2.18.0

