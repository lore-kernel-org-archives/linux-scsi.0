Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895442CB14
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077677; cv=none; b=OOreAB5osO4BmctyqUdGwgMVjG+yVZFs0l8oSavvmxJm8lPuWfTeh+AlaXcwcWkdOvnE/Sz5RwHGh6tZc2p+E5Ed03wlJuXl/vOB2P8SDgwCMUg0u6yNeCE4g8hea1Ty+Y2+F3HZZX9FoFPeqYNY0+wIrWhiMFpcQ7WXLLn6cHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077677; c=relaxed/simple;
	bh=A1WnrbElwoj1WsY3TSZx8dLiT0A6VDdKtk7a8OHnXxE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=L7NyQF6XTwEycoah9BOCw2B3aEF5balcO4Fwlu3p+ooJK0deo8SOVBNFwygDyqbBwjCo5gFSlRLq0UtfxmqUnhr6DsJcjGV3kIWrPbuvZ15SbpNFMXpMNNHlpPFdY5ydIYx9OYmQXltCYCdRR9AlsC8BRg2sYq7O/K4tvNIc/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eu74gXqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eu74gXqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02AC1F000C4;
	Thu, 15 Oct 2026 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077676;
	bh=0kA5WO3T4KsUXraHWnoFlBjsKf414wnZZh6RGjxLo9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eu74gXqoeh6cjY1W6AVrQkz1Bzu7IWJVrFbTos8CJ0o7z1FjX2L1Q8E9bKo6EK/+v
	 gN6+7jEwJQgwCyHMQm/aY+jxOSAdwsZUHx1dr1FOFs58eSBZq7T5RK9rL9DzOvRihZ
	 hio6J6iAdRcjEH0f3sfi9N62GQarlamgsgdsNo1wk2XM1+w93ptg4LCLpW300RjOJb
	 HRnArPtKdg4hOaO+iiDsuUeM9QlFz7ONrFKK9nn1Jy6j2wQArNCVEM2Ipt6SWlpLdk
	 eT9iZeeedsEmdCVhqscUfGFPQBLDTui8YsG6D+uBPJBll8/dGk2F3AuY/i4VYbJEoI
	 3mCmxJY7aZynw==
Message-ID: <sashiko-outbox-173056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 09/11] scsi: ibmvfc: extend channel reg/dereg
 helpers for async sub-CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-9-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
 <20261015-ibmvfc-fpin-support-v14-9-a0b063b8d825@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 15:21:15 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ibmvfc: race reading uninitialized hwq_id on early interrupt
--

commit 305244f5c1aeffae812f2cadfc3586d45148fbbe
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
   =20
This commit extends ibmvfc_register_channel() and ibmvfc_deregister_channel=
()
to handle IBMVFC_PROTO_ASYNC channels. It removes the __maybe_unused
annotation from ibmvfc_interrupt_async_subq and updates error messages to
include the channel protocol.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index fc69012efccc0..b12655f028879 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6882,7 +6901,8 @@ static int ibmvfc_register_channel(struct ibmvfc_ho=
st *vhost,
>  	rc =3D request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);

[Severity: Low]
Is there a potential race condition here when the interrupt is requested?

If a hardware interrupt triggers immediately after request_irq() enables it,
the newly bound handler ibmvfc_interrupt_async_subq() could run before
scrq->hwq_id is initialized:

ibmvfc_register_channel()
    ...
    rc =3D request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
    ...
    scrq->hwq_id =3D index;

If an early interrupt happens, the handler calls ibmvfc_toggle_scrq_irq(),
which uses scrq->hwq_id for error logging if the hypervisor call fails.

Could this result in reading an uninitialized (zeroed) scrq->hwq_id in the
dev_err() message? Would it be safer to initialize scrq->hwq_id before
calling request_irq()?

> =20
>  	if (rc) {
> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		dev_err(dev, "Couldn't register protocol (%d) sub-crq[%d] irq\n",
> +			channels->protocol, index);
>  		irq_dispose_mapping(scrq->irq);
>  		scrq->irq =3D 0;
>  		goto irq_failed;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ibmvfc-fpi=
n-support-v14-0-a0b063b8d825@linux.ibm.com?part=3D9
