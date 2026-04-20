Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8B93A6B9B
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706441; cv=none; b=k5DeCTrw5bR2bQZ7RI2No3yH6XEo9JvzQP/QCJwFLgIa/wlb06hkI02sOVZg9/7XGjMeuWfO9yrLYAKXvaK5FSFUM0tY3mz3vNIlQjkBNkmbdNH262nFjQu5FJWdJ69liKm/4jz8lzE2Jx5m4cES0oUYWqbZIAVvStev7bOQKYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706441; c=relaxed/simple;
	bh=yXRXa49ii7EMtQpnop2c+sFR3fyXPbmJPIrsey3pv50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5DLgKNWZ24WXA77Rk/3qNwhuOMRZr39waYi1sCJiUutdW1YnNWTsf0vfndVxA2hGv/HuflxMLYh7HXP+BHI4RKjbrzFpkx9tGCGZ1Rkc11ixiNWX/T21CVZoEMOxrvl+p8tBHHFZTeEPfQyeuwdO7NibA6nUuRuMl9hAMC1L9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RafTrwXP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RafTrwXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776706438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yXRXa49ii7EMtQpnop2c+sFR3fyXPbmJPIrsey3pv50=;
	b=RafTrwXPy3U4tQgNYgbt7BwgQUvaDRzj8BuC71Hx90+vwIRNRvF1xf2uEO+uXH/1eCnxmG
	fi68YeFu0KdT5kONNK8zFW2C1Oj9nus+X69KIe6B85PX2/1+jHml7rkdmS+oUr9NxjTDzm
	j86BiKbDRw4GSTFem8ztioLJdsg/3GM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-cI8A8w63OKmBYpXpBmnZYg-1; Mon,
 20 Apr 2026 13:33:57 -0400
X-MC-Unique: cI8A8w63OKmBYpXpBmnZYg-1
X-Mimecast-MFC-AGG-ID: cI8A8w63OKmBYpXpBmnZYg_1776706435
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75A7118004AD;
	Mon, 20 Apr 2026 17:33:55 +0000 (UTC)
Received: from localhost (unknown [10.44.48.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 531E21800370;
	Mon, 20 Apr 2026 17:33:54 +0000 (UTC)
Date: Mon, 20 Apr 2026 13:33:52 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com,
	virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
	eperezma@redhat.com
Subject: Re: [PATCH 0/4] scsi: Support devices that don't have a cmd_per_lun
 limit
Message-ID: <20260420173352.GB405461@fedora>
References: <20260417230751.117836-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KaAzs6/QIPBWgyu3"
Content-Disposition: inline
In-Reply-To: <20260417230751.117836-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--KaAzs6/QIPBWgyu3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 05:57:20PM -0500, Mike Christie wrote:
> The following patches were made over Linus's and Martin's 7.1 trees.
> They fix an issue where for virtio-scsi we export a lot of non-scsi
> devices but are getting throttled by the cmd_per_lun_limit too early.
> For example we export 1 or more NVMe or block devices and would like
> to just pass command to them in way where virtio-scsi's hw queue
> limits match the physical hardware. Or in some cases we are doing
> cgroup based throttling on the host side, and we don't want the guest
> to block IO when the host knows we have extra bandwidth.
>=20
> The patches add a new cmd_per_lun value so drivers can indicate
> when to avoid tracking queueing at the device wide level. They
> then rely on just the block layer hw queue limits. And the patches
> convert virtio-scsi. They also fix some can_queue related issues
> discovered while testing/reviewing.

Hi Mike,
Is there a difference between setting cmd_per_lun to U32_MAX with your
patches versus setting cmd_per_lun to the virtqueue size without your
patches (this can already be done today without code changes in the
driver)?

Thanks,
Stefan

--KaAzs6/QIPBWgyu3
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnmY4AACgkQnKSrs4Gr
c8gWQggAih11OwTFLYPwIEPZH1UoehTgpAOlQUsDBxyaxZCSkkcVN/d4+9/Hbs4A
dIczEZdYWOmzAHeefxcR3HUWWVU29v5ZpoeKY9eWb/JEhNujh8U6bx6GoMn3jVq4
PIfqU8p4YKZRhpRg4VR/JZbN9LEydANb53rOStyCrp8CAy+8nCvQ2gQrxHyyTeSH
mSAEjLuLNGBw5tjO5SqfHkQR8WTzDLW5G3ErW+goMtDaQ6zR4ezVuq9JKn72RLAV
VAVjWnRsXjgvhUVr3zzoHwdfj2fH0U7TNZ1RI9//BvC/lpzSKqsNuvdY/hxtT+8U
XObCdlBmXMXApDvpnKYliXxm8MRLbA==
=F1XH
-----END PGP SIGNATURE-----

--KaAzs6/QIPBWgyu3--

