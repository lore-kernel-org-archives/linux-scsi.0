Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B45472F64
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324005; cv=none; b=sZB9nNLGMfWkZwpg/07pespBxuaLz+yw3TtyGSM04s73Vq40+xOEF94JyzI8ozbzXAUJ4/NqbZ/OIwm8awfn4yL2h/7jHdmOTU/eX2E5pNZ44DkFVlbfrZbsps4t8YxXFOFIZqstOe9b0FA0/ezxa/+tO2/yHNzXhn/g0rj05uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324005; c=relaxed/simple;
	bh=jqYTBrqRve3UQVk/u9J8gxAitTrcAYe6MjGEV57YgCI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hzwp0l668DlZ4ktF2i+b1+J1dPbbk/SaRxafca4u1XkFHq4/a9UN8xlknb0n8gwEhCmYvjDT+RCNzSmcx+YZS4J7gaX3AEJ+3cDd/7KiWUIZOwD2Ru/WxMC6Hos3dn1Q13UmQ5Zyv6MATE4ekN0aJanL7/Qg2r//Hg6tyJuQEwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAX+duKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAX+duKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD36B1F00A3D;
	Wed, 29 Jul 2026 11:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324003;
	bh=1qtW5zubg37Y0G/Nl9Na+VTod/29TlLxtWcIsOdUIMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAX+duKc7SCWDgwn2fNR2f0yWDob7z+fjri/0qNLwjBkWiJ+3IraISM9KCJK6NHRd
	 M5JmNzGLAVKCas6a2n7xUi3tGOXUL1pjQ68To8mUS7eHYzXxt12Ic82iqron/qyytK
	 LtejPrss0jmq6zbAjUC51sR4WVAcg7sMBmGm3JL8oog7yZawm8Vfadda+RKkuFxiAV
	 R3yU7eAw1HtUcWo9UKFtI7IALTfll8bbt/GRy62PsHS6uZnLCfo0bEsFOSSJmLxIdX
	 a+965a17vUMHWo6VEHV4FjkxA5IUrlKQ9/F/naGCPOTOTJz2+dhbvvXGxsj/gR4W0+
	 kQS4yLGNEMuAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/27] libmultipath: Add basic gendisk support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-3-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:20:03 +0000
Message-Id: <20260729112003.AD36B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The block_device_operations struct `mpath_ops` lacks the mandatory=
 `submit_bio` callback, causing `device_add_disk()` to unconditionally fail=
 and preventing the multipath disk from functioning.
- [High] Re-using `gendisk` after `device_add_disk()` failure violates the =
driver model and causes kobject corruption.
- [High] `mpath_head_uninit()` synchronously blocks on open file descriptor=
s, causing device removal to hang indefinitely if userspace holds the devic=
e open.
--

--- Patch [2]: [PATCH v6 02/27] libmultipath: Add basic gendisk support ---
commit 0995e161443bbd8d5024681ae6aeaebc37bafd47
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add basic gendisk support

This commit adds support to allocate and free a multipath gendisk.
It introduces struct mpath_head_template as a method for drivers to
provide custom multipath functionality.

> diff --git a/lib/multipath.c b/lib/multipath.c
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
[ ... ]
> @@ -36,6 +36,107 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
[ ... ]
> +const struct block_device_operations mpath_ops =3D {
> +	.owner          =3D THIS_MODULE,

[Severity: High]
Does setting the owner to THIS_MODULE (libmultipath) rather than the caller
module (such as nvme_core) introduce a regression where the caller module c=
an
be unloaded while the disk is held open by userspace? If the caller's module
exit calls mpath_head_uninit(), could it hang indefinitely in an
uninterruptible wait on the refcount, permanently deadlocking module_mutex?

> +	.open		=3D mpath_bdev_open,
> +	.release	=3D mpath_bdev_release,
> +};

[Severity: High]
Is this regression missing a submit_bio callback in mpath_ops? For bio-based
queues, the block layer's __add_disk() mandates that disk->fops->submit_bio
is present. If it is absent, device_add_disk() unconditionally aborts and
returns -EINVAL, which prevents the multipath block device from registering.

[ ... ]
> +void mpath_device_set_live(struct mpath_device *mpath_device)
> +{
[ ... ]
> +	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
> +		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
> +		ret =3D device_add_disk(mpath_head->parent, mpath_head->disk,
> +				mpath_head->disk_groups);
> +		if (ret) {
> +			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
> +			return;
> +		}

[Severity: High]
If device_add_disk() fails, clearing the live flag without freeing the
disk leaves the object intact. When this function is called again for anoth=
er
path, won't it retry device_add_disk() on the exact same gendisk object?
Because the driver model forbids calling device_add() more than once on the
same device object and requires dropping the device upon failure, could this
regression result in kobject BUGs or memory corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D2
