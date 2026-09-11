Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05643DDAFA
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093657; cv=none; b=WECX4ASdiP00fijlbJuGY1jnRjhdtn7ygQTc4lIxm19eyVVcsCk0jeqGZ9nRoV5BC55fmSBh/EFgraxr5UzFrHYYhWPZU4iLFh1694v6ke4AE7VnLgPsG8iSytSj2ONIeu74+P8A1pIk2sGEhxn94PMWAn6AgxD5wQ32/XBXhFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093657; c=relaxed/simple;
	bh=dOTixXdHPt2OEA0tpsFyZp1P+XOJDiEg+SgZIO9teJc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hfY5Owh0iWMxEhKbDnnmlvsOvPZvtCCutPS6/nLIPnb8sxlWi0On2KBw2NK0JZv21/y0Xpz05BZ5RM56wR5zD8cQ2+5kOdRQMFeyWPzmyoyHNX1eu2ErTSmxmGLwk41qUFht3crazdIqiyKIJHB6lE/hocRknAioN99RYv45Lis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZvyJV6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZvyJV6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E961F000FF;
	Fri, 11 Sep 2026 02:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093655;
	bh=C/G8tCWaBnSAIgYn07c5Po65iBoiDOcsyueYfFmwg6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AZvyJV6nZ7/LbViYWSjjIRSsaBoWr4rymyDyaA08EFn/rzot0VjZfzyHmBRUnT9mP
	 rXF0deuKB8qdOyt+HtON3Faju2l68Stx88I8Xtod4vlr0D4k65SwTDU7Ti6nCwfJwZ
	 T3SYRJgyidkVfl0+7qT9fzIV4OpxxaX1CaGej9xkELkl+yTnYXouxap8g12h3+LHL4
	 2zK4RBQiUGMoOag6+EIPtDv/rUg2pgRUtX1whITkWoBwcaOFhz6owEn44vIbHBZGeC
	 CoWsVhAcVVo20ABMyhxd7p4pd88FEI0fmuaSUM7F/sh5vSEBTgov59dWstAlR4Ai1E
	 kqFMkmTA9tCGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-7-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:27:34 +0000
Message-Id: <20260911022735.27E961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Stale or uninitialized scrq->cookie is not zeroed on registration =
error paths, leading to hypervisor double-free vulnerabilities that can des=
troy actively reallocated resources (like NVMe channels).
--

commit feefbdeb2d2be2bbda626264ddada70d34bd36bd
Author: Dave Marquardt <davemarq@linux.ibm.com>

    scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
   =20
    If request_irq() fails during ibmvfc_register_channel(), the error path
    disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->=
irq
    populated with the stale virq number. A subsequent call to
    ibmvfc_deregister_channel() during teardown or reset cleanup then
    unconditionally invokes free_irq() and irq_dispose_mapping() on the sta=
le
    IRQ descriptor, triggering kernel warnings.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index fa312a58471fa..8eeb125ee13b8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6933,9 +6934,11 @@ static void ibmvfc_deregister_channel(struct ibmvf=
c_host *vhost,
> =20
>  	ENTER;
> =20
> -	free_irq(scrq->irq, scrq);
> -	irq_dispose_mapping(scrq->irq);
> -	scrq->irq =3D 0;
> +	if (scrq->irq) {
> +		free_irq(scrq->irq, scrq);
> +		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
> +	}
> =20
>  	do {
>  		rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,

[Severity: High]
This is a pre-existing issue, but does the sub-CRQ cookie need a similar
check to prevent a double-free against the hypervisor?

If h_reg_sub_crq() fails during ibmvfc_register_channel(), scrq->cookie
is populated with uninitialized stack data from retbuf:

h_reg_sub_crq() {
	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
	long rc;

	rc =3D plpar_hcall(H_REG_SUB_CRQ, retbuf, unit_address, ioba, length);
	*cookie =3D retbuf[0];
        ...
}

Additionally, if request_irq() fails in ibmvfc_register_channel(), the error
path calls H_FREE_SUB_CRQ but leaves the stale cookie in scrq->cookie:

ibmvfc_register_channel() {
        ...
irq_failed:
	do {
		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq-=
>cookie);
	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
        ...
}

Since ibmvfc_deregister_channel() is unconditionally called for all queues
during teardown, it appears this could pass uninitialized data or a stale
cookie to a second H_FREE_SUB_CRQ call, potentially destroying unrelated,
actively reallocated sub-CRQ resources.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D7
