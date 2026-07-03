Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB2388885
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783077107; cv=none; b=kM04s5YGgi5mw/vDvRi7wENKXX6dGC8FkGdEr9rKE8kK5nzo8/OoIB4KpVTw/ql/U12mwIr1T/J2pxJfZ1Xot2nT+hWEblie0KGRQwglXwFP7Jbf4xv46tK0FrbwEdqX1gQpAWn/zqNyNTnvJjU3129a2P4j4/XkIpx18pc6OWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783077107; c=relaxed/simple;
	bh=8QRyana2mIVwo+KzH3MUXWFMOWC7ssMaaOjHiU9vgrI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OL7vGzDtxFxHToOIZQQcJSKWXVRdriokxrQ/q8NRfZjnQ9A/oJzq0OaDgtAqHKzjbyuVGS/prFrL0bvsvjp+rGJmt7+jKQoq0PxmoUvItdTncuyfyhqOl4wJOOrXYv86uFVCW0zdDggMAN5ZQc4mLyIgdtQ6MOo6tZQ5kufLqnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJw9efiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJw9efiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA151F00A3A;
	Fri,  3 Jul 2026 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783077105;
	bh=V/9OZg3T7glbMFzp7Z/NI+Dt8/7M8IVwM/4W439AgOU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BJw9efiSI+Ufa+9MvdeYWH+8lNC8Gb4uvS/8tVpPMO6vOT4pvvavk9oLiqBI+4V8C
	 iTCEcoDkttSc+xTdCorfLPN9/B1PyMB1MpJsEckwEAu8kFoUdpAOdjWzlDJJ//mp4j
	 EDF5f27pgD9oCoawFI8Xp0h4jBNHH9b8k/vWRRlRu4TBa1zEPVmweF78uH+5907bRX
	 Q8F/a0thKk9elAWFqd4Rd4X9jUIiVvirBLtZD9Jh4FYJpO98A+WvegTmeyP4Ymqrx4
	 HXOtbRBDccoClTiMQyCd9K3kpOY7gptBHIzkWt+lb2z2onwtXPac4x/nC85Pt6+OE+
	 //CJs6oqVQ4gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/10] nvme-multipath: add nvme_mpath_cdev_ioctl()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-6-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:11:44 +0000
Message-Id: <20260703111145.4EA151F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Accessing `ns->ctrl` in `_nvme_ns_chr_ioctl()` leads to a Use-=
After-Free because the SRCU read lock protecting the namespace is dropped b=
y the caller.
- [Critical] `nvme_mpath_ioctl_begin()` fails to initialize `*data` for non=
-controller ioctls, causing a NULL pointer dereference or crash in `nvme_mp=
ath_ioctl_finish()`.
--

commit 7c14abcc0f25bf0d710bcb67c0dbd7f7f3dc3774
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add nvme_mpath_cdev_ioctl()

This commit adds nvme_mpath_cdev_ioctl() and related ioctl lifecycle
callbacks to handle SRCU read lock dropping during controller command
IOCTL handling for NVMe multipath character devices.

> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 664216eece4a6..14ac86b8b1a8a 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c

[ ... ]

> @@ -689,6 +695,29 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd=
 *ioucmd,
>  	return 0;
>  }
>  #ifdef CONFIG_NVME_MULTIPATH
> +long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned i=
nt cmd,
> +					unsigned long arg, bool open_for_write)
> +{
> +	return _nvme_ns_chr_ioctl(nvme_mpath_to_ns(mpath_device), cmd,
> +			arg, open_for_write);
> +}

[Severity: Critical]
Could this lead to a use-after-free on the namespace object?

When a userspace program issues a controller ioctl on a multipath char devi=
ce,
the generic mpath_chr_ioctl() drops the SRCU read lock before calling
nvme_mpath_cdev_ioctl().=20

While nvme_mpath_ioctl_begin() takes a reference to the controller, the
namespace object itself is left unprotected during this window. If the
namespace is concurrently removed, passing the unprotected ns pointer down =
to
_nvme_ns_chr_ioctl() and dereferencing ns->ctrl could access freed memory.

> +
> +void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
> +		unsigned int cmd, void **data)
> +{
> +	struct nvme_ctrl *ctrl =3D nvme_mpath_to_ns(mpath_device)->ctrl;
> +
> +	if (is_ctrl_ioctl(cmd)) {
> +		nvme_get_ctrl(ctrl);
> +		*data =3D ctrl;
> +	}
> +}

[Severity: Critical]
Does this leave *data uninitialized or unmodified for non-controller ioctls?

If a user issues a standard ioctl (like NVME_IOCTL_ID), is_ctrl_ioctl(cmd)
will evaluate to false, meaning *data is not assigned here.

> +
> +void nvme_mpath_ioctl_finish(void *opaque)
> +{
> +	nvme_put_ctrl(opaque);
> +}

[Severity: Critical]
Is it safe to unconditionally call nvme_put_ctrl() here?

If nvme_mpath_ioctl_begin() did not set *data (because it was not a control=
ler
ioctl), opaque might be NULL or uninitialized garbage.=20

Calling nvme_put_ctrl() unconditionally:

static inline void nvme_put_ctrl(struct nvme_ctrl *ctrl)
{
        put_device(ctrl->device);
}

will dereference ctrl->device, which could result in a panic if opaque is N=
ULL
or an invalid pointer. Should there be a check before calling nvme_put_ctrl=
()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D5
