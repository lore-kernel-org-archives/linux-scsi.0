Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D23D9DA1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312429; cv=none; b=iOKwosAFAIN+/DGC0wbS5uasgVGdroteF9PkSUXNThEiLmodgx9pRkbiZJi0PQy2F/AJwBOWyinzeYOewOQ66FQqlW7/MFwR3JQV0gLPK+A7Y/u67mS7vQjBayvnlUyK9tL4cQNyAMIqkw+VftASImNqKnnyM8LrHH6i0h8O0aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312429; c=relaxed/simple;
	bh=ep9xnSSm3QuaiuIQfq32b9MKwdz4V00VCqj5FeNP7WU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NhiJfvZbMcHhEjBkTqToO4XaC1/cobQjOhRzWQhtMXFaiDYdd2PFrMExe1hQrcpLSteNkvVF/DuB/X27f4yJ50E/keAX+H/20p/V6gIFlIks7wkuyLcRyEx/piMuPJN5gPKuIaIIxjlJiQV9TvkN+N4GyB2cRR0r/B55gl8HCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQG476uY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQG476uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5481F000FF;
	Fri, 25 Sep 2026 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790312423;
	bh=iKn2Y8AvJqdhThubPCQKk385namR7nUeQyRDkySwq8k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQG476uYJbOQ55ba/7+nSC1Azs6VXb3VLwNRjY6RPvluxMMrbYXTzJ0Je6VMzFVQP
	 BorGYiYpBE7kgBERman/NaBkDk6fgRBc2VK5uTlzVIFrFHWCe/3E/vcOaKO9HTTMGD
	 fdJUCESlklbvVeW12O4tlGT5LdA0gP510s29mkHdLLzdq+SnwGnsdfbZ0q0ap8b4P4
	 0mPVVk4qcYrQymAFxU5ymPtUlNqy1diwjYZsK93KYnCXplr8zJzlVNCXAa4oDMVbZg
	 CQmtS4TM//wtLqeFO5m0kFOtCvXbXTIFKGSqHA224k70ybWX+C0mGsZkQm4UKLUnXG
	 Tx7cMgpwRlUrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260925044900.414340-8-tyreld@linux.ibm.com>
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
 <20260925044900.414340-8-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 05:00:23 +0000
Message-Id: <20260925050023.8E5481F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: FPIN descriptor uses potentially unpopulated WWPN =
from sub-CRQ
--

commit 8a1ab5ee327462636518cdba29b91df0f867bb9f
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This commit refactors async event handling to support both traditional async
CRQs and new asynchronous sub-queue CRQs. It introduces a tagged union that
wraps the async event and dispatches processing based on event type.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index f465efadc02c8..321bb2f7219ed 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq =
*crq, u64 wwpn)
>  					  cpu_to_be32(1));
>  }
> =20
> +/**
> + * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpi=
n struct
> + * containing a descriptor.
> + * @ibmvfc_fpin: Pointer to async subq FPIN data
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
> +{
> +	__be16 type;

[ ... ]

> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin=
->wwpn,
> +					  type, cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}

[ ... ]

> @@ -3463,28 +3502,40 @@ static struct ibmvfc_target *ibmvfc_find_target(s=
truct list_head *target_list,
>   */
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {

[ ... ]

> @@ -3496,7 +3547,11 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
>  		goto free;
>  	}
> =20
> -	fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	if (crq)
> +		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	else
> +		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +

[Severity: Medium]
If the hardware sends an async sub-CRQ FPIN event lacking a WWPN but
providing a valid node_name or scsi_id, the driver successfully resolves
the target (tgt) earlier in this function.=20

However, ibmvfc_full_fpin_to_desc() uses subq->wwpn instead of the resolved
tgt->wwpn. Could this generate an FPIN descriptor with a zero attached WWPN,
causing fc_host_fpin_rcv() to fail to match the target's rport and drop the
congestion statistics update?

The legacy CRQ path safely passes tgt->wwpn via ibmvfc_basic_fpin_to_desc().
Should ibmvfc_full_fpin_to_desc() be updated to also take tgt->wwpn?

>  	if (fpin) {
>  		fc_host_fpin_rcv(tgt->vhost->host,
>  				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925044900.4143=
40-1-tyreld@linux.ibm.com?part=3D7
