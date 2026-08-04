Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845A3AD527
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785854349; cv=none; b=GMVWvAM7Cut2VbFj7EHRT7nWLPIQBVj9mImS/LMucQIolz2mejwt7s/OouhL8NYXbjj2QffzLAMrEYL+ZXqy3+umM9x4G+n5FnDpIZba1dF65UCgx8uoPuABBy0xXBpPzEyT5jRi8oVBukg84JGMaWH7Xgl0p55j85zU04XNafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785854349; c=relaxed/simple;
	bh=VyZ/J3k/uAe5+L4QV5upPclMLRpFN2CF/7zqxLckDLY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C+gVqMrusKh0WqKl2CrukpJThRpPZXiPy3qp0b2nUIajd/dOXnVutTi6ZzHCCeZAYczXvMt8+ouPxx9M/84dPgXo7BCuBdlhN331XFpg4BINeqcCxOByct3vRAmmlYGdgMq2IXGopdwksUe849+gGADXSupUu/LlXPinvXYJH4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9UMaTsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9UMaTsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3AA1F00A3A;
	Tue,  4 Aug 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785854347;
	bh=PlIfXBcoOBL1CPCE6FTR2+8v+6v0HsXA5pZGRzqvNqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G9UMaTsnVoL5/cbxC/1vrboktMhljmHNGrQsTHG71jzIbyIoA2A19TJ1MrvBA6WEv
	 xSPEnV/ntQDyOBGXIFKfOKfBoRgREIQPTnP38MLXsZh4g7lwAPUVqTGo3BMaSJpAXD
	 T8IcvJNpts9wSDIsvLKJJZv6svenWFZ8FSlveNkFUpoCWvZ5m9+hEQnGlSiM+tfYa7
	 9HFjMz4+GFDy1runZjqutcCvkU4wNrKu0TrCXOLtnzjX7a35J3rwTA6EonSxyhhH0l
	 tFwMZgdoqhW2ZRVDqb3a/FvsNDau4eKQJxj/XOFg7c5i2tQWllHARMjFu7zdelqkg6
	 r1UGbnClRrZxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilya Khomyakov" <khomyakovilya@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804140004.4004-1-khomyakovilya@gmail.com>
References: <20260804140004.4004-1-khomyakovilya@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 14:39:07 +0000
Message-Id: <20260804143907.9B3AA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect bit iteration over a `u64` variable using `for_each_set_=
bit` in `mpi3mr_update_mr_sas_port`.
- [High] Out-of-bounds heap write in `mpi3mr_refresh_sas_ports` when a cont=
roller firmware reports more than 64 unique PHY connections.
--

--- Patch [1]: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe ---
commit f7b3b6c83f03cd4dace1e13e5700d80724e506b0
Author: Ilya Khomyakov <khomyakovilya@gmail.com>

    scsi: mpi3mr: make SAS port PHY masks 64-bit safe
   =20
    This patch fixes 64-bit PHY-mask handling in the Broadcom MPI3 Storage
    Controller driver under drivers/scsi/mpi3mr/.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..d6492dddf7352 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c

[ ... ]

> @@ -1765,7 +1805,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
>  		port_idx =3D host_port_count;
>  		h_port[port_idx].sas_address =3D le64_to_cpu(sasinf->sas_address);
>  		h_port[port_idx].handle =3D attached_handle;
> -		h_port[port_idx].phy_mask =3D (1 << i);
> +		h_port[port_idx].phy_mask =3D mpi3mr_sas_phy_bit(i);

[Severity: High]
This isn't a bug introduced by this patch, but can the h_port array overflow
when iterating over the PHYs in mpi3mr_refresh_sas_ports()?

The array is allocated earlier in the function with a fixed size of 64:

	h_port =3D kzalloc_objs(struct host_port, 64);

Since the loop iterates up to mrioc->sas_hba.num_phys times (which is an
8-bit integer allowing up to 255), and host_port_count is incremented for
each unique attached handle without bounds checking, will this write out of
bounds if the firmware reports more than 64 unique PHY connections?

[Severity: High]
This is also a pre-existing issue, but since we are making PHY masks 64-bit
safe, is the bit iteration over the u64 mask in mpi3mr_update_mr_sas_port()
working correctly on 32-bit big-endian architectures?

mpi3mr_update_mr_sas_port() uses for_each_set_bit with a cast to ulong *:

	u64 phys_to_be_added, phys_to_be_removed;
	...
	for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) {
		mr_sas_phy =3D &mrioc->sas_hba.phy[i];

By casting a local u64 pointer to unsigned long * on 32-bit big-endian
systems, won't the bit halves be swapped? This could result in out-of-bounds
array accesses on mrioc->sas_hba.phy[i] and incorrect topology changes since
bits 0-31 become 32-63 and vice versa.

>  		h_port[port_idx].iounit_port_id =3D sas_io_unit_pg0->phy_data[i].io_un=
it_port;
>  		h_port[port_idx].lowest_phy =3D sasinf->phy_num;
>  		h_port[port_idx].used =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804140004.4004=
-1-khomyakovilya@gmail.com?part=3D1
