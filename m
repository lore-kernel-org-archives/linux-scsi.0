Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9396AC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 21:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C2761242
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 21:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhGLVla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhGLVla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 17:41:30 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1643AC0613DD
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jul 2021 14:38:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id b26so13786445lfo.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jul 2021 14:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mklevc/R5KovzmDP+adIiwGymVPkRVyHS2MxHb0OMgM=;
        b=f+61re/HqoEq+rndu80qtznwa7X37+14PmBK7oKMaBCMo7cN6QxWgWhw0vXsImV1UB
         ge2KlP0wdieMENJU/BOFKlyEhbnTAcWoQ7EpgQVBdjKM9A0uOb52mijtA426suDmlwon
         CaKmGci/AtalSCc9jvn9Os3cpMMtbRvK+9jfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mklevc/R5KovzmDP+adIiwGymVPkRVyHS2MxHb0OMgM=;
        b=SUAxxDxOBefpKaKZkHvJT+wPW4hEDnnPAqR4BIU1dlV5lkJJ0AJsmnFZmqiVhOVqtk
         iomfqsHHAyMZUL/PnJIf/Am6fuoNZlXGMH6GFEjLzhQzfXyE894/WOPNF1M/C7AiI6kV
         m+BDM2SlKxnwRcM8vZUCty5sK/+9zn9sY1Ghif1U7wwQrG7nKtcQIVHDPWozGVBQ5c+Y
         vx/aQLq3TQpAn+ac0SIKTQYL8/uLuyHASoG2BDgkDoTU43PKWhFDyPccdm+vPcPKGIgv
         XlSPL2tcnM8G3EfWtcbEkGypjeAeCo2e8g0xsmCznUPX7wnWt3m72x1fK5ZaegeQhMa/
         UuNA==
X-Gm-Message-State: AOAM530n3i6HIQBYkFT4UYTOmeLim/jeWhXQF4jWGxwgnIVDZDUpLgzp
        UsMidfBjToEEonWVy6WMfzUCfJBhm+QYfg7EDYoLNw==
X-Google-Smtp-Source: ABdhPJzTLpWBM+6lPao6y4ScCMIX74RBcUCpUOUdKMEt2Xa7kvuwgjlOSEXUadMnHIfpXCdo/8Ot8/VEh/V6pGDxlEI=
X-Received: by 2002:ac2:592b:: with SMTP id v11mr644333lfi.59.1626125918279;
 Mon, 12 Jul 2021 14:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
 <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
In-Reply-To: <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Mon, 12 Jul 2021 14:38:27 -0700
Message-ID: <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
To:     Martin Wilck <mwilck@suse.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please confirm that your kernel included ee8868c5c78f ("scsi:
scsi_dh_alua: Retry RTPG on a different path after failure").
That commit should cause the RTPG to be retried on other map members
which are not in failed state, thus avoiding this phenomenon.

In my case, there are no other map members that are not in the failed
state. One set of paths goes to the ALUA unavailable state when the
primary fails, and the second set of paths moves to ALUA state
transitioning as the previous secondary becomes the primary. If the
paths are failed which are transitioning, an all paths down state
happens which is not expected. There should be a time for which
transitioning is a transient state until the next state is entered.
Failing a path assuming there would be non-failed paths seems wrong.

The purpose of that patch was to set the state of the transitioning
path to failed in order to make sure IO is retried on a different path.
Your patch would undermine this purpose.

I agree this is what happens but those transitioning paths might be
the only non-failed paths available. I don't think it is reasonable to
fail them. This is the same as treating transitioning as standby or
unavailable. As you point out this happened with the commit you
mention. Before this commit what I am doing does not result in an all
paths down error, and similarly, it does not in earlier Linux versions
or other OS's under the same condition. I see this as a regression.

Thanks,
Brian

On Mon, Jul 12, 2021 at 2:19 AM Martin Wilck <mwilck@suse.com> wrote:
>
> Hello Brian,
>
> On Do, 2021-07-08 at 13:42 -0700, Brian Bunker wrote:
> > In a controller failover do not fail paths that are transitioning or
> > an unexpected I/O error will return when accessing a multipath device.
> >
> > Consider this case, a two controller array with paths coming from a
> > primary and a secondary controller. During any upgrade there will be a
> > transition from a secondary to a primary state.
> >
> > [...]
> > 4. It is not expected that the remaining 4 paths will also fail. This
> > was not the case until the change which introduced BLK_STS_AGAIN into
> > the SCSI ALUA device handler. With that change new I/O which reaches
> > that handler on paths that are in ALUA state transitioning will result
> > in those paths failing. Previous Linux versions, before that change,
> > will not return an I/O error back to the client application.
> > Similarly, this problem does not happen in other operating systems,
> > e.g. ESXi, Windows, AIX, etc.
>
> Please confirm that your kernel included ee8868c5c78f ("scsi:
> scsi_dh_alua: Retry RTPG on a different path after failure").
> That commit should cause the RTPG to be retried on other map members
> which are not in failed state, thus avoiding this phenomenon.
>
>
> > [...]
> >
> > 6. The error gets back to the user of the muitipath device
> > unexpectedly:
> > Thu Jul  8 13:33:59 2021: /opt/Purity/bin/bb/pureload I/O Error: io
> > 43047 fd 36  op read  offset 00000028ef7a7000  size 4096  errno 11
> > rsize -1
> >
> > The earlier patch I made for this was not desirable, so I am proposing
> > this much smaller patch which will similarly not allow the
> > transitioning paths to result in immediate failure.
> >
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> > Acked-by: Seamus Connor <sconnor@purestorage.com>
> >
> > ____
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index bced42f082b0..d5d6be96068d 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1657,7 +1657,7 @@ static int multipath_end_io(struct dm_target
> > *ti, struct request *clone,
> >                 else
> >                         r = DM_ENDIO_REQUEUE;
> >
> > -               if (pgpath)
> > +               if (pgpath && (error != BLK_STS_AGAIN))
> >                         fail_path(pgpath);
> >
> >                 if (!atomic_read(&m->nr_valid_paths) &&
> >
>
> I doubt that this is correct. If you look at the commit msg of
> 268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
> transitioning state"):
>
>
>  "When the ALUA state indicates transitioning we should not retry the command
>  immediately, but rather complete the command with BLK_STS_AGAIN to signal
>  the completion handler that it might be retried.  This allows multipathing
>  to redirect the command to another path if possible, and avoid stalls
>  during lengthy transitioning times."
>
> The purpose of that patch was to set the state of the transitioning
> path to failed in order to make sure IO is retried on a different path.
> Your patch would undermine this purpose.
>
> Regards
> Martin
>
>


-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
