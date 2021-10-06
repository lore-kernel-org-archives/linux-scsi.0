Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D8CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC606120D
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbhJFDL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 23:11:58 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:41728 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231867AbhJFDL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 23:11:57 -0400
X-UUID: c6545ed43ed24dce8bc4b66905119bcd-20211006
X-UUID: c6545ed43ed24dce8bc4b66905119bcd-20211006
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 762116720; Wed, 06 Oct 2021 11:10:02 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 6 Oct 2021 11:10:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Oct 2021 11:10:00 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>
Subject: [PATCH v3 0/2] scsi: ufs: support vops pre suspend for mediatek to disable auto-hibern8
Date:   Wed, 6 Oct 2021 11:09:57 +0800
Message-ID: <20211006030959.20533-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Mediatek UFS design need disable auto-hibern8 before suspend.
This patch introduce an solution to do pre suspned before SSU
(sleep) command.

Peter Wang (2):
  scsi: ufs: support vops pre suspend
  scsi: ufs: ufs-mediatek: disable auto-hibern8 before suspend

 drivers/scsi/ufs/ufs-exynos.c   |  6 ++-
 drivers/scsi/ufs/ufs-hisi.c     |  6 ++-
 drivers/scsi/ufs/ufs-mediatek.c | 68 ++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-mediatek.h | 20 ++++++++++
 drivers/scsi/ufs/ufs-qcom.c     |  6 ++-
 drivers/scsi/ufs/ufshcd.c       |  9 ++++-
 drivers/scsi/ufs/ufshcd.h       |  8 ++--
 7 files changed, 114 insertions(+), 9 deletions(-)

-- 
2.18.0

