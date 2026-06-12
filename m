Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70160371D0A
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260733; cv=none; b=DCH3gnMDmfr1dPh6SDNDYhQqAeJZjiThs04AS0m9iBZIw/ny94PMiYOHFW0PoAIFOm5lZMMCMwStEfoRvs75bh/r66G/drg1fC8bW1qjQ9hQCzmm6ZKT31TnilSG4yksEktre1aT3s0Hl7NsHrBFqE9tBqFX5JJRc4coH5Q+J4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260733; c=relaxed/simple;
	bh=09x1kLrdtYNuUVorUb/gG3VpILHDBs445opurILapF8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KKdrgYdyglYqIDE4sVGhc2fTaOc7cESlX6Dectx8Ser2MbHkBRV5m6a+nb0drJY3yvaaq/q3pZVXI+e3tvqbCZDxk6wnS2jKIcxgAgssQsjvbia/AJ9zm5hWjMQNv75ZwbxJSoymTKl6PuPiWVgRwMvS+aw/etmV5tf5e4WAA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+wMqhBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+wMqhBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAD01F000E9;
	Fri, 12 Jun 2026 10:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260732;
	bh=Q98di/AfBlZ1F24IDe0q2+DCQmcXJTrLZ+vsbxEMD14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z+wMqhBB3fo0W5VEkI0De/BMFgRQ1QI3g9sAs1wBQGAignSCrepdfM+C9XjfOqgO9
	 CwA7N7mh+FrmmPzONcTUIFBmMcUv5FVl+aATpHSV3vO6ZAfP6oruf4lYzapeU8HCg7
	 baOu5tQ3EWYyn6uZ4JWc5VkVRwMVPm7OO4alEJ8iSmdqXWpnLzSr8bdfF8WkTTQ+pv
	 hahbgPNZFw0q9nYZ/WAIfcmzyLY2ptmXxF60KilNEMwQt69M7r6avb9cvqMsnhpM4X
	 CeT+6qW6DkETrTotYcWsas9JNXC+ZLTUysb3QbsNtRlMu7I5yjQsJIJsw1BpKLVn9i
	 q06jmKLyXruXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/60] scsi: qla2xxx: Enable serdes, resource count
 and FCE trace for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-22-njavali@marvell.com>
References: <20260612095333.1666592-22-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:38:51 +0000
Message-Id: <20260612103851.DFAD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling kstrtoul(buf, 0, 0) passes a NULL pointer for the result, =
which unconditionally causes a kernel panic upon successful string parsing.
- [High] qla2x00_alloc_fw_dump() lacks an IS_QLA29XX check when deciding wh=
ether to size the fw_dump buffer using FWDT, leading to legacy fixed-size a=
llocations that are too small.
- [High] Enabling FCE trace dynamically via debugfs does not resize the pre=
-allocated firmware dump buffer, leading to an out-of-bounds write of 64KB =
(FCE_SIZE) during a firmware dump.
- [High] A race condition between disabling the FCE trace via debugfs and a=
 concurrent firmware dump leads to a Use-After-Free of the DMA-allocated FC=
E trace buffer.
--

commit f8a1650862943af8f27bc3e84bb79567498967d8
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
   =20
The 29xx adapters share the diagnostic and management interfaces
already supported on ISP27xx/28xx, but several family capability
gates still omitted IS_QLA29XX(), leaving these paths unreachable
on 29xx.

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_df=
s.c
> index 43970caca7b39..177d47e92e494 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -497,7 +497,7 @@ qla2x00_dfs_fce_write(struct file *file, const char _=
_user *buffer,
>  	unsigned long enable;
> =20
>  	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
> -	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
> +	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {

[Severity: High]
This isn't a bug introduced by this patch, but exposing this interface to 2=
9xx
adapters makes it relevant here. Looking further down in qla2x00_dfs_fce_wr=
ite(),
there is a call to kstrtoul():

    enable =3D kstrtoul(buf, 0, 0);
    rc =3D count;

Does passing a NULL pointer as the third argument to kstrtoul() cause a ker=
nel
crash when parsing succeeds? Additionally, since kstrtoul() returns a status
code (0 on success, negative on failure), does assigning its return value
directly to the boolean enable flag cause inverse logic where writing a val=
id
number skips FCE enablement?

[Severity: High]
This is a pre-existing issue, but since 29xx adapters are now enabling FCE =
and
fw dump features, should IS_QLA29XX be added to the sizing check in
qla2x00_alloc_fw_dump()?

Currently, the check only includes IS_QLA27XX and IS_QLA28XX:

    if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
        struct fwdt *fwdt =3D ha->fwdt;

If a 29xx adapter falls through this check, it defaults to legacy fixed-size
allocations that are too small. When qla27xx_fwdump() later executes the FW=
DT
templates for QLA29XX, could this write past the end of the undersized buff=
er?

[Severity: High]
This is a pre-existing issue, but exposing FCE trace dynamically via debugfs
highlights it. When qla2x00_dfs_fce_write() enables FCE, it attempts to res=
ize
the firmware dump buffer to account for the new 64KB FCE trace:

    if (!ha->flags.fce_dump_buf_alloced)
        qla2x00_alloc_fw_dump(vha);

However, if ha->fw_dump is already allocated, qla2x00_alloc_fw_dump() retur=
ns
immediately without expanding the buffer.

Later, if a firmware dump occurs, qla27xx_fwdt_entry_t264() sees ha->fce is=
 not
NULL and unconditionally copies FCE_SIZE (64KB) bytes into the dump buffer.
Can this result in an out-of-bounds write since the buffer was never actual=
ly
enlarged?

[Severity: High]
This is a pre-existing issue, but could disabling the FCE trace via this
debugfs node race with a concurrent firmware dump?

When FCE is disabled in qla2x00_dfs_fce_write(), qla2x00_free_fce_trace()
frees the DMA memory and sets ha->fce to NULL under ha->fce_mutex, but
without holding ha->hardware_lock.

Conversely, the firmware dump routines (like qla27xx_fwdt_entry_t264)
execute under ha->hardware_lock and read from ha->fce without acquiring
ha->fce_mutex.

Could this race allow the FCE buffer to be freed after the dump routine
verifies the pointer but before the memcpy completes, leading to a
use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D21
