Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE643C49ED9
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 05:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC25E20856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 05:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfILFhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 01:37:42 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:26570 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725794AbfILFhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 01:37:42 -0400
X-UUID: ac9febee49994d14859fb0a10dba9ce3-20190912
X-UUID: ac9febee49994d14859fb0a10dba9ce3-20190912
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 476330481; Thu, 12 Sep 2019 13:37:35 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Sep 2019 13:37:31 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Sep 2019 13:37:31 +0800
Message-ID: <1568266651.16730.13.camel@mtkswgap22>
Subject: RE: [PATCH v1 2/3] scsi: ufs: override auto suspend tunables for ufs
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Thu, 12 Sep 2019 13:37:31 +0800
In-Reply-To: <MN2PR04MB6991D63EEF50367BE2CB062CFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1568194890-24439-1-git-send-email-stanley.chu@mediatek.com>
         <1568194890-24439-3-git-send-email-stanley.chu@mediatek.com>
         <MN2PR04MB6991D63EEF50367BE2CB062CFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> > 30b752c61b97..d253a018a73b 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -88,6 +88,9 @@
> >  /* Interrupt aggregation default timeout, unit: 40us */
> >  #define INT_AGGR_DEF_TO        0x02
> > 
> > +/* default delay of autosuspend: 2000 ms */ #define
> Typo?
> 

This is wired because it looks fine in both my local patch and in
patchwork website: https://patchwork.kernel.org/patch/11140759/

Anyway I will try to fix and check it carefully in v2.

Thanks,
Stanley

