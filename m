Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B904D245012
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305703; cv=none; b=NpaC8+1DH1EHNjGeJrUvJl5PXvtkxr2hRvjAuuCkvOGwG4vG29m8pTGCkq+fZt7JkFwGxhB6CxVBoyw7FDQwqD3jHjfFPdRmL3IKWTMAb1dDEXiEUth6HHV+c4rAzlpjIZLhoMre1dlwNzye4R+C/zXOhocz/oSGbky3mK4KuvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305703; c=relaxed/simple;
	bh=137UVyHMAzdF2l1wspeeN5Z7nI8PEVC5k1v0/13iUJg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f9wQIRukfyCH5EB3GtqIAsOo2/gwJE757Tug+q7bff+aQBAWLxyZX3lltx2w5kN7Kiu+8WHcVKXbcyFRuTU3s8dJHgu9BWVTroa+QrHSOgu0LWBVqsWVOlEMKkNXP76nSXK4CqchKqLT/Ldo38tHncQzLUhlkmULMyL3bYK8CzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PM86iH50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PM86iH50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5231F000E9;
	Fri, 17 Jul 2026 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305702;
	bh=38bIOq6rYBbmrMYekobtU16aPPE7ER2/Xp4d9+H7BrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PM86iH50BX4M0XZS8GMgxFS9TELXUfm9p6Ebwe4kwp0PksI2prDBldYjP4lXpm+DT
	 r4gyfudPNYYckRcKyMhBv3AqB0nLKWo76jxtuuidFxvkMOVHcEQfBOIvSzuXAy6nj2
	 zPqJut1Bm6kgkqQjBpLX/vJLyzI1TNF6frsqKM0AaKhGEIg7iiy50x+x6nso8VtvWX
	 41x4PKcdA12PXGyNsnDF8iUUG0RlOqrldkx3D2DY4IUiTao7kFkzFresfVV/fN76bA
	 5f1GbPrMYWR9FzTj9nyHURV7T71Nc6BqX0kTrnkgVMAFTnKuzlS3nw2VXTisLrDdFU
	 CLnx0rARyw6oQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 43/56] scsi: qla2xxx: Use 64-bit FPM word counters
 for 29xx host stats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-44-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-44-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:28:21 +0000
Message-Id: <20260717162822.2F5231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch introduces corrupted RX/TX word counter reporting for =
QLA29XX hardware on big-endian architectures due to a double byte-swap bug.
--

--- Patch [43]: [PATCH v5 43/56] scsi: qla2xxx: Use 64-bit FPM word counter=
s for 29xx host stats ---
commit 6dc53192ab6558b115cab1a52a856c1edbdfd7e4
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats

This patch adds IS_QLA29XX() to the high-speed branch in
qla2x00_get_fc_host_stats() so that 29xx reports hardware word counters
instead of falling back to software approximations.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 19aa66b8ca521..6cf74f8c9628d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2990,7 +2990,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>  		p->error_frames =3D
>  		    le32_to_cpu(stats->dropped_frames) +
>  		    le32_to_cpu(stats->discarded_frames);
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +		    IS_QLA29XX(ha)) {
>  			p->rx_words =3D le64_to_cpu(stats->fpm_recv_word_cnt);

[Severity: Medium]
Will this result in corrupted RX/TX word counters for QLA29XX on big-endian
systems?

The link_statistics DMA buffer is globally byte-swapped in-place as 32-bit
integers by le32_to_cpus() in qla24xx_get_isp_stats():

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_get_isp_stats() {
    ...
    /* Re-endianize - firmware data is le32. */
    for ( ; dwords--; iter++)
        le32_to_cpus(iter);
    ...
}

For 64-bit fields like fpm_recv_word_cnt, this independently swaps the two
32-bit halves.

Later, this code calls le64_to_cpu() on the result, which effectively jumbl=
es
the 8 bytes into an invalid sequence on big-endian machines.

While this double-swap logic seems to be a pre-existing flaw for older
adapters (83xx/27xx/28xx), this patch specifically introduces the bug for
QLA29XX by disabling its previously working software-based fallback metric
and routing it into the broken hardware reading path.

>  			p->tx_words =3D le64_to_cpu(stats->fpm_xmit_word_cnt);
>  		} else {
>  			p->rx_words =3D ib >> 2;
>  			p->tx_words =3D ob >> 2;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D43
