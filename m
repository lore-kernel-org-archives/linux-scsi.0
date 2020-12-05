Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30124C4361A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 02:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D9822DFA
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 02:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgLEClA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 21:41:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:43895 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728663AbgLECk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 21:40:59 -0500
X-UUID: f4922e3ba7e2400db2e14d41092d9185-20201205
X-UUID: f4922e3ba7e2400db2e14d41092d9185-20201205
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 584594122; Sat, 05 Dec 2020 10:39:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 5 Dec 2020 10:39:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 5 Dec 2020 10:39:35 +0800
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
        <alice.chao@mediatek.com>, <huadian.liu@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 0/8] Refine error history and introduce event_notify vop
Date:   Sat, 5 Dec 2020 10:39:30 +0800
Message-ID: <20201205023938.13848-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series refines error history functions, do vop cleanups and introduce a new event_notify vop to allow vendor to get notification of important events.

Changes since v3:
  - Fix build warning in patch [8/8]

Changes since v2:
  - Add patches for vop cleanups
  - Introduce phy_initialization helper and replace direct invoking in ufs-cdns and ufs-dwc by the helper
  - Introduce event_notify vop implemntation in ufs-mediatek

Changes since v1:
  - Change notify_event() to event_notify() to follow vop naming covention

Stanley Chu (8):
  scsi: ufs: Remove unused setup_regulators variant function
  scsi: ufs: Introduce phy_initialization helper
  scsi: ufs-cdns: Use phy_initialization helper
  scsi: ufs-dwc: Use phy_initialization helper
  scsi: ufs: Add error history for abort event in UFS Device W-LUN
  scsi: ufs: Refine error history functions
  scsi: ufs: Introduce event_notify variant function
  scsi: ufs-mediatek: Introduce event_notify implementation

 drivers/scsi/ufs/cdns-pltfrm.c        |   3 +-
 drivers/scsi/ufs/ufs-mediatek-trace.h |  37 ++++++++
 drivers/scsi/ufs/ufs-mediatek.c       |  12 +++
 drivers/scsi/ufs/ufshcd-dwc.c         |  11 +--
 drivers/scsi/ufs/ufshcd.c             | 132 ++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h             | 100 +++++++++----------
 6 files changed, 175 insertions(+), 120 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-mediatek-trace.h

-- 
2.18.0

