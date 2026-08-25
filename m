Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008BD32B10E
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674802; cv=none; b=NeQ11q99gruAaCT/0Jzs5a8bK0xdEwh03B2zS1mAejepawTQuh9sGVYIXZ2myEaGJ9CDz/UzI10wlXn08Ji17T7egCvnefH+NkCjywtuF8xgcTytkxGb0YfuYYZm6YxL2y7KkDo0+UDANh0avkosQJF6K+VPdop52OwtDX+BCAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674802; c=relaxed/simple;
	bh=GW2s+7W0c/GZwB9vB5hiyjNaS8geH+1Ou04gpkbp6lw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ni9VbeTWm1eaRMxjuL11z7JDLqCkY8N6rWjfs2Gu85aQljbISJvX1MhwGRHh5kwE3ViMIipbzLwSFn1mXn/+LmTidJYowCxhOQbaackXmGl89vQoVR5a4zzCahwBf4rfBkJYdm1H9Y5gWZokx5NcZFbuJzrgCXbYUgVyCRbu/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB5p+hp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB5p+hp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E60B1F000E9;
	Tue, 25 Aug 2026 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674800;
	bh=cerNN6hwAH74cHovoCNUWae1mRZSZ5d+OXqz+LsA1GI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iB5p+hp+yAqBzlR3CmABDb3vW1gDwTnGpou4jbY6JoZZlMZqY1heZXSdHCt6T19JI
	 DIZPnNqlvK0lN0gn+3qlPx/RV1U/fjaMfmIZB+ktTmpKXn3znD9lKZNBI2fNKqCEWL
	 9lorxZnD6q48gNcqMROCWWbJ/iUzKzSIRkQDZTNDy5fGTfvWsZYFggrEqSTBOsWS1+
	 0RVKpUpn38IRb74NXgBJIBHIksgrVCrLKteBM+3w4K3Wm9/sPIt5uabm/pkoGe3gju
	 r0kwLTSk4G+++BVWI1vV4VpsQ+MYe6iJUEtXCqOpPBEU2p5w4hiF1AwfgapKgdOMz+
	 1dkiQ0Nd1O8Rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/17] mpi3mr: Fix NULL pointer dereference on PCI
 error recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-18-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-18-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:20:00 +0000
Message-Id: <20260825162000.8E60B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent execution between `mpi3mr_cleanup_fwevt_list()` and=
 the firmware event worker thread results in a Use-After-Free of the `mrioc=
->current_event` pointer.
- [High] The patch fails to resolve the 'already in flight' race condition =
described in its commit message, leaving the driver vulnerable to NULL poin=
ter dereferences via a Time-Of-Check to Time-Of-Use (TOCTOU) race.
--

commit 67ebeaa54b154ad043a90c5a2e98345f3782e9c3
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix NULL pointer dereference on PCI error recovery

This patch attempts to fix a race condition on a frozen PCI channel by
preventing in-flight firmware event handlers from accessing unmapped
register windows. It adds a check for pci_err_recovery early in the
bottom-half handler to skip event processing during recovery.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index e97e343b14fa5..a389f7f2c741e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2130,9 +2130,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mri=
oc,
>  	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
>  	mrioc->current_event =3D fwevt;

[Severity: Critical]
This is a pre-existing issue, but does assigning mrioc->current_event here
lead to a use-after-free during driver teardown or reset?

If mpi3mr_cleanup_fwevt_list() is executing concurrently, it performs a
lockless read of mrioc->current_event:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
        ...
        fwevt =3D mrioc->current_event;
        ...
}

At the end of mpi3mr_fwevt_bh(), the worker thread drops the reference and
NULLs the pointer:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_fwevt_bh() {
        ...
out:
        mpi3mr_fwevt_put(fwevt);
        mrioc->current_event =3D NULL;
}

If mpi3mr_cleanup_fwevt_list() captures the pointer before the worker thread
NULLs it, but accesses it after mpi3mr_fwevt_put() frees the memory, could
this corrupt memory when interacting with the freed event's work struct?

> =20
> -	if (mrioc->stop_drv_processing) {
> -		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half hand=
ler\n"
> -				"due to stop_drv_processing\n", fwevt->event_id);
> +	if (mrioc->stop_drv_processing || mrioc->pci_err_recovery) {

[Severity: High]
This isn't a bug introduced by this patch, but does this lockless check ful=
ly
resolve the race condition described in the commit message?

Since this check is evaluated early in the handler, could an in-flight work=
er
pass this check, get preempted, and then attempt to access hardware registe=
rs
concurrently with mpi3mr_error_detected() unmapping and NULLing sysif_regs?

For example, if the worker proceeds to mpi3mr_admin_request_post():

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_admin_request_post() {
        ...
        writel(mrioc->admin_req_pi, &mrioc->sysif_regs->admin_request_queue=
_pi);
        ...
}

Would this still result in a NULL pointer dereference or unmapped memory
access if the PCI error recovery path clears mrioc->sysif_regs after the
boolean check in mpi3mr_fwevt_bh() has already passed?

> +		dprint_event_bh(mrioc,
> +				"ignoring event(0x%02x) in the bottom half handler\n"
> +				"due to stop_drv_processing or pci_err_recovery\n",
> +				fwevt->event_id);
>  		goto out;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D17
