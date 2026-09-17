Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7955456E0B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683175; cv=none; b=Yr2T3gjTpesv/vS8PCQgUxd7ZaqgasDIMmbX14sFbVekeGH6/tFp+UPb2Liw7fzcHNh3KNnVUwzXudUd9KVgnHx/FFeSIUzy6bUDbsyqeioe008XtqjtHbUu7AktE4roMyrXxSaYH8/4IHW2hJVvoQHjydtCAbnsOs/YK74Fo6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683175; c=relaxed/simple;
	bh=rchfa/LYpRmRvrcdlX0sEA8mlNUZfU5ddypiNEjn6OY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=osrIjmLwPEZtuQ0v7j70F/GwJ272yWLaviDijQJvflxKxWy+qCi3Ssk4rzPIlIYD2Ix8Xy2kYTWbUGKLGal2OVYGN2fonSGAIElKOyJIDjeUrJ2mpNjoUbGYuPPZrl2dVDcfm8Rp65Q6g66L7+HDC80Oi47fAQsx73ZaD1j/O9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHidVZkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHidVZkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2C41F000FF;
	Thu, 17 Sep 2026 22:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683174;
	bh=VB7WowP8g8OJ7BZADVg8lli/65RVJVxxdbtjZE/BvEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GHidVZkNXHO6X/985O9HSJsWZkBO39EpABPUyVodhppQNU/3eYXnE27ucXvdJKlir
	 zAnhjPWJV19swteeBzO8b/B2CXc+lvp1z7NesJRA9/utOU0J64PeO1GodVKiZ7Sf/E
	 wc7iINvcDlDLZbVzxUG46ed31hHHnrx8G1kzXtbaAe5ztSzAuP8jRmTz8rTO2CULqi
	 aPmomA9U8dcF/EHLrDwcbNMr2H4YU2rKtvfVQO7avGDN1YauuPLYXCjtH9xEUPGWKU
	 qFy2gn95GWbKhcmMiD6NXd9XbduZEAs/v+T5Bmjfz1DmpjfnrfKlZSQBia+s7Fxviw
	 vbX0dKfld5+bA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/14] lpfc: Improve PLOGI retry handling for large
 SAN configurations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-9-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-9-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:12:53 +0000
Message-Id: <20260917221254.2B2C41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] lpfc: Deferred PLOGIs are erroneously rejected in lpfc_nlp_logo_un=
reg due to state check
- [Medium] lpfc: TOCTOU race in NLP_PLOGI_SND flag tracking allows multiple=
 PLOGIs in flight
--

commit 3d16993b649c134340e20dec0bd637799a114aff
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Improve PLOGI retry handling for large SAN configurations

In large SAN configurations with link perturbations, rediscovery of target
ports is problematic due to PLOGI retry race conditions. This patch improves
target rediscovery by ensuring PLOGI retries are serialized in unregistrati=
on
and retry handler paths.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index cd431c7bd9f08..3e26654a8286a 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -2329,17 +2331,43 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, ui=
nt32_t did, uint8_t retry)
[ ... ]
> +	if (test_bit(NLP_PLOGI_SND, &ndlp->nlp_flag)) {
> +		lpfc_printf_vlog(vport, KERN_INFO,
> +				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
> +				 "4113 Reject PLOGI issue, PLOGI in-flight "
> +				 "x%px, DID x%x nflag x%lx\n",
> +				 ndlp, ndlp->nlp_DID, ndlp->nlp_flag);
> +		return 1;
> +	}

[Severity: Medium]
Can concurrent worker threads race on this lockless flag check?

If two threads execute lpfc_issue_els_plogi() simultaneously (for example,
from an unregistration completion and a timer), both could evaluate
test_bit(NLP_PLOGI_SND, &ndlp->nlp_flag) as false.

Both threads would then continue executing, allocate their IOCBs, and reach
the set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag) call at the end of the function.
This sequence would issue duplicate PLOGI commands to the same NPort.

> +
> +	if (ndlp->nlp_state > NLP_STE_PLOGI_ISSUE &&
> +	    ndlp->nlp_state <=3D NLP_STE_MAPPED_NODE) {
> +		lpfc_printf_vlog(vport, KERN_INFO,
> +				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
> +				 "4114 Reject PLOGI issue, Node in "
> +				 "unexpected state x%px, DID x%x nflag x%lx "
> +				 "in State x%x\n",
> +				 ndlp, ndlp->nlp_DID,
> +				 ndlp->nlp_flag, ndlp->nlp_state);
> +		return 1;
>  	}

[Severity: High]
Will this strict state check inadvertently drop deferred PLOGIs during LOGO
unregistration?

During target recovery after a LOGO storm or link toggle, the unregistration
handler lpfc_nlp_logo_unreg() uses lpfc_issue_els_logo() to transition the
node state to NLP_STE_LOGO_ISSUE.=20

When the deferred PLOGI is subsequently issued via lpfc_issue_els_plogi(),
this new check (ndlp->nlp_state > NLP_STE_PLOGI_ISSUE &&
ndlp->nlp_state <=3D NLP_STE_MAPPED_NODE) evaluates to true because
NLP_STE_LOGO_ISSUE (0x5) falls between 0x1 and 0x7. This causes the deferred
PLOGI to be erroneously rejected, potentially stalling the target discovery
process.

[ ... ]
> @@ -2410,11 +2438,26 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, ui=
nt32_t did, uint8_t retry)
[ ... ]
>  		lpfc_els_free_iocb(phba, elsiocb);
>  		lpfc_nlp_put(ndlp);
>  		return 1;
>  	}
> =20
> +	set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D8
