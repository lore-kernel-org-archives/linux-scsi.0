Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC897299931
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261082; cv=none; b=L7JISKE45r6pXd8G82POzclp6jwCkSs/u5n0x9m8L4RLC55AA5R0AaBG3GbH/AkH6AwYOaw35xOj9UVv+R+wB7Mwdrf8MNA6nrQ+xpJ9Kl01ySfL2qblKeAGNhI0Kx0upeiL68e8SjMIlA06Rm1268E+sCDhnHpmhzlPgJvpKTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261082; c=relaxed/simple;
	bh=tBHhTDsndNjuCkISysX+gZeUrrHxd8ceLYbF0p7oQJI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KVdIfpLh3XwTcpl3OjCn0KlakI+niUUh+w6Gr3sXCGJrBufGMOvYYoqVAqnpVR8uM7g29uKKTbi62ai5XqgKai2w3zzXridvuo5vSjq1+1Rlaqh3vYuNW4b07ckMrl9hOC+25kMi4M3htyCIIDkYhq5kudNDyGJ9scwBLsCsoCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ew1y9oSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ew1y9oSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7DE1F000E9;
	Tue,  1 Sep 2026 11:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788261081;
	bh=G0pr1SScTJkhz/reL8T3Q3KLyLBmW65wmDU7Ypo6bNc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ew1y9oSmL6k4yG9J1UbKPxYEHw6rFfWohwNOmGwmI4TWHgxdaydUCosU/NIrFr1BF
	 xjLTy1xEo5RGCW5Gc83rPU1Sp1wQZQYlibvbrHSg6reaenEofPvwK2nbAwOfzQ9Htu
	 E3/ys4qMqMKDyfzdoDoybrd2Ds4oNZhCPIxE//9QXxj625jpOslqZUQZwPinWqspeY
	 n5KWmktO388gekltSLrnvMTKdO0Zak7l+yvqiGzZsEk/FlcH1JhEqNZ1P8wHdJ3jdf
	 T4tsulKIVXAKHtB/oeoBN6OdkL7RwrzloBSl/XnPwJzDpiDFLpMGNzzT76dDGC1fZb
	 1flEUlyqg1taA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 14/27] scsi-multipath: support iopolicy
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-15-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-15-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:11:20 +0000
Message-Id: <20260901111121.5C7DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] A TOCTOU race between updating the I/O policy and lockless path =
resolution can cause a path evaluated under the old policy to be permanentl=
y cached.
--

commit 23d70dc129a3932ccedd2e25833214d5d4fedd20
Author: John Garry <john.garry@linux.dev>

scsi-multipath: support iopolicy

Add support to set the multipath iopolicy. The default policy can be set via
a module parameter, and it can be dynamically updated via a sysfs attribute.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1c04947d906ea..7164bc61e65e1 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -99,8 +116,41 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct d=
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
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Medium]
Is there a race condition here between updating the I/O policy and lockless
path resolution?

If an administrator writes to the iopolicy sysfs attribute while an I/O
request is concurrently finding a path, this sequence appears possible:

Thread 1 (I/O) evaluates the path under the current policy (e.g.,
round-robin) and selects a path.

Thread 2 (sysfs) updates the policy to NUMA here in
scsi_mpath_device_iopolicy_store(), and calls mpath_clear_paths(), setting
current_path[node] =3D NULL.

Thread 1 finishes path selection and executes this in __mpath_find_path()
located in lib/multipath.c:

	if (found)
		rcu_assign_pointer(mpath_head->current_path[node], found);

This would overwrite the NULL with the path chosen under the old policy.
Subsequent I/Os calling mpath_numa_path() would see a non-NULL
current_path[node] and use it directly, permanently caching a stale path
under the new policy.

Does mpath_clear_paths() need synchronization against concurrent path
resolutions to prevent caching paths evaluated under the old policy?

> +	mpath_schedule_requeue_work(mpath_head);
> +	/*
> +	 * Ensure requeue work completes, as this work could run later when
> +	 * the mpath_head is gone.
> +	 */
> +	flush_work(&mpath_head->requeue_work);
> +	return count;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D14
