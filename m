Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80728257851
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784759535; cv=none; b=e+bwNcxd7Bt9oXpHnbbRZcJMwsCfZeaCmCHkxoUA1MgoC7Ul46VG/LebeNsBVmkUCU3RV8zYywzqdLGXmDfQUnktU0sf/L0IwCm+PCoiqtloP0NQjAzUtQ3rIr7Pen/ITqUjD5Ny6qHleU9SnSgZ+KpfaFlMTtamuN65zwq9Tws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784759535; c=relaxed/simple;
	bh=yZ6It3utopTPz3lRBbTsRK9zhFdBi7zPJEyLlfp11H8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i8Fm0XvIXQhzmMYu5lZTf3coiArfN2uwriQaq5LE4zdWDQNbm8N8QpE8keNIqdk+8mhkCAATaY8ikFdW74Ij580LCdwwzzCvJm0KhEgypuUknVgGfuqejuf0SJKdm5QxndHgxY9Kz5nUNxJiW/d9wiHNMw6iDjGyFBYri8K2H88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWDIJKSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWDIJKSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8A91F000E9;
	Wed, 22 Jul 2026 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784759534;
	bh=YeSJe20i8Am0oQ1VtiLCnNWvR+SX2/lN1xYqCrt1tY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HWDIJKSE7pfpmhZk3nBFzupu83JA6ZLf676JLH0IvOYfLUNUsnCswdRdPYbz++gLG
	 7wgt29hEhetsxDrKZMUwgl0HG2EB4Pri0DgnLNT3u5USjE78+6sTdoCkzrn1XiO0lC
	 jBb1EqYRj+6CAVY0QYPClZntjzwIS6c8Itg+albd5CTYSVud4zjlZ6KH34zNfRoxdV
	 GMgL4MDGmSSRClF5uTJTm4G3XBAP+++LWuaTGDKx3zn9s1rov1/JarxydVv3vAnWVB
	 xRW6zXADEq45t2J1TvL/EJdr7Nbx0fD0eMTQOvHJUDIfuN4wnIB9EGzPwdepdBUuTr
	 EuZcRTZpDtE+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/4] smartpqi: add support for CCISS_BIG_PASSTHRU
 ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Strahan" <david.strahan@microchip.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722220401.6357-3-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
 <20260722220401.6357-3-david.strahan@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 22:32:13 +0000
Message-Id: <20260722223213.EB8A91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unbounded `kmalloc` of user-controlled size prevents large transfe=
rs and triggers page allocation warnings.
- [High] Missing 32-bit compat ioctl translation for `CCISS_BIG_PASSTHRU`.
--

--- Patch [2]: [PATCH v1 2/4] smartpqi: add support for CCISS_BIG_PASSTHRU =
ioctl ---
commit 89c5d7119f80d6cae47c460c85b511017c1cd263
Author: David Strahan <David.Strahan@microchip.com>

smartpqi: add support for CCISS_BIG_PASSTHRU ioctl
   =20
This commit adds pqi_big_passthru_ioctl() to handle CCISS_BIG_PASSTHRU ioctl
requests. The new ioctl uses BIG_IOCTL_Command_struct which stores the buff=
er
size as a 32-bit integer, allowing larger transfers than the previous 64KB
limit.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 3a75b9fbedf45..473f1c9e47380 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c

[ ... ]

> @@ -6935,6 +6935,144 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_inf=
o *ctrl_info, void __user *arg)
>  	return rc;
>  }
> =20
> +static int pqi_big_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void =
__user *arg)
> +{

[ ... ]

> +	if (iocommand.buf_size > 0) {
> +		kernel_buffer =3D kmalloc(iocommand.buf_size, GFP_KERNEL);

[Severity: High]
Will this trigger page allocation warnings for large transfers?

Since iocommand.buf_size is a user-controlled 32-bit integer passed directly
here, a large allocation without __GFP_NOWARN could trigger a page allocati=
on
warning if it exceeds MAX_PAGE_ORDER. This might panic systems that have=20
panic_on_warn set.

> +		if (!kernel_buffer)
> +			return -ENOMEM;

[ ... ]

> +	if (iocommand.buf_size > 0) {
> +		put_unaligned_le32(iocommand.buf_size, &request.buffer_length);
> +
> +		rc =3D pqi_map_single(ctrl_info->pci_dev,
> +			&request.sg_descriptors[0], kernel_buffer,
> +			iocommand.buf_size, DMA_BIDIRECTIONAL);

[Severity: High]
Does this prevent the driver from handling the large chunked transfers this
ioctl was designed for?

Since the entire buffer is mapped to a single scatter-gather descriptor here
(sg_descriptors[0]), it seems to require physically contiguous memory from
the earlier kmalloc() call, rather than utilizing scatter-gather arrays for
large payloads. Memory fragmentation could cause large transfer requests to=
 fail.

> +		if (rc)
> +			goto out;

[ ... ]

> @@ -6958,6 +7096,12 @@ static int pqi_ioctl(struct scsi_device *sdev, uns=
igned int cmd,
>  	case CCISS_PASSTHRU:
>  		rc =3D pqi_passthru_ioctl(ctrl_info, arg);
>  		break;
> +	case CCISS_BIG_PASSTHRU:
> +		rc =3D pqi_big_passthru_ioctl(ctrl_info, arg);
> +		break;
> +	case CCISS_BIG_PASSTHRU_SUPPORTED:
> +		rc =3D 0;
> +		break;
>  	default:
>  		rc =3D -EINVAL;

[Severity: High]
Is a compat_ioctl handler needed for 32-bit applications?

BIG_IOCTL_Command_struct contains a trailing pointer (BYTE __user *buf), so
its size varies between 32-bit and 64-bit architectures (88 vs 96 bytes).
Because the _IOWR macro embeds the structure size in the ioctl command
number, a 32-bit application will emit a different command number
(e.g., CCISS_BIG_PASSTHRU32) than the 64-bit kernel expects.

Since there is no compat_ioctl callback for the smartpqi driver, will the
32-bit ioctl fall through to this default -EINVAL case?

Interestingly, since CCISS_BIG_PASSTHRU_SUPPORTED uses the _IO macro, it
is size-independent, so 32-bit utilities might successfully probe for
support but fail when actually issuing the transfer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722220401.6357=
-1-david.strahan@microchip.com?part=3D2
