Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD823ACA71
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409825; cv=none; b=QV7sdTOlcLvMAJLWQ8GIrwpXtKLGtCnNc6iWT/WVBJW05qfTOrrq3IVmYcjatlhc0aKlPrKlpPFWhmxdDRkIaS60CRFGO3KRoBxN0WIYuVhUWv/7BZRqaKS97jg6nJ8xn80HWKjbl5cDLuR9udCZom1lVV13fNqy6kOXl9A/zMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409825; c=relaxed/simple;
	bh=XxtJSwBvT+MI12+oQ/Hw2xgi0txEGBNo+i4w0oAYoy4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Htgv7Y/L1+yraPI2371izIHUH0lE7I70/qA1TTA9+6+EZ8e7KaaIb1YD3uAVV8e7wBFvtFNYU4adviFQyEbDhC6vF+Eu6Ba1D88m/ZMuw6weDLH2WMj4sHslyIvoE3UUReMK4oGDgR2w1xy6U7cKb56cReGPNskMtuL6r4E4ee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeexPT17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeexPT17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECA01F000E9;
	Tue,  7 Jul 2026 07:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409824;
	bh=3ISMWDOtsjE8T7ZeLZkCYl6XhrA6Bp3hRmHqjyn846c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeexPT17ruOVZkhzmJW6FOeQzzTx2D+lVpw40ZKGsKuYo3Wc6hD0ch8yyyRCrUqS4
	 tVNWshk3HR7r4Bq/lYKIIJYEZLR4kHtQOdD6xm2+Ox9hRI9XOPha1kRhFwmgIGJ75j
	 g+9RGTciizmcH/PdxG02xPMA6tLwuww34HOc8bnuE/1ninM1tws+XYSqSnpvK5rBKo
	 UitewU20wZHBYH5aEHJw5WETEU7bsxqxnE7WisaybS/C83jDcy9WKlbXjuhSz/uZLH
	 SleVbHdvVrzBbZ9VWC7LKvXG09Ts5GMjHdpFAMi7E7sggd4e6g3WqlOA4Ov6uTK/Sd
	 VNLIF1o/UvApg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 84/88] scsi: qla2xxx: Zero-init bsg stack buffers to
 avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-85-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-85-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:37:03 +0000
Message-Id: <20260707073704.2ECA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `qla24xx_iidma` BSG handler fails to validate `bsg_job->reques=
t_len`, leading to heap out-of-bounds read and write vulnerabilities when p=
rocessing a short request.
- [High] Missing bounds check on user-supplied `i2c->length` in `qla2x00_re=
ad_i2c` allows kernel stack buffer overflow and DMA memory corruption.
--

--- Patch [84]: [PATCH v3 84/88] scsi: qla2xxx: Zero-init bsg stack buffers=
 to avoid info leak ---
commit e991f43fbeb0a4f289a4242fcd01f28211667aba
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak

This patch zero-initializes the stack buffers in several qla2xxx bsg handle=
rs
to prevent leaking stale kernel stack memory to user space on short request=
s.
It explicitly sets the bsg arrays to zero at declaration across the handler=
s.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 55142df30bda7..cb7227298b24b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
[ ... ]
> @@ -2163,7 +2163,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
>  	int rval =3D 0;
> -	uint8_t bsg[DMA_POOL_SIZE];
> +	uint8_t bsg[DMA_POOL_SIZE] =3D {};
>  	struct qla_i2c_access *i2c =3D (void *)bsg;
>  	dma_addr_t sfp_dma;
>  	uint8_t *sfp =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);

[Severity: High]
This is a pre-existing issue, but does this function lack a bounds check on
the user-supplied i2c->length?

In qla2x00_write_i2c(), there is a check to ensure i2c->length is not larger
than sizeof(i2c->buffer). However, in qla2x00_read_i2c(), the unvalidated
i2c->length is passed directly to qla2x00_read_sfp():

    rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
        i2c->device, i2c->offset, i2c->length, i2c->option);

Could this instruct the firmware to perform a DMA transfer larger than the
allocated sfp buffer?

Following that, the unbounded length is used in memcpy():

    memcpy(i2c->buffer, sfp, i2c->length);

Since i2c points to the local bsg stack array, could a length greater than
248 bytes cause a kernel stack buffer overflow?


While reviewing the BSG handlers in this file, I also noticed another
pre-existing issue in qla24xx_iidma().

[Severity: High]
This is a pre-existing issue, but does qla24xx_iidma() fail to validate
bsg_job->request_len?

In qla24xx_iidma(), port_param is derived by appending the size of the
request header to the user-supplied bsg_request:

    port_param =3D (void *)bsg_request + sizeof(struct fc_bsg_request);

If a user provides a short request where bsg_job->request_len is not
sufficiently large, port_param points past the end of the buffer.

The function then passes &port_param->speed to qla2x00_get_idma_speed():

    rval =3D qla2x00_get_idma_speed(vha, fcport->loop_id,
            &port_param->speed, mb);

Could this result in an out-of-bounds heap read and write when the speed
is read from or written to the out-of-bounds location?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D84
