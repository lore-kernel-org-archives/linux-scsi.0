Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BA8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470106197A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348866AbhI3Iw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:52:27 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:48898 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1348052AbhI3Iw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 04:52:26 -0400
X-UUID: 120975a9fa3c4183b67d298a3bf2d88c-20210930
X-UUID: 120975a9fa3c4183b67d298a3bf2d88c-20210930
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2053204664; Thu, 30 Sep 2021 16:50:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 30 Sep 2021 16:50:39 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Sep 2021 16:50:38 +0800
Message-ID: <a0c747584bf4190d1456f285d83670e807f31553.camel@mediatek.com>
Subject: Re: [PATCH 0/2] Fix UFS task management command timeout
From:   Po-Wen Kao <powen.kao@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "jonathan.hsu@mediatek.com" <jonathan.hsu@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "ed.tsai@mediatek.com" <ed.tsai@mediatek.com>
Date:   Thu, 30 Sep 2021 16:50:38 +0800
In-Reply-To: <DM6PR04MB657502D8172084475F280CF5FCA99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210929070047.4223-1-powen.kao@mediatek.com>
         <DM6PR04MB657502D8172084475F280CF5FCA99@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

Thanks for reminding. It's exactly the same issue.

Best,
Po-Wen Kao

On Wed, 2021-09-29 at 07:39 +0000, Avri Altman wrote:
> > On UTP_TASK_REQ_COMPL interrupt, ufshcd_tmc_handler() iterates
> > through
> > busy requests in tags->rqs and complete request if corresponding
> > doorbell flag is reset.
> > However, ufshcd_issue_tm_cmd() allocates requests from tags-
> > >static_rqs
> > and trigger doorbell directly without dispatching request through
> > block
> > layer, thus requests can never be found in tags->rqs and completed
> > properly. Any TM command issued by ufshcd_issue_tm_cmd() inevitably
> > timeout and further leads to recovery flow failure when LU Reset or
> > Abort Task is issued.
> > 
> > In this patch, blk_mq_tagset_busy_iter() call in
> > ufshcd_tmc_handler()
> > is replaced with new interface, blk_mq_drv_tagset_busy_iter(), to
> > allow completion of request allocted by driver. The new interface
> > is
> > introduced for driver to iterate through requests in static_rqs.
> 
> Is this the same issue that was addressed here - 
> https://urldefense.com/v3/__https://www.spinics.net/lists/linux-scsi/msg164520.html__;!!CTRNKA9wMg0ARbw!yDkg-AVkMBFsnDBV42HMDgnE51HaEBarK2Tw8z8Di4aC1_7BrRkjIO13nz5rFUk-FA$
> A$  ?
> 
> Thanks,
> Avri
> 
> > 
> > Po-Wen Kao (2):
> >   blk-mq: new busy request iterator for driver
> >   scsi: ufs: fix TM request timeout
> > 
> >  block/blk-mq-tag.c        | 36 ++++++++++++++++++++++++++++++-----
> > -
> >  drivers/scsi/ufs/ufshcd.c |  2 +-
> >  include/linux/blk-mq.h    |  4 ++++
> >  3 files changed, 35 insertions(+), 7 deletions(-)
> > 
> > --
> > 2.18.0
> 
> 

