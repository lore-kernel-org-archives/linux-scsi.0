Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA6FC1B0D8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6217B206DB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgLHN5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 08:57:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56236 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729025AbgLHN5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 08:57:24 -0500
X-UUID: 8ef993b99daa4830a6bd8b7b2228282c-20201208
X-UUID: 8ef993b99daa4830a6bd8b7b2228282c-20201208
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1497966473; Tue, 08 Dec 2020 21:56:37 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Dec 2020 21:56:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Dec 2020 21:56:34 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nguyenb@codeaurora.org>,
        <bjorn.andersson@linaro.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/2] scsi: ufs: Re-enable WriteBooster after device reset
Date:   Tue, 8 Dec 2020 21:56:34 +0800
Message-ID: <20201208135635.15326-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201208135635.15326-1-stanley.chu@mediatek.com>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS 3.1 specification mentions that below WriteBooster flags will be
set to default value, say disabled, after power cycle or any type
of reset event. Thus we need to reset those flag variables kept
in struct hba to align the device status and ensure WriteBooster
related functions being configured properly after device reset.

Without this fix, WriteBooster will not be enabled successfully
after by ufshcd_wb_ctrl() after device reset because hba->wb_enabled
remains true.

Flags required to be reset to default values:
- fWriteBoosterEn: hba->wb_enabled
- fWriteBoosterBufferFlushEn: hba->wb_buf_flush_enabled
- fWriteBoosterBufferFlushDuringHibernate: No variable mapped

Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 08c8a591e6b0..36d367eb8139 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1221,8 +1221,13 @@ static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 	if (hba->vops && hba->vops->device_reset) {
 		int err = hba->vops->device_reset(hba);
 
-		if (!err)
+		if (!err) {
 			ufshcd_set_ufs_dev_active(hba);
+			if (ufshcd_is_wb_allowed(hba)) {
+				hba->wb_enabled = false;
+				hba->wb_buf_flush_enabled = false;
+			}
+		}
 		if (err != -EOPNOTSUPP)
 			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
 	}
-- 
2.18.0

