Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB283A544A
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788212461; cv=none; b=sOogpmrd2Vc68lhNUWXfjFWDEqlbXjUnJitaMpe6OMR94/33OaxwU9l5V3yyXtYuFMK9jZt7J6p7LFIDNORFD1TZ8yW/KzyCmlMCESQWABOW0hPSokX7FWG1neMuP5vGKxlunEFPDyVpdEdnG0NI4N+f9v3ZNgdmqkUPEKOVCHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788212461; c=relaxed/simple;
	bh=MmLxkpEJ5xG2CBZyQQOgdgkNr1jOUMhKcpZUo7j0lAQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EvLEjb8y7vzqKkNRV/xjtWqU6T0ufXw5KGIWy7GhHH3tlkhSZkgHq+pdoNmAsFj3RhDqFom5LlLQ6pHVR/bGogzXl0YYpfNnpuSCMqLWtl8V+6VHl2U8I86wSdQl6MTnZu2pLH+0D4LFPfnMqAgRaKfYvarcQw5G3mj1Cub1zas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCokACPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCokACPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA141F000E9;
	Mon, 31 Aug 2026 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788212457;
	bh=UAqVjKwcp3M4tKsHphZOBvqbEQMlx4QJGSrdDSyVeAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nCokACPISQCSdAkyUyMqT/P6rer/T/ZX2q6fN9kyFSrezLqaLc6/TeZpwZtGLrNrc
	 5YdJdxuDjHXx3rvg0diHWZb1fm+CS32tbpcRA/X1lpNdfqSBPfW9VmGSf1pna9HPvo
	 wNtVCNc/SsxWI/aX9ss8hArd2/A6v30efNufxC4Fb7tZ6fWozubwsNBdtWplO+VI2o
	 PXj3gfI1LYmtuFdHSW6OXJlPcWSOZENwUWp/a1Fkx2Bkxid7MuIZoU/EPagUb5Hebs
	 K9eITWmzMFt5Z6dosPg88wMlFoNbu0MWHkrXEOQ3hceJemPNPadegC+dPxeMqlpNTM
	 xyq9ADU9PDQvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/8] scsi: ibmvfc: Add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-2-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-2-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:40:56 +0000
Message-Id: <20260831214057.3FA141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The code suppresses logging of unexpected NOOP messages received=
 before NPIV login completes, directly contradicting the commit message cla=
im of logging early messages.

Pre-existing issues:
- [High] Dereferencing untrusted pointer `evt->queue` before validation in =
`ibmvfc_handle_scrq` can lead to a kernel panic or out-of-bounds read if th=
e partner sends a malicious or corrupted non-NULL correlation token.
--

commit a2f1ce40ef9fb5e6c86a16b1ac92eb6c526f0a48
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: Add NOOP command support

This commit adds support for VFC_NOOP messages from VIOS to enable keep-ali=
ve
functionality between the client and server. It defines the VFC_NOOP CRQ
format, adds handling in the CRQ handlers, and sets the NPIV login capabili=
ty
bit.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 78be00d31a064..e972e4ec5be00 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3693,6 +3695,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *c=
rq, struct ibmvfc_host *vhost,
>  	if (crq->format =3D=3D IBMVFC_ASYNC_EVENT)
>  		return;
> =20
> +	if (crq->format =3D=3D IBMVFC_NOOP) {
> +		if (vhost->state =3D=3D IBMVFC_ACTIVE &&
> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
> +			dev_err_ratelimited(vhost->dev,
> +					    "Received unexpected NOOP command from partner\n");
> +		return;
> +	}
> +

[Severity: Medium]
The commit message states the intent is to "Log unexpected NOOP messages if
received before VIOS advertises support during NPIV login." Does this
condition match that intent?

In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_crq(), the code checks:
if (vhost->state =3D=3D IBMVFC_ACTIVE && !ibmvfc_check_caps(...))

By requiring the host state to be IBMVFC_ACTIVE, this appears to suppress
logging of unexpected NOOP messages received during the IBMVFC_INITIALIZING
state, and only logs them after NPIV login has completed.

>  	/* The only kind of payload CRQs we should get are responses to
>  	 * things we send. Make sure this response is to something we
>  	 * actually sent
[ ... ]
> @@ -4223,7 +4233,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
crq, struct ibmvfc_host *vhost
>  	case IBMVFC_CRQ_XPORT_EVENT:
>  		return;
>  	default:
> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->vali=
d);
> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid=
);
> +		return;
> +	}
> +
> +	if (crq->format =3D=3D IBMVFC_NOOP)
> +		return;
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");
>  		return;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but can this lead to an
out-of-bounds read or kernel panic if the VIOS partner sends a corrupted or
malicious non-NULL correlation token?

Just below this new null check in
drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_scrq(), the untrusted
evt pointer is dereferenced prior to validation:

    if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {

Could a malformed CRQ payload with a corrupted crq->ioba token cause a
crash when accessing evt->queue before verifying that evt is a legitimate
pointer from the event pool?

Passing the scrq pointer from ibmvfc_drain_sub_crq() instead of vhost might
be a way to avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D2
