Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F92E62AC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990515; cv=none; b=nI+rq9KbMNnAPn+0sbOoDnQGn3tKSG5IOnD06Xb+Flq+O+diw/XAFUQuuoq3Nq6K9Bc0Hw/fPamKYdQftlbPEs6o6JVEHtw7p6fXNAvFjigvKuUvXQp7IlzV7MRYQhLd1u8SsBgmpaFaXdftJLzrbNKFYOEtwOn4+GSdlGK4GmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990515; c=relaxed/simple;
	bh=copJbjX89akrK1QkokZCIkhC4Si8QbG+RTROPZu/EyI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e26tjImDz/Qq2OAIBSSGonTdfOiUnNiNR9TDNDDXQMAHoAuXvXG+2OnBnFlIwWLZVLRiQVFG8ZeOKVOHVmaDSPFfhNEGk2BXCwPw9f1jPYAv/xF1Qygc4WGoh3QqcetRP5O3Zh/2AVcbQf5xFvOKqQbNmmq2uvxfKzJmk7hmO2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6lxLaak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6lxLaak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B96E1F000E9;
	Tue, 14 Jul 2026 00:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990503;
	bh=MJfT1AD2z4hDUBJ2T7GUXVnTS2+PEHD6LHLxPeL3QqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D6lxLaakDWIPiljp27BviHAJ7F3lhqlJa3H0lOclM2fcDlafkwTsM/Kc/A7HPPLW3
	 H9w5d78bH3jjWmOQ/LVVmlxvjC9cUkZNlV7LV5LtjRIhG/dzcqnwePIEkexyjb0eh5
	 At6YiXy9t6Q7S98j8Ng938NmloLyuonQdIEyalkBuH5ttZ/vX8spDqRAcYiYJhUl5I
	 hSthAeh1I5g0+FkCUQZXwMv+XFRURDvpdxQSjGoAq9Qz7OxgFObTWkjGs/aaJXOGa3
	 Zzb2v62+XezNwWfknWlMqFkhAY+uF6mgfBNjDAuBwxM+EuU09GAgb93mK1GeZbTO4G
	 0ckYXbyoa8oiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/14] lpfc: Improve PLOGI retry handling for large
 SAN configurations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-9-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-9-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:55:02 +0000
Message-Id: <20260714005503.5B96E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Non-atomic test-and-set and post-submission setting of NLP_PLO=
GI_SND causes permanent target block or bypassed serialization.
- [High] New state validation check in `lpfc_issue_els_plogi` silently drop=
s legitimate PLOGIs, stalling discovery.
- [High] TOCTOU race in delayed PLOGI timer and unreg completion permanentl=
y drops deferred PLOGIs.
- [Medium] The `NLP_PLOGI_SND` flag is completely bypassed when a PLOGI IOC=
B is queued for retry upon `IOCB_FAILED_PUT`.
--

--- Patch [8]: [PATCH v3 08/14] lpfc: Improve PLOGI retry handling for larg=
e SAN configurations ---
commit 1ce21a9bd9de0c81a785643032705d301dd6dccb
Author: Justin Tee <justintee8345@gmail.com>
Date:   Tue Jul 14 01:18:06 2026 +0000

lpfc: Improve PLOGI retry handling for large SAN configurations

In large SAN configurations with link perturbations, rediscovery of target
ports is problematic due to PLOGI retry race conditions.

This patch improves target rediscovery by ensuring PLOGI retries are
serialized in unregistration and retry handler paths.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 6720fd5ec5232..16b10377a0953 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -2329,17 +2331,43 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, ui=
nt32_t did, uint8_t retry)
[ ... ]
> +	if (test_bit(NLP_PLOGI_SND, &ndlp->nlp_flag)) {

[Severity: Critical]
Can NLP_PLOGI_SND become permanently stuck?

The flag is tested here, but it is not set until after the I/O is submitted
to the HBA at the end of the function. If the hardware completes the PLOGI
quickly, the completion handler lpfc_cmpl_els_plogi() might run before the
issuing thread sets the bit.

The completion handler would clear the bit, achieving nothing, and then the
issuing thread would execute set_bit(), leaving the flag permanently set.

Could this permanently reject future PLOGIs? Would test_and_set_bit() be
more appropriate here to prevent this regression?

> +		lpfc_printf_vlog(vport, KERN_INFO,
> +				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
> +				 "4113 Reject PLOGI issue, PLOGI in-flight "
> +				 "x%px, DID x%x nflag x%lx\n",
> +				 ndlp, ndlp->nlp_DID, ndlp->nlp_flag);
> +		return 1;
> +	}
> +
> +	if (ndlp->nlp_state > NLP_STE_PLOGI_ISSUE &&
> +	    ndlp->nlp_state <=3D NLP_STE_MAPPED_NODE) {

[Severity: High]
Does this block legitimate PLOGIs during discovery?

For example, lpfc_rcv_plogi_adisc_issue() calls lpfc_issue_els_plogi() while
the node is in NLP_STE_ADISC_ISSUE. The PLOGI would be silently rejected
here, but the caller proceeds to force the state to NLP_STE_PLOGI_ISSUE
anyway.

Could this cause the port state machine to wait forever for a PLOGI
completion that will never arrive?

> +		lpfc_printf_vlog(vport, KERN_INFO,
> +				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
> +				 "4114 Reject PLOGI issue, Node in "
> +				 "unexpected state x%px, DID x%x nflag x%lx "
> +				 "in State x%x\n",
> +				 ndlp, ndlp->nlp_DID,
> +				 ndlp->nlp_flag, ndlp->nlp_state);
> +		return 1;
>  	}
> =20
>  	cmdsize =3D (sizeof(uint32_t) + sizeof(struct serv_parm));
> @@ -2415,6 +2443,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint=
32_t did, uint8_t retry)
[ ... ]
>  		/* Under heavy vpi counts, the driver's host_index can catch up
>  		 * to the hba_index causing a put error. Catch this case and
>  		 * put the IO on phba->txq.
>  		 */
>  		if (ret =3D=3D IOCB_FAILED_PUT && phba->sli_rev =3D=3D LPFC_SLI_REV4) {
>  			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
>  			return 0;
>  		}

[Severity: Medium]
If the IO is queued for retry here and returns early, doesn't it bypass
setting NLP_PLOGI_SND at the bottom of this function?

Since the IO is queued but the flag isn't set, wouldn't concurrent callers
pass the test_bit() check and issue duplicate PLOGIs, bypassing the
intended serialization?

>  		lpfc_els_free_iocb(phba, elsiocb);
>  		lpfc_nlp_put(ndlp);
>  		return 1;
>  	}
> =20
> +	set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
>  	return 0;
>  }
> =20
> @@ -4614,6 +4643,31 @@ lpfc_els_retry_delay_handler(struct lpfc_nodelist =
*ndlp)
[ ... ]
>  	case ELS_CMD_PLOGI:
> +		/* The driver delayed a PLOGI via the nlp_delayfunc, but
> +		 * it's possible the PLOGI is already on a deferred retry.
> +		 * Catch this case and skip this delayed PLOGI. This prevents
> +		 * multiple PLOGIs in flight. The defer code flow cleans
> +		 * up.
> +		 */
> +		if ((test_bit(NLP_IGNR_REG_CMPL, &ndlp->nlp_flag) ||
> +		     test_bit(NLP_UNREG_INP, &ndlp->nlp_flag)) &&

[Severity: High]
Is there a race condition here with the unreg completion interrupt?

In lpfc_els_retry_delay_handler(), nlp_last_elscmd is temporarily cleared
before reaching this point. If this timer thread decides to skip issuing the
PLOGI because NLP_UNREG_INP is set:

CPU1 (lpfc_els_retry_delay_handler)
    cmd =3D ndlp->nlp_last_elscmd;
    ndlp->nlp_last_elscmd =3D 0;
    ...
    if (... test_bit(NLP_UNREG_INP, &ndlp->nlp_flag) ...) {

If CPU2 processes the unreg completion interrupt at this exact moment:

CPU2 (lpfc_sli4_unreg_rpi_cmpl_clr)
    if (!test_bit(NLP_DELAY_TMO, &ndlp->nlp_flag) &&
        ndlp->nlp_last_elscmd =3D=3D ELS_CMD_PLOGI) {

CPU2 will see nlp_last_elscmd as 0 and skip issuing the PLOGI.

Then CPU1 resumes:

CPU1
    ndlp->nlp_last_elscmd =3D ELS_CMD_PLOGI;
    break;

Could this result in both paths skipping the PLOGI, permanently stalling
recovery?

> +		    ndlp->nlp_defer_did !=3D NLP_EVT_NOTHING_PENDING &&
> +		    ((ndlp->nlp_DID & Fabric_DID_MASK) !=3D Fabric_DID_MASK) &&
> +		    !test_bit(FC_OFFLINE_MODE, &vport->fc_flag)) {
> +			/* When UNREG_RPI completes we need to have the
> +			 * nlp_last_elscmd set.
> +			 */
> +			ndlp->nlp_last_elscmd =3D ELS_CMD_PLOGI;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D8
