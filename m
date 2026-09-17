Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB952519907
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657092; cv=none; b=CH+LW9n1qTURF2GVHzkLAiJUca/o0WaIb2GVeDD5c0LAfsx+jq7IuR68CUONsFpBWhaNfYlp5SIzCueoT6kv/iTVfoZqBuJ6gWnOylQDrNn1fGLv0przs8CZ7qpy8y6CmYV68sQU0cq+77YpJyzjjsijrctCNwoWdsLb9SevDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657092; c=relaxed/simple;
	bh=ztAYbIH5B4FJ74lIklLLjZJCQGlZyfpBY1Zi6ZXPlBw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LWhcYOXsNxYhy0QAtq+gFWNPq2xj/OtmysW8Ho1Ra7rcztZAdd+u5zx2uBZqRzVRpd24WIbmm2ucrqxV9usrO5ML87yl876ak22xEVX/rMtn9IJ9itzasXr/RC7WC2Lf/WGLzr8k03p/70fcJnJFHmY2al935UO2SpDS7Ky1k8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYrxq6qS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYrxq6qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9B71F000FF;
	Thu, 17 Sep 2026 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789657077;
	bh=2d/hpsQTPmJxwLM/nXADipbpcliCsV4PFQbuH3xlMqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YYrxq6qS7g56NFhV/euXsTLZSYK5wB5UDxUf/lx7Ly2rkY6Cc8epmWNqQnDmMeR50
	 iKG9A1l8IRLPmvnbsDoaNDj1pMPEYC3rksMTmaIxOUjMk6qXoybt9PAUVpx4sc/iz8
	 bnukKTrjwbh+zoi3c/j7nl0akJKk1avaKKRvJtizrzvSVcb+tHv3Z+PAxv73on9jgf
	 0x6TDlt9HRC8vyzI7+6gX6OB0aJu4LOMiiu6EC+inppGLB2a/kDV0WoZeXC9yP/3k6
	 7ICutRmJM6ks6DFsDLOhY+CKEE9LK61oDNudrsCIo8sA64ibGoGRug8eODyhfMifUu
	 +tRW0EUCA1r7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix ndlp reference leak in
 lpfc_nlp_reg_node()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917144543.2157614-1-vulab@iscas.ac.cn>
References: <20260917144543.2157614-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 14:57:56 +0000
Message-Id: <20260917145757.6B9B71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: missing NVME_XPT_REGD clear in NVMET unregister causes=
 leak
- [Medium] scsi: lpfc: TOCTOU race in lpfc_nlp_reg_node() leaks reference
--

commit 8a787af86823c5598e09493f24aaa14226c3f5da
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: lpfc: Fix ndlp reference leak in lpfc_nlp_reg_node()

This commit attempts to fix a node reference leak for NVMET nodes by
setting the NVME_XPT_REGD flag when the reference is taken in
lpfc_nlp_reg_node(). This aims to ensure that lpfc_nlp_unreg_node()
balances the reference count during teardown.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index 4c673dffa671b..f61026e3b48ea 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4664,9 +4664,15 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct=
 lpfc_nodelist *ndlp)
>  			}
>  		} else {
>  			/* Just take an NDLP ref count since the
> -			 * target does not register rports.
> +			 * target does not register rports. Mark it as
> +			 * an NVME transport ref so that
> +			 * lpfc_nlp_unreg_node() releases it.
>  			 */
>  			lpfc_nlp_get(ndlp);
> +
> +			spin_lock_irqsave(&ndlp->lock, iflags);
> +			ndlp->fc4_xpt_flags |=3D NVME_XPT_REGD;
> +			spin_unlock_irqrestore(&ndlp->lock, iflags);

[Severity: Medium]
Does acquiring the lock here to set NVME_XPT_REGD introduce a time-of-check
to time-of-use race that can leak the reference?

Earlier in lpfc_nlp_reg_node(), NLP_XPT_REGD is set and ndlp->lock is
dropped to call lpfc_register_remote_port().

If a concurrent lpfc_nlp_unreg_node() call sees NLP_XPT_REGD set, it clears
it, and then locklessly evaluates NVME_XPT_REGD as 0, skipping the
lpfc_nlp_put().

When lpfc_nlp_reg_node() resumes, it increments the refcount and sets
NVME_XPT_REGD. Because NLP_XPT_REGD was already cleared, subsequent
unregisters will return early, permanently leaking this reference.

[Severity: High]
Does setting NVME_XPT_REGD for NVMET nodes here strand the node during
unregistration?

While lpfc_nlp_unreg_node() drops the reference for NVMET nodes, it fails
to clear the NVME_XPT_REGD flag:

lpfc_nlp_unreg_node() {
    ...
    /* NVMET has no upcall. */
    lpfc_nlp_put(ndlp);
    // missing: ndlp->fc4_xpt_flags &=3D ~NVME_XPT_REGD;
    ...
}

Leaving this flag set permanently prevents the driver from evaluating this
to true in lpfc_dev_loss_tmo_handler():

    if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
        lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);

This strands the node, blocking device removal and potentially deadlocking
vport teardown.

Additionally, if the node is rediscovered as FCP-only, the sticky flag
triggers an unmatched lpfc_nlp_put(), causing an underflow and
use-after-free.

>  		}
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917144543.2157=
614-1-vulab@iscas.ac.cn?part=3D1
