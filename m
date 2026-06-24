Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC8316197
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325998; cv=none; b=DKrAlBALp/mWb3bTzeX5MnpRl7UXlOBQYbkQPU2HBzHP07sCbuHbFY0yVQlWNVY4MlBjYhP+Erm+qy2PY4tqyXBVJ8qHWgeERWBQv1WKmSb/0MfHpNiS5D0LxCsDjPeGbEN5z/jNyQRNyjBf5ims/6AoTdfBPTnx4aFjQIZBBGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325998; c=relaxed/simple;
	bh=d6SS2hdmFREsNjmOmyRiyLOoyxKlUipWPae5EI0+XTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJUwf5NP3O24vYVzrp85sonp+y58Wf+9AtJA5XbRhXh0M26Cga0vjUlFGpT7Ii7RTZ6flV4tkB6TjNJdenGv2lYyPkVpowe+8/UFmA5jT048qicmT+VDol0y3enEtNbFksKvBzBs7bd0K3Oh3P1LPNnRQPsl9X1CS6p71kvXb9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OsfGCa6K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsfGCa6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782325995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xli+07pdTqJ8w2g88YzSHaZ2kwsq+VarNsXrNo5aBRY=;
	b=OsfGCa6KlT/m+hNcl1HpTz/OsgQ36vIRmBrXUNZhv7pehO6YraZ8SiS+YD8WRrsO/FvtPG
	WO4THBsLGORgMU9BjHC2gsbNJkHifbHr84UFPyU4i8P1vj6AXuurTyv44DkQ7dPi3QE2Fn
	edafwsbMqfEUcallCnBPTTXTwtesUQk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-VhYs4R9xMi25T5A4kbi8oQ-1; Wed,
 24 Jun 2026 14:33:11 -0400
X-MC-Unique: VhYs4R9xMi25T5A4kbi8oQ-1
X-Mimecast-MFC-AGG-ID: VhYs4R9xMi25T5A4kbi8oQ_1782325990
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92C8B19560BA;
	Wed, 24 Jun 2026 18:33:09 +0000 (UTC)
Received: from localhost (unknown [10.2.17.97])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D61DE180057F;
	Wed, 24 Jun 2026 18:33:08 +0000 (UTC)
Date: Wed, 24 Jun 2026 14:07:49 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: fixup endian conversions for warning
 messages
Message-ID: <20260624180749.GF109308@fedora>
References: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DAJOO0OXErLxQASI"
Content-Disposition: inline
In-Reply-To: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--DAJOO0OXErLxQASI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 02:24:27PM +0100, Ben Dooks wrote:
> There are several places where printing functions are being passed parame=
ters
> that have not been through endian conversion functions. Use the virtio32_=
to_cpu
> to fix the warnings.
>=20
> Fixes the following warnings from (prototype) sparse:
> drivers/scsi/virtio_scsi.c:126:9: warning: incorrect type in argument 7 (=
different base types)
> drivers/scsi/virtio_scsi.c:126:9:    expected unsigned int
> drivers/scsi/virtio_scsi.c:126:9:    got restricted __virtio32 [usertype]=
 sense_len
> drivers/scsi/virtio_scsi.c:312:17: warning: incorrect type in argument 2 =
(different base types)
> drivers/scsi/virtio_scsi.c:312:17:    expected unsigned int
> drivers/scsi/virtio_scsi.c:312:17:    got restricted __virtio32 [usertype=
] reason
> drivers/scsi/virtio_scsi.c:412:17: warning: incorrect type in argument 2 =
(different base types)
> drivers/scsi/virtio_scsi.c:412:17:    expected unsigned int
> drivers/scsi/virtio_scsi.c:412:17:    got restricted __virtio32 [usertype=
] event
>=20
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  drivers/scsi/virtio_scsi.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--DAJOO0OXErLxQASI
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmo8HPUACgkQnKSrs4Gr
c8h8fwgAkHu+pNIrC4nVmraazySiZY04aaupHXw+4tH5J7KKXRD9Vt7VwE22Uz4p
JN9PUE1L5QmeLzohWpRczEtbBy1WCCvMNiaPRmxsYkGRC1r/ZVfGKrfG28NVQSVc
E4q8/w64HBPWjSqWFV4quEvD2HqYyVrF7NUUii+kMWlcCTJmIANJj9pAyQSGLJwM
63owTfg323lVguFIl2eEhx5MTL3ZhWUijIo4uudQbFyKyq9+ltuI8QWCbpmGqM7Y
MHM+hSO7+M0jKKd4S7Akz2g0HUFCj1COi+SJLBWWl2z6nRt+/EXqdqA4E0OtzYh7
ZueUkRSKF6YAMk5PjkHnCoM/i11LuQ==
=UW4F
-----END PGP SIGNATURE-----

--DAJOO0OXErLxQASI--

