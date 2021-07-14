Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE393C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 00:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF276136D
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 00:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbhGNAk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhGNAk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 20:40:57 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D96C0613DD
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 17:38:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f30so504519lfj.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 17:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KIC76D5QqmN0TWjM6LWR9SvCVXCq0hr2Q5b2O9r3CNY=;
        b=VloO4VR3hcqKlQ1ZuUD1oJAfZ+JafP10wUxZJsALssiOW3Zw8454lxKOULoMhCGZR7
         htc+8dYG3Bye3+Uaw1IyEr9b1ISbpCFaVdrgw6wH4BauScrA+YBRbsCnBOb4kqIvWLIS
         4a+HJXb/gSW6Lh797B5GEcHIK7h9xil1L+tCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KIC76D5QqmN0TWjM6LWR9SvCVXCq0hr2Q5b2O9r3CNY=;
        b=PlhI8RfTHx9MEGtpsIarLYchFAom31PFQu04D0k3jMfYGQZxQF0bqZd3K1f/QloYDp
         tudZf5tFNajZjvkwNJ/CcPZz4epVOk0CuYSJsd35AaWHKX3WyIWCXtZmFhf/D34u+cwR
         /I2xVt/WECGJNbaa4EfGFoPhVd1D3wYePtxU/Nr0ULfBzti9Tz9ktZczzChNXp93GwE2
         MfoRgoGZyprefZXEffsr3Oe+0JImcp24yINs5qUNWxetGH8rMax42vvo4AJUzILmaMCE
         bj3TIAdItymWPuiob9xv0RcBxtoHxaPtF08s8fDT3zv/7mS4mhT9vlXwkntS3JPeOegv
         6djA==
X-Gm-Message-State: AOAM530JFqxk/AYUE2jVJ9Bvo7I4symA1SApsxt2X+rMXFleZAR2gKrU
        Ocjg6XCtcDfdXZCH3VAXx7spGu5gB3T/r6iKkhCx3g==
X-Google-Smtp-Source: ABdhPJwrTET98hoysUB1AE8NzpbOW2udp4PjQCOb6Y9FMLHqfHEcgKeFdrz5lYnYlAvK+EPE3eDZjQjXLR8yWpf33es=
X-Received: by 2002:ac2:5dc3:: with SMTP id x3mr5849143lfq.514.1626223084156;
 Tue, 13 Jul 2021 17:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
 <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com> <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
 <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com> <CAHZQxyLEsQWjTV_P8YPhConyQiOOtzc+oNmuT=Oi1=WMyysmCg@mail.gmail.com>
In-Reply-To: <CAHZQxyLEsQWjTV_P8YPhConyQiOOtzc+oNmuT=Oi1=WMyysmCg@mail.gmail.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Tue, 13 Jul 2021 17:37:53 -0700
Message-ID: <CAHZQxy+crC90wWuHMKA=9CE-gHSiDTEC_jQDnH0Otx=R7PM-SQ@mail.gmail.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
To:     Martin Wilck <mwilck@suse.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 13, 2021 at 2:13 AM Martin Wilck <mwilck@suse.com> wrote:
>
> Hello Brian,
>
> On Mo, 2021-07-12 at 14:38 -0700, Brian Bunker wrote:
> > Martin,
> >
> > > Please confirm that your kernel included ee8868c5c78f ("scsi:
> > > scsi_dh_alua: Retry RTPG on a different path after failure").
> > > That commit should cause the RTPG to be retried on other map
> > > members
> > > which are not in failed state, thus avoiding this phenomenon.
> >
> > In my case, there are no other map members that are not in the failed
> > state. One set of paths goes to the ALUA unavailable state when the
> > primary fails, and the second set of paths moves to ALUA state
> > transitioning as the previous secondary becomes the primary.
>
> IMO this is the problem. How does your array respond to SCSI commands
> while ports are transitioning?
>
> SPC5 (=C2=A75.16.2.6) says that the server should either fail all command=
s
> with BUSY or CHECK CONDITION/NOT READY/LOGICAL UNIT NOT
> ACCESSIBLE/ASYMMETRIC ACCESS STATE TRANSITION (a), or should support
> all TMFs and a subset of SCSI commands, while responding with
> CC/NR/AAST to all other commands (b). SPC6 (=C2=A75.18.2.6) is no differe=
nt.
>
> No matter how you read that paragraph, it's pretty clear that
> "transitioning" is generally not a healthy state to attempt I/O.
>
> Are you saying that on your server, the transitioning ports are able to
> process regular I/O commands like READ and WRITE? If that's the case,
> why do you pretend to be "transitioning" at all, rather than in an
> active state? If it's not the case, why would it make sense for the
> host to retry I/O on the transitioning path?

In the ALUA transitioning state, we cannot process READ or WRITE and
will return with the sense data as you mentioned above. We expect
retries down that transitioning path until it transitions to another
ALUA state (at least for some reasonable period of time for the
transition). The spec defines the state as the transition between
target asymmetric states. The current implementation requires
coordination on the target not to return a state transition down all
paths at the same time or risk all paths being failed. Using the ALUA
transition state allows us to respond to initiator READ and WRITE
requests even if we can't serve them when our internal target state is
transitioning (secondary to primary). The alternative is to queue them
which presents a different set of problems.

>
> >  If the
> > paths are failed which are transitioning, an all paths down state
> > happens which is not expected.
>
> IMO it _is_ expected if in fact no path is able to process SCSI
> commands at the given point in time.

In this case it would seem having all paths move to transitioning
would lead to all paths lost. It is possible to imagine
implementations where for a brief period of time all paths are in a
transitioning state. What would be the point of returning a transient
state if the result is a permanent failure?

>
> >  There should be a time for which
> > transitioning is a transient state until the next state is entered.
> > Failing a path assuming there would be non-failed paths seems wrong.
>
> This is a misunderstanding. The path isn't failed because of
> assumptions about other paths. It is failed because we know that it's
> non-functional, and thus we must try other paths, if there are any.
>
> Before 268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
> transitioning state"), I/O was indeed retried on transitioning paths,
> possibly forever. This posed a serious problem when a transitioning
> path was about to be removed (e.g. dev_loss_tmo expired). And I'm still
> quite convinced that it was wrong in general, because by all reasonable
> means a "transitioning" path isn't usable for the host.
>
> If we find a transitioning path, it might make sense to retry on other
> paths first and eventually switch back to the transitioning path, when
> all others have failed hard (e.g. "unavailable" state). However, this
> logic doesn't exist in the kernel. In theory, it could be mapped to a
> "transitioning" priority group in device-mapper multipath. But prio
> groups are managed in user space (multipathd), which treats
> transitioning paths as "almost failed" (priority 0) anyway. We can
> discuss enhancing multipathd such that it re-checks transitioning paths
> more frequently, in order to be able to reinstate them ASAP.
>
> According to what you said above, the "transitioning" ports in the
> problem situation ("second set") are those that were in "unavailable"
> state before, which means "failed" as far as device mapper is concerned
> - IOW, the paths in question would be unused anyway, until they got
> reinstated, which wouldn't happen before they are fully up. With this
> in mind, I have to say I don't understand why your proposed patch would
> help at all. Please explain.
>

My proposed patch would not fail the paths in the case of
BLK_STS_AGAIN. This seems to result in the requests being retried
until the path transitions to either a failed state, standby or
unavailable, or an online state.

> > > The purpose of that patch was to set the state of the transitioning
> > > path to failed in order to make sure IO is retried on a different  >
> > path.
> > > Your patch would undermine this purpose.
>
> (Additional indentation added by me) Can you please use proper quoting?
> You were mixing my statements and your own.
>
> > I agree this is what happens but those transitioning paths might be
> > the only non-failed paths available. I don't think it is reasonable
> > to
> > fail them. This is the same as treating transitioning as standby or
> > unavailable.
>
> Right, and according to the SPC spec (see above), that makes more sense
> than treating it as "active".
>
> Storage vendors seem to interpret "transitioning" very differently,
> both in terms of commands supported and in terms of time required to
> reach the target state. That makes it hard to deal with it correctly on
> the host side.
>
> >  As you point out this happened with the commit you
> > mention. Before this commit what I am doing does not result in an all
> > paths down error, and similarly, it does not in earlier Linux
> > versions
> > or other OS's under the same condition. I see this as a regression.
>
> If you use a suitable "no_path_retry" setting in multipathd, you should
> be able to handle the situation you describe just fine by queueing the
> I/O until the transitioning paths are fully up. IIUC, on your server
> "transitioning" is a transient state that ends quickly, so queueing
> shouldn't be an issue. E.g. if you are certain that "transitioning"
> won't last longer than 10s, you could set "no_path_retry 2".
>
> Regards,
> Martin
>
>
>

I have tested using the no_path_retry and you are correct that it does
work around the issue that I am seeing. The problem with that is are times
we want to convey all paths down to the initiator as quickly
as possible and doing this will delay that.

Thanks,
Brian

Brian Bunker
PURE Storage, Inc.
brian@purestorage.com

On Tue, Jul 13, 2021 at 5:32 PM Brian Bunker <brian@purestorage.com> wrote:
>
> On Tue, Jul 13, 2021 at 2:13 AM Martin Wilck <mwilck@suse.com> wrote:
> >
> > Hello Brian,
> >
> > On Mo, 2021-07-12 at 14:38 -0700, Brian Bunker wrote:
> > > Martin,
> > >
> > > > Please confirm that your kernel included ee8868c5c78f ("scsi:
> > > > scsi_dh_alua: Retry RTPG on a different path after failure").
> > > > That commit should cause the RTPG to be retried on other map
> > > > members
> > > > which are not in failed state, thus avoiding this phenomenon.
> > >
> > > In my case, there are no other map members that are not in the failed
> > > state. One set of paths goes to the ALUA unavailable state when the
> > > primary fails, and the second set of paths moves to ALUA state
> > > transitioning as the previous secondary becomes the primary.
> >
> > IMO this is the problem. How does your array respond to SCSI commands
> > while ports are transitioning?
> >
> > SPC5 (=C2=A75.16.2.6) says that the server should either fail all comma=
nds
> > with BUSY or CHECK CONDITION/NOT READY/LOGICAL UNIT NOT
> > ACCESSIBLE/ASYMMETRIC ACCESS STATE TRANSITION (a), or should support
> > all TMFs and a subset of SCSI commands, while responding with
> > CC/NR/AAST to all other commands (b). SPC6 (=C2=A75.18.2.6) is no diffe=
rent.
> >
> > No matter how you read that paragraph, it's pretty clear that
> > "transitioning" is generally not a healthy state to attempt I/O.
> >
> > Are you saying that on your server, the transitioning ports are able to
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
> transitioning state allows us to respond to initiator READ and WRITE
> requests even if we can't serve them when our internal target state is
> transitioning (secondary to primary). The alternative is to queue them
> which presents a different set of problems.
>
> >
> > >  If the
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
>
> >
> > >  There should be a time for which
> > > transitioning is a transient state until the next state is entered.
> > > Failing a path assuming there would be non-failed paths seems wrong.
> >
> > This is a misunderstanding. The path isn't failed because of
> > assumptions about other paths. It is failed because we know that it's
> > non-functional, and thus we must try other paths, if there are any.
> >
> > Before 268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
> > transitioning state"), I/O was indeed retried on transitioning paths,
> > possibly forever. This posed a serious problem when a transitioning
> > path was about to be removed (e.g. dev_loss_tmo expired). And I'm still
> > quite convinced that it was wrong in general, because by all reasonable
> > means a "transitioning" path isn't usable for the host.
> >
> > If we find a transitioning path, it might make sense to retry on other
> > paths first and eventually switch back to the transitioning path, when
> > all others have failed hard (e.g. "unavailable" state). However, this
> > logic doesn't exist in the kernel. In theory, it could be mapped to a
> > "transitioning" priority group in device-mapper multipath. But prio
> > groups are managed in user space (multipathd), which treats
> > transitioning paths as "almost failed" (priority 0) anyway. We can
> > discuss enhancing multipathd such that it re-checks transitioning paths
> > more frequently, in order to be able to reinstate them ASAP.
> >
> > According to what you said above, the "transitioning" ports in the
> > problem situation ("second set") are those that were in "unavailable"
> > state before, which means "failed" as far as device mapper is concerned
> > - IOW, the paths in question would be unused anyway, until they got
> > reinstated, which wouldn't happen before they are fully up. With this
> > in mind, I have to say I don't understand why your proposed patch would
> > help at all. Please explain.
> >
>
> My proposed patch would not fail the paths in the case of
> BLK_STS_AGAIN. This seems to result in the requests being retried
> until the path transitions to either a failed state, standby or
> unavailable, or an online state.
>
> > > > The purpose of that patch was to set the state of the transitioning
> > > > path to failed in order to make sure IO is retried on a different  =
>
> > > path.
> > > > Your patch would undermine this purpose.
> >
> > (Additional indentation added by me) Can you please use proper quoting?
> > You were mixing my statements and your own.
> >
> > > I agree this is what happens but those transitioning paths might be
> > > the only non-failed paths available. I don't think it is reasonable
> > > to
> > > fail them. This is the same as treating transitioning as standby or
> > > unavailable.
> >
> > Right, and according to the SPC spec (see above), that makes more sense
> > than treating it as "active".
> >
> > Storage vendors seem to interpret "transitioning" very differently,
> > both in terms of commands supported and in terms of time required to
> > reach the target state. That makes it hard to deal with it correctly on
> > the host side.
> >
> > >  As you point out this happened with the commit you
> > > mention. Before this commit what I am doing does not result in an all
> > > paths down error, and similarly, it does not in earlier Linux
> > > versions
> > > or other OS's under the same condition. I see this as a regression.
> >
> > If you use a suitable "no_path_retry" setting in multipathd, you should
> > be able to handle the situation you describe just fine by queueing the
> > I/O until the transitioning paths are fully up. IIUC, on your server
> > "transitioning" is a transient state that ends quickly, so queueing
> > shouldn't be an issue. E.g. if you are certain that "transitioning"
> > won't last longer than 10s, you could set "no_path_retry 2".
> >
> > Regards,
> > Martin
> >
> >
> >
>
> I have tested using the no_path_retry and you are correct that it does
> work around the issue that I am seeing. The problem with that is there
> are times we want to convey all paths down to the initiator as quickly
> as possible and doing this will delay that.
>
> Thanks,
> Brian
>
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com



--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
