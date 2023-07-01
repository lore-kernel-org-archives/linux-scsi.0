Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C2DC001B1
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Jul 2023 12:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjGAMpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Jul 2023 08:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGAMpB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2023 08:45:01 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16303C0A;
        Sat,  1 Jul 2023 05:44:56 -0700 (PDT)
X-UUID: 125f034e180d11ee9cb5633481061a41-20230701
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=4xGu9VlnslxLeLQzb8tdhvdhSZ/9/Xe77++VYmaP6Vs=;
        b=MQ5oHdZADYfWkvag700wPRGUK7C1Nxuy2xV989ND7Md6ef+Qt7v9JuqWFtGtELjiHUegtzjOgLqNfqZbOfntadiHXTr6ni4L+ge2wqPsVksiGcqQD2DcwCHK3FIzZSvs4fezdovGUo+7AX9FK6ulTuCW4FwlJkDiL4JjmIK/C0Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.27,REQID:d478bcdd-ed45-4422-beae-57c88eb0ca8a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.27,REQID:d478bcdd-ed45-4422-beae-57c88eb0ca8a,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:01c9525,CLOUDID:8a75720d-26a8-467f-b838-f99719a9c083,B
        ulkID:230701204452YKKLYVTS,BulkQuantity:0,Recheck:0,SF:17|19|48|38|29|28,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
        ,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,
        TF_CID_SPAM_FSD
X-UUID: 125f034e180d11ee9cb5633481061a41-20230701
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1069962375; Sat, 01 Jul 2023 20:44:51 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 1 Jul 2023 20:44:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Sat, 1 Jul 2023 20:44:50 +0800
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <stanley.chu@mediatek.com>, <powen.kao@mediatek.com>,
        <alice.chao@mediatek.com>, <naomi.chu@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <cc.chou@mediatek.com>,
        <eddie.huang@mediatek.com>
Subject: [PATCH v5 0/2] Add MCQ support for MTK platform
Date:   Sat, 1 Jul 2023 20:44:39 +0800
Message-ID: <20230701124442.10489-1-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 -> v5
- Remove unused define in header
- Let chatty log print only at debug level
- Correct ufs_mtk_init_mcq_irq() that was wrongly fixed

v3 -> v4
Address AngeloGioacchino's comments.

v2 -> v3
- Drop SQ to CQ mapping vops introduced in v2
- Refactor commit message
- Update export symbols

v1 -> v2
- Introduce MCQ SQ to CQ mapping vops and provide MTK implementation.
- Update export symbol patch

v1
- Separated from topic "[PATCH v4 0/5] Several UFS MCQ Code Changes".
  Here are some changes since last upload
  - Store irq in per host array
  - Symbol rename
  - Use ufshcd_mcq_poll_cqe_lock() instead of ufshcd_mcq_poll_cqe_nolock()
  - Handle invalid irq dts property
  - Remove ufshcd_disable_intr(hba, MCQ_CQ_EVENT_STATUS) in MCQ mode.
    This will become host quirk later.

Po-Wen Kao (2):
  scsi: ufs: core: Export symbols for MTK driver module
  scsi: ufs: ufs-mediatek: Add MCQ support for MTK platform

 drivers/ufs/core/ufs-mcq.c      |   3 +
 drivers/ufs/host/ufs-mediatek.c | 174 +++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  33 ++++++
 include/ufs/ufshcd.h            |   3 +
 4 files changed, 211 insertions(+), 2 deletions(-)

--
2.18.0

