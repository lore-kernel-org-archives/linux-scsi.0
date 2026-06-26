Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B1828725B
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475386; cv=none; b=XKN/zQRnLPx788YLMsTVI9qnInrgRCLigvxnZBmc32MD+sdIO/QWJQstr03QgK8y3YEevjsKhSuF1XXQxatALK4uVsOTigivtmKgtzeaQlSrR4MdAoHevbml/i2Z252oH4kP59z+opaf1kc/npYlHbFUP5uDEGzCo/wa3es40Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475386; c=relaxed/simple;
	bh=rGao843PBgOL+ARdTr4QcQYCLLq45apvPnfVmUBEdVo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S40Mm8AjnJWfc4Um3Vr2cR2OinLZalZb4Nl+5rI+SjwHestGpxO/Q5eMrelSbT/R+ZsoTuVkRy7xEtyNiM3DegmY+xYTxW9sDBLRQ8QBhuPJb7q2/TT9muTTlyJuzumEj9MwW5xMmiGGu9OUNmSIXK4AHmeEEtXC3rjOU6/J1nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlDJiMSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlDJiMSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC29F1F000E9;
	Fri, 26 Jun 2026 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475385;
	bh=6bzah+QGYK4UXviDoGLy4Ndt5JAtdjYbzrPUctw8m3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QlDJiMSXkLkGPwRaHBvfk12hwORVboXldaIrzu2n1g5sK24xxlcZozy/L3I1iTPv1
	 sJKc7rZMmTYFnS18XahM4sf2dnJ6agPZB+277wdi4glWCj1OfMHWWRo0NS9obqsH77
	 eZMdNJfsJQf6VlqHIzuWgDvRPrAkModeg5n5HUfxuH6tftlcI845yPvoj1ekGvCxzS
	 //u0ZPmfbj56UnplCdPS8I96G6nMrZc9OAGecvwN9KBpkB34/aOCW8DyySLcruA/SF
	 cAr7sbmwKkJjujahd/eCn5qTk+aJDy4AeVuXN/HaClgYdpJsu+Wj8hAuEy9rbjAUHJ
	 Hki4fNWMCjxzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 07/10] mpi3mr: Fix firmware event reference leak
 during cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-8-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-8-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:03:03 +0000
Message-Id: <20260626120304.EC29F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch introduces a Use-After-Free and Double-Free vulnerabilit=
y by prematurely decrementing the reference count of the currently executin=
g firmware event in the early-exit path of `mpi3mr_cleanup_fwevt_list`.

Pre-existing issues:
- [High] Lockless read of `mrioc->current_event` in `mpi3mr_cleanup_fwevt_l=
ist` leads to a Time-of-Check to Time-of-Use (TOCTOU) use-after-free when r=
acing with the firmware event worker thread.
--

commit 50f8b457978a02d12ee5baafb77e83f6f06d294f
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: mpi3mr: Fix firmware event reference leak during cleanup

This commit attempts to fix a firmware event reference leak during cleanup.
It adds a call to release the firmware event reference before returning from
the early-exit path when an event is currently executing or pending at the
SCSI mid-layer.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index e361fbb8f7235..b60afaeef68d0 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -399,6 +399,7 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mri=
oc)
>  		 */

[Severity: High]
This is a pre-existing issue, but does the lockless read of current_event
earlier in this function create a race condition with the firmware event
worker thread?

If a soft reset thread executes mpi3mr_cleanup_fwevt_list() and reads the
event into the fwevt pointer, and the worker thread finishes and frees the
event before this thread reaches the pending_at_sml check below, could
dereferencing fwevt result in a use-after-free?

>  		if (current_work() =3D=3D &fwevt->work || fwevt->pending_at_sml) {
>  			fwevt->discard =3D 1;
> +			mpi3mr_fwevt_put(fwevt);

[Severity: High]
Does this additional mpi3mr_fwevt_put() cause a double-free or use-after-fr=
ee
when the active worker thread finishes its execution?

Looking at mpi3mr_fwevt_worker(), the worker thread retains ownership of the
event and appears to drop the reference itself after returning from the bot=
tom
half handler:

mpi3mr_fwevt_worker() {
   ...
   mpi3mr_fwevt_bh(fwevt->mrioc, fwevt);
   /*
    * Put fwevt reference count after
    * dequeuing it from worker queue
    */
   mpi3mr_fwevt_put(fwevt);
   ...
}

Since the worker thread relies on its own reference, will stealing the
reference here cause the count to reach zero prematurely while the worker is
still using the object?

>  			return;
>  		}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D7
