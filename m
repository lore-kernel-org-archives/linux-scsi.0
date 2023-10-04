Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C78BE8FDCA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 06:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjJDGZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 02:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjJDGZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 02:25:12 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8144EA6
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 23:25:04 -0700 (PDT)
X-UUID: bd33c442627e11eea33bb35ae8d461a2-20231004
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=dLk6h3JIv/VwN5I2F/6v+BEy4FVgZe2ToaeVemTiK4o=;
        b=JjWUGd3d2jym53ssd3z3Vac/i/YjvaWuJHXbSNp32trW9BnIGWkEc4CniXVJ63bw/01w0vU0uEoWVVMDGORRwFXbGZWPU6kOf/tvYUlRVhYr4d59HYQ5EeHMrJiRKwS4+U7ETDJXhCdfRb27aELguA++S3YCju4lgxXj0fCsin0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:7d777768-82f5-4385-85a3-5841a03ce01a,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:5f78ec9,CLOUDID:fac390bf-14cc-44ca-b657-2d2783296e72,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: bd33c442627e11eea33bb35ae8d461a2-20231004
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 921873695; Wed, 04 Oct 2023 14:24:57 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 4 Oct 2023 14:24:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 4 Oct 2023 14:24:55 +0800
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
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>
Subject: [PATCH v1] ufs: core: remove dev cmd clock scaling busy
Date:   Wed, 4 Oct 2023 14:24:54 +0800
Message-ID: <20231004062454.29165-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--4.029200-8.000000
X-TMASE-MatchedRID: sBypFcuOxUYMQLXc2MGSbBuZoNKc6pl+KVrLOZD1BXRKUzR+o2IehQfo
        RwTLQ8VIRK8zTtidEIMmcX+PhFtDQc5bqtIsLkuo4bl1FkKDELdMkOX0UoduuVwpnAAvAwazLA6
        iWJ2FQ/Hi8zVgXoAltsIJ+4gwXrEtwrbXMGDYqV/6CZXLlV1mSSPj1juHE0e7Vgd4fqyr9xBUwv
        q6R0rjLBK1ABsP5FVXM0QEmCKR6WHkCJS9s03wogMmAJtItKcxQcdwHvBRzhT0s0GdaA6/B3ZrU
        bEZipAEiWT09mQz7szw9kH8zAy44aOuVLnx3A74
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.029200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: D6DDA25898B22DC95D00B6E3A3EA66746BD7811BB3DA076354D2122F965A774E2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

If dev command timeout, clk_scaling.active_reqs is not decrease
and cause clock scaling framework abnormal. But it is complicated to
handle different dev command timeout case in legacy mode or mcq mode.
Besides, dev cmd is rare used and busy time is short.
So remove clock scaling busy window for dev cmd is properly.
Same as uic or tm cmd which doesn't update busy window too.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..474d5dded7ed 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2165,7 +2165,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
 	lrbp->compl_time_stamp = ktime_set(0, 0);
 	lrbp->compl_time_stamp_local_clock = 0;
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
-	ufshcd_clk_scaling_start_busy(hba);
+	if (lrbp->cmd)
+		ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
 
@@ -5405,7 +5406,6 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 				lrbp->utr_descriptor_ptr->header.ocs = ocs;
 			}
 			complete(hba->dev_cmd.complete);
-			ufshcd_clk_scaling_update_busy(hba);
 		}
 	}
 }
-- 
2.18.0

