Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A6DC49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 06:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C88A20830
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 06:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfIPGic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 02:38:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:62067 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727834AbfIPGic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2019 02:38:32 -0400
X-UUID: 3e9d6bdf93b34165b0b1a5136983859e-20190916
X-UUID: 3e9d6bdf93b34165b0b1a5136983859e-20190916
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 262386844; Mon, 16 Sep 2019 14:38:26 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Sep 2019 14:38:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Sep 2019 14:38:25 +0800
Message-ID: <1568615905.16730.21.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/3] scsi: core: allow auto suspend override by
 low-level driver
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
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
        Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= 
        <Andy.Teng@mediatek.com>
Date:   Mon, 16 Sep 2019 14:38:25 +0800
In-Reply-To: <485731ed-d455-dbb2-0cd5-3110ff14f6b7@acm.org>
References: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
         <1568270135-32442-2-git-send-email-stanley.chu@mediatek.com>
         <485731ed-d455-dbb2-0cd5-3110ff14f6b7@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> > -	pm_runtime_forbid(&sdev->sdev_gendev);
> > +	if (sdev->rpm_autosuspend_delay < 0)
> > +		pm_runtime_forbid(&sdev->sdev_gendev);
> >  	pm_runtime_enable(&sdev->sdev_gendev);
> >  	scsi_autopm_put_target(starget);
> 
> So we have a single new struct member, rpm_autosuspend_delay, that
> controls two different behaviors: (a) whether or not runtime suspend is
> enabled at device creation time and (b) the power management autosuspend
> delay. I don't like this. Should two separate variables be introduced
> instead of using a single variable to control both behaviors?
> 

OK! Will try to separate different variables to control different things
in next version.

> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index 202f4d6a4342..133b282fae5a 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -199,7 +199,7 @@ struct scsi_device {
> >  	unsigned broken_fua:1;		/* Don't set FUA bit */
> >  	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
> >  	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
> > -
> > +	int rpm_autosuspend_delay;
> >  	atomic_t disk_events_disable_depth; /* disable depth for disk events */
> >  
> >  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
> > 
> 
> Since the default value for the autosuspend delay is the same for all
> SCSI devices attached to a SCSI host is the same, please add a variable
> with the same name in the SCSI host template and use that value as the
> default value for SCSI devices. If the rpm_autosuspend_delay variable
> only occurs in struct scsi_device then LLD authors are forced to
> introduce a slave_configure function. Introducing such a function can be
> avoided if the default autosuspend delay can be specified in the host
> template.
> 

Sounds reasonable. Will create a member indicating autosuspend delay for
the same SCSI host in SCSI host template in next version.

> Bart.
> 

Thanks,
Stanley


