Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B39FC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 02:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjE3Ccy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 22:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjE3Ccw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 22:32:52 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1AFB5;
        Mon, 29 May 2023 19:32:46 -0700 (PDT)
X-UUID: 3f51977afe9211ed9cb5633481061a41-20230530
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=wKxiAjJaD2fCBU9jgKHTupnXwycEnNR8OZfzadkS1xQ=;
        b=haa1p6Yia7kEZQWqt3xUqH8dahF+keedtV1I3+Lrdnc6J2s780+i1ij3qgErFPVdxeit5renIhI4SaZQlXmg2XRBY+vCL54A8PcoEIFqFjI+v6N0jJv5GdCXW78VDRQnnS1qOSg6TXaB8O2wqbx0Jsp4+TgFL9nB5FFdqqAfAMI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.25,REQID:734331c2-05f1-427a-a70c-23ad76da9508,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:d5b0ae3,CLOUDID:7c84646d-2f20-4998-991c-3b78627e4938,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: 3f51977afe9211ed9cb5633481061a41-20230530
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 725805236; Tue, 30 May 2023 10:32:39 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 10:32:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 30 May 2023 10:32:38 +0800
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
Subject: [PATCH v2 0/3] Add MCQ support for MTK platform
Date:   Tue, 30 May 2023 10:32:24 +0800
Message-ID: <20230530023227.16653-1-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

Peter Wang (1):
  scsi: ufs: core: Introduce mcq ops to config cqid

Po-Wen Kao (2):
  scsi: ufs: core: Export symbols for MTK driver module
  scsi: ufs: ufs-mediatek: Add MCQ support for MTK platform

 drivers/ufs/core/ufs-mcq.c      |   6 +-
 drivers/ufs/core/ufshcd-priv.h  |  10 +-
 drivers/ufs/core/ufshcd.c       |  11 ++
 drivers/ufs/host/ufs-mediatek.c | 188 +++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  33 ++++++
 include/ufs/ufshcd.h            |   8 ++
 6 files changed, 251 insertions(+), 5 deletions(-)

--
2.18.0

