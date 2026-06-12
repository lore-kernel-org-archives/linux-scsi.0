Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13136F91D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259505; cv=none; b=pPOoqem+DE2mpAa9v8G5kJ8s4bf1T1dZIHwSYRiZctSiCYCIcw6mzd4ca3vhXAFNlX9V0A+xQyrVSOHayUDacvmU8XueViPD53eFNxiAfB/UkIMJfydQ13lWGFcR/Le0PDgS61hzmweI4repXhfEbulHRtv5m8dzSgQAL0dN6dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259505; c=relaxed/simple;
	bh=M2BunIqwPzkCKuIz0bndbfaam9avlwT5DMr3ZX9YIhQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jB+DW8wixZam0aU6L363go9vdsaEU3qTcjzp1JO9Y5xjKUJiQiGMKWI0JHs7LyxHxjcCj0rjV2ghBvsrYuKFNHb7wG+HEYofx89W3G6H1J4u3AzndU9enovHPjSe/B+wX1nHwkpSCE7XPGgi99DcpLgx2LKJYCXvFU6aIuUsoAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCXY7Fii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCXY7Fii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5367E1F000E9;
	Fri, 12 Jun 2026 10:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259504;
	bh=vhj43dGBN2+wOToo+sbN7sEiWfVhFRVjEX7QUMRDG2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MCXY7FiiwxY3ROie947+ISRzEnnKe9gmZQ+T8E5MUuyzsYrHcnblerBPjhl4OaYUY
	 29izkgti37EG1ZdNUxLW83nPaHrgXjAvlwbKjheyWlxksEB8jDmPLrdg67672MNpZt
	 YCs+D1HlycIJpxQDgZqp8eRK43hKWBf165j/wMNT+FiE2930NcR2pEy6RI7ACMrbHw
	 sHLbefX+qUnWiDTeMVgiCLvTrNQ8LiCtPGiWxo/dRC6wcquDHwYFnS4ePpP+JwJfR5
	 BjOqkVjXvWi0a2dDQPBi8ShoMvcBA6bHF0xely0y8WMeKcSRT1dRJ769yk8mFM5Na9
	 bkTeNDCKgPW0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/60] scsi: qla2xxx: Add get_flash_version support
 for 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-5-njavali@marvell.com>
References: <20260612095333.1666592-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:18:23 +0000
Message-Id: <20260612101824.5367E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Inconsistent fallback error handling logic and commit message mi=
smatch in `qla24xx_get_flash_version()`.

Pre-existing issues:
- [High] Hardware flash registers are read/written via `qla24xx_read_flash_=
dword` without proper locking, creating a race condition with concurrent sy=
sfs operations.
--

commit 94d10a85b890acf6bb363bf65b3e955e838a9522
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add get_flash_version support for 29xx adapters

This commit removes the standalone qla29xx_get_flash_version() and folds=20
29xx support directly into qla24xx_get_flash_version(). It uses early=20
metadata reads for 29xx firmware and modifies PCI expansion ROM reads.

>   - PCI expansion ROM reads (header + data structure): a new
>     file-static helper, qla24xx_read_pci_rom_chunk(), abstracts the
>     per-generation flash access so both read sites are straight-line
>     calls instead of inline if/else twin blocks.  29xx uses
>     qla29xx_read_optrom_data(FLT_REG_BOOT_CODE, byte-offset); 24xx
>     uses qla24xx_read_flash_data(dword-address).

The commit message mentions a new file-static helper,
qla24xx_read_pci_rom_chunk(), but this function does not appear in the code.
Is the commit message out of sync with the patch?

> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index eb10904f14caa..2229c2b084cff 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
[ ... ]
> @@ -4137,7 +4108,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, voi=
d *mbuf)
>  		if (ret) {
>  			ql_log(ql_log_info, vha, 0x017d,
>  			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
> -			return QLA_FUNCTION_FAILED;
> +			break;
>  		}

[Severity: High]
This is a pre-existing issue, but can qla24xx_read_flash_data() race with
concurrent sysfs operations?

Hardware flash registers are read/written via qla24xx_read_flash_dword()
without proper locking:

qla24xx_read_flash_dword() {
	wrt_reg_dword(&reg->flash_addr, addr & ~FARX_DATA_FLAG);
	while (cnt--) {
		if (rd_reg_dword(&reg->flash_addr) & FARX_DATA_FLAG) {
        ...
}

When invoked via the sysfs reset handler:

qla2x00_sysfs_write_reset() {
    ...
    ha->isp_ops->get_flash_version(vha, tmp_data);
    ...
}

It doesn't appear to hold ha->optrom_mutex or ha->hardware_lock. Could
concurrent calls interleave their register accesses and corrupt data?

[Severity: Medium]
When qla24xx_read_flash_data() fails, the code now uses break to fall throu=
gh
and read the active firmware image version. However, signature validation
failures later in this loop still return QLA_FUNCTION_FAILED:

		bcode =3D mbuf + (pcihdr % 4);
		if (memcmp(bcode, "\x55\xaa", 2)) {
			/* No signature */
			ql_log(ql_log_fatal, vha, 0x0059,
			    "No matching ROM signature.\n");
			return QLA_FUNCTION_FAILED;
		}

If the flash read succeeds but contains invalid boot code, the function abo=
rts
entirely and skips reading the firmware version, whereas a complete flash r=
ead
failure successfully falls through. Is this inconsistent fallback behavior
intentional?

> =20
>  		bcode =3D mbuf + (pcihdr % 4);
> @@ -4155,7 +4126,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, voi=
d *mbuf)
>  		if (ret) {
>  			ql_log(ql_log_info, vha, 0x018e,
>  			    "Unable to read PCI Data Structure (%x).\n", ret);
> -			return QLA_FUNCTION_FAILED;
> +			break;
>  		}
> =20
>  		bcode =3D mbuf + (pcihdr % 4);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D4
