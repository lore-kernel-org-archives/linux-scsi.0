Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3719012C534
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783991107; cv=none; b=h0qMb9D6xOk7x9082sQzooH4ZFL2T7B+WsekFK3yhaOZYNcenJl8Q2HIQkPZeNlYEIS+wZmT+9wsI68fLLbhp704Px+bHCbsELDG2ayGfghS+HMLbGdUnvQvfL81ju3aRZJKxqFvXmh/wDzynmcXv+Z1RgNeSTpcTE+cPDXuSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783991107; c=relaxed/simple;
	bh=TxAvt2U/a++yBNfj7+KhkpF/uClaRBFU7YPBSN8cmjM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MHpd0//ezAencxVLaQO1huXHa1U8gJ+GL2xi6MCqVq9mIDiZBkPK7XWCnuioMcClIgFM3ACyNpDySYDSO7ECvDQk3dv+ec+Sy7ZRcM9jAjXAhv4WQmdUPjAz0ndLZ8zQzOe6XkYSUn3D9m/F4NgHRhjtMQlqK8S7arN+qMQY1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPbRCCJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPbRCCJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD51E1F00A3A;
	Tue, 14 Jul 2026 01:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783991105;
	bh=5SY78+aLE8IqwGamDlIqdA7NmKVJxb8OUGnEnSoL7jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VPbRCCJbedRQ9Y0t2Pxj6S9uK0gt6UqSc2aa4EZKbKFBDvEExjHcCnZGbAp4EUaDk
	 drT0x202bkGLaoon4fCji6XEU5EJ/dcJtdmAtPsUN1RFFUDpT2wyoj9uAAh4eWp9n7
	 7gMDLD6nVvIdiGnXmhgIwaHClePAug1CWAxYeM5Q4ngzKzhAzqB6AhlhY7hUwT4kEY
	 Y5eBdhqumSySoSnkdS6KNadQnFrbxr0EGy7KfvmvofK4fa63R6NWEJ7CNvSV5kxfqx
	 kI7bP8zrU819TACx4eLTcm0KwXsKwfrEhekFpxl6GXg/gJoDHn2oVuhSFg23dzkj59
	 YXLQAF6HXvztg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/14] lpfc: Send inhibited ABORT_WQE when PLOGI CQE
 SEQUENCE_TMO is received
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-10-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-10-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 01:05:05 +0000
Message-Id: <20260714010505.AD51E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Issuing an unconditional abort on an already-completed ELS command=
 introduces a tag-reuse race condition that can inadvertently abort a newly=
 allocated command.

Pre-existing issues:
- [High] Deadlock in `lpfc_sli_abort_iocb_ring` due to non-recursive double=
 acquisition of `pring->ring_lock`.
- [High] Data race and list corruption from unlocked iteration of `pring->t=
xcmplq` in `lpfc_sli_host_down`.
--

--- Patch [9]: [PATCH v3 09/14] lpfc: Send inhibited ABORT_WQE when PLOGI C=
QE SEQUENCE_TMO is received ---
commit faea8f503d6a5b239d2ea58d59fefef913f41aeb
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received

This commit updates the driver to send an inhibited ABORT_WQE when a PLOGI
CQE SEQUENCE_TIMEOUT is received. This allows the aborted CQE to return
immediately instead of waiting for a BA_ACC.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 16b10377a0953..11c36968a2bed 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -4893,7 +4897,38 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_=
iocbq *cmdiocb,
>  				/* Reset the Link */
>  				link_reset =3D 1;
>  				break;
> +			} else if (cmd =3D=3D ELS_CMD_PLOGI) {
> +
> +				/* if invalid ndlp, do not retry */
> +				if (unlikely(!ndlp)) {
> +					retry =3D 0;
> +					break;
> +				}
> +
> +				lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +						 "0159 PLOGI Sequence TMO for "
> +						 "ndlp x%px x%lx x%x x%x x%x "
> +						 "x%x x%x %u x%x\n",
> +						 ndlp, ndlp->nlp_flag,
> +						 ndlp->nlp_DID, ndlp->nlp_type,
> +						 ndlp->nlp_fc4_type,
> +						 ndlp->nlp_rpi, ndlp->nlp_state,
> +						 kref_read(&ndlp->kref),
> +						 ndlp->fc4_xpt_flags);
> +
> +				/* Abort all outstanding ELS and auto-ABTS.  If
> +				 * no response for E_D_TOV, then it is unlikely
> +				 * auto-ABTS would receive a response too.  So,
> +				 * inhibit the abort for faster XRI release.
> +				 * However, still proceed with delayed retry.
> +				 */
> +				pring =3D lpfc_phba_elsring(phba);
> +				spin_lock_irqsave(&phba->hbalock, iflags);
> +				lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb,
> +							   true, NULL);

[Severity: High]
Could this unconditional abort introduce a tag reuse race condition?

When a PLOGI command fails with a sequence timeout, this new logic issues
an asynchronous abort and then returns 1 to retry.

Because lpfc_els_retry() returns 1, the caller lpfc_cmpl_els_plogi()
immediately jumps to out_freeiocb and calls lpfc_els_free_iocb(), freeing
the command.

The command is returned to the free list since the exchange busy flag is
only set on the response, not the command itself. Its tag then becomes
available for reallocation. Since the abort is processed asynchronously by
the HBA, could the firmware erroneously abort a newly allocated ELS command
if the tag is reused quickly?

> +				spin_unlock_irqrestore(&phba->hbalock, iflags);
>  			}
> +
>  			retry =3D 1;
>  			delay =3D 100;
>  			break;
[ ... ]
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 54bc5d8984fc2..0a300efc92401 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4608,7 +4608,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, str=
uct lpfc_sli_ring *pring)
>  	} else {
>  		/* Issue ABTS for everything on the txcmplq */
>  		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
> -			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
> +			lpfc_sli_issue_abort_iotag(phba, pring, iocb, false,
> +						   NULL);

[Severity: High]
This is a pre-existing issue, but does this lead to a deadlock on the ring
lock?

In lpfc_sli_abort_iocb_ring(), the ring lock is acquired before this loop:

spin_lock_irq(plock);
list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)

Inside the loop, lpfc_sli_issue_abort_iotag() is called, which then
evaluates the ring and unconditionally acquires the exact same lock for
SLI-4:

spin_lock_irqsave(&pring->ring_lock, iflags);

Since these spinlocks are not recursive, won't this cause an immediate
deadlock?

>  	}
>  	spin_unlock_irq(plock);
> =20
[ ... ]
> @@ -11998,7 +11999,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
>  				if (iocb->vport !=3D vport)
>  					continue;
>  				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
> -							   NULL);
> +							   false, NULL);

[Severity: High]
This is a pre-existing issue, but does this unlocked traversal of the
completion queue invite data races or list corruption?

In lpfc_sli_host_down(), the code explicitly drops the ring lock for SLI-4
just before this loop:

spin_unlock(&pring->ring_lock);
list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
    ...
}

However, the completion queue is actively modified by concurrent completion
handlers like lpfc_sli_sp_handle_rspiocb() which rely on the ring lock for
synchronization. Is it safe to iterate this list while it could be
modified concurrently?

>  			}
>  			pring->flag =3D prev_pring_flag;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D9
