Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E55C12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC82613D6
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhGNVJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:09:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55180 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbhGNVJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 17:09:09 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9E5D2202D5;
        Wed, 14 Jul 2021 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626296776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DJb0dKj4aj+q50I6rF1YT6HHWwJTgnoT08vDnIwjk0=;
        b=N4e3Sv2w/cFGNB/z3Qom9BPATinh/1NLh41GLEPvLbD0F3ZZUBQGxFIqqqIdzAnrFdE/qu
        ZgF5H7FmTfKD7tIOP12Bg/ip8s4WlY5W2tByf1cooTmma70ZmkILK1vnX7PlG0bLji6+sf
        oP/g7+xkwLygS3H9IvjrEvSjvX89wiw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 733A513C14;
        Wed, 14 Jul 2021 21:06:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5B77GchR72CUYAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 14 Jul 2021 21:06:16 +0000
Message-ID: <2733dbd6e8da6510c1b5f3407661717fa3f1d52c.camel@suse.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Wed, 14 Jul 2021 23:06:15 +0200
In-Reply-To: <CAHZQxy++GoK=XJv1UoO1zGvoUNfKK6RrASbctGeUA6zt80RuhA@mail.gmail.com>
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
         <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
         <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
         <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com>
         <CAHZQxyLEsQWjTV_P8YPhConyQiOOtzc+oNmuT=Oi1=WMyysmCg@mail.gmail.com>
         <CAHZQxy+crC90wWuHMKA=9CE-gHSiDTEC_jQDnH0Otx=R7PM-SQ@mail.gmail.com>
         <3ec7da52f5645d2cd139fce7f00243f4746e9b18.camel@suse.com>
         <CAHZQxy++GoK=XJv1UoO1zGvoUNfKK6RrASbctGeUA6zt80RuhA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mi, 2021-07-14 at 11:13 -0700, Brian Bunker wrote:
> On Wed, Jul 14, 2021 at 1:39 AM Martin Wilck <mwilck@suse.com> wrote:
> 
> > 
> > When a command fails with ALUA TRANSITIONING status, we must make
> > sure
> > that:
> > 
> >  1) The command itself is not retried on the path at hand, neither
> > on
> > the SCSI layer nor on the blk-mq layer. The former was the case
> > anyway,
> > the latter is guaranteed by 0d88232010d5 ("scsi: core: Return
> > BLK_STS_AGAIN for ALUA transitioning").
> > 
> >  2) No new commands are sent down this path until it reaches a
> > usable
> > final state. This is achieved on the SCSI layer by alua_prep_fn(),
> > with
> > 268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
> > transitioning state").
> > 
> > These two items would still be true with your patch applied.
> > However,
> > the problem is that if the path isn't failed, dm-multipath would
> > continue sending I/O down this path. If the path isn't set to
> > failed
> > state, the path selector algorithm may or may not choose a
> > different
> > path next time. In the worst case, dm-multipath would busy-loop
> > retrying the I/O on the same path. Please consider the following:
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 86518aec32b4..3f3a89fc2b3b 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1654,12 +1654,12 @@ static int multipath_end_io(struct
> > dm_target *ti, struct request *clone,
> >         if (error && blk_path_error(error)) {
> >                 struct multipath *m = ti->private;
> > 
> > -               if (error == BLK_STS_RESOURCE)
> > +               if (error == BLK_STS_RESOURCE || error ==
> > BLK_STS_AGAIN)
> >                         r = DM_ENDIO_DELAY_REQUEUE;
> >                 else
> >                         r = DM_ENDIO_REQUEUE;
> > 
> > -               if (pgpath)
> > +               if (pgpath && (error != BLK_STS_AGAIN))
> >                         fail_path(pgpath);
> > 
> > This way we'd avoid busy-looping by delaying the retry. This would
> > cause I/O delay in the case where some healthy paths are still in
> > the
> > same dm-multipath priority group as the transitioning path. I
> > suppose
> > this is a minor problem, because in the default case for ALUA
> > (group_by_prio in multipathd), all paths in the PG would have
> > switched
> > to "transitioning" simultaneously.
> > 
> > Note that multipathd assigns priority 0 (the same prio as
> > "unavailable") if it happens to notice a "transitioning" path. This
> > is
> > something we may want to change eventually. In your specific case,
> > it
> > would cause the paths to be temporarily re-grouped, all paths being
> > moved to the same non-functional PG. The way you describe it, for
> > your
> > storage at least, "transitioning" should be assigned a higher
> > priority.
> > > 
> > 
> 
> Yes. I tried it with this change and it works. Should I re-submit
> this
> modified version or do you want to do it? 

Yes, please.

Regards,
Martin


