Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D82D3B47F4
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 07:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788161273; cv=none; b=hPBh3kKz8o0Ce56aziipikgEoswtsjVafph9p7iHMgBMUGAhBE4LPoHUON2iV6hi/78RVrOMUiWRqcitRXKcOfn2FlyGgfiaoi+NeiCKewIrM4M7UzW0dYluZEzEvIA4Fvml9eSsbqS3ZSeCGSVn9y/ze/BuomJ2KwRQZJ2ppws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788161273; c=relaxed/simple;
	bh=oee+dgqoYaaF2j4n+RCLjyCIiiIc/++4KI5FnkgHTSg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mAhIIbWO3oXxw7Y0RoLcbo+00zippLzubOSkpELD3xbmhrqY4rXUU1DCcZoEwA0RbpGdT4UL9WWdCQLI5NihyYuuvUUZns1hglCdKf4reLiXaIiNKJ7rOmgeCdQKpwN0g1HrJUGNAgjlxBIdhmo6QLQUAUT8cy49a45ArdcOnFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYcNGFK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYcNGFK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B6A1F000E9;
	Mon, 31 Aug 2026 07:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788161272;
	bh=D/1t5xmzSppP3tZHek4JPisY9RcXge+vO0kRJ3G3gzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYcNGFK2yFBugbyBvfX902DeZtClyVmboxVHLBAfrmiu2z2C5LCS2WeUU/oRXksA4
	 xbV6YTzgveBdqSPYWiNuyhh+11LVpYp7Sno4MGp0jzMtBSSH/3dBavG9MVKOlN6j7d
	 AaitsKbdwiZJB3+Z4MgOyj1hhKQo/arLHk5tfr8yaNbKyYEhWrGaWMHybhMcTIlp8q
	 9S6GZnND4msLsDmg5hfb9sBYW6mrrx3jugXwfj50wgTJ3ifDPiTIZ0Fu5Edy1XoGhI
	 Gjl5d/1dIZV12LOtKqqH4trBuHzvGJfTI+3FXUQs+7U09L/BHgFktRAP/OJ2IB5RKt
	 tk6IAiIQZW0vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831064500.2576832-2-hch@lst.de>
References: <20260831064500.2576832-1-hch@lst.de>
 <20260831064500.2576832-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 07:27:51 +0000
Message-Id: <20260831072751.D5B6A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Unbounded loops with preemption disabled, combined with excessive =
kernel logging and wrap-around logic errors, cause CPU lockups and state co=
rruption.
- [Medium] The debugfs write handler passes the raw user-provided count to =
`memdup_user_nul()` without capping it, risking kernel allocator warnings.

Pre-existing issues:
- [High] Out-of-bounds memory read in `map_state()` when Logical Block Prov=
isioning (LBP) and `virtual_gb` are used together.
--

commit 9a79e34fe4a44a1c0a0765e0674426353e4ac98e
Author: Christoph Hellwig <hch@lst.de>

scsi_debug: add support to corrupt data and/or reftag

This commit adds a new debugfs file "corrupt" to inject data and/or reftag
corruptions into scsi_debug devices. This enables testing file system and
protection information mechanisms via random bit errors or misplaced writes.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3346562275f80..959177adfc9a8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> +static ssize_t sdebug_corrupt_write(struct file *file, const char __user=
 *ubuf,
> +		size_t count, loff_t *ppos)
> +{
[ ... ]
> +	u64 lba =3D 0;
> +	u32 num =3D 1;
> +	u32 nr_bit_errors =3D 0;
> +	s32 reftag_adjust =3D 0;
> +
> +	buf =3D memdup_user_nul(ubuf, count);

[Severity: Medium]
Could passing the raw VFS count directly to memdup_user_nul() trigger page
allocator warnings?=20

Since count can be up to ~2GB (MAX_RW_COUNT), and memdup_user_nul()
internally uses kmalloc_track_caller() without the __GFP_NOWARN flag, a
large write request might cause loud warning stack traces or allocation
failures.

[ ... ]
> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> +		u32 nr_bit_errors, s32 reftag_adjust)
> +{
[ ... ]
> +	if (scsi_debug_lbp() &&
> +	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {

[Severity: High]
This is a pre-existing issue, but does calling map_state() with an
un-folded lba cause an out-of-bounds read if virtual_gb > 0?

When map_state() uses test_bit() on lba_to_map_index(lba), it doesn't
verify if the index exceeds the allocated map_size. If lba goes up to
sdebug_capacity, it can easily exceed the backing store size. This vector
was already reachable via block I/O (like GET LBA STATUS) but this patch
now exposes it directly via debugfs.

[ ... ]
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
> +			u8 *p =3D sip->storep + (block * sdebug_sector_size);
> +
> +			sdeb_data_sector_lock(sip, true);
> +			p[bit / BITS_PER_BYTE] ^=3D (1 << (bit % BITS_PER_BYTE));
> +			sdeb_data_sector_unlock(sip, true);
> +			if (++block >=3D sdebug_store_sectors)
> +				block =3D 0;
> +		}
> +	}

[Severity: High]
Can these nested loops cause CPU soft lockups?

Since nr_bit_errors and num are parsed from user input without strict upper
bounds, large values might stall the CPU while holding sdeb_data_lock(),
which acquires a rwlock in read mode and disables preemption.

Also, if num is larger than sdebug_store_sectors, the wrap-around logic=20
will visit the same physical backing memory multiple times. If a sector is
visited an even number of times, does this accidentally undo the bit flips?

> +	if (reftag_adjust) {
> +		pr_info("adjusting reftag by %d sectors for LBAs %llu:%llu\n",
> +			reftag_adjust, lba, lba + num - 1);
> +		for (i =3D 0; i < num; i++) {
> +			struct t10_pi_tuple *sdt =3D dif_store(sip, lba + i);
> +
> +			be32_add_cpu(&sdt->ref_tag, reftag_adjust);
> +		}
> +	}
> +	sdeb_data_unlock(sip, false);

[Severity: High]
Similar to the wrap-around logic above, if num exceeds sdebug_store_sectors,
will dif_store() wrap around and redundantly apply reftag_adjust multiple
times to the exact same tuple?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831064500.2576=
832-2-hch@lst.de?part=3D1
