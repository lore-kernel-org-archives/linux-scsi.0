Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A75C5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 15:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46BFF2463D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 15:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyLKk4E+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgKQPc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 10:32:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbgKQPc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 10:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605627148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wLVAtYjVS9UVZg93yIztzkKAu2j+G+0Xum5F8J6uQuk=;
        b=gyLKk4E+nuBQqI/+BhEJqBfyiCzExtiMKDQVoSBgzPvTQdl4LkGkgw22JL9flAGgU6/Ifr
        QJnGVMHhTv0dFTui+vsp/uMfCKUwEdBESnwKjjyzChk7G67Vjzv3H1Oe1BKCSi6xwqfte3
        x9XipmW9S1kKZJs1gDUHb/966out/+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-VgzRt7eHMj64zcp_JPCINg-1; Tue, 17 Nov 2020 10:32:25 -0500
X-MC-Unique: VgzRt7eHMj64zcp_JPCINg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0ADC1800D42;
        Tue, 17 Nov 2020 15:32:23 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C78B1974D;
        Tue, 17 Nov 2020 15:32:20 +0000 (UTC)
Date:   Tue, 17 Nov 2020 15:32:19 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/10] vhost: poll support support multiple workers
Message-ID: <20201117153219.GN131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-7-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-7-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3hAdtgBjtgL7p0NQ"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--3hAdtgBjtgL7p0NQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:19:05PM -0600, Mike Christie wrote:
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d229515..9eeb8c7 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -187,13 +187,15 @@ void vhost_work_init(struct vhost_work *work, vhost=
_work_fn_t fn)
> =20
>  /* Init poll structure */
>  void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
> -=09=09     __poll_t mask, struct vhost_dev *dev)
> +=09=09     __poll_t mask, struct vhost_dev *dev,
> +=09=09     struct vhost_virtqueue *vq)
>  {
>  =09init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
>  =09init_poll_funcptr(&poll->table, vhost_poll_func);
>  =09poll->mask =3D mask;
>  =09poll->dev =3D dev;
>  =09poll->wqh =3D NULL;
> +=09poll->vq =3D vq;
> =20
>  =09vhost_work_init(&poll->work, fn);
>  }

Tying the poll mechanism to vqs rather than directly to vhost_worker
seems okay for now, but it might be necessary to change this later if
drivers want more flexibility about poll something that's not tied to a
vq or that uses worker 0.

Stefan

--3hAdtgBjtgL7p0NQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+z7QMACgkQnKSrs4Gr
c8heSgf/U4+UEuXuZ0CZCYgD7Qauq2K06gDJ32h3QmIb6XTaQmSneBT3FsOoYjgJ
iph3VMECwKocLt/ABeniUqw/7zVeKj+hj5fC/bu0twjhjtsA7FdvJcBeB5Ism1Nj
3fYfDDpVE8zuO6h8fBwXqn0sGqNZOdbx7jWVZaE311gnxXuutC+k6N+uAFh8Y29G
YEK2nP94JQXUC3o7ET+vxDaktr2pmj4GomC528mfgmaVa5faFKX9fpp4jEOZwQHq
E7p0qEHp+lubeZAXeNj/ZQVQ7apxxXD9rw5br3uq9BrjzoTWF30qLETDo8ihoz6m
IuoPoKFk5k+OXDn0mJWCfMYsJOBu4w==
=MdBC
-----END PGP SIGNATURE-----

--3hAdtgBjtgL7p0NQ--

