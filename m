Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4943CC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 11:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD818241A5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 11:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gv2s9pL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKRLbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 06:31:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgKRLbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 06:31:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605699095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4klu/6VLPeehKC0MRm/Zpkk011aelEzsRD3uMBe14/8=;
        b=Gv2s9pL8SaUL8wiw+WKoGgyIs9TRzoBtnZFi8iXYIzgUfMCPiCYu5KXYzOH/MyPe19oraA
        Wo0iRvOp92it7T0+E1S5nZ63ScQFrWHcdddeW+VgGbQpo0YEtZdgd+4ZLlg0WIZAaea7e6
        nd3XpmbBFESeLh+HiDm8LokGSX+0bnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-S28dO65_M5iUYAS-Hqtjyw-1; Wed, 18 Nov 2020 06:31:30 -0500
X-MC-Unique: S28dO65_M5iUYAS-Hqtjyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FFFF107B293;
        Wed, 18 Nov 2020 11:31:28 +0000 (UTC)
Received: from localhost (ovpn-114-60.ams2.redhat.com [10.36.114.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDEE560C43;
        Wed, 18 Nov 2020 11:31:18 +0000 (UTC)
Date:   Wed, 18 Nov 2020 11:31:17 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201118113117.GF182763@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
MIME-Version: 1.0
In-Reply-To: <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DEueqSqTbz/jWVG1"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--DEueqSqTbz/jWVG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2020 at 01:13:14PM -0600, Mike Christie wrote:
> On 11/17/20 10:40 AM, Stefan Hajnoczi wrote:
> > On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
> >> The following kernel patches were made over Michael's vhost branch:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=
=3Dvhost
> >>
> >> and the vhost-scsi bug fix patchset:
> >>
> >> https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x=
1.localdomain/T/#t
> >>
> >> And the qemu patch was made over the qemu master branch.
> >>
> >> vhost-scsi currently supports multiple queues with the num_queues
> >> setting, but we end up with a setup where the guest's scsi/block
> >> layer can do a queue per vCPU and the layers below vhost can do
> >> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
> >> but all IO gets set on and completed on a single vhost-scsi thread.
> >> After 2 - 4 vqs this becomes a bottleneck.
> >>
> >> This patchset allows us to create a worker thread per IO vq, so we
> >> can better utilize multiple CPUs with the multiple queues. It
> >> implments Jason's suggestion to create the initial worker like
> >> normal, then create the extra workers for IO vqs with the
> >> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
> >=20
> > How does userspace find out the tids and set their CPU affinity?
> >=20
>=20
> When we create the worker thread we add it to the device owner's cgroup,
> so we end up inheriting those settings like affinity.
>=20
> However, are you more asking about finer control like if the guest is
> doing mq, and the mq hw queue is bound to cpu0, it would perform
> better if we could bind vhost vq's worker thread to cpu0? I think the
> problem might is if you are in the cgroup then we can't set a specific
> threads CPU affinity to just one specific CPU. So you can either do
> cgroups or not.
>=20
>=20
> > What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
> > really "enable" or "disable" the vq, requests are processed regardless.
> >=20
>=20
> Yeah, I agree. The problem I've mentioned before is:
>=20
> 1. For net and vsock, it's not useful because the vqs are hard coded in
> the kernel and userspace, so you can't disable a vq and you never need
> to enable one.
>=20
> 2. vdpa has it's own enable ioctl.
>=20
> 3. For scsi, because we already are doing multiple vqs based on the
> num_queues value, we have to have some sort of compat support and
> code to detect if userspace is even going to send the new ioctl.
> In this patchset, compat just meant enable/disable the extra functionalit=
y
> of extra worker threads for a vq. We will still use the vq if
> userspace set it up.
>=20
>=20
> > The purpose of the ioctl isn't clear to me because the kernel could
> > automatically create 1 thread per vq without a new ioctl. On the other
> > hand, if userspace is supposed to control worker threads then a
> > different interface would be more powerful:
> >=20

The main request I have is to clearly define the meaning of the
VHOST_SET_VRING_ENABLE ioctl. If you want to keep it as-is for now and
the vhost maintainers are happy with then, that's okay. It should just
be documented so that userspace and other vhost driver authors
understand what it's supposed to do.

> My preference has been:
>=20
> 1. If we were to ditch cgroups, then add a new interface that would allow
> us to bind threads to a specific CPU, so that it lines up with the guest'=
s
> mq to CPU mapping.

A 1:1 vCPU/vq->CPU mapping isn't desirable in all cases.

The CPU affinity is a userspace policy decision. The host kernel should
provide a mechanism but not the policy. That way userspace can decide
which workers are shared by multiple vqs and on which physical CPUs they
should run.

Stefan

--DEueqSqTbz/jWVG1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+1BgUACgkQnKSrs4Gr
c8gQ8gf/W0FT+4mtlnBc1yI9COd4MhYzjWL16Evq9DEgWquUzme1kaqRI7BlJytk
WTMMYhgdHP6+ema9RCf4p53nO5wG+mordaLuyYBiXt0KmhZjZll+rbi/X+FkazQ/
PBTy38MCHBUY0aqtbtLSvEUSWmzDmPsNPGN+QdXbDmYL41n9J8nXlFwhFF+oKAtZ
GnSwDNaMssjd9pQetIQ8voNXguTkfpifUYYpSRZ5nKtrtzT3eQxFUA8Xe6GXE1Rd
1Nx4SjBo7EiQQ4WI83cjGIP8gjX2TQ21dlybNRal1sd++To0lpRy1j1qlm875DVg
WR0YSP5J+YGIAdY/BRQ2w2SY9SBoLg==
=/BhM
-----END PGP SIGNATURE-----

--DEueqSqTbz/jWVG1--

