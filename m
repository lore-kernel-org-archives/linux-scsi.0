Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF28BC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 08:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3565613AF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 08:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbhGNIlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 04:41:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56982 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbhGNIlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 04:41:51 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7AAD4229A1;
        Wed, 14 Jul 2021 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626251939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DwjroXhMnpMrEhAp1gXz+s/TiKg7rtnyrdbKGQXVDXc=;
        b=vR6eSoNXTkqda/phlGf2KhCM6wLnnzY6sXaPa1bv/7ir8cWiQRJDQ5s8kec7ftTBzz/47s
        d1N+uP6SMht/gorDr23WYQ3RImQqA96z3/xvvkhsz/EjbAzpFSU6x8fA3+KHftLIyjEXNL
        iTHBuzfuVX604aSLeFUsEvTls8u3qN0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 373B013BEC;
        Wed, 14 Jul 2021 08:38:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id roXmCKOi7mBiEAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 14 Jul 2021 08:38:59 +0000
Message-ID: <3ec7da52f5645d2cd139fce7f00243f4746e9b18.camel@suse.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Wed, 14 Jul 2021 10:38:57 +0200
In-Reply-To: <CAHZQxy+crC90wWuHMKA=9CE-gHSiDTEC_jQDnH0Otx=R7PM-SQ@mail.gmail.com>
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
         <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
         <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
         <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com>
         <CAHZQxyLEsQWjTV_P8YPhConyQiOOtzc+oNmuT=Oi1=WMyysmCg@mail.gmail.com>
         <CAHZQxy+crC90wWuHMKA=9CE-gHSiDTEC_jQDnH0Otx=R7PM-SQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Di, 2021-07-13 at 17:37 -0700, Brian Bunker wrote:
> On Tue, Jul 13, 2021 at 2:13 AM Martin Wilck <mwilck@suse.com> wrote:
> > Are you saying that on your server, the transitioning ports are able
> > to
> > process regular I/O commands like READ and WRITE? If that's the case,
> > why do you pretend to be "transitioning" at all, rather than in an
> > active state? If it's not the case, why would it make sense for the
> > host to retry I/O on the transitioning path?
> 
> In the ALUA transitioning state, we cannot process READ or WRITE and
> will return with the sense data as you mentioned above. We expect
> retries down that transitioning path until it transitions to another
> ALUA state (at least for some reasonable period of time for the
> transition). The spec defines the state as the transition between
> target asymmetric states. The current implementation requires
> coordination on the target not to return a state transition down all
> paths at the same time or risk all paths being failed. Using the ALUA
> transition state allows us to respond to initiator READ and WRITE
> requests even if we can't serve them when our internal target state is
> transitioning (secondary to primary). The alternative is to queue them
> which presents a different set of problems.

Indeed, it would be less prone to host-side errors if the "new"
pathgroup went to a usable state before the "old" pathgroup got
unavailable. Granted, this may be difficult to guarantee on the storage
side.

> > >  If the
> > > paths are failed which are transitioning, an all paths down state
> > > happens which is not expected.
> > 
> > IMO it _is_ expected if in fact no path is able to process SCSI
> > commands at the given point in time.
> 
> In this case it would seem having all paths move to transitioning
> would lead to all paths lost. It is possible to imagine
> implementations where for a brief period of time all paths are in a
> transitioning state. What would be the point of returning a transient
> state if the result is a permanent failure?

When a command fails with ALUA TRANSITIONING status, we must make sure
that:

 1) The command itself is not retried on the path at hand, neither on
the SCSI layer nor on the blk-mq layer. The former was the case anyway,
the latter is guaranteed by 0d88232010d5 ("scsi: core: Return
BLK_STS_AGAIN for ALUA transitioning").

 2) No new commands are sent down this path until it reaches a usable
final state. This is achieved on the SCSI layer by alua_prep_fn(), with
268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
transitioning state").

These two items would still be true with your patch applied. However,
the problem is that if the path isn't failed, dm-multipath would
continue sending I/O down this path. If the path isn't set to failed
state, the path selector algorithm may or may not choose a different
path next time. In the worst case, dm-multipath would busy-loop
retrying the I/O on the same path. Please consider the following:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 86518aec32b4..3f3a89fc2b3b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1654,12 +1654,12 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
        if (error && blk_path_error(error)) {
                struct multipath *m = ti->private;
 
-               if (error == BLK_STS_RESOURCE)
+               if (error == BLK_STS_RESOURCE || error == BLK_STS_AGAIN)
                        r = DM_ENDIO_DELAY_REQUEUE;
                else
                        r = DM_ENDIO_REQUEUE;
 
-               if (pgpath)
+               if (pgpath && (error != BLK_STS_AGAIN))
                        fail_path(pgpath);

This way we'd avoid busy-looping by delaying the retry. This would
cause I/O delay in the case where some healthy paths are still in the
same dm-multipath priority group as the transitioning path. I suppose
this is a minor problem, because in the default case for ALUA
(group_by_prio in multipathd), all paths in the PG would have switched
to "transitioning" simultaneously.
 
Note that multipathd assigns priority 0 (the same prio as
"unavailable") if it happens to notice a "transitioning" path. This is
something we may want to change eventually. In your specific case, it
would cause the paths to be temporarily re-grouped, all paths being
moved to the same non-functional PG. The way you describe it, for your
storage at least, "transitioning" should be assigned a higher priority.
> 

> > If you use a suitable "no_path_retry" setting in multipathd, you
> > should
> > be able to handle the situation you describe just fine by queueing
> > the
> > I/O until the transitioning paths are fully up. IIUC, on your
> > server
> > "transitioning" is a transient state that ends quickly, so queueing
> > shouldn't be an issue. E.g. if you are certain that "transitioning"
> > won't last longer than 10s, you could set "no_path_retry 2".
> 
> I have tested using the no_path_retry and you are correct that it
> does
> work around the issue that I am seeing. The problem with that is are
> times
> we want to convey all paths down to the initiator as quickly
> as possible and doing this will delay that.

Ok, that makes sense e.g. for cluster configurations. So, the purpose
is  to distinguish between two cases where no path can process SCSI
commands: a) all paths are really down on the storage, and b) some
paths are down and some are "coming up".

Thanks,
Martin


