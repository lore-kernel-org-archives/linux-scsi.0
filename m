Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C827E3B6BF3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817471; cv=none; b=dQQFuBvY5ZBcEpXpCfRmfcEtzddAExBXgifmWojD/vxEaR7IsRFTqrqIV7DTXlt8BJI4Zy/KC7WKWpwqE1TTUeP0RiZaclr9l0DX/HyLjvJa6J6lXJAKPunSa7yy2FfONiifQHjj7sBDMkj1vK11fvKqNcTiXJ35Zp+64VOvDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817471; c=relaxed/simple;
	bh=u45ROxEWLuefEaEe70wk0itgCGx0c0QT0ZlWiLGSuQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HMuCD3j38gMbAkR/Eqa6TyUA6jaa2QSrP963vfxqftiOxhRi6r4HPlXET+FJcOARHsakBxAxHvN4GoEhQuiJyW3iZtNCuZHRvtd9d7yCeRLK16SyPRF/xlWKS3O0G9fUI5JLr9OSc2+4ljIB1MhEeDVdBCRXVWrx2p2O+POecps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8821F000E9;
	Thu, 23 Jul 2026 14:37:46 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723142154.107268-1-hch@lst.de>
References: <20260723142154.107268-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:37:44 +0000
Message-Id: <20260723143746.6B8821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [High] `map_state()` unintentionally overwrites the user-requested `num` =
parameter, severely altering the number of corrupted blocks.
- [High] Modifying sector data and PI without acquiring the required data l=
ocks leads to data races.
- [High] Writing to the `corrupt` debugfs file triggers a `BUG_ON` kernel p=
anic if the module is loaded with `fake_rw=3D1`.
- [High] NULL pointer dereference when modifying `ref_tag` if `sdebug_dix` =
is not enabled.
- [Medium] User buffer is leaked when parsing an invalid option in `sdebug_=
corrupt_write`.
- [Medium] `match_uint()` is incorrectly used for the signed `reftag_adjust=
` parameter, preventing negative adjustments.
- [Medium] Bit errors are incorrectly correlated across all sectors in a mu=
lti-block request.
- [Medium] Off-by-one check prevents corrupting the full capacity of the de=
vice.
- [Medium] Kernel log flooding and CPU spin via unbounded `pr_info()` calls.
--

--- Patch [1]: [PATCH] scsi_debug: add support to corrupt data and/or refta=
g ---
commit 0839e34574724c1b365a8698f556ce1b2b9bb134
Author: Christoph Hellwig <hch@lst.de>

scsi_debug: add support to corrupt data and/or reftag
   =20
Add a new debugfs file to inject corruptions of the data and/or reftag.
This will be used to detect that protection information and/or file
system checksumming can detect random bit errors or misplaced writes.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4a95e6bae38b0..7d5b55b788f48 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -1168,6 +1169,94 @@ static const struct file_operations sdebug_error_f=
ops =3D {
> +static ssize_t sdebug_corrupt_write(struct file *file, const char __user=
 *ubuf,
> +		size_t count, loff_t *ppos)
> +{

[ ... ]

> +	while ((p =3D strsep(&options, ",\n")) !=3D NULL) {
> +		if (!*p)
> +			continue;
> +		switch (match_token(p, corrupt_tokens, args)) {

[ ... ]

> +		case Opt_reftag_adjust:
> +			error =3D match_uint(args, &reftag_adjust);

[Severity: Medium]
Is match_uint() the correct function to parse this parameter?

Since reftag_adjust is defined as an s32, match_uint() will reject negative
adjustments, preventing users from simulating reference tag skew using
negative values.

> +			break;
> +		default:
> +			pr_warn("unknown parameter or missing value '%s'\n", p);
> +			error =3D -EINVAL;
> +		}
> +		if (error)
> +			return error;

[Severity: Medium]
Does this leak the buffer allocated by memdup_user_nul() earlier in
sdebug_corrupt_write()?

It looks like returning directly here bypasses the kfree(buf) cleanup path =
at
the end of the function when an invalid option is provided.

> +	}

[ ... ]

> @@ -4862,6 +4951,68 @@ static int resp_write_tape(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)
>  	return 0;
>  }
> =20
> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> +		u32 nr_bit_errors, s32 reftag_adjust)
> +{
> +	struct sdeb_store_info *sip =3D devip2sip(devip, true);

[Severity: High]
Will this trigger a BUG_ON() panic if the module is loaded with fake_rw=3D1?

Calling devip2sip() with the bug_if_fake_rw parameter set to true explicitly
triggers an assertion when sdebug_fake_rw is enabled. This seems to allow a
user writing to the debugfs file to crash the system.

> +	bool meta_data_locked =3D false;
> +	u8 *fsp =3D sip->storep;
> +	u32 block, b, i;
> +	int error =3D 0;
> +
> +	if (sdebug_dev_is_zoned(devip) ||
> +	    sdebug_dix ||
> +	    scsi_debug_lbp())  {
> +		sdeb_meta_write_lock(sip);
> +		meta_data_locked =3D true;
> +	}
> +
> +	if (num >=3D sdebug_capacity || lba > sdebug_capacity - num) {

[Severity: Medium]
Is this bounds check overly strict?

Checking if num >=3D sdebug_capacity prevents operations that exactly span
the entire capacity of the device when starting at LBA 0. Should this
check be num > sdebug_capacity instead?

> +		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
> +		error =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (scsi_debug_lbp() && !map_state(sip, lba, &num)) {

[Severity: High]
Does map_state() unintentionally overwrite the requested block count?

map_state() writes the size of the mapped extent into its third parameter.
Since the user's requested block count is passed by reference here, this
discards the user's value and could cause the operation to corrupt an
unintended number of blocks, potentially up to the entire mapped extent.

> +		pr_err("can't modify unmapped logical blocks: %llu:%u",
> +			lba, num);
> +		error =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	for (b =3D 0; b < nr_bit_errors; b++) {
> +		unsigned int bit;
> +
> +		bit =3D get_random_u32_below(sdebug_sector_size * BITS_PER_BYTE);
> +
> +		div_u64_rem(lba, sdebug_store_sectors, &block);
> +		for (i =3D 0; i < num; i++) {
> +			u8 *p =3D fsp + (block * sdebug_sector_size);
> +
> +			p[bit / BITS_PER_BYTE] ^=3D (1 << (bit % BITS_PER_BYTE));

[Severity: High]
Could this lead to data races when modifying sector data concurrently with
standard block layer I/O?

It appears corrupt_lbas() reads and modifies the data store without acquiri=
ng
the necessary sector data locks, such as sdeb_data_sector_lock().

[Severity: Medium]
Also, does the outer loop calculate a single bit offset that is then
applied identically across all sectors in a multi-block request?

It looks like the random bit offset is chosen once in the outer loop,
causing the exact same bit to be flipped in every sector handled by the
inner loop, rather than randomizing the error per sector.

> +			pr_info("flipping bit %u in LBA %llu\n", bit, lba + i);

[Severity: Medium]
Could these unconditional pr_info() calls cause severe performance
degradation or log flooding?

They are placed directly inside nested loops bounded by user inputs, with
no rate limiting.

> +
> +			if (++block >=3D sdebug_store_sectors)
> +				block =3D 0;
> +		}
> +	}
> +
> +	if (reftag_adjust) {
> +		for (i =3D 0; i < num; i++) {
> +			struct t10_pi_tuple *sdt =3D dif_store(sip, lba + i);
> +
> +			be32_add_cpu(&sdt->ref_tag, reftag_adjust);

[Severity: High]
Could this lead to a NULL pointer dereference if the module is loaded
with dif=3D1 but dix=3D0?

The prerequisite check in sdebug_corrupt_write() validates that sdebug_dif
is Type 1 or Type 2, but it fails to check if sdebug_dix is enabled. The
backing array for protection information (sip->dif_storep) is only allocated
if sdebug_dix is non-zero, so dif_store() might return an unallocated addre=
ss
that gets dereferenced here.

> +			pr_info("adjusting reftag by %d sectors for LBA %llu\n",
> +				reftag_adjust, lba + i);
> +		}
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723142154.1072=
68-1-hch@lst.de?part=3D1
