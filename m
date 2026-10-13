Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4553A1B5
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850373; cv=none; b=ZMIp57lYzphwjMXUM2FdFLIpKMIGkgye2puJF1z2IhdxNhzbZ+njzTDJq5TrAbXI3z9NNlQVYyHjP7a/EFhSimdKr0KE4pdEdU80o1uOgOYu3GneR2Pm2vt3UqlNU1yEVN1wrd3c8SZVgieres0f8TOoC8ckQZFjD5FiGCAkiUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850373; c=relaxed/simple;
	bh=1hhv5ZE+RcEMCfoaHGmTzg4mj2aAdO+Aht+1BlJVxbw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=maWbXktCVyLM2fsxRh58bsIm5nYx/AcH7hfqnhzTAfqo+fyY86d/UFJBh1C/71mn2GH8aUg8bY2Zx/RMFbjiLbLKTM6+rIf4DiZ0mbtAUNG7BhfhdEKpF67/yWbYodk7p2EWAp68VnDz2lUrCMR53bG86RFfJS2JEqXm+pGAqrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oM2//pDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oM2//pDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2821F0089B;
	Tue, 13 Oct 2026 00:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850372;
	bh=Qj/A+ri7k93NGDx3M4j+WgLhB0JANbdF0YCpHJ2y+fA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oM2//pDumC+/JVBSCBuaZTMovwsTyuneust5CTqZsVRRzFse08pVoyfDO7FwgMZqF
	 bml/Jlc5VHK/bOZyz3uuAZDKmOIVtKkHl+82LEkM4AnUb3cn2QKJ9PSTQenx2ZILhT
	 HijvkO7MWVQAVF9fcQbOv85gXlukanP7XRz3Jc1L9HIrZkVoRXnF12HxtESqPhtPil
	 ZHKAQMhVKR1gx7ekMptycAfcY4Q8n/Kv3QTxgZNzBpRx8c1N0vM23IOWBh9brChJxU
	 NBm7It6LfF2LhU3wzrfy9DdhfDmFFr4bxUeLp0TsDLPliB7HHw/RPDKPf1II1bSOQO
	 hZlSffCf//Oog==
Message-ID: <sashiko-outbox-168784@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/8] lpfc: Rework I/O flush ordering when unloading
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013001648.62289-6-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
 <20261013001648.62289-6-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 00:12:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] lpfc: lockless mutation of txcmplq in lpfc_els_abort causes list c=
orruption
- [High] lpfc: Use-After-Free of lpfc_queue in destroy_workqueue during unl=
oad
- [High] scsi: lpfc: memory leak / infinite wait for IOCBs on txcmplq durin=
g unload
--

commit c519125dd5fca5410ebb69899d1a9f5ce0a92a82
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Rework I/O flush ordering when unloading driver

This commit modifies the handling of failed aborts during driver unload
to avoid concurrent threads acting on the same IOCB. It also delays
freeing the IOCB list until after the HBA is unset and flushes the
workqueue during PCI removal.

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
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

[Severity: High]
Could flushing the workqueue here lead to a use-after-free later during
unload?

If lpfc_sli4_hba_unset() issues hardware aborts, completions can still
trigger interrupts that queue new work to phba->wq. Later in the same unset
function, lpfc_sli4_queue_destroy() frees the lpfc_queue structures (which
contain the work_structs) without explicitly canceling the enqueued works.

When lpfc_unset_driver_resource_phase2() eventually calls
destroy_workqueue(phba->wq), it drains the queue and executes those newly
enqueued items on the freed lpfc_queue memory.

> +	lpfc_sli4_hba_unset(phba);
>  	lpfc_unset_driver_resource_phase2(phba);
>  	lpfc_sli4_driver_resource_unset(phba);

[ ... ]
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
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

[Severity: High]
Does modifying the IOCB list here happen without the required locks?

The target iocb was found by traversing pring->txcmplq, but the lock
(phba->hbalock) was dropped immediately before this block. Calling
list_del_init(&iocb->list) alters the txcmplq list locklessly, which could
race with concurrent completion handlers or other abort routines traversing
the same list, resulting in list corruption.

[Severity: High]
Also, by intentionally bypassing cancellation for IOCB_ABORTING and leaving
the IOCB on txcmplq, is there a risk of leaking these IOCB structures?

Later in the unload path, lpfc_free_iocb_list() only frees items currently
on the free list (phba->lpfc_iocb_list). Any IOCB stranded on txcmplq would
not be returned to the free list and could be permanently leaked.
Additionally, if NVMe is enabled, could this cause functions like
lpfc_nvme_wait_for_io_drain() to loop infinitely while waiting for txcmplq
to be fully empty?

>  			list_add_tail(&iocb->list, &drv_cmpl_list);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013001648.6228=
9-1-nkirkland2304@gmail.com?part=3D5
