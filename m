Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9BC39AD51
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405569; cv=none; b=MvvylpCkHU1g664DKaoOwSjjdcNjGU8wXgs3pTl/vXI40IMYu4Ybqo2G/WE/RKc0miktn+feHiiJX+9NM1wmAw92Mm5JyLSvCN13wXnhCh3l5+GcbggoZLRL/Yjjb9Ze3P2jx9n2W+lBd/IWxwLk7jVURrPqBnWd5aLOrWy63C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405569; c=relaxed/simple;
	bh=r69i0tOwMzjFr625IO/O2jXFQPOhZhF4AhakNwfjj3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JV3k3tIpE/Bdof/QEXFQzGYR8yOSxi4loyb2kc7y757/6zGlOZXAdtCws5/RtFjJtP8W5FpmN9NKF32Y6o7htZXPfnJOLrEtUW6jnZtGMRKYz+euNnSD9Nj8c3YIuWqpiKh5/8YSCejC+hRz+Y7f6+0cKOgrVa2z60REAj9KgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgBTiaci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgBTiaci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA381F000E9;
	Tue,  7 Jul 2026 06:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405567;
	bh=93sKdr2ye2IdcFB0RzUXCzqiNyUmhZSMfqNwBSej7P4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AgBTiaciS1Bh6E+tXjzVdBrikrRODbd/uf8BeXEKiDwbuBzFtDrifGNRArvSwvHvv
	 gWeWvqNYQWycjq29QuxuDNi25ksqcba4Q0zv+IYpmeY3EsnenuFxn+TIFh5uVLRJGP
	 3vYPBM4piOEx4ADdoylyIwNz7iUwA62dXIbCJD+RUGYZXD6T3oJjYEVxkS21yow8N/
	 sr0mpmBAH2dHC/iNUBi5rA0+yX/z+H4qo2sYbrz26Mzfs5m/82NZ4A4zDsL7lT8S3J
	 B15rDra1xeama+KSLKhE0/q57DQPUYxu3uKYJ4cML/ULTfVxkiBP7xm6+UmMMiA6JE
	 5jyxbxLhu1q0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 23/88] scsi: qla2xxx: Use ring-slot helpers in
 __qla2x00_alloc_iocbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-24-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-24-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:26:06 +0000
Message-Id: <20260707062607.5BA381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Standard memset() is called on memory-mapped I/O (MMIO) addresses =
for QLAFX00 adapters instead of memset_io().
--

--- Patch [23]: [PATCH v3 23/88] scsi: qla2xxx: Use ring-slot helpers in __=
qla2x00_alloc_iocbs ---
commit d9b770194269becaf782d0cbaf7f08d1fbe9ade7
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

This commit refactors __qla2x00_alloc_iocbs() to use the qla_req_ring_slot()
and qla_req_entry_size() helpers. This removes open-coded ring pointer
selection and simplifies the IOCB memory zeroing logic.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 13882a399fbc5..c0cec1f74dfc5 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -2454,13 +2453,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb=
_t *sp)
>  	 * layout-compatible once we return the pkt as request_t *.
>  	 */
>  	req->cnt -=3D req_cnt;
> -	if (IS_QLA29XX(ha)) {
> -		pkt =3D (request_t *)req->ring_ext_ptr;
> -		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
> -	} else {
> -		pkt =3D req->ring_ptr;
> -		memset(pkt, 0, REQUEST_ENTRY_SIZE);
> -	}
> +	pkt =3D qla_req_ring_slot(ha, req);
> +	memset(pkt, 0, qla_req_entry_size(ha));

[Severity: High]
This is a pre-existing issue, but does this standard memset() call cause
faults on strict architectures when using a QLAFX00 adapter?

In qlafx00_config_queues(), req->ring is initialized as an __iomem pointer
for QLAFX00 adapters:

qlafx00_config_queues() {
    ...
    req->ring =3D (void __force *)ha->iobase + ha->req_que_off;
    ...
}

Since qla_req_ring_slot() returns this __iomem pointer for QLAFX00, calling
memset() instead of memset_io() could trigger unaligned access faults or
unsupported memory transactions (such as Synchronous External Aborts on
ARM64) when allocating an IOCB.

>  	if (IS_QLAFX00(ha)) {
>  		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
>  		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D23
