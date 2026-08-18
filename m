Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05125439F89
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077417; cv=none; b=sL4wPXDBUSVEYXqJBBPvbpEDRVKi4qM742CBQjkRlcaFtJyJp6mFuqJwYS1EMN0q9ZNQmHbOZU2KklsS9S5nHbLyY5xNpcLP/n9wLCsXluwFpXLbbDnbDWUDAKxj7PoKiXn/uOmZl8ecKWyqibLtg6HJk0zRlXSDruSUKbr0MIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077417; c=relaxed/simple;
	bh=BZcbqGK8PhFsAQfF0/BV2xuVlH8r1AQX2dg27nm2zYc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GaXxn/zsnPUdbcvee4YWlwgKI3FWlk7JxSSs/per5D2O6yZQU8yeDGgL+zYuWeJCFDVT/fBC2KcmWBpH0N3Gaw561HfWHOo1Is7f2ItIO7OC6XCcwqkzof0tbXSHX5I6rRBtXe4nriI3ZdWAtkKSASkpWh2ZagpXEcMuK0Uo9T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=my/P0yCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="my/P0yCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBE1F000E9;
	Tue, 18 Aug 2026 18:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077415;
	bh=8mWoTXfE4+yTqL6o5ZxhwBsz9ma22yW2rOI0ZmVaPjQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=my/P0yCJ9MBbsUyFvZFyjp/t3yEttAykrOX/Hnr0VZatgeBiFPyBV4LhtCtOfIyhJ
	 UH1m9GiEiZOb+jLEOmLeeINdzR7xSO42+mCI+wZPsXPup1pvWMD+qsL+x7F2BGCQD6
	 UIWbGMKpTwn83KPfkdhOHCh2geiXRbg3YMHcfq4BU8aCkyWkhe/iCYJ8AHWW6tEYQG
	 9wrDUCtprmgf1cyt2WqQfrDsWR14N6axq60qlBcgV663yIM8hH+pWskuLiumeNc6ja
	 oYCHlIl7SGqCCovc+ALHqhU36I6bBscyr7GXB5d+9Qce+RS9JRnVJh3Mz3gH8uqppO
	 Fgu+bAkaX2jCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/17] mpi3mr: Fix use-after-free of the firmware event
 workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-17-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-17-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:23:35 +0000
Message-Id: <20260818182335.C3EBE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of firmware event (`fwevt`) in `mpi3mr_cleanup_fwev=
t_list` during driver teardown.
--

--- Patch [16]: [PATCH 16/17] mpi3mr: Fix use-after-free of the firmware ev=
ent workqueue ---
commit d1068d82a1a0b06d1a9647481bac5d43ff5f1ebc
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix use-after-free of the firmware event workqueue

This commit fixes a use-after-free issue regarding the firmware event
workqueue in the mpi3mr driver. It ensures the worker thread pointer is
checked while holding the event lock to prevent a race condition with the
workqueue being destroyed.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 510c990d42d1b..4a72b3d89c294 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_=
ioc *mrioc,
>  {
>  	unsigned long flags;
> =20
> -	if (!mrioc->fwevt_worker_thread)
> -		return;
> -
>  	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> +	if (!mrioc->fwevt_worker_thread) {
> +		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> +		return;
> +	}
>  	/* get fwevt reference count while adding it to fwevt_list */
>  	mpi3mr_fwevt_get(fwevt);
>  	INIT_LIST_HEAD(&fwevt->list);

[Severity: High]
This is a pre-existing issue, but while reviewing the firmware event
lifecycle, I noticed another potential use-after-free during driver teardow=
n.

In mpi3mr_dequeue_fwevt(), the list reference is dropped before returning
the pointer:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_dequeue_fwevt() {
    ...
		fwevt =3D list_first_entry(&mrioc->fwevt_list,
		    struct mpi3mr_fwevt, list);
		list_del_init(&fwevt->list);
		/*
		 * Put fwevt reference count after
		 * removing it from fwevt_list
		 */
		mpi3mr_fwevt_put(fwevt);
	}
	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);

	return fwevt;
}

Then in mpi3mr_cleanup_fwevt_list(), we pass this unreferenced pointer to
cancel_work_sync():

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
    ...
	while ((fwevt =3D mpi3mr_dequeue_fwevt(mrioc)))
		mpi3mr_cancel_work(fwevt);
    ...
}

Could the background worker thread (mpi3mr_fwevt_worker) concurrently finish
executing and free the fwevt structure, causing cancel_work_sync() inside
mpi3mr_cancel_work() to access freed memory?

Additionally, lockless access to mrioc->current_event in
mpi3mr_cleanup_fwevt_list() could similarly read a concurrently freed event=
 if
the worker thread finishes in the middle of cleanup:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
    ...
	if (mrioc->current_event) {
		fwevt =3D mrioc->current_event;
        ...
		mpi3mr_cancel_work(fwevt);
	}
}

Does this code need to hold a reference to fwevt while calling
mpi3mr_cancel_work() to prevent the worker thread from freeing it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D16
