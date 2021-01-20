Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16833C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 15:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D477E233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 15:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389118AbhATPKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:10:02 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:48442 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390870AbhATPC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 10:02:58 -0500
X-UUID: 8726652692a9472c814580e6faed3ec3-20210120
X-UUID: 8726652692a9472c814580e6faed3ec3-20210120
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 289457921; Wed, 20 Jan 2021 23:02:16 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 20 Jan 2021 23:01:52 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Jan 2021 23:01:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 0/3] scsi: ufs: Cleanup and refactor clock scaling
Date:   Wed, 20 Jan 2021 23:01:39 +0800
Message-ID: <20210120150142.5049-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 4813510C0F2570B68E6DFB194355F03012662DC6A73A47E8BF304A594C14F6CA2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series cleans up and refactors clk-scaling feature, and shall not change any functionality.

This series is based on Can's series "Three changes related with UFS clock scaling" in 5.12/scsi-queue branch in Martin's tree.

Changes since v2:
  - Remove patch 4
  - Rebase to Can's series: [v11] Three changes related with UFS clock scaling

Changes since v1:
  - Refactor ufshcd_clk_scaling_suspend() in patch [3/4]
  - Change function name from ufshcd_clk_scaling_pm() to ufshcd_clk_scaling_suspend() in patch [3/4]
  - Refine patch titles


Stanley Chu (3):
  scsi: ufs: Refactor cancelling clkscaling works
  scsi: ufs: Remove redundant null checking of devfreq instance
  scsi: ufs: Cleanup and refactor clk-scaling feature

 drivers/scsi/ufs/ufshcd.c | 87 ++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 46 deletions(-)

-- 
2.18.0

