Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D48932B139
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779950269; cv=none; b=CIpg+6pIxCFXWig8Gwlv6Zwc0k19Jt8Kzj83d7/c63w6mxjiDUBWUc7PmmkgqTXQkRHaRhozIdc6VKESuY2RMlPjCxeNfcVZvIfN7Bpj7iBh7Yb/eyXgPdzT2RC5PucZXUQeYBTmLAJGphjp04i7PHnJGtRovOaepM39NkbB1JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779950269; c=relaxed/simple;
	bh=rjf1M1rdJQ8MRrgqNMwuXVNidW7IgFQtnblsECw4YP4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=iuayrmF3u6ZXeOlu5SFPNZftODWphW0DID5NlcYDx5VvY8YdPYmmNKd23aTsgXDJltsl+cUQArBdt6HHec+bBER8PKjPsmsQJUCkwTAOlKqIsa5QuEj9TQc/46HaLtTs4yX8VQCNarfsZdi42yW09fq8F/utxmKVNFUdyvYfEVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=CYcr1LL0; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="CYcr1LL0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=rjf1M1rdJQ8MRr
	gqNMwuXVNidW7IgFQtnblsECw4YP4=; h=in-reply-to:references:to:from:
	subject:cc:date; d=arkamax.eu; b=CYcr1LL0k7I4BnznGKWjBQs2Cq9KzJIA5pNnv
	UnQlOaIZl6NFzz7pEsRSxutXxUlmUmWwjKmDJ1m9jmkNLSpJvBZcE97CMfjvV/Jh2T68MU
	ZqDXFO56LQ9LcJfxtFBZJtKBWmBl3oPNjnR+kSIOHbWOqYm7TNPZQ24tfdbhGl+TpA2EV3
	Dg3FIEsl5vBP0m7Ue09vMj1MrzYObf8/MmaqpsFYbvBhWqM9XOXdJW5/UoEZJlAf+te37g
	/8LK8l/yK8ZohXAjfje7SIwrNvHvELqOg2lpORDWsMTJ5FX/oafj040iaHUbPErmGTHA9z
	7RoTPDSe4e75PgnUxrrS9fYCg==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id d49059f5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 28 May 2026 08:37:45 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 May 2026 08:37:45 +0200
Message-Id: <DIU3PJDWJ7ZA.13R289W326RZD@arkamax.eu>
Cc: <linux-scsi@vger.kernel.org>, <jmeneghi@redhat.com>,
 <nilesh.javali@marvell.com>
Subject: Re: [PATCH] scsi: qedf: use GFP_ATOMIC to prevent vmalloc
 allocation panic
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Nimal Prabudoss I" <nprabudo@redhat.com>,
 <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
X-Mailer: aerc 0.21.0
References: <20260528062750.20148-1-nprabudo@redhat.com>
In-Reply-To: <20260528062750.20148-1-nprabudo@redhat.com>

On Thu May 28, 2026 at 8:27 AM CEST, Nimal Prabudoss I wrote:
> The qedf driver encounters an exc_invalid_op crash in get_vm_area_node
> when running under intensive I/O stress with IOMMU enabled.
>
> Link: https://issues.redhat.com/browse/RHEL-75146

This is not accessible without a Jira account.
I'd suggest to drop the link and expand the commit message to explain
why it crashed.

Maurizio

> Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>
> ---
>  drivers/scsi/qedf/qedf_io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
> index a120f0e37a64..6883aaf683bd 100644
> --- a/drivers/scsi/qedf/qedf_io.c
> +++ b/drivers/scsi/qedf/qedf_io.c
> @@ -2059,7 +2059,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
>  		mp_req->req_len =3D io_req->data_xfer_len;
> =20
>  	mp_req->req_buf =3D dma_alloc_coherent(&qedf->pdev->dev, QEDF_PAGE_SIZE=
,
> -	    &mp_req->req_buf_dma, GFP_KERNEL);
> +	    &mp_req->req_buf_dma, GFP_ATOMIC);
>  	if (!mp_req->req_buf) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP req buffer\n");
>  		qedf_free_mp_resc(io_req);
> @@ -2067,7 +2067,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
>  	}
> =20
>  	mp_req->resp_buf =3D dma_alloc_coherent(&qedf->pdev->dev,
> -	    QEDF_PAGE_SIZE, &mp_req->resp_buf_dma, GFP_KERNEL);
> +	    QEDF_PAGE_SIZE, &mp_req->resp_buf_dma, GFP_ATOMIC);
>  	if (!mp_req->resp_buf) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc TM resp "
>  			  "buffer\n");
> @@ -2078,7 +2078,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
>  	/* Allocate and map mp_req_bd and mp_resp_bd */
>  	sz =3D sizeof(struct scsi_sge);
>  	mp_req->mp_req_bd =3D dma_alloc_coherent(&qedf->pdev->dev, sz,
> -	    &mp_req->mp_req_bd_dma, GFP_KERNEL);
> +	    &mp_req->mp_req_bd_dma, GFP_ATOMIC);
>  	if (!mp_req->mp_req_bd) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP req bd\n");
>  		qedf_free_mp_resc(io_req);
> @@ -2086,7 +2086,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
>  	}
> =20
>  	mp_req->mp_resp_bd =3D dma_alloc_coherent(&qedf->pdev->dev, sz,
> -	    &mp_req->mp_resp_bd_dma, GFP_KERNEL);
> +	    &mp_req->mp_resp_bd_dma, GFP_ATOMIC);
>  	if (!mp_req->mp_resp_bd) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP resp bd\n");
>  		qedf_free_mp_resc(io_req);

