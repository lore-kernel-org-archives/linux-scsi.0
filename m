Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D16C3769E3
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210058; cv=none; b=Gprv7kvY7cODi/r25Fo1bDX4YXvGBnH0VwWKvWmigyKpGCR7BIojOvAgSlIh5cnMFdJxLheW6YGlYtpt8cKtHe/Yx5N3nW2Lw+6w6HNz7+8qAne5x8CVJ3HQjBdKsSRC9li0eqVXbCDVy+oZ+FH9BcFf2d1U8TV6Ol/kc8o0JpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210058; c=relaxed/simple;
	bh=ZZ+mzRNrLvuBLz6ICrajzx15TE4bRNOiPYdT1wUW03w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dVnPW4VEAVQq6wOW7ZyjBbTTiDVyvz8lYPKcuN2jPMk+CRYPYe6X2c5mgKMS9zY0XmKJ5pv+35tSoI8oITnA5DOMuXQpYi3sVAJWYtinWCgL8yBTLmWtffZTS4wh51uB6ct8959MEUQacTf8E6CfdGZbUmwJixINa8mXpkYEnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwZN4Le4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwZN4Le4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C11F000E9;
	Tue, 23 Jun 2026 10:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782210057;
	bh=PRfZ2Pf5lzYSdE6C3fX7z76SQiJrB4SVq6gjO8B79Ek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LwZN4Le4TSFFTZBScoR7zkjmVgxpTtbgQ0jfKm7kdIYAc9IHG8h2ov9SbpZXbTBgL
	 34i+7MoOeMYNxucI7whFX2xEB/iUdK5b1afYbuKsUqgjlAV0BcOCw1vgxEoj4wchzh
	 GiYguoYcKJLdPQFaUA6CDN1CeeqE1aNIIEw34b60GdeauhLUBZKWI7tlVFhazNYszA
	 xC8b/eP2POSHtTGLHoUa4V9kNwWIZoPMloo6pHwR8PlqId6O8vnFcq6Apo40nonz0m
	 caQKsutyR53+si6pzxhmhMtvQ51Mdu0WP1kW7SkiQ7fzVcOMcyzV2ujoBELUJDFcAn
	 uLJzicj+jXBhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 3/4] scsi: sd: fix special_vec mempool leak when
 scsi_alloc_sgtables() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623100159.4018066-4-yangxiuwei@kylinos.cn>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-4-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 10:20:56 +0000
Message-Id: <20260623102056.E11C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Concurrent updates to `sdp->sector_size` can cause `sd_uninit_comm=
and()` to free a payload page to the wrong mempool.
--

commit ba587f7eceae0f0ec53afb6d48daeb8d25456542
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: sd: fix special_vec mempool leak when scsi_alloc_sgtables() fails

sd_set_special_bvec() allocates a special payload page for UNMAP and
WRITE SAME commands.  If scsi_alloc_sgtables() fails afterward in
sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
midlayer does not call uninit_command() because RQF_DONTPREP is not
set yet, leaking the page.

Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
freeing the page.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b096ea237f14a..6f05e7683df6d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -958,6 +958,21 @@ static unsigned char sd_setup_protect_cmnd(struct sc=
si_cmnd *scmd,
>  	return protect;
>  }
> =20
> +static void sd_uninit_command(struct scsi_cmnd *cmd)
> +{
> +	struct request *rq =3D scsi_cmd_to_rq(cmd);
> +	struct scsi_device *sdp =3D cmd->device;
> +
> +	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
> +		return;
> +
> +	if (sdp->sector_size > PAGE_SIZE)
> +		mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
> +	else
> +		mempool_free(rq->special_vec.bv_page, sd_page_pool);

[Severity: High]
This is a pre-existing issue, but can checking sdp->sector_size here cause a
page to be freed into the wrong mempool if the sector size changes
concurrently?

In sd_set_special_bvec(), the page is allocated based on sdp->sector_size:

	if (sector_size > PAGE_SIZE)
		page =3D mempool_alloc(sd_large_page_pool, GFP_ATOMIC);

Concurrently, sd_revalidate_disk() calls sd_read_capacity(), which updates
sdkp->device->sector_size directly before the block layer queue is frozen:

	sdkp->device->sector_size =3D sector_size;

If sdp->sector_size is modified and crosses the PAGE_SIZE boundary while an
UNMAP or WRITE SAME request is in flight, could sd_uninit_command() read the
new size and free the page to the wrong pool? This might be reachable by a
malicious USB device returning a different sector size upon a media change.
Since sd_large_page_pool uses high-order allocations, freeing an order-0 pa=
ge
into it could corrupt the page allocator and cause subsequent allocations to
write out of bounds.

> +	rq->rq_flags &=3D ~RQF_SPECIAL_PAYLOAD;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623100159.4018=
066-1-yangxiuwei@kylinos.cn?part=3D3
