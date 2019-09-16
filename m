Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D1DC49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 15:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97115206C2
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 15:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbfIPPzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 11:55:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:15480 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727666AbfIPPzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2019 11:55:46 -0400
X-UUID: 8621e6238e33419db293d603130736bd-20190916
X-UUID: 8621e6238e33419db293d603130736bd-20190916
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 143584848; Mon, 16 Sep 2019 23:55:38 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Sep 2019 23:55:36 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Sep 2019 23:55:36 +0800
Message-ID: <1568649336.16730.22.camel@mtkswgap22>
Subject: Re: [PATCH v3 1/3] scsi: core: allow auto suspend override by
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
        "kernel-team@android.com" <kernel-team@android.com>,
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
Date:   Mon, 16 Sep 2019 23:55:36 +0800
In-Reply-To: <bebea62f-8ab0-528f-5634-9b3c06f47ef7@acm.org>
References: <1568616437-16271-1-git-send-email-stanley.chu@mediatek.com>
         <1568616437-16271-2-git-send-email-stanley.chu@mediatek.com>
         <bebea62f-8ab0-528f-5634-9b3c06f47ef7@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 5F47E35CB09F565A53FE9C6AB70840EF796B39E9C06F1BF69DB3769F521CD1352000:8
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> > -
> > +	unsigned rpm_autosuspend_on:1;	/* Runtime autosuspend */
> >   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
>     The "_on" part in the variable name "rpm_autosuspend_on" is probably 
> redundant and the comment could have been more elaborate. Anyway:

OK! Thanks for suggestions. Will fix both in next version.

> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks,
Stanley


