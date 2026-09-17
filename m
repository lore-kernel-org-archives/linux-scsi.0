Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35684A13A6
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683621; cv=none; b=NRg9yJlXxutbqimlDT6Io9JSE6LSTGWffSIfbh0UbH1he13XPyKPiUiCHR1TjOn09O/K53H0LtpOM34QKYxpJKm4MMB3CkQGRiSCuT+SWnVa4nE3E6hDKhGEEK5dgZg49K9Zph2VhHdyZfm2rExb5/I20hVqnlTq4vewFxxFzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683621; c=relaxed/simple;
	bh=2jq3hg8f2M0W7coBca7pp9wK5rxxgSbldWUYRu2Gw+s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=auPu/Xwb2V6i3DdxHXsHdDRUezbnn7NcJXosNs0KjeX1yJmFeCak21LFV5KgMZmKIBNPHfUOR3VYaBX9kc8NOJXU341emzVpV4osoy0mWqZsh+J9pK761yfv/RDecyTRERb/hoJgwSujC1S+2+2JgoEWrvKNSS8Dq5eS6EkKaOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSOaivVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSOaivVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E22A1F000FF;
	Thu, 17 Sep 2026 22:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683619;
	bh=iSy39TUuxy6/V7yLOUoS9i7Cdc0+mj82+g7err70Pwg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nSOaivVA9DqusKXOT1FUIfNHtN05SS7Swuu8XpOCtPdiuWAqs7O5Wu3IrF8pjBROb
	 FFZdwsLWnop5kOFrOeIjLjyq/67P5LNkkmTyogBJeQdCtqfcv7T3we32+T8zC2/86B
	 96L+gxnxt2xdWSEgulzeruhzLc64g2QxpAex1AkXriCih2bW/czIC5qvdUQXXz7s9j
	 Pap9VeIIpoud36ZiUBOpTbBBSa7D+0aqlq8zKYaxub3a6b63UdXcMybrgJhFyJdPyD
	 ICAAFPYaY6s9G/MIsWU3EJMM4mCVAGaHpl53PudjYTjvzqNSYcY+E37Yr13ZdE+96f
	 oGE70nxsT9iWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/14] lpfc: Put iocbq on phba->txq when ELS WQ is
 full or ELS SGL unavailable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-12-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-12-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:20:18 +0000
Message-Id: <20260917222019.4E22A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: lpfc: txq list churning in lpfc_drain_txq due to missing S=
LI_IOCB_RET_IOCB flag
--

commit 8b96ef178c664b569b564d0486b1112a8fe88e10
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailable

This commit adds logic to queue ELS/CT commands to the head or tail of the
txq for retry when the ELS WQ is full or SGLs are unavailable. It updates
lpfc_drain_txq to handle these retry scenarios.

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
[ ... ]
> @@ -10819,12 +10866,19 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba,=
 uint32_t ring_number,
>  			if (!sglq) {
>  				if (!(flag & SLI_IOCB_RET_IOCB)) {
>  					__lpfc_sli_ringtx_put(phba,
>  							pring,
> -							piocb);
> +							piocb, false);
>  					return IOCB_SUCCESS;
>  				} else {
>  					return IOCB_BUSY;
>  				}

[Severity: Medium]
If lpfc_drain_txq() passes 0 for the flag, won't it trigger this block?

When SLI_IOCB_RET_IOCB is omitted, this path places the IOCB at the tail of
the txq and returns IOCB_SUCCESS. This defeats the newly added back-off
mechanism in lpfc_drain_txq() which relies on receiving an IOCB_BUSY status
to execute its retry logic and push the failing IOCB to the head.

[ ... ]
> @@ -21301,12 +21355,15 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>  		}
>  		txq_cnt--;
> =20
> +		/* Capture the return values that indicate an error during IO
> +		 * submit and cannot be retried. Prefix message 2822.
> +		 */
>  		ret =3D __lpfc_sli_issue_iocb(phba, pring->ringno, piocbq, 0);

[Severity: Medium]
Does this missing flag cause txq list churning during resource exhaustion?

Because the flag is passed as 0 here (instead of SLI_IOCB_RET_IOCB), the
underlying __lpfc_sli_issue_iocb() call will not return IOCB_BUSY when SGL
resources are exhausted. Since IOCB_SUCCESS is returned instead, the loop
below won't break early and will continuously pop and push items back to the
tail of the txq.

> -
> -		if (ret && ret !=3D IOCB_BUSY) {
> +		if (ret && ret !=3D IOCB_BUSY && ret !=3D IOCB_FAILED_PUT) {
>  			fail_msg =3D " - Cannot send IO ";
>  			piocbq->cmd_flag &=3D ~LPFC_DRIVER_ABORTED;
>  		}
> +
>  		if (fail_msg) {
>  			piocbq->cmd_flag |=3D LPFC_DRIVER_ABORTED;
>  			/* Failed means we can't issue and need to cancel */
> @@ -21319,9 +21376,35 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>  			list_add_tail(&piocbq->list, &completions);
>  			fail_msg =3D NULL;
>  		}
> -		spin_unlock_irqrestore(&pring->ring_lock, iflags);
> -		if (txq_cnt =3D=3D 0 || ret =3D=3D IOCB_BUSY)
> +
> +		if (txq_cnt =3D=3D 0 || ret =3D=3D IOCB_BUSY ||
> +		    ret =3D=3D IOCB_FAILED_PUT) {
> +			/* IOCB_FAILED_PUT is unique to SLI4 and means SGL/XRI
> +			 * resources are allocated.  For this case, set the
> +			 * in retry flag.  For SLI3 and 4, push the IO to the
> +			 * txq for retry.
> +			 */
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D11
