Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE2AECDE27
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 06:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CA62075C
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 06:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfILGfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 02:35:47 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44387 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728876AbfILGfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 02:35:47 -0400
X-UUID: 120f723e30f64e88bac93360b62a798a-20190912
X-UUID: 120f723e30f64e88bac93360b62a798a-20190912
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1628552556; Thu, 12 Sep 2019 14:35:38 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Sep 2019 14:35:35 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Sep 2019 14:35:35 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <sthumma@codeaurora.org>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <evgreen@chromium.org>, <beanhuo@micron.com>,
        <marc.w.gonzalez@free.fr>, <subhashj@codeaurora.org>,
        <vivek.gautam@codeaurora.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2] scsi: allow auto suspend override by low-level driver
Date:   Thu, 12 Sep 2019 14:35:32 +0800
Message-ID: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 69DFC312C55A697E8114525BFA6A4A5DF700A0FEEAA883F214F7D392E1776FDE2000:8
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Until now the scsi mid-layer forbids runtime suspend till userspace
enables it. This is mainly to quarantine some disks with broken
runtime power management or have high latencies executing suspend
resume callbacks. If the userspace doesn't enable the runtime suspend
the underlying hardware will be always on even when it is not doing
any useful work and thus wasting power.

Some low-level drivers for the controllers can efficiently use runtime
power management to reduce power consumption and improve battery life.

This patchset allows runtime suspend parameters override within the LLD itself
instead of waiting for userspace to control the power management, and
make UFS as the first user of this capability.

v1 => v2:
- Allow "zero" sdev->rpm_autosuspend_delay (Avri)
- Fix format of some lines (Avri)

Stanley Chu (3):
  scsi: core: allow auto suspend override by low-level driver
  scsi: ufs: override auto suspend tunables for ufs
  scsi: ufs-mediatek: enable auto suspend capability

 drivers/scsi/scsi_scan.c        |  6 ++++++
 drivers/scsi/scsi_sysfs.c       |  3 ++-
 drivers/scsi/sd.c               |  4 ++++
 drivers/scsi/ufs/ufs-mediatek.c |  7 +++++++
 drivers/scsi/ufs/ufshcd.c       |  8 ++++++++
 drivers/scsi/ufs/ufshcd.h       | 10 ++++++++++
 include/scsi/scsi_device.h      |  2 +-
 7 files changed, 38 insertions(+), 2 deletions(-)

-- 
2.18.0

