Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F48C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 07:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiFHH7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiFHH7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 03:59:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B7021488E
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 00:33:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2AB6E1F892;
        Wed,  8 Jun 2022 07:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654673527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1YaBkbjfd2hWGrUkD/iKU6TjvxYpaDym494qOaqyP8=;
        b=HgwtqG/Fb9F9GJgazM3QKAacWd4BCXMZv9zJ3VLzVYAORDiMoP8l6bu6Uzn4VQw/VMMRlq
        4WaeonLcdNv3Ndb357unp2nq7PXTxELYysMemonMmQ+fxz4A93vuibrv0GDxvxkMsi0jYM
        uSy/BoLZ7KZlilVHd/sx1uAcqaUaYQU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DB7F713A15;
        Wed,  8 Jun 2022 07:32:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EHJTM3ZQoGI9IAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 08 Jun 2022 07:32:06 +0000
Message-ID: <64935157aac54ad86d710451ff63cacfbc41d4cb.camel@suse.com>
Subject: Re: [PATCH] scsi_dh_alua: mark port group as failed after ALUA
 transitioning timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Martin Wilck <mwilck@suse.de>
Date:   Wed, 08 Jun 2022 09:32:06 +0200
In-Reply-To: <3161c450d78c79c3dbc8f471fd9d387f32f92d09.camel@suse.com>
References: <20220525081139.88165-1-hare@suse.de>
         <37b61d6b956c18bf4a56d14b5746dab2719ef20d.camel@suse.com>
         <afa5f370-4e16-319f-ded8-49e11f12ff56@suse.de>
         <3161c450d78c79c3dbc8f471fd9d387f32f92d09.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-05-25 at 21:33 +0200, Martin Wilck wrote:
> On Wed, 2022-05-25 at 14:07 +0200, Hannes Reinecke wrote:
> > On 5/25/22 13:20, Martin Wilck wrote:
> > > On Wed, 2022-05-25 at 10:11 +0200, Hannes Reinecke wrote:
> > > > When ALUA transitioning timeout triggers the path group state
> > > > must
> > > > be considered invalid. So add a new flag ALUA_PG_FAILED to
> > > > indicate
> > > > that the path state isn't necessarily valid, and keep the
> > > > existing
> > > > path state until we get a valid response from a RTPG.
> > > >=20
> > > > Cc: Brian Bunker <brian@purestorage.com>
> > > > Cc: Martin Wilck <mwilck@suse.de>
> > > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > > ---
> > > > =A0=A0drivers/scsi/device_handler/scsi_dh_alua.c | 24 +++++++------
> > > > --
> > > > -----
> > > > --
> > > > =A0=A01 file changed, 7 insertions(+), 17 deletions(-)
> > > >=20
> > > > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> > > > b/drivers/scsi/device_handler/scsi_dh_alua.c
> > > > index 1d9be771f3ee..6921490a5e65 100644
> > > > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > > > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > > > @@ -49,6 +49,7 @@
> > > > =A0=A0#define ALUA_PG_RUN_RTPG=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A00x10
> > > > =A0=A0#define ALUA_PG_RUN_STPG=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A00x20
> > > > =A0=A0#define ALUA_PG_RUNNING=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A00x40
> > > > +#define ALUA_PG_FAILED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A00x80
> > > > =A0=20
> > > > =A0=A0static uint optimize_stpg;
> > > > =A0=A0module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
> > > > @@ -420,7 +421,7 @@ static enum scsi_disposition
> > > > alua_check_sense(struct scsi_device *sdev,
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 */
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0rcu_read_lock();
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0pg =3D rcu_dereference(h->pg);
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (pg)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (pg && !(pg->flags &
> > > > ALUA_PG_FAILED))
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->state =3D
> > > > SCSI_ACCESS_STATE_TRANSITIONING;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0rcu_read_unlock();
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0alua_check(sdev, false);
> > >=20
> > > You still return NEEDS_RETRY from alua_check_sense(), even if
> > > ALUA_PG_FAILED is set?
> > >=20
> > > > @@ -694,7 +695,7 @@ static int alua_rtpg(struct scsi_device
> > > > *sdev,
> > > > struct alua_port_group *pg)
> > > > =A0=20
> > > > =A0=A0 skip_rtpg:
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0spin_lock_irqsave(&pg->lock, flags);
> > > > -=A0=A0=A0=A0=A0=A0=A0if (transitioning_sense)
> > > > +=A0=A0=A0=A0=A0=A0=A0if (transitioning_sense && !(pg->flags &
> > > > ALUA_PG_FAILED))
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->state =3D SC=
SI_ACCESS_STATE_TRANSITIONING;
> > > > =A0=20
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0if (group_id_old !=3D pg->group_id || st=
ate_old !=3D pg-
> > > > > state ||
> > > > @@ -718,23 +719,10 @@ static int alua_rtpg(struct scsi_device
> > > > *sdev,
> > > > struct alua_port_group *pg)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0pg->interval =3D ALUA_RTPG_RETRY_DELAY;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0err =3D SCSI_DH_RETRY;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0struct alua_dh_data *h;
> > > > -
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* Transitioning time exceeded, set
> > > > port
> > > > to
> > > > standby */
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* Transitioning time exceeded, mark pg
> > > > as
> > > > failed */
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0err =3D SCSI_DH_IO;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pg->state =3D SCSI_ACCESS_STATE_STANDBY;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pg->flags |=3D ALUA_PG_FAILED;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0pg->expiry =3D 0;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0rcu_read_lock();
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0list_for_each_entry_rcu(h, &pg-
> > > > >dh_list,
> > > > node) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!h->sdev)
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0continue;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0h->sdev->access_state =3D
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(pg->state &
> > > > SCSI_ACCESS_STATE_MASK);
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pg->pref)
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0h->sdev->access_state
> > > > |=3D
> > > > -
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0SCSI_ACCESS_STA
> > > > TE
> > > > _PREFE
> > > > RRED;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0rcu_read_unlock();
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0case SCSI_ACCESS_STATE_OFFLINE:
> > > > @@ -746,6 +734,8 @@ static int alua_rtpg(struct scsi_device
> > > > *sdev,
> > > > struct alua_port_group *pg)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Useable path =
if active */
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D SCSI_DH_=
OK;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->expiry =3D 0=
;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* RTPG succeeded, cl=
ear ALUA_PG_FAILED */
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->flags &=3D ~ALUA_=
PG_FAILED;
> > >=20
> > > Shouldn't this be done for any state except TRANSITIONING?
> > >=20
> > Why, but it does.
> > We're only entering this block if the state is not TRANSITIONING.
> > (It's part of a 'switch' statement)
>=20
> Right, the only exception is SCSI_ACCESS_STATE_OFFLINE, for which the
> ALUA_PG_FAILED state should of cause persist. Sorry for bothering.
>=20

What I'm still missing here is how we avoid sending further I/O down
the path after the timeout has expired.

alua_check_sense() will return NEEDS_RETRY, even if ALUA_PG_FAILED is
set. Without this patch, alua_prep_fn() would return an error because
it would see STANDBY state. With this patch, the state will stay
TRANSITIONING, and (after 6056a92ceb2a ("scsi: scsi_dh_alua: Properly
handle the ALUA transitioning state")) alua_prep_fn() will return
BLK_STS_OK.

IMO alua_check_sense() should return SUCCESS if ALUA_PG_FAILED is set,
and alua_prep_fn() should return an error.

Regards
Martin
