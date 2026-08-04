Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB8536B92A
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785857354; cv=none; b=eBT7o/HgGM5NLLY7rO0x902DkUav3VojFYyMMEsZDnR+/UG1zy6cUOFPdOCqoP4g+CIfrkLKLcABMkSrJBhbAwizp7qaXW+70Na0kYpuq/NsarPGyTN8j1LKvFzWkmAB8vzTiusM0pBOuRlrCJx8FZ8NpubKK9eBljznVgmJPJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785857354; c=relaxed/simple;
	bh=HgQc9uI3TNSWxf00MQKPai+nYaIf826u+ikUimaeMeI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=okItLz1kUyz81di5NJoaW5CBv6sBiXM7gqMOdxDtbdIdbzOvkXlJDuQIeCo+A01sNojEXaNHVR2lSL+cvczMlOHcPdEIO2vHhX/HI84KFBdqVXj9yvxnsd1MIFufseFb9tXuJ4G2t85Bgh/0HRW/gMJ3aibG7P8h7W21u6ioGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+vv2LVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+vv2LVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB251F000E9;
	Tue,  4 Aug 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785857352;
	bh=ij9vt2fuGCZKkdDHR28qBD9WKIHvTwpEE9m4x0PTRBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L+vv2LVphaHbJBnHwk6+aphSkD2HOV2hUCkSwpdERFtItDCZEg3KHawZ3wvgD/zYL
	 b6EQcR0sAeILixYbAAS+0Rtb5Hi9Y1S3BF5vLgqLfJ+a7AEEbfkdVQERi+/PKr4+zl
	 sfIVlDRpUvtR5A1DbQHfesAVK6aGddaA1fqxkl3oUQghFeGLcKaQeXxurUOJGuoEYM
	 8QhKTQac42578VNLTeHg4qb/PsEhJjOmzL1G1+eEKzD0jtZMf2nUZzkE3lUuf4hUtl
	 Us2S66JTswde1XnyTcrvkHTYfsMKj5zUCwGvWIQFVJ0bCSlNHvOrUNdrfFs9ORuRid
	 YwQj2m2kKziUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilya Khomyakov" <khomyakovilya@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804142831.4365-1-khomyakovilya@gmail.com>
References: <20260804142831.4365-1-khomyakovilya@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 15:29:11 +0000
Message-Id: <20260804152912.5DB251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly introduced `mpi3mr_sas_phy_bit` function uses `WARN_ON_O=
NCE` to validate firmware-provided PHY identifiers, which creates a kernel =
panic vector if `panic_on_warn` is enabled.

Pre-existing issues:
- [High] Incorrect casting of `u64` bitmask to `unsigned long *` for `for_e=
ach_set_bit()` causes incorrect PHY IDs on 32-bit big-endian architectures,=
 leading to array out-of-bounds access.
- [High] A malicious or compromised firmware can trigger a heap buffer over=
flow in `mpi3mr_refresh_sas_ports()` by providing a `num_phys` value greate=
r than 64.
--

--- Patch [1]: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe ---
commit ceebecd676e904ef112074dffb72b70397933c87
Author: Ilya Khomyakov <khomyakovilya@gmail.com>

scsi: mpi3mr: make SAS port PHY masks 64-bit safe
   =20
This patch fixes 64-bit PHY-mask handling in the Broadcom MPI3 Storage
Controller driver under drivers/scsi/mpi3mr/. It introduces helpers to avoid
undefined behavior when constructing 64-bit PHY masks using signed 32-bit s=
hift
operations.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..d6492dddf7352 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -11,6 +11,42 @@
> =20
>  #include "mpi3mr.h"
> =20
> +/**
> + * mpi3mr_sas_phy_bit - build a bit for a firmware PHY identifier
> + * @phy_id: Firmware PHY identifier to represent in a 64-bit port mask
> + *
> + * The port mask is a u64, so every shift must be performed in a 64-bit
> + * unsigned type. Reject identifiers that cannot be represented before t=
he
> + * shift to avoid undefined behavior.
> + *
> + * Return: BIT_ULL(@phy_id) for a representable identifier, otherwise ze=
ro.
> + */
> +static u64 mpi3mr_sas_phy_bit(u8 phy_id)
> +{
> +	if (WARN_ON_ONCE(phy_id >=3D sizeof(u64) * 8))
> +		return 0;

[Severity: High]
Can this allow malicious or buggy firmware to trigger a kernel panic?

The phy_id originates from the device firmware. If a compromised or buggy
device provides a num_phys >=3D 64, the driver iterates through these and p=
asses
them to mpi3mr_sas_phy_bit(), triggering WARN_ON_ONCE().

Kernel guidelines prohibit using WARN_ON macros to validate external or
hardware-provided data because it allows an external entity to crash the
system via a Denial of Service if panic_on_warn is enabled.

[ ... ]
> @@ -1765,7 +1805,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
>  		port_idx =3D host_port_count;
>  		h_port[port_idx].sas_address =3D le64_to_cpu(sasinf->sas_address);
>  		h_port[port_idx].handle =3D attached_handle;
> -		h_port[port_idx].phy_mask =3D (1 << i);
> +		h_port[port_idx].phy_mask =3D mpi3mr_sas_phy_bit(i);
>  		h_port[port_idx].iounit_port_id =3D sas_io_unit_pg0->phy_data[i].io_un=
it_port;
>  		h_port[port_idx].lowest_phy =3D sasinf->phy_num;
>  		h_port[port_idx].used =3D 0;
>  		host_port_count++;

[Severity: High]
This isn't a bug introduced by this patch, but can a malicious or compromis=
ed
firmware trigger a heap buffer overflow here by providing a num_phys value
greater than 64?

Earlier in mpi3mr_refresh_sas_ports(), h_port is allocated with a hardcoded
size of 64 elements on the heap:

    h_port =3D kzalloc_objs(struct host_port, 64);

The loop that populates it iterates up to mrioc->sas_hba.num_phys, which is
parsed directly from the firmware's SAS IO Unit Page 0 (as an 8-bit value,
allowing up to 255).

If the firmware reports more than 64 phys and provides distinct attached
handles for them, host_port_count (tracked via port_idx) will exceed 63.
This directly results in unconstrained out-of-bounds heap writes when
initializing fields like h_port[port_idx].sas_address.

[Severity: High]
This is a pre-existing issue, but does the incorrect casting in
mpi3mr_update_mr_sas_port() cause array out-of-bounds access on 32-bit
big-endian architectures?

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_update_mr_sas_port() {
    ...
    for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) {
        mr_sas_phy =3D &mrioc->sas_hba.phy[i];
    ...
}

In mpi3mr_update_mr_sas_port(), phys_to_be_added is a u64 bitmask. On 32-bit
big-endian systems, unsigned long is 32 bits, and the cast points to the
most significant 32 bits (bits 32-63) of the u64.

for_each_set_bit() processes this as bits 0-31, effectively swapping the
lower and upper halves of the 64-bit mask. If a PHY ID < 32 is set, it
will be interpreted as PHY ID >=3D 32, which causes out-of-bounds access
to dynamically allocated arrays like mrioc->sas_hba.phy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804142831.4365=
-1-khomyakovilya@gmail.com?part=3D1
