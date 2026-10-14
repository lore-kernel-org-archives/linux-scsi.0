Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C5029992A
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791939170; cv=none; b=rwa49GDXnIBUi7j4tXUkazQXAesHCq6Pgb6RBTWJWmjaiKB42gUnUraxmX9PTXbjDgTV3aSj/nv3vLvUjEB1Pe0o3aM2+EkgMDEKbuDqb4+oF2iWWYOykP0Mvemu5LZylcLUoWOmmuhXfp6W9wtFvs3i5JqBfYrg9wFZ+WlviRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791939170; c=relaxed/simple;
	bh=kiRbDpg7/+K6VmJHWDvToE2ms3scsAjYrOjRvGpndKI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ty4hvq95kuWa6kDRzgCcO3URExXWe+VOh959/Gkj0Edy35Sm84qx+ewScPoAtJWlou/L5iaNS6rcJOE9pJMooYbgJoEzwKCA9EkHSbCVn09hftGsvTVnTfBzqWw7wSDQ7VRGfztdbfc/xfBgGp99WWyeVwRaal6lmGvoRR5pxX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Voc8gsS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Voc8gsS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099921F000FF;
	Wed, 14 Oct 2026 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791939169;
	bh=3wlFRAXLb8qNI35vwV9fAWKn+Q1NaUHi3OwLUuhQCvI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Voc8gsS2vTg2BWf7D3wKHbCD4SUG94S76DaawcoMjg6xobwQZxTAQFWG1ZkWpTOFq
	 rtjahsyi+OWsaC8Qp35P43Y4I0Jhdt/cIAe5C3e4fUZ/ddjuYM0z9MlN7340laKGy4
	 O7cuvbHJGINppfQ3vkLoM9Xz1kmzAOp3TfKBU5ZParE2b4IHKx9WTRljD17cCPZLkv
	 C3sXajg1bMSE4Mw3l9dI825zinKei30MkTS4SxPWw2WA+eE/nA2MZAGWmY+IsJFQmT
	 iQZp3EGCUDjVrsVagR4hh+/AbMsRRHLDZnEem5xktvl7BU601IzgTEBzP6HIZ6hreb
	 Z1C4nFUdiYJGg==
Message-ID: <sashiko-outbox-170653@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mvumi: reject handshake sizes that overflow the
 list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
References: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 00:52:48 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: size_t truncation bypasses buffer overflow check on 3=
2-bit architectures
- [High] scsi: mvumi: Out-of-bounds access due to unvalidated list_num_io
--

commit b87e745d0db555a98674b0d478b3e35f7a31fefb
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
scsi: mvumi: reject handshake sizes that overflow the list allocations

This commit adds firmware handshake boundary checks to reject sizes that
could overflow integer capacities. It restricts shift counts to avoid
integer overflow and introduces a check on the total required allocation
size.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..b86d954f3576b 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -912,10 +912,23 @@ static int mvumi_init_data(struct mvumi_hba *mhba)
>  	unsigned int tmp_size, offset, i;
>  	void *virmem, *v;
>  	dma_addr_t p;
> +	size_t total;
> =20
>  	if (mhba->fw_flag & MVUMI_FW_ALLOC)
>  		return 0;
> =20
> +	/* These are firmware-supplied and size the allocations below. */
> +	total =3D (size_t)mhba->ib_max_size * mhba->max_io +
> +		(size_t)mhba->ob_max_size * mhba->max_io +
> +		sizeof(struct mvumi_dyn_list_entry) * (size_t)mhba->max_io +
> +		160;
> +	if (total > UINT_MAX) {

[Severity: High]
Does this truncation bypass the buffer overflow check on 32-bit architectur=
es?

The calculation casts the factors to size_t. On 32-bit architectures,
size_t is exactly 32 bits. If the firmware provides large values, the
product can silently wrap to 0 during the arithmetic.

Because total is of type size_t, it mathematically can never exceed UINT_MAX
on 32-bit systems. The check total > UINT_MAX becomes tautologically false
and is bypassed, which allows the driver to proceed and allocate undersized
buffers using the wrapped 32-bit values.

> +		dev_err(&mhba->pdev->dev,
> +			"handshake sizes too large: io %u, in %u, out %u\n",
> +			mhba->max_io, mhba->ib_max_size, mhba->ob_max_size);
> +		return -1;
> +	}

[ ... ]

> @@ -1051,16 +1064,24 @@ static int mvumi_hs_process_page(struct mvumi_hba=
 *mhba,
>  	case HS_PAGE_FIRM_CAP:
>  		hs_page1 =3D (struct mvumi_hs_page1 *) hs_header;

[ ... ]

> -		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF)
> -			mhba->list_num_io =3D 1 << hs_page1->cl_inout_list_depth;
> +		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF) {
> +			if (hs_page1->cl_inout_list_depth >=3D 32) {
> +				dev_err(&mhba->pdev->dev,
> +					"invalid handshake list depth\n");
> +				return -1;
> +			}
> +			mhba->list_num_io =3D 1U << hs_page1->cl_inout_list_depth;

[Severity: High]
Can this lead to an out-of-bounds access if list_num_io exceeds max_io?

The patch caps cl_inout_list_depth to 31, allowing list_num_io to be up
to 2^31, but fails to check whether list_num_io exceeds max_io.

The ib_list and ob_list arrays are explicitly sized and allocated based
on max_io in mvumi_init_data(). The array indices unconditionally increment
with each IO operation and only wrap around when they reach list_num_io.

If list_num_io > max_io, the driver can sequentially advance the index
beyond the allocated array size after processing max_io commands, causing
out-of-bounds heap reads and writes.

> +		}
>  		break;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014004226.3469=
868-1-yhlee@isslab.korea.ac.kr?part=3D1
