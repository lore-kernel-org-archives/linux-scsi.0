Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C758C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 10:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbiETK5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 06:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245475AbiETK52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 06:57:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7188F92D13
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 03:57:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BBF361F8DC;
        Fri, 20 May 2022 10:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653044243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3IeSzJ+WFQ4RjFyDrUL94PIvFiwtV9YzqelYtpt4WI0=;
        b=DEL9QLI4Qy9mVYNE2Zm6koeyQA6AOTERVJS2GonzeVryqHaSki8eU1fi/p1zZTXlbKMJd1
        lnKyYKCiGVCfMa63xEPJ88+uMqWOsPy+sgbsgGv7zZLCD0SA3/Or3pKf0NS0X490SWSFBm
        ikEvh3A5X5RmvStYVX2B9QBVjeLleEo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8468013A5F;
        Fri, 20 May 2022 10:57:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZcCdHhN0h2JkGwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 20 May 2022 10:57:23 +0000
Message-ID: <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
Date:   Fri, 20 May 2022 12:57:23 +0200
In-Reply-To: <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Brian, Martin,=20

sorry, I've overlooked this patch previously. I have to say I think
it's wrong and shouldn't have been applied. At least I need more in-
depth explanation.

On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
> On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
>=20
> > The handling of the ALUA transitioning state is currently broken.
> > When
> > a target goes into this state, it is expected that the target is
> > allowed to stay in this state for the implicit transition timeout
> > without a path failure.=A0

Can you please show me a quote from the specs on which this expectation
("without a path failure") is based? AFAIK the SCSI specs don't say
anything about device-mapper multipath semantics.

> > The handler has this logic, but it gets
> > skipped currently.
> >=20
> > When the target transitions, there is in-flight I/O from the
> > initiator. The first of these responses from the target will be a
> > unit
> > attention letting the initiator know that the ALUA state has
> > changed.
> > The remaining in-flight I/Os, before the initiator finds out that
> > the
> > portal state has changed, will return not ready, ALUA state is
> > transitioning. The portal state will change to
> > SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
> > immediately failing the path unexpectedly. The path failure happens
> > in
> > less than a second instead of the expected successes until the
> > transition timer is exceeded.

dm multipath has no concept of "transitioning" state. Path state can be
either active or inactive. As Brian wrote, commands sent to the
transitioning device will return NOT READY, TRANSITIONING, and require
retries on the SCSI layer. If we know this in advance, why should we
continue sending I/O down this semi-broken path? If other, healthy
paths are available, why it would it not be the right thing to switch
I/O to them ASAP?

I suppose the problem you want to solve here is a transient situation
in which all paths are transitioning (some up, some down), which would
lead to a failure on the dm level (at least with no_path_retry=3D0). IMO
this has to be avoided at the firmware level, and if that is
impossible, multipath-tools' (no_path_retry * polling_interval) must be
set to a value that is higher than the time for which this transient
degraded situation would persist.

Am I missing something?

The way I see it, this is a problem that affects only storage from one
vendor, and would cause suboptimal behavior on most others. If you
really need this, I would suggest a new devinfo flag, e.g.
BLIST_DONT_FAIL_TRANSITIONING.

Regards,
Martin


> >=20
> > [...]
>=20
> Applied to 5.18/scsi-fixes, thanks!
>=20
> [1/1] scsi_dh_alua: properly handling the ALUA transitioning state
> =A0=A0=A0=A0=A0 https://git.kernel.org/mkp/scsi/c/6056a92ceb2a
>=20

