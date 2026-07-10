Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB20E233920
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712214; cv=none; b=NmfTfoj8Mr6n9uhrDJ3CO08056QIEf6smi4XBIs0UBjlimxTM10Llpe2epJzqi3tmDcKqrqLFzYOBSykKzYxunC6HmP70JAzLkzxUw+3FeIqVumyGWP/a2GaivCS5n1O9k0LsU7TUBdl54lqmY3q0dvergCDPunCdiGKKNMjWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712214; c=relaxed/simple;
	bh=0Ptd+Bmm/nxpEShgJVGF8I3IQU0Zku0OEXl9jqSJYGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZaWhVbmx1WLPX7Gh7xA/P0N9s8Zun06R9Fd6hkCBjq1eFPdMbjfSGc/T6bPF8TCX4/GJytn4mrNBkK3UHYArfasul7ceUjXvLd0Iy1tv49eY8boJq+K4Vj1h3H1pfHyEeVyuhax2zUHTrVI6FrNuViRcz0rIKNFM6/RJePUM2II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyU1/CJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyU1/CJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482921F000E9;
	Fri, 10 Jul 2026 19:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712213;
	bh=oDioHje5rJ5p23dzw7/aYB5pJJBEbcwUErxMAl8dFXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cyU1/CJPfIjMVxZ+7X47dN3r+4WpUCtUzAS2D6T7MJNT8DeuGtKxr7u1FPvogqnHb
	 2flIiw4/GQzhznnh/Hs2X32rtakBmyhB6Q4YPjSMQuOGNSQiNtFSgj0CTa5z0fQIh8
	 T3qPC2lHn7mROUpO080sIQhW7e4Hh1Gd72bYzsCzOuOEGiKgaoi0CmNuqvaRDlbhFL
	 eikrSWxoCXcJu+Mi6q2KeZXW/Rzt407j2j0SsCcZAsKGY63BNW5fhrNKFUrebcsBZQ
	 GTpHPREdgUIFFfpZ7dsNQd1pGGPRpwlXcrfqAqk97qb2WW2Nck4AQsBsH1I5ML1H2W
	 mZFyf7x2cIRYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/8] ibmvfc: allocate asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-5-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-5-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:36:52 +0000
Message-Id: <20260710193653.482921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The newly allocated asynchronous sub-queue (`async_scrq`) is never=
 registered with the hypervisor, leaving its cookie uninitialized and the q=
ueue non-functional.

Pre-existing issues:
- [High] Unprotected dereference of queue pointers in `ibmvfc_channel_setup=
()` leads to a kernel panic if MQ is disabled or if queue allocation fails.
--

--- Patch [5]: [PATCH v4 5/8] ibmvfc: allocate asynchronous sub-queue ---
commit d243c6fd5b265f83cb24c3737fb1dfe6fd989a93
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: allocate asynchronous sub-queue

This commit allocates and initializes an asynchronous sub-queue required for
receiving full and extended FPIN events from the VIOS.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -5425,6 +5428,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host=
 *vhost)
>  		setup_buf->num_scsi_subq_channels =3D cpu_to_be32(num_channels);
>  		for (i =3D 0; i < num_channels; i++)
>  			setup_buf->channel_handles[i] =3D cpu_to_be64(scrqs->scrqs[i].cookie);
> +		setup_buf->async_subq_handle =3D cpu_to_be64(scrqs->async_scrq->cookie=
);

[Severity: High]
This is a pre-existing issue, but does this code unconditionally dereference
the queue pointers?

If MQ is disabled or if queue allocation fails in ibmvfc_alloc_channels(),
scrqs->scrqs and scrqs->async_scrq are left as NULL.

If the VIOS subsequently indicates channel support in its capabilities,
ibmvfc_channel_setup() is called and these unallocated pointers are
dereferenced here, which would result in a kernel panic.

Could we add a check to ensure the queues were successfully allocated before
dereferencing them during channel setup?

[ ... ]

> @@ -6392,6 +6396,17 @@ static int ibmvfc_alloc_channels(struct ibmvfc_hos=
t *vhost,
>  	if (!channels->scrqs)
>  		return -ENOMEM;
> =20
> +	channels->async_scrq =3D kzalloc_obj(*channels->async_scrq, GFP_KERNEL);
> +	if (!channels->async_scrq) {
> +		rc =3D -ENOMEM;
> +		goto free_scrqs;
> +	}
> +
> +	rc =3D ibmvfc_alloc_queue(vhost, channels->async_scrq,
> +				IBMVFC_SUB_CRQ_FMT);
> +	if (rc)
> +		goto free_async;

[Severity: High]
Is this missing a step to register the asynchronous sub-queue with the
hypervisor?

The queue is allocated here and mapped in memory, but it doesn't appear to
be registered via h_reg_sub_crq() anywhere.

Because it is never registered, its cookie remains 0, meaning an
uninitialized handle is sent to the VIOS during ibmvfc_channel_setup(),
and no hardware IRQ is mapped or requested, which renders the async queue
non-functional.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D5
