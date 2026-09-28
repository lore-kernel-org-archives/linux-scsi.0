Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876E137F330
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619273; cv=none; b=gvnt223ebrAPvHQ7MbiLycSW8ExOD+zlKF0WU7FiPUQZzsyRrPTwhKlJVSVvQA8g1Jgy8bjclsXSOi54KGQ5cwUgMGL2h9dVx88OCEUjSWVg2smgMpsbX8fLgfth1LBvZgevrps6S+aE/89/GdnG3PUWLhccASKzKVTJrF2MK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619273; c=relaxed/simple;
	bh=xyxjnkgtnJ1xARz8QlILPs/01YsUWGgb0sB5jTtLV4g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lU5KPFvSKo9tXBZSWnBAWpSq6Q4cCOph0ws2Kyvye8GCF3bKqzviICww4kaF9bCj0cGJNsJHkfZDHjENkPD3Sw54dT0UbRjr8BHtYEkubozARWT+3f1F45LR/w794NgsKKf7JnhO1gogwJLB7kbKhQYMJwnLDGcmCR8OptMQEpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heCX3IgZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heCX3IgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6BC1F000FF;
	Mon, 28 Sep 2026 18:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619272;
	bh=2fwucTU81sdM8sPpfQhYC4FFY0bLOMc04lMMXju3mQI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=heCX3IgZS6ShQoxGhURrXST6szDJI2bQ6ZJwzTmhu5dA0IG1f6DUCf+FEpQ+TVeqR
	 HvuUZP4wPesGI2pwkkQIZfe/T4fz51c+AdE0MlpDnsyeQNzg4sGAFxe3lu1ieroCWu
	 E5f1TxtqY01ITL7JhY330S+loKvk1n9Ewfd6YNpD1YHV7vCOmob8fo29IyRvZKWXqk
	 c5+zTpitsgVT4RJ3TJf+5DtZhuC6jVnYB+XTtrfcUCeR9Xvbin4dIm4Y5jNbxt0G2h
	 bRTsLRVC9igaZsOYhU1O4Jw6km57nDFUUfEXcn21McovfnINumS9dbqkqt+v2YWxzn
	 kqY0nFRSltmfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/10] lpfc: Update correct ndlp refcnt when
 rejecting an unsolicited PLOGI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928181757.21959-10-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
 <20260928181757.21959-10-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 18:14:31 +0000
Message-Id: <20260928181431.EC6BC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: lpfc: memory leak of ndlp nodes on unsolicited PLOGI rejecti=
on
--

commit dd6a700ba9afcbae128094473fe756a0c9d5e1df
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI

This commit updates the reference counting logic when rejecting an
unsolicited PLOGI to account for dynamically changing domain controller
FC_IDs. It modifies the cleanup path in lpfc_els_unsol_buffer to remove
references from an explicitly saved alloc_ndlp instead of ndlp.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 1793d9c6d8b80..0ca1659d5d102 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c

[ ... ]

> @@ -10580,7 +10582,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, stru=
ct lpfc_sli_ring *pring,
>  			did, vport->port_state, ndlp->nlp_flag);
> =20
>  		phba->fc_stat.elsRcvPLOGI++;
> +		alloc_ndlp =3D ndlp;
>  		ndlp =3D lpfc_plogi_confirm_nport(phba, payload, ndlp);
> +
>  		if (phba->sli_rev =3D=3D LPFC_SLI_REV4 &&

[ ... ]

> @@ -10896,13 +10900,28 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, st=
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

[Severity: High]
Does this code leak both struct lpfc_nodelist objects when rejecting an
unsolicited PLOGI from an unrecognized WWPN?

When the PLOGI is received, lpfc_els_unsol_buffer() allocates an initial
node (alloc_ndlp). Then lpfc_plogi_confirm_nport() allocates a new_ndlp:

drivers/scsi/lpfc/lpfc_els.c:lpfc_plogi_confirm_nport() {
	...
	new_ndlp =3D lpfc_nlp_init(vport, ndlp->nlp_DID);
	...
}

It swaps the states, places alloc_ndlp into NLP_STE_UNUSED_NODE, and returns
new_ndlp as ndlp.

If the PLOGI is then rejected (e.g., due to port state), this modified
cleanup path calls NLP_EVT_DEVICE_RM on alloc_ndlp instead of ndlp. This
seems to abandon new_ndlp (which is now assigned to ndlp) without dropping
its reference, causing it to leak.

Additionally, because alloc_ndlp is already in the NLP_STE_UNUSED_NODE state
after the swap, its cleanup handler (lpfc_device_rm_unused_node) might simp=
ly
return NLP_STE_FREED_NODE without dropping the reference, meaning alloc_ndlp
also leaks.

> +		}
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928181757.2195=
9-1-nkirkland2304@gmail.com?part=3D9
