Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97BE23D7D4
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2026 03:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773025590; cv=none; b=j5r0rtwUNtXKpbzsABJoVvQCZWM1ZsLndaoH8Y6gH4vUaCqj0Bo2vsPDph/mD9YeKSK52DCYgutxOHAEYCo1BwlU/2LYFYfUc8GISPTXw/zRF8m+HyaQG+0dOmdFPglIh2qULP+ON5X1JwSeZ/JfmMy5rxi7M5PvcROoNfGuack=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773025590; c=relaxed/simple;
	bh=fUiQIVH8sTCLCOgI16xmsLuCD8Ao5+AeST8T2f5zir4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azFp6a+09DHnebBVNjyMY23letDHDYdSJYowzZbgdp+SVFZS8tfR5k946p6m0FOE4rtcbGk9mTVTmrj1WVfMJEWBsk+O5BuKyV9htm4Bp+m9tcPmUjpvGhBEJBdQM4oqypa31wY8+lFQf380MIaFqWMihcXo84ziq04m9i511yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAUL70IB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAUL70IB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773025587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KsFocuVC05O13EcJevQPNOGiCSFao1PbcBM41J57c1g=;
	b=OAUL70IB7bNLB4bwp3PCroYZaGQdJxiZkNL9Wdh0NF7w/xyl3Mws8hklmKniyUDyHi/i+0
	tA5CYchqYj8Nt/xYGXDVuGQMb0+qabMFTDA26nAfaiO75wmNwSPOUA75FICjeGybI5kvgk
	P1wtSMmx516uyUJWOBXZhStVpN3IMRs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-8AJ8a2l5Mw6oU0uT44baqg-1; Sun,
 08 Mar 2026 23:06:23 -0400
X-MC-Unique: 8AJ8a2l5Mw6oU0uT44baqg-1
X-Mimecast-MFC-AGG-ID: 8AJ8a2l5Mw6oU0uT44baqg_1773025582
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C58A81800365;
	Mon,  9 Mar 2026 03:06:21 +0000 (UTC)
Received: from localhost (unknown [10.44.32.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 582A21800351;
	Mon,  9 Mar 2026 03:06:19 +0000 (UTC)
Date: Mon, 9 Mar 2026 11:06:17 +0800
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
Message-ID: <20260309030617.GB8611@fedora>
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
 <20260226204345.1904786-2-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Yyy1S4WiXsAqigun"
Content-Disposition: inline
In-Reply-To: <20260226204345.1904786-2-jdaley@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--Yyy1S4WiXsAqigun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2026 at 09:43:45PM +0100, Joshua Daley wrote:
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
> virtscsi_init instead.
>=20
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0ed8558dad72..173092931df6 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vs=
csi,
>  	struct scatterlist sg;
>  	unsigned long flags;
> =20
> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
> =20
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> @@ -898,6 +897,11 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>  	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
> =20
> +	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
> +		for (i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
> +			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
> +	}

The eventq should be populated unconditionally so that non-hotplug
events are processed even when F_HOTPLUG is not negotiated. For example,
LUN capacity changes are reported via the VIRTIO_SCSI_T_PARAM_CHANGE
event. LUN capacity changes depend on F_CHANGE, not F_HOTPLUG.

There is a related bug here: the other if (virtio_has_feature(vdev,
VIRTIO_SCSI_F_HOTPLUG)) conditionals in this file need to be revisited
so that LUN capacity changes are reported even when F_HOTPLUG is not
negotiated. You can test this bug with QEMU's -device
virtio-scsi-pci,hotplug=3Doff parameter and the 'block_resize' QEMU
monitor command.

Do you want to write a patch or do you want me to send a follow-up?

Thanks,
Stefan

--Yyy1S4WiXsAqigun
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmmuOSkACgkQnKSrs4Gr
c8g21ggArHvq8wqVdLA0LaVFvCNBlinO4udjWi3bYhTRrCxfLMr6kJiGfctP9eEB
Ej5+/GplYZyCHgAOjPS2Fl6j54aAinx4HvyHxOeOjKlsTMyEAWBeq/9a9Q29dz50
abWinzJ+qHbvligRWo0KhHeOiAi9y/d6+0txpfVY9SyezEOhZS/hNdE4tOWGlbaZ
e3GCOKLc153YV7qJv1ENYzlDPRuPAHlPFbznbP3nijgs3f9dg/mCtFs8o04Ky1fx
pu6aEtnTVDyqSkRHgDwhT3swapPfRd8NZoBlwXaeU3uw3yAy7mY9SES1gD1cuqSa
hbkZAPQSOOKAFLWgwtxAs9lZi8nIQg==
=RjTn
-----END PGP SIGNATURE-----

--Yyy1S4WiXsAqigun--

