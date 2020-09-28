Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC494C4346E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 01:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C1A23A33
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 01:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBTzkvVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgI1Bof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Sep 2020 21:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI1Bof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Sep 2020 21:44:35 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A853BC0613CE
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 18:44:34 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a12so8315974eds.13
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 18:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itJ/3WUujIWyzLEIfgrjeLw+zqf5VU5ZcmDS3CYoLYg=;
        b=CBTzkvVCUYUzxSS85OwJ9p7pFrq5bC8InvXnmedkeHVxMdmovolbgQM3JoKIm/CnfQ
         C50ZjC+Owy85eX9K3Chb0auejHZXvaQTlfDVwQ55XWZddW/w7QeUwxPNvWLhRira6Owv
         0vDIqBMoZmEx/fMM5aJCF57yxPNs2INhZiZDNu/BwrWYJN9XPOpAq7zDLB4KYWHITTdl
         048GvGjB+XqPkD0YFyhSvVbTJ3RQ3TLSd7AEBnYe1q36i0luOoPDzZn1LyAfMGxrpGBT
         UkX/Rcb7m8peXfCGpNv+LChZAxoa9Uf9hZYHwuCAJVPeGsq3rxKYu+hleEgmUoRPPJYj
         pkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itJ/3WUujIWyzLEIfgrjeLw+zqf5VU5ZcmDS3CYoLYg=;
        b=nkge7ThdxMpIe8sfzUu8/A8dogbT4zM8U+rnSTDRD1pC/pSHywLreX9mDrrCprEOv2
         QLA8rncdHf2eYAVoCyR4iPmO1FZuT3zv/Ng59tkDH7A9mB8S6uybvSkHiziHG3F86YvY
         rsj3fDpz86YW1AIDno4s0fvIq+8MKXCZU51/p1QGADPW8nFADqFdm74tCFUMQx9XiL+T
         U6GZF6fELxU6BiCE02mOiHbKk+YlVmBNA3mXaXEetQQFyCZRyIYKFY0i64VJGR4146xB
         0jWfinmLSsGCb0NA1D97qE+zkn0QTWctHzWuj9n0evurnTsm7x59e4lyI/YdgXqa0iJH
         IiSA==
X-Gm-Message-State: AOAM531WuaqRFplP4cm2/z+PadRWIMv1G5wO4gDiVfBcAH95S14URwgg
        fBL4lWITR8pQg+1ZOOaJGvgHsblD08suocZS6Ec=
X-Google-Smtp-Source: ABdhPJx2FHi7ncC2vYamDJtLi3rI8Zhjb1w0RaWeohtEK/4WwSJL/2tBfaauOYQfFeDFVZ5jygKvSnlB05shgYO//oE=
X-Received: by 2002:a05:6402:1593:: with SMTP id c19mr13421329edv.33.1601257473276;
 Sun, 27 Sep 2020 18:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200923055248.1901-1-tom.ty89@gmail.com> <ca33b6af-6523-821d-5dc9-28ef6d8e7228@acm.org>
In-Reply-To: <ca33b6af-6523-821d-5dc9-28ef6d8e7228@acm.org>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Mon, 28 Sep 2020 09:44:21 +0800
Message-ID: <CAGnHSEmQQVex4Xa0sYDyRHKZN56L4nk840BYOBTcgm8pAvmstw@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: sg: use queue_logical_block_size() in max_sectors_bytes()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Oh right, that's what logical_to_sectors()'s for. Thanks! :-)

On Fri, 25 Sep 2020 at 01:52, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2020-09-22 22:52, Tom Yan wrote:
> > Logical block size was never / is no longer necessarily 512.
> >
> > Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> > ---
> >  drivers/scsi/sg.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index 20472aaaf630..8a2cca71017f 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -848,10 +848,11 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
> >  static int max_sectors_bytes(struct request_queue *q)
> >  {
> >       unsigned int max_sectors = queue_max_sectors(q);
> > +     max_sectors *= queue_logical_block_size(q);
> >
> > -     max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
> > +     max_sectors = min_t(unsigned int, max_sectors, INT_MAX);
> >
> > -     return max_sectors << 9;
> > +     return max_sectors;
> >  }
>
> I think the above patch is wrong and also that it breaks code that is
> correct. In the Linux kernel, "one sector" is by definition 512 bytes.
> See also the definition of the SECTOR_SIZE and SECTOR_SHIFT constants.
>
> Bart.
