Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1577BC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52AB6141C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhEYQtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 12:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232479AbhEYQtP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 12:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621961264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fL6Y/duGHBMJKkmMDJ4jflONRQgZgnAzPjAPflMfB2s=;
        b=NirqhuDVVDLTpqdbUNHL4TtQ8UcYuD8wcTaOtX0CZxeLb4ir/ucGSE278+bmp/Cbj37WBA
        bkUiIRMMaM1fl2MAbroxbE8lrDWYo9//TnwbUVpSGlja58E4IZHrd+MAFDhZy+fgWbyOmm
        1x6uygak2EVcRUXmM/9sEraDQqUrYmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-M1ILaIflOF2vHlFCyOjrRg-1; Tue, 25 May 2021 12:47:42 -0400
X-MC-Unique: M1ILaIflOF2vHlFCyOjrRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B8AA180FD66;
        Tue, 25 May 2021 16:47:41 +0000 (UTC)
Received: from localhost (ovpn-115-80.ams2.redhat.com [10.36.115.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 449B9421F;
        Tue, 25 May 2021 16:47:37 +0000 (UTC)
Date:   Tue, 25 May 2021 17:47:36 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, joe.jin@oracle.com,
        junxiao.bi@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [RFC] virtio_scsi: to poll and kick the virtqueue in timeout
 handler
Message-ID: <YK0qKMF0I8Wm1euN@stefanha-x1.localdomain>
References: <20210523063843.1177-1-dongli.zhang@oracle.com>
 <ac161748-15d2-2962-402e-23abca469623@suse.de>
 <YKupFeOtc6Pr5KS2@stefanha-x1.localdomain>
 <a0404035-2ab7-6b9c-f393-0bb0417c4b3d@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VNMvGmWXBqxStO+j"
Content-Disposition: inline
In-Reply-To: <a0404035-2ab7-6b9c-f393-0bb0417c4b3d@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--VNMvGmWXBqxStO+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 24, 2021 at 11:33:33PM -0700, Dongli Zhang wrote:
> On 5/24/21 6:24 AM, Stefan Hajnoczi wrote:
> > On Sun, May 23, 2021 at 09:39:51AM +0200, Hannes Reinecke wrote:
> >> On 5/23/21 8:38 AM, Dongli Zhang wrote:
> >>> This RFC is to trigger the discussion about to poll and kick the
> >>> virtqueue on purpose in virtio-scsi timeout handler.
> >>>
> >>> The virtio-scsi relies on the virtio vring shared between VM and host.
> >>> The VM side produces requests to vring and kicks the virtqueue, while=
 the
> >>> host side produces responses to vring and interrupts the VM side.
> >>>
> >>> By default the virtio-scsi handler depends on the host timeout handler
> >>> by BLK_EH_RESET_TIMER to give host a chance to perform EH.
> >>>
> >>> However, this is not helpful for the case that the responses are avai=
lable
> >>> on vring but the notification from host to VM is lost.
> >>>
> >> How can this happen?
> >> If responses are lost the communication between VM and host is broken,=
 and
> >> we should rather reset the virtio rings themselves.
> >=20
> > I agree. In principle it's fine to poll the virtqueue at any time, but I
> > don't understand the failure scenario here. It's not clear to me why the
> > device-to-driver vq notification could be lost.
> >=20
>=20
> One example is the CPU hotplug issue before the commit bf0beec0607d ("blk=
-mq:
> drain I/O when all CPUs in a hctx are offline") was available. The issue =
is
> equivalent to loss of interrupt. Without the CPU hotplug fix, while NVMe =
driver
> relies on the timeout handler to complete inflight IO requests, the PV
> virtio-scsi may hang permanently.
>=20
> In addition, as the virtio/vhost/QEMU are complex software, we are not ab=
le to
> guarantee there is no further lost of interrupt/kick issue in the future.=
 It is
> really painful if we encounter such issue in production environment.

Any number of hardware or software bugs might exist that we don't know
about, yet we don't pre-emptively add workarounds for them because where
do you draw the line?

I checked other SCSI/block drivers and found it's rare to poll in the
timeout function so there does not seem to be a consensus that it's
useful to do this.

That said, it's technically fine to do it, the virtqueue APIs are there
and can be used like this. So if you and others think this is necessary,
then it's a pretty small change and I'm not against merging a patch like
this.

Stefan

--VNMvGmWXBqxStO+j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCtKigACgkQnKSrs4Gr
c8jE6gf/SzpIij5k5NFqXRfDYjrAoN/hHDK0f8rALj06t2cmrKq1LugoGygtb4nd
MmJypVvxZZW037iS8fChHC5kcqvBA9Y/N+0tABVJNT8GHLnvDZI8diTONgXVUCzj
X/u0+3EjQNz2TX6W9pZbEJmeVv0z7JiWCQKcLf9DYq77Xei8U4U5Xv4k0Nks1b1A
PFH+j4R42eYdziIwwxCPgAQtlCWlTgWbGO9B14kqeybM7I9pq2Ar+WQXIItptuuA
9R3RBQ6n1cOqtiOHwOXjz2Y4zSa3o4jrLeV8/u3MEmZAwpc2+1A7QL+fW2uxpWJf
7geSWXbXMdwb7odJ+yKHBNAMOjZqmA==
=d024
-----END PGP SIGNATURE-----

--VNMvGmWXBqxStO+j--

