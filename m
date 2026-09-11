Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC61F1534
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106446; cv=none; b=ZZpXkuIAPgeobEiEInIIY8G3bxQPmrikKNNcUQI/Vde8LY35rFXywDlzOCgjeRZNy89y1BBPLFXAZSH9x0kfVZXQILcbjTSFC3CNCvbQbf6TasJ8doWpiaSmqIKFx8/amLB2knuDzS6dVmBYUahSafKwBbOMnGrWCPVUESdVrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106446; c=relaxed/simple;
	bh=BWDDaH5h54zaOSsEu2PwaG6s7dkfl4UMeql3dIGjf0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o66RAwa/ZU0NfA4kAe3wF4ZVAtJh11C1gCW6OqXtBcpq+8hr56Q6mESy1LGPcGyLiWK0CfoyzaaEsXrzYLyDibjvU5fNHL2duZcA5f8laR5VVdmwjs40pXJRnkv+sif96jZLfKTKLRtEh7J0Ya2HhewLAQabHDfVYlcgl1BVIVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPRrV7js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPRrV7js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8F41F000FF;
	Fri, 11 Sep 2026 06:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106444;
	bh=aTgWoeBKGmORs13y5cXhxRCKWWnyCAmPoZPa6tLLIq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gPRrV7jsUjHPtSULiNk0bELloxxLL1//hDoWCDUg4NhceplSpZD85FVlMfV7w+77x
	 dYBEJdq6l8bNPd6QzmbiNjYptsxT0YbkeeBlrjWMJm1O4AesGrvj0eK52zdeHxQ1hY
	 X5AqppykTq1OH+sHfLZuTLdr3i6AaiBLD7Yw065xTQrRjiSOrHgt12rW4d+xjjPGhm
	 q6PlEYN5pRCwIQ8Z8JOUxCUkDkIv0dmNwWvMbFdkQlBpY73peHiuconfh8g8hONyJ1
	 Y8YBYvN97n74KEnzG9Z7J/IwB04DH2N9BA+qQSiAN6y0crQmennWRI1Nlz6MjbV4+K
	 33V5oJkC9hjmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 2/9] scsi: ibmvfc: add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911054832.1311668-3-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:00:43 +0000
Message-Id: <20260911060044.5D8F41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is a pre-exis=
ting high-severity issue in `ibmvfc_handle_scrq()`. The unvalidated pointer=
 `evt` (derived directly from the hypervisor's untrusted `crq->ioba` payloa=
d) is dereferenced via `evt->queue` to determine which event pool to valida=
te against. If the hypervisor provides a non-NULL garbage correlation token=
, this will trigger a kernel panic before the validation function can even =
execute.
--

commit 7bc4ed43b16179c365542ff5e1801c32adcc35f1
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add NOOP command support

This commit adds support for handling IBMVFC_NOOP format CRQ messages from
the VIOS partner. It handles and ignores NOOP messages in both
ibmvfc_handle_crq() and ibmvfc_handle_scrq(), while also logging unexpected
NOOP commands. Additionally, it fixes a typo and guards against null event
pointers before processing CRQ responses.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 514fc87c10173..7ea64956653ef 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4223,7 +4233,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
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
> +	if (crq->format =3D=3D IBMVFC_NOOP) {
> +		if (vhost->state =3D=3D IBMVFC_ACTIVE &&
> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
> +			dev_err_ratelimited(vhost->dev,
> +					    "Received unexpected NOOP command from partner\n");
> +		return;
> +	}
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");
>  		return;
>  	}
> =20

[Severity: High]
This isn't a bug introduced by this patch, but is it possible for a malform=
ed
CRQ message to crash the host in ibmvfc_handle_scrq() here?

If the hypervisor (VIOS) returns a CRQ response with a non-NULL garbage
correlation token in crq->ioba, it will be cast to struct ibmvfc_event *evt.
The !evt check will pass, but immediately after this block, the code calls:

	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {

This dereferences evt->queue to determine which event pool to validate agai=
nst
before the pointer is actually validated. This could lead to an out-of-boun=
ds
memory read and a kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911054832.1311=
668-1-tyreld@linux.ibm.com?part=3D2
