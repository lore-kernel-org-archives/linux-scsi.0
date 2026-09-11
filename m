Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C64725B084
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106613; cv=none; b=kNNFNiPNGAKU4VGa+I+0B0vXZQWz3bcDLehp8wFgwwbnLQJsVb68xIimkXwrBjnBWninIpqP2ncge13xQeqkeIAGqxqUf+g6eQYWF4Mkd0spCh6t5HNQqMRM9EqxEZ6XK8PE6MNKwpQzU8//p6UJHjIfECoxVsCKP7rel3s5hHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106613; c=relaxed/simple;
	bh=UB+SISbbesghW9fa3CIm/OBp7BhUaCIPTQLSfnZkndM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ftGvuuqvHdDvuFzc41FUhp35Gz8QFaOHgum/GejLMY2jG1mPr60+zE3F3xORoOLIENWEvFeh5YC+e9fAeNumWCBJ3ztBzhs9AnMEONrK2AapUqRy5LGkZTRXg+a2/0mlm0zTm7I60miZ+jPHJUDrxhCgcGtIC29Ma4+T9LgGjr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcKTd4wp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcKTd4wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE71F000FF;
	Fri, 11 Sep 2026 06:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106612;
	bh=i1FxH5btFzjkQMm1H6wQcWHtKbiCpAHqTbTDabYsn70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DcKTd4wpfkdIw5hSqBZc18bV+V3HErG5REfmfYfRvnc88wEePjbeqTXnAgDcZMaJc
	 Ndpjw8TfgDsIG1vw/0q9wH9kaNKFsMxFXoDyAPG2onBVTdVHeYpF3+ecFJbYxCWAPd
	 QQfbfZAYBkZzS+81x5dG0JD9sUxk4c7ZeWYWeoqLWXazMEXv3C/CYyShyWe1u4T3D4
	 tmifp06ZpRKFG37ZdLxYIterQZh9PCndBP0zkh+oeydON2I+NUSsrdtogfKGb6dJwM
	 lxWRxl9QpPEa4KXzgHOQCqppH0HISn/rIQ7ZrX7Wbb4SkAnLlsThqXL/jF4kz09/yC
	 Op56pPd5fUAVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911054832.1311668-8-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-8-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:03:31 +0000
Message-Id: <20260911060331.CEAE71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unguarded hypervisor cleanup in ibmvfc_deregister_channel() leads =
to double-free of hypervisor resources and unconditional H_FREE_SUB_CRQ cal=
ls.
--

commit 6e9a49d8343f9077df9f1052cfd7a71c721c4b81
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure

This commit ensures scrq->irq is cleared to 0 after irq_dispose_mapping()
and guards free_irq() and irq_dispose_mapping() with a check for scrq->irq
in ibmvfc_deregister_channel() so unmapped or unregistered queues are
safely skipped.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index a9cf1096e755d..c78e221f182a2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6890,6 +6890,7 @@ static int ibmvfc_register_channel(struct ibmvfc_ho=
st *vhost,
>  		else
>  			dev_err(dev, "Couldn't register async sub-crq irq\n");
>  		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;

[Severity: High]
This isn't a bug introduced by this patch, but on the request_irq() error
path, the hypervisor resource is freed but scrq->cookie is not cleared to 0:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_register_channel() {
    ...
irq_failed:
	do {
		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ,
                                              vdev->unit_address, scrq->coo=
kie);
	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
    ...
}

Could this cause a double-free when ibmvfc_deregister_channel() is later
called?

>  		goto irq_failed;
>  	}
> =20
> @@ -6932,9 +6933,11 @@ static void ibmvfc_deregister_channel(struct ibmvf=
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
This is a pre-existing issue, but does this leave the hypervisor call
unguarded?

It appears this hypervisor call is executed unconditionally using whatever
stale cookie is present, even for queues that were never successfully
registered or have already been freed.

If the hypervisor reallocates the freed cookie to another queue or device,
could the double-free maliciously or accidentally destroy a live queue?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911054832.1311=
668-1-tyreld@linux.ibm.com?part=3D7
