Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9620331CA68
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606210; cv=none; b=t7frq3YLyaQo/nxbPlj+d5yrU8jDEyRK4BUG275b/qgTUI341kJQpLBYXD67/9OTlnsxOyR/GpttSZkBXdLxQUQ8cVne8i43ByZYy0YH724RUMLcspo5SdTDX8s6+H2D17l0RWQnaJuI1Hv4yaobagMJO3TRHE845HZ4hKDs5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606210; c=relaxed/simple;
	bh=Z10Xep7cgDGVJfpaYpwtQV6DUKhjH3dPpkRNarzciN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irr61qOp/YVONfJCDeZU42sAtv/JphqymZFWNqbnxmi/wwAUU68nk9J9pL8QMAGcGvqFSOnJcEb0n+o+uI2i48p+cqHpl8wTv1sh9qaUq2L1Wu/bvPnYH33eHCygmfNW2TjVDTPHl7K2WD09eqvUQ+I+B8sRPuVk2DgN2SQKv6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KI9m+dXr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KI9m+dXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764606207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4iWnwLMwmGLsjkBGFc5ezIShODWDymLzptUH0xLu4zU=;
	b=KI9m+dXrT3Vx+stwireQJzxWd0dDoL+kGJzPKwTxzytT2ekhAoeIbwSA4D+ncDXU5ucxVb
	Zi2G0aylGN8nXIeNgrz/knofB4Ezf2cvMVilolkleI61mnFplW+kEB2nlX3TG+Y9KGYdl9
	xFKg9v+XzuQmnp6aQdCTiBP+yAlAcr8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-YIt7-LwiMqizY8fJDXan2w-1; Mon,
 01 Dec 2025 11:23:22 -0500
X-MC-Unique: YIt7-LwiMqizY8fJDXan2w-1
X-Mimecast-MFC-AGG-ID: YIt7-LwiMqizY8fJDXan2w_1764606200
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEAE41956094;
	Mon,  1 Dec 2025 16:23:19 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8724D1800451;
	Mon,  1 Dec 2025 16:23:18 +0000 (UTC)
Date: Mon, 1 Dec 2025 11:23:17 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/4] scsi: sd: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251201162317.GE866564@fedora>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-2-stefanha@redhat.com>
 <20251201063413.GA19461@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/q2A/sdcGUHGB5kN"
Content-Disposition: inline
In-Reply-To: <20251201063413.GA19461@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--/q2A/sdcGUHGB5kN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2025 at 07:34:13AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 27, 2025 at 10:54:21AM -0500, Stefan Hajnoczi wrote:
> > +	/*
> > +	 * Each reservation key takes 8 bytes and there is an 8-byte header
> > +	 * before the reservation key list. The total size must fit into the
> > +	 * 16-bit ALLOCATION LENGTH field.
> > +	 */
> > +	if (num_keys > (USHRT_MAX / 8) - 1)
> > +		return -EINVAL;
> > +
> > +	data_len =3D num_keys * 8 + 8;
>=20
> Having the same arithmerics express here in two different ways is a bit
> odd.
>=20
> I'd expected this to be something like:
>=20
> 	if (check_mul_overflow(num_keys, 8, &data_len) || data_len > USHRT_MAX)
> 		return -EINVAL;

Will fix, thanks.

Stefan

--/q2A/sdcGUHGB5kN
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmktwPUACgkQnKSrs4Gr
c8g0gwgAiEUYpY9G7g748zxuE7RRdteHJBtuBVbAtrYXJqfIdAmupy9eKEf9Sa1D
FUo7wdk9KaajdFP8aJSFuqdy81X4qMI5wjnl7Yv5mpbCUdVXTrTWQy3yEx93ILlO
iCpY+0cdWjCslnFTsIdzawzlo7+4xLEzWcVBG+gRlCd3Z598f8uAyZEXwuc36qwv
ki8wRuKkfHzLmF57XTBR/ZhJmSSFzSCFkqOneFoXX8VsDrGF7yOLyyJ0q9ATBJo4
U15dVvLjQd1cYZhHjHX30W4rXLL4UhXWSURGKcrYXlLQW0g7B4JloBMCOFup5U6Y
ubAwouirRAk9bodTanTM+CJq/292Pw==
=eJaQ
-----END PGP SIGNATURE-----

--/q2A/sdcGUHGB5kN--

