Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D3B2F5A0E
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 00:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850429; cv=none; b=g0/aH/RsEmOvBeVtYAruwx+wz49eJeONWSY3+oMI43UVe58wxAhLWqu3SjBLsvPuO7x7kLRfJyLhDrIg/w48qYV3lFwcnWf1YU6zJsb888rP3lCY+KujwdUBJfdQ0tYz4Dmr42JG5yrV85suS+9HaIbU1deL+YWQ/VFv0tbCQ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850429; c=relaxed/simple;
	bh=krL46FadYQfLwVi/hQDiJVC4MtqCABU5oIF+0gengWI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QdyU4DrkMfgq4Hu6o/R3Tx3R7ZhvI2k07AYWP8MQuSFf62uhcllssekK89fJ5MhaqNrgmWzvKdnByPRuj54bgPuaZtHHphfh61r+DZoOFTAP3KTZkSj6Wuw0dVW37NZLEnDBJgBx9v/jegUf7SruYps11CX5NKZONuvwtY568vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvu/TzyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvu/TzyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817601F0089B;
	Tue, 13 Oct 2026 00:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850427;
	bh=KPtwqBuD7BfRPAXUXrCfuOF6SRUmExIgdJQFEghQJUc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nvu/TzyDw6vq8jDI4mb1dCgE3+C22eBQs3rARGA1rVPL/mMTp2Qckzm2QEGnmP8KV
	 SVL/75gsepypKDu/9iALbEvy16t9C3fJTIw1ygaSSc1OJbJc2/Wcwlx7kNwrkkKxPO
	 tiZOMff3xg5bc0062H2c/P//my2yqFMjOTfNWBcSgq7wSmssFm5Yb015eJSSAt/OaD
	 kTglwu5cb8gqgCbaT8NTfForXgka5SlItoTNF8scHzU0329oPhSSIr2DKpgLNZ/47Q
	 kbFivUvncmoN8iHVa7BC4gA1OlU9zjEKjkTRbi2jdim1heVAt4D2ykypXwQ7D8yAmg
	 Wx5C1Xi7+/Stw==
Message-ID: <sashiko-outbox-168785@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 7/8] lpfc: Update correct ndlp refcnt when rejecting
 an unsolicited PLOGI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013001648.62289-8-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
 <20261013001648.62289-8-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 00:13:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] lpfc: Data race and list corruption in lpfc_findnode_did() due to =
lock mismatch
- [High] scsi: lpfc: NVMe remote port leak in PLOGI confirm swap
- [Medium] scsi: lpfc: memory leak of alloc_ndlp on PLOGI with existing non=
-NPR node
--

commit 65d29181555761c7bca4d5992df4a57bb2bdb0d1
Author: Nigel Kirkland <nkirkland2304@gmail.com>

    lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
   =20
    The domain controller FC_ID can change whenever a fabric switch with
    an ISL link is replaced or the admin reconfigures the fabric switch
    with active links. In such situations, reference count updates should
    be applied to the correct nodelist structure.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 5691af515b432..0e5038feec9a7 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c

[ ... ]

> @@ -10457,6 +10458,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, stru=
ct lpfc_sli_ring *pring,
>  		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
>  {
>  	struct lpfc_nodelist *ndlp;

[Severity: High]
This problem wasn't introduced by this patch, but can this lead to a data r=
ace
and list corruption when finding the remote node in lpfc_findnode_did()?

lpfc_findnode_did() protects the traversal of vport->fc_nodes using
shost->host_lock:

drivers/scsi/lpfc/lpfc_hbadisc.c:lpfc_findnode_did() {
	spin_lock_irqsave(&shost->host_lock, iflags);
	ndlp =3D __lpfc_findnode_did(vport, did);
	spin_unlock_irqrestore(&shost->host_lock, iflags);
}

However, the list is modified in lpfc_enqueue_node() and lpfc_dequeue_node()
using vport->fc_nodes_list_lock instead:

drivers/scsi/lpfc/lpfc_hbadisc.c:lpfc_enqueue_node() {
	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
	list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
}

Since callers of lpfc_enqueue_node() and lpfc_dequeue_node() do not hold
shost->host_lock, modifying the list concurrently with lpfc_findnode_did()
can corrupt list pointers and trigger a kernel panic during external ELS
command processing.

> +	struct lpfc_nodelist *alloc_ndlp =3D NULL;
>  	struct ls_rjt stat;
>  	u32 *payload, payload_len;
>  	u32 cmd =3D 0, did =3D 0, newnode, status =3D 0;

[ ... ]

> @@ -10555,7 +10557,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, stru=
ct lpfc_sli_ring *pring,
>  			did, vport->port_state, ndlp->nlp_flag);
> =20
>  		phba->fc_stat.elsRcvPLOGI++;
> +		alloc_ndlp =3D ndlp;
>  		ndlp =3D lpfc_plogi_confirm_nport(phba, payload, ndlp);

[Severity: High]
Does calling lpfc_plogi_confirm_nport() here leak the NVMe remote port trac=
king
structure?

When an unsolicited PLOGI arrives from an existing NVMe target or initiator,
the driver creates a new ndlp with a zeroed WWPN, so memcmp against zero
evaluates to true. In lpfc_plogi_confirm_nport(), it finds the existing
new_ndlp and swaps their nrport fields, storing the original in keep_nrport:

	keep_nrport =3D new_ndlp->nrport;
	new_ndlp->nrport =3D ndlp->nrport;

	/* Move this back to NPR state */
	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) =3D=3D 0) {
		/* The ndlp doesn't have a portname yet... */

In this branch, keep_nrport is bypassed. It is never restored to new_ndlp or
ndlp, nor is it freed, permanently leaking the pointer and leaving the NVMe
transport with orphaned state that can hang recovery or shutdown.

> +
>  		if (phba->sli_rev =3D=3D LPFC_SLI_REV4 &&
>  		    test_bit(FC_PT2PT, &phba->pport->fc_flag)) {
>  			vport->fc_prevDID =3D vport->fc_myDID;

[ ... ]

> @@ -10871,13 +10875,28 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, st=
ruct lpfc_sli_ring *pring,
>  		stat.un.b.lsRjtRsnCodeExp =3D rjt_exp;
>  		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, elsiocb, ndlp,
>  				    NULL);
> -		/* Remove the reference from above for new nodes. */
> -		if (newnode)
> -			lpfc_disc_state_machine(vport, ndlp, NULL,
> -					NLP_EVT_DEVICE_RM);
> +
> +		/* Remove the safety reference from routine start. */
> +		if (newnode) {
> +			/* alloc_ndlp is assigned for an unsolicited PLOGI from
> +			 * the ndlp allocated by this routine. The routine
> +			 * lpfc_plogi_confirm_nport may have swapped the initial
> +			 * ndlp to an existing ndlp. In that case, alloc_ndlp
> +			 * is the pre-swap ndlp that needs a DEVICE_RM because
> +			 * it is the newnode. For all other paths to lsrjt
> +			 * (non-PLOGI ELS) that were rejected by the early
> +			 * port_state check, alloc_ndlp is NULL and ndlp is
> +			 * still the originally allocated node.
> +			 */
> +			lpfc_disc_state_machine(vport,
> +						alloc_ndlp ? alloc_ndlp : ndlp,
> +						NULL, NLP_EVT_DEVICE_RM);
> +		}
>  	}
> =20
> -	/* Release the reference on this elsiocb, not the ndlp. */
> +	/* This elsiocb is not the IOCB issued for a response. Remove
> +	 * the safety reference allocated earlier.
> +	 */
>  	lpfc_nlp_put(elsiocb->ndlp);
>  	elsiocb->ndlp =3D NULL;

[Severity: Medium]
Does this bypass the node drop and leak alloc_ndlp when the existing node is
not in NLP_STE_NPR_NODE?

When lpfc_plogi_confirm_nport() finds an existing node, alloc_ndlp takes the
pre-swap state of the existing node (e.g., NLP_STE_MAPPED_NODE). The inline
cleanup check at the end of lpfc_plogi_confirm_nport() evaluates to false
because the state is no longer NPR_NODE, bypassing the NLP_EVT_DEVICE_RM
event.

On the success path (rjt_err =3D=3D 0), the routine exits after dropping th=
e safety
reference here, leaving the un-dropped initial reference of alloc_ndlp leak=
ed,
accumulating as a garbage node on the vport->fc_nodes list. Furthermore, on
the reject path, this patch calls NLP_EVT_DEVICE_RM on alloc_ndlp, but since
its state is no longer NPR_NODE, the event maps to lpfc_disc_illegal (a no-=
op)
and the node still leaks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013001648.6228=
9-1-nkirkland2304@gmail.com?part=3D7
