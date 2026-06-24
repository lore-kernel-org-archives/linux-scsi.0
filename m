Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7463328FA
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782330471; cv=none; b=LRR0BFEhbf0qnDh/4OypW/mtg5aDijQnsHjfJzxpZaGDS0nwc7QWRphoIdeSS3ljiieL7aXziupdkzxi1i6oBpYsVAOzlQspysSDPov+lmVOluqt9SC0NubWap+i26eVMGTt104I5plAFdFp9V1JrFmtXVP7mimRRkJMJPPJwvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782330471; c=relaxed/simple;
	bh=KPFQHRyeF81xC7iwPFVGFvgOHHXThTUbATkJA/EsYXE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bn+NKwsMRtR5vQsmrdkTIXhrGX+hZHYIxkscmhy5dE/IMmTmy0fdBgFCf7d4p8t8zJYEp1nVezJ5Ar2+29ZXqv4aJZ1xiWuEJys9nuk8g1o57HahFmO5xxNA//T4Gw7iwY4ojuiTKWMc1fVD2tm91Q4yhzkBfi9pePsxLpC602E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cuudjp5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cuudjp5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209D41F000E9;
	Wed, 24 Jun 2026 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782330470;
	bh=iHKO44IRWvt4TdJ33aqxiLQ9SAhSxQiSfYh/WLxjs7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cuudjp5Y9wlmeH3dXoya+zl9O4zgdPtX738FIJ/0KudHQsFBn2FRFsAV4vVK2z36j
	 Cnen5W66M+yjWwLrzKjLtPn3foT9/E4OA4OCg1yRk9HUTnOqKYQ003NELsAFZYUGOl
	 /ms3DNdwcULXVr4Hyp/YFEHuwxn1plwyyAd0v1AvGC17/r0Uok+EpJxYK6MEuccFHF
	 VHnTHq67DvtKF0jsNO2YSmB8ywGWKZdMT+uP+o/PSCwr6Bm113ATlBkpYYHvAq65q3
	 I8gLhq5iPgq9V9/1ejagprrwrPE98LOgIMWDhNRoblDZY6m8iy7bfy3HLzHI+VsX4S
	 6BOml0BROczbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 3w-xxxx: validate AEN ioctl buffer length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624193121.5895-1-alhouseenyousef@gmail.com>
References: <20260624193121.5895-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 19:47:49 +0000
Message-Id: <20260624194750.209D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Arbitrary physical memory read/write via unvalidated scatter-g=
ather lists in TW_CMD_PACKET_WITH_DATA ioctl.
- [High] Out-of-bounds slab writes in 3w-9xxx.c when processing ioctls with=
 small data buffers.
- [High] Use-after-free on tw_dev due to missing Scsi_Host reference holdin=
g in character device open.
- [High] DMA use-after-free when hardware reset fails during ioctl command =
timeout.
--

commit 3b17020e8e124fad25e2ae1bcd6bfc20e4d712ff
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: 3w-xxxx: validate AEN ioctl buffer length

TW_OP_AEN_LISTEN copies a fixed AEN code into the ioctl data buffer, but
the coherent ioctl allocation is sized from the user supplied buffer
length. A zero-length or otherwise short buffer lets the handler write
past the allocated ioctl buffer.

Reject AEN listen requests whose data buffer is too small for the code
returned by the driver.

> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index c68678fa72c1e..147a47e6b3e55 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -908,6 +908,12 @@ static long tw_chrdev_ioctl(struct file *file, unsig=
ned int cmd, unsigned long a
>  		goto out;
>  	}
> =20
> +	if (cmd =3D=3D TW_OP_AEN_LISTEN &&
> +	    data_buffer_length < sizeof(tw_aen_code)) {
> +		retval =3D -EINVAL;
> +		goto out;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does the sibling driver
3w-9xxx.c suffer from the exact same out-of-bounds write that this commit
fixes?

In twa_chrdev_ioctl(), if the user provides a buffer length smaller than the
structure size, the fixed-size copy might overwrite the allocated buffer:

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl() {
    ...
    tw_compat_info =3D (TW_Compatibility_Info *)tw_ioctl->data_buffer;
    memcpy(tw_compat_info, &tw_dev->tw_compat_info,
           sizeof(TW_Compatibility_Info));
    ...
}


[Severity: High]
This is a pre-existing issue, but I noticed a potential use-after-free race
condition regarding the scsi_host reference.

In tw_chrdev_open(), we don't pin the Scsi_Host via scsi_host_get(). If the
device is concurrently hot-removed, tw_remove() frees the host data while
the file descriptor remains open.

Could a subsequent ioctl call dereference the freed tw_dev pointer here?

tw_chrdev_ioctl() {
    ...
    if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
    ...
}

>  	/* Hardware can only do multiple of 512 byte transfers */
>  	data_buffer_length_adjusted =3D (data_buffer_length + 511) & ~511;

[Severity: Critical]
This is a pre-existing issue, but is there a risk of arbitrary physical
memory access when handling TW_CMD_PACKET_WITH_DATA?

Later in tw_chrdev_ioctl(), the switch statement only overwrites sgl[0] for
specific opcode offsets:

tw_chrdev_ioctl() {
    ...
    switch (TW_SGL_OUT(tw_ioctl->firmware_command.opcode__sgloffset)) {
    case 2:
        tw_ioctl->firmware_command.byte8.param.sgl[0].address =3D
            dma_handle + sizeof(TW_New_Ioctl);
        ...
    }
   =20
    memcpy(tw_dev->command_packet_virtual_address[request_id],=20
           &(tw_ioctl->firmware_command), sizeof(TW_Command));
    ...
}

If a user with CAP_SYS_ADMIN provides an unhandled offset or additional SGL
entries (sgl[1..61]), it seems those unvalidated physical addresses are
copied into the command packet and passed directly to the hardware. Could
this be used to bypass kernel lockdown limits?


[Severity: High]
This is a pre-existing issue, but I have a question about the error handling
if a hardware command times out.

If the hardware fails to reset, we jump to out2:

tw_chrdev_ioctl() {
    ...
    if (tw_dev->chrdev_request_id !=3D TW_IOCTL_CHRDEV_FREE) {
        retval =3D -EIO;
        if (tw_reset_device_extension(tw_dev)) {
            printk(KERN_WARNING "...");
        }
        goto out2;
    }
    ...
}

At out2, the DMA buffer is freed:

out2:
    dma_free_coherent(&tw_dev->tw_pci_dev->dev,=20
                      data_buffer_length_adjusted + sizeof(TW_New_Ioctl),=20
                      cpu_addr, dma_handle);

If the hardware is still active because the reset failed, could it continue
processing the stalled command and write into these freed physical memory
pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624193121.5895=
-1-alhouseenyousef@gmail.com?part=3D1
