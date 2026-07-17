Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5CE370D49
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304209; cv=none; b=t3oLvyI/xbOsyORjm5++j1PE0Fq7Xdb3v0JmRk6sHXWSn0035g3VvSGyO/ZazYyAxVJKQxiJznzLKfBNQeeqmbJG7TBF4bHg3HWR7kaxCk2hSZTTPfkQAlL+whPDjVfIPOxnl/PD8V3Y94Y2ZJhU0QKkUZezDLdzZwotP5p4vJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304209; c=relaxed/simple;
	bh=pWsw4+6y1mLHE9L3qy3TbRuLitRUT05arjvkIHe6+sI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gwpiQofausNmWSnSC2SDmYTQblNzNiR41u5sPhHyjJ8hCsDgTd1yfAK5/rtog3fEKLG1fOlmUKnu6Bi1xDl6waEEDZHtyZBgCbg6m/jRHDt9gDJRJtPEFjdOW3+Sj2CRq+KeM1yZKg7yJcwFlcQSj5gtZaM2Pz67aAklsBlInZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAlHApWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAlHApWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96761F000E9;
	Fri, 17 Jul 2026 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304208;
	bh=sTg7djzpYJFbj5oOcCIUTaL0P1YTRO3Bw574hpMHH0M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YAlHApWgt4614PVyJ0bYoV7RHRM5myfyx9vfbZfTI7g7LS30tGGmn65r8SeKKOhME
	 YoRDg3WVFIk3qU1K+DzZgbOOwCIeKc3vJYlG2U1RBX3IXFkCIFKtMjdVtun+N4aNjY
	 yGxtz0A0szyCI12a8oXw3eTpkTKLlKdEuv9mw2TPwsJaLwa9hKxi4d9u+cCWXmBRGM
	 8tQUvJaS0kFKjNkwTH85zJ6Hq6b3utbCdxQe6tfUA3QSy4Oodw9uPIyYqHJODuhDgG
	 NY+Ne5n1KoTkuek2qShWoXap1LU4TxyAs97Erbu+tH6AT+wmEDgnGf7IXS9UqC94Zx
	 08af6Nxse6jDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 23/56] scsi: qla2xxx: Use ring-slot helpers in
 __qla2x00_alloc_iocbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-24-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-24-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:03:27 +0000
Message-Id: <20260717160327.E96761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the refactored c=
ode retains a dangerous flaw: the driver uses the standard library `memset(=
)` function to zero an IOCB slot that, for QLAFX00 adapters, resides in PCI=
 MMIO space. In `__qla2x00_alloc_iocbs()`, `qla_req_ring_slot()` retrieves =
the ring slot pointer and assigns it to `pkt`. For QLAFX00 adapters, the re=
quest ring is mapped directly into device memory (`req->ring =3D (void __fo=
rce *)ha->iobase + ha->req_que_off;`), meaning `pkt` is an `__iomem` pointe=
r. Calling `memset()` on MMIO memory can generate unaligned or byte-wise bu=
s transactions. On strict-alignment architectures like ARM64 or SPARC, this=
 triggers a synchronous external abort (kernel oops) and crashes the system=
. The subsequent `if (IS_QLAFX00(ha))` block correctly casts the fields bac=
k to `__iomem` to use `wrt_reg_byte()` and `wrt_reg_dword()`, demonstrating=
 that the memory is indeed MMIO, but the unsafe `memset()` remains.
--

--- Patch [23]: [PATCH v5 23/56] scsi: qla2xxx: Use ring-slot helpers in __=
qla2x00_alloc_iocbs ---
commit 30045e77ead5341377665972b3b6c891e41c1958
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

This commit refactors __qla2x00_alloc_iocbs to use qla_req_ring_slot()
and qla_req_entry_size() helpers for ring pointer selection and entry
size. It consolidates the branching logic for QLA29XX and standard
adapters into a unified memset.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index aab7905c0d6ca..1ca50fc200d65 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c

[ ... ]

> @@ -2530,13 +2529,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb=
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
This isn't a bug introduced by this patch, but could using the standard
memset() here cause unaligned or byte-wise bus transactions on QLAFX00
adapters?

For QLAFX00, the request ring is mapped directly into device memory, meaning
pkt points to __iomem. The subsequent if (IS_QLAFX00(ha)) block correctly
casts the fields back to __iomem to use wrt_reg_byte() and wrt_reg_dword(),
demonstrating that the memory is indeed MMIO.

Could calling memset() directly on this MMIO pointer trigger a synchronous
external abort or alignment fault on strict-alignment architectures like
ARM64 or SPARC, since it is not using an I/O specific function like
memset_io()?

>  	if (IS_QLAFX00(ha)) {
>  		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
>  		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D23
