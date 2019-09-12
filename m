Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F2BECDE20
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 06:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3615E208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 06:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfILGfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 02:35:47 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:20126 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728588AbfILGfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 02:35:46 -0400
X-UUID: e35a8371ddcf4970a7e928552e0006a0-20190912
X-UUID: e35a8371ddcf4970a7e928552e0006a0-20190912
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 756990619; Thu, 12 Sep 2019 14:35:38 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Sep 2019 14:35:36 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Sep 2019 14:35:36 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <sthumma@codeaurora.org>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <evgreen@chromium.org>, <beanhuo@micron.com>,
        <marc.w.gonzalez@free.fr>, <subhashj@codeaurora.org>,
        <vivek.gautam@codeaurora.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/3] scsi: ufs: override auto suspend tunables for ufs
Date:   Thu, 12 Sep 2019 14:35:34 +0800
Message-ID: <1568270135-32442-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
References: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework from previous work by:
Sujit Reddy Thumma <sthumma@codeaurora.org>

Override auto suspend tunables for UFS device LUNs during
initialization so as to efficiently manage background operations
and the power consumption.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c |  8 ++++++++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 30b752c61b97..d253a018a73b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -88,6 +88,9 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+/* default delay of autosuspend: 2000 ms */
+#define RPM_AUTOSUSPEND_DELAY_MS 2000
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -4612,9 +4615,14 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
  */
 static int ufshcd_slave_configure(struct scsi_device *sdev)
 {
+	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+
+	if (ufshcd_is_rpm_autosuspend_allowed(hba))
+		sdev->rpm_autosuspend_delay = RPM_AUTOSUSPEND_DELAY_MS;
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a43c7135f33d..99ea416519af 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -714,6 +714,12 @@ struct ufs_hba {
 	 * the performance of ongoing read/write operations.
 	 */
 #define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 5)
+	/*
+	 * This capability allows host controller driver to automatically
+	 * enable runtime power management by itself instead of waiting
+	 * for userspace to control the power management.
+	 */
+#define UFSHCD_CAP_RPM_AUTOSUSPEND (1 << 6)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
@@ -747,6 +753,10 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 }
+static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_RPM_AUTOSUSPEND;
+}
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
-- 
2.18.0

