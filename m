Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90782C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 08:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiEXI3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 04:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiEXI3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 04:29:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D2C694B0
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 01:29:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 830AD1F8E6;
        Tue, 24 May 2022 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653380948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6TQDh8WxzBFSxYENfNUZ+NlEW4yWCIaWpPFVRjmxZ8=;
        b=lE459dfBENGA13x2wzrxlc2bODgvnyemq3fJfxHUir5BocSGTw2iOkMzFuil1G1+uLGiR/
        GrbJuwfKUFlcetDeb7+d5wYZT8h7wHiBb5JyhHYxIt0z6eF/0Wy8GgTB1+QEaXFIKhP8TI
        wpfyrXEP9pHiVgMIotp0oODsbe3RQMg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 452FE13AE3;
        Tue, 24 May 2022 08:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6N1AD1SXjGKHZQAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 24 May 2022 08:29:08 +0000
Message-ID: <731d08291f201a4c056737c107c3c78485b609f3.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
Date:   Tue, 24 May 2022 10:29:07 +0200
In-Reply-To: <4CBD87A8-0A92-4DFD-B50B-124C11BB9C86@purestorage.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
         <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
         <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
         <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
         <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
         <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
         <CAHZQxyLEOw8jXUzLj8DugbbsVkFP=OMjv-Lkz6LkuayEavYahg@mail.gmail.com>
         <07f3474feb4ea7c2e80664c9977ae0e24b82cc09.camel@suse.com>
         <4CBD87A8-0A92-4DFD-B50B-124C11BB9C86@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-05-23 at 09:52 -0700, Brian Bunker wrote:
>=20
> > On May 23, 2022, at 9:03 AM, Martin Wilck <mwilck@suse.com> wrote:
> >=20
> > On Fri, 2022-05-20 at 19:52 -0700, Brian Bunker wrote:
> > > From my perspective, the ALUA transitioning state is a temporary
> > > state
> > > where the target is saying that it does not have a permanent
> > > state
> > > yet. Having the initiator try another pg to me doesn't seem like
> > > the
> > > right thing for it to do.
> >=20
> > I agree. Unfortunately, there's no logic in dm-multipath saying "I
> > may
> > switch paths inside a PG, but I may not do PG failover".
> >=20
> > > If the target wanted the initiator to use a
> > > different pg, it should use an ALUA state which would make that
> > > clear,
> > > standby, unavailable, etc. The target would only return an error
> > > state
> > > if it was aware that some other path is in an active state.When
> > > transitioning is returned, I don't think the initiator should
> > > assume
> > > that any other pg would be a better choice. I think it should
> > > assume
> > > that the target will make its intention clear for that path with
> > > a
> > > permanent state within a transition timeout.
> >=20
> > For me the question is still whether trying to send I/O to the path
> > that is known not to be able to process it makes sense. As noted
> > elsewhere, you patch just delays the BLK_STS_AGAIN by a few
> > milliseconds. You want to avoid a PG switch, and I second that, but
> > IMO
> > that needs a different approach.
> >=20
> > > From my perspective the right thing to do is to let the ALUA
> > > handler
> > > do what it is trying to do. If the pg state is transitioning and
> > > within the transition timeout it should continue to retry that
> > > request
> > > checking each time the transition timeout.
> >=20
> > But this means that we should modify the logic not only in
> > alua_prep_fn() but also for handling of NOT READY conditions,
> > either in
> > alua_check_sense() or in scsi_io_completion_action().
> > I agree that this would make a lot of sense, perhaps more than
> > trying
> > to implement a cleverer logic in dm-multipath as discussed between
> > Hannes and myself.
> >=20
> > This is what we need to figure out first: Do we want to change the
> > logic in the multipath layer, making it somehow aware of the
> > special
> > nature of "transitioning" state, or should we tune the retry logic
> > in
> > the SCSI layer such that dm-multipath will "do the right thing"
> > automatically?
> >=20
> > Regards
> > Martin
> >=20
> I think that a couple of things are needed to get to where my
> expectation of how it should work would be. First this code should
> come out of the not ready sense check. The reason is that it will
> continually override alua_check=E2=80=99s attempt to change the pg state =
as
> it exceeds the allowed time and the path state is changed to standby
> to handle a misbehaving target which stays in transitioning past the
> timer.
>=20
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -409,20 +409,12 @@ static char print_alua_state(unsigned char
> state)
> =C2=A0static enum scsi_disposition alua_check_sense(struct scsi_device
> *sdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_sense_hdr
> *sense_hdr)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct alua_dh_data *h =3D sdev->ha=
ndler_data;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct alua_port_group *pg;
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (sense_hdr->sense_key) =
{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case NOT_READY:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D
> 0x0a) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * =
LUN Not Accessible - ALUA state transition
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rcu_read_lock(=
);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pg =3D rcu_der=
eference(h->pg);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pg)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pg->state =3D
> SCSI_ACCESS_STATE_TRANSITIONING;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rcu_read_unloc=
k();
>=20

Good point. But I'd say that rather than removing it, this code should
be made aware of the timer.

> Second for this to work how it used to work in Linux and how it works
> for other OS=E2=80=99s where ALUA state transition is not a fail path
> response:
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8d18cc7e510e..33828aa44347 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -776,11 +776,11 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x1b: /* sanitize in progress =
*/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x1d: /* configuration in
> progress */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x24: /* depopulation in
> progress */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 action =3D ACTION_DELAYED_RETRY;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x0a: /* ALUA state transition
> */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 blk_stat =3D BLK_STS_AGAIN;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 fallthrough;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 action =3D ACTION_REPREP;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 break;
>=20
> Because, as you said the expiation check for whether to continually
> allow new I/O on the pg is in the prep function of the ALUA handler.

Not any more with your patch, or what am I missing?

> I think that this does introduce a lot error processing for a target
> that will respond quickly. Maybe there is some way to use the
> equivalent of ACTION_DELAYED_RETRY so that the target is not as
> aggressively retried in the transitioning state.

IMHO ACTION_DELAYED_RETRY would be a good option. Note that it blocks
the device; thus it prevents dispatching IO to the device according to
the scsi_device_block() logic. This way it automatically introduces
some delay.=20

>=20
> It is possible, maybe likely, in other OS=E2=80=99s that this retry is do=
ne
> at the multipath level. The DSM from Microsoft in GitHub would seem
> to show that Windows does it that way. The multipath-tools in Linux
> though don=E2=80=99t seem to use sense data to make decisions so getting =
this
> logic in would seem like a decent set of changes and getting the buy-
> in to go that route.

IMO we're closer to a good solution on the SCSI side. I've no idea how
Microsoft's DSM works, but it probably has a more detailed concept of
path states than Linux' dm-multipath, which operates on abstract block
devices.

Neither dm-multipath nor multipath-tools have a concept of
transitioning state.=C2=A0While it'd be possible to add this logic in
multipath-tools (user space), I see a couple of hard-to-solve problems:

 - multipathd has no concept of ALUA.=C2=A0The ALUA functionality is split
into the device handler part (handled in the kernel, responsible for
explicit PG switching and error handling), and the "prioritizer"
handled in user space. ALUA is just one out of several path
prioritizers. The generic prioritizer concept doesn't define a
"transitioning" property. We'd need to try to generalize the concept,
and possibly figure out how to implement it with other prioritizers.

 - the dm-multipath path group concept is abstract and, in general,
independent of ALUA's port groups. The core property of ALUA (all ports
in a group always have the same primary port state) doesn't generlly
apply to multipath PGs. Nothing prevents users from configuring
different path grouping policies, like multibus or grouping by latency,
even if ALUA is supported. The idea to prevent dm-multipath from
switching PG away from a transitioning path group is only valid if dm-
multipath PGs map 1:1 to ALUA port groups.

 - ALUA itself is more generic than the scenario you describe. You say
that that if a path is transitioning, trying to switch PGs is wrong.
This is true if there's just one other PG, and that other PG is
unavailable. But there may be setups with more than 2 PGs, where one PG
is perfectly healthy while another is transitioning. In such a case,
it'd be reasonable to switch PGs towards the healthy one.

 - multipathd doesn't get notified of ALUA state changes. It polls in
rather long time intervals (5s). If this logic is implemented in
multipathd, we'll see considerable latency in PG switching.

- In general, multipathd doesn't have full control over dm-multipath PG
switching. Some logic is in the kernel and some in user space. It's not
easy for multipathd to prevent the kernel from switching to a certain
PG. Basically the only way is to set all paths in that PG to failed
status.

Here's one dumb question: ALUA defines "transitioning" in an abstract
fashion, as a "movement from one target port asymmetric access state to
another". This doesn't say anything about the state the port is
transitioning towards. IOW, it could be transitioning towards "STANDBY"
or "UNAVAILABLE", perhaps even "OFFLINE". I am unsure if this makes
sense in practice; I _guess_ that most of the time "transitioning"
means something like "booting". Your suggestions seem to confirm that.
at least for PURE hardware, "transitioning" always means "will be
usable soon". Is this correct? And if yes, to which extent could this
be generalized to other arrays, past, present, and future?

Regards
Martin

