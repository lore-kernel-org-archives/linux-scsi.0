Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52812C325C
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032034; cv=none; b=RPtsU5CmwUseiRHuQddTqX79+Ic7Hv3SAj5JcGOywJNR9EawYl9SlLedXSVGZSPxXlY6k1lhIYAIMy6snFtMZxkVHa9HsMe0EUqeIbDuyCjNcnBUfgqPxovH1qBl1kXPNgbFE8Ix6jvKkqf60s2P8fg+FnGYqhdwr0SvAPwv3GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032034; c=relaxed/simple;
	bh=mrrhfnAQxyOzZgKPrO+6iGrB0g7zc5R/ee5Abmi+PeE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iUEMX+Czm93lpMkxlVsJ5qxT1BLyl6btlzuN4CECq+zznPnCqTxCvcPj8CJr+aR/2NYbH0AxfBGjhHE1U7SarWjfIeA0k5wDgqB8xiNRktTTV0iOjoABpqYnEZdJuh9Kr/zWE5t42l93i0cvRCme/T2zGx7zeYifO+qjZNavbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsnNy8mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsnNy8mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072381F000C4;
	Thu, 15 Oct 2026 02:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792032033;
	bh=fbofTko769gecTYhRF7txnju5t6YylfJS/wF+pibngU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gsnNy8mTWGkwdjT5lZCEz3a+H79h3oENLlG7H4Pki7Szx8aAuFDallhfb3W9Ts38c
	 0yvowSfk5Qxt5WD/rlGxngcbje+HVOZddB9PnCZLdQsEhOvabJO6bSGNMHJJ/blrVd
	 H0jOYlvnkJSH6/dg3fxradnWmpgpHwN/aAnBFxxQGPGa2TFYan/pKKsxC/gVraTO6y
	 JE/rO+ENqHgAZAw086F68lRDZpmNtzyY0SY1UBYY3w1u1rlGhq68LDZcvc6RHcesd2
	 g2ytMFDJY91UkP4vdaRVrKXFIoPp+WpecQ0vS4oJVW+Za0PFDGYfX8ZuOBHD+3kbbj
	 Zhylw/BzG+MCQ==
Message-ID: <sashiko-outbox-172163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/8] scsi: mvumi: reject handshake sizes that
 overflow the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015022728.3936714-6-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
 <20261015022728.3936714-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:40:32 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing firmware abort write causes infinite retry lo=
op
--

commit 4d0f01fe304c4edb98be93f9e2717cb4c6551a92
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

mvumi_hs_process_page() takes max_io, the two command entry sizes and the
list depth from the firmware handshake page. The entry sizes are u8 fields
used as shift counts, and 1 is an int, so a count of 29 or more makes the
<< 2 applied to the shift overflow an int; a count of 32 or more is
undefined outright.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 18964e860ac8e..8b8e5545747e8 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -912,10 +912,23 @@ static int mvumi_init_data(struct mvumi_hba *mhba)
>  	unsigned int tmp_size, offset, i;
>  	void *virmem, *v;
>  	dma_addr_t p;
> +	u64 total;
> =20
>  	if (mhba->fw_flag & MVUMI_FW_ALLOC)
>  		return 0;
> =20
> +	/* These are firmware-supplied and size the allocations below. */
> +	total =3D (u64)mhba->ib_max_size * mhba->max_io +
> +		(u64)mhba->ob_max_size * mhba->max_io +
> +		sizeof(struct mvumi_dyn_list_entry) * (u64)mhba->max_io +
> +		160;
> +	if (total > UINT_MAX) {
> +		dev_err(&mhba->pdev->dev,
> +			"handshake sizes too large: io %u, in %u, out %u\n",
> +			mhba->max_io, mhba->ib_max_size, mhba->ob_max_size);
> +		return -1;

[Severity: High]
If these new boundary checks fail and return -1, will it cause an infinite
retry loop?

When mvumi_hs_process_page() or mvumi_init_data() returns -1,
mvumi_handshake() sets hs_fun to HS_S_ABORT but returns immediately without
writing the abort state to the doorbell registers:

	if (mvumi_hs_process_page(mhba, hs_header)) {
		HS_SET_STATE(hs_fun, HS_S_ABORT);
		return -1;
	}

Because the firmware never receives the abort, it waits for a response and
eventually retries by asserting DRBL_HANDSHAKE_ISR.

The caller mvumi_handshake_event() then processes the interrupt, calls
mvumi_handshake() again, and resets the timeout:

	if (isr_status & DRBL_HANDSHAKE_ISR) {
		mhba->instancet->clear_intr(mhba);
		mvumi_handshake(mhba);
		before =3D jiffies;
	}

Doesn't this result in the driver probe hanging indefinitely on bad firmware
instead of timing out or failing cleanly?

> +	}
> +
>  	tmp_size =3D mhba->ib_max_size * mhba->max_io;
>  	if (mhba->hba_capability & HS_CAPABILITY_SUPPORT_DYN_SRC)
>  		tmp_size +=3D sizeof(struct mvumi_dyn_list_entry) * mhba->max_io;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015022728.3936=
714-1-yhlee@isslab.korea.ac.kr?part=3D5
