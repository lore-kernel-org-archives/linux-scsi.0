Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C02E331EC7
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782379868; cv=none; b=lkc2P4VGHjik4ew7Eg4kZpcDpZGRmjGja8e0WUTHYgwrxwh2n/I4A7nAStiv6zxl8G9r0xcrr3sVntNTmS982iL7TsJSsHgT/xw7FPEFkghFeTU5/yeRnw5vxijoDrmEQCmGIVh22ZgpnO22ILZERQJJfeHkQvCiZQv5jOr3UFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782379868; c=relaxed/simple;
	bh=4dOglFpvwXOBGQwGORy4YgPYH0o/jbTs/I11x4X+2Y4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bjvTItaUTWBUd6igidu57pXMbPN3aqdnNtcKomoveeghOmjJcvkY3cWOM20y0q8u9rO8UDtgGePd7Jz+lrX3f+uLWlDNTBjbQKra3YG7H6IGdCxsgm9y2T1FO07KpVDbSM/eKFue5Wfyq9l/fNmEgI6q091HtqysgXVm1yYWOG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD3Goucc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD3Goucc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D7F1F000E9;
	Thu, 25 Jun 2026 09:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782379866;
	bh=LXq6jyr1KmAXrOMT5OrHXP9AnkAAAnwZiWRyxihWw/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eD3GouccfHzvZ/zBj3cyyv4ol7yFmDibS58MzSFF9F54kT9ZAwBKSNkPGWuTwwotA
	 tNxTzifoc9mdYMljPqkaTkPmRxO60DG/tR28mGWhNjAhYhk8/65LBh9t7rcSzEuJcD
	 +qENzCxI+a3OemFJfI2mpFIgxM7e2CrR/HSELsieteF0DImn7zi/7cvhWRjJ10Q1kP
	 QQRjbCMwtNQbZNMMoYfFNWaCOfFNWYSySkJzxI+EFHlzvQyc4ZAP0TDYlv3gih9pRM
	 LPFg1YZfBJVIB6yBaxoDsWoeFuqYi5gWreC4sG6/orm4hdGFtJFakJ41zYi7dc6zf1
	 vmQHMNWz/ka6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: 3w-9xxx: sanitize passthrough SGLs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260625085842.4522-1-alhouseenyousef@gmail.com>
References: <20260625085842.4522-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 09:31:06 +0000
Message-Id: <20260625093106.B0D7F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Medium] Failure in `copy_to_user()` is silently ignored for `TW_IOCTL_FI=
RMWARE_PASS_THROUGH` commands because `retval` is prematurely set to 0.

Pre-existing issues:
- [High] Missing minimum `buffer_length` validation allows an out-of-bounds=
 write of up to 112 bytes on the `dma_alloc_coherent` heap for non-passthro=
ugh ioctls.
- [High] A character device ioctl Use-After-Free exists if a controller is =
removed (hot-unplugged) while a file descriptor remains open.
- [High] The exact same SGL injection and command size vulnerabilities exis=
t in the sibling driver 3w-sas, which is not addressed by this patch series.
--

commit 511c1e3b0d7a73d0dd03209ebbb80ee6964280e4
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>
scsi: 3w-9xxx: sanitize passthrough SGLs

This patch validates legacy SGL placement, enforces command sizing for
single buffers, and clears SGL arrays before copying user requests to
prevent exposing stale coherent memory.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 9b93a2440af8f..22f5fa1e473f6 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
[ ... ]
> @@ -686,6 +688,8 @@ static long twa_chrdev_ioctl(struct file *file, unsig=
ned int cmd, unsigned long
>  	}
> =20
>  	tw_ioctl =3D (TW_Ioctl_Buf_Apache *)cpu_addr;
> +	memset(tw_ioctl, 0, sizeof(TW_Ioctl_Buf_Apache) +
> +	       data_buffer_length_adjusted);

[Severity: High]
This is a pre-existing issue, but is there a use-after-free if the device
is hot-unplugged while the character device file descriptor is open?

In twa_remove(), the device extension is freed, but the stale pointer is not
cleared from the global twa_device_extension_list array:

drivers/scsi/3w-9xxx.c:twa_remove()
   twa_free_device_extension(tw_dev);
   scsi_host_put(tw_dev->host);
   ...
   twa_device_extension_count--;
  =20
Then in twa_chrdev_ioctl(), the driver fetches the pointer directly from the
array and dereferences it without verifying its lifetime:

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl()
   TW_Device_Extension *tw_dev =3D twa_device_extension_list[iminor(inode)];
   ...
   if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
  =20
Could this lead to memory corruption if a user calls ioctl() during removal?

[Severity: High]
This is also a pre-existing issue, but does this allocation lack minimum
buffer_length validation, leading to an out-of-bounds write?

If an event-retrieval ioctl (like TW_IOCTL_GET_COMPATIBILITY_INFO) is called
with buffer_length =3D 0, data_buffer_length_adjusted will be 0, and
dma_alloc_coherent allocates exactly sizeof(TW_Ioctl_Buf_Apache) bytes.

However, the driver later blindly copies up to 112 bytes into the flexible
array:

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl()
   memcpy(tw_ioctl->data_buffer, tw_dev->event_queue[event_index], sizeof(T=
W_Event));
  =20
Since tw_ioctl->data_buffer sits outside the allocated size when
buffer_length is 0, will this corrupt the DMA heap?

> =20
>  	/* Now copy down the entire ioctl */
>  	if (copy_from_user(tw_ioctl, argp, sizeof(TW_Ioctl_Buf_Apache) + driver=
_command.buffer_length))
> @@ -706,7 +710,14 @@ static long twa_chrdev_ioctl(struct file *file, unsi=
gned int cmd, unsigned long
>  		full_command_packet =3D &tw_ioctl->firmware_command;
> =20
>  		/* Load request id and sglist for both command types */
> -		twa_load_sgl(tw_dev, full_command_packet, request_id, dma_handle, data=
_buffer_length_adjusted);
> +		retval =3D twa_load_sgl(tw_dev, full_command_packet, request_id,
> +				      dma_handle, data_buffer_length_adjusted);

[Severity: Medium]
Does this assignment cause copy_to_user() failures to be silently ignored?

Because twa_load_sgl() returns 0 on success, retval is overwritten to 0 her=
e.
Later in twa_chrdev_ioctl(), the copy_to_user() check looks like this:

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl()
   if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_co=
mmand.buffer_length) =3D=3D 0)
       retval =3D 0;
      =20
If copy_to_user() fails, the condition evaluates to false, skipping the
assignment. But since retval is already 0, the error is lost and 0 is
returned to userspace instead of -EFAULT. Will this cause userspace to
process uninitialized or stale data as valid firmware output?

> +		if (retval) {
> +			tw_dev->chrdev_request_id =3D TW_IOCTL_CHRDEV_FREE;
> +			twa_free_request_id(tw_dev, request_id);
> +			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
> +			goto out3;
> +		}
[ ... ]

[Severity: High]
This is a pre-existing issue and outside the scope of this file, but does t=
he
exact same SGL injection and command size vulnerability exist in the sibling
driver 3w-sas?

Looking at twl_load_sgl() in drivers/scsi/3w-sas.c, the SGL offset appears
completely controlled by the user, and trailing SGL elements are not zeroed
out:

drivers/scsi/3w-sas.c:twl_load_sgl()
   sgl =3D (TW_SG_Entry_ISO *)((u32 *)newcommand + newcommand->sgl_offset);
   sgl->address =3D TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
   sgl->length =3D cpu_to_le32(length);
  =20
Since it lacks the bounds checking added here for 3w-9xxx, can a user
with CAP_SYS_ADMIN pass arbitrary physical DMA descriptors to the firmware?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625085842.4522=
-1-alhouseenyousef@gmail.com?part=3D1
