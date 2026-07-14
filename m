Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C432135B8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990805; cv=none; b=UAXWjnCRSAZh17gxxyeNFeocDteXFNfiN3X1F08VCi4/nqOcCm2iprlwzG6auwBIct5Ic/1T6FreI3MTqDgNjDzcopiqyA1ebR3WyUAt4ZPcHKkAUgTv3cmJFStANhDY/t+3Nu4yX/CWJMrYTBiz9PMAioXs96IE1bPG9hcxpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990805; c=relaxed/simple;
	bh=i3ehS07Vmov9k4Xj0fef7uWm8IDtUw3CRmZgX7NAXUA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TcKWkeu180MnPj3OyA3MDAavWuTd4cT8gejG/cCQGBPaUk4cXJ75iXo4CkRVPM6Bg/GJnk0yL+sbQsVuVue2doa6tDjHYpIjzNmp8kSENm8UXPqYQIlbrEgQyJ5WtGHAIfr1jgR4ztShjAA7BJkPd9BkrMhx93Gbi5AHZ22mY4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJ78NKAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJ78NKAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED0B1F000E9;
	Tue, 14 Jul 2026 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990802;
	bh=8u5ICu4AZnSxdiaqWlvAXxcEzvQ0RiRonisJw0Ei+dM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iJ78NKAjdq6AEesvawdCAsbT6sHFqqUza1bsft3xN9940fA0asCBB7yjJL2A8ndjj
	 PtTV6yKDbdSkAAScM5Ab3fzalFJ12qiAobnH5giZAIVZc6Dnr0sQl8LLUXpicpkCPw
	 /TC7Js8yaB0OTXXNRzC4JhAp7+klTxDJEc+xbIvHPXgiFrEu6TmOZaoTfc+Od7ULYX
	 P1BUel8iG8gJYvKqH3FNwJa0ESFOgB3pmPXfGg8GR5ir41mW7INjcXIv3yN10b2T5E
	 uTIdnt7s9FGeaLPT6RBgbTH1wwdJEjnzhILEvbYeLHH2Cp2CzMSE+4GJzoMDEpRk8M
	 jcZ7EqNXTF7sw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/14] lpfc: Rework I/O flush ordering when unloading
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-8-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-8-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 01:00:01 +0000
Message-Id: <20260714010002.5ED0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unsafe lockless modification of `txcmplq` via `list_del_init(&iocb=
->list)` leads to list corruption.
- [High] Use-After-Free on `lpfc_queue` structures caused by failing to dis=
able hardware interrupts before destroying the queues.
--

--- Patch [7]: [PATCH v3 07/14] lpfc: Rework I/O flush ordering when unload=
ing driver ---
commit c00c06170572ea9d93301e5572a551c25be7b877
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Rework I/O flush ordering when unloading driver

This patch captures the IOCB_ABORTING return value in lpfc_els_abort to
prevent adding it to the list of iocbs for cancelling, allowing it to
complete naturally. It also reorders lpfc_free_iocb_list and adds a call
to flush_workqueue in lpfc_pci_remove_one_s4 to flush I/O before freeing.

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 23355f12fbffa..8682f5a445d29 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
[ ... ]
> @@ -14948,11 +14951,20 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
> =20
>  	/* Perform scsi free before driver resource_unset since scsi
>  	 * buffers are released to their corresponding pools here.
> +	 * lpfc_sli4_hba_unset() issues aborts via lpfc_sli_hba_iocb_abort(),
> +	 * which allocates abort IOCBs from phba->lpfc_iocb_list; the pool
> +	 * must still exist, so lpfc_free_iocb_list() runs only after unset.
>  	 */
>  	lpfc_io_free(phba);
> -	lpfc_free_iocb_list(phba);
> -	lpfc_sli4_hba_unset(phba);
> =20
> +	/* Flush the PHBA WQ - there could be a race with ELS IOs while lpfc
> +	 * is unloading.  This stops a race between completions, aborts and
> +	 * resource recovery.
> +	 */
> +	if (phba->wq)
> +		flush_workqueue(phba->wq);
> +
> +	lpfc_sli4_hba_unset(phba);

[Severity: High]
This is a pre-existing issue, but does flushing the workqueue here before
calling lpfc_sli4_hba_unset() leave a window where new work items could be
queued?

In lpfc_pci_remove_one_s4(), the call to lpfc_sli4_hba_unset() will issue
aborts via lpfc_sli_hba_iocb_abort(). Because interrupts are still enabled =
at
this point, hardware completions from these aborts could trigger interrupts
that add new work items to phba->wq.

Later in lpfc_sli4_hba_unset(), interrupts are disabled and
lpfc_sli4_queue_destroy() frees the queue memory. However, since
lpfc_unset_driver_resource_phase2() eventually calls destroy_workqueue(), it
will drain the workqueue and execute those pending work items on the
already freed queue objects. Could this result in a use-after-free when the
driver is unloaded while IO is in flight?

>  	lpfc_unset_driver_resource_phase2(phba);
>  	lpfc_sli4_driver_resource_unset(phba);
> =20
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
> index 2c8d995a45bf8..f917a5bcfd025 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
[ ... ]
> @@ -271,7 +272,13 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_no=
delist *ndlp)
>  		retval =3D lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
>  		spin_unlock_irq(&phba->hbalock);
> =20
> -		if (retval && test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
> +		/* An abort that fails here is just cancelled when the driver is
> +		 * going offline.  However, if the abort failure is because the
> +		 * IOCB is already getting aborted, don't cancel.  Just let it
> +		 * complete.
> +		 */
> +		if (test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
> +		    retval && retval !=3D IOCB_ABORTING) {
>  			list_del_init(&iocb->list);
>  			list_add_tail(&iocb->list, &drv_cmpl_list);
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to modify iocb->l=
ist
here without holding the ring lock?

In lpfc_els_abort(), the loop operates on abort_list using iocb->dlist. The
original iocb->list nodes remain on the active pring->txcmplq. After releas=
ing
phba->hbalock, if lpfc_sli_issue_abort_iotag() fails while unloading,
list_del_init(&iocb->list) is called on txcmplq without acquiring any locks.

Could concurrent hardware completion handlers, such as
lpfc_sli_process_cmp_ring() traversing txcmplq under ring_lock or hbalock,
encounter corrupted list pointers if this list modification races with them?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D7
