Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0D71DED49
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764601612; cv=none; b=W047wCgGPiHhlxOwDqT8nFZkig49LE0b2igUUzWDNkC37FyAhlqqMtpWrh+JbBK116AmWogMFgrrk0Scl5cbFCawpGQrEymRkuEGLWYO8R9We5wiaKZTCOTEWUBqUd0I3qV7+AgBaAgFC/qWjHuSbR9OdGEUYcr4LsKmyEHG2gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764601612; c=relaxed/simple;
	bh=yWEx/0wbt0Pgthdm0c+ArXg5ZJU9JS7A+ciFmvBP3Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3EsxfqIyBYF37+Vr/9X5HwhNewyyRhA+q2hB+4TPYlvVNW6S0jts8Y8HR/t1OjOdAggUwhkXBoVKCdaPWbF74Qx5OyMZRC6saDMWKQiES75nOp7NWqnXCRWdXwMl4wg2Mef+4bMBgdxVwn4R5TBdi4tB+zMbWfzw9FP1GlzUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BVLpM2L5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BVLpM2L5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764601609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0taldGU/p3RQUsqrVclk++ge/JmFmUsQeYAw3t0jxA0=;
	b=BVLpM2L5JdopXd7gH4wf8xJUJwYjS8hPHfZwBXPBFJ4Agqhw9qHscfVJd8p20fBph7bHoI
	B+aJ6TkwLT+wTtNT4QZg2XxYI7ZaZSINjpuDLW4sgvvtUldfXL22hQSghydPACf/4nnpZG
	HyCgv3mVaMRG8P0MfmAmxUFaDD/P3ck=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-TodEzmINNRugQ6nx2slY1w-1; Mon,
 01 Dec 2025 10:06:43 -0500
X-MC-Unique: TodEzmINNRugQ6nx2slY1w-1
X-Mimecast-MFC-AGG-ID: TodEzmINNRugQ6nx2slY1w_1764601601
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 597B0195608F;
	Mon,  1 Dec 2025 15:06:40 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48F3830001A4;
	Mon,  1 Dec 2025 15:06:38 +0000 (UTC)
Date: Mon, 1 Dec 2025 10:06:36 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
Message-ID: <20251201150636.GA866564@fedora>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-4-stefanha@redhat.com>
 <cfd7cace-563b-4fcb-9415-72ac0eb3e811@suse.de>
 <89bdc184-363c-4d14-bad6-dd4ab65b80d9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/C/EfXMAoYrl/InE"
Content-Disposition: inline
In-Reply-To: <89bdc184-363c-4d14-bad6-dd4ab65b80d9@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--/C/EfXMAoYrl/InE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 03:32:35PM +0100, Krzysztof Kozlowski wrote:
> On 27/11/2025 08:07, Hannes Reinecke wrote:
> >=20
> >> +	size_t keys_info_len =3D struct_size(keys_info, keys, inout.num_keys=
);
> >> +
> >> +	keys_info =3D kzalloc(keys_info_len, GFP_KERNEL);
> >> +	if (!keys_info)
> >> +		return -ENOMEM;
> >> +
> >> +	keys_info->num_keys =3D inout.num_keys;
> >> +
> >> +	ret =3D ops->pr_read_keys(bdev, keys_info);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/* Copy out individual keys */
> >> +	u64 __user *keys_ptr =3D u64_to_user_ptr(inout.keys_ptr);
> >> +	u32 num_copy_keys =3D min(inout.num_keys, keys_info->num_keys);
> >> +	size_t keys_copy_len =3D num_copy_keys * sizeof(keys_info->keys[0]);
> >=20
> > We just had the discussion about variable declarations on the ksummit=
=20
> > lists; I really would prefer to have all declarations at the start of=
=20
> > the scope (read: at the start of the function here).
>=20
> Then also cleanup.h should not be used here.

Hi Krzysztof,
The documentation in cleanup.h says:

 * Given that the "__free(...) =3D NULL" pattern for variables defined at
 * the top of the function poses this potential interdependency problem
 * the recommendation is to always define and assign variables in one
       ^^^^^^^^^^^^^^
 * statement and not group variable definitions at the top of the
 * function when __free() is used.

This is a recommendation, not mandatory. It is also describing a
scenario that does not apply here.

There are many examples of existing users of __free() initialized to
NULL:

  $ git grep '__free(' | grep ' =3D NULL' | wc -l
  491

To me it seems like it is okay to use cleanup.h in this fashion. Did I
miss something?

Thanks,
Stefan

--/C/EfXMAoYrl/InE
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmktrvwACgkQnKSrs4Gr
c8i7bAf9HNfOvXB6gX5exTG1f7E+v7bUNWhclZTjpR5u8BtEtSCbwk2zvR4o81B2
9ROH8bQvPQv+NeT+zqIcGdsoBC6rbfZmDSHlALtvCsGb51Y2nZ9sZhpH1EcycjsS
yIFFFCmSzkHRMf/oSNs5g+lS9oXs0sUW8mCZD6oofK8hSFv0Qa+BbgUhF36dAQO8
OSp+PGYyJgQ/GnBqxxJ2lhTBVxoX/k3p7rwUY1MuPAa8wMa+skIT5uCa8zIP+Li/
Uv6qRE1wUmmAMJJvyRHTo+fJAH8Si01hMa2hzw8efDv781qLxzLj4NKL9MpQDxbC
wb1TkzyzAqb7unNVO/A2XFcrzeIObw==
=mmRd
-----END PGP SIGNATURE-----

--/C/EfXMAoYrl/InE--

