Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30949496D2D;
	Wed, 23 Sep 2026 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160312; cv=none; b=XL+FhNAXAvJg9dnKB2cSHdqWmElgJ/gneB/F182Bknxbto4C3/2dYnbgxwT10+V4Gu/33qh0Z8Ayu1k8KIFnyhaBi/JnLS8JTsZFEOk09qM7bqlzgELpqEpaXn3XaQRIaz0Ke8sCnLHcfSeqrC9wESrXhaIvcrhJQ0lKgRiF+F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160312; c=relaxed/simple;
	bh=1+q40tRub3P0xXOmkTmQ57VZhPQHUQdLqRpHmQbS1o4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rV7aTMdQw5PsMj1sEEqzP7q3d00Np/oX/dQXKYGX3Hxcgq6KA3EczpImzeggQB2N2QcYzQ5Sw8CbtMKzVb210o3RqNlHrpGRLc5vqKiTml2X2th+GwDh0d7F03tn83Uavzys80O42GZS8u/5T6oxQ5D6ZWR91eyXJXkZQk6x724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0b1Pf8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0b1Pf8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AC61F000FF;
	Wed, 23 Sep 2026 10:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160292;
	bh=V/FyOS00U5P4MnAxS/g18eVWcJcWYTkCDu4k9jjySc8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q0b1Pf8JWKTvKOiYaA7X0OK2xu6FJM2T8i2x5zyrXRzf2741bXoliGbDkBMDnHYrl
	 /kvHHS6fQJiluaZUxOoUKTo4CPbO9IBHG2QBo8sajIOYrp91hkLGlzYseqVsrGlhqI
	 BeDnl3wZum8zmuVOhX4eZt4PL19puplrden1SW543oxURk1Tf+Nvj4uFCXlJIBaX8p
	 U1Hhju8FqL9OsSyq9sfMqm9qw8lUJ0zv4ZT9YjCOb9tIxm+da2RzbBHXIhlUGru9Cg
	 Qch8j7LZIIy60iPQfAxNCHoHwK8tvq3xPGMPnqOFNjSJU6G0bbE03p/ujY5TpmGx2m
	 Roir+9AMC/sww==
From: sashiko-bot@kernel.org
Subject: Re: [RFC v7 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: lee@kernel.org, linux-scsi@vger.kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <20260923103015.2365773-2-nbg2974@gmail.com>
References: <20260923103015.2365773-1-nbg2974@gmail.com>
 <20260923103015.2365773-2-nbg2974@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 10:44:51 +0000
Message-Id: <20260923104451.B1AC61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] leds: undefined kzalloc_obj() macro usage
- [Low] leds: blk_rq_map_kern() missing request_queue argument
--

commit e0971e949056a90448861cfc243c852426110000
Author: Liang Haowen <nbg2974@gmail.com>
leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit introduces the ASUS Aura RGB LED driver for ROG external NVMe
enclosures. The driver manages the ENE LED controller using vendor SCSI
commands.

> --- a/drivers/leds/rgb/leds-asus-aura-scsi.c
> +++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
[ ... ]
>  static int ene_write(struct scsi_device *sdev, u16 reg,
>  		     const void *data, u8 arg_count)
>  {
>  	struct request *rq;
>  	struct scsi_cmnd *scmd;
>  	u8 cdb[ENE_CDB_LEN];
>  	int ret;
> =20
>  	ene_build_cdb(cdb, reg, arg_count);
> =20
>  	rq =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
>  	if (IS_ERR(rq))
>  		return PTR_ERR(rq);
> =20
>  	if (arg_count) {
>  		ret =3D blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);

[Severity: Low]
Does this code omit the request_queue argument when calling
blk_rq_map_kern()? The blk_rq_map_kern() API requires five parameters,
starting with the queue pointer, but only four are passed here. This causes
a compilation error due to too few arguments.

[ ... ]
>  static int asus_aura_attach(struct scsi_device *sdev)
>  {
>  	struct asus_aura_zone *zone;
>  	int i, ret;
> =20
>  	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
>  	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
>  		return SCSI_DH_DEV_UNSUPP;
> =20
>  	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Is kzalloc_obj() a valid macro or function in the kernel? Using an
undefined identifier here causes a compilation failure when allocating the
primary data structure. The standard API for this allocation would be
kzalloc().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103015.2365=
773-1-nbg2974@gmail.com?part=3D1
