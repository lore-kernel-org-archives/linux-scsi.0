Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5C14A8FEC
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683752; cv=none; b=QJCA0dxU4gDc1Ffwi/jXjM6n5KFAwej7NYGMI3toZ7bPj1mHAyqSBo8Be0ppjmimodY6AOMNx362Vwi5kwMEtnBq9DmjLgSSm5hJf6EWPQot1JkWt2rEPiw7cq0+OY/cZ2aVprA5ai0EvXOHUYWQR9iOO6dGmPC4qbYENoDpl3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683752; c=relaxed/simple;
	bh=s6piugh/xWMJyEDtNcqMFGqC3xFaWNIBnZlr1CZeJ/4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e7HGENAqBi5hI2HZHGp+GMU0n1dh0UlUppyZbhg5Q3kuCZhQHUG30fSrIC3SCvnXLdgEajHVP7sWRzOPGMG6q2Cq3ov0OpR0rkdK1ZujtfN+OLZyKRW16XhrsX7Y932WlTq34Fm2I6uPVq1EC5j3vwfovUXokzLfymb7hgMaD1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQrnbWoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQrnbWoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292DB1F000FF;
	Thu, 17 Sep 2026 22:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683751;
	bh=BvIooYl46fkLp3UAfTe3rrCZhYGya8lyzHNJhojjrH4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JQrnbWoWJ3ZKcxaGJxmxL+t6bvgT+ci6mtF2rwptYQiE0GmjloGYxbptXtIEpxqCX
	 2ocnoF+8ZKf2zGd5S1pAOq9G4c8u9/zG6YMrFWL1dthXPF3ue/AUIf9GKV36S83Jtt
	 BDqSBJvYaT0eX+zbDjdI3DJqCSLKJt00sy4AX8k1DD6MhVgOB781b5PdUF4jBfhxJo
	 m/VWaPqKkBkF3TwkulCbvb41AB8DAEPnhNSA/0kNdeLKJ+RqhFPXdd1w/6sOxImJlw
	 WgZKc1QaZl74cU5TVn8VjdrhMrCfqvqawWLOb74rykCYr/64jmL4JMp9m9nRZ1ksUw
	 AkA570cesRZ6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/14] lpfc: Update ELS ACC logging for diagnostic
 troubleshooting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-13-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-13-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:22:30 +0000
Message-Id: <20260917222231.292DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: lpfc: UAF in lpfc_els_rsp_acc() error path due to concurrent=
 RSCN flush
--

commit 47dddef465d8869f241a192661f8107a7fb86c19
Author: Nigel Kirkland <nkirkland2304@gmail.com>

    lpfc: Update ELS ACC logging for diagnostic troubleshooting
   =20
    Currently, there are ELS ACC routines that lack debug log messages to
    indicate when ACC frame transmission run into issues.  The generic
    lpfc_els_rsp_acc and more specific ACC routines are updated to log when
    there is an issue with transmitting the frame.  The routines are also
    updated to return different return codes when encountering various
    transmission issues and their function comment header is updated.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index bf71b5a3e55e5..cb06dbc9edfab 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -6055,6 +6065,17 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_=
t flag,
>  			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
>  			 ndlp->nlp_rpi, vport->fc_flag, kref_read(&ndlp->kref));
>  	return 0;
> +
> +err_out:
> +	if (oldiocb->cmd_dmabuf && oldiocb->cmd_dmabuf->virt)
> +		old_opcode =3D *(uint32_t *)oldiocb->cmd_dmabuf->virt;

[Severity: High]
Can this dereference a freed pointer?

In lpfc_els_rcv_rscn(), setting vport->fc_rscn_flush =3D 0 publishes the bu=
ffer
for concurrent processing. If a parallel thread processes and frees this bu=
ffer,
and lpfc_els_rsp_acc() takes this new error path, oldiocb->cmd_dmabuf->virt
would point to freed memory.

> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "1027 Xmit ELS ACC Unsuccessful: "
> +			 "cmd: x%x, error_code: %d "
> +			 "S_ID: x%x\n", old_opcode, err,
> +			 vport->fc_myDID);
> +	return err;
>  }
[ ... ]
> @@ -8489,14 +8570,14 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struc=
t lpfc_iocbq *cmdiocb,
>  	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] =3D pcmd;
>  	/* Indicate we are done walking fc_rscn_id_list on this vport */
>  	vport->fc_rscn_flush =3D 0;
> +	/* Send back ACC */
> +	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);

[Severity: High]
Does moving this lpfc_els_rsp_acc() call introduce a use-after-free risk?

By calling lpfc_els_rsp_acc() here, cmdiocb->cmd_dmabuf has been published =
by
clearing vport->fc_rscn_flush, but is not yet set to NULL. A concurrent thr=
ead
could free cmdiocb->cmd_dmabuf before the error path in lpfc_els_rsp_acc()
attempts to read from it.

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

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D12
