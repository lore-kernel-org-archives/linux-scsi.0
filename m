Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51C8C2BBCF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BB5233CF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgLPNR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:17:29 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60973 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726224AbgLPNR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 08:17:29 -0500
X-UUID: bea846b11c0f45cba0aa92489afaf1ce-20201216
X-UUID: bea846b11c0f45cba0aa92489afaf1ce-20201216
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 932496842; Wed, 16 Dec 2020 21:16:43 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 21:16:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 21:16:39 +0800
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
Subject: [PATCH v2 0/4] scsi: ufs: Cleanup and refactor clock scaling
Date:   Wed, 16 Dec 2020 21:16:35 +0800
Message-ID: <20201216131639.4128-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6911A1B75C51CE1585C5596884292F91209385E11FA99098B076F220C13A7F152000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series cleans up and refactors clk-scaling feature, and shall not change any functionality.

This series is based on Can's series "Three changes related with UFS clock scaling" in 5.10/scsi-fixes branch in Martin's tree.

However this series may not be required to be merged to 5.10. The choice of base branch is simply making these patches easy to be reviewed because this series is based on clk-scaling fixes by Can. If this series is decided not being merged to 5.10, then I would rebase it to 5.11/scsi-queue.

Changes since v1:
  - Refactor ufshcd_clk_scaling_suspend() in patch [3/4]
  - Change function name from ufshcd_clk_scaling_pm() to ufshcd_clk_scaling_suspend() in patch [3/4]
  - Refine patch titles

Stanley Chu (4):
  scsi: ufs: Refactor cancelling clkscaling works
  scsi: ufs: Remove redundant null checking of devfreq instance
  scsi: ufs: Cleanup and refactor clk-scaling feature
  scsi: ufs: Fix build warning by incorrect function description

 drivers/scsi/ufs/ufshcd.c | 90 +++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 47 deletions(-)

-- 
2.18.0

