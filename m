Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2493BCD12
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788215673; cv=none; b=BEPj+okywMIDdHbgdLeGBp9H8DqyDPDZ53RhMM6T4qbXMGVSfz+jx61CjuKrFEhcJyghP+9soXE55Av2gP8wVpQ/nspp8okBGvDferSZFo/zMp4Dkv7EK4WGwi0t0T94Q1uAEF+ONQvkXxT1BpI4QHeM4OrCA/FZ7XbAk7Lrv6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788215673; c=relaxed/simple;
	bh=/UQJK+pt23D4W6sEDnBdm3/3BwF+78dr+dXeqRhXDPE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HulvWTP47ScFdSgLsbrCKIw4LJaJt4MNcmdwntdvvYCgcNPT8yAlGePG884cV/jt6YT3H+ERqNG3w86F1MQO/9ptVjHVaFpe4MVuA6rJb04Edc1IpggIR+behWCi9e+dVAXBl8zsqgVOHCx4UH5FO9SuIZYKLYSzEQj385FQG84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zbyd3jVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zbyd3jVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4341F000E9;
	Mon, 31 Aug 2026 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788215671;
	bh=oSok4zGewcwa/412/qVq/TG9pe/zZsQiLeuXpNfN4eU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zbyd3jVeO4tyGFOFvRMEOubzHwwkfwqbujGwuUIKAbbWMnAYt56swsWWvi0RKZNAE
	 vxheZfSitHMU3aFd/DOU525CQ0MkWx/lSjqdKopTDMqLIJZq5EkHSBHOHDmet+2LEP
	 ySqXKFPkGsdFFw6hgmCSN4aGn9ofdmjpjM0+sHM0rVuuyXLJnmQ5o5o674NvwkosFI
	 0Q4UrdKe8fjksAlAHTReL+ZDhinfbdQPlGtVGBFeB3p2BLE3w63obPcUwQoRIlwfeL
	 FWlA/RfEKx1RjhwPBdmAG8yPXKbNqDzRuLR/SgUlm51Jx0C6iCoRPF2YsYoVV/7Sx4
	 NnCAfn9DtSdPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/8] scsi: ibmvfc: extend channel registration and
 deregistration for async subq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-6-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-6-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:34:30 +0000
Message-Id: <20260831223431.2F4341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Race condition and lockless list access in async sub-CRQ handler.

Pre-existing issues:
- [Medium] Stale IRQ mapping handle left on error path causes free_irq kern=
el WARNING.
--

commit 99a10b7da4dba7f584bda8695781cb27e1b928b0
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend channel registration and deregistration for async subq

This commit extends ibmvfc_register_channel() and
ibmvfc_deregister_channel() to handle the async sub-CRQ by accepting a
negative index. It also removes the __maybe_unused attribute from the async
interrupt handler to enable its use.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4409,7 +4409,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_q=
ueue *scrq)
>   * @scrq_instance: async subq
>   *
>   **/
> -static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, v=
oid *scrq_instance)
> +static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_insta=
nce)
>  {
>  	struct ibmvfc_queue *scrq =3D (struct ibmvfc_queue *)scrq_instance;
> =20

[Severity: High]
Now that the async sub-CRQ handler is enabled by this patch, can its
execution race with target teardown or host reset?=20

In drivers/scsi/ibmvscsi/ibmvfc-core.c, the interrupt handler calls:
ibmvfc_interrupt_async_subq() -> ibmvfc_drain_async_subq() ->
ibmvfc_handle_async().

The ibmvfc_handle_async() function expects to hold vhost->host->host_lock,
but this call chain only holds scrq->q_lock. Consequently, it iterates over
and modifies vhost->scsi_scrqs.targets without the proper lock.=20

Could this lockless list traversal cause a use-after-free or data corruption
when handling dynamic async events sent by the hypervisor?

[ ... ]

> @@ -6825,36 +6841,49 @@ static int ibmvfc_register_channel(struct ibmvfc_=
host *vhost,
[ ... ]
>  	rc =3D request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
> =20
>  	if (rc) {
> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		if (!is_async)
> +			dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		else
> +			dev_err(dev, "Couldn't register async sub-crq irq\n");
>  		irq_dispose_mapping(scrq->irq);
>  		goto irq_failed;
>  	}

[Severity: Medium]
This is a pre-existing issue, but does leaving scrq->irq populated with a
stale value after irq_dispose_mapping() cause a kernel warning during
teardown?

If request_irq() fails in ibmvfc_register_channel(), the error path calls
irq_dispose_mapping(scrq->irq) but does not clear the irq field to 0. Later,
when ibmvfc_deregister_channel() is unconditionally called for the async
sub-CRQ during teardown, it might call free_irq(scrq->irq, scrq) on this
stale mapping ID (or on 0 if it was never registered).=20

Should scrq->irq be explicitly cleared to 0 in this error path to prevent
invalid IRQ descriptor warnings?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D6
