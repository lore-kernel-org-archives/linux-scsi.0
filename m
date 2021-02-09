Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E07C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F7B64E25
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBIFen convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 00:34:43 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2581 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIFej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 00:34:39 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DZWj933nkzW18j;
        Tue,  9 Feb 2021 13:31:41 +0800 (CST)
Received: from dggemi709-chm.china.huawei.com (10.3.20.108) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 9 Feb 2021 13:33:56 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi709-chm.china.huawei.com (10.3.20.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 9 Feb 2021 13:33:55 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Tue, 9 Feb 2021 13:33:55 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Topic: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Index: AQHW/fAMrBMz1ua2YUiLJwcWnjqnW6pPDROA//+zewCAAIlDYA==
Date:   Tue, 9 Feb 2021 05:33:55 +0000
Message-ID: <6712a7f16b99489db2828098dc3e03b2@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
In-Reply-To: <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Finn Thain [mailto:fthain@telegraphics.com.au]
> Sent: Tuesday, February 9, 2021 6:06 PM
> To: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
> Cc: tanxiaofei <tanxiaofei@huawei.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; linuxarm@openeuler.org;
> linux-m68k@vger.kernel.org
> Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
> for SCSI drivers
> 
> On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
> 
> > > -----Original Message-----
> > > From: Finn Thain [mailto:fthain@telegraphics.com.au]
> > > Sent: Monday, February 8, 2021 8:57 PM
> > > To: tanxiaofei <tanxiaofei@huawei.com>
> > > Cc: jejb@linux.ibm.com; martin.petersen@oracle.com;
> > > linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > linuxarm@openeuler.org
> > > Subject: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
> > > for SCSI drivers
> > >
> > > On Sun, 7 Feb 2021, Xiaofei Tan wrote:
> > >
> > > > Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
> > > > There are no function changes, but may speed up if interrupt happen too
> > > > often.
> > >
> > > This change doesn't necessarily work on platforms that support nested
> > > interrupts.
> > >
> > > Were you able to measure any benefit from this change on some other
> > > platform?
> >
> > I think the code disabling irq in hardIRQ is simply wrong.
> > Since this commit
> >
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> ?id=e58aa3d2d0cc
> > genirq: Run irq handlers with interrupts disabled
> >
> > interrupt handlers are definitely running in a irq-disabled context
> > unless irq handlers enable them explicitly in the handler to permit
> > other interrupts.
> >
> 
> Repeating the same claim does not somehow make it true. If you put your

Sorry for I didn't realize xiaofei had replied.

> claim to the test, you'll see that that interrupts are not disabled on
> m68k when interrupt handlers execute.

Sounds like an implementation issue of m68k since IRQF_DISABLED has
been totally removed.

> 
> The Interrupt Priority Level (IPL) can prevent any given irq handler from
> being re-entered, but an irq with a higher priority level may be handled
> during execution of a lower priority irq handler.
> 

We used to have IRQF_DISABLED to support so-called "fast interrupt" to avoid
this. But the concept has been totally removed. That is interesting if m68k
still has this issue.

> sonic_interrupt() uses an irq lock within an interrupt handler to avoid
> issues relating to this. This kind of locking may be needed in the drivers
> you are trying to patch. Or it might not. Apparently, no-one has looked.

Thanks
Barry

