Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9B6C07548
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 07:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbjKOHPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 02:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOHPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 02:15:03 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02633E9;
        Tue, 14 Nov 2023 23:14:56 -0800 (PST)
X-UUID: aa8fc178838611eea33bb35ae8d461a2-20231115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=hIaTDgDzLIscHf5CKI3TUjE0bb/R8Q6i6db1afgHSuQ=;
        b=jfBaPhGkL2sQQ6PjYrDY34FjNfsWp1/5LSRsEkUtC4OxCjmwNvU+wW9bXFHJKHgGz3KZrY3jDDrkPAO4j4vu+mBdWiA+MD7+DXCSIjXORohLnwCfmpJgqyEtejCe+19kQ9O4dClOPja3gqBtg+q6rA04cElLI7Z2omdYOPEYP1Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:a8c5b985-04fc-4cdd-9c02-6e6cda05b2aa,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:364b77b,CLOUDID:d7f66995-10ce-4e4b-85c2-c9b5229ff92b,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: aa8fc178838611eea33bb35ae8d461a2-20231115
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1956763761; Wed, 15 Nov 2023 15:14:50 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 15 Nov 2023 15:14:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 15 Nov 2023 15:14:49 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v1] ufs: core: clear cmd if abort success in mcq mode
Date:   Wed, 15 Nov 2023 15:14:46 +0800
Message-ID: <20231115071446.23912-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--8.173600-8.000000
X-TMASE-MatchedRID: NeCdpr+F3d4MQLXc2MGSbO7KTDtx8CggCt59Uh3p/NWsafcFLFlU1OhA
        oL09ZB7k7Oz5SO8AjrR6fWcwarN2OU2VnXMRzIBjMJoQm3jo+mk7pfSjRsD2Og2Y8xyy93kWcam
        vz988laLcGqNrS/CXVwG2ORx9EyapQq2SOVgDzZ2eAiCmPx4NwJuJ+Pb8n/VxdMrO7yc0I/wqtq
        5d3cxkNf1GGMILmA8BR0fN/zghq0cQZQGdbkyzRAyH5HTyOLIFidciRFVG7v7AvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.173600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 2F4036E4201BD7F8BC5623DF16C952CC2C84C88063EA7D5054272B455441BA7C2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

In mcq mode, if cmd is pending in device and abort success, response
will not return from device. So we need clear this cmd right now,
else command timeout happen and next time use same tag will have
warning. WARN_ON(lrbp->cmd).

Below is error log:
<3>[ 2277.447611][T21376] ufshcd-mtk 112b0000.ufshci: ufshcd_try_to_abort_task: cmd pending in the device. tag = 7
<3>[ 2277.476954][T21376] ufshcd-mtk 112b0000.ufshci: Aborting tag 7 / CDB 0x2a succeeded
<6>[ 2307.551263][T30974] ufshcd-mtk 112b0000.ufshci: ufshcd_abort: Device abort task at tag 7
<4>[ 2307.623264][  T327] WARNING: CPU: 5 PID: 327 at source/drivers/ufs/core/ufshcd.c:3021 ufshcd_queuecommand+0x66c/0xe34

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8b1031fb0a44..e559593e6979 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6449,6 +6449,16 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 		*ret ? "failed" : "succeeded");
+
+	/* Release cmd in mcq mode if abort success */
+	if (is_mcq_enabled(hba) && (*ret == 0)) {
+		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(hba->lrb[tag].cmd));
+		spin_lock_irqsave(&hwq->cq_lock, flags);
+		if (ufshcd_cmd_inflight(lrbp->cmd))
+			ufshcd_release_scsi_cmd(hba, lrbp);
+		spin_unlock_irqrestore(&hwq->cq_lock, flags);
+	}
+
 	return *ret == 0;
 }
 
-- 
2.18.0

