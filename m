Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8403115AE
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077274; cv=none; b=eRcm4S5YmKyZeIZ0emT0Dwnm1l9AaH3JsJGM6MjvyJWg7uIpl+sAlGVhFqupsVwW88j/bNHxCXQuCX11rdrBdYozYKHCLtFlVkkaCAUy9SmaFKb3BVO5jHJ9BJbM7bnbSHxsJC7v5NlsRHuPJ4kKKYI5HnlYZ3vWK/CYyGUfIUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077274; c=relaxed/simple;
	bh=v7ATPaPCDypxNFvoUBe4ZusJN/i4+3BL844KPjpFgLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gRox4nStAr81b61NEuXUV4Czl1R8FCd+kXbck4yklAuVCk1XVogPLRq9pwJZz0jGXjYZfCjRwOM8WHTua30Bu53d9gS3OjUo3N+9HpXG4IUAB6vRHjbP3OxbjRKePwlLHVzF1wal7gEpESaZCY+oIFodH0XJ0kKLZPDc7O+GVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNYMBZWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNYMBZWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AB51F000E9;
	Tue, 18 Aug 2026 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077273;
	bh=77D69DhFHQx5YhlKseZszQhQFH3kwh5R8RWa2CYYQOo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kNYMBZWWxXi6cDQKk8hHg/ekD8jp3sRxn++Y5MiphVFnmDQLHGcEGaXVh/i+tj/4Q
	 uRspQo0EzddQ69WesMF4MN4Sdamatx114JD2EOu66Nqh1SenrwcYqoiZ7qIPhwHNoc
	 RxP8MP0W4UqS7Gy93yMTa5F6EgzA/sshulqc/7jMk4y9UOmU/YWcCUeKS9xoMAr9eU
	 JhFWL300dOApzccrtqKG3ON+07ZHnA9LS/wz9PVgv7+O8+4xDYjf2lpuDmGKvMQub6
	 E7y3HQNwRBJ2E2gdOO6sGPT4HWKC7Rj4IruivDhVV+ZNVdQf+TuJ2y1iWdVcj7wcPL
	 8OHXXlEh8XoAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/17] mpi3mr: zero out diagnostic buffer status memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-16-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-16-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:21:13 +0000
Message-Id: <20260818182113.87AB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An integer overflow in the bounds check of `mpi3mr_bsg_upload_hdb`=
 allows a malicious user to bypass the check and read arbitrary kernel memo=
ry.
--

--- Patch [15]: [PATCH 15/17] mpi3mr: zero out diagnostic buffer status mem=
ory ---
commit 76872b40f16cd1ab1c93f0a03cc6bd1fb6b3db94
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: zero out diagnostic buffer status memory
   =20
Memory allocated for the BSG diagnostic buffer status is not zero'd
before it is copied back to user space. Several fields in this
structure are reserved and never written by the driver. Use kzalloc
instead of kmalloc to zero out the allocated memory.
   =20
Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index f5b48c95cf055..0cdcb8d236d37 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1244,7 +1244,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc =
*mrioc,
> =20
>  	length =3D (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
>  		    sizeof(*hbd_status_entry)));
> -	hbd_status =3D kmalloc(length, GFP_KERNEL);
> +	hbd_status =3D kzalloc(length, GFP_KERNEL);
>  	if (!hbd_status)
>  		return -ENOMEM;
>  	hbd_status_entry =3D &hbd_status->entry[0];

[Severity: High]
This is a pre-existing issue, but while reviewing this file I noticed a
potential integer overflow in mpi3mr_bsg_upload_hdb():

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_upload_hdb() {
    ...
	if ((upload_hdb.start_offset + upload_hdb.length) > diag_buffer->size) {
		dprint_bsg_err(mrioc,
		    "%s: invalid start offset %d, length %d for type %d\n",
		    __func__, upload_hdb.start_offset, upload_hdb.length,
		    upload_hdb.buf_type);
		return -EINVAL;
	}
    ...
}

Can upload_hdb.start_offset and upload_hdb.length wrap around during additi=
on?

Since they are 32-bit unsigned integers controlled by user space via the BSG
interface, a large start_offset (e.g. 0xFFFFFFF0) and a small length
(e.g. 0x20) could wrap to a sum that passes the bounds check against
diag_buffer->size.

Would this allow a malicious user to bypass the check and read arbitrary ke=
rnel
memory when the subsequent copy occurs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D15
