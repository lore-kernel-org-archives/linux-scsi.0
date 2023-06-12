Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7C5C7EE43
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 09:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjFLJC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 05:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjFLJBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 05:01:40 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37A3E64;
        Mon, 12 Jun 2023 01:58:26 -0700 (PDT)
X-UUID: 480d016608ff11ee9cb5633481061a41-20230612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=fSXGGjV7TfLUPXcpZ3gu+0BbhppOJSGdmLD1p/7hYzk=;
        b=fA3toNeTsYzKrcFo/z7T3ImgHCdWf6x2D/8E1GzY9bo+QglhOA73rQoTDtecn23MD9GQNIzxHQlaRcZpwrziPwcp4r4gJMhJQQ00r7+PK4/D70hmHRRLj5exct2xJvtAL2np03dUqbWmVlNAC+wp9V4M4pyfW8M+wAKt1/+T3Jo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.26,REQID:c79cd210-eb39-4052-b4d6-b5ffe87bee1c,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:cb9a4e1,CLOUDID:b7c9563e-7aa7-41f3-a6bd-0433bee822f3,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 480d016608ff11ee9cb5633481061a41-20230612
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1462173400; Mon, 12 Jun 2023 16:58:21 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 12 Jun 2023 16:58:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 12 Jun 2023 16:58:20 +0800
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
Subject: [PATCH v1 0/4] ufs: Introduce MCQ Quirks for MediaTek host
Date:   Mon, 12 Jun 2023 16:58:08 +0800
Message-ID: <20230612085817.12275-1-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1
Introduce quirks for non-standard part of UFSHCI and address Bart's comment
from last patch
https://lore.kernel.org/all/20230328103801.11198-1-powen.kao@mediatek.com/


Po-Wen Kao (4):
  scsi: ufs: core: Add host quirk UFSHCD_QUIRK_MCQ_BROKEN_INTR
  scsi: ufs: core: Add host quirk UFSHCD_QUIRK_MCQ_BROKEN_RTC
  scsi: ufs: ufs-mediatek: Set UFSHCD_QUIRK_MCQ_BROKEN_INTR quirk
  scsi: ufs: ufs-mediatek: Set UFSHCD_QUIRK_MCQ_BROKEN_RTC quirk

 drivers/ufs/core/ufs-mcq.c      | 12 ++++++++++++
 drivers/ufs/core/ufshcd.c       |  6 +++++-
 drivers/ufs/host/ufs-mediatek.c |  2 ++
 include/ufs/ufshcd.h            | 13 +++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

--
2.18.0

