Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1075F42E8E9
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785929604; cv=none; b=nqPwzGJhPQvHiFFL5Ek9aolxuf3OAozs50jk8vx9inCHZjfncfTv07GEG/0q6aE4BpuE3fvzfgXlV7GRWDztLj1jwkECpIrwxhw4M2d48db87L3oVxBke6xV0k+7351LP1vYl2s95HD8E5iELuC7i0nUQ5UzO1o8Hy7WsfYup0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785929604; c=relaxed/simple;
	bh=RTb/Fxjp+QCUw/ob8NWbzofgM4EkQbkWV8CvO8WK4UM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ltHtcdtX8sY7y7v1X3RfWsPihE0Fr5qMFaFhuflYxh85V64TOgaIHYXmv4j2a9p00psjqT102LBntiRTayyxHgnAxLOQg899RWZVfPeWLx6npwaf8RCJ/YNBkPeAZRFuYMyyvU2UwLh7QVxMku2/Jxff8BEoMO1kGEtsYb/g2ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHWwBpi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHWwBpi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993BA1F000E9;
	Wed,  5 Aug 2026 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785929602;
	bh=HBlPMbDcisUoAA7PemRdr2pSPS7r6GCAu/i9Cw5w2L4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IHWwBpi1Tv433Mj1Tipn5cwsRjssOzPgtZ/Bi/DDowZ1CMLXrytkdA1EISpNJLO9t
	 IUgaokPzarzOPpHeGXm2mvwu38d7FW1gsnOXfWMEXwOguXONWfZLOIkz2/KP6a5x/+
	 Ui4g4t8Nzl+/13Wa+ZQVOgHKvNQv1uhod5/5cr5PhSbvU0+lJ7xSN8LdQJImg4nWPX
	 iiWThnB5ZW3ho7grO9aMfr7NroZKBO+3wGHAyeW7aJpQNg9A1vpXdzawCeq5WM7LGW
	 d6xes39z0QuxE5D0o0LpBPW30nczTbWrbFx3doY7jt61TYVoq19jtZvmSsEeV5vpJh
	 OLxaYLi8l82Eg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/10] mpi3mr: Skip device shutdown during unload per
 controller configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-2-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:33:22 +0000
Message-Id: <20260805113322.993BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver rounds down the trace buffer size internally when alloc=
ating segmented buffer entries, but passes the original unrounded size to t=
he firmware, which can cause the firmware to read past the end of the segme=
nt list and DMA write to arbitrary physical memory.
- [Medium] A trace buffer size smaller than 4KB results in a 0-byte DMA all=
ocation, triggering a WARN_ON_ONCE within the kernel DMA API.
--

--- Patch [1]: [PATCH v4 01/10] mpi3mr: Skip device shutdown during unload =
per controller configuration ---
commit 9ac255a070f5df8da5fb46e54b2787eacb0b7c7c
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Skip device shutdown during unload per controller configuration

This commit caches Driver Page 1 settings to suppress device shutdown durin=
g=20
driver unload. It adds endianness conversions for the diagnostic buffer siz=
es
read from Driver Page 1 and hardens the allocation retry loops against inva=
lid
decrement sizes provided by the firmware.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D1
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D1
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar=
@broadcom.com?part=3D1

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 1353a8ff9c85d..fca5357a515d1 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
[ ... ]
> @@ -179,6 +181,12 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
>  		    mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
> =20
>  			retry =3D true;
> +
> +			if (!trace_dec_size || trace_dec_size > trace_size) {
> +				retry =3D false;
> +				goto retry_fw;
> +			}
> +
>  			trace_size -=3D trace_dec_size;

[Severity: High]
This is a pre-existing issue, but does this lead to firmware reading
out-of-bounds and potentially corrupting physical memory?

The driver rounds down the trace buffer size internally when allocating
segmented buffer entries in mpi3mr_alloc_trace_buffer():

    seg_count =3D (trace_size) / MPI3MR_PAGE_SIZE_4K;
    trace_size =3D seg_count * MPI3MR_PAGE_SIZE_4K;

However, it does not update the caller's trace_size. Thus, the original
unrounded trace_size is stored in mpi3mr_alloc_diag_bufs():

    diag_buffer->size =3D trace_size;

When posting the buffer to firmware in mpi3mr_issue_diag_buf_post():

    diag_buf_post_req.length =3D le32_to_cpu(diag_buffer->size);

The firmware calculates the required number of segments using the unrounded
size (e.g., ceil(5120/4096) =3D 2), but only 1 segment was allocated (size 8
bytes for the segment list). The firmware will read past the end of the
segment list (16 bytes), leading to an out-of-bounds DMA read. It will then
use the arbitrary out-of-bounds value as a physical address to DMA-write
trace data, leading to memory corruption.

[Severity: Medium]
This is a pre-existing issue, but can this retry loop cause a 0-byte DMA
allocation warning?

If the firmware-provided host_diag_trace_max_size (or the size after retry
decrements) is less than 4KB, trace_size will be less than 4096. When passed
to mpi3mr_alloc_trace_buffer(), it calculates seg_count =3D trace_size / 40=
96
which evaluates to 0.

This results in a 0-byte allocation in mpi3mr_alloc_trace_buffer():

    diag_buffer_list =3D dma_alloc_coherent(&mrioc->pdev->dev,
                                          sizeof(u64) * seg_count,
                                          &diag_buffer_list_dma, GFP_KERNEL=
);

Calling the DMA API with a 0 size triggers a WARN_ON_ONCE(!size) splat in
dma_alloc_attrs(), which can crash systems with panic_on_warn enabled.

>  			dprint_init(mrioc, "trace diag buffer allocation failed\n"
>  			"retrying smaller size %dKB\n", trace_size / 1024);
>  			goto retry_trace;
>  		} else
>  			diag_buffer->size =3D trace_size;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D1
