Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752684749DB
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324448; cv=none; b=SxokEv7v9VD98/BjBwPO5GqIRR7hTy5o0+uCttMRJbQGWSAlvqwjdY0izvBLQZv4mBJ5Dtpv7KeROZBnGCio/ccddE9y23Y3Hyq4mj+gQvTUhxsDVD9ZdM6Lz2KbBYnXQHhCE89F/BbH2Gvt8FJnijXG/IXylSiD+/Oy2v+q+1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324448; c=relaxed/simple;
	bh=o5tiiutdBhORzNCfmo5owcQJkbFKYV0GT7T4YCpk6O8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=beA/0Ghj5nmcB90cfmhl4nxs/elQjNQkuTVU/aNikgyZaJ9GOXZpw5W908SAl1+gwa4v0JTx/FTNWIrjo5xpABy+hNhf0NxaqfjX3GEfZ/zxLqT006hEku8QM2VqA+LDxmpnN+HCc6TNI8EyIHTJgg1FIVlwujCHiYGXFimaIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iStNoI6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iStNoI6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBF61F000E9;
	Wed, 29 Jul 2026 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324447;
	bh=eQK9rGKOz19VOyDADpmq3DBbhGdcs2NQbYfUBKvdp0U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iStNoI6lGq1tj6g+/s6V9hYceI3kLKW26c2Uqahl74P1kyTx2SGnVi4dSrOWYi2uA
	 hcJsc1l0zcXKmZ8h23/WMN/SirhIUqnlCCDOlfOMfc3ZC5osvQJeLkpHpRuR60xi2l
	 UyxNrN/h1cRMu4eEUf6yjAteyc52Foj2vUKwFbfu0Av+S3TbZ+2V6KGbErFwzdgoif
	 tP58cwmMO2DrmKxK/ImVSDUA1oCkv9IWYBG3zlLf4x0IbLNPhJ+70Jg4bblsnoo3sR
	 gyupQPflBHN5Q/Q0C/ybJ8/9sbN2KjCNWBW/vQdFrO5wGYqkAu4MHzDGCvg2OwoUIA
	 AqmmPlDivAI3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: core: pair EH runtime PM get and put
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongjie Fang" <hongjiefang@asrmicro.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
References: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:27:26 +0000
Message-Id: <20260729112726.ACBF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the SCSI error h=
andler thread enters an infinite CPU spin (livelock) if `scsi_autopm_get_ho=
st(shost)` persistently fails.
--

--- Patch [1]: [PATCH v3] scsi: core: pair EH runtime PM get and put ---
commit c29848e943092f2d5f259d4461009f3a5aa7ad12
Author: Hongjie Fang <hongjiefang@asrmicro.com>

scsi: core: pair EH runtime PM get and put

This commit modifies the SCSI error handler to snapshot the eh_noresume
flag using READ_ONCE() at the start of each EH iteration. This ensures
that runtime PM get and put operations remain balanced even if the flag
changes concurrently. It also changes eh_noresume from a bitfield to a
regular bool.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 453a2232452db..74b70801269bd 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c

[ ... ]

> @@ -2403,7 +2404,8 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) !=3D 0) {
> +		eh_noresume =3D READ_ONCE(shost->eh_noresume);
> +		if (!eh_noresume && scsi_autopm_get_host(shost) !=3D 0) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				shost_printk(KERN_ERR, shost,
>  					     "scsi_eh_%d: unable to autoresume\n",
>  					     shost->host_no));
>  			continue;
                        ^^^^^^^^

[Severity: High]
This isn't a bug introduced by this patch, but does this continue statement
cause an infinite CPU spin if scsi_autopm_get_host() persistently fails?

If the SCSI host encounters an error, shost->host_failed =3D=3D scsi_host_b=
usy(shost)
becomes true, and the error handler thread wakes up. If the PM resume retur=
ns
a non-zero error (like -ENODEV during hot-unplug), the code logs an error a=
nd
hits this continue statement.

This skips the scsi_unjam_host() call and the shost->host_failed =3D 0
assignment. On the next loop iteration in scsi_error_handler(), host_failed
still equals host_busy, so the sleep condition remains false. This causes
the thread to immediately loop and retry the PM resume, spinning endlessly
on a CPU core.

>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729111614.2407=
559-1-hongjiefang@asrmicro.com?part=3D1
