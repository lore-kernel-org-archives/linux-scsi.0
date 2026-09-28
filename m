Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4A3822A1
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619516; cv=none; b=sJ5xodneQZkDDIMDxsX5TLLOBhEV2vztzQZY2RRoWK7o8GBGB5cCDydeRswyZgH55K7rp04fkhophkVRuQmmPtLoeebgt00E/ZcdHJqUrjtO/RDSLoaQrLiOIII1ZzXmtN9qXRt/gA40dKQU3Fh3MawccZ/ONfQwwCtlAvgf/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619516; c=relaxed/simple;
	bh=vCSwISVKLHa407/dCliejLRYv8DgjdMBQmC3JnnjXrs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rB+22tiYCKur/g8jarCtVwIaavMcu1hIbaHJKXaWi7T28gfOFEADQRoNJ6aXlXt3cl4AVaDVfm9g7PLuj5lwgWXeSe3lqvZxchOtWk5/84Slrr4EPrB7TAJiJZ55P5X//3N2GAn4n4v+bOzBeU1jB+WDkSzW91mR/PEUZY5qkyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePjBpSht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePjBpSht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C01F000FF;
	Mon, 28 Sep 2026 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619515;
	bh=UZY3EFLxbWwmS59gF5DoGmXcrgAZl2IF4kkOFLW8L38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ePjBpShtMSQa605DGt1hFMvjI4I2tbZwYTE7HSkNjrqI91VUyMGR+Hl3MEYANcFZB
	 bzonLPO8GB6xxFNEUnMJkXFZjBpHZNWGhrZHGQ3oPK5xczTeVQueSZlvaJpO3jQWZC
	 ePJIxeDTLZEk0lhHh4Ub+S2hLaewMuDFS48djw8sw3RGun6BYXFSVK70i552rYh3Z1
	 8PNyYZSYieTDrWjQl8HW5sKZ4AjacMyRUJpKDUCSCT/K4H90nYyG3RfYpcS+SEYYcB
	 /KS9Dfkhpe2KTT4g4Qb84TC1o9EoiOTUX2vE9co+rxNOwEBdw3HZgSEtKmH4n4A6WB
	 l+2kpp9jDfZmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/10] lpfc: Rework I/O flush ordering when unloading
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928181757.21959-8-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
 <20260928181757.21959-8-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 18:18:34 +0000
Message-Id: <20260928181834.CD4C01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: lpfc: memory leak of iocbq left on txcmplq during unload
--

commit 0147a0023ef276c5ea7aa246240c55db9bc5ed52
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Rework I/O flush ordering when unloading driver

This commit reworks I/O flush ordering during driver unload by avoiding
cancelling IOCB_ABORTING returns in lpfc_els_abort() and flushing the
PHBA WQ prior to resource unset.

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 6460127bcc7b0..7352cb6e584bf 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13514,6 +13514,9 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
>  	/* Stop the SLI4 device port */
>  	if (phba->pport)
>  		phba->pport->work_port_events =3D 0;
> +
> +	/* All IO completed and queues released. Free the IOCBs. */
> +	lpfc_free_iocb_list(phba);
>  }

[ ... ]

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

[Severity: Medium]
If an ELS abort returns IOCB_ABORTING during driver unload, this explicitly
leaves the IOCB on the ring's txcmplq to complete naturally.

However, does the unload path guarantee this will complete? In lpfc_init.c,
lpfc_sli4_hba_unset() calls lpfc_sli4_xri_exchange_busy_wait() which checks
abts_* lists, but does not wait for txcmplq to empty before calling
lpfc_sli4_disable_intr() to disable interrupts.

When lpfc_sli4_hba_unset() finally calls lpfc_free_iocb_list(), it only fre=
es
the available IOCBs in phba->lpfc_iocb_list:

lpfc_init.c:lpfc_free_iocb_list() {
    ...
    list_for_each_entry_safe(iocbq_entry, iocbq_next,
                             &phba->lpfc_iocb_list, list) {
        list_del(&iocbq_entry->list);
        kfree(iocbq_entry);
    ...
}

Because the pending IOCB is still linked in txcmplq and hasn't been returned
to the free list, does this result in a memory leak of the lpfc_iocbq
structure?

>  			list_del_init(&iocb->list);
>  			list_add_tail(&iocb->list, &drv_cmpl_list);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928181757.2195=
9-1-nkirkland2304@gmail.com?part=3D7
