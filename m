Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2564C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7699720717
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n08eF27D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfKFEJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:09:39 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44906 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKFEJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:09:39 -0500
Received: by mail-il1-f195.google.com with SMTP id i6so1873429ilr.11
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 20:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBF6i0CsRDj4z1nhlXI49p94vi3PFKk2xM4+N9XDEV0=;
        b=n08eF27DZopynSP+bqsjccjiNqyrTQWp4VcbBITQ9nUGQoqie1oA2yKVAbWLvDULOS
         a588XrVcES9g3fMhfYOGyp6eO728+SLKN5skSq6RbMe98cyAatzCAgoPixfmFGvR9tX8
         DSE0DO5JHflwASQthDLoSakL9UKtKwo1BXYa250RZJor3AS8+i/YKdCdBpsvMSu+Wkuo
         NzMg1jdCgpzbDftOKgvXXC7ar1SaFlDPukE4hRUnTViXJFSphGgpMxDJt9Ld9lMakxrg
         RjjRRk+y2JoFGMtYalqNJNIWN5J2Xdnlcgaotw1ehlH76azglp925y9D8nkHlW4i1sdt
         ndNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBF6i0CsRDj4z1nhlXI49p94vi3PFKk2xM4+N9XDEV0=;
        b=DwNLKQfCrV/esfsI3qngN2ZvoKUnmz+Kh+kIEzio6GFb3vh/unBTjnDDkLknA7gYhT
         422HKBWBgqCLX8t6fLd3gWC076UxS67AuW4WFyasvQt38xUJP/9fhqYV3qinQLL9K9GB
         z6yU3Fb4S2KPZG/TQXMNQL/VPRuFCzwUII3xSmlaGSkfJjgFJXtKcWSEjb2itv1qEs/M
         Iq3ki2vJ5JhytHkVC/ukbQVnNruJe1q8d+/IaPBnS3wexYBcw/oJ39sj/RWtxgSWSxeG
         L/3szSQC9WtpIqstVdLr7l+UcZ09rglrhRDOwXul/dxOujkmb4e1OJ7fmvd1RmkK8pm3
         djvg==
X-Gm-Message-State: APjAAAV87VIUgIh+LRfKjnn8uSv+Dl0lI07QGkAf5uswHjdXU5pxgr3v
        q3/Fogvq3lu+an8qDVtzHNTzAAGOKvV1SavXqC4=
X-Google-Smtp-Source: APXvYqz9MT3VXyZaJdW42Y+64kvdoc3aLi8CcFGzJiCzNH0v44CQLWNDf2/Q9QbfrxCa38f9p3aiojdhUjBWVXIqs7k=
X-Received: by 2002:a92:a308:: with SMTP id a8mr537455ili.105.1573013378063;
 Tue, 05 Nov 2019 20:09:38 -0800 (PST)
MIME-Version: 1.0
References: <20191029230710.211926-1-bvanassche@acm.org> <20191029230710.211926-4-bvanassche@acm.org>
 <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
 <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGOxZ51AHByBFsMiKG_-pGjVe4=1ijQnUipS=Gjq1pYPsCKQGA@mail.gmail.com>
In-Reply-To: <CAGOxZ51AHByBFsMiKG_-pGjVe4=1ijQnUipS=Gjq1pYPsCKQGA@mail.gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 6 Nov 2019 09:39:01 +0530
Message-ID: <CAGOxZ53xoaFrs09KfPFHfR69-n9SnRrZ0uESE65e+Wgwe3Pr7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] ufs: Remove .setup_xfer_req()
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart / Avri

On Tue, Nov 5, 2019 at 9:47 PM Alim Akhtar <alim.akhtar@gmail.com> wrote:
>
> Hi
>
> On Mon, Nov 4, 2019 at 6:29 PM Avri Altman <Avri.Altman@wdc.com> wrote:
> >
> > As no response from Kiwoong Kim:
> >
> > >
> > >
> > > + Kiwoong Kim
> Looks like he is not active here.
> > >
> > > >
> > > > Since the function ufshcd_vops_setup_xfer_req() is the only user of
> > > > the setup_xfer_req function pointer and since that function pointer is
> > > > always zero, remove both this function and the function pointer. This
> > > > patch does not change any functionality.
> > > >
> > > > Cc: Yaniv Gardi <ygardi@codeaurora.org>
> > > > Cc: Subhash Jadavani <subhashj@codeaurora.org>
> > > > Cc: Stanley Chu <stanley.chu@mediatek.com>
> > > > Cc: Avri Altman <avri.altman@wdc.com>
> > > > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > Since this was introduced only a couple of years ago, Maybe better to CC the
> > > author Kiwoong Kim <kwmad.kim@samsung.com> Before removing this
> > > altogether.
> > Reviewed-by: Avri Altman <avri.altman@wdc.com>
>
> Let me check and reconfirm this, give a day or two.
> It will be good if am copied to the ufs patch (I hope
> get_maintainer.pl still pointout my email)
> thanks
>
I checked the brief history of this adding  "setup_xfer_req" to
support Samsung UFSHCI (this was the ground work done)
We need this to support vendor specific NEXUS_TYPE settings.
The Samsung UFSHCI driver will be up for review in near future
For usecase of the function pointer please see an older version of the
patch https://patchwork.kernel.org/patch/7306321/

> --
> Regards,
> Alim



-- 
Regards,
Alim
