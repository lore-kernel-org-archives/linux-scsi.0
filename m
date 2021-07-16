Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755F2C636CA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 18:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5779F613F6
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 18:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhGPSnI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 14:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhGPSnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 14:43:07 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1ECC06175F
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 11:40:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i5so17571921lfe.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9nCrxcelbpDIbpESpWTfClCqoqokLILtrUeS3p8Qgo=;
        b=LlbUobBHAEsbD+vsYCfC2l/zxoD37dxYfuUQVevnVgIFyLAgAelaGfA+NxPjNINOGT
         E/+inM05AqOqZqmj879EHFR8LnuNNSnOI1lSSKkkG92kxHPAINcesa29BG+4nveDmReg
         FW0PoDExWELoPdfcJjbnGXvh8oxnLX28eauDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9nCrxcelbpDIbpESpWTfClCqoqokLILtrUeS3p8Qgo=;
        b=IUBRlMcefzAk0TVS5E1OHWkGXYCRYeEvbsT9PYpsAdRNJ9Wuk/CsLB4sPlxzGEyGID
         lxv65bmZE90BANHUbeDvIFK+Nsqtewnkz//WpyDJPa2+vJaH9D782F/J1wsmLioIq02I
         vlqgvpjf07FVNU2xaQYndDzK+EquDKuxcq6DQygOzxSB2xY5k5gpUM235u+f5pe1LQaa
         9Nedx5Dphw6mxhdi/riDN3HXzV2eCrv738//MteLin7tkkq5dIqH8k612fIHdx4xpx+Q
         jOojsFs+SvbzKoPyj+IbkpyE3CxuD6sWh+wpsuaIALF6GoiM9a2ItYtwrcCZWVowxftO
         rDng==
X-Gm-Message-State: AOAM533qDwJtvfZKT3e8TMSnRYjMNtzR9zNrArJijsukdVjsSs++ZVAY
        yj/YK017N8PTajtpr04+zEpeoGZ01q4YwufgoYM9sw==
X-Google-Smtp-Source: ABdhPJzhHKksBXQ+5Mq4WEVxSNK45oJ2wqNZ8LM6YRwVdVdgnm2ARjsBH+dTRreaLR9mmlS1xE9qVTer2qfiBUc61+0=
X-Received: by 2002:a19:6b06:: with SMTP id d6mr8900451lfa.525.1626460810123;
 Fri, 16 Jul 2021 11:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
 <eace208b-fd4a-2a98-5dc7-7262bf7a390c@suse.de> <b43346cc42a2fb11c7f976cb000e5a825c6445bc.camel@suse.com>
In-Reply-To: <b43346cc42a2fb11c7f976cb000e5a825c6445bc.camel@suse.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Fri, 16 Jul 2021 11:39:59 -0700
Message-ID: <CAHZQxyK+nQfd724D7WH2my-ZV19Nzd8f7MMSftfFHg3NCw1Vzg@mail.gmail.com>
Subject: Re: [PATCH] scsi: dm-mpath: do not fail paths when the target returns
 ALUA state transition
To:     Martin Wilck <mwilck@suse.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 16, 2021 at 1:25 AM Martin Wilck <mwilck@suse.com> wrote:
>
> Hannes,
>
> On Fr, 2021-07-16 at 08:27 +0200, Hannes Reinecke wrote:
> > On 7/15/21 6:57 PM, Brian Bunker wrote:
> > > When paths return an ALUA state transition, do not fail those paths.
> > > The expectation is that the transition is short lived until the new
> > > ALUA state is entered. There might not be other paths in an online
> > > state to serve the request which can lead to an unexpected I/O error
> > > on the multipath device.
> > >
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> > > Acked-by: Seamus Connor <sconnor@purestorage.com>
> > > --
> > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > index bced42f082b0..28948cc481f9 100644
> > > --- a/drivers/md/dm-mpath.c
> > > +++ b/drivers/md/dm-mpath.c
> > > @@ -1652,12 +1652,12 @@ static int multipath_end_io(struct dm_target
> > > *ti, struct request *clone,
> > >          if (error && blk_path_error(error)) {
> > >                  struct multipath *m = ti->private;
> > >
> > > -               if (error == BLK_STS_RESOURCE)
> > > +               if (error == BLK_STS_RESOURCE || error ==
> > > BLK_STS_AGAIN)
> > >                          r = DM_ENDIO_DELAY_REQUEUE;
> > >                  else
> > >                          r = DM_ENDIO_REQUEUE;
> > >
> > > -               if (pgpath)
> > > +               if (pgpath && (error != BLK_STS_AGAIN))
> > >                          fail_path(pgpath);
> > >
> > >                  if (!atomic_read(&m->nr_valid_paths) &&
> > > --
> >
> > Sorry, but this will lead to regressions during failover for arrays
> > taking longer time (some take up to 30 minutes for a complete
> > failover).
> > And for those it's absolutely crucial to _not_ retry I/O on the paths
> > in
> > transitioning.
>
> This won't happen.
>
> As argued in https://marc.info/?l=linux-scsi&m=162625194203635&w=2,
> your previous patches avoid the request being requeued on the SCSI
> queue, even with Brian's patch on top. IMO that means that the deadlock
> situation analyzed earlier can't occur. If you disagree, please explain
> in detail.
>
> By not failing the path, the request can be requeued on the dm level,
> and dm can decide to try the transitioning path again. But the request
> wouldn't be added to the SCSI queue, because alua_prep_fn() would
> prevent that.
>
> So, in the worst case, dm would retry queueing the request on the
> transitioning path over and over again. By adding a delay, we avoid
> busy-looping. This has basically the same effect as queueing on the dm
> layer in the first place: the request stays queued on the dm level most
> of the time. Except for the fact that the queueing would stop earlier:
> as soon as the kernel notices that the path is not transitioning any
> more. By not failing the dm paths, we don't depend on user space to
> reinstate them, which is the right thing to do for a transitioning
> state IMO.
>
> > And you already admitted that 'queue_if_no_path' would resolve this
> > problem, so why not update the device configuration in multipath-
> > tools
> > to have the correct setting for your array?

The reason I don't like queue_if_no_path for a solution is that there
are times we do want to tail all of the paths as quickly as possible
(e.g. a cluster sharing a resource). If we add some non zero value to
no_path_retry we would be forcing that configuration to unnecessarily
wait, and those customers will see this delay as a regression. This is
where a distinction between an ALUA state of standby or unavailable
vs. a transition ALUA state is attractive.

>
> I think Brian is right that setting transitioning paths to failed state
> in dm is highly questionable.
>
> So far, in dm-multipath, we haven't set paths to failed state because
> of ALUA state transitions. We've been mapping ALUA states to priorities
> instead. We don't even fail paths in ALUA "unavailable" state, so why
> do it for "transitioning"?
>
> Thanks
> Martin
>
>

Thanks,
Brian

-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
