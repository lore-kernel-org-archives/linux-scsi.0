Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC37C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 07:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiKQHDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 02:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiKQHDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 02:03:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7506175AD
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 23:03:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1F8C11F855;
        Thu, 17 Nov 2022 07:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668668624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pERRWIxzU28yQROgyXCbnYcF4cXb+xCVLT2bPp+hQOY=;
        b=g9twhSbZOBXWtJOZPsxUJgZzzOdCJ+BzZGn3Yc2F78ylZDFqHi2N86Q4UnJmQAM60Tfzxx
        Yij0D30ul7HHms1OYQ768GXJFahingZfTp2rKi65GZGnqhG8Ed6YMuTKXUxjsd0xbA2USG
        LmmKsXLxs5wFLAqx35MGaJyfsIQHdss=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDB0013A12;
        Thu, 17 Nov 2022 07:03:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Dht3NM/cdWOlJQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 17 Nov 2022 07:03:43 +0000
Message-ID: <2063a6a55bbbccd43ccdde0c687e27e39362286c.camel@suse.com>
Subject: Re: [PATCH] scsi: alua: Fix alua_rtpg_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Date:   Thu, 17 Nov 2022 08:03:43 +0100
In-Reply-To: <feb72aeb-cd34-4cc0-0520-30e8a808a824@acm.org>
References: <20221115224903.2325529-1-bvanassche@acm.org>
         <0efc9faa6dd519d1d402a08dbedd5cd7ed0de4f5.camel@suse.com>
         <feb72aeb-cd34-4cc0-0520-30e8a808a824@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.0 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-11-16 at 13:22 -0800, Bart Van Assche wrote:
> On 11/16/22 02:32, Martin Wilck wrote:
>=20
>=20
> [...]
>=20
> Although I like the approach of this patch, how about the
> implementation below?
> I think the implementation below is a little cleaner but that might
> be subjective ...
>=20

Fine with me, absolutely, and indeed better than mine. I don't quite
understand the last hook - sdev->handler_data isn't protected by rcu in
any way, is it? But that doesn't matter much.

Regards,
Martin


> Thanks,
>=20
> Bart.
>=20
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index bd4ee294f5c7..d5a7d6ed5c63 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -354,6 +354,8 @@ static int alua_check_vpd(struct scsi_device
> *sdev, struct alua_dh_data *h,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 "%s: port group %x rel port %x\n",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 ALUA_DH_NAME, group_id, rel_port);
>=20
> +=A0=A0=A0=A0=A0=A0=A0kref_get(&pg->kref);
> +
> =A0=A0=A0=A0=A0=A0=A0=A0/* Check for existing port group references */
> =A0=A0=A0=A0=A0=A0=A0=A0spin_lock(&h->pg_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0old_pg =3D rcu_dereference_protected(h->pg, lockd=
ep_is_held(&h-
> >pg_lock));
> @@ -373,11 +375,11 @@ static int alua_check_vpd(struct scsi_device
> *sdev, struct alua_dh_data *h,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_rcu(&h->node, &p=
g->dh_list);
> =A0=A0=A0=A0=A0=A0=A0=A0spin_unlock_irqrestore(&pg->lock, flags);
>=20
> -=A0=A0=A0=A0=A0=A0=A0alua_rtpg_queue(rcu_dereference_protected(h->pg,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lo=
ckdep_is_held(&h-
> >pg_lock)),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sde=
v, NULL, true);
> =A0=A0=A0=A0=A0=A0=A0=A0spin_unlock(&h->pg_lock);
>=20
> +=A0=A0=A0=A0=A0=A0=A0alua_rtpg_queue(pg, sdev, NULL, true);
> +=A0=A0=A0=A0=A0=A0=A0kref_put(&pg->kref, release_port_group);
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if (old_pg)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kref_put(&old_pg->kref, r=
elease_port_group);
>=20
> @@ -986,6 +988,9 @@ static bool alua_rtpg_queue(struct
> alua_port_group *pg,
> =A0 {
> =A0=A0=A0=A0=A0=A0=A0=A0int start_queue =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned long flags;
> +
> +=A0=A0=A0=A0=A0=A0=A0might_sleep();
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
>=20
> @@ -996,11 +1001,17 @@ static bool alua_rtpg_queue(struct
> alua_port_group *pg,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0force =3D true;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (pg->rtpg_sdev =3D=3D NULL) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->interval =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->flags |=3D ALUA_PG_RUN_=
RTPG;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kref_get(&pg->kref);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->rtpg_sdev =3D sdev;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0start_queue =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct alua_dh_data *h =3D =
sdev->handler_data;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rcu_read_lock();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rcu_dereference(h->pg) =
=3D=3D pg) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg-=
>interval =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg-=
>flags |=3D ALUA_PG_RUN_RTPG;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kre=
f_get(&pg->kref);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg-=
>rtpg_sdev =3D sdev;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sta=
rt_queue =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rcu_read_unlock();
> =A0=A0=A0=A0=A0=A0=A0=A0} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && for=
ce) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pg->flags |=3D ALUA_PG_RU=
N_RTPG;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Do not queue if the wo=
rker is already running */
> @@ -1246,8 +1257,8 @@ static void alua_bus_detach(struct scsi_device
> *sdev)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0spin_unlock_irq(&pg->lock=
);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kref_put(&pg->kref, relea=
se_port_group);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0sdev->handler_data =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0synchronize_rcu();
> +=A0=A0=A0=A0=A0=A0=A0sdev->handler_data =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0kfree(h);
> =A0 }
>=20

