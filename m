Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448775;
	b=Q3nnHqPTP3ds/epD2C0MIoYnLRWceTglHYiCSNIqSBedOSpKXVxd2GCSsQD2QZ+SWlFn
	 9mw9nx/3/mzN79gA/ApOKS3bztSbC1gArswzkc6HsRqEYV33jLBfQ7kAblFNYtMFPHGyL
	 igyVPvfr4PmeiBWta3T3JuVJy3k8zqwjvH6tzUpQCnH+CjAr1AKD/O64aGkWPWkZI8A8/
	 cFQfeQ2OdXDdd1Mpyq0QsqWTLlRBBqzqq2hiMr+Vbz1K5m/Cdm0KlJ1P/5dd0/dLDcm9i
	 bCz/NKNp/9rqk6VxvKslLWsW1X4ZUFRslr+6TWFJYUGOjob3aIrFqD3zcyGsqjOpXGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448775;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LlRL0+VYpIOHaaECalTh2x0CubxvgZCHa9dYckpKbm4=;
	b=sp4/zo5cHycMowkItrL72iqRjv96A8BGPgXKE7CSv1iZIKba8QwaFZA9sYDeZpEI/Xdr
	 92IJmFD7+TvZSXQBMMLVYz37QIGl7D1ZrFslKcdhpx0fAkvd/3Q+tM2RAI3cpbht6iSKd
	 SDSr+FloMOh6uRujzW4Yk90lXei+bEKe668AaROzT0mxCH8ioVHrGpNxLS+Xvf0vG+raK
	 Xe9PWe8pyHFRNljjHwo7N08lPgs4iTM7tkbM0ZmdKutfjcyvSDiUtyLiWUH8J9HdaxrnG
	 ONUyD2nbTNDSYWyBi9zhA6z5EGqpM4aj195Zwei4F9G5wH4il82HjEimIVBvmpoUCeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JRpE/Oih";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62EC606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRpE/Oih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B71D1F000C4;
	Mon, 19 Oct 2026 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448774;
	bh=LlRL0+VYpIOHaaECalTh2x0CubxvgZCHa9dYckpKbm4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JRpE/Oihe2tPHoOdKDMWNekn7ZH/g7Bpd0yWJ7v2LdvBt7PhURqZmTPDS7gXC4QNC
	 0KmaRyDazHkOOYd7NdkgGnMuvQOEIFLiBXYJJAEKtRJDeTZA35Fb1I7aQ40BcvYRfX
	 0TglTJyvU+oSo+ndos9ptF6waDnMPqZZKx0xIiK2M3kObIgAj4lzKTj5GpyIXu6PYj
	 hq3El4/bAa2lH6D32Tk/Md/t+3drhru8MAuaagd6OcfReQPlVRY++CLiCBz/M+jvRu
	 wD8tSKr3I0c8PvOOKeJK0p2Kqf5i2JzL+Ay5ASEJZgizdjLvO3df8GaHB28aOOSWJF
	 3b01EmfwLogfQ==
Message-ID: <sashiko-outbox-178317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261019-ibmvfc-fpin-support-v15-10-a858726e178a@linux.ibm.com>
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
 <20261019-ibmvfc-fpin-support-v15-10-a858726e178a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 22:26:13 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: clearing mq_enabled in ibmvfc_reg_sub_crqs() skips d=
eregistration
- [High] scsi: ibmvfc: ibmvfc_init_sub_crqs() ignores ibmvfc_reg_sub_crqs()=
 failures
--

commit 97f68806c8ca0b8cd795db2454a75c5e092d7ae9
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the asynchronous sub-CRQ into the sub-CRQ lifecycle by
allocating, registering, and freeing vhost->async_scrqs alongside the SCSI
and NVMe channel queues. It also updates channel setup and login info to
handle the async sub-CRQ and multi-queue capabilities.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 7e012281d368c..0d603542fe348 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6977,6 +6995,7 @@ EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
>  static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>  				struct ibmvfc_channels *channels)
>  {
> +	unsigned long flags;
>  	int i, j;
> =20
>  	ENTER;
> @@ -6987,7 +7006,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host=
 *vhost,
>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>  			for (j =3D i; j > 0; j--)
>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>  			vhost->do_enquiry =3D 0;
> +			vhost->mq_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  			return;
>  		}
>  	}

[Severity: High]
Does clearing vhost->mq_enabled here prevent previously registered channel
sets from ever being deregistered?

In ibmvfc_init_sub_crqs(), ibmvfc_reenable_crq_queue(), and
ibmvfc_reset_crq(), channel sets are registered sequentially:

	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);

If ibmvfc_reg_sub_crqs() succeeds for vhost->async_scrqs (or
vhost->scsi_scrqs), and then fails on a later call for vhost->scsi_scrqs or
vhost->nvme_scrqs, the error path in ibmvfc_reg_sub_crqs() only unwinds the
current channels set and sets vhost->mq_enabled =3D 0, leaving the earlier
channel sets registered with the hypervisor and their Linux IRQs active.

Because ibmvfc_dereg_sub_crqs() guards deregistration on vhost->mq_enabled:

	if (!vhost->mq_enabled || !channels->scrqs)
		return;

	for (i =3D 0; i < channels->max_queues; i++)
		ibmvfc_deregister_channel(vhost, channels, i);

all subsequent calls to ibmvfc_dereg_sub_crqs() in
ibmvfc_reenable_crq_queue(), ibmvfc_reset_crq(), and
ibmvfc_release_sub_crqs() will return early without calling
ibmvfc_deregister_channel().

When ibmvfc_release_sub_crqs() later runs during teardown,
ibmvfc_dereg_sub_crqs() is skipped while ibmvfc_release_channels()
unconditionally unmaps and frees each queue page (scrq->msgs.handle) and
kfree()s channels->scrqs. Doesn't this leak the hypervisor sub-CRQ
registrations and kernel IRQs, leaving the IRQ handler and hypervisor
referencing freed scrq slab memory and DMA pages?

[ ... ]

> @@ -7081,9 +7084,53 @@ static void ibmvfc_release_channels(struct ibmvfc_=
host *vhost,
>  	}
>  }
> =20
> +static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
> +{
> +	unsigned long flags;
> +
> +	ENTER;
> +	if (!vhost->mq_enabled)
> +		return;
> +
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
> +		goto out;
> +
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
> +
> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
> +		goto deregister_async_sub_crq;
> +
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> +
> +	if (vhost->nvme_enabled) {
> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +			vhost->nvme_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		} else
> +			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> +	}
> +
> +	LEAVE;
> +	return;
> +
> +deregister_async_sub_crq:
> +	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
> +	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
> +out:
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +	vhost->do_enquiry =3D 0;
> +	vhost->mq_enabled =3D 0;
> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +}

[Severity: High]
The commit message states that in ibmvfc_init_sub_crqs(), failure of either
ibmvfc_alloc_channels() or ibmvfc_reg_sub_crqs() disables multi-queue and
aborts init. However, ibmvfc_reg_sub_crqs() returns void and its failure is
not checked here.

If ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) fails, should
ibmvfc_init_sub_crqs() release vhost->async_scrqs and return rather than
continuing to allocate vhost->scsi_scrqs and vhost->nvme_scrqs?

Similarly, if ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) fails after
vhost->async_scrqs has been registered, shouldn't it release
vhost->scsi_scrqs and jump to deregister_async_sub_crq so vhost->async_scrqs
is deregistered and released instead of proceeding to allocate
vhost->nvme_scrqs?

[ ... ]

> +static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
> +	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
> +
>  	if (!vhost->scsi_scrqs.scrqs)
>  		return;

[ ... ]

>
>
>
>

[]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-ibmvfc-fpi=
n-support-v15-0-a858726e178a@linux.ibm.com?part=3D10
