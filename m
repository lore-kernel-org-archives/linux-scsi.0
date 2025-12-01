Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3CE244663
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764602069; cv=none; b=AOe6V0nU8rQr6Dgm1trYaQrlzGH8pnKxP7HZD0x/8PXKIgt4V3wbb/gcXQVzNcz5Jkqxy/YVN5rjqfeV/oPqDix2LNNHMaOcJyzCY3VUwfNUF5VHNYUKhLyimt5il7jyolCztn5qw9/L5mYmQGfSdRP/H80xRbByXN8PC7m1iC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764602069; c=relaxed/simple;
	bh=q0SSmcj84tVSNVkpubJJ90Hr8bFh87IOnXawYAkLkbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdzF5sAHasXfby9Rwog9h4CuGCbCAGwvelccIZMfYOcprZy2m+i0XdcWfoUdZ5cnyHTqJc1Ver0QlU/ozYOB5ZvKyQJiRYChoeJh0YovVTn+brn3YIQWe3l1Unr4IQVCKjsbABGJCv3V9kdgo9MfJ8tbfRIAOLCqwXxtM37+ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NaHO0rh3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NaHO0rh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764602067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I6cvuay9TvcgzCSa2szhxoL8AXhyOhaVC4Nmz1aT7UM=;
	b=NaHO0rh35O1ZfMpjiWFCGWY1ihcNJvutH8BDjEJmsr8oMtu3VmEePcheLGspHcPWjnwV/g
	Ezp9PtKreh3dM2krrfrks15rlRJJY1eK+f+J61M9VuM274l52p/R7Veejcy4ODsxfwZXSq
	MzeUtmSP1Y0BbgAuHlwoj2r9CvaWlvA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378-2MHEfzbSMbqWxAszSp-yAQ-1; Mon,
 01 Dec 2025 10:14:24 -0500
X-MC-Unique: 2MHEfzbSMbqWxAszSp-yAQ-1
X-Mimecast-MFC-AGG-ID: 2MHEfzbSMbqWxAszSp-yAQ_1764602061
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F0F11800EF6;
	Mon,  1 Dec 2025 15:14:21 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A85B19560A7;
	Mon,  1 Dec 2025 15:14:19 +0000 (UTC)
Date: Mon, 1 Dec 2025 10:14:18 -0500
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
Message-ID: <20251201151418.GC866564@fedora>
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
	protocol="application/pgp-signature"; boundary="rlrGdwHT0htf22pn"
Content-Disposition: inline
In-Reply-To: <89bdc184-363c-4d14-bad6-dd4ab65b80d9@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--rlrGdwHT0htf22pn
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
Christoph Hellwig replied to the v2 series, also against using __free().
Regardless of the reply I just sent to you about whether cleanup.h may
or may not be used in code that forbids declarations midway through a
scope, I will be dropping it in v3.

Thanks,
Stefan

--rlrGdwHT0htf22pn
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmktsMoACgkQnKSrs4Gr
c8jXyQf/Xb1N0Lry0quE06jBUyiqZo66ksdNXaM1ieTz8sh8NzXWrxSHKfVGwdZ9
wj6uj7sVEOKfWf7c0dPW/x1/2tzc7n2mhamEIWh7ExQxJ28165MkkmOOQ+0uttCz
H0gOYhEcUtDRs5TcD40sY8yFIb7xNCUC4U3xAEpE+9Oz/fdWLurBh+eioiGldhSD
OO+dCosy9BhTco9y9zU9MdJfX7/PeCtManlpKUV4d+9r83hp8I9fIxV+3faMzHfp
wdU3DR0PGdlIur7d8vHCE5oh4UEo0i63E8XFcBh2qQoTy8zoPgR4L8Zu7IJU4VoH
pVpBEcm32EFKLfFyeLkmkA6N2DtoSQ==
=+H1/
-----END PGP SIGNATURE-----

--rlrGdwHT0htf22pn--

