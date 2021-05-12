Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA2CC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 08:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A430F613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 08:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhELIkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 04:40:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37459 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229968AbhELIkh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 04:40:37 -0400
X-UUID: 66d7e4d7f4984b95bfca9232ce06952e-20210512
X-UUID: 66d7e4d7f4984b95bfca9232ce06952e-20210512
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1347917821; Wed, 12 May 2021 16:39:25 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 May 2021 16:39:24 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 16:39:24 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: scsi: ufs-mediatek: fix ufs power down specs violation
Date:   Wed, 12 May 2021 16:39:05 +0800
Message-ID: <1620808746-21082-1-git-send-email-peter.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As per specs, e.g, JESD220E chapter 7.2, while powering off
the ufs device, RST_N signal should be between VSS(Ground)
and VCCQ/VCCQ2. The power down sequence after fixing as below:

Power down:
1. Assert RST_N low
2. Turn-off VCC
3. Turn-off VCCQ/VCCQ2


 drivers/scsi/ufs/ufs-mediatek.c |    4 ++++
 1 file changed, 4 insertions(+)
