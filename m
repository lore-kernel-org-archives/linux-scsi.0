Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB4356751
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782344796; cv=none; b=HQIgT//Uj5Lz0QnpGCcP+auTCsInzPJ62/WaIsfoGPHCgYndEWb4A8YpgeMH3dLRLqapgU/ccmk2n5Eaa3ihOgcn75isjy8nyh/yrGXw3uKyxeo2W0ndBWymUHeUAfyk/Bnb80JJ30OcHSapvWg5lbwt5h5ymDLLeDZh/w9UyUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782344796; c=relaxed/simple;
	bh=rrZd6eALQfsrxPBBpnq4e+oYY/61C8vgWoSdec7H3xo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EFA7riUsdINGbzd1qU6s0oEgojB5bn9ocdY9s2qAv4UX0Fzrs2jc0lgeUOvzWOKuHuzgRNASRvYV5mcnVzLeH4eDpB6fbbF0Y1elDhav2DZAkrpw+NAkUJm1UEujZKzC/Sc60+uFD0tLkPAaqnBAqXbAOj+7vlNDQNN06aDsMCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RG0YuAOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RG0YuAOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9F71F000E9;
	Wed, 24 Jun 2026 23:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782344795;
	bh=esh3pmzd/iG0oGTRZw3N9vDHw0fZX/QD2D3yTxX22SM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RG0YuAOlxEILiJVCvil+laZYreIKJ3jVRhHm9GXMwXA0hLE0OgEg9lm0ZDEWKYFao
	 lSy+agjYq/A990vh7q4xnaqB9DFHw2/iFSiC7kke/MqinsXwP/y8Z3OcgqVYND3Ah6
	 fOXjzprcdvqFQ89R5OhJqDxjBaRUwe6imoqq2e1i0oR1qjLRT6z2S2rC4wQp5aR9DK
	 dl+vrQc4NFlJVMRQbYu2pS3bSaDrYjiYLDteCsLBlyGfHl4G3mV+Goj0CRiYQbpXhA
	 pylmImRBSZdICTJIJHE6pvinBne52XCQuqSOvQXchhRR1frOh4Rt3db4FlxGbUn6LX
	 bjtn/gdPmJzSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: validate ioctl data buffer sizes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624192839.5631-1-alhouseenyousef@gmail.com>
References: <20260624192839.5631-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 23:46:34 +0000
Message-Id: <20260624234635.3D9F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Arbitrary physical memory read/write via untruncated user-supp=
lied SGL array in `twa_load_sgl`.
- [High] The patch misses an identical buffer overflow vulnerability in the=
 sibling driver 3w-xxxx.c.
- [High] Hardware DMA Use-After-Free if controller reset fails during comma=
nd timeout.
- [High] Out-of-bounds write of DMA address and length in `twa_load_sgl` du=
e to unvalidated `oldcommand->size`.
--

commit 69ffecc286b1d761a2c8d6da1c54662b5737e454
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: 3w-9xxx: validate ioctl data buffer sizes

Several 3w-9xxx character ioctls read or write fixed-size structures in
the ioctl data buffer, but allocation is based only on the user supplied
buffer_length. This patch requires the data buffer to be large enough for
the fixed payload used by each local ioctl before allocating and copying
the full request.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 9b93a2440af8f..a125801e3aad9 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -653,6 +653,7 @@ static long twa_chrdev_ioctl(struct file *file, unsig=
ned int cmd, unsigned long
>  	ktime_t current_time;
>  	TW_Device_Extension *tw_dev =3D twa_device_extension_list[iminor(inode)=
];
>  	int retval =3D TW_IOCTL_ERROR_OS_EFAULT;
> +	unsigned int min_data_length =3D 0;
>  	void __user *argp =3D (void __user *)arg;
> =20
>  	mutex_lock(&twa_chrdev_mutex);

[ ... ]

> @@ -673,6 +674,26 @@ static long twa_chrdev_ioctl(struct file *file, unsi=
gned int cmd, unsigned long
>  		goto out2;
>  	}
> =20
> +	switch (cmd) {
> +	case TW_IOCTL_GET_COMPATIBILITY_INFO:
> +		min_data_length =3D sizeof(TW_Compatibility_Info);
> +		break;
> +	case TW_IOCTL_GET_LAST_EVENT:
> +	case TW_IOCTL_GET_FIRST_EVENT:
> +	case TW_IOCTL_GET_NEXT_EVENT:
> +	case TW_IOCTL_GET_PREVIOUS_EVENT:
> +		min_data_length =3D sizeof(TW_Event);
> +		break;
> +	case TW_IOCTL_GET_LOCK:
> +		min_data_length =3D sizeof(TW_Lock);
> +		break;
> +	}
> +
> +	if (driver_command.buffer_length < min_data_length) {
> +		retval =3D TW_IOCTL_ERROR_OS_EINVAL;
> +		goto out2;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does a similar regression
exist in the sibling driver 3w-xxxx.c?

If the TW_OP_AEN_LISTEN ioctl is issued with data_buffer_length set to 0, t=
he
driver appears to allocate exactly sizeof(TW_New_Ioctl) bytes, leaving 0 by=
tes
for the flexible array member data_buffer.

drivers/scsi/3w-xxxx.c:tw_chrdev_ioctl() {
    ...
    memcpy(tw_ioctl->data_buffer, &tw_aen_code, sizeof(tw_aen_code));
    ...
}

Could this lead to an out-of-bounds write of 2 bytes into kernel memory?

[Severity: High]
This is a pre-existing issue, but looking further down in twa_chrdev_ioctl(=
),
could this sequence lead to hardware DMA into freed memory?

If an ioctl command is sent to the hardware but times out, the driver
attempts to reset the controller.

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl() {
    ...
			twa_reset_device_extension(tw_dev);
			goto out3;
    ...
}

If the reset fails, the hardware might still be active.

Since the code unconditionally jumps to out3 and frees the DMA coherent buf=
fer,
could the hardware still DMA into the freed memory if it completes the comm=
and
later?

[Severity: High]
This isn't a bug introduced by this patch, but I have a question about how
the SGL pointer is calculated in twa_load_sgl().

If a user issues TW_IOCTL_FIRMWARE_PASS_THROUGH with a small buffer_length
but a large oldcommand->size:

drivers/scsi/3w-9xxx.c:twa_load_sgl() {
    ...
				sgl =3D (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->size - (sizeof(TW=
_SG_Entry)/4) + pae);
			else
				sgl =3D (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode=
__sgloffset));
			sgl->address =3D TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
			sgl->length =3D cpu_to_le32(length);
    ...
}

Since oldcommand->size is unvalidated, could this calculation result in an
out-of-bounds write of the DMA address and length into kernel memory?

[Severity: Critical]
This is a pre-existing issue, but does the hardware process additional
user-supplied SGL entries?

In twa_load_sgl(), oldcommand->size is modified to account for PAE:

drivers/scsi/3w-9xxx.c:twa_load_sgl() {
    ...
		oldcommand->size +=3D pae;
    ...
}

If the user embeds multiple SGL entries and oldcommand->size is not truncat=
ed
to a single entry, could the hardware process subsequent malicious SGL
entries and access arbitrary physical memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624192839.5631=
-1-alhouseenyousef@gmail.com?part=3D1
