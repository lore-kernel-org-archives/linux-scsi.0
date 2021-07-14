Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C228C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 00:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FCA6136D
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 00:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhGNAfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbhGNAfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 20:35:43 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D20C0613DD
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 17:32:51 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t17so531442lfq.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xJLS8BEy2IWawqBmayttffIfAs0ViqLd29scY4/I7BA=;
        b=cxyNOScn8lJIX4+axaGs0RJBlq7wzDVcJCoDeJLthuGZkmFt3VR38EqLKVSke4AKkt
         bhtV1ytBXwWVV8WGMkV86KX+O+MWZSEsg/Fevg6xHkfX/YgBewyrZfp2AH4q17C44IUQ
         hQeLvMaQuuuSwRa36njIvas/swAdHgP4ddg28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xJLS8BEy2IWawqBmayttffIfAs0ViqLd29scY4/I7BA=;
        b=Q6+/JtpM+YeamzcimYp663TQKfz6IxnPkJOCMKs52PdoVETMJIL4Ydvn9GaotlduoW
         br+e5EmUOATMiVSemB+oonaUpnzQF/LKY/xlRUr/AWwtAgk7KFJcxhq9xQ1QCT/k0mAg
         dphRFIIW1q3vH3FeUDu1UN4JqAEqz651ZM7pL1tCTiXsSXI2A/y7d2dQqKtX1n/rP4+A
         YKB0ruVEhpbpW7WAlYKjzR852mDtPP131lLluRA3geraj9XBIigH+y0itGMBgggIvQaj
         nNXE63TRwVRM2RMfbhKZmN3/wNr6eOIGogL2To88uzsQRFZlaPvs/gd3P7pUa9dDxnmF
         /4gg==
X-Gm-Message-State: AOAM532XK+4F8a7B/ZpT4gnQv54z5HMTUSyMBgxdZWWMAsmlPl7n15J5
        qd8mut5lozOg+3Xp1pRtenUpv1HUrKJfUxTIS9qnKQ==
X-Google-Smtp-Source: ABdhPJyc5Ukh+EpwGJ8Tpofc23+YCdUgLDnn8OsgSC+dAhMKQtaU8suLsXXLCthnhpvqRFFnEaGjoZ2oI5djM+9Zw2s=
X-Received: by 2002:ac2:4e15:: with SMTP id e21mr5568614lfr.245.1626222769797;
 Tue, 13 Jul 2021 17:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
 <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com> <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
 <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com>
In-Reply-To: <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Tue, 13 Jul 2021 17:32:38 -0700
Message-ID: <CAHZQxyLEsQWjTV_P8YPhConyQiOOtzc+oNmuT=Oi1=WMyysmCg@mail.gmail.com>
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
transitioning state allows us to respond to initiator READ and WRITE
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
work around the issue that I am seeing. The problem with that is there
are times we want to convey all paths down to the initiator as quickly
as possible and doing this will delay that.

Thanks,
Brian

Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
