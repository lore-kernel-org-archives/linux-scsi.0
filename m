Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5189C21D3F4
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764614196; cv=none; b=Mh+QzJucfCgqi6hnzLICCAYTfW4OzK7bfdGJCF+AcbGBu14NLXETSiAQrQwGoZIq6Q2FEg1F9nyLHyNiZXBdzyvy5U5038K1zxiNzk7YH++/fASI4Gp4hCT+TR3pfQbxsYjfsfVPHdxNa+N9O0upw1nd8Q6UQcI/8qopbf4QhTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764614196; c=relaxed/simple;
	bh=NrH/y+fQnUKXOiPZ55IULiatXMoFSssdpHc9s0BB6uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiuuBvrFoAiBeWBT/d0Om6K6tt+E8/pLkan2eAPOWz6jFSNYwf+wS3n+Kwm7DQa43WI5jfXv3rEW5L3VZMtdYuLatodfyNQmR/MaVavBm2xa+EHwSgmIU/gUbcUsXHanzzQk52SpjPcY1jPehganLWq2NLqnYSb2HQhdRrAZGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkL6gWkI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkL6gWkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764614194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y68PE+8MIkJ1RsOV+m+uznVl4WPgZ4iLffSkfESDJys=;
	b=fkL6gWkI0HLLZWwrUTz/In7OCCP8PVR5nElK3arvPew674QTQUHRLcZhWxveA7nvoCyFWk
	3GEtbOBgEq5u0mR9pW4TJJ4kWbQ9vGgYvDjMBO+HE58RAYJiP6dROmZzjNUQ8UbPTQLJ70
	02pcdcQ9Qhs5HNsvItxw0fJ3vbzwPz4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-NAmDLMHrM864mT_0ya8-qw-1; Mon,
 01 Dec 2025 13:36:27 -0500
X-MC-Unique: NAmDLMHrM864mT_0ya8-qw-1
X-Mimecast-MFC-AGG-ID: NAmDLMHrM864mT_0ya8-qw_1764614185
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9170B18002D7;
	Mon,  1 Dec 2025 18:36:24 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A47C4195608E;
	Mon,  1 Dec 2025 18:36:22 +0000 (UTC)
Date: Mon, 1 Dec 2025 13:36:21 -0500
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
Message-ID: <20251201183621.GA919572@fedora>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-4-stefanha@redhat.com>
 <cfd7cace-563b-4fcb-9415-72ac0eb3e811@suse.de>
 <89bdc184-363c-4d14-bad6-dd4ab65b80d9@kernel.org>
 <20251201150636.GA866564@fedora>
 <fadbd728-6810-49de-905d-214c2f72a857@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xpXfsTqxKRlXxqC4"
Content-Disposition: inline
In-Reply-To: <fadbd728-6810-49de-905d-214c2f72a857@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--xpXfsTqxKRlXxqC4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2025 at 05:26:27PM +0100, Krzysztof Kozlowski wrote:
> On 01/12/2025 16:06, Stefan Hajnoczi wrote:
> > On Sat, Nov 29, 2025 at 03:32:35PM +0100, Krzysztof Kozlowski wrote:
> >> On 27/11/2025 08:07, Hannes Reinecke wrote:
> >>>
> >>>> +	size_t keys_info_len =3D struct_size(keys_info, keys, inout.num_ke=
ys);
> >>>> +
> >>>> +	keys_info =3D kzalloc(keys_info_len, GFP_KERNEL);
> >>>> +	if (!keys_info)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	keys_info->num_keys =3D inout.num_keys;
> >>>> +
> >>>> +	ret =3D ops->pr_read_keys(bdev, keys_info);
> >>>> +	if (ret)
> >>>> +		return ret;
> >>>> +
> >>>> +	/* Copy out individual keys */
> >>>> +	u64 __user *keys_ptr =3D u64_to_user_ptr(inout.keys_ptr);
> >>>> +	u32 num_copy_keys =3D min(inout.num_keys, keys_info->num_keys);
> >>>> +	size_t keys_copy_len =3D num_copy_keys * sizeof(keys_info->keys[0]=
);
> >>>
> >>> We just had the discussion about variable declarations on the ksummit=
=20
> >>> lists; I really would prefer to have all declarations at the start of=
=20
> >>> the scope (read: at the start of the function here).
> >>
> >> Then also cleanup.h should not be used here.
> >=20
> > Hi Krzysztof,
> > The documentation in cleanup.h says:
> >=20
> >  * Given that the "__free(...) =3D NULL" pattern for variables defined =
at
> >  * the top of the function poses this potential interdependency problem
> >  * the recommendation is to always define and assign variables in one
> >        ^^^^^^^^^^^^^^
> >  * statement and not group variable definitions at the top of the
> >  * function when __free() is used.
> >=20
> > This is a recommendation, not mandatory. It is also describing a
> > scenario that does not apply here.
>=20
> If you have actual argument, so allocation in some if branch, the of cour=
se.

I'm pointing out that the documentation uses the word "recommendation",
which is usually not considered mandatory but a suggestion.

Please update the documentation to clarify that __free() _must_ be
assigned the real value (no NULL initialization) so that it's clear this
is not a suggestion but mandatory.

Stefan

--xpXfsTqxKRlXxqC4
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmkt4CUACgkQnKSrs4Gr
c8jLDwf/eWxDE5uirmFhIp1judTLNN8oBJ2XAI8bBsjv2vTN64KlNTUqvQt4fsNu
5DwI6lkNvDuez34Wkg5kLTvQMPUhMJnPHb1s4KD2UvgbBq+dp1jmJ8VfzoglSkyk
k2CT1CgvgoJmUnhngtldfKqHiu5j6e/2Dx8xyqLF5GUq+OrAn+xog+P3tIRvi5yn
BuijC0Wd48jO1W0o3xNS9tPVJSchLWTuaO5LCIsKYq6NMGkUQmUpBx64tMCWwVuD
NYOTP3vEaJxEUlg2Shqx2xNjPLgQX/Yi6uzdDeT/+WwFoT9E8OUD1nlJvLiUKWJ4
2/Udb13YeFPSBBxBkeaESVyPZbcFOQ==
=QIpw
-----END PGP SIGNATURE-----

--xpXfsTqxKRlXxqC4--

