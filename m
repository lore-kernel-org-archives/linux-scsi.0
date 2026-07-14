Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4591A466B52
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 13:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784034643; cv=none; b=LcAAUpP4IcKWPVzXrCiZw/TLxVsxmUdPqG0LxJGEtwXQLuD99v20/32QeHg/EtFDGSV6aJSG0SbxWKNcmH5+KLGatbiNc8mfFa7IM9xOORXUlkKkF/QI4q9eY0dcXTWjuu5lqo0SdW9/tZ9/QyZHLpj0NdHvMhNIihC/yOW4+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784034643; c=relaxed/simple;
	bh=BFyif+cRQH9MdpsZdpQcGiKFZv7WXJqPWHgAdopKltA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=elUlzItYH40oO9b9wWzzMktl1lQteo7VeeHKN74Sn2mPeO+8SzceuyG40MskIB+d92926DvyggBOgjxkVsY+9HOLHTmegSBP/9WXXVkU7Zvj9pca33D1s58LzACn+pF6/T89TET26jIElknl7kF6x8iD5kQjfJ4ipiJGz3ziZbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFO+9sdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFO+9sdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79EE1F000E9;
	Tue, 14 Jul 2026 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034641;
	bh=4DA4mHdOh+1ZLXnYwX2T9aV91Mai/yaOmpv1jpVNiGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mFO+9sdpdalSkRrfYYGseN03g3VBCAZwOwFt4BdFM8JZN45KbC6M19QCT9PE2Q39C
	 IEKk4oq3YGcHGuZYZcTH8LNl4pM+IhxgZA1o+n0rnVk6PiS3tiNNaCe0lX3VTws6kb
	 /qOcTaT/NxGXr+GlAEACVWfSzL+t6mDa4TJ2pDgJ43GLXsDXyUziNsD4noTzPLp10s
	 MnWWeattnbgJxIwaH7W55E0bqEeimT5pDbXXNHyyq1QZ3f+DOCU11lgZ5r6PQ/Keqc
	 JHQO5LAWa8twUZQkEPMwJ0ppGZhHzOk+vdyCutDUc9e13nQmNANKLyAIMWKHJCjPaL
	 SaIEEjDKvYO1Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 19/56] scsi: qla2xxx: Enable serdes, resource count
 and FCE trace for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-20-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-20-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 13:10:40 +0000
Message-Id: <20260714131041.B79EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect usage of `kstrtoul` in `qla2x00_dfs_fce_write` passes a =
NULL pointer for the result argument, causing an unconditional kernel oops =
upon successful parsing.
- [High] A TOCTOU race condition in `qla2x00_dfs_fce_release` can lead to a=
 NULL pointer dereference when accessing `ha->fce`.
- [High] Concurrent non-atomic modification of the `ha->flags` bitfield lea=
ds to data corruption, potentially dropping critical interrupts or mailbox =
states.
- [High] A concurrent firmware dump can trigger a Use-After-Free on `ha->fc=
e` while the FCE trace is being disabled via DebugFS.
--

--- Patch [19]: [PATCH v4 19/56] scsi: qla2xxx: Enable serdes, resource cou=
nt and FCE trace for 29xx ---
commit c0d2af5f457ed884072ede4fabe84388c9abed9e
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
   =20
The 29xx adapters share the diagnostic and management interfaces
already supported on ISP27xx/28xx, but several family capability
gates still omitted IS_QLA29XX(), leaving these paths unreachable
on 29xx.

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
>  		ql_dbg(ql_dbg_user, vha, 0xd034,
>  		       "this adapter does not support FCE.");
>  		return -EINVAL;

[Severity: High]
This isn't a bug introduced by this patch, but looking at the parsing logic
further down in qla2x00_dfs_fce_write():

qla2x00_dfs_fce_write() {
    ...
    enable =3D kstrtoul(buf, 0, 0);
    ...
}

Does this cause an unconditional kernel oops? kstrtoul() writes the parsed
result to the pointer provided in the third argument, which is 0 (NULL)
here. Additionally, the return value (0 on success, negative on error) is
assigned to enable, which appears to invert the intended logic.


[Severity: High]
This is a pre-existing issue, but does modifying the bitfields in
qla2x00_dfs_fce_write() risk dropping mailbox interrupts?

qla2x00_dfs_fce_write() {
    ...
    ha->flags.user_enabled_fce =3D 1;
    ...
}

Since user_enabled_fce shares the same 32-bit volatile struct word as
mbox_int and mbox_busy, and compilers use non-atomic read-modify-write
operations for bitfields, can a concurrent interrupt handler modifying those
mailbox flags overwrite this update or vice versa?


[Severity: High]
This is also a pre-existing issue, but is there a use-after-free risk when
disabling the FCE trace?

In qla2x00_dfs_fce_write(), the trace buffer is freed:

    qla2x00_free_fce_trace(ha);

This is called under ha->fce_mutex. However, a concurrent firmware dump in
qla25xx_fw_dump() calls qla25xx_copy_fce() which copies data from ha->fce
while only holding ha->hardware_lock:

qla25xx_copy_fce() {
    ...
    memcpy(iter_reg, ha->fce, ntohl(fcec->size));
    ...
}

If these paths do not share a lock, could a concurrent firmware dump read
from the freed FCE buffer?


[Severity: High]
This is another pre-existing issue, but could a race condition cause a NULL
pointer dereference in qla2x00_dfs_fce_release()?

The release function checks ha->fce outside of the mutex:

qla2x00_dfs_fce_release() {
    if (ha->flags.fce_enabled || !ha->fce)
        goto out;

    mutex_lock(&ha->fce_mutex);
    ha->flags.fce_enabled =3D 1;
    memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));
    ...
}

If a concurrent write to qla2x00_dfs_fce_write() acquires the mutex, frees
ha->fce, sets it to NULL, and releases the mutex, will the release thread
then acquire the mutex and execute memset() on the NULL pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D19
