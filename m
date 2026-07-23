Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AD023393C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801424; cv=none; b=puhGZZtdnwP7PtducTVZPaAxCvwejEh9YW8LH/pu2GUUq+NtNa4bkxucyK1DDXNu7i4vRlXZpH+1md76hhMCehsKW6FNVW6rfy2isKS2t8yLAr8JzY4C1amCafmgitypWmw02eCuk4bmlQIHFzEn1KwWi6Hztz9KMxpQNqcedUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801424; c=relaxed/simple;
	bh=Tn157s6grPj+3u5cnLRJtGDoZcfFMcNkfNQp4uOh4pQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ISGJbWbyLwEbuYGFTwpxoqfcLFSTy4wdxPKF/z/Y3rZSYWyszdArmL/lnGc7bq3q6G0fgCEqt40MHnbJFezX5TAymO9dJbVoxHxPgr00u0fwcXkvdZ+nBxSYzQGIm3qFpGAdCfQPzhCn1co2PGi1cGo5x1on4LoCd0l0c7Zt2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqT1Km+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqT1Km+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADF91F000E9;
	Thu, 23 Jul 2026 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801422;
	bh=y/w70O2wvvnbWWuXApvXtuLhOXbVvFbz38DMqv8O1oQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bqT1Km+nESsig2axZXpEtnBNw+iXYfGNayEwev2CL4U03DsFtyQwCtI1tT/6/YXsh
	 Edjle875yWjFmdblKtO4d5hM7lKiyUFkl0dkqPTua9m2VEV+wywFZA6LN+oLUKp6np
	 8tcm+g6MVAL22lTCfwvcoZhlQS/hl7hNydVxYZyCp7ohSGJkuXPwnmlRNk5FyttQRp
	 YPWfhbw3qdggeZ95cAz4UfGE0MOyuE4EjEOuUOOnWDHOrd0EPWy8NrN9SGh9KiftMA
	 KXhjoMbl2ax931nsxhoiRJQfl8R5zcNWq/rSL93v8NRlRsGxkm3P9Dfq54tUk6nqQX
	 +uKgMP3SGw7Kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 19/56] scsi: qla2xxx: Enable serdes, resource count
 and FCE trace for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-20-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-20-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:10:21 +0000
Message-Id: <20260723101022.2ADF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The debugfs write handler `qla2x00_dfs_fce_write()` passes a NULL =
pointer to `kstrtoul()`, guaranteeing a kernel crash upon successful parsin=
g, and erroneously evaluates its error code as the parsed value.
- [High] Dynamically enabling FCE trace via debugfs causes a 64KB out-of-bo=
unds write during a firmware dump because the fw_dump buffer is not properl=
y resized.
- [High] Concurrent execution of a firmware dump and disabling the FCE trac=
e via debugfs leads to a Use-After-Free of the FCE DMA buffer.
--

--- Patch [19]: [PATCH v6 19/56] scsi: qla2xxx: Enable serdes, resource cou=
nt and FCE trace for 29xx ---
commit ce99a18d7438f0c23e7c18bd3dad0bfb7220456a
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
This is a pre-existing issue, but since this patch exposes the FCE debugfs
node to 29xx adapters, does writing to this node cause a guaranteed kernel
panic?

Looking at qla2x00_dfs_fce_write() just below this check:

    enable =3D kstrtoul(buf, 0, 0);

Does passing 0 (NULL) as the third argument to kstrtoul() cause a NULL poin=
ter
dereference when the function attempts to write the successfully parsed val=
ue?

Additionally, since it assigns the return value (an error code) to enable
rather than the parsed number, does writing an invalid string return a
non-zero negative error code that evaluates to true, incorrectly enabling
the trace without crashing?

[Severity: High]
This is another pre-existing issue exposed by enabling FCE trace via debugf=
s,
but does dynamically enabling this feature cause an out-of-bounds write
during a firmware dump?

When FCE is enabled dynamically, qla2x00_dfs_fce_write() calls
qla2x00_alloc_fw_dump() to resize the dump buffer. However,
qla2x00_alloc_fw_dump() returns early if the buffer is already allocated:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_alloc_fw_dump() {
    if (ha->fw_dump) {
        ql_dbg(ql_dbg_init, vha, 0x00bd,
            "Firmware dump already allocated.\n");
        return;
    }
    ...
}

During a firmware dump, qla25xx_copy_fce() appends the 64KB FCE buffer to
the fw_dump buffer:

drivers/scsi/qla2xxx/qla_dbg.c:qla25xx_copy_fce() {
    ...
    memcpy(iter_reg, ha->fce, ntohl(fcec->size));
    ...
}

Does this blindly write 64KB past the end of the unresized firmware dump
buffer?

[Severity: High]
This is also a pre-existing issue, but does disabling the FCE trace via this
debugfs node race with firmware dumps, leading to a Use-After-Free?

When disabling FCE, qla2x00_dfs_fce_write() calls qla2x00_free_fce_trace()
which frees ha->fce using dma_free_coherent() while holding fce_mutex.

Concurrently, if a firmware dump triggers (e.g., via a system error),
the dump path accesses this same memory:

drivers/scsi/qla2xxx/qla_dbg.c:qla25xx_copy_fce() {
    ...
    memcpy(iter_reg, ha->fce, ntohl(fcec->size));
    ...
}

Since the dump path executes under hardware_lock but without holding
fce_mutex, and the free path does not acquire hardware_lock, can the dump
path observe a non-NULL pointer and access the memory after it has been
freed?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D19
