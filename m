Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE67C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C9261040
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbhJZPr3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 11:47:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237052AbhJZPrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 11:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635263099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydavJn7DI5FQeuBROtYPyYrL+o3WSf2VUpZ//UwJoaI=;
        b=NaB6nPGgUEibfR+/4rT3E0e8cMnRK1C7WhC0RKOGX0fRVqFSMycZT53g6WG2xMZjzpY9lB
        2vwianhNxcVLTXqvqiFYYEl/WuSFEbKmipY9T1sHomHQ4uMTu0zH0bm2A7omySEKG/WN28
        bDkZfSXRcZnQpCF2zqtM4ypby2NsWmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-lhFgLe3HMe-kxCJV5owltA-1; Tue, 26 Oct 2021 11:44:57 -0400
X-MC-Unique: lhFgLe3HMe-kxCJV5owltA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B1C55074C;
        Tue, 26 Oct 2021 15:44:56 +0000 (UTC)
Received: from localhost (unknown [10.39.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 956B6AFD87;
        Tue, 26 Oct 2021 15:44:33 +0000 (UTC)
Date:   Tue, 26 Oct 2021 16:44:32 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXgiYFIUTKtoRJWW@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VMwuMuFNjq9JI4o+"
Content-Disposition: inline
In-Reply-To: <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--VMwuMuFNjq9JI4o+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2021 at 01:37:14PM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/10/22 =E4=B8=8B=E5=8D=881:19, Mike Christie =E5=86=99=E9=
=81=93:
> > This patch allows userspace to create workers and bind them to vqs. You
> > can have N workers per dev and also share N workers with M vqs.
> >=20
> > Signed-off-by: Mike Christie <michael.christie@oracle.com>
>=20
>=20
> A question, who is the best one to determine the binding? Is it the VMM
> (Qemu etc) or the management stack? If the latter, it looks to me it's
> better to expose this via sysfs?

A few options that let the management stack control vhost worker CPU
affinity:

1. The management tool opens the vhost device node, calls
   ioctl(VHOST_SET_VRING_WORKER), sets up CPU affinity, and then passes
   the fd to the VMM. In this case the VMM is still able to call the
   ioctl, which may be undesirable from an attack surface perspective.

2. The VMM calls ioctl(VHOST_SET_VRING_WORKER) itself and the management
   tool queries the vq:worker details from the VMM (e.g. a new QEMU QMP
   query-vhost-workers command similar to query-iothreads). The
   management tool can then control CPU affinity on the vhost worker
   threads.

   (This is how CPU affinity works in QEMU and libvirt today.)

3. The sysfs approach you suggested. Does sysfs export vq-0/, vq-1/, etc
   directories with a "worker" attribute? Do we need to define a point
   when the VMM has set up vqs and the management stack is able to query
   them? Vhost devices currently pre-allocate the maximum number of vqs
   and I'm not sure how to determine the number of vqs that will
   actually be used?

   One advantage of this is that access to the vq:worker mapping can be
   limited to the management stack and the VMM cannot access it. But it
   seems a little tricky because the vhost model today doesn't use sysfs
   or define a lifecycle where the management stack can configure
   devices.

Stefan

--VMwuMuFNjq9JI4o+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF4ImAACgkQnKSrs4Gr
c8gRxgf/e4VddkwF5mz1ehejjissc2bD+9Qs4+4UBTGivifiCSzfT6H9wO4jnas2
iyTdVOfZrtNR1TpeHFlgl8oOAM8VGL6lOkeshxznpITYwit2yfZWRZS67bR1lP4e
aC5STvrI9s8uglVezSIfFvlLwqDfzaSA0QyZiyOZjrVJ4Tru/BB2CjGttuW07D2r
vFu4qZRjmbeugTSklPMvhKSGVN5dfunFZ/AYIH5QypUW01T5LkE23F7Z2TULidjT
lmKeR9QLvG8vvw8r7bRdfG2lhqz244jAEGwKYKnoiUQhOEyxgOz7X4zOLNfkeIOg
jJqvytP/GaJjYNtanCW5j/zn1o/xwA==
=yQjM
-----END PGP SIGNATURE-----

--VMwuMuFNjq9JI4o+--

