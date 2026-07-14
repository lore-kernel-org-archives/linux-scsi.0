Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0D92FB97B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990547; cv=none; b=qNJUui2URrhM6s9LB1waK9hPkQjorDydaikqi/pxiLKX1MekU8HWgas3KJLC+EePP9vg8X2ZuX1+ITGxz0a84GclAtj1qg6Jud6WjqXRNeWAj65uGr6ikRcZP4p7KOXPmP8GKKp683EhTv0jY6QsRuS3DQAwpP9H4RFKebHavlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990547; c=relaxed/simple;
	bh=mP2ycowDfhb9ryQfmvyhwbmp+ZffuMcWbmvguPQnMzA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FdrbZGS6AWwOwHjrPgLoXLpnA2Z7UEcqx1MxH9tLCW01Jblm4eTvuLrf69M6M/MaBq5DYygNwkOfLVu26XxkOa0ob3Z2K1UHhXTrbdtcGRLHpqO9DleJ/cA4Wo6IcB0ewLckz27MLinJz1c2qAhIRGhns3dpbKTQJWj//33t228=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocan7uOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocan7uOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E71F000E9;
	Tue, 14 Jul 2026 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990537;
	bh=Emc8ebDvf+/lktdqTZEUMpk/tMhKnMc365SduB8h4mE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ocan7uOsUZZRPe2K+jSfRKtQEkVif3QftetnM+g2uzyu9hFS2bp0pXFBcAesvhjSG
	 opTPuYLRwuIftx8Uib0vmOm7mwFet/CDFaW+Kh67Vo3+8XE2rKUGLoN9ISXa8BSlhw
	 IJk/CsRGVi+T/LKuAULXNbMtP7mKsJXV62WFy0rCtL1kOQ6YcTG0CABzFzKCbe38cw
	 h8/gbS92RQZ+/hdJWJhc6rz+HlCaByL8xGtzFra4+cFjG48qpCELbmAhZrAxoUKAg3
	 9BVnLHUiTnfsw2gkZJox+BlR312yvU5w+6MKs7xa6qAcMFyjN8AbpWqUsskYIlTeZ7
	 7RQINfaIxbF+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/14] lpfc: Check fc4_xpt_flags before decrementing
 ndlp kref on FDISC error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-5-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-5-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:55:36 +0000
Message-Id: <20260714005537.136E71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing vulnerabilities in `lpfc_cmpl_els_flogi` and `lpfc_sl=
i4_seq_abort_rsp` due to missing NVMe checks and non-atomic `NLP_DROPPED` f=
lag operations.
--

--- Patch [4]: [PATCH v3 04/14] lpfc: Check fc4_xpt_flags before decrementi=
ng ndlp kref on FDISC error ---
commit 0f11d01d4dc626992ac78f74f8c706c25c1fb010
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error

This patch modifies FDISC error handling to ensure we check whether a node
has been registered with a transport layer before decrementing the initial
kref count. If previously registered, it delegates the kref drop to the
transport's respective dev_loss_tmo callback to avoid a potential
use-after-free.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 52fc5058976d9..b756de9986ebe 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -11427,11 +11426,22 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, stru=
ct lpfc_iocbq *cmdiocb,
>  			goto out;
>  		/* Warn FDISC status */
>  		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
> -			      "0126 FDISC cmpl status: x%x/x%x)\n",
> -			      ulp_status, ulp_word4);
> +			      "0126 FDISC cmpl status: (x%x/x%x) ndlp x%px "
> +			      "Data: x%lx x%x x%x x%x x%x x%x x%x x%x x%x\n",
> +			      ulp_status, ulp_word4, ndlp, ndlp->nlp_flag,
> +			      ndlp->nlp_DID, ndlp->nlp_last_elscmd,
> +			      ndlp->nlp_type, ndlp->nlp_rpi, ndlp->nlp_state,
> +			      ndlp->nlp_prev_state, ndlp->fc4_xpt_flags,
> +			      kref_read(&ndlp->kref));
> =20
> -		/* drop initial reference */
> -		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
> +		/* If have not previously registered with transport layer and no
> +		 * LPFC_EVT_DEV_LOSS work pending, then drop initial reference.
> +		 * Otherwise, let the dev_loss_tmo_callbk drop the initial
> +		 * reference.
> +		 */
> +		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
> +		    !test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
> +		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
>  			lpfc_nlp_put(ndlp);

[Severity: High]
This is a pre-existing issue, but since this patch updates the logic here to
use an atomic test_and_set_bit() for the NLP_DROPPED flag and checks for bo=
th
SCSI and NVMe transport registrations, it highlights similar vulnerable code
blocks elsewhere.

For instance, in the same file, lpfc_cmpl_els_flogi() uses a non-atomic
check and set:

drivers/scsi/lpfc/lpfc_els.c:lpfc_cmpl_els_flogi() {
    ...
	if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
	    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
		set_bit(NLP_DROPPED, &ndlp->nlp_flag);
		lpfc_nlp_put(ndlp);
	}
    ...
}

Can concurrent threads (like a link flap triggering lpfc_dev_loss_tmo_callb=
k)
evaluate test_bit(NLP_DROPPED, ...) as false and concurrently double-put the
ndlp kref here?

Also, does this FLOGI path miss the NVME_XPT_REGD check entirely, potential=
ly
allowing premature kref drops for NVMe-only registrations?

A similar non-atomic pattern appears in sequence abort handling:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli4_seq_abort_rsp() {
    ...
	if (ndlp->nlp_state =3D=3D NLP_STE_UNUSED_NODE &&
	    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
	    !(ndlp->fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD))) {
		set_bit(NLP_DROPPED, &ndlp->nlp_flag);
		lpfc_nlp_put(ndlp);
	}
    ...
}

Would it be worth updating these other paths to use the atomic
test_and_set_bit() and the unified transport checks as you did in this patc=
h?

> =20
>  		goto fdisc_failed;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D4
