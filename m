Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E18C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C3A613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbhI2HC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:02:56 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:34276 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229536AbhI2HCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 03:02:55 -0400
X-UUID: 565c1f70ef764a769e0909e9db7ccfee-20210929
X-UUID: 565c1f70ef764a769e0909e9db7ccfee-20210929
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1605795204; Wed, 29 Sep 2021 15:01:10 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 29 Sep 2021 15:01:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Sep 2021 15:01:09 +0800
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <wsd_upstream@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH 0/2] Fix UFS task management command timeout
Date:   Wed, 29 Sep 2021 15:00:45 +0800
Message-ID: <20210929070047.4223-1-powen.kao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On UTP_TASK_REQ_COMPL interrupt, ufshcd_tmc_handler() iterates through
busy requests in tags->rqs and complete request if corresponding
doorbell flag is reset.
However, ufshcd_issue_tm_cmd() allocates requests from tags->static_rqs 
and trigger doorbell directly without dispatching request through block 
layer, thus requests can never be found in tags->rqs and completed 
properly. Any TM command issued by ufshcd_issue_tm_cmd() inevitably 
timeout and further leads to recovery flow failure when LU Reset or 
Abort Task is issued.

In this patch, blk_mq_tagset_busy_iter() call in ufshcd_tmc_handler() 
is replaced with new interface, blk_mq_drv_tagset_busy_iter(), to 
allow completion of request allocted by driver. The new interface is 
introduced for driver to iterate through requests in static_rqs. 

Po-Wen Kao (2):
  blk-mq: new busy request iterator for driver
  scsi: ufs: fix TM request timeout

 block/blk-mq-tag.c        | 36 ++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.c |  2 +-
 include/linux/blk-mq.h    |  4 ++++
 3 files changed, 35 insertions(+), 7 deletions(-)

-- 
2.18.0

