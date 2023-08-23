Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493FBEE49B2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 09:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbjHWJjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbjHWJiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 05:38:02 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3A85587
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 02:29:58 -0700 (PDT)
X-UUID: 9c49171c419711eeb20a276fd37b9834-20230823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vo3+V+eMV1OAqifmmQMhpDL/h1ukA0z3irk/9OPLQqo=;
        b=S0Skr4KGYErFXrdAdE0q9NmsX9aKDK7oFCLKU1Olrccv9gnKNbZ4AhsAhfa1A/hgowW9PIrD38U8nI3giwYM5Ne0Wey6buWSVujTsQd19RteY8Xw65B7r6PN6YlNetlOC7GHv80QzsnUGOaYt2P5A/8xcy4jNwAl3C1SNF6umt4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:1d6db235-020a-4db6-a02f-2a154aa42380,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.31,REQID:1d6db235-020a-4db6-a02f-2a154aa42380,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:0ad78a4,CLOUDID:36afa81f-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:2308231729510J1DBNU2,BulkQuantity:0,Recheck:0,SF:29|28|17|19|48|38,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,
        TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-UUID: 9c49171c419711eeb20a276fd37b9834-20230823
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1046389694; Wed, 23 Aug 2023 17:29:51 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 23 Aug 2023 17:29:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 23 Aug 2023 17:29:50 +0800
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
Subject: [PATCH v1 0/3] Fix abnormal clock scaling behaviors
Date:   Wed, 23 Aug 2023 17:29:45 +0800
Message-ID: <20230823092948.22734-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

This patch fix abnormal clock scaling behaviors.

Peter Wang (3):
  ufs: core: only suspend clock scaling if scale down
  ufs: core: fix abnormal scale up after last cmd finish
  ufs: core: fix abnormal scale up after scale down

 drivers/ufs/core/ufshcd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.18.0

