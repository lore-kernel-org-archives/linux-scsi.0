Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C49C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 15:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiEWPdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 11:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237865AbiEWPdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 11:33:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F702717D
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 08:33:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 28F821F948;
        Mon, 23 May 2022 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653320022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvpPtNZ7MIwBoA5gEor9/nS6YOBms56MF4GDK0ASlBg=;
        b=K39/77WHGfqhsPaAPBqfYrThibqZsYAksxymgFRPA33tCBifLX/+6moy0kLWsq170/DLwV
        OWNiIq6/E1UI8vh6QrOxAI4ucp2mV4HyqVMsrgES/0/96YYC8kgUOPqthJf3rn0hUJsiEZ
        MiGTHB/C+/F5cOQ1v8uQOQp2IzO5bv4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DFB9B13AA5;
        Mon, 23 May 2022 15:33:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CaPzNFWpi2LQGQAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 23 May 2022 15:33:41 +0000
Message-ID: <c6d36e75817866b341b3a3b5163472a92697fe10.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
Date:   Mon, 23 May 2022 17:33:41 +0200
In-Reply-To: <a9567ba6-d4ec-70d5-26a8-d6e055fd79e5@suse.de>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
         <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
         <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
         <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
         <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
         <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
         <a9567ba6-d4ec-70d5-26a8-d6e055fd79e5@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2022-05-21 at 12:17 +0200, Hannes Reinecke wrote:
> On 5/20/22 13:03, Martin Wilck wrote:
> > On Fri, 2022-05-20 at 14:08 -0500, Mike Christie wrote:
> > > On 5/20/22 9:03 AM, Martin Wilck wrote:
> > > > On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
> > > > > On 5/20/22 12:57, Martin Wilck wrote:
> > > > > > Brian, Martin,
> > > > > >=20
> > > > > > sorry, I've overlooked this patch previously. I have to say
> > > > > > I
> > > > > > think
> > > > > > it's wrong and shouldn't have been applied. At least I need
> > > > > > more
> > > > > > in-
> > > > > > depth explanation.
> > > > > >=20
> > > > > > On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen
> > > > > > wrote:
> > > > > > > On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
> > > > > > >=20
> > > > > > > > The handling of the ALUA transitioning state is
> > > > > > > > currently
> > > > > > > > broken.
> > > > > > > > When
> > > > > > > > a target goes into this state, it is expected that the
> > > > > > > > target
> > > > > > > > is
> > > > > > > > allowed to stay in this state for the implicit
> > > > > > > > transition
> > > > > > > > timeout
> > > > > > > > without a path failure.
> > > > > >=20
> > > > > > Can you please show me a quote from the specs on which this
> > > > > > expectation
> > > > > > ("without a path failure") is based? AFAIK the SCSI specs
> > > > > > don't
> > > > > > say
> > > > > > anything about device-mapper multipath semantics.
> > > > > >=20
> > > > > > > > The handler has this logic, but it gets
> > > > > > > > skipped currently.
> > > > > > > >=20
> > > > > > > > When the target transitions, there is in-flight I/O
> > > > > > > > from
> > > > > > > > the
> > > > > > > > initiator. The first of these responses from the target
> > > > > > > > will be
> > > > > > > > a
> > > > > > > > unit
> > > > > > > > attention letting the initiator know that the ALUA
> > > > > > > > state
> > > > > > > > has
> > > > > > > > changed.
> > > > > > > > The remaining in-flight I/Os, before the initiator
> > > > > > > > finds
> > > > > > > > out
> > > > > > > > that
> > > > > > > > the
> > > > > > > > portal state has changed, will return not ready, ALUA
> > > > > > > > state
> > > > > > > > is
> > > > > > > > transitioning. The portal state will change to
> > > > > > > > SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all
> > > > > > > > new
> > > > > > > > I/O
> > > > > > > > immediately failing the path unexpectedly. The path
> > > > > > > > failure
> > > > > > > > happens
> > > > > > > > in
> > > > > > > > less than a second instead of the expected successes
> > > > > > > > until
> > > > > > > > the
> > > > > > > > transition timer is exceeded.
> > > > > >=20
> > > > > > dm multipath has no concept of "transitioning" state. Path
> > > > > > state
> > > > > > can be
> > > > > > either active or inactive. As Brian wrote, commands sent to
> > > > > > the
> > > > > > transitioning device will return NOT READY, TRANSITIONING,
> > > > > > and
> > > > > > require
> > > > > > retries on the SCSI layer. If we know this in advance, why
> > > > > > should
> > > > > > we
> > > > > > continue sending I/O down this semi-broken path? If other,
> > > > > > healthy
> > > > > > paths are available, why it would it not be the right thing
> > > > > > to
> > > > > > switch
> > > > > > I/O to them ASAP?
> > > > > >=20
> > > > > But we do, don't we?
> > > > > Commands are being returned with the appropriate status, and
> > > > > dm-multipath should make the corresponding decisions here.
> > > > > This patch just modifies the check when _sending_ commands;
> > > > > ie
> > > > > multipath Depending on timing, multipathd may or may not
> > > > > already have done a PG switch because of 3.)
> > > > > had decided that the path is still usable.
> > > > > Question rather would be why multipath did that;
> > > >=20
> > > > If alua_prep_fn() got called, the path was considered usable at
> > > > the
> > > > given point in time by dm-multipath. Most probably the reason
> > > > was
> > > > simply that no error condition had occured on this path before
> > > > ALUA
> > > > state switched to transitioning. I suppose this can happen
> > > > if=A0storage
> > > > switches a PG consisting of multiple paths to TRANSITIONING. We
> > > > get
> > > > an
> > > > error on one path (sda, say), issue an RTPG, and receive the
> > > > new
> > > > ALUA
> > > > state for all paths of the PG. For all paths except sda, we'd
> > > > just
> > > > see
> > > > a switch to TRANSITIONING without a previous SCSI error.
> > > >=20
> > > > With this patch, we'll dispatch I/O (usually an entire bunch)
> > > > to
> > > > these
> > > > paths despite seeing them in TRANSITIONING state. Eventually,
> > > > when
> > > > the
> > > > SCSI responses are received, this leads to path failures. If
> > > > I/O
> > > > latencies are small, this happens after a few ms. In that case,
> > > > the
> > > > goal of Brian's patch is not reached, because the time until
> > > > path
> > > > failure would still be on the order of milliseconds. OTOH, if
> > > > latencies
> > > > are high, it takes substantially longer for the kernel to
> > > > realize
> > > > that
> > > > the path is non-functional, while other, good paths may be
> > > > idle.=A0I
> > > > fail
> > > > to see the benefit.
> > > >=20
> > >=20
> > > I'm not sure everyone agrees with you on the meaning of
> > > transitioning.
> > >=20
> > > If we go from non-optimized to optimized or standby to non-
> > > opt/optimized
> > > we don't want to try other paths because it can cause thrashing.
> >=20
> > But only with explicit ALUA, or am I missing something? I agree
> > that
> > the host shouldn't initiate a PG switch if it encounters
> > transitioning
> > state. I also agree that for transitioning towards a "better"
> > state,
> > e.g. standby to (non)-optimized, failing the path would be
> > questionable.=A0Unfortunately we don't know in which "direction" the
> > path
> > is transitioning - it could be for 'better' or 'worse'. I suppose
> > that
> > in the case of a PG switch, it can happen that we dispatch I/O to a
> > device that used to be in Standby and is now transitioning. Would
> > it
> > make sense to remember the previous state and "guess" what we're
> > going
> > to transition to? I.e. if the previous state was "Standby", it's
> > probably going to be (non)optimized after the transition, and vice-
> > versa?
> >=20
> > > =A0 We just
> > > need to transition resources before we can fully use the path. It
> > > could
> > > be a local cache operation or for distributed targets it could be
> > > a
> > > really
> > > expensive operation.
> > >=20
> > > For both though, it can take longer than the retries we get from
> > > scsi-ml.
> >=20
> > So if we want to do "the right thing", we'd continue dispatching to
> > the
> > device until either the state changes or the device-reported
> > transition
> > timeout has expired?
> >=20
> Not quite.
> I think multipath should make the decision, and we shouldn't try to=20
> out-guess multipathing from the device driver.
> We should only make the information available (to wit: the path
> state)=20
> for multipath to make the decision.=20

The only information that dm-multipath currently has is the block-level
error code. The SCSI layer uses BLK_STS_AGAIN for "transitioning". Can
dm-multipath assume that BLK_STS_AGAIN *always* has these semantics,
regadless of the low-level driver? It isn't clearly documented, AFAICS.

Doing this properly requires additional logic in dm-mpath.c to treat
BLK_STS_AGAIN differently from other path errors. IIUC, what Brian and
Mike say is that dm-multipath may do path failover, but not PG failover
for BLK_STS_AGAIN. We currently don't have this logic, but we could
work on it.

IMO this means that Brian's patch would be a step in the wrong
direction: by returning BLK_STS_OK instead of BLK_STS_AGAIN, dm-
multipath gets *less* information about path state than before.

dm-multipath has 3 ways to get notified of transitioning state
(correct me if I'm missing anything):

 1. I/O queuing fails with BLK_STS_AGAIN in scsi_prep_fn(). This won't
    happen any more with Brian's patch.
 2. I/O returns from target with CHECK CONDITION / NOT READY / 0x4:0xa
    (LU not accessible - asymmetric state change transition).
    In this case the SCSI layer applies the "maybe_retry" logic,
    i.e. it retries the command. When retries are exhausted, it fails
    the command with BLK_STS_AGAIN.
 3. multipathd in user space sees a TRANSITIONING status during routine
    path checking. Currently multipathd uses prio=3D0 for TRANSITIONING
    state, which is even less than the prio used for STANDBY (1). Thus
    multipathd would initiate a PG switch sooner or later. I believe
    these prio assignments by multipathd are questionable, but that's
    a different discussion.

dm-multipath interprets BLK_STS_AGAIN in 2.) as path error, and will
thus do a path failover in the PG. In a case like Brian's, the other
paths in the PG will likely also be in TRANSITIONING state, so
procedure 2.) will repeat until all paths in the PG have failed. In
that situation, dm-multipath will initiate a PG switch, which is what
Brian wanted to avoid in the first place.

> But if multipath decides to send I/O via a path which we _think_ it's
> in=20
> transitioning we shouldn't be arguing with that (ie we shouldn't
> preempt=20
> is from prep_fn) but rather let it rip; who knows, maybe there was a=20
> reason for that.

You seem to assume that multipath knows more about the device then the
SCSI layer. Isn't the opposite true?=A0dm-multipath would never know that
the path is "transitioning", and it has zero knowledge about the
transition timeout. Only the ALUA code knows that certain path devices
will change their status simultaneously, always. The only additional
"knowledge" that multipath has is knowledge about path siblings and
PGs. By returning BLK_STS_OK from scsi_prep_fn(), we hold back
information that the multipath layer could use for an informed
decision.

> The only thing this patch changes (for any current setup) is that
> we'll=20
> incur additional round-trip times for I/O being sent in between the=20
> first I/O returning with 'transitioning' and multipath picking up the
> new path state. This I/O will be returned more-or-less immediately by
> the target, so really we're only having an additional round-trip
> latency=20
> for each I/O during that time. This is at most in the milliseconds=20
> range, so I guess we can live with that.

Side note: AFAICS it'll be several round-trips (until SCSI retries are
exhausted,=A0as this is not a "fast io fail" case).

Anyway, you're right, a PG switch will happen after a few milliseconds.
That's what Brian wanted to avoid. IOW, the patch won't achieve what
it's supposed to achieve. *But* it will hold back information that dm-
multipath could use for handling transitions smarter than it currently
does.

> If, however, multipath fails to pick up the 'transitioning' state
> then=20
> this won't work, and we indeed will incur a regression. But that=20
> arguably is an issue with multipath ...

dm-multipath currently doesn't. Requesting that it should is a valid
feature request, no less and no more. I'm not against working on this
feature. But the generic device model in dm-multipath isn't quite
powerful enough for this. We could try to handle it more cleverly in
user space, but yet I don't see how it could  be done.

Cheers,
Martin

