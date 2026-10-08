Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B4448B8A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791497378; cv=none; b=U/y6XCprZ1BezaASXdJri+DqNuvBtmHyAMZfgCEU3WKgfS1fA2pkHsm02JwaEIuIYRQtXpPKtwwioO5JmufFCJE7DKvfjzsNBlEtaaYXe0JkMUFl+cyVz+YcXsEwW3JJ4y4yzusLSCqjECzeHfzfcBcos3+9f5n2up3z7Sdin4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791497378; c=relaxed/simple;
	bh=jsOrp5RQX4u23pZFuSzRegHeUdypRaE4QHAxOhc1lMs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Bfa+6aaCSfqA0oITsAcww1rw6vv4LC0h6oAw/XvTW1A5LLOpENAjonYEr+8h3olesLPwR5ravfjdF3JY26hIKyWuFDuFlIrMWVelOrxfmmqTiXUNrgUUhqxEL9hCNkwg0+kmqXU2cHzr7Xyk2rirWi6rDJhOwgBIdQUxktPf/vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amjmGGEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amjmGGEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1651F000FF;
	Thu,  8 Oct 2026 22:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791497375;
	bh=WkJNhlKuvJGmwyda5VUNL7XBlC+cT5JYtRRAmc28DGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=amjmGGEsRgTdGObJVd6gwfRZtEEGTOt4WnThRZ0R3UT1A0DngsPKI1mGtU37N8ucu
	 hRPwocEb2dSGtD641Uo8yvWefYhpMe5Ba43a891wnRvWfYIX1uMmYikHVSwNBEnKFr
	 G/v+9os/YHoAmLKWoH4qg2CXFIqkxxsvjyfEvCr5xwrWiy16hptiQVyoG4VtNzq94r
	 tBdvIlHGJgYUKoOuLAE+/nuyTBztj99y7JFY03zebsHUBAomvaiQ854zjZS6RZFsab
	 /gtzkR7skl+JuR6jNXtgMloKxR7dJIh1ctCyDMDIPE4halkbXeuqFaYmYCtYi6EY6C
	 76awrbBhJ0IRw==
Message-ID: <sashiko-outbox-164622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: rd: Reject page counts larger than total
 RAM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sanan Hasanov" <sanan.hasanou@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008215709.46014-1-sanan.hasanou@gmail.com>
References: <20261008215709.46014-1-sanan.hasanou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 22:09:35 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: OOM killer storm from unbounded ramdisk allocation
- [Medium] target: incomplete fix for MAX_PAGE_ORDER warning on large RAM s=
ystems
--

commit 12a2dad36a98577f1d3e561b02b29fc0a3802314
Author: Sanan Hasanov <sanan.hasanov@ucf.edu>

scsi: target: rd: Reject page counts larger than total RAM

The rd_pages=3D device parameter is taken from configfs without an upper
bound. rd_build_device_space() uses it to size the sg table array, so a
large value such as INT_MAX makes it attempt a kzalloc() of roughly
64 MiB, which is above the page allocator's maximum order and triggers:
[ ... ]

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core=
_rd.c
> index 092d9fe0d4e31..3700cc1b5d67c 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
[ ... ]
> @@ -188,6 +189,12 @@ static int rd_build_device_space(struct rd_dev *rd_d=
ev)
>  	if (rd_dev->rd_flags & RDF_NULLIO)
>  		return 0;
> =20
> +	if (rd_dev->rd_page_count > totalram_pages()) {

[Severity: High]
Does this limit still allow a privileged user to request up to 100% of
physical memory, potentially triggering an OOM killer storm?

In drivers/target/target_core_rd.c:rd_allocate_sgl_table(), this translates
to looping totalram_pages() times and calling:

    pg =3D alloc_pages(GFP_KERNEL, 0);

Because GFP_KERNEL lacks __GFP_RETRY_MAYFAIL or __GFP_NORETRY, the page
allocator will aggressively retry by invoking the OOM killer when free memo=
ry
is exhausted.

Furthermore, because these allocations are not accounted to the caller's
memcg (no __GFP_ACCOUNT), the calling process maintains a low badness score,
which might cause the OOM killer to systemically terminate innocent
user-space processes.

[Severity: Medium]
Will this still exceed the page allocator's maximum order on systems with a
large amount of RAM (e.g., >=3D 512 GB)?

The size of the sg_table array is calculated in rd_build_device_space() as:

    sg_tables =3D (total_sg_needed / max_sg_per_table) + 1;

On a system with 1 TB of RAM, totalram_pages() is ~268 million pages. The
required sg_table array allocation size would be
(268,435,456 / 2048) * 64 =3D ~8 MiB.

An 8 MiB allocation exceeds the typical 4 MiB KMALLOC_MAX_SIZE
(MAX_PAGE_ORDER) limit of the page allocator, which means the subsequent
contiguous allocation in rd_build_device_space():

    sg_table =3D kzalloc_objs(*sg_table, sg_tables);

will still trigger the exact same kernel WARNING and -ENOMEM failure on
systems with high memory capacity.

Could kvcalloc() (and kvfree()) be used here to safely fall back to vmalloc
for large array sizes?

> +		pr_err("Page count: %u exceeds total RAM pages: %lu for Ramdisk device=
\n",
> +		       rd_dev->rd_page_count, totalram_pages());
> +		return -EINVAL;
> +	}
> +
>  	total_sg_needed =3D rd_dev->rd_page_count;
> =20
>  	sg_tables =3D (total_sg_needed / max_sg_per_table) + 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008215709.4601=
4-1-sanan.hasanou@gmail.com?part=3D1
