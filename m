Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF033B95F6
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 21:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372776; cv=none; b=Lsfqbu+3b3l9ee3voV6+2W1g37bXdmVvy7zjDp8jdd64nKhJL2O3bEt69Z6Nen1qWcoaXOxOYbyHm4bjN7vByIOhjGhbmvVjwz8EmQNl+B0jdP/Fsu3mYlDNXyymS7RCx1oCAmIcnJ3VHx5HpDM9N2eQ5PZPH6lP7E4OQlLYLS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372776; c=relaxed/simple;
	bh=MTtK2l/cJucsE0tQSEvDoSoLIihQjhVcksEc+0pAqzQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ke5cAqxgdvSlxs/SlZeGOMGstBxVB4gIkYfG0+G1uwNwYcG45GuCPrHfirdu8ERL3VCa2Pbo2Z8PuyCA0U8zIcSjZGQZ5LNrlle6AHw7f0lJTa2w6QlB0TKhtc+y/vJInamQKvWJvmoAxC5MVRyjfzNGs9ESXNnh892OfrVJGyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iErrLScs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iErrLScs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD7E1F000FF;
	Fri, 25 Sep 2026 21:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790372774;
	bh=3PeDVCZvL+mlYYNNSlKhPqHacLXSk6f/2OamkbI/NHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iErrLScsCW0KrO3C6n/6SQaF5G5eRMxPPywyYr6RQVExmPzgiUCa1MY2zKEgla4wm
	 LrUTjv0T0JByW3DdzlZu6QKvEm/Ejn83GfAGNxNQDgCiaYov+Burf9m+Xo8isUT2tk
	 Q0gcFtdj/OgG834ok7W6+WaOGG9aBzFAuxAMBLl6eIeHwO3nBvG5QcQrPUtYJliwpn
	 xRqiOXiGNLdVf/1zhF52NRreZHC+3yT1/gUh0mBq7iNrUQwDqbuW0ZZzvllwk8vjZH
	 jTtgPWKytJlgrwqFpjUVDxVcdsNNtzVzFl5LVWYqd0r8+x76sgcW3V2d7EApRcLeHQ
	 qZ/rUveMtoeMA==
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc4+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
References: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 21:46:13 +0000
Message-Id: <20260925214614.0CD7E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: Use-After-Free on pseudo_sdev in ufshcd_err_handling_pr=
epare()
- [Low] scsi: megaraid: mixing goto-based error handling and scoped_guard i=
n megasas_resume
--

commit 779f0b1927d5f926d874e86dcf935da1578ca2f4
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Sep 25 21:22:51 2026 +0000

SCSI fixes for 7.3-rc4+

Mostly small driver fixes. The biggest fix is the one to the block zone
handling which might trip for real or virtual hardware if the number of
zones is > 2^32.

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index b95f187297aed..4f9a53769966f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
[ ... ]
> @@ -7886,7 +7886,9 @@ megasas_resume(struct device *dev)
>  			goto fail_init_mfi;
>  	}
> =20
> -	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
> +	scoped_guard(mutex, &instance->reset_mutex)
> +		rval =3D megasas_get_ctrl_info(instance);
> +	if (rval !=3D DCMD_SUCCESS)

[Severity: Low]
This isn't a bug, but this function relies heavily on goto-based error
handling.

Does the introduction of a scope-based cleanup helper (scoped_guard) here
violate the cleanup subsystem guidelines?

The kernel cleanup guidelines state that scope-based cleanup helpers and
goto should not be mixed in the same function, as it can create confusing
ownership semantics.

>  		goto fail_init_mfi;
> =20
>  	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
[ ... ]
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2ba244cf40ac7..54f4e7d7de02e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6817,11 +6817,17 @@ static void ufshcd_err_handling_prepare(struct uf=
s_hba *hba)
>  	}
>  	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
>  	blk_mq_quiesce_tagset(&hba->host->tag_set);
> +	/*
> +	 * Internal commands are submitted on the pseudo SCSI device. Let them
> +	 * through so that the error handler can recover the link.
> +	 */
> +	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);

[Severity: High]
Can this sequence lead to a use-after-free on hba->host->pseudo_sdev?

If a device error triggers ufshcd_intr(), it schedules hba->eh_work.
Concurrently, the driver could be unbound, invoking ufshcd_remove().

ufshcd_remove() calls scsi_remove_host(), which destroys and frees the SCSI
devices, including hba->host->pseudo_sdev.

Because ufshcd_remove() does not cancel hba->eh_work until later in
ufshcd_hba_exit(), the error handler might execute
ufshcd_err_handling_prepare() while teardown is in progress.

Is it possible for the code to dereference hba->host->pseudo_sdev here
after it has already been freed?

>  	cancel_work_sync(&hba->eeh_work);
>  }
> =20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
> +	blk_mq_quiesce_queue_nowait(hba->host->pseudo_sdev->request_queue);
>  	blk_mq_unquiesce_tagset(&hba->host->tag_set);
>  	ufshcd_release(hba);
>  	if (ufshcd_is_clkscaling_supported(hba))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/ea8f769b49f7d1185f5=
88cf5b9202f300c280af7.camel@HansenPartnership.com?part=3D1
