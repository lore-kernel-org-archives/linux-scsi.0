Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD015C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 09:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABAB92078D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 09:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys8+SS1e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgFQJxy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 05:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgFQJxy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 05:53:54 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E505C061573;
        Wed, 17 Jun 2020 02:53:53 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id y123so1012493vsb.6;
        Wed, 17 Jun 2020 02:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAZWB5/FadmuRl9utB2u/LqF6lndy4SpSJklCc+5bYU=;
        b=Ys8+SS1eO8qlJTwzctPCqJgyNKQEdzl2U2dftMfCqZFNaPgU+VrVWOO6n5HNvlzoum
         f2DhhXvbqqXEkftYenMwa+kAV8hbKb3s+YNuj7QxLMFShd1cnK5AjGz3fwR/jEsOIOpw
         deh9lvyVzxmY6rg4tXjogd+uvia09abTAFEDDuGO0QfL+q9tlBI1vcLksVj89TGg8ZJO
         Lq/dJrh7h8bb8Whyw5wZ+uLh9Uuvr913Y7+w2JcdIkUPxwq8rPfSxkSjwZSXq2CbtBam
         1lAKN+aBN/kH1CFhRy64whiKF5lvWdLcJhOFTV9ZztwRUu2jIpxq2WHOacJeDbFaNYlm
         eIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAZWB5/FadmuRl9utB2u/LqF6lndy4SpSJklCc+5bYU=;
        b=mYuG/Tcla0X6HK/VG1FrUT91J1PwjerxpTSisE+ponjWoCi3SQLsYwZx6r8oOPqrOj
         wCWTGK9aW6s1X3ZZFH78x09nnNYc24ocYc0e+EvC7aXHwpSYRSU/41rwhDqpD9cBmK0e
         SVOJpP+IlOfd0V6h6T+dAtXmOeTcElfyzndM+AZdwn/FvYAM4v4U6QFW8J62wFshI6Uo
         gXhH1z+KBEyyAPOIiRxidF5jQo1NMf4QIDjkUu2OL1Q7RKOIxLdf/Ht0ATrJkOZjO/Y0
         TOPNmLEMvKkkt6KdyNtpK2eTzNEyFmlyZTV0Nktj70I+AajVAZglF1Wu/8HCO4Jus1/W
         ry4w==
X-Gm-Message-State: AOAM530QQPuqa9QN39kuntyneNAUUX3CsxbR29J0m4tduqjX0lQcgFPV
        DPcppjXZKStOKkptjiRZPeUnjcN1dWUAHFRd1w8=
X-Google-Smtp-Source: ABdhPJycBka/Ek+TGS4xyOPp2K+zeCp77Tmrvu+eYu0R01KMu8BdWN8cXEjVPcHMO+RYeSrdMae7TVYyI2cUS7X61N4=
X-Received: by 2002:a67:f902:: with SMTP id t2mr4792265vsq.176.1592387632519;
 Wed, 17 Jun 2020 02:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
 <336371513.41592205783606.JavaMail.epsvc@epcpadp2> <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
 <231786897.01592212081335.JavaMail.epsvc@epcpadp2> <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
 <1210830415.21592275802431.JavaMail.epsvc@epcpadp1> <SN6PR04MB4640EE125CF504AF9362B23FFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <CAGOxZ50TUnvmmdspxr6dHWrpoxZqHtvR-1Wg6jAVH6k-w5LT2w@mail.gmail.com> <653426a77669eaced17e9e5aa87259ad57514c47.camel@gmail.com>
In-Reply-To: <653426a77669eaced17e9e5aa87259ad57514c47.camel@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 17 Jun 2020 15:23:16 +0530
Message-ID: <CAGOxZ51tpiBiTgns9q7X4w2rzvhc0U81s8st+f9PXDdmytJhAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
To:     Bean Huo <huobean@gmail.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On Wed, Jun 17, 2020 at 3:12 PM Bean Huo <huobean@gmail.com> wrote:
>
> > > HPB1.0 isn't part of ufs3.1, but published only later.
> > > Allowing earlier versions will required to quirk the descriptor
> > > sizes.
> > > I see Bean's point here, but I vote for adding it in a single
> > > quirk, when the time comes.
> > >
> >
> > I second Avri here, older devices need a quirk to handle, let do that
> > as a separate patch.
> > > Thanks,
> > > Avri
> >
> >
>
> what is useful point of adding a quirk for this?
>
> From the customer side piont, they just get our FW image, and then do
> FFU. If adding a quirk here, that means they also need to change UFS
> driver. Also,  you expand the qurik structure.
>
>
> from cambridge dictionary:
> Qurik:
>         an unusual habit or part of someone's personality, or something
>         that
> is strange and unexpected.
>
> HPB feature is unexpected??
>
>
> please tell me the useful point of adding a Quirk.
>
The point is not about adding a quirk per say, it's about  doing that
as a separate patch so that we know which device/ features are added
and why it is added. Please understand there is no denial about your
proposal or thought.
Thanks!!
> Bean
> >
>


-- 
Regards,
Alim
