Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1C9C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 05:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB70208FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 05:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgKLFpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:45:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:52217 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725920AbgKLFpu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 00:45:50 -0500
X-UUID: 3619e16383324db68f09494592aaac68-20201112
X-UUID: 3619e16383324db68f09494592aaac68-20201112
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1261890501; Thu, 12 Nov 2020 13:45:41 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Nov 2020 13:45:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 Nov 2020 13:45:38 +0800
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
Subject: [PATCH] scsi: ufs: Add retry flow for failed hba enabling
Date:   Thu, 12 Nov 2020 13:45:37 +0800
Message-ID: <20201112054537.22494-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 71C1B6B624CEB4EED4AABDF7C779B0B4F80EF6905439682D9094502A978056822000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Once hba enabling is failed, add retry mechanism and in the
meanwhile allow vendors to apply specific handlings before
the next retry. For example, vendors can do vendor-specific
host reset flow in variant function "ufshcd_vops_hce_enable_notify()".

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8001bbfec5c0..9186ee01379a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4328,8 +4328,10 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
  */
 static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
-	int retry;
+	int retry_outer = 3;
+	int retry_inner;
 
+start:
 	if (!ufshcd_is_hba_active(hba))
 		/* change controller state to "reset state" */
 		ufshcd_hba_stop(hba);
@@ -4355,13 +4357,17 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 	ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
 
 	/* wait for the host controller to complete initialization */
-	retry = 50;
+	retry_inner = 50;
 	while (ufshcd_is_hba_active(hba)) {
-		if (retry) {
-			retry--;
+		if (retry_inner) {
+			retry_inner--;
 		} else {
 			dev_err(hba->dev,
 				"Controller enable failed\n");
+			if (retry_outer) {
+				retry_outer--;
+				goto start;
+			}
 			return -EIO;
 		}
 		usleep_range(1000, 1100);
-- 
2.18.0

