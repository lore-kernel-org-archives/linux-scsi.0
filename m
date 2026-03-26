Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD12F5498
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774533651; cv=none; b=LvR9PnurFiYCUABIybVmqLreTYENBtJbpOL/BUm0EYxaXecqF94rY4ogjl9uDEjktUbGFkl0pmVWOXa4f15KgD3mdxgPJ2jZOhGO4QRr61cQmFpHkep78q46jWnGrGLLqy6wVHGflFRdWzI25t+rn0QjwmvkrqeAxwNjTqWvcq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774533651; c=relaxed/simple;
	bh=KTRKonfGUd97+mpSwvoA/3Jmlf8IN1wJ4LosLVYKkrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWGLxu5rt3zB3Zjr1RRuLq/2jq2W9OnKUYxsd1PYrDjzrFMWNYv8ocxDHMPnXys/ltDnTcL1d7d9jdToIvF5VIASBvbqaKqqvhtaAcxk2Z12YtnVz5WZDM1bb0wscCBn9X/Mp46KShMyLVwv/q3fId6bhW70buxqJ3MuBKI7X4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODWxKMoP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODWxKMoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774533643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ud6/uRMMbQ6RHbdjTkyUxh57Nx1jsGx4SxZ5+YkVoU=;
	b=ODWxKMoPGH2AKX0trIY+YjkpbUyIz316kC7HMVtAGIXeRpksJKE+IojvrmkbZVckX1o03Q
	KNwbbSmJwL885KVDodqMcZdXXq10Zg61Fx3TDAgBjK+8SP01T3MJUSXoszrCZIqUVCOFj3
	LWWya67AmZ2fjskbcQjMJguYy2bcdzQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-U6nCzDQ8OTKuAhhnq91FsA-1; Thu,
 26 Mar 2026 10:00:40 -0400
X-MC-Unique: U6nCzDQ8OTKuAhhnq91FsA-1
X-Mimecast-MFC-AGG-ID: U6nCzDQ8OTKuAhhnq91FsA_1774533638
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEBF619560B4;
	Thu, 26 Mar 2026 14:00:37 +0000 (UTC)
Received: from localhost (unknown [10.44.35.38])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65F9218001FE;
	Thu, 26 Mar 2026 14:00:36 +0000 (UTC)
Date: Thu, 26 Mar 2026 10:00:33 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v4 1/2] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_probe
Message-ID: <20260326140033.GC758087@fedora>
References: <20260325180857.3675854-1-jdaley@linux.ibm.com>
 <20260325180857.3675854-2-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eEXDPCt21ng7yGj2"
Content-Disposition: inline
In-Reply-To: <20260325180857.3675854-2-jdaley@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--eEXDPCt21ng7yGj2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 07:08:56PM +0100, Joshua Daley wrote:
> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
> which calls INIT_WORK on it's own work item. INIT_WORK resets the
> work item's data bits to 0.
>=20
> If this occurs while the work item is being flushed by
> cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
> kernel warning, as it expects the "disable" bit to be 1:
>=20
> [   21.450115] workqueue: work disable count underflowed
> [   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_=
work+0x10a/0x120
> ...
> [   21.450171] Call Trace:
> [   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
> [   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
> [   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
> [   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_sc=
si]
> [   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
> [   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac=
/0x260
> [   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
> [   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
> [   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
> [   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40
>=20
> This warning may occur if a controller is detached immediately
> following a disk detach.
>=20
> Move the INIT_WORK call to prevent this. Don't re-init event list
> work items in virtscsi_kick_event, init them only once in
> virtscsi_probe instead.
>=20
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--eEXDPCt21ng7yGj2
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnFPAEACgkQnKSrs4Gr
c8ia4wgAjrcxhvgueCwsnWGTkhwdMBqfQEa1muDZVm/1qybWRGO57sKFCJYIXKUK
DXEhC+1QCvYa/iQqCM97Hlwblh3WLqyC9A3/cASQl82JXlIs6y2I6dYRB8MEitDx
HODAgaWGsqztA9wUqgIqdaKNfjELlkiNK9k6eiJJLs2kgnGTwNi0OVYYiGBTCITN
iM6oqt5Tiv9WSoawqJa+PQYSfwWWp/p5zabehccx+ilTtByt43i6EhcLHtdhF5CL
+XvBMVBHlIDQwZmxEliEB8LxZpiOuC+BXXhqi00dyOWBozq2N7XeQ9dqTWSajG2X
2azsqUjcbU2/kanG86drSlg220M8iA==
=Jv78
-----END PGP SIGNATURE-----

--eEXDPCt21ng7yGj2--

