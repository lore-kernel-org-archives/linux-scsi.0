Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C47835A933
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 05:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786687113; cv=none; b=BIj4iudNx0t3CtiVFn9E15KAtYlO2/kVzEkkK9W+Fl9ylCWEoFXDQAmwUbWIH8aB2IdmOCPpPyTwzY5Ph1zLjIyUGy5zlNXZqrQdrrTa6WMqtKDSKH0CWaS8nbXBUkZ3PsmCb+P0cNGFnd5eVZt3Nfsv83csVFstuWnBf+CB9Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786687113; c=relaxed/simple;
	bh=LCv6Vx9WPgFyvIWWcs39m/e56cT/bP43ZBoEMXsaYys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PImXYi+70m9MO7G/TH7pl/X3ymB+SryZW0cG/5zM8ZZkQTVjlkcQ5ijdQGwH33m9BdrftL/V/aZYfYKGbdF4OGiuOPnv+tc0WDS0nYNZw+sbu9gN7ksZe82kw52Uy3gGNrrVvQy4d6C35CXQT6W2P5CC2rC/+f9FLxY7c/sME3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3PN+NWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3PN+NWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E900A1F000E9;
	Fri, 14 Aug 2026 05:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786687112;
	bh=T4SkXVEYT7lJNrPEnVJfOuy9c1lIAOn4gsdazVcKJVs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G3PN+NWxEI9TxuKKAhD3Ihex4phV3+CmGkYUkz/EB19DgoY8w/UNCsjeI7KTJPkHI
	 sQYEAT4PmUga2QJIJ9a605OWWa+gX2TgIVJKg9Xotc3iRtkLIpavXWhQA98twcpICJ
	 qnWDebqqbBctc0itfvAWVWJrXXyu56bjDfNjqSc6yWxaE3M9s7SLSU7jXqWVUdh0i/
	 nxpnO8cvDKkEUnorMiQwDgbFAiP25WrfD5m5L68Tmy7f0DWtMRrpZXRrG1NXBD+kAj
	 rTIDqhSIj+U02ZWvPr/uH6uhuyhG8QWJ4/DHNM6Za2s3UEp9zK44GexHXIs2Xs8ovv
	 uhugfUP3JipNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pmcraid: check device_create() return value
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linkai Gong" <gonglinkai@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814054513.2519483-1-gonglinkai@kylinos.cn>
References: <20260814054513.2519483-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 05:58:28 +0000
Message-Id: <20260814055831.E900A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Medium] The new error path for `device_create()` failure introduces a Us=
e-After-Free because `cdev_del()` does not revoke active file descriptors.

Pre-existing issues:
- [High] The error path in `pmcraid_probe` frees adapter buffers before dis=
abling hardware or unregistering the interrupt handler, leading to ISR UAF.
- [High] Missing `cancel_work_sync()` on probe error path causes workqueue =
Use-After-Free.
- [Medium] Missing `scsi_host` refcounting in character device file operati=
ons leads to a Use-After-Free upon device removal.
- [Medium] Data race on the `pmcraid_minor` global bitmap during concurrent=
 PCI probing.
- [Medium] A time-of-check to time-of-use (TOCTOU) race condition and missi=
ng bounds check allow exceeding `PMCRAID_MAX_ADAPTERS`, leading to an out-o=
f-bounds write.
--

--- Patch [1]: [PATCH] scsi: pmcraid: check device_create() return value ---
commit b3e81f4a9bfa636816d6ecf5e77c7bcf9c823cca
Author: Linkai Gong <gonglinkai@kylinos.cn>

scsi: pmcraid: check device_create() return value

This commit adds a check for the return value of device_create() in
pmcraid_setup_chrdev(). If it fails, the driver now cleans up by deleting
the cdev and releasing the assigned minor number.

> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 942a993932049..65a87d30e65fe 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4721,12 +4721,21 @@ static int pmcraid_setup_chrdev(struct pmcraid_in=
stance *pinstance)
>  	pinstance->cdev.owner =3D THIS_MODULE;
> =20
>  	error =3D cdev_add(&pinstance->cdev, MKDEV(pmcraid_major, minor), 1);
> +	if (error) {
> +		pmcraid_release_minor(minor);
> +		return error;
> +	}
> =20
> -	if (error)
> +	error =3D PTR_ERR_OR_ZERO(device_create(&pmcraid_class, NULL,
> +					      MKDEV(pmcraid_major, minor), NULL,
> +					      "%s%u", PMCRAID_DEVFILE, minor));
> +	if (error) {
> +		pmcraid_err("failed to create device file for minor %d, error %d\n",
> +			    minor, error);
> +		cdev_del(&pinstance->cdev);

[Severity: Medium]
If a user opens the device right after cdev_add() but before device_create()
fails, does cdev_del() revoke the active file descriptor?

When the probe fails here, it returns an error and eventually calls
scsi_host_put(), freeing pinstance. If the user still holds an open file
descriptor, would any subsequent ioctl() or close() lead to a use-after-free
of the pinstance structure?

>  		pmcraid_release_minor(minor);
> -	else
> -		device_create(&pmcraid_class, NULL, MKDEV(pmcraid_major, minor),
> -			      NULL, "%s%u", PMCRAID_DEVFILE, minor);
> +	}
> +
>  	return error;
>  }

[Severity: Medium]
This is a pre-existing issue, but is there missing scsi_host refcounting in
the character device file operations?

drivers/scsi/pmcraid.c:pmcraid_chr_open() {
	pinstance =3D container_of(inode->i_cdev, struct pmcraid_instance, cdev);
	filep->private_data =3D pinstance;
}

Since pmcraid_fops lacks a .release callback to properly balance refcounting
with scsi_host_put(), could this lead to a use-after-free? If an admin
keeps the device open during a PCI hot-remove, pmcraid_remove() calls
scsi_host_put() and frees pinstance. Does this leave the open file descript=
or
pointing to freed memory?

[Severity: High]
This is a pre-existing issue, but does the error path in pmcraid_probe() fr=
ee
adapter buffers before disabling hardware or unregistering the interrupt
handler?

drivers/scsi/pmcraid.c:pmcraid_probe() {
...
out_release_bufs:
	pmcraid_release_buffers(pinstance);

out_unregister_isr:
	pmcraid_kill_tasklets(pinstance);
	pmcraid_unregister_interrupt_handler(pinstance);
}

If pmcraid_probe() fails after pmcraid_reset_bringup() and jumps to
out_release_bufs, the hardware is still fully active while its DMA memory
buffers are freed. If the adapter sends an interrupt (like a Configuration
Change Notification) during this window, can the ISR access freed host
resource request queues and cause a use-after-free?

[Severity: High]
This isn't a bug introduced by this patch, but does the probe error path mi=
ss
cancelling the worker queue?

drivers/scsi/pmcraid.c:pmcraid_probe() {
out_remove_host:
	scsi_remove_host(host);

out_release_bufs:
	pmcraid_release_buffers(pinstance);
}

If a hardware event schedules pinstance->worker_q before a probe failure, t=
he
error teardown frees pinstance without calling cancel_work_sync(). Will the
system workqueue later attempt to execute the callback on freed memory?

[Severity: Medium]
This is a pre-existing issue, but is there a data race on the pmcraid_minor
global bitmap during concurrent PCI probing?

drivers/scsi/pmcraid.c:pmcraid_get_minor() {
	minor =3D find_first_zero_bit(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
	__set_bit(minor, pmcraid_minor);
}

Since __set_bit() is non-atomic and there is no lock protection here, could
two threads probing multiple adapters concurrently read the same available =
bit
and claim the same minor number?

[Severity: Medium]
This is a pre-existing issue, but is there a race condition that can lead to
an out-of-bounds write?

drivers/scsi/pmcraid.c:pmcraid_probe() {
	if (atomic_read(&pmcraid_adapter_count) >=3D PMCRAID_MAX_ADAPTERS) {
...
	atomic_inc(&pmcraid_adapter_count);
}

The adapter count check uses atomic_read() followed separately by atomic_in=
c().
If concurrent probes interleave and bypass this limit, find_first_zero_bit()
in pmcraid_get_minor() will return PMCRAID_MAX_ADAPTERS (1024) since all bi=
ts
are set.

Because there is no bounds check before calling __set_bit(), does this resu=
lt
in writing beyond the end of the pmcraid_minor bitmap array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814054513.2519=
483-1-gonglinkai@kylinos.cn?part=3D1
