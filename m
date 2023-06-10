Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970D0C7EE2E
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jun 2023 08:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjFJIf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Jun 2023 04:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjFJIf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jun 2023 04:35:27 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAC335A9;
        Sat, 10 Jun 2023 01:35:21 -0700 (PDT)
X-UUID: bb43e34e076911ee9cb5633481061a41-20230610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=J6vjsBT5jCzdHAk/J8ixvT+CHDsKynDNYR2jcMEHNFs=;
        b=Q6t92QRVYQeE1ooxi3in07KLapl7TGmTaqnKNAOufZTmUQPmDBqMU8lfuOPS2wsqHWb5cjfSStMCEf402AbQDwllyn2zpFRcU7PJ0neCSoEmcLdbaKFm1TWRu02rCRN4a9zEYg8riRujXi6J9KlZWgqwbOXIIhERxRRH1MxUlPE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.26,REQID:b42c9078-3eb1-4b63-be0b-a805992dadc9,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:cb9a4e1,CLOUDID:feebfd3d-de1e-4348-bc35-c96f92f1dcbb,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: bb43e34e076911ee9cb5633481061a41-20230610
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1720328119; Sat, 10 Jun 2023 16:35:18 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 10 Jun 2023 16:35:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Sat, 10 Jun 2023 16:35:17 +0800
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
Subject: [PATCH v3 0/2] Add MCQ support for MTK platform
Date:   Sat, 10 Jun 2023 16:33:18 +0800
Message-ID: <20230610083321.5566-1-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/ufs/core/ufshcd-priv.h  |   2 -
 drivers/ufs/host/ufs-mediatek.c | 174 +++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  33 ++++++
 include/ufs/ufshcd.h            |   3 +
 5 files changed, 211 insertions(+), 4 deletions(-)

--
2.18.0

