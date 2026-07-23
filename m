Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CCB435EEA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802049; cv=none; b=aTSvrrPzF8118l2TlXB9cWSJr/6q2VDF2ITu1miIbLrZ5NE0ByOOs7ZDTl5MkOAuxnWxzmy10LFD8xtDd0q3zqQR2VO5NjQsgnOAzRu/wTpLS6yVuPjnCBFkol8Prw0HSyRGv1a5HYB7R2SCHowz5YW9Unqla9tkq3YmmBeSwcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802049; c=relaxed/simple;
	bh=r3v4WgbUgggbUdtEEOuLTJKZvAbNDc4cAWUVT3kqiWE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QCBch8Y6EtuFZriezwYzCgjKq4oNmZy7BCWWFKq5gTFdHypFKciQ6101FlLlypwbeluqePyMzBVMQ3AuXsnzmg+xpIRyXQ3Lm/dtd4ACcvC9bZ9UPXRMs2Jj8EnxbuUU4tWFmNSXmX46mJejIDa7SuORFKivPK9CFhTGfCv88uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzsyHcdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzsyHcdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B431F000E9;
	Thu, 23 Jul 2026 10:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802046;
	bh=02oXI5yTUqagHJ3d6hxtNbisb77IBiKIP3o+CfA2bKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lzsyHcdZD0icU5nC2Y5q+6P5sFwmIz74iw9jpo4UcDSEWqrkpb6MbmYQSsn9yfzXa
	 GwpAj1Z4BU733B85IbtADP/DqdwY0T679k5DXOgiDQpJZtZ1+FkLiGN0ManUf7p3dz
	 adScGKhQxvXcMy0GxKvxe6yH/V8AGsGkpA4vdKDI9Xt5ihMZaJChygsJnbBPmabEz4
	 vogtrEV2V35WWJlldo5caiqBhUYqUbAbuL0UPPOeMk1pdcOUwN1uIA598WTaPB0omF
	 VAU0l6Nz1DV/dq3SuqaKzIT0+YgkY02SOmGt1pt8AVx5Rj+b0G+rLU29lp9eI2OL7D
	 oBOzzkNlFryIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/28] scsi-multipath: support iopolicy
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-16-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-16-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:20:36 +0000
Message-Id: <20260723102046.35B431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Use-after-free on requeue_work during device teardown after sysfs =
store.
- [Low] Data race on global iopolicy module parameter.

Pre-existing issues:
- [High] TOCTOU race exposing uninitialized sysfs attributes to userspace.
--

--- Patch [15]: [PATCH v4 15/28] scsi-multipath: support iopolicy ---
commit d1b32244eafe032033fe9c1b3cb04bb7a990a08a
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: support iopolicy

This commit adds support for configuring the multipath I/O policy. It
introduces a new iopolicy member to the scsi_mpath_head structure and adds a
module parameter to set the default policy.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 59d1c0b2d3441..6228ff4be4ff7 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_o=
ps =3D {
>  module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
>  MODULE_PARM_DESC(multipath, "turn on native multipath support, options: =
on, off, always");
> =20
> +static enum mpath_iopolicy_e iopolicy =3D MPATH_IOPOLICY_NUMA;
> +
> +static int scsi_mpath_set_iopolicy_param(const char *val, const struct k=
ernel_param *kp)
> +{
> +	return mpath_set_iopolicy(val, &iopolicy);
> +}

[Severity: Low]
Does this introduce a data race on the global module parameter?

The global iopolicy variable is updated locklessly here, and read locklessly
when assigning it later in scsi_mpath_alloc_head(). Should this use
READ_ONCE() and WRITE_ONCE() to prevent KCSAN warnings and ensure proper
concurrency hygiene?

> +
> +static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_=
param *kp)
> +{
> +	return mpath_get_iopolicy(buf, iopolicy);
> +}
> +
> +module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
> +		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
> +MODULE_PARM_DESC(multipath_iopolicy,
> +	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queu=
e-depth'");
> +

[ ... ]

> @@ -96,8 +113,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct d=
evice *dev,
>  }
>  static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
> =20
> +static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +		container_of(dev, struct scsi_mpath_head, dev);
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
> +		return -EINVAL;
> +
> +	mpath_clear_paths(mpath_head);
> +	mpath_schedule_requeue_work(mpath_head);

[Severity: High]
Can mpath_schedule_requeue_work() trigger a use-after-free during device
teardown?

If a sysfs write occurs concurrently with device removal, the asynchronous
requeue work is scheduled here. The teardown path in scsi_mpath_head_releas=
e()
frees the scsi_mpath_head structure without calling cancel_work_sync() to
cancel this pending work.

Could the workqueue access freed memory when it executes the queued functio=
n?

> +	return count;
> +}
> +
> +static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{

[ ... ]

> @@ -201,6 +246,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(=
void)
>  	if (mpath_head_init(&scsi_mpath_head->mpath_head))
>  		goto out_free;
>  	scsi_mpath_head->mpath_head.mpdt =3D &smpdt;
> +	scsi_mpath_head->iopolicy =3D iopolicy;
> +	scsi_mpath_head->mpath_head.iopolicy =3D &scsi_mpath_head->iopolicy;
> =20
>  	scsi_mpath_head->index =3D ida_alloc(&scsi_multipath_dev_ida, GFP_KERNE=
L);
>  	if (scsi_mpath_head->index < 0)

[Severity: High]
This is a pre-existing issue, but does this allocation path contain a race
condition exposing uninitialized sysfs attributes to userspace?

Later in scsi_mpath_alloc_head(), device_add() is called which registers the
device and fires a KOBJ_ADD uevent. However, the caller scsi_mpath_dev_allo=
c()
only populates the scsi_mpath_head->vpd_id data after scsi_mpath_alloc_head=
()
returns.

Could userspace udev rules react to the new device and read an empty vpd_id
string before it is fully initialized?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D15
