Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94233A874D
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700551; cv=none; b=OJZlhotaSK02WCeLj5err6tOKueXbZdBB8VbTDfz8i1RH1qqvnKaLP2g8//grxnujswtS4SoDymnEebM5jbD06xS8n30u1Y0u0nzq7RCpMpJbjJ/nxYyzkhgYAA3dm3l+H3KSOPLmBkMjfIREZ8ygZ+Lh+LH+zOjDcJED4bVQG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700551; c=relaxed/simple;
	bh=YNb9USpm9zLXyKrTa+xukmVNH4RSbGVBExB0VpxViOg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dd7fRYeVgcteW8H6biS/y05kAG27UjqMHn+No3PTTZIh2MLqTHA5WkAgIkHhIZNjfeTcY6grqWR2MdT7OCr8HYEx2N+c//nrDPsyFAIuJK+KauuVxikXvEkyDdRsYR0YpXYGH9B9W2qrEnd6O4w/3tQXpGxiYP1izwS4wFde8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmph2ppI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmph2ppI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DF31F000E9;
	Fri, 14 Aug 2026 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786700549;
	bh=QEudLvDVCKtwCehdAiBosyE0GYR7CUni4VHzLjhrGWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mmph2ppIRD+SvmJ8EnJ6mYjwqwbkl+H4CQIv9vrdJGud079OatrGcjzGlAxhNg36E
	 BXaW1zqKtbRiIKUfKac1Xh2O9W0OfoXG9yQI/XRZcizX/eTaLxsUGH86Bn9BF3w8b0
	 +3R1Z/12mjYwlaOb9uijMXxLcqihDZhfWBQeCl/l+GRxwO+gF1Li/gQphNE9nOmHTK
	 xoXVe84FwCmecd981s7xw6WZmOOgotAPl89dD8VSKTPgLSTuOTrs1+R8sDsEafpGxN
	 AAkUAQCP52AOGYCzRG3+v9gawnkSv7HxIgoZ6lC1ts1dKND9grVKXdEz16URRFac4C
	 A1dq/JHIqbCFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: hpsa: fix divide-by-zero in
 hpsa_scsi_ioaccel_raid_map
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haotian Zhang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814090015.10207-1-vulab@iscas.ac.cn>
References: <20260814090015.10207-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 09:42:28 +0000
Message-Id: <20260814094229.42DF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] The patch introduces a Time-Of-Check to Time-Of-Use (TOCTOU) vulne=
rability due to a double fetch of `map->strip_size`, which defeats the newl=
y added divide-by-zero check.
- [Low] The patch calls an undeclared and undefined function `hpsa_turn_off=
_ioaccel_for_device()`, which will cause a build and linker failure.

Pre-existing issues:
- [Critical] The block address parsing for SCSI `READ_6` and `WRITE_6` comm=
ands ignores the top 5 bits of the 21-bit LBA, leading to silent data corru=
ption.
- [High] The controller-provided `map->row_cnt` field is used as a modulo d=
ivisor without being validated against zero, leading to a divide-by-zero pa=
nic.
- [High] A 32-bit integer overflow when calculating `stripesize` can result=
 in a divisor of 0, bypassing safety checks and leading to a divide-by-zero=
 crash.
- [High] The driver blindly trusts controller-supplied values to enforce sa=
fety using multiple `BUG_ON()` assertions, creating trivial vectors where m=
alformed firmware data can panic the host.
- [High] In `hpsa_figure_phys_disk_ptrs`, a signed integer overflow when co=
mputing `nraid_map_entries` can bypass the upper-bound array check, leading=
 to a NULL pointer dereference on subsequent I/O.
--

--- Patch [1]: [PATCH] scsi: hpsa: fix divide-by-zero in hpsa_scsi_ioaccel_=
raid_map ---
commit 3421092ab4fbde9690cdb0b8f3136415015aac53
Author: Haotian Zhang <vulab@iscas.ac.cn>

scsi: hpsa: fix divide-by-zero in hpsa_scsi_ioaccel_raid_map

hpsa_scsi_ioaccel_raid_map() divides by blocks_per_row, the product of
data_disks_per_row and strip_size, two controller-supplied RAID map
fields that are never validated.  If either field is zero, the
unguarded division raises a divide-by-zero exception on every I/O to an
offload-enabled logical volume.

Check blocks_per_row for zero as soon as it is computed.  If it is
zero, turn off ioaccel for the device and return IO_ACCEL_INELIGIBLE.

> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -4444,6 +4444,10 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_=
info *h,
>  	/* calculate stripe information for the request */
>  	blocks_per_row =3D le16_to_cpu(map->data_disks_per_row) *
>  				le16_to_cpu(map->strip_size);
> +	if (blocks_per_row =3D=3D 0) {
> +		hpsa_turn_off_ioaccel_for_device(dev);

[Severity: Low]
Does this break the build? The function hpsa_turn_off_ioaccel_for_device do=
es
not appear to be declared or defined anywhere, which could lead to an
implicit function declaration and undefined reference at link time.

> +		return IO_ACCEL_INELIGIBLE;
> +	}
>  	strip_size =3D le16_to_cpu(map->strip_size);

[Severity: High]
Could this second fetch of map->strip_size reintroduce the divide-by-zero
issue? Since the I/O path executes locklessly with respect to device
configuration updates, a concurrent update could change map->strip_size to
zero right after the blocks_per_row check, causing the subsequent operations
using strip_size to fault.

[ ... ]

While reviewing this area, I noticed a few pre-existing issues in the same
driver that might be worth addressing:

drivers/scsi/hpsa.c:hpsa_scsi_ioaccel_raid_map() {
    ...
    map_row =3D ((u32)(first_row >> map->parity_rotation_shift)) %
              le16_to_cpu(map->row_cnt);

[Severity: High]
This isn't a bug introduced by this patch, but does this modulo operation
risk a divide-by-zero exception? The controller-provided map->row_cnt field
appears to be used here without being validated against zero.

[ ... ]

drivers/scsi/hpsa.c:hpsa_scsi_ioaccel_raid_map() {
    ...
    r5or6_blocks_per_row =3D
        le16_to_cpu(map->strip_size) *
        le16_to_cpu(map->data_disks_per_row);
    BUG_ON(r5or6_blocks_per_row =3D=3D 0);
    stripesize =3D r5or6_blocks_per_row *
        le16_to_cpu(map->layout_map_count);

[Severity: High]
This is a pre-existing issue, but can this stripesize calculation silently
overflow to zero? Both r5or6_blocks_per_row and layout_map_count are
evaluated as signed 32-bit integers. If the controller provides specific
values (such as strip_size =3D 16384, data_disks_per_row =3D 8, and
layout_map_count =3D 32768), the product evaluates to exactly 2^32. This wr=
aps
to 0 when stored in the u32 stripesize variable, causing a divide-by-zero
crash later.

[ ... ]

drivers/scsi/hpsa.c:hpsa_scsi_ioaccel_raid_map() {
    ...
    case HPSA_RAID_1:
        /* Handles load balance across RAID 1 members.
         * (2-drive R1 and R10 with even # of drives.)
         * Appropriate for SSDs, not optimal for HDDs
         */
        BUG_ON(le16_to_cpu(map->layout_map_count) !=3D 2);

[Severity: High]
This is a pre-existing issue, but is it safe to use BUG_ON() to assert
structural properties of the raid_map? A buggy or compromised controller
could provide a mismatched layout map count, which would trigger this
assertion and panic the host immediately upon processing an I/O instead of
safely falling back to standard non-accelerated I/O.

[ ... ]

drivers/scsi/hpsa.c:hpsa_scsi_ioaccel_raid_map() {
    ...
    switch (cmd->cmnd[0]) {
    case WRITE_6:
        is_write =3D 1;
    case READ_6:
        first_block =3D
            (((u64) cmd->cmnd[2]) << 8) |
            cmd->cmnd[3];

[Severity: Critical]
This is a pre-existing issue, but does this LBA reconstruction silently
truncate the address? The standard 6-byte SCSI command format places the
upper 5 bits of the 21-bit LBA into byte 1 (cmd->cmnd[1]). By ignoring
byte 1 entirely, any application issuing a READ_6 or WRITE_6 command to an
offload-enabled device targeting an LBA greater than or equal to 65536 will
have the address truncated, resulting in operations against the wrong disk
region.

[ ... ]

drivers/scsi/hpsa.c:hpsa_figure_phys_disk_ptrs() {
    ...
    int nraid_map_entries =3D le16_to_cpu(map->row_cnt) *
                            le16_to_cpu(map->layout_map_count) *
                            total_disks_per_row;
    if (nraid_map_entries > RAID_MAP_MAX_ENTRIES) {

[Severity: High]
This isn't a bug introduced by this patch, but can this multiplication
overflow? Evaluated as a signed 32-bit integer, a maliciously crafted RAID
map from the controller could cause this product to exceed INT_MAX and wrap
to a negative value.

This would bypass the upper-bound check against RAID_MAP_MAX_ENTRIES,
leaving elements in the phys_disk array initialized as NULL. During I/O
submission, fetching and dereferencing this NULL pointer to access
ioaccel_handle will result in a kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814090015.1020=
7-1-vulab@iscas.ac.cn?part=3D1
