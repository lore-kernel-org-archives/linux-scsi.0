Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C40C3321D5
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606799; cv=none; b=Fyxh0WDev+fGxQHB+JZFkb18QiMVk2aS1Ko/z3h5FPeh4pW6uHzDHobbhG4DDVy1SoTy4R6SEfjieeE2hIXyEpcUyN0OKTF5YC7bRIYrYijpDRquYPtDvcfWzgunrV6gob1spTWSZb9hoC01+4pBCttMQiYKR9XRCfNHZNI93qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606799; c=relaxed/simple;
	bh=2fYv14IWylXhNRGtu83HpRW7RgdpmRvAlRYJKmIbukU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6DOUzyulRldty2FnqBKOxx6fEo4lgGGyQEP5V2w+Cencg7tXHHCowPq9dfD18fjE+EPS+zIBdNqyidJZ/VdsXJp1BKKw1ZmQZn2b7yyXpVQE7h7fHvSXzUhLopPbRiYoZgYxAQg5+zv/bwzZff1IDzJ294qbtLJDIe7qT2DZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLYpBxPy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLYpBxPy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764606797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FEWq6IeBh011o08f/hWEQ+gTUdIM+S4jmcV1ap/FeSI=;
	b=DLYpBxPyESMveokennSsNQNn8L1x5bhvLbVFFE35v1ekkSa+emPDX2PbW+IPT5Tu5MWkio
	NIjYGHznynCqZGxzqSJ79ZaQHtl91Dj9QDBLR5n7Z871N7nm++c8/e/Vh7i11lFzkOuz5H
	Zyt3stYei8E+6pg9bwPr84DXzAIWrsI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-14JTXgA9Obixynv9YqxJNg-1; Mon,
 01 Dec 2025 11:33:11 -0500
X-MC-Unique: 14JTXgA9Obixynv9YqxJNg-1
X-Mimecast-MFC-AGG-ID: 14JTXgA9Obixynv9YqxJNg_1764606789
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08E44195606F;
	Mon,  1 Dec 2025 16:33:09 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 73C931800451;
	Mon,  1 Dec 2025 16:33:07 +0000 (UTC)
Date: Mon, 1 Dec 2025 11:33:06 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 3/4] block: add IOC_PR_READ_KEYS ioctl
Message-ID: <20251201163306.GF866564@fedora>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-4-stefanha@redhat.com>
 <20251201064016.GC19461@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5Wld60ZO5GhULH6y"
Content-Disposition: inline
In-Reply-To: <20251201064016.GC19461@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--5Wld60ZO5GhULH6y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2025 at 07:40:16AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 27, 2025 at 10:54:23AM -0500, Stefan Hajnoczi wrote:
> > +static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t m=
ode,
> > +		struct pr_read_keys __user *arg)
> > +{
> > +	const struct pr_ops *ops =3D bdev->bd_disk->fops->pr_ops;
> > +	struct pr_keys *keys_info __free(kfree) =3D NULL;
>=20
> Please avoid the use of the __free mess and write readable and maintainab=
le
> code instead.

Okay.

> > +	struct pr_read_keys inout;
>=20
> Inout is not a very good variable name, as it doesn't really have much
> of meaning. =20

It's the ioctl argument. I will change it to read_keys in the next
revision. I'm not sure if that's any better, but it reminds us which
struct this is.

> > +	if (copy_from_user(&inout, arg, sizeof(inout)))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * 64-bit hosts could handle more keys than 32-bit hosts, but this
> > +	 * limit is more than enough in practice.
> > +	 */
> > +	if (inout.num_keys > (U32_MAX - sizeof(*keys_info)) /
> > +	                     sizeof(keys_info->keys[0]))
> > +		return -EINVAL;
> > +
> > +	keys_info_len =3D struct_size(keys_info, keys, inout.num_keys);
>=20
> Do the size check on the calculate len here?

Yes, that's better. Checking SIZE_MAX also gets rid of the 32-bit vs
64-bit host comment.

> > +		return ret;
> > +
> > +	/* Copy out individual keys */
> > +	keys_ptr =3D u64_to_user_ptr(inout.keys_ptr);
> > +	num_copy_keys =3D min(inout.num_keys, keys_info->num_keys);
> > +	keys_copy_len =3D num_copy_keys * sizeof(keys_info->keys[0]);
>=20
> num_copy_keys is only used once, so maybe drop it?

Will fix.

Stefan

--5Wld60ZO5GhULH6y
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmktw0IACgkQnKSrs4Gr
c8jbjwf4l8yKwuv+JSACDgyBSmml66HpfH23XvTBZ1amFOCIGNjC/b5FuNNlKmxx
uiZ+J2cmoLSe9XZLD2WheyZj3IsyRI7zXdxW7sRKmlkOScwiMAjCfYN/E6RAkD8l
q8i7i307XyhMALjleqLDDI/8zM7GpKrPCAmRgHmnzAxEW0k2dfrKX9soWlZkUwdU
VP+/JgXktggIfajUjGKHh6CBT2ez2Ju4xHEWcX/8pRGFY1BwIff5vFDuEGt5yr7g
mVp8wS3xjZWbuK1mhGHe3Mn2HVFwU27XMZ4onHUp13Xexiyek6kSpilE9dp0DDdd
y+3x2ZZ4+tTHHRYqaEgEvbM+5vpE
=D7ST
-----END PGP SIGNATURE-----

--5Wld60ZO5GhULH6y--

