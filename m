Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FECC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA6361040
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 09:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbhJ0JGR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234246AbhJ0JGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 05:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635325430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HiJPaiuyZPbcdwIA9KdMWyKh2jI2bcomXoBjA/5KsHk=;
        b=LzFMhfrh7nUUrqhWsLi+orKVVzFLYB9Etd7vFP28casr4fW9Kilj+nDgen6B6Y5sjFqz9C
        DoREKxKrDK8lyQss/wK5/I6bO8Yh/rEhvYWuLVGl1M1yAHqMzebrU4oLfzQF3MgeF9/hmh
        SYKHIuRrXGAt9iDblpUuY/NK4Le6Z0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-2IE4rjOqM8SdmhK3Pzt2HQ-1; Wed, 27 Oct 2021 05:03:48 -0400
X-MC-Unique: 2IE4rjOqM8SdmhK3Pzt2HQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A90189126B;
        Wed, 27 Oct 2021 09:03:47 +0000 (UTC)
Received: from localhost (unknown [10.39.195.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FCDD5F4EE;
        Wed, 27 Oct 2021 09:03:44 +0000 (UTC)
Date:   Wed, 27 Oct 2021 10:03:43 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     michael.christie@oracle.com
Cc:     Jason Wang <jasowang@redhat.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, pbonzini@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXkV73jK7fNGzcoX@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
 <4d33b7e1-5efb-3729-ee15-98608704f096@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7VOiUeZYb/rbOPB5"
Content-Disposition: inline
In-Reply-To: <4d33b7e1-5efb-3729-ee15-98608704f096@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--7VOiUeZYb/rbOPB5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2021 at 11:49:37AM -0500, michael.christie@oracle.com wrote:
> On 10/26/21 12:37 AM, Jason Wang wrote:
> > Do we need VHOST_VRING_FREE_WORKER? And I wonder if using dedicated ioc=
tls are better:
> >=20
> > VHOST_VRING_NEW/FREE_WORKER
> > VHOST_VRING_ATTACH_WORKER
>=20
>=20
> We didn't need a free worker, because the kernel handles it for userspace=
=2E I
> tried to make it easy for userspace because in some cases it may not be a=
ble
> to do syscalls like close on the device. For example if qemu crashes or f=
or
> vhost-scsi we don't do an explicit close during VM shutdown.
>=20
> So we start off with the default worker thread that's used by all vqs lik=
e we do
> today. Userspace can then override it by creating a new worker. That also=
 unbinds/
> detaches the existing worker and does a put on the workers refcount. We a=
lso do a
> put on the worker when we stop using it during device shutdown/closure/re=
lease.
> When the worker's refcount goes to zero the kernel deletes it.

Please document the worker (p)id lifetime for the ioctl. Otherwise
userspace doesn't know whether a previously created worker is still
alive.

SSTefan

--7VOiUeZYb/rbOPB5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF5Fe8ACgkQnKSrs4Gr
c8jfMwf/WNxR+7YZbmsVZ+oUXAYb2qAG6sPNc4zPOt3GHye/2a0FuI59d6dKn/R9
aNuf1C/a5YMTigcqOSnV3pHjLEjQP7hHElDGJJIePNJqHTRf8rgRHX/+ORalRu24
HH6CkCfGvwKkfztFa1jjwc9e6YNjtSVXBsPcD9EV3WQ7ZO5BaRBL8fiEcoHWmhRJ
8YUO6TCv+aSZFltkM+9G3DBf90SPrcwixImuesvbP8J455/zAwBg4tYns0YLZvW5
4PcbVP56MyoThHzbfA7g8FFLct9zDr4cFGYjuq+q8YX2da+dILEY/5PHkjPzWKcp
ahFfycIxAyGsIcgqEtpcu7WC0HIFVg==
=87xD
-----END PGP SIGNATURE-----

--7VOiUeZYb/rbOPB5--

