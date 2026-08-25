Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F7533D6FC
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674101; cv=none; b=Krh8u2jQc+5CLBdqbD6wAudoy+bha25Uyb5E1EZfDsV0RxIComgeoMvKI0iHSuU+NvPo2vymz1+jbUR8/HJ4TXsO8fjA8joH6sUMZfpqOnF+/yGMZFf2zV4tG1gcGv2JN2ZP05hjZPRuu2EnOqOfZlohu7F8xJcwK7RAVBJRVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674101; c=relaxed/simple;
	bh=HvcWKb+xmD7lyzossXTNKq5oUWz/sngwxx6YL8Q7/xo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ke/dNWib6xQz9Y3TCueXru87n3EYZRL5tvTA9VTBEmQQwHxdhTMgrCmPEywWB/My3spj9l01Vz5CE9eoZZ+ISbvoqt9DVV1ASFSqPO3Xdh2UWKd8ubyi66ym5cBd9AIAmaHRh6/FwgHbFJSOSyVt2iyg6gKX79PsTqJgvXHiLoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ux/1k3HB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux/1k3HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689021F000E9;
	Tue, 25 Aug 2026 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674099;
	bh=kcDTOyYnKb34dfKu1/QpNKmgpTK1s80JWArzB2Y6Pcc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ux/1k3HBUEXtCyxR2BgocBI64WCNhpkuWFh5FQxzXdh7m/finru8vbhZuY6DYMUcw
	 BMEHDByvhReCPJjGHefMdvLPKqDmXxbEM6ihNlG8ciIYBCSCQCPN77J0krb2PJ0pEJ
	 WgAi52WMzoco0FOw/8pg+KEy1zYhWgYcmJdu8w7WfZaRsTy8oWGB1c8zzo18I2T4TK
	 fe6X5NszR3ZUxXdBLdZxQR9EgtnSKWwdfnCjI4BT2xKslypyJQRYMXYwvcwbRaTH2H
	 DRDqT8QvKZ2RXavNyi4KgN09jDo5JtrjhMRGmTFbH6C79gcfCJ11LmuaIJv4ddjcpV
	 8S7DhSPHyLu9A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/17] mpi3mr: Fix out-of-bounds sense buffer access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-8-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-8-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:08:18 +0000
Message-Id: <20260825160819.689021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds reply_dma addresses are reposted back to the firmwar=
e in the admin queue, allowing potential memory corruption.
- [High] Missing `dma_rmb()` after polling the DMA completion queue phase b=
it allows the CPU to read stale descriptor and sense data on weakly-ordered=
 architectures.
--

commit 9016299b1f02eb19e9cbac5395a3c1dc0ee4a8cc
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds sense buffer access

The sense buffer address reported on completion is turned into a
virtual address with no range check, so an address outside the pool
resolves to memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 82fadb4d2b21f..5c2547bb67a52 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -142,9 +142,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *=
mrioc,
>  void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
>  	dma_addr_t phys_addr)
>  {
> +	u64 offset;
> +
>  	if (!phys_addr)
>  		return NULL;
> =20
> +	offset =3D phys_addr - mrioc->sense_buf_dma;
> +
> +	if (phys_addr < mrioc->sense_buf_dma ||
> +	    (phys_addr > mrioc->sense_buf_dma +
> +	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_S=
Z) ||
> +	    do_div(offset, MPI3MR_SENSE_BUF_SZ))
> +		return NULL;
> +
>  	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
>  }

While reviewing this patch, I noticed some pre-existing issues in the drive=
r:

> static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
> 	struct mpi3_default_reply_descriptor *reply_desc, u64 *reply_dma)
> {
[ ... ]
> 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
> 		addr_desc =3D (struct mpi3_address_reply_descriptor *)reply_desc;
> 		*reply_dma =3D le64_to_cpu(addr_desc->reply_frame_address);
> 		def_reply =3D mpi3mr_get_reply_virt_addr(mrioc, *reply_dma);
> 		if (!def_reply)
> 			goto out;

[Severity: High]
This is a pre-existing issue, but does mpi3mr_process_admin_reply_desc()
leave *reply_dma populated with an invalid physical address when
mpi3mr_get_reply_virt_addr() returns NULL?

If def_reply is NULL, the code jumps to out without clearing *reply_dma.

Then in mpi3mr_process_admin_reply_q():

> 		mpi3mr_process_admin_reply_desc(mrioc, reply_desc, &reply_dma);
> 		if (reply_dma)
> 			mpi3mr_repost_reply_buf(mrioc, reply_dma);

Since *reply_dma was not cleared on error, doesn't this result in the
unvalidated or out-of-bounds address being blindly reposted to the hardware
via mpi3mr_repost_reply_buf()?

This could poison the hardware's reply free queue with arbitrary host
addresses, potentially allowing memory corruption during future DMA writes.


I also noticed another pre-existing issue in the polling logic:

> static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
> {
[ ... ]
> 	if ((le16_to_cpu(reply_desc->reply_flags) &
> 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> 		atomic_dec(&mrioc->admin_reply_q_in_use);
> 		return 0;
> 	}

[Severity: High]
This isn't a bug introduced by this patch, but is a dma_rmb() missing after
polling the DMA completion queue phase bit?

Without an address dependency between the phase bit and the rest of the
descriptor (since the pointer is already known), weakly-ordered CPU
architectures like ARM64 and PowerPC might speculatively fetch the rest of =
the
descriptor or the sense data before the phase bit read has actually complet=
ed.

The same pattern appears in mpi3mr_process_op_reply_q():

> 	if ((le16_to_cpu(reply_desc->reply_flags) &
> 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> 		atomic_dec(&op_reply_q->in_use);
> 		return 0;
> 	}

And when the sense data is later read in mpi3mr_process_op_reply_desc() in
drivers/scsi/mpi3mr/mpi3mr_os.c:

> 		if (sense_buf) {
> 			scsi_normalize_sense(sense_buf, sense_count, &sshdr);

Could this result in the CPU reading stale descriptor or sense data? A
dma_rmb() seems required immediately after observing the phase bit toggle
across both the admin and operational completion paths.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D7
