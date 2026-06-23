Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670B38AC68
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 08:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201941; cv=none; b=o1DqrcgrYKtMWUAKsDINaFFB/tHkUMLMqW3aDr/MLAXMHkthPnbgzDSlrQar3EEMVOwibGYbhhTV5utCslZ+4Gyx561u7RSxlc8FHVl1yBMnwxdUYm9E5F2jkw/MwNOeXblsCP8Bnwqy+WxcJa3npvVKKtYC+Jc/4yZg9UP8AiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201941; c=relaxed/simple;
	bh=1Cb5jOOx5EfZAsqHwAXu1ziJYliSYDztvMtCGCzDrNU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ccCqDins4HzDJaM2w1Mwg5oZYKdFsMzg5q/U7FRzveDLPX6DoTwdQdD77+Tf2ud7JNCrjFh1RF5Kbyo3Bo5lcx1dbkMOAmvWYeZ7DHbtIbKGCOZ+Xk9u2HmwEe4k0U1JN6xT6nJ8P2Od8wO958zpeQ/UaFMPVubQZIV6QLMsW9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IkAqSOlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IkAqSOlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938911F000E9;
	Tue, 23 Jun 2026 08:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201939;
	bh=ZgZxVJmnxKyketZjqX2Bn9u44eDAOPj5KvKEaPOTnXQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IkAqSOlrsc6PpRDmpuiXpjFCrft4JX21deDHfiggGFT3OCH+Uz0v8qcZEIVGGFPfi
	 7dUdZ1IxTFCP9wtYHkyXnHAkrDUwQ75sOJr0OLtSWr9ku/jf+O7RSBEGtry27VHI4/
	 oNX8Gm893dr95grNMWg0FKvBCvfWq7vvB5TbUL62i7FGcqtYGyD1LU5bl5hW430wUg
	 nPm0Acz1pu36om79nYJT3y3p3FWZukHqhCf3PGFHuYsqGc7QiwyKkcbJRmro2a+pnI
	 AbvBPQyyCI7k+z8ilLcms26NwzibyiyU793Oy0OXZ/kKA7Sq4cLN/hAa7OC+UOqSvH
	 fcE2Q/2bjUBoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: core: pair EH runtime PM get and put
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongjie Fang" <hongjiefang@asrmicro.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
References: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 08:05:39 +0000
Message-Id: <20260623080539.938911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected concurrent modification of the `eh_noresume` bitfield =
causes data corruption and torn writes of adjacent bitfields in `struct Scs=
i_Host`.
- [High] If `scsi_autopm_get_host()` persistently returns an error, the SCS=
I error handler thread enters an infinite busy loop, completely locking up =
a CPU core.
--

commit ac1a188a1cc95a2e48943738d61761f7fb9d8f35
Author: Hongjie Fang <hongjiefang@asrmicro.com>

scsi: core: pair EH runtime PM get and put

This patch fixes a potential runtime PM usage count underflow by ensuring
scsi_autopm_put_host() is only called if the corresponding get operation
in the same iteration succeeded. It introduces a boolean variable to
track this state.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9c..c78ea64641a98 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c

[ ... ]

> @@ -2383,12 +2384,16 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) !=3D 0) {
> -			SCSI_LOG_ERROR_RECOVERY(1,
> -				shost_printk(KERN_ERR, shost,
> -					     "scsi_eh_%d: unable to autoresume\n",
> -					     shost->host_no));
> -			continue;
> +		autopm_put =3D false;
> +		if (!shost->eh_noresume) {

[Severity: High]
This isn't a bug introduced by this patch, but could this concurrent read
and update of shost->eh_noresume be unsafe?

Looking at include/scsi/scsi_host.h, eh_noresume is a 1-bit bitfield that
shares the same memory word as tmf_in_progress and other state flags:

	unsigned tmf_in_progress:1;
	unsigned eh_noresume:1;

If eh_noresume is modified directly (for example in
ufshcd_set_dev_pwr_mode() in drivers/ufs/core/ufshcd.c) without holding
shost->host_lock, could this cause torn writes that corrupt other adjacent
bitfields modified by concurrent threads holding the lock?

> +			if (scsi_autopm_get_host(shost) !=3D 0) {
> +				SCSI_LOG_ERROR_RECOVERY(1,
> +					shost_printk(KERN_ERR, shost,
> +						     "scsi_eh_%d: unable to autoresume\n",
> +						     shost->host_no));
> +				continue;

[Severity: High]
This is a pre-existing issue, but if scsi_autopm_get_host() persistently
returns an error, won't this continue statement cause an infinite CPU-hoggi=
ng
loop?

Since continue bypasses the rest of the loop, the cleanup step
(shost->host_failed =3D 0) is never executed.

On the next iteration, the initial sleep condition at the top of the loop
will evaluate to false because host_failed is still equal to
scsi_host_busy(). This bypasses schedule() and immediately loops to retry
the resume operation ad infinitum.

> +			}
> +			autopm_put =3D true;
>  		}
> =20
>  		if (shost->transportt->eh_strategy_handler)

[ ... ]

> @@ -2407,7 +2412,7 @@ int scsi_error_handler(void *data)
>  		 * which are still online.
>  		 */
>  		scsi_restart_operations(shost);
> -		if (!shost->eh_noresume)
> +		if (autopm_put)
>  			scsi_autopm_put_host(shost);
>  	}
>  	__set_current_state(TASK_RUNNING);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623074408.1639=
663-1-hongjiefang@asrmicro.com?part=3D1
