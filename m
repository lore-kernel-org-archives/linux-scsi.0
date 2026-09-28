Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B891547046
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618990; cv=none; b=LlwsUYU1umw6WzYGGEAF5SuU0hKfvMB3YNMCGWDim/mp0huItsrQe8myNCjDs5tNX4ktyE6e0WfYojtG5sf8ws0w+O0037qrv/e7J8v5ZBaKgNYiZ6/kl7gvfNc3aFmV73/7IKX27ZoqK5Dtm+UDj7K0F9loBhzFbOuiVh1jmzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618990; c=relaxed/simple;
	bh=zhIAecKDcgs2eKAbAaO7xkqSqfUIDZQzU/0V5E77pqA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HhaI8htQXfzSUurSlPDKvg54n1gVIpPFDqfeI7R468X+2nDQNCrWa60qd9jEiOdibsMXSZxH5tuBUivyeaxAbZ3JO6aauPU0XWaesuy2PXLsdVVNYJaL3OSM4+/nSgUe0LapyaO9Vod3vy7fEqQYGBdzG0ovQT/SdZj1mE9QS3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QArFWsyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QArFWsyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5301F000FF;
	Mon, 28 Sep 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790618988;
	bh=vw3FnIHj7bam9vrT8lL1Jt1wyimLuH3n02KZVXPd0zw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QArFWsyJ9X0cE8gmQrYFKGQGXPR3rMzeelK2ZdFlrYhFIH9P662tOT48p8CSOxYI+
	 7ja4eOp26d7Om91RwzHfP+OOLhygp9BvrAERfXh8I4fDxKRdG6pOuM2/RDCjatzkJ7
	 jKlAFPrNLkGGktKGs27CXTMSb2TKFcwaBnxb6okiniCWkWYSoTGLKMeDyf6yGows17
	 zXRXoOKYNypjAk4umLAa+PnQrA5G9cg55PxLWcPRE5P+QN/4Ab9I67xY2DwFa1PBtL
	 4GGgunsh+OjSUl6kVr+5LLBjLZrM1kav4jukaAs//kGABNLC/FUKApLzBO93DAu8hk
	 FT2PHbNBXDczg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/10] lpfc: Fix ndlp use-after-free during repeated
 RSCN and rediscovery sequence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928181757.21959-7-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
 <20260928181757.21959-7-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 18:09:48 +0000
Message-Id: <20260928180948.CA5301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] lpfc: UAF and rport leak in lpfc_register_remote_port() due to rac=
e with devloss
- [High] lpfc: Duplicate NVMe transport registrations in lpfc_nlp_reg_node(=
) due to missing synchronization
--

commit 01b3084183c4a09b5084e2e3651c384b815d645a
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence

The commit refactors transport registration flags to separate SCSI and
NVME states, preventing premature release of node objects during transport
callbacks. It also introduces symmetric reference-count tracking for NVMET
target nodes.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c

[ ... ]

> @@ -4481,26 +4481,36 @@ lpfc_register_remote_port(struct lpfc_vport *vpor=
t, struct lpfc_nodelist *ndlp)
>  	struct lpfc_hba  *phba =3D vport->phba;
>  	unsigned long flags;
> =20
> -	if (vport->cfg_enable_fc4_type =3D=3D LPFC_ENABLE_NVME)
> +	/* Don't add the remote port if unloading. */
> +	if (test_bit(FC_UNLOADING, &vport->load_flag))
>  		return;
> =20
> +	spin_lock_irqsave(&ndlp->lock, flags);
> +	if ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | SCSI_XPT_UNREG_WAIT)) =3D=3D
> +	    SCSI_XPT_REGD) {
> +		/* Prevent racing registrations */
> +		spin_unlock_irqrestore(&ndlp->lock, flags);
> +		return;
> +	}
> +	ndlp->fc4_xpt_flags &=3D ~SCSI_XPT_UNREG_WAIT;
> +	ndlp->fc4_xpt_flags |=3D SCSI_XPT_REGD;
> +	spin_unlock_irqrestore(&ndlp->lock, flags);

[Severity: High]
Could this flag manipulation open a race window with devloss? By setting=20
SCSI_XPT_REGD and dropping ndlp->lock before calling fc_remote_port_add(),=
=20
ndlp->rport still points to the old rport.

If a concurrent dev_loss_work executes lpfc_dev_loss_tmo_callbk() on the
old rport before the new one is assigned, it will observe SCSI_XPT_REGD as
set.=20

If the driver is unloading, lpfc_nlp_put() is called prematurely here,
causing a use-after-free when lpfc_register_remote_port() resumes.
Otherwise, the callback clears SCSI_XPT_REGD, leaving the new rport
permanently unregistered and leaked since subsequent unregister calls will
bypass removal.

>  	/* Remote port has reappeared. Re-register w/ FC transport */
>  	rport_ids.node_name =3D wwn_to_u64(ndlp->nlp_nodename.u.wwn);
>  	rport_ids.port_name =3D wwn_to_u64(ndlp->nlp_portname.u.wwn);

[ ... ]

> @@ -4623,7 +4640,10 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct=
 lpfc_nodelist *ndlp)
>  	lpfc_check_nlp_post_devloss(vport, ndlp);
> =20
>  	spin_lock_irqsave(&ndlp->lock, iflags);
> -	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
> +	if (((ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
> +	     !(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT)) ||
> +	    ((ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
> +	     !(ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))) {
>  		/* Already registered with backend, trigger rescan */
>  		spin_unlock_irqrestore(&ndlp->lock, iflags);

[ ... ]

> -	ndlp->fc4_xpt_flags |=3D NLP_XPT_REGD;
>  	spin_unlock_irqrestore(&ndlp->lock, iflags);

[ ... ]

> -	if (vport->phba->sli_rev >=3D LPFC_SLI_REV4 &&
> -			ndlp->nlp_fc4_type & NLP_FC4_NVME) {
> -		if (vport->phba->nvmet_support =3D=3D 0) {
> -			/* Register this rport with the transport.
> -			 * Only NVME Target Rports are registered with
> -			 * the transport.
> -			 */
> -			if (ndlp->nlp_type & NLP_NVME_TARGET) {
> -				vport->phba->nport_event_cnt++;
> -				lpfc_nvme_register_port(vport, ndlp);
> +	if (vport->phba->nvmet_support =3D=3D 0) {
> +		/* Register this rport with the transport.
> +		 * Only NVME Target Rports are registered with
> +		 * the transport.
> +		 */
> +		if (ndlp->nlp_type & NLP_NVME_TARGET) {
> +			vport->phba->nport_event_cnt++;
> +			lpfc_nvme_register_port(vport, ndlp);

[Severity: High]
Does removing the unified NLP_XPT_REGD flag setting before the unlock
allow duplicate NVMe transport registrations?

By replacing the single check with separate SCSI and NVME flag checks and
dropping ndlp->lock immediately, concurrent executions of lpfc_nlp_reg_node=
()
(for instance, from RSCN spam) can both observe NVME_XPT_REGD as 0 and
proceed to call lpfc_nvme_register_port().

Since lpfc_nvme_register_port() does not internally synchronize and check
NVME_XPT_REGD before calling nvme_fc_register_remoteport(), both threads
will register a new remoteport and increment the ndlp reference count. The
first remoteport will be overwritten in ndlp->nrport, permanently leaking
the transport object and its reference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928181757.2195=
9-1-nkirkland2304@gmail.com?part=3D6
