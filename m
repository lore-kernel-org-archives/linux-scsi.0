Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC72360EC5
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 07:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786606743; cv=none; b=QO2GiDug+d1MioXD+Oq7fPWnrvb9BewffBE4TTcmkcUQwPRFmA8XoyA20rpJrigQ5xUvnwujTFuEPc01Pv5atGYQQRlhqTt1VPtzKNQk3D8i5GqZfPmECSt2473hDjycKDNCgXI7HMlJJV7uZm9zt83FK4BWsvJo1RAaRC9nBy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786606743; c=relaxed/simple;
	bh=nY3B0C5+iP2iGUCiyYTd0ThugTsexZTWA8r7GDFK+14=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ml5MjxzlSJi8XZ6lA/QSCAScb4ZejT9YvWoDzHZ69ZIjJKbfWbj6YaDzYpGlHk8K+I7DhLCXOuEzGHAo0/tD0L4TJUY7hu5z6ieSM08J+aM1WuJmHsrqK+7nm1hoCeKud1ISs+OlgR69WYt4KUbd75ZN8sNE8WH0Bd9TLxNhz+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBbu5fZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBbu5fZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808DE1F000E9;
	Thu, 13 Aug 2026 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786606741;
	bh=+uK+ddmXqS/3AY1OxbnaHo5FyBHq8hVNZYNSWPCcW6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kBbu5fZ7s1rNi4xiyaDn5gJvKZjO+QlRaWXfeyV6GxUmTCE/gnmpdYIpwfbHhxt0V
	 5R6y3a1JMb9tjkwhRAbo/G0gH/YIIdV0HzM4+Z7tChNwa4GjPF12jqV7qtl0m6jCer
	 QxDB6quN+KMEayeCk6UwRZuxT2lb3qsWjvwwO+TLJiQ8gideQuQ52b8exF7ldzCHbe
	 JjcsoED6v41mEUremloL6Pf68dM7UKFZ2LCCAFXKuYoaBJ5OHH7gInnA43He7/3qsC
	 uxOevwVG3S3h+1kb6eUCQ2tywi+zaJ9s4WJw74lbth0/vwMZ7KWltSAXmLHn8vI2DU
	 mi6fH49VJWyjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: leapraid: balance host references for
 firmware log VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linmao Li" <lilinmao@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260813072614.1387555-2-lilinmao@kylinos.cn>
References: <20260813072614.1387555-1-lilinmao@kylinos.cn>
 <20260813072614.1387555-2-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 07:39:01 +0000
Message-Id: <20260813073901.808DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unkillable sleep in device removal path if userspace keeps the mem=
ory mapped.
- [High] TOCTOU race in leapraid_fw_mmap allowing use-after-free of fw_log_=
buffer.
--

--- Patch [1]: [PATCH v2 1/2] scsi: leapraid: balance host references for f=
irmware log VMAs ---
commit f0e08e76b84e5bcaddf6147e197d89f0cec2a4e9
Author: Linmao Li <lilinmao@kylinos.cn>

scsi: leapraid: balance host references for firmware log VMAs

leapraid_fw_mmap() keeps the Scsi_Host reference obtained while
looking up the adapter for the lifetime of the initial VMA.  The VMA
close callback drops that reference.

The open callback is also invoked when a VMA is duplicated or split,
but it only increments mmap_refcnt.  Since every corresponding close
callback drops a host reference, cloning the mapping can release the
host while another VMA still refers to the adapter.

Take a host device reference for every VMA open and release the lookup
reference once the initial mapping has acquired its own reference.  Use
get_device() because a VMA can be cloned after the host enters SHOST_DEL;
an existing VMA still pins the host at that point and open cannot fail.

> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid=
/leapraid_app.c
> index 742f19c07fcbb..841027ce2501c 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
> @@ -697,6 +697,7 @@ static void leapraid_fw_mmap_open(struct vm_area_stru=
ct *vma)
>  	if (!adapter)
>  		return;
> =20
> +	get_device(&adapter->shost->shost_gendev);
>  	atomic_inc(&adapter->fw_log_desc.mmap_refcnt);

[Severity: High]
This is a pre-existing issue, but does this create an unkillable sleep in t=
he
device removal path?

If a user maps the firmware log buffer via mmap and never unmaps it, the
removal thread executing leapraid_fw_log_exit() in leapraid_func.c will blo=
ck
indefinitely waiting for the reference count to drop to zero:

    wait_event(adapter->fw_log_desc.mmap_waitq,
               !atomic_read(&adapter->fw_log_desc.mmap_refcnt));

Since there is no mechanism to forcibly revoke the mapping, could this allow
userspace to block device removal indefinitely?

>  }
> =20
> @@ -767,7 +768,6 @@ static int leapraid_fw_mmap(struct file *filp, struct=
 vm_area_struct *vma)
>  	vma->vm_private_data =3D adapter;
>  	vma->vm_ops =3D &leapraid_fw_mmap_vm_ops;
>  	leapraid_fw_mmap_open(vma);

[Severity: High]
This isn't a bug introduced by this patch, but is there a race condition he=
re
that allows a use-after-free of the firmware log buffer?

The buffer is mapped to user space via dma_mmap_coherent() earlier in this
function before mmap_refcnt is incremented here in leapraid_fw_mmap_open().

If a concurrent device removal preempts this thread right before
leapraid_fw_mmap_open() is called, leapraid_fw_log_exit() will see
mmap_refcnt =3D=3D 0 and free the buffer via dma_free_coherent().

When the mmap thread resumes, will it have successfully mapped freed kernel
DMA memory into user space?

> -	adapter =3D NULL;
> =20
>  	rc =3D 0;
>  out_put:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813072614.1387=
555-1-lilinmao@kylinos.cn?part=3D1
