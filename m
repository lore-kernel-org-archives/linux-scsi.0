Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD5D3D47D9
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 07:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123608; cv=none; b=gowsjLW0FCWyXxT/yGhO8NXfQjxIehr8NESoOt4/rZGv9UWKJDm8+o5ho2gyEvPrrI1sAq/g13IOYTQsIdQLGsFANSjRTKaHUjbobVltt2APVsXxXAHeCGi/1HDRQw8lq74yEKxSCxjhkNSM14YwDBt3eg/rxmHKd+zH4oKA8+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123608; c=relaxed/simple;
	bh=5BL78SsW+pxjUsXTNTEwP+EgUlvW7MPaQ9E0hCpMTis=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TwcTkpeENB/6imgkC0PG6DOfbQNkiiHrO7h5PEPqsovpiwnZkzLyOcKjn89iO891LgW0XEKyiOC/VTc5j7qtva+lhvOWDhOVffG8K2AwQDz7qcLs4tk+IUIhd2TtPiuKqm1ig3E98MmvtzWkfyNj7DvN8GiMmC35URDJbrp2LR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gS//eT91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gS//eT91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456301F000E9;
	Wed, 19 Aug 2026 07:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787123606;
	bh=wi0tFVAlYlZPIzkLxQ3JL+YV0LmcRSim7vHXpwXFljI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gS//eT91rYk0/1DEhmlA+hH/PwUsWL/blg0Mo9qQVrxxSfmilIZ3Vz+3ttIYwgLdy
	 Y7gj1VKVvPbT3IhmrXhejlzpM9+kXOLbRXDfczHpPQ8hR9rSIVKtSZMUL9ftSZnVwI
	 +mWD3maLJ+gwTkJvfzmyZiF8wFUJHE45QYPCRsMWceqOUsVP08govbxtm6kWpAaAA9
	 MIVwrCpi6z4VpafjpfBblu2+7LeuDb/ixmeSq60Wz8LSNE2yhi1KZl9+prCR3PBBZq
	 pRpdU6PseWysPf6f7b21k7W38ZphEzaI5d76sncwHbFG2/QICUVubkw4pBmNTT7mlT
	 B1YSEQQ3fXIaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819065850.1358861-2-hch@lst.de>
References: <20260819065850.1358861-1-hch@lst.de>
 <20260819065850.1358861-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 07:13:25 +0000
Message-Id: <20260819071326.456301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Unbounded nested loops in `corrupt_lbas()` executed with preemptio=
n disabled allow users to cause CPU lockups.
- [High] Unconditional dereference of `sip` in `corrupt_lbas()` when initia=
lized with fake I/O (`fake_rw=3D1`).
- [Medium] Flawed map state validation in `corrupt_lbas()` rejects valid wr=
apping corruption requests.

Pre-existing issues:
- [High] Pre-existing out-of-bounds array access in `map_state()` when usin=
g large virtual LBAs.
- [High] Toggling `fake_rw` from 1 to 0 at runtime causes a pre-existing NU=
LL pointer dereference in LBP operations.
--

--- Patch [1]: [PATCH] scsi_debug: add support to corrupt data and/or refta=
g ---
commit b674d4afbf6311bc89a7d69aaa16a3947e8d3546
Author: Christoph Hellwig <hch@lst.de>
scsi_debug: add support to corrupt data and/or reftag

Add a new debugfs file to inject corruptions of the data and/or reftag.
This will be used to detect that protection information and/or file
system checksumming can detect random bit errors or misplaced writes.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3346562275f80..8750e07759306 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -4862,6 +4952,77 @@ static int resp_write_tape(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
>  	return 0;
>  }
> =20
> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> +		u32 nr_bit_errors, s32 reftag_adjust)
> +{
> +	struct sdeb_store_info *sip =3D devip2sip(devip, false);
> +	bool meta_data_locked =3D false;
> +	u8 *fsp =3D sip->storep;

[Severity: High]
Does this unconditionally dereference sip if devip2sip() returns NULL?

If the scsi_debug module is loaded or toggled with fake_rw=3D1, devip2sip()
explicitly returns NULL. The sip->storep assignment then dereferences it
before any validation occurs, which will cause a kernel panic.

> +	u32 block, num_mapped, b, i;
> +	int error =3D 0;
> +
> +	if (sdebug_dev_is_zoned(devip) ||
> +	    sdebug_dix ||
> +	    scsi_debug_lbp())  {
> +		sdeb_meta_write_lock(sip);
> +		meta_data_locked =3D true;
> +	}
> +
> +	if (num > sdebug_capacity || lba > sdebug_capacity - num) {
> +		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
> +		error =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (scsi_debug_lbp() &&
> +	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {

[Severity: High]
This is a pre-existing issue, but can map_state() perform an out-of-bounds
array access when called with large virtual LBAs?

If sdebug_virtual_gb is configured, sdebug_capacity exceeds the physical
sdebug_store_sectors. A command passing a large LBA generates an index
larger than map_size:

drivers/scsi/scsi_debug.c:map_state() {
    ...
    index =3D lba_to_map_index(lba);
    mapped =3D test_bit(index, sip->map_storep);
    ...
}

This causes test_bit and subsequent bit operations to access memory outside
the allocated sip->map_storep array.

[Severity: Medium]
Does this check incorrectly reject valid corruption requests that cross the
physical storage boundary?

If a user requests corruption across the physical store boundary (for examp=
le,
an lba near sdebug_store_sectors with a num crossing it), map_state() limits
the returned contiguous blocks to the physical boundary:

drivers/scsi/scsi_debug.c:map_state() {
    ...
    end =3D min_t(sector_t, sdebug_store_sectors, map_index_to_lba(next));
    *num =3D end - lba;
    ...
}

This causes the num > num_mapped condition to trigger and abort the request,
even though the underlying data loops correctly use div_u64_rem to wrap
around the physical bounds.

[Severity: High]
This is a pre-existing issue, but does toggling fake_rw from 1 to 0 at
runtime cause a NULL pointer dereference in LBP operations?

If fake_rw is toggled from 1 to 0 via sysfs, fake_rw_store() calls
sdebug_add_store() before updating sdebug_fake_rw to 0:

drivers/scsi/scsi_debug.c:fake_rw_store() {
    ...
    idx =3D sdebug_add_store();
    ...
    sdebug_fake_rw =3D n;
    ...
}

Inside sdebug_add_store(), scsi_debug_lbp() returns false because
sdebug_fake_rw is still 1, so sip->map_storep remains unallocated. Once
the transition completes, fake_rw is 0 and LBP becomes active. Any
subsequent command using LBP calls map_state(), which crashes when
dereferencing the NULL sip->map_storep.

> +		pr_err("can't modify unmapped logical blocks: %llu:%u",
> +			lba, num);
> +		error =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * For each possible bit error, flip the same bit in each corrupted
> +	 * block to simulate repeated patterns like errors in cables.
> +	 */
> +	sdeb_data_lock(sip, false);
> +	for (b =3D 0; b < nr_bit_errors; b++) {
> +		unsigned int bit;
> +
> +		bit =3D get_random_u32_below(sdebug_sector_size * BITS_PER_BYTE);
> +		pr_info("flipping bit %u in LBAs %llu:%llu\n",
> +				bit, lba, lba + num - 1);
> +
> +		div_u64_rem(lba, sdebug_store_sectors, &block);
> +		for (i =3D 0; i < num; i++) {

[Severity: High]
Can these unbounded nested loops cause a CPU lockup since they run with
preemption disabled?

A user can write large values for num and nr_bit_errors into the corrupt
debugfs file. The sdeb_data_lock() function calls read_lock(), which
disables preemption. The function then enters these loops, potentially
stalling the CPU for an extended period of time if the inputs are large.

> +			u8 *p =3D fsp + (block * sdebug_sector_size);
> +
> +			sdeb_data_sector_lock(sip, true);
> +			p[bit / BITS_PER_BYTE] ^=3D (1 << (bit % BITS_PER_BYTE));
> +			sdeb_data_sector_unlock(sip, true);
> +			if (++block >=3D sdebug_store_sectors)
> +				block =3D 0;
> +		}
> +	}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819065850.1358=
861-2-hch@lst.de?part=3D1
