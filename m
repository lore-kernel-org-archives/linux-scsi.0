Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA5FC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 02:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354390AbiEUCxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 22:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbiEUCw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 22:52:59 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCCF1912E6
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 19:52:57 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id br17so4868155lfb.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 19:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ms6XoZ31tzmHoW1hzsDoCSlDrcUAqED/ntb7pTx9gX4=;
        b=haQ4a8alOk8D/Dm/iyJNA4SSRr8riCaZE/lUeQuewpUExol9j0sSUzCKE1VRKNEB8h
         vOrYqfnFQJcHw+Q/EF7eR60mE5jGiDcidfbykpIGdw7yJEELMKUXzVXSnI9ClqUAQ6dE
         D6slU6IoL7JvceEfyQuo16cC91/+0WF9BlRAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ms6XoZ31tzmHoW1hzsDoCSlDrcUAqED/ntb7pTx9gX4=;
        b=31dxj9zUFTeqq5zrhpADvR93iyRR0WSwpR+d+splgJScvZNkhTAgonFUqoBaPbbv1I
         clnCMoYgMG3j3zN+1r8tX0JH7mJLvQ3xrEXyoEPl176fjsNhTsx2MNGsYqR9z2v4kqTz
         iS5/3EfKuwdmgrxy2GxW+JAksZnKbu2MrQw+xYPI3rKcuYzy4MNsEv0rSOSHAdVPm/Oh
         jZlLLBwhb6cgF22EPrKNnEKl+um5XGj/lkceCrD3/3aCFYpuxbbWmvZabrZ/7Y4qJ4jT
         Kmvi3tn9WOdBsXaazJI5Ip6necpqbWmRCC7ChpflUApLfxBmaHITJ93xrH+D+VqXDXH6
         fcSA==
X-Gm-Message-State: AOAM531CO7gFskCKn18h1iqRSuUrYB5/NNyEDx3QY0c3Y0+pCcBPEUgJ
        xA7TglAgPIQ0hpEpKG+IVaMxwk/eHH44kr93d3AODg==
X-Google-Smtp-Source: ABdhPJxcdZrIequnJedb2o3eXpbu8XuByacUKkzsjC41MhUZW31Z/YKohfzPfGSY44oPVlV9Sl3r/Ler9Zc3Fq6OZ9Q=
X-Received: by 2002:a05:6512:3c84:b0:478:19f2:bc2e with SMTP id
 h4-20020a0565123c8400b0047819f2bc2emr5194637lfv.324.1653101575357; Fri, 20
 May 2022 19:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com> <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
 <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de> <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
 <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com> <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
In-Reply-To: <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Fri, 20 May 2022 19:52:44 -0700
Message-ID: <CAHZQxyLEOw8jXUzLj8DugbbsVkFP=OMjv-Lkz6LkuayEavYahg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
To:     Martin Wilck <mwilck@suse.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From my perspective, the ALUA transitioning state is a temporary state
where the target is saying that it does not have a permanent state
yet. Having the initiator try another pg to me doesn't seem like the
right thing for it to do. If the target wanted the initiator to use a
different pg, it should use an ALUA state which would make that clear,
standby, unavailable, etc. The target would only return an error state
if it was aware that some other path is in an active state.When
transitioning is returned, I don't think the initiator should assume
that any other pg would be a better choice. I think it should assume
that the target will make its intention clear for that path with a
permanent state within a transition timeout.

From my perspective the right thing to do is to let the ALUA handler
do what it is trying to do. If the pg state is transitioning and
within the transition timeout it should continue to retry that request
checking each time the transition timeout. In most cases the target
will easily change its state within the transition timeout and the
subsequent requests for that pg will either fail if the state has
transitioned to an error state, standby, etc., or the request will be
served as it has transitioned to an active state. If the target
misbehaves for the pg and stays in transition too long then the
handler will change the state from transition to standby and
subsequent I/O will fail on that path.

On Fri, May 20, 2022 at 1:03 PM Martin Wilck <mwilck@suse.com> wrote:
>
> On Fri, 2022-05-20 at 14:08 -0500, Mike Christie wrote:
> > On 5/20/22 9:03 AM, Martin Wilck wrote:
> > > On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
> > > > On 5/20/22 12:57, Martin Wilck wrote:
> > > > > Brian, Martin,
> > > > >
> > > > > sorry, I've overlooked this patch previously. I have to say I
> > > > > think
> > > > > it's wrong and shouldn't have been applied. At least I need
> > > > > more
> > > > > in-
> > > > > depth explanation.
> > > > >
> > > > > On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
> > > > > > On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
> > > > > >
> > > > > > > The handling of the ALUA transitioning state is currently
> > > > > > > broken.
> > > > > > > When
> > > > > > > a target goes into this state, it is expected that the
> > > > > > > target
> > > > > > > is
> > > > > > > allowed to stay in this state for the implicit transition
> > > > > > > timeout
> > > > > > > without a path failure.
> > > > >
> > > > > Can you please show me a quote from the specs on which this
> > > > > expectation
> > > > > ("without a path failure") is based? AFAIK the SCSI specs don't
> > > > > say
> > > > > anything about device-mapper multipath semantics.
> > > > >
> > > > > > > The handler has this logic, but it gets
> > > > > > > skipped currently.
> > > > > > >
> > > > > > > When the target transitions, there is in-flight I/O from
> > > > > > > the
> > > > > > > initiator. The first of these responses from the target
> > > > > > > will be
> > > > > > > a
> > > > > > > unit
> > > > > > > attention letting the initiator know that the ALUA state
> > > > > > > has
> > > > > > > changed.
> > > > > > > The remaining in-flight I/Os, before the initiator finds
> > > > > > > out
> > > > > > > that
> > > > > > > the
> > > > > > > portal state has changed, will return not ready, ALUA state
> > > > > > > is
> > > > > > > transitioning. The portal state will change to
> > > > > > > SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new
> > > > > > > I/O
> > > > > > > immediately failing the path unexpectedly. The path failure
> > > > > > > happens
> > > > > > > in
> > > > > > > less than a second instead of the expected successes until
> > > > > > > the
> > > > > > > transition timer is exceeded.
> > > > >
> > > > > dm multipath has no concept of "transitioning" state. Path
> > > > > state
> > > > > can be
> > > > > either active or inactive. As Brian wrote, commands sent to the
> > > > > transitioning device will return NOT READY, TRANSITIONING, and
> > > > > require
> > > > > retries on the SCSI layer. If we know this in advance, why
> > > > > should
> > > > > we
> > > > > continue sending I/O down this semi-broken path? If other,
> > > > > healthy
> > > > > paths are available, why it would it not be the right thing to
> > > > > switch
> > > > > I/O to them ASAP?
> > > > >
> > > > But we do, don't we?
> > > > Commands are being returned with the appropriate status, and
> > > > dm-multipath should make the corresponding decisions here.
> > > > This patch just modifies the check when _sending_ commands; ie
> > > > multipath
> > > > had decided that the path is still usable.
> > > > Question rather would be why multipath did that;
> > >
> > > If alua_prep_fn() got called, the path was considered usable at the
> > > given point in time by dm-multipath. Most probably the reason was
> > > simply that no error condition had occured on this path before ALUA
> > > state switched to transitioning. I suppose this can happen
> > > if storage
> > > switches a PG consisting of multiple paths to TRANSITIONING. We get
> > > an
> > > error on one path (sda, say), issue an RTPG, and receive the new
> > > ALUA
> > > state for all paths of the PG. For all paths except sda, we'd just
> > > see
> > > a switch to TRANSITIONING without a previous SCSI error.
> > >
> > > With this patch, we'll dispatch I/O (usually an entire bunch) to
> > > these
> > > paths despite seeing them in TRANSITIONING state. Eventually, when
> > > the
> > > SCSI responses are received, this leads to path failures. If I/O
> > > latencies are small, this happens after a few ms. In that case, the
> > > goal of Brian's patch is not reached, because the time until path
> > > failure would still be on the order of milliseconds. OTOH, if
> > > latencies
> > > are high, it takes substantially longer for the kernel to realize
> > > that
> > > the path is non-functional, while other, good paths may be idle. I
> > > fail
> > > to see the benefit.
> > >
> >
> > I'm not sure everyone agrees with you on the meaning of
> > transitioning.
> >
> > If we go from non-optimized to optimized or standby to non-
> > opt/optimized
> > we don't want to try other paths because it can cause thrashing.
>
> But only with explicit ALUA, or am I missing something? I agree that
> the host shouldn't initiate a PG switch if it encounters transitioning
> state. I also agree that for transitioning towards a "better" state,
> e.g. standby to (non)-optimized, failing the path would be
> questionable. Unfortunately we don't know in which "direction" the path
> is transitioning - it could be for 'better' or 'worse'. I suppose that
> in the case of a PG switch, it can happen that we dispatch I/O to a
> device that used to be in Standby and is now transitioning. Would it
> make sense to remember the previous state and "guess" what we're going
> to transition to? I.e. if the previous state was "Standby", it's
> probably going to be (non)optimized after the transition, and vice-
> versa?
>
> >  We just
> > need to transition resources before we can fully use the path. It
> > could
> > be a local cache operation or for distributed targets it could be a
> > really
> > expensive operation.
> >
> > For both though, it can take longer than the retries we get from
> > scsi-ml.
>
> So if we want to do "the right thing", we'd continue dispatching to the
> device until either the state changes or the device-reported transition
> timeout has expired?
>
> Martin
>
>
> > For example this patch:
> >
> > commit 2b35865e7a290d313c3d156c0c2074b4c4ffaf52
> > Author: Hannes Reinecke <hare@suse.de>
> > Date:   Fri Feb 19 09:17:13 2016 +0100
> >
> >     scsi_dh_alua: Recheck state on unit attention
> >
> >
> > caused us issues because the retries were used up quickly. We just
> > changed
> > the target to return BUSY status and we don't use the transitioning
> > state.
> > The spec does mention using either return value in "5.15.2.5
> > Transitions
> > between target port asymmetric access states":
> >
> > ------
> > if during the transition the logical unit is inaccessible, then the
> > transition
> > is performed as a single indivisible event and the device server
> > shall respond
> > by either returning BUSY status, or returning CHECK CONDITION status,
> > with the
> > sense key set to NOT READY, and the sense code set to LOGICAL UNIT
> > NOT ACCESSIBLE,
> > ASYMMETRIC ACCESS STATE TRANSITION;
> >
> > ------
> >
> > So Brian's patch works if you return BUSY instead of 02/04/0a and are
> > setting
> > the state to transitioning during the time it's transitioning.
> >
> > I do partially agree with you and it's kind of a messy mix and match.
> > However,
> > I think we should change alua_check_sense to handle 02/04/0a the same
> > way we
> > handle it in alua_prep_fn. And then we should add a new flag for
> > devices that
> > have a bug and return transitioning forever.
> >
>


-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
