Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73C357CE8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990969; cv=none; b=KUOBM1YWxj4rXRwNYsIjLyL60uLgAmKl/VD+f5siPoEzyA1oYMy1Sn8bIz8uNNdweRjB4UhJDen3uumd/t6pPjHp0RxCp2BjcqHxCtMxfEGJeszxs5PCUFlO4yZMJdZ32/+glIPyCSZNrpMm32XsZVn+5hS77CiHqoupqMd0zBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990969; c=relaxed/simple;
	bh=JQLjrBYMjXH37YclXHcQEDp1IFwYFMD4lGEvfEalZ0M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u0YH9ZDQw7qhk7jN7bdn0Hd90mnyNCMjR8YPXWZwX/mYUWFawfgu7Sr1SD3/9IryIIYZ/fD8WgLBI/uYCvcCCD90NMJQYW/N+XIi8etQgCOBVWGdD1mmhwBpW5iyhrXcu8XOQQZJzQ/RpvPhT1UbZTZROgockv1PCWhFqMJxc70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ny/CcEfm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ny/CcEfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD61F000E9;
	Tue, 14 Jul 2026 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990966;
	bh=woEPeGUgdS3vdmiyUpO66qY3NpGBYVY7lN6dn9j0AbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ny/CcEfmie/YQPbq1TTBYrSaNeJxiCm9lgq/5YnrxTnLTZSc75/+IMjJ0Tk5ZSqOL
	 ksL9qWhrRkm5JORi+sXUSGZOGJg20N53PlffBG8bFpmSClDIskdV5psrUSEO5rSxCU
	 hdxcBm2DFXnLkXf3bw3sYCdmu0UQve+5eFygnVDIbd2CoVFy14rxLYM5i9Talidxah
	 fGvIAEM9J1LcjMk5H5QlXhjxCFi7dE7p9/WHjnl/F2XvO8AayQM0865TrpUqw2EmwW
	 2duZO814ZNgsCkVV2bhGTczCUu8wyY0ZqTg1gMsnDhYXG+eM9opbzglvLBLbtRrnzq
	 stotFq/GYb57g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/14] lpfc: Update ELS ACC logging for diagnostic
 troubleshooting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-13-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-13-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 01:02:46 +0000
Message-Id: <20260714010246.B8DD61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Reordering lpfc_els_rsp_acc() introduces a Use-After-Free window f=
or the RSCN payload buffer.

Pre-existing issues:
- [Critical] Integer overflow in `lpfc_els_rsp_rpl_acc` leads to a massive =
heap buffer overflow.
--

--- Patch [12]: [PATCH v3 12/14] lpfc: Update ELS ACC logging for diagnosti=
c troubleshooting ---
commit 8be36e657b7a29a5634f38457734d0cc4e29c5eb
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Update ELS ACC logging for diagnostic troubleshooting

This commit adds debug log messages to ELS ACC routines in the lpfc driver
to indicate when ACC frame transmission fails. It also updates the routines
to return distinct error codes for different transmission issues and updates
the corresponding function comment headers.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 73552ce4bc64b..0a7e69dcb2dbe 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c

[ ... ]

> @@ -6039,6 +6049,17 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_=
t flag,
>  			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
>  			 ndlp->nlp_rpi, vport->fc_flag, kref_read(&ndlp->kref));
>  	return 0;
> +
> +err_out:
> +	if (oldiocb->cmd_dmabuf && oldiocb->cmd_dmabuf->virt)
> +		old_opcode =3D *(uint32_t *)oldiocb->cmd_dmabuf->virt;
> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "1027 Xmit ELS ACC Unsuccessful: "
> +			 "cmd: x%x, error_code: %d "
> +			 "S_ID: x%x\n", old_opcode, err,
> +			 vport->fc_myDID);
> +	return err;
>  }

[ ... ]

> @@ -8473,14 +8554,14 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struc=
t lpfc_iocbq *cmdiocb,
>  	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] =3D pcmd;
>  	/* Indicate we are done walking fc_rscn_id_list on this vport */
>  	vport->fc_rscn_flush =3D 0;
> +	/* Send back ACC */
> +	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);

[Severity: High]
Does this reordering introduce a race condition with concurrent freeing?

By moving lpfc_els_rsp_acc() here, it now executes after vport->fc_rscn_flu=
sh
is set to 0, but before cmdiocb->cmd_dmabuf is set to NULL.

If a concurrent thread observes fc_rscn_flush =3D=3D 0, it can process the =
list
and free the buffer.

If lpfc_els_rsp_acc() subsequently fails, the newly added err_out path shown
above would dereference the freed oldiocb->cmd_dmabuf->virt, potentially
causing a use-after-free.

Should cmdiocb->cmd_dmabuf be set to NULL before calling lpfc_els_rsp_acc(),
or should the flush flag be cleared after?

>  	/*
>  	 * If we zero, cmdiocb->cmd_dmabuf, the calling routine will
>  	 * not try to free it.
>  	 */
>  	cmdiocb->cmd_dmabuf =3D NULL;
>  	lpfc_set_disctmo(vport);
> -	/* Send back ACC */
> -	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
>  	/* send RECOVERY event for ALL nodes that match RSCN payload */
>  	lpfc_rscn_recovery_check(vport);
>  	return lpfc_els_handle_rscn(vport);

[ ... ]

> @@ -9280,7 +9361,9 @@ lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_no=
de_rrq *rrq)
>   *
>   * Return code
>   *   0 - Successfully issued ACC RPL ELS command
> - *   1 - Failed to issue ACC RPL ELS command
> + *   -ENOMEM - IOCB not prepped successfully
> + *   -EIO - The IOCB failed to issue successfully
> + *   -ENODEV - No associated node for IOCB
>   **/
>  static int
>  lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,

[Severity: Critical]
This is a pre-existing issue, but I noticed a potential integer overflow
leading to a massive heap buffer overflow in this function.

The cmdsize parameter is a uint16_t. When called from lpfc_els_rcv_rpl(),
cmdsize is calculated using an unvalidated maxsize from the remote request:

lpfc_els_rcv_rpl() {
    ...
    cmdsize =3D sizeof(uint32_t) + maxsize * sizeof(uint32_t);
    ...
    lpfc_els_rsp_rpl_acc(vport, cmdsize, cmdiocb, ndlp);
}

If an attacker sends an RPL request with maxsize =3D 16383, cmdsize evaluat=
es
to 65536, which truncates to 0 in the uint16_t argument.

Later in lpfc_els_rsp_rpl_acc(), the following memcpy is executed:

    memcpy(pcmd, &rpl_rsp, cmdsize - sizeof(uint32_t));

Since cmdsize is 0, the subtraction underflows, resulting in an enormous
copy size. Could maxsize be validated in lpfc_els_rcv_rpl() to prevent this?

> @@ -9294,12 +9377,15 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, ui=
nt16_t cmdsize,
>  	struct lpfc_iocbq *elsiocb;
>  	uint8_t *pcmd;
>  	u32 ulp_context;
> +	int err;
> =20
>  	elsiocb =3D lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
>  				     ndlp->nlp_DID, ELS_CMD_ACC);
> =20
> -	if (!elsiocb)
> -		return 1;
> +	if (!elsiocb) {
> +		err =3D -ENOMEM;
> +		goto err_out;
> +	}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D12
