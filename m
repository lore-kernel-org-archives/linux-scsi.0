Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540BDC49ED6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 02:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0172085B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 02:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfILCZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 22:25:02 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:29785 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726952AbfILCZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 22:25:02 -0400
X-UUID: e0c776e483ff4f23b6e1d48ff1c158b4-20190912
X-UUID: e0c776e483ff4f23b6e1d48ff1c158b4-20190912
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1841125873; Thu, 12 Sep 2019 10:24:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Sep 2019 10:24:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Sep 2019 10:24:54 +0800
Message-ID: <1568255094.16730.10.camel@mtkswgap22>
Subject: RE: [PATCH v1 1/3] scsi: core: allow auto suspend override by
 low-level driver
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
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>
Date:   Thu, 12 Sep 2019 10:24:54 +0800
In-Reply-To: <MN2PR04MB6991142450EEF05E2AF2D8DFFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1568194890-24439-1-git-send-email-stanley.chu@mediatek.com>
         <1568194890-24439-2-git-send-email-stanley.chu@mediatek.com>
         <MN2PR04MB6991142450EEF05E2AF2D8DFFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: FFB581AF885F6D0D8BCF8806218FBBFE49DD31A95CC1CEB7B6B3B7B30AF6FD832000:8
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > 149d406aacc9..2218d57c4c0c 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -3371,6 +3371,9 @@ static int sd_probe(struct device *dev)
> >         }
> > 
> >         blk_pm_runtime_init(sdp->request_queue, dev);
> > +       if (sdp->rpm_autosuspend_delay > 0)
> > +               pm_runtime_set_autosuspend_delay(dev, 
> > +
> Redundant line ?

checkpatch reported "WARNING:LONG_LINE:line over 80 characters" when I
made this as oneline : (

> > + sdp->rpm_autosuspend_delay);
> Don't you need to call now pm_runtime_use_autosuspend() ?

dev->power.user_autosuspend was set by blk_pm_runtime_init() above, thus
pm_runtime_use_autosuspend() is not necessary here.

> 
> >         device_add_disk(dev, gd, NULL);
> >         if (sdkp->capacity)
> >                 sd_dif_config_host(sdkp); diff --git a/include/scsi/scsi_device.h
> > b/include/scsi/scsi_device.h index 202f4d6a4342..133b282fae5a 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -199,7 +199,7 @@ struct scsi_device {
> >         unsigned broken_fua:1;          /* Don't set FUA bit */
> >         unsigned lun_in_cdb:1;          /* Store LUN bits in CDB[1] */
> >         unsigned unmap_limit_for_ws:1;  /* Use the UNMAP limit for WRITE
> > SAME */
> > -
> > +       int rpm_autosuspend_delay;
> Can suspend be negative?

Yes, however negative delay value will block rpm.

Here we just use the same type as parameter "delay" of
pm_runtime_set_autosuspend() even though we do not set it as negative
value in this version.

But thank you so much to remind me that
pm_runtime_set_autosuspend_delay() can accept "zero" delay so we shall
allow "zero" sdev->rpm_autosuspend_delay as well.

I will fix it in v2.

> 
> >         atomic_t disk_events_disable_depth; /* disable depth for disk events */
> > 
> >         DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /*
> > supported events */
> > --
> > 2.18.0
> 

Thanks,
Stanley


