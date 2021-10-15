Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE96C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18CF46115C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbhJOPlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:41:19 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:41412 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235616AbhJOPlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:41:19 -0400
X-UUID: cb7a63a7da4c4b91afbff72d23390826-20211015
X-UUID: cb7a63a7da4c4b91afbff72d23390826-20211015
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 463697543; Fri, 15 Oct 2021 23:39:09 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 15 Oct 2021 23:39:07 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Oct 2021 23:39:07 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <peter.wang@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <chaotian.jing@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <gray.jia@mediatek.com>, <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs-mediatek: Introduce default delay for reference clock
Date:   Fri, 15 Oct 2021 23:39:05 +0800
Message-ID: <20211015153906.21929-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211015153906.21929-1-stanley.chu@mediatek.com>
References: <20211015153906.21929-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce default delay time for gating or ungating reference clock
instead of ambiguous magic numbers.

The defined value is suitable for all current MediaTek UFS platforms.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 13 ++++++++-----
 drivers/scsi/ufs/ufs-mediatek.h |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d1696db70ce8..2c7d12a30493 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -282,7 +282,7 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 }
 
 static void ufs_mtk_setup_ref_clk_wait_us(struct ufs_hba *hba,
-					  u16 gating_us, u16 ungating_us)
+					  u16 gating_us)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
@@ -293,7 +293,7 @@ static void ufs_mtk_setup_ref_clk_wait_us(struct ufs_hba *hba,
 		host->ref_clk_gating_wait_us = gating_us;
 	}
 
-	host->ref_clk_ungating_wait_us = ungating_us;
+	host->ref_clk_ungating_wait_us = REFCLK_DEFAULT_WAIT_US;
 }
 
 static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
@@ -1102,11 +1102,14 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 	 * requirements.
 	 */
 	if (mid == UFS_VENDOR_SAMSUNG)
-		ufs_mtk_setup_ref_clk_wait_us(hba, 1, 1);
+		ufs_mtk_setup_ref_clk_wait_us(hba, 1);
 	else if (mid == UFS_VENDOR_SKHYNIX)
-		ufs_mtk_setup_ref_clk_wait_us(hba, 30, 30);
+		ufs_mtk_setup_ref_clk_wait_us(hba, 30);
 	else if (mid == UFS_VENDOR_TOSHIBA)
-		ufs_mtk_setup_ref_clk_wait_us(hba, 100, 32);
+		ufs_mtk_setup_ref_clk_wait_us(hba, 100);
+	else
+		ufs_mtk_setup_ref_clk_wait_us(hba,
+					      REFCLK_DEFAULT_WAIT_US);
 
 	return 0;
 }
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index c96b9b529ee2..414dca86c09f 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -34,6 +34,7 @@
 #define REFCLK_ACK                  BIT(1)
 
 #define REFCLK_REQ_TIMEOUT_US       3000
+#define REFCLK_DEFAULT_WAIT_US      32
 
 /*
  * Other attributes
-- 
2.18.0

