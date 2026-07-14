Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3430429BDBB
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990412; cv=none; b=qQexXeIxACmPcOHYpsjpCJ06KE1TdzoRYsllQN0OUACc+TTbMq4uMSm9/p/Ja2IuuN9Buzg4N4igM9RHrBQa1sEytcDRuepcTrnbojPjncNrtH4/+i6fTkEqM2jZ+r0N5MYdBGJr6d7yWk5Icox0QqZUTvKfoqn6Zf3ajWDGPEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990412; c=relaxed/simple;
	bh=SSoZaQWs8cekrgfNL4ze4oEcKmggCjwclb7UecsDssY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=krdja2cOKOdCT2hi18IIddflXCRoAZZF+65iz0PHyivaVw+Q4bc4Rmv3yQu1W8K+BGFUExkrKNHLwRx6i9yClRN2e9FYLbsKQXM8yNAsZq8r81bOXRPUN2T641pW11v/sAa6OAyyYRFP6ZkX4QwfpOWlUW3yPAaJRUDq+/DLBjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFYfEu93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFYfEu93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE1D1F000E9;
	Tue, 14 Jul 2026 00:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990403;
	bh=iOQjdkxl3ayUv8Z28dAFso2E+Wh0l6MFhqHNhuPV1WU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AFYfEu939E9Wltm7tXuwFQNWFexN/qbvB4xcEL/aX2W8WAjIDdbSQMxCdP7pk36Hh
	 EWpuzgIPYrDerjFLJ+nGRf3qeOVcpKxyYXscGScMZEm5HiAakMfy4x7qeo6lM2liVY
	 u8fmNprBDDrC2XLg6AJ1lCwTfJ8mVMaU29Yn72WBO881qJx8j0t98360Lr4kYq9xav
	 x3Wm8X6RrXcPdHJMc7dekLyPMM7Ej+Fu01Cq2fmKpQPlEc+Vp7YWSM+Tb2VqOcjIyS
	 Eomn+rgSaNNw3UuxP7I3xGX9UjCDSQ1CvgFGg9NRf4MaH1Yc90GpmCgU58D8oYqXFs
	 OlqRj2xotaIgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/14] lpfc: Early return out of lpfc_els_abort when
 HBA_SETUP flag is not set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-3-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-3-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:53:21 +0000
Message-Id: <20260714005322.DCE1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The lockless check of the `HBA_SETUP` flag introduced to prevent a=
 use-after-free is insufficient and suffers from a TOCTOU race, leaving the=
 UAF vulnerability unmitigated.
- [High] The iocb list entry is removed from the shared `txcmplq` without h=
olding the required lock on an error path, leading to list corruption.
--

--- Patch [2]: [PATCH v3 02/14] lpfc: Early return out of lpfc_els_abort wh=
en HBA_SETUP flag is not set ---
commit 686b3cec858238b11486ee8f0c3a182653eb8d41
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
   =20
It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer.  To prevent such a condition, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

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
This is a pre-existing issue, but does this lockless check of HBA_SETUP
still leave a time-of-check to time-of-use race window open?

A concurrent HBA reset thread can clear HBA_SETUP and destroy the work
queues:

lpfc_wq_destroy()
    kfree(wq->pring);
    wq->pring =3D NULL;

If this happens immediately after the lockless check in lpfc_els_abort()
but before the pointer is used, could we still fetch a pointer that is
about to be freed, and subsequently dereference it later when acquiring
pring->ring_lock?

>  	pring =3D lpfc_phba_elsring(phba);
> =20
>  	/* In case of error recovery path, we might have a NULL pring here */

[Severity: High]
This is a pre-existing issue, but does the error path later in
lpfc_els_abort() remove the iocb from the shared txcmplq without holding
the required locks?

	spin_unlock_irq(&phba->hbalock);

	if (test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
	    retval && retval !=3D IOCB_ABORTING) {
		list_del_init(&iocb->list);

Since elements are iterated on pring->txcmplq using their list node and
added to a local abort_list using their dlist node, the iocb->list is
still linked into txcmplq.

Could modifying iocb->list here without pring->ring_lock or hbalock lead
to list corruption if the shared list is concurrently accessed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D2
