Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9D2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 20:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351655AbiETUD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 16:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiETUD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 16:03:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9BC19C39F
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 13:03:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B32E1FA6F;
        Fri, 20 May 2022 20:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653077005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLcNLOpcjes25Lho7R+866IMs61FnVBOPXa/QIyn5Ys=;
        b=ZwQxHr+HwHkv/a4wSQ9FjdGHW2BHVaM8ImQTWft07bmrLkCGFsTY/no0h6Fi1hnO/tVYpN
        MBIlAtlKqqorqAQh3FzMGBponY5FChwRk8KOaouy+o4OS1uXSK6uC+vJR/wBHioDVkTVey
        MsRh+8IIgBzajJVpP12El/JJZGVMA4w=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D75513A5F;
        Fri, 20 May 2022 20:03:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yx9tDQ30h2IubAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 20 May 2022 20:03:25 +0000
Message-ID: <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
Date:   Fri, 20 May 2022 22:03:24 +0200
In-Reply-To: <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
         <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
         <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
         <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
         <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-05-20 at 14:08 -0500, Mike Christie wrote:
> On 5/20/22 9:03 AM, Martin Wilck wrote:
> > On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
> > > On 5/20/22 12:57, Martin Wilck wrote:
> > > > Brian, Martin,
> > > >=20
> > > > sorry, I've overlooked this patch previously. I have to say I
> > > > think
> > > > it's wrong and shouldn't have been applied. At least I need
> > > > more
> > > > in-
> > > > depth explanation.
> > > >=20
> > > > On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
> > > > > On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
> > > > >=20
> > > > > > The handling of the ALUA transitioning state is currently
> > > > > > broken.
> > > > > > When
> > > > > > a target goes into this state, it is expected that the
> > > > > > target
> > > > > > is
> > > > > > allowed to stay in this state for the implicit transition
> > > > > > timeout
> > > > > > without a path failure.
> > > >=20
> > > > Can you please show me a quote from the specs on which this
> > > > expectation
> > > > ("without a path failure") is based? AFAIK the SCSI specs don't
> > > > say
> > > > anything about device-mapper multipath semantics.
> > > >=20
> > > > > > The handler has this logic, but it gets
> > > > > > skipped currently.
> > > > > >=20
> > > > > > When the target transitions, there is in-flight I/O from
> > > > > > the
> > > > > > initiator. The first of these responses from the target
> > > > > > will be
> > > > > > a
> > > > > > unit
> > > > > > attention letting the initiator know that the ALUA state
> > > > > > has
> > > > > > changed.
> > > > > > The remaining in-flight I/Os, before the initiator finds
> > > > > > out
> > > > > > that
> > > > > > the
> > > > > > portal state has changed, will return not ready, ALUA state
> > > > > > is
> > > > > > transitioning. The portal state will change to
> > > > > > SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new
> > > > > > I/O
> > > > > > immediately failing the path unexpectedly. The path failure
> > > > > > happens
> > > > > > in
> > > > > > less than a second instead of the expected successes until
> > > > > > the
> > > > > > transition timer is exceeded.
> > > >=20
> > > > dm multipath has no concept of "transitioning" state. Path
> > > > state
> > > > can be
> > > > either active or inactive. As Brian wrote, commands sent to the
> > > > transitioning device will return NOT READY, TRANSITIONING, and
> > > > require
> > > > retries on the SCSI layer. If we know this in advance, why
> > > > should
> > > > we
> > > > continue sending I/O down this semi-broken path? If other,
> > > > healthy
> > > > paths are available, why it would it not be the right thing to
> > > > switch
> > > > I/O to them ASAP?
> > > >=20
> > > But we do, don't we?
> > > Commands are being returned with the appropriate status, and=20
> > > dm-multipath should make the corresponding decisions here.
> > > This patch just modifies the check when _sending_ commands; ie
> > > multipath=20
> > > had decided that the path is still usable.
> > > Question rather would be why multipath did that;
> >=20
> > If alua_prep_fn() got called, the path was considered usable at the
> > given point in time by dm-multipath. Most probably the reason was
> > simply that no error condition had occured on this path before ALUA
> > state switched to transitioning. I suppose this can happen
> > if=A0storage
> > switches a PG consisting of multiple paths to TRANSITIONING. We get
> > an
> > error on one path (sda, say), issue an RTPG, and receive the new
> > ALUA
> > state for all paths of the PG. For all paths except sda, we'd just
> > see
> > a switch to TRANSITIONING without a previous SCSI error.
> >=20
> > With this patch, we'll dispatch I/O (usually an entire bunch) to
> > these
> > paths despite seeing them in TRANSITIONING state. Eventually, when
> > the
> > SCSI responses are received, this leads to path failures. If I/O
> > latencies are small, this happens after a few ms. In that case, the
> > goal of Brian's patch is not reached, because the time until path
> > failure would still be on the order of milliseconds. OTOH, if
> > latencies
> > are high, it takes substantially longer for the kernel to realize
> > that
> > the path is non-functional, while other, good paths may be idle.=A0I
> > fail
> > to see the benefit.
> >=20
>=20
> I'm not sure everyone agrees with you on the meaning of
> transitioning.
>=20
> If we go from non-optimized to optimized or standby to non-
> opt/optimized
> we don't want to try other paths because it can cause thrashing.

But only with explicit ALUA, or am I missing something? I agree that
the host shouldn't initiate a PG switch if it encounters transitioning
state. I also agree that for transitioning towards a "better" state,
e.g. standby to (non)-optimized, failing the path would be
questionable.=A0Unfortunately we don't know in which "direction" the path
is transitioning - it could be for 'better' or 'worse'. I suppose that
in the case of a PG switch, it can happen that we dispatch I/O to a=20
device that used to be in Standby and is now transitioning. Would it
make sense to remember the previous state and "guess" what we're going
to transition to? I.e. if the previous state was "Standby", it's
probably going to be (non)optimized after the transition, and vice-
versa?

>  We just
> need to transition resources before we can fully use the path. It
> could
> be a local cache operation or for distributed targets it could be a
> really
> expensive operation.
>=20
> For both though, it can take longer than the retries we get from
> scsi-ml.

So if we want to do "the right thing", we'd continue dispatching to the
device until either the state changes or the device-reported transition
timeout has expired?

Martin


> For example this patch:
>=20
> commit 2b35865e7a290d313c3d156c0c2074b4c4ffaf52
> Author: Hannes Reinecke <hare@suse.de>
> Date:=A0=A0 Fri Feb 19 09:17:13 2016 +0100
>=20
> =A0=A0=A0 scsi_dh_alua: Recheck state on unit attention
>=20
>=20
> caused us issues because the retries were used up quickly. We just
> changed
> the target to return BUSY status and we don't use the transitioning
> state.
> The spec does mention using either return value in "5.15.2.5
> Transitions
> between target port asymmetric access states":
>=20
> ------
> if during the transition the logical unit is inaccessible, then the
> transition
> is performed as a single indivisible event and the device server
> shall respond
> by either returning BUSY status, or returning CHECK CONDITION status,
> with the
> sense key set to NOT READY, and the sense code set to LOGICAL UNIT
> NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION;
>=20
> ------
>=20
> So Brian's patch works if you return BUSY instead of 02/04/0a and are
> setting
> the state to transitioning during the time it's transitioning.
>=20
> I do partially agree with you and it's kind of a messy mix and match.
> However,
> I think we should change alua_check_sense to handle 02/04/0a the same
> way we
> handle it in alua_prep_fn. And then we should add a new flag for
> devices that
> have a bug and return transitioning forever.
>=20

