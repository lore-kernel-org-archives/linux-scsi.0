Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50816C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F3D60F02
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhJZQjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234299AbhJZQje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 12:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635266230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Az0qkUpjldfbOLg6I432oCB5a4nNHQuU76umLMMYadU=;
        b=QA3vUANKqKePy+slHM3UmZJHiVrXZLTBSrfTOK3Cc1QqvtyKBa4ozHKF6FsTX3UnZeGwF1
        8WfuJXWStymMCgb+N95h+ZkPf3LKwFpKDSc6wKYu4lbPkHm2X+6dQ3lSAHkdZ6TE+fYSCM
        8dZTTZufcgqTZZcFKbCfV+LdOo4vGOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-ofjAw7OzNPiZ9ZDYuJ9RoA-1; Tue, 26 Oct 2021 12:37:06 -0400
X-MC-Unique: ofjAw7OzNPiZ9ZDYuJ9RoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF0C3806688;
        Tue, 26 Oct 2021 16:37:05 +0000 (UTC)
Received: from localhost (unknown [10.39.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53A785FC13;
        Tue, 26 Oct 2021 16:36:57 +0000 (UTC)
Date:   Tue, 26 Oct 2021 17:36:56 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXguqJmsWVEnrgA7@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
 <20211026090923-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1ineXJazAgcBuxtr"
Content-Disposition: inline
In-Reply-To: <20211026090923-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--1ineXJazAgcBuxtr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2021 at 09:09:52AM -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 26, 2021 at 01:37:14PM +0800, Jason Wang wrote:
> >=20
> > =E5=9C=A8 2021/10/22 =E4=B8=8B=E5=8D=881:19, Mike Christie =E5=86=99=E9=
=81=93:
> > > This patch allows userspace to create workers and bind them to vqs. Y=
ou
> > > can have N workers per dev and also share N workers with M vqs.
> > >=20
> > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> >=20
> >=20
> > A question, who is the best one to determine the binding? Is it the VMM
> > (Qemu etc) or the management stack? If the latter, it looks to me it's
> > better to expose this via sysfs?
>=20
> I think it's a bit much to expect this from management.

The management stack controls the number of vqs used as well as the vCPU
and IOThread CPU affinity. It seems natural for it to also control the
vhost worker CPU affinity. Where else should that be controlled?

Stefan

--1ineXJazAgcBuxtr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF4LqgACgkQnKSrs4Gr
c8iD5wgAsuJ8yfTtumt6et4Z9rKxpsJsIoaFnmQPbxkXAOBMuTqZ2viOvqn1dIfo
niOTLg4+L9z5Gns9Lhew9DfnZZit0SQqra+DAwswoUxBw6vxuzhO7ZkBfzK7H59m
fQj/yd//kENNW/sTpnMaYk13FpvtXSMhWmm93Kp2hBExvrJoXoqf9UF4Cc06KDjf
rBtXEbSifXixOEdboxaQTDD3a5aycpYdpm7DtaBlIw7698jymOY/uR0lQ6AfeHj5
qbskHy+VKwOwPvmQtk41QHz4rT8BsZSLpJQ24ZFzUDr7sJisbBM1Ula0NkI16GPZ
sd1S1pC5t+Ke/8RvzSXeB26xaBbOuw==
=EGIY
-----END PGP SIGNATURE-----

--1ineXJazAgcBuxtr--

