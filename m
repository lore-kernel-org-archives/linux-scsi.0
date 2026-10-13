Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700A870830
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849929; cv=none; b=n4kJ48Tv4jCvCJoV2mtsWXLX/8qPJmh1Ic0U2u5TSrN0vIYH6lLOzS5ogFfiVrXkeHSRYsnPlrtpNDaWattfG+aVO09mqmYQWMwXrCcZNHPQWt1uaH92/P5glmzBmrwH7FpSMgodIxSJMvYF1aBeu5057R5wU7EIJnkwcYaEX+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849929; c=relaxed/simple;
	bh=XK+nxc52pDLq2hPiw9JSTmuwYv0Jea/6vyXrbW098W4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ieo5cBExAx4z9mbrL2TWtH4T2oloCo+gNvZP6ikVcOV1xVjkQFEqfQ+3vlyV0QVkuM9zE4DgZpyRatzpE5Nw8arNkhv6CKpf59hD6KcCszJRn6Yitx6+kAw9WmKLkdXgEzhrhc/gvsMOylktQmVW2fRhj/pvoGtMWTqxqpPD9aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kkckdpbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kkckdpbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308091F0089B;
	Tue, 13 Oct 2026 00:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791849926;
	bh=G3Y8FmW5OBzUeDJzNGxtiWz6DM56hhTr3R3djpDAdQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KkckdpbhlceummQCVbA0LNlZO11M1uOeaP6phRMI3ZEHQwx6BE9By8SN2u6NteuP5
	 HzzO2CGbdEuv33jjPbBXnGATqU6MPvvTerWbvbdnnySO3eJ2Ri8N9ktwZWS29C4j48
	 CiNXS+IoJPdAdaLPbQKf0J2OExvk1djkg2kGlm0Y0rjwgoyVbSYVpZ5GbwRxsLKMBs
	 Rivs/y0DK8D5jz0i10V1UOkPAvhOWU9DF4iGs6NqazIRewaawiiy73gEXnlqtehyIT
	 7tctahYfHZcFvGkEC9z+VGJS2MGjuhJpCrBOo+jPnC23/xkQun3caqkc7rOWgBWa9t
	 o4fAn64eOs7NQ==
Message-ID: <sashiko-outbox-168769@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/8] lpfc: Early return out of lpfc_els_abort when
 HBA_SETUP flag is not set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013001648.62289-3-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
 <20261013001648.62289-3-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 00:05:25 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: lpfc: lockless HBA_SETUP check leaves TOCTOU Use-After-Free =
race on pring
--

commit b6474390ac6cffa345174f9e11e10a15b8a091a7
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set

This commit adds an early check on the HBA_SETUP flag in lpfc_els_abort()
to avoid using a stale ELS pring pointer during an HBA reset.

> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
> index 9c449055a55e6..2c8d995a45bf8 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_no=
delist *ndlp)
>  	struct lpfc_iocbq *iocb, *next_iocb;
>  	int retval =3D 0;
> =20
> +	/* Exit early to prevent race with queue teardown. */
> +	if (unlikely(phba->sli_rev =3D=3D LPFC_SLI_REV4 &&
> +		     !test_bit(HBA_SETUP, &phba->hba_flag)))
> +		return;
> +

[Severity: High]
Does this lockless check leave a time-of-check to time-of-use race window
that can still result in a use-after-free on the pring pointer?

If a dev_loss_tmo callback executing lpfc_els_abort() is running
concurrently with an HBA reset, could this sequence occur:

CPU1 (dev_loss_tmo)
lpfc_els_abort()
  test_bit(HBA_SETUP, &phba->hba_flag) // returns true
  pring =3D lpfc_phba_elsring(phba);

CPU2 (HBA reset)
lpfc_sli_brdrestart_s4()
  clear_bit(HBA_SETUP, &phba->hba_flag);
  lpfc_sli4_queue_unset(phba);
    lpfc_wq_destroy(wq);
      kfree(wq->pring);

CPU1
  spin_lock_irq(&phba->hbalock);
  spin_lock(&pring->ring_lock); // use-after-free on stale pring pointer

Should the check and the subsequent usage of pring be synchronized against
the queue teardown path?

>  	pring =3D lpfc_phba_elsring(phba);
> =20
>  	/* In case of error recovery path, we might have a NULL pring here */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013001648.6228=
9-1-nkirkland2304@gmail.com?part=3D2
