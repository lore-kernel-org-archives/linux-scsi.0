Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272694457DA
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292114; cv=none; b=JyqAVvLPmJ49zz/BMihD/856xhSCBdBZJXu/ruEv/MLYJvx12ZUTduUAxHfFsZ3l5aKyov3hYJPJRgKAquhlyLyYbM6G7DlBGzVkM5TgFyXo1fwjgy1KAc6uEhuMYzxI/m3Am9eNF6c/xGFanZMia8vg6Pfurnna1sLl6w8K3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292114; c=relaxed/simple;
	bh=1XA3Iq64Qh5S96yUdeRyZkUWOMJWh2wuTH7qZS7tpF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liP8/eDB/jtQOiT5NGN0ZzBroTF2HOdtOK6HVtj1PJJVDiA9XQgpxxsxHTug4uitSg53ln/6YwmVMEfgMkECSn18yo0AR4Vu1o91oI6ozFPNqEOglJjECCtiqPh+ISnyolmRD+27VHxhAaM2fIc1qguslevcPDTeJ6Y5P2t+Euo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKP6lM3a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKP6lM3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788292111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PdHg9I4oGgxBB+BPGUebv8panrT4iRjdZZ8owiahDtA=;
	b=CKP6lM3aeMMrNSVmEVMJcXlbqFJ4l7HTA7DqmczkXlXvCB9jgn7Gr0yPWvDojA6Avz4MeB
	d4bAFgAcBF8/EUsBh5zFtTpN3jUQkitTcnVtj1S8iQN/fOEX8QUDDZkNfFv1QFGHhFFMwP
	JNuU0EJXuhtUzESw3Gtw55Y3Bu+TIcI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-Ydnij9yYPvO9lR82MlwnUQ-1; Tue,
 01 Sept 2026 15:48:24 -0400
X-MC-Unique: Ydnij9yYPvO9lR82MlwnUQ-1
X-Mimecast-MFC-AGG-ID: Ydnij9yYPvO9lR82MlwnUQ_1788292100
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE97719539AC;
	Tue,  1 Sep 2026 19:48:19 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 544051955F70;
	Tue,  1 Sep 2026 19:48:18 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:48:17 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com,
	jasowangio@gmail.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, neeraj.soni@oss.qualcomm.com,
	gaurav.kashyap@oss.qualcomm.com, mani@kernel.org,
	andersson@kernel.org, konradybcio@kernel.org, bvanassche@acm.org,
	alim.akhtar@samsung.com, avri.altman@sandisk.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/11] virtio_blk: add inline encryption support
Message-ID: <20260901194817.GE729142@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9aX0ODMiNe3QBG+4"
Content-Disposition: inline
In-Reply-To: <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

--9aX0ODMiNe3QBG+4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:07:10AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlzhan@qti.qualcomm.com>
>=20
> Negotiate VIRTIO_BLK_F_INLINE_ENCRYPTION with the host and wire it into
> the block layer's inline-crypto framework to enable inline encryption
> on virtio block device.
>=20
> When the feature is present, the driver reads crypto characteristics from
> virtio config space (key-slot count, DUN size, supported key types) and
> issues VIRTIO_BLK_T_GET_CRYPTO_MODES to discover supported cipher and
> data-unit-size combinations.  Encrypted requests use new request types
> VIRTIO_BLK_T_CRYPTO_IN/OUT, which append a virtio_blk_crypto_msg
> (keyslot index, DUN, data-unit-size-bits) to the standard outhdr.
>=20
> A new virtio block crypto extension driver (virtio_blk_crypto_ext),
> owns the blk_crypto_profile singleton and the blk_crypto_ll_ops dispatch
> table. Actual key operations are forwarded to a platform-specific
> backend registered via virtblk_set_crypto_ops(); without one,
> VIRTIO_BLK_F_INLINE_ENCRYPTION is still negotiated and the
> profile is registered, but every keyslot operation returns -EOPNOTSUPP.
>=20
> The shared profile is a singleton as per blk_crypto_profile is
> corresponding to one ICE hardware: the first device to negotiate the
> feature initializes it; subsequent devices reuse it only when their
> negotiated capabilities (slot count, DUN size, key types) match exactly.
>=20
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/block/Kconfig                 |  13 ++
>  drivers/block/Makefile                |   2 +
>  drivers/block/virtio_blk.c            | 199 ++++++++++++++++--
>  drivers/block/virtio_blk_crypto_ext.c | 283 ++++++++++++++++++++++++++
>  include/linux/virtio_blk_crypto_ext.h |  78 +++++++
>  include/uapi/linux/virtio_blk.h       |  62 ++++++
>  6 files changed, 623 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/block/virtio_blk_crypto_ext.c
>  create mode 100644 include/linux/virtio_blk_crypto_ext.h

Thanks for sending this as we discuss the VIRTIO spec changes.

Although it's nice to have all the Linux patches together, there are two
separate parts: 1. the virtio_blk.ko guest driver changes and 2. the
hypervisor blk-crypto uapi. I suggest splitting this into two patch
series to avoid confusion between these parts. It may also make review
and merging easier if we stay focussed on just the guest or just the
host parts.

Stefan

--9aX0ODMiNe3QBG+4
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXLAEACgkQnKSrs4Gr
c8gA+QgAqDS7OZpv76XEz3ux6y5Md9USN6fgNjmMguv95TrS/+5BA5hTQoo/oRLD
Tyk3iCHL+q76w6ukHAbFg75WHzYnE/1ylnCcq8Mu0xrXMjWX7/jOe5/EgXv594De
ZQI/hrpfc8FZ42giSJBp2SWIVxa9ZaKnUL+33Lf57l2HelEsBrK2C8uhm3HBa9gq
VVwdgoHixN5DIclvKSmI/lCv3sW7AexMGRjBe6dskR08f84Xn0AisTB3OuzyRJMG
vHjIzGapZrQVw2jubuAhztBcAedmEhuRJKrCt9HtBMheyWwAfxfkb7FTmVmsIbfd
37a52DGnb2PYe0N70Q8MmaSi/n/kfw==
=jTU8
-----END PGP SIGNATURE-----

--9aX0ODMiNe3QBG+4--

