Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4768C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEE760FC0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbhJ0JEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236159AbhJ0JEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 05:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635325315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wauAe2a13htRLUou8eOus0V9+ON8mGohpili1PfUnLw=;
        b=WU5oSqFxsH7McH5rXLzZdb9MspE+7Hb8E1S3uspCY4afZQ0QGde8oYBgI97q5FjOBiifAW
        jKCy6yngMG45idtVHahSMYB6oOuJn67K+dNLKXZP2BX13rjgx7FyxEbS1z8p+MVp5oL861
        NVr5CZZSBk/X/xxzsYLnzYy2JiEMKhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-lYaDzzYRPyafPQ7MRBjptQ-1; Wed, 27 Oct 2021 05:01:51 -0400
X-MC-Unique: lYaDzzYRPyafPQ7MRBjptQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A72F19200CB;
        Wed, 27 Oct 2021 09:01:50 +0000 (UTC)
Received: from localhost (unknown [10.39.195.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2595779450;
        Wed, 27 Oct 2021 09:01:49 +0000 (UTC)
Date:   Wed, 27 Oct 2021 10:01:49 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini <pbonzini@redhat.com>, mst <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXkVfbdOEKTPnY+t@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
 <YXgiYFIUTKtoRJWW@stefanha-x1.localdomain>
 <CACGkMEsD=JwjWgTM4XpcKVy+ZKs6siW_1Q=3zzB8jZ3vq1CyZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zhj4RK4pWGOqEvNg"
Content-Disposition: inline
In-Reply-To: <CACGkMEsD=JwjWgTM4XpcKVy+ZKs6siW_1Q=3zzB8jZ3vq1CyZA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--zhj4RK4pWGOqEvNg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 27, 2021 at 10:55:04AM +0800, Jason Wang wrote:
> On Tue, Oct 26, 2021 at 11:45 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Tue, Oct 26, 2021 at 01:37:14PM +0800, Jason Wang wrote:
> > >
> > > =E5=9C=A8 2021/10/22 =E4=B8=8B=E5=8D=881:19, Mike Christie =E5=86=99=
=E9=81=93:
> > > > This patch allows userspace to create workers and bind them to vqs.=
 You
> > > > can have N workers per dev and also share N workers with M vqs.
> > > >
> > > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > >
> > >
> > > A question, who is the best one to determine the binding? Is it the V=
MM
> > > (Qemu etc) or the management stack? If the latter, it looks to me it's
> > > better to expose this via sysfs?
> >
> > A few options that let the management stack control vhost worker CPU
> > affinity:
> >
> > 1. The management tool opens the vhost device node, calls
> >    ioctl(VHOST_SET_VRING_WORKER), sets up CPU affinity, and then passes
> >    the fd to the VMM. In this case the VMM is still able to call the
> >    ioctl, which may be undesirable from an attack surface perspective.
>=20
> Yes, and we can't do post or dynamic configuration afterwards after
> the VM is launched?

Yes, at least it's a little risky for the management stack to keep the
vhost fd open and make ioctl calls while the VMM is using it.

> >
> > 2. The VMM calls ioctl(VHOST_SET_VRING_WORKER) itself and the management
> >    tool queries the vq:worker details from the VMM (e.g. a new QEMU QMP
> >    query-vhost-workers command similar to query-iothreads). The
> >    management tool can then control CPU affinity on the vhost worker
> >    threads.
> >
> >    (This is how CPU affinity works in QEMU and libvirt today.)
>=20
> Then we also need a "bind-vhost-workers" command.

The VMM doesn't but the management tool does.

Stefan

--zhj4RK4pWGOqEvNg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF5FXwACgkQnKSrs4Gr
c8jO1wgAtIXGYe1wRi8nwef0ov+cUVVVhMWYzrRpJBtIQlvn8M4oMTBBlAAeaBZP
QzHjuCcS3mcx0Ab4Q/wDJDwNbgm6GW9ucaGWkWUsu2htgZcWg2pYm2xE3jWeavR7
AoDJlLUbC8fmI9hbOMtTqDpsAUXAuiEfw3ht3DAN2mS09w/6Qxnd5/ATLz1vfg1h
0uZesc1w+bfikB2Wg6KtaveBtEPJbzMUHI0alpyevi0Y2oswUZ9FKmLSsaDXmQAm
9Y8vwP0TZZW/G2868ilGJLMy5w66eUcSC6Mixiylhe/7SvieSmTK81Bp6vgZur3z
Fmfyjq6XCgDGA2aGgqbIaDAZbWiBNg==
=rfJ4
-----END PGP SIGNATURE-----

--zhj4RK4pWGOqEvNg--

