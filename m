Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7E1FA373D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 07:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiJZHkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiJZHkD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 03:40:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9937013CF6
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 00:39:56 -0700 (PDT)
X-UUID: ba78004ee5ce48a9b1393280a7928358-20221026
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Q1xVPgyjNzrGEirYEr+nq8Zk4ZTr7PDzTq3MciNODW4=;
        b=Xgg/Awwe9reCbl5pmQ4H1DJQdVq8baozhEBwtDUHopbQhSyg/HtYRrRqAUM7fQ0U3Snk9Kmaw0bxgtWoXwqmrgPS5qe0Ixtdc2hOhPJ41se2VhSFKvs0S02z4gk/S0XkgCk4x/CZSekPYKlYfPyqxy7tJIlIPLE7EshblybA+ns=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:1e48772c-a9df-4fe5-a52a-18193fbd6835,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.12,REQID:1e48772c-a9df-4fe5-a52a-18193fbd6835,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:62cd327,CLOUDID:87bc2d27-9eb1-469f-b210-e32d06cfa36e,B
        ulkID:221026153953YLS0QSUM,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: ba78004ee5ce48a9b1393280a7928358-20221026
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <eddie.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 363711304; Wed, 26 Oct 2022 15:39:51 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 26 Oct 2022 15:39:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 26 Oct 2022 15:39:50 +0800
From:   Eddie Huang <eddie.huang@mediatek.com>
To:     Asutosh Das <quic_asutoshd@quicinc.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
CC:     <avri.altman@wdc.com>, <liang-yen.wang@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <cc.chou@mediatek.com>,
        <powen.kao@mediatek.com>, Eddie Huang <eddie.huang@mediatek.com>
Subject: [PATCH v1 0/2] Add Mediatek UFS Multi Circular Queue
Date:   Wed, 26 Oct 2022 15:39:41 +0800
Message-ID: <20221026073943.22111-1-eddie.huang@mediatek.com>
X-Mailer: git-send-email 2.9.2
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch support Mediatek SoC UFSHCI 4.0 MCQ (Multi Circular
Queue) capability. The implementation is based on "Add Multi
Circular Queue Support" series [1] by Asutosh Das, and provide

1. Customize MCQ register resource vops
2. Mediatek MCQ porting

This series test pass use FIO on Mediatek platform

[1] https://www.spinics.net/lists/linux-scsi/msg178322.html

Eddie Huang (2):
  ufs: core: mcq: Add config_mcq_resource vops
  ufs: mtk-host: Add MCQ feature

 drivers/ufs/core/ufs-mcq.c      |  3 +++
 drivers/ufs/core/ufshcd-priv.h  |  8 ++++++++
 drivers/ufs/host/ufs-mediatek.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  7 +++++++
 include/ufs/ufshcd.h            |  1 +
 5 files changed, 56 insertions(+)

-- 
2.9.2

