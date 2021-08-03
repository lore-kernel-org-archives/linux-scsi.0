Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08545C4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 22:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8FF600EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 22:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhHCWJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 18:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHCWJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 18:09:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892A7C061757
        for <linux-scsi@vger.kernel.org>; Tue,  3 Aug 2021 15:09:17 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id c16so1079781lfc.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Aug 2021 15:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZcdSrPnrlxA/BFQBwtGCMOgA2xpA1nJhAuYQJdN18JA=;
        b=U1JpWbUwjtZmK8MoPzFsn/kmN9T4fqoEYAy7aWCKlZ0rdrbpQFwiOFJbgqVAXKv3fu
         mygMh8p/9fyyu95TMUGTp07SbAzcDFDmyWUhILOILhpjAOi87mvP13PggJyCwpNLPWFl
         Lro9O2DOAhQhb2heLhlmGYHbrqxeEbiBsTLyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZcdSrPnrlxA/BFQBwtGCMOgA2xpA1nJhAuYQJdN18JA=;
        b=jGQIXdZ9H8ZIR8ZoLoZKLzlU6RZnRT4J76387Xpu/xcL5KT7CbHCaZeV/xTlDg4xzE
         ED4WrIA7VSWF3YC3kjxAT+NUDfvHcVO16qiOZkr4m1iauM8ghxAp0GD9nE/B/2/l+xwr
         J7LFD9vPA1n2XksVC5LRSME0WIMo86z3GSkmRL9h+NG5vB8vnZBIVgUm37mFPXChbkNL
         do4plCBykwTP8s/BSDDvZxE46bRcXj6JElUgfzwYltnba9AjBr3K7IaDksOS5yvsriGe
         Oh6V9R4szYH/PZa5mzXmjh8Cc73aoYO0w+QczHEsF2Rm1n+P7SY4t0jU67c9wCHyqcD8
         jYdg==
X-Gm-Message-State: AOAM531voq17Ludgqf3QOugtqSmqky8QeTAR3RpXMIYt/uzLMiZyOjQN
        MkH7VMhwQyfsgAwzzeszXMJfzdgAXKeNiK7Fc0hn4w==
X-Google-Smtp-Source: ABdhPJzZnVTzt+EHctZS+OWmQTXP+U6LwDuRc/jLJV5X1V4D57BsVq0/qGTAISAKiGOyDqWNhrONSDtaZRFJse5LjTk=
X-Received: by 2002:a05:6512:3f9c:: with SMTP id x28mr14491496lfa.245.1628028555850;
 Tue, 03 Aug 2021 15:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
 <eace208b-fd4a-2a98-5dc7-7262bf7a390c@suse.de> <b43346cc42a2fb11c7f976cb000e5a825c6445bc.camel@suse.com>
 <CAHZQxyK+nQfd724D7WH2my-ZV19Nzd8f7MMSftfFHg3NCw1Vzg@mail.gmail.com>
In-Reply-To: <CAHZQxyK+nQfd724D7WH2my-ZV19Nzd8f7MMSftfFHg3NCw1Vzg@mail.gmail.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Tue, 3 Aug 2021 15:09:04 -0700
Message-ID: <CAHZQxyLNvnuRK_MacrkXCJzggkZqMJu_RvBwU8xk2n1aFiu-dQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: dm-mpath: do not fail paths when the target returns
 ALUA state transition
To:     Martin Wilck <mwilck@suse.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin and Hannes,

Any resolution to this issue?

Thanks,
Brian

On Fri, Jul 16, 2021 at 11:39 AM Brian Bunker <brian@purestorage.com> wrote:
>
> On Fri, Jul 16, 2021 at 1:25 AM Martin Wilck <mwilck@suse.com> wrote:
> >
> > Hannes,
> >
> > On Fr, 2021-07-16 at 08:27 +0200, Hannes Reinecke wrote:
> > > On 7/15/21 6:57 PM, Brian Bunker wrote:
> > > > When paths return an ALUA state transition, do not fail those paths.
> > > > The expectation is that the transition is short lived until the new
> > > > ALUA state is entered. There might not be other paths in an online
> > > > state to serve the request which can lead to an unexpected I/O error
> > > > on the multipath device.
> > > >
> > > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > > > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> > > > Acked-by: Seamus Connor <sconnor@purestorage.com>
> > > > --
> > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > index bced42f082b0..28948cc481f9 100644
> > > > --- a/drivers/md/dm-mpath.c
> > > > +++ b/drivers/md/dm-mpath.c
> > > > @@ -1652,12 +1652,12 @@ static int multipath_end_io(struct dm_target
> > > > *ti, struct request *clone,
> > > >          if (error && blk_path_error(error)) {
> > > >                  struct multipath *m = ti->private;
> > > >
> > > > -               if (error == BLK_STS_RESOURCE)
> > > > +               if (error == BLK_STS_RESOURCE || error ==
> > > > BLK_STS_AGAIN)
> > > >                          r = DM_ENDIO_DELAY_REQUEUE;
> > > >                  else
> > > >                          r = DM_ENDIO_REQUEUE;
> > > >
> > > > -               if (pgpath)
> > > > +               if (pgpath && (error != BLK_STS_AGAIN))
> > > >                          fail_path(pgpath);
> > > >
> > > >                  if (!atomic_read(&m->nr_valid_paths) &&
> > > > --
> > >
> > > Sorry, but this will lead to regressions during failover for arrays
> > > taking longer time (some take up to 30 minutes for a complete
> > > failover).
> > > And for those it's absolutely crucial to _not_ retry I/O on the paths
> > > in
> > > transitioning.
> >
> > This won't happen.
> >
> > As argued in https://marc.info/?l=linux-scsi&m=162625194203635&w=2,
> > your previous patches avoid the request being requeued on the SCSI
> > queue, even with Brian's patch on top. IMO that means that the deadlock
> > situation analyzed earlier can't occur. If you disagree, please explain
> > in detail.
> >
> > By not failing the path, the request can be requeued on the dm level,
> > and dm can decide to try the transitioning path again. But the request
> > wouldn't be added to the SCSI queue, because alua_prep_fn() would
> > prevent that.
> >
> > So, in the worst case, dm would retry queueing the request on the
> > transitioning path over and over again. By adding a delay, we avoid
> > busy-looping. This has basically the same effect as queueing on the dm
> > layer in the first place: the request stays queued on the dm level most
> > of the time. Except for the fact that the queueing would stop earlier:
> > as soon as the kernel notices that the path is not transitioning any
> > more. By not failing the dm paths, we don't depend on user space to
> > reinstate them, which is the right thing to do for a transitioning
> > state IMO.
> >
> > > And you already admitted that 'queue_if_no_path' would resolve this
> > > problem, so why not update the device configuration in multipath-
> > > tools
> > > to have the correct setting for your array?
>
> The reason I don't like queue_if_no_path for a solution is that there
> are times we do want to tail all of the paths as quickly as possible
> (e.g. a cluster sharing a resource). If we add some non zero value to
> no_path_retry we would be forcing that configuration to unnecessarily
> wait, and those customers will see this delay as a regression. This is
> where a distinction between an ALUA state of standby or unavailable
> vs. a transition ALUA state is attractive.
>
> >
> > I think Brian is right that setting transitioning paths to failed state
> > in dm is highly questionable.
> >
> > So far, in dm-multipath, we haven't set paths to failed state because
> > of ALUA state transitions. We've been mapping ALUA states to priorities
> > instead. We don't even fail paths in ALUA "unavailable" state, so why
> > do it for "transitioning"?
> >
> > Thanks
> > Martin
> >
> >
>
> Thanks,
> Brian
>
> --
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com



-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
