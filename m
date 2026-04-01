Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C526B472765
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775063363; cv=none; b=i01I3U8e1DtTukbw4D24rx4GG+tzYgHJkf+sjcDE5RzCsYU/p/O/Csd9FtjjQNGTL/dj9VVpbBVXWkedMu7C7T2vHnEGlA8t8gx0Q+zhNkx0D4SaE+PqTXJ4xBJt3pf5pFVJeL1ipULNeRDmIJcHUeEZyn6t5D44IH/JQcMyAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775063363; c=relaxed/simple;
	bh=UrlrL3JrdlkwweCdRKeXD8MoN74BHicvKbtfVaI7CU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjYekBBpswoSabYLkiawGM7hrqqksONyb78bgOj49njIKq6RAl+K37kzlYUbavMf+HiMf3crMy18mlr4zoJ+YanATkWWYi2IhJUv3YFfVNacuHo5qmEgOjGiRGfolYw5xktLJ+QUzDS9E9eBGEysCj/jAr4YMaCaiy4g2CDpT9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUX052K/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUX052K/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775063360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrlrL3JrdlkwweCdRKeXD8MoN74BHicvKbtfVaI7CU8=;
	b=GUX052K/4r/a60YyKEVtJP2Q/RfQrt6nO/CwTFiGPxU7ecKPyQ3S6eZKtE2LyWPh3pxMkC
	/WahkNIQrkaHubTDVXxcSItXyLY9OU3WverdzzbTceD/76sIGdKLjB5nUE7/0bamttpDhp
	zk9Cxd4XEVD1qZfSNg/TneBZYiZ0yig=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-7vDLrfpHP1qNdvQbawMPrg-1; Wed,
 01 Apr 2026 13:09:17 -0400
X-MC-Unique: 7vDLrfpHP1qNdvQbawMPrg-1
X-Mimecast-MFC-AGG-ID: 7vDLrfpHP1qNdvQbawMPrg_1775063356
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 354BE19560B1;
	Wed,  1 Apr 2026 17:09:16 +0000 (UTC)
Received: from localhost (unknown [10.44.32.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 599CE30001A2;
	Wed,  1 Apr 2026 17:09:14 +0000 (UTC)
Date: Wed, 1 Apr 2026 13:09:12 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: target-devel@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: LIO PERSISTENT RESERVE OUT PREEMPT spec compliance
Message-ID: <20260401170912.GA329795@fedora>
References: <20260401124626.GA266484@fedora>
 <9c556370-5e85-4cb6-8f4d-c0361467b2f3@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zejTu4YnJbD2u5vy"
Content-Disposition: inline
In-Reply-To: <9c556370-5e85-4cb6-8f4d-c0361467b2f3@acm.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--zejTu4YnJbD2u5vy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 01, 2026 at 08:56:05AM -0700, Bart Van Assche wrote:
> On 4/1/26 5:46 AM, Stefan Hajnoczi wrote:
> > Thoughts?
>=20
> There is a persistent reservation compliance test suite in libiscsi.
> SCST passes that test suite if I remember correctly. It would be great
> if LIO would pass the tests from that test suite too. See also
> https://github.com/sahlberg/libiscsi

Hi Bart,
Thanks for sharing the libiscsi test suite.

Stefan

--zejTu4YnJbD2u5vy
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnNUTgACgkQnKSrs4Gr
c8gonQgAxceD3FeX/z3kfqUOYoYBEqUF3P21CdFZSUbSUITCwWPeb5E1wsj8S+Db
poFnup1JfMTUkQ+A1TmzhYmRx8IaNGxZ5EbAVjAfQ+qgIlv88mrEgTeMkIS4zXEZ
anyp24UttTQZMen+vC8NjpP+IOlyaN126jThPtxHgZU62Xilk/GroxYlxhl4cWMA
taahgqZGOomHYfr4FwAg/0oOiOMRuFKiDVn3khKXxH4bSbp9zsRtqaZLQcE/TKnK
tXHKw6NXi5c07C3LAAWssnaRGfNN9quP5kYYrlfbkDpmRfnhx5Gwi2+cwfImCSpA
2t+Y7/2TU0pz8FcmD7vpOo/kpieFzA==
=w7w/
-----END PGP SIGNATURE-----

--zejTu4YnJbD2u5vy--

