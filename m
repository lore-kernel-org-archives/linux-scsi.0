Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982F1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 14:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350078AbiETOD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 10:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiETODy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 10:03:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ECB7A466
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 07:03:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AB9B121B58;
        Fri, 20 May 2022 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653055432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XupJJnC2OGzwOSL7uTsc4tWG2XkSd6oHSQJqQpjaTkM=;
        b=WfQ2uRrYFJ/KlsA6UoOr6Omfg1bpOOyHUlPx+MmYs9F5SZEwjkgGs2pI73hoKG1EMlyD62
        3QV8Mka58Kb1d8hYhf21WB3SPghUbks8MNSTsBmh51ixU/lk9x9EVaBRPG0HGJiBIFdXDE
        3Pgm1RvIb1QuImy8i88I2r1frZBhB3c=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 78A7C13A5F;
        Fri, 20 May 2022 14:03:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MP3ZG8ifh2IOdAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 20 May 2022 14:03:52 +0000
Message-ID: <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
Date:   Fri, 20 May 2022 16:03:51 +0200
In-Reply-To: <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
         <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
         <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
> On 5/20/22 12:57, Martin Wilck wrote:
> > Brian, Martin,
> >=20
> > sorry, I've overlooked this patch previously. I have to say I think
> > it's wrong and shouldn't have been applied. At least I need more
> > in-
> > depth explanation.
> >=20
> > On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
> > > On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
> > >=20
> > > > The handling of the ALUA transitioning state is currently
> > > > broken.
> > > > When
> > > > a target goes into this state, it is expected that the target
> > > > is
> > > > allowed to stay in this state for the implicit transition
> > > > timeout
> > > > without a path failure.
> >=20
> > Can you please show me a quote from the specs on which this
> > expectation
> > ("without a path failure") is based? AFAIK the SCSI specs don't say
> > anything about device-mapper multipath semantics.
> >=20
> > > > The handler has this logic, but it gets
> > > > skipped currently.
> > > >=20
> > > > When the target transitions, there is in-flight I/O from the
> > > > initiator. The first of these responses from the target will be
> > > > a
> > > > unit
> > > > attention letting the initiator know that the ALUA state has
> > > > changed.
> > > > The remaining in-flight I/Os, before the initiator finds out
> > > > that
> > > > the
> > > > portal state has changed, will return not ready, ALUA state is
> > > > transitioning. The portal state will change to
> > > > SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
> > > > immediately failing the path unexpectedly. The path failure
> > > > happens
> > > > in
> > > > less than a second instead of the expected successes until the
> > > > transition timer is exceeded.
> >=20
> > dm multipath has no concept of "transitioning" state. Path state
> > can be
> > either active or inactive. As Brian wrote, commands sent to the
> > transitioning device will return NOT READY, TRANSITIONING, and
> > require
> > retries on the SCSI layer. If we know this in advance, why should
> > we
> > continue sending I/O down this semi-broken path? If other, healthy
> > paths are available, why it would it not be the right thing to
> > switch
> > I/O to them ASAP?
> >=20
> But we do, don't we?
> Commands are being returned with the appropriate status, and=20
> dm-multipath should make the corresponding decisions here.
> This patch just modifies the check when _sending_ commands; ie
> multipath=20
> had decided that the path is still usable.
> Question rather would be why multipath did that;

If alua_prep_fn() got called, the path was considered usable at the
given point in time by dm-multipath. Most probably the reason was
simply that no error condition had occured on this path before ALUA
state switched to transitioning. I suppose this can happen if=A0storage
switches a PG consisting of multiple paths to TRANSITIONING. We get an
error on one path (sda, say), issue an RTPG, and receive the new ALUA
state for all paths of the PG. For all paths except sda, we'd just see
a switch to TRANSITIONING without a previous SCSI error.

With this patch, we'll dispatch I/O (usually an entire bunch) to these
paths despite seeing them in TRANSITIONING state. Eventually, when the
SCSI responses are received, this leads to path failures. If I/O
latencies are small, this happens after a few ms. In that case, the
goal of Brian's patch is not reached, because the time until path
failure would still be on the order of milliseconds. OTOH, if latencies
are high, it takes substantially longer for the kernel to realize that
the path is non-functional, while other, good paths may be idle.=A0I fail
to see the benefit.

Regards,
Martin


>  however that logic=20
> isn't modified here.
>=20
> Cheers,
>=20
> Hannes

