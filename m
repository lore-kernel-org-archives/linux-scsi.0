Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C1846AEE4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854868; cv=none; b=oT3lQy+pXkqMk7OWiKVAWkw5NUc1agkFr74EGiHRTtUU7SJZiwXqIeRg3HsnTn8S6ZluEIIv/shP4koQ2FSiH57c6Wa+lELjt6Te7+3kAhtm0fMDWNTJ9PJa2kVMWCrItGjfdYFDe49tg/RdFOafTTq3TZDWqEOoYEaWCodRqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854868; c=relaxed/simple;
	bh=o8HGamV5A1kVRs4FiPdPcA9QGnHS/rwsRtgUYMqTXe4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mB7zWUHeYYkw7ii7XSVA85tzAV5fMY6PpXWT3nHGXiz9V5kDiTvSyb6IdzdtmqDmW7m0fqhnLQRw2tPoQ3lD/v0ODkGum6o0QkczwBmZXEhg6xe7AaubPKzuhEVr3mehWE+7bFBJqE4lCkxwhviLAGczPPjTzkmHmDZWubTzjMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U52rMYWz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U52rMYWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535D61F000E9;
	Thu, 27 Aug 2026 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787854866;
	bh=eisZaWLwrx7oajnlpURa/eS8PaIT0B3XBxwF7hRiyjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U52rMYWzvUL4G7pc62b5V/WTYFDdDywXDaKAuxXdqxQEYnbIuTiJHsOF7Gxu8EZK8
	 IT0TQd0Kjws854sS3Vpei6q4/RJEEfzF6wDRymSQ3Pr3WK3gxWQeVzcPHP5E2V1p1U
	 MS4duv+HMlLP21t5p8ZtDRs/2jhburMG2k781P42njSHiwBu5K1BHwc9ZTvut4eiMA
	 Jg54aq9l+8P5Po/njhIXgnLu+9f35DM/IEaLn+bSdg1ZcFJ8bnVt8s/MMk5HggLVY9
	 chubpch/2QwARA6XBDhzGBNr/zxoWjKAP6Y2FUov0vwAwAA2rnmbL42S0RlG+SBXvy
	 Su3JA8WxENfoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP
 chain frame
Reply-To: sashiko-reviews@lists.linux.dev
To: "Thomas Lamprecht" <t.lamprecht@proxmox.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260827175743.734593-1-t.lamprecht@proxmox.com>
References: <20260827175743.734593-1-t.lamprecht@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 18:21:05 +0000
Message-Id: <20260827182106.535D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Preexisting: `megasas_make_prp_nvme` uses the virtual address =
instead of the physical address to detect NVMe page boundaries, which break=
s PRP chain pointers if the NVMe page size exceeds the DMA pool alignment.
--

commit fd59af10f7e697e784da3de5d62a37975fb7023a
Author: Thomas Lamprecht <t.lamprecht@proxmox.com>

scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame

This patch limits the max_hw_sectors for NVMe transfers in the megaraid_sas
driver to prevent PRP list construction from overrunning its DMA buffer
boundary. It calculates the capacity dynamically based on the adapter's
max_chain_frame_sz.

Link: https://lore.kernel.org/all/yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com/

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index ecd365d78ae3c..d83abded2039b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1973,12 +1973,23 @@ megasas_set_nvme_device_properties(struct scsi_de=
vice *sdev,
>  {
>  	struct megasas_instance *instance;
>  	u32 mr_nvme_pg_size;
> +	u64 max_prp_io;
> =20
>  	instance =3D (struct megasas_instance *)sdev->host->hostdata;
>  	mr_nvme_pg_size =3D max_t(u32, instance->nvme_page_size,
>  				MR_DEFAULT_NVME_PAGE_SIZE);
> =20
> -	lim->max_hw_sectors =3D max_io_size / 512;
> +	/*
> +	 * megasas_make_prp_nvme() builds the PRP list in cmd->sg_frame without
> +	 * bounding it against that buffer, and spends one entry per page of
> +	 * it on the chain pointer. Cap the transfer at what the buffer holds,
> +	 * less one page for lists that start off a page boundary.
> +	 */

[Severity: Critical]
This is a pre-existing issue, but since this patch directly addresses how
megasas_make_prp_nvme() builds PRP chains and accounts for page boundaries,
does the chain boundary detection logic in that function safely calculate
the boundary?

Looking at megasas_make_prp_nvme() in
drivers/scsi/megaraid/megaraid_sas_fusion.c:

	page_mask_result =3D (uintptr_t)(ptr_sgl + 1) & page_mask;

This tests the virtual address (ptr_sgl) against the NVMe page mask instead
of the physical IOVA address. If the system uses an IOMMU and creates an
unaligned virtual mapping for the DMA pool (modulo the NVMe page size), this
will miscalculate physical NVMe page boundaries.

Could this result in the NVMe controller misinterpreting the PRP list,
treating data PRPs as chain pointers and reading or writing disk data to
arbitrary physical addresses provided by user data?

> +	max_prp_io =3D (u64)((instance->max_chain_frame_sz / sizeof(u64)) -
> +			   (instance->max_chain_frame_sz / mr_nvme_pg_size) - 1) *
> +		     mr_nvme_pg_size;
> +
> +	lim->max_hw_sectors =3D min_t(u64, max_io_size, max_prp_io) >> SECTOR_S=
HIFT;
>  	lim->virt_boundary_mask =3D mr_nvme_pg_size - 1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827175743.7345=
93-1-t.lamprecht@proxmox.com?part=3D1
