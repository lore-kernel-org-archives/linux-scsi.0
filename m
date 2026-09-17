Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C712A49F123
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683343; cv=none; b=mK9qG/4F8viY9etX+F2YGG6vnLZHSl3g0Fq0Id3Ey3S+MxRP/wfJ369D+RnAy3cKztzaVGJ7wJVTFaGC6jnJcaBHG4ldJ45+F+UOvH/FTwvKa/SVeEdeIP8IQx+59mLAj9DRCoFsG4UcxbhNAJRK+LsOCJxxPlYzr6wgO3Ytlho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683343; c=relaxed/simple;
	bh=Qu1ANGjzKlf8v4fsEtyO2bvQusrvjHWJS+cWe9ndtgo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=huHlAOFgn9OuZEAFUmJ7rSGdJoL7SVkjEuIYEL0Z6vbxQBMC4aaSkIzuxfw5ba4Z5xG6rw7KR0zdQqf52sPDPEfzID8i5GplWsM77keHmfIUrEhjlPUTTD0yaYRWr1yyiWjtcYM0S1Qx7b++aIaNfhx0vEQZtRioGSygaMsWpjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSz513i6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSz513i6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247251F000FF;
	Thu, 17 Sep 2026 22:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683341;
	bh=vioQrKO3tMdHggWfdrXdUXIqPwGdVJn5lma+EBpF2CA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BSz513i6ZVTrQA/80yg+OtTULo8PNTojPDVsJW/YbcyyFEKbzunPDwxjLgglYLzE8
	 76fY+PAtXAd2e1/j6R0Hjy1tFxR2/gFlALrwPFdxle0A4BXpCEwMwX8WLTq4hzUZ9t
	 6AxQPgQ+vhGxGOEH6AfrkWLat+LdOcP2HqgW/ZMgm6htjlceu2rLqIr5nmPthKDuU7
	 W9jpiOQmryZ0OHmRzEQHfbWqOcMjbhyraT28mx9FjBlErxuLAoS6K2KYPTRkU+KvkH
	 lFERPY5ZImsy8SVi3nOBWhscEnqo9nHw6yicVXv22XkUMohVrXmz4YAgsFykd4Smx2
	 XHB+rWDLmj3sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/14] lpfc: Send inhibited ABORT_WQE when PLOGI CQE
 SEQUENCE_TMO is received
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-10-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-10-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:15:40 +0000
Message-Id: <20260917221541.247251F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: txcmplq list corruption in lpfc_sli_abort_iocb_ring()
- [High] scsi: lpfc: unintended abort of reused XRI/IoTag in lpfc_els_retry=
()
--

commit d8f6ae5839dc18257873d48c2e2262ffa79b7bec
Author: Nigel Kirkland <nkirkland2304@gmail.com>
Subject: lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is rece=
ived

This commit modifies the LPFC driver to explicitly set the Inhibit Abort (I=
A)
bit when sending an ABORT_WQE for a timed-out PLOGI CQE. It introduces a
boolean argument to lpfc_sli_issue_abort_iotag to control this behavior.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -4921,7 +4925,38 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_=
iocbq *cmdiocb,
>  				/* Reset the Link */
>  				link_reset =3D 1;
>  				break;
> +			} else if (cmd =3D=3D ELS_CMD_PLOGI) {
[ ... ]
> +				pring =3D lpfc_phba_elsring(phba);
> +				spin_lock_irqsave(&phba->hbalock, iflags);
> +				lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb,
> +							   true, NULL);
> +				spin_unlock_irqrestore(&phba->hbalock, iflags);

[Severity: High]
Could this inadvertently abort an unrelated command?

Because lpfc_els_retry() schedules a retry, the completion handler
lpfc_cmpl_els_plogi() will immediately free cmdiocb locally, returning the
XRI/IoTag to the free pool.

Since the abort is issued here without validating if the hardware actually
kept the exchange busy (LPFC_EXCHANGE_BUSY) or checking if this is SLI-4
hardware, another CPU could concurrently allocate the freed tag, issue a new
command, and have it erroneously aborted.

>  			}
> +
>  			retry =3D 1;
>  			delay =3D 100;
>  			break;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
[ ... ]
> @@ -4620,12 +4621,19 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, s=
truct lpfc_sli_ring *pring)
>  			iocb->cmd_flag &=3D ~LPFC_IO_ON_TXCMPLQ;
>  		list_splice_init(&pring->txcmplq, &tx_completions);
>  		pring->txcmplq_cnt =3D 0;
> +		spin_unlock_irqrestore(plock, iflag);
>  	} else {
> +		/* lpfc_sli_issue_abort_iotag expects the hba_lock held, but not
> +		 * the ring_lock.
> +		 */
> +		spin_unlock_irqrestore(plock, iflag);
> +		spin_lock_irqsave(&phba->hbalock, iflag);
>  		/* Issue ABTS for everything on the txcmplq */
>  		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
> -			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
> +			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
> +						   NULL);
> +		spin_unlock_irqrestore(&phba->hbalock, iflag);

[Severity: High]
Does this code risk list corruption on the txcmplq list?

In lpfc_sli_abort_iocb_ring(), plock (which aliases ring_lock for SLI-4
hardware) is dropped, leaving txcmplq unprotected against concurrent remova=
ls
by completion handlers.

While list_for_each_entry_safe() protects against the current element being
removed, it is not thread-safe if a concurrent interrupt handler removes
next_iocb.

Could this lead to poisoned or corrupted list pointers during host reset or
link down events?

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D9
