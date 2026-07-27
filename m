Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B92541B8D5
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164783; cv=none; b=bpSW+MoOm36ZRbGt/tkFWWioPUCtGY3eyQeJn31B16lkksp/claX0l0iP6KPRXWNNOrL3JyqrTp5CdGLQRPHg2QTqhp9Jc/avwGRGb1Z3f2gXUFJsUIr4GesGLycl8iq4c8XQyWK5C9r1ORHJoaAXd2cjx80V3IgQHMtWMXdKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164783; c=relaxed/simple;
	bh=4zsHqWN4MQeLBJIZMveOxy/dinaXGqOcei3/uQmnjpQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TPHkgSN9PCxyxAxCtYpby3Wsu2Da7b1WAEJCV8aWREcYiNK79h3RNBwkiZQZIbZcZZJfKxeaPSFlSlB2FSI7PYfE9EKGa8iJpFqTJ14TVxQzMliLQ9e9UlKiG8Ow6qKgp7gTzGtoxkgwb9WdK8zL4jBMqLls6mbyVxRV5xXNmbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0At8zkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0At8zkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8457A1F000E9;
	Mon, 27 Jul 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164781;
	bh=k/aKp6a3tc8pTvz/KDt2ZYI+kSSjRuqUcHX+m4oMPZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0At8zkm/iJZXobqFHrt4X3sDv37n7/I7HQg+5n6Gz8LEnVFs7qtAEqlBaw54uDB8
	 tZIxj1bibI12QKovwfKGfz+k2sfIcO2XoIEdZAYk4MShuIR/K/sn0XEWCaahtaFxF1
	 H+aQBTf9NdbHTCjPbTYGE6b6XESeCXzWpuLA7GTQTWjV3gd3L2+FsXH23Tyukqec9g
	 944ogBrDHe1j9mguH4PCH0aiwms/KLWYE89WAA5sva5tutMOhCNyd+4k2lGBX3HjTx
	 yt8fQmgsPJcURC3W6Yr2YBKSPEGtaJ3EYjoZuDOgGsp8kEj6+esFJ4vy2F9WIs/lWQ
	 +n3MCcntQm4GA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/27] scsi-multipath: support iopolicy
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-15-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-15-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:06:21 +0000
Message-Id: <20260727150621.8457A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing `cancel_work_sync()` for `requeue_work` in the device rele=
ase path leads to a Use-After-Free.
--

--- Patch [14]: [PATCH v5 14/27] scsi-multipath: support iopolicy ---
commit fea581175f41f33e0cbfa8e1c00312d8a25daa1c
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: support iopolicy
   =20
Add support to set the multipath iopolicy. The iopolicy member is per
scsi_mpath_head structure. A module param is added so that the default
iopolicy may be set.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1866f282c15cc..1b955e19a6814 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -97,8 +114,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct d=
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
Does this code introduce a use-after-free risk during device teardown?

If a user writes to the iopolicy sysfs attribute here, mpath_schedule_reque=
ue_work()
is called, which schedules mpath_head->requeue_work asynchronously.=20

If the SCSI device is subsequently unbound or removed before this work comp=
letes,
scsi_mpath_head_release() frees the scsi_mpath_head structure. It doesn't a=
ppear
to call cancel_work_sync() to ensure the scheduled work is stopped before f=
reeing.

When the workqueue eventually executes mpath_requeue_work(), could it deref=
erence
the freed mpath_head memory when accessing requeue_lock?

lib/multipath.c:mpath_requeue_work() {
    ...
    spin_lock_irq(&mpath_head->requeue_lock);
    ...
}

> +	return count;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D14
