Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313ABC07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 08:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180AF6128B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 08:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhGPI2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 04:28:46 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39036 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbhGPI2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 04:28:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A1CB422B4E;
        Fri, 16 Jul 2021 08:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626423949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LiLGxALwk/Sv5xzCWTuKh+0llAu+NKXikKfPwa8Xhk=;
        b=T+NMw3A7xwnEg1HcWnQ/tQ5usbs/EklbHHVGmUynUWofDaxB2mgO1buU6a6DyA87Nu+zLu
        3dXORq4XI29eonACf6hWLA6bW5CFLHKJUij7gCF08XvpH+AxyqwxAuAXmIhQc4mkYeEbB7
        2NkPGGKG6erjNIQaCkNlVDFpYCY+erE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6B03613C69;
        Fri, 16 Jul 2021 08:25:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZoLzF41C8WC/YQAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 16 Jul 2021 08:25:49 +0000
Message-ID: <b43346cc42a2fb11c7f976cb000e5a825c6445bc.camel@suse.com>
Subject: Re: [PATCH] scsi: dm-mpath: do not fail paths when the target
 returns ALUA state transition
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>
Date:   Fri, 16 Jul 2021 10:25:48 +0200
In-Reply-To: <eace208b-fd4a-2a98-5dc7-7262bf7a390c@suse.de>
References: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
         <eace208b-fd4a-2a98-5dc7-7262bf7a390c@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes,

On Fr, 2021-07-16 at 08:27 +0200, Hannes Reinecke wrote:
> On 7/15/21 6:57 PM, Brian Bunker wrote:
> > When paths return an ALUA state transition, do not fail those paths.
> > The expectation is that the transition is short lived until the new
> > ALUA state is entered. There might not be other paths in an online
> > state to serve the request which can lead to an unexpected I/O error
> > on the multipath device.
> > 
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> > Acked-by: Seamus Connor <sconnor@purestorage.com>
> > --
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index bced42f082b0..28948cc481f9 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1652,12 +1652,12 @@ static int multipath_end_io(struct dm_target
> > *ti, struct request *clone,
> >          if (error && blk_path_error(error)) {
> >                  struct multipath *m = ti->private;
> > 
> > -               if (error == BLK_STS_RESOURCE)
> > +               if (error == BLK_STS_RESOURCE || error ==
> > BLK_STS_AGAIN)
> >                          r = DM_ENDIO_DELAY_REQUEUE;
> >                  else
> >                          r = DM_ENDIO_REQUEUE;
> > 
> > -               if (pgpath)
> > +               if (pgpath && (error != BLK_STS_AGAIN))
> >                          fail_path(pgpath);
> > 
> >                  if (!atomic_read(&m->nr_valid_paths) &&
> > --
> 
> Sorry, but this will lead to regressions during failover for arrays 
> taking longer time (some take up to 30 minutes for a complete
> failover).
> And for those it's absolutely crucial to _not_ retry I/O on the paths
> in 
> transitioning.

This won't happen.

As argued in https://marc.info/?l=linux-scsi&m=162625194203635&w=2,
your previous patches avoid the request being requeued on the SCSI
queue, even with Brian's patch on top. IMO that means that the deadlock
situation analyzed earlier can't occur. If you disagree, please explain
in detail.

By not failing the path, the request can be requeued on the dm level,
and dm can decide to try the transitioning path again. But the request
wouldn't be added to the SCSI queue, because alua_prep_fn() would
prevent that. 

So, in the worst case, dm would retry queueing the request on the
transitioning path over and over again. By adding a delay, we avoid
busy-looping. This has basically the same effect as queueing on the dm
layer in the first place: the request stays queued on the dm level most
of the time. Except for the fact that the queueing would stop earlier:
as soon as the kernel notices that the path is not transitioning any
more. By not failing the dm paths, we don't depend on user space to
reinstate them, which is the right thing to do for a transitioning
state IMO.

> And you already admitted that 'queue_if_no_path' would resolve this 
> problem, so why not update the device configuration in multipath-
> tools 
> to have the correct setting for your array?

I think Brian is right that setting transitioning paths to failed state
in dm is highly questionable.

So far, in dm-multipath, we haven't set paths to failed state because
of ALUA state transitions. We've been mapping ALUA states to priorities
instead. We don't even fail paths in ALUA "unavailable" state, so why
do it for "transitioning"?

Thanks
Martin


