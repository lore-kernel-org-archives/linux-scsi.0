Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1874641D113
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164586; cv=none; b=p9OQIKkR3LIT4WVxlveslbiYzCm4OpsV0nWvu7sZN5/YojBRVCWuUNG4V8sCK8HHmediX9ApXq2PtyErW09xKkf+A6u3VTZLKoirv/GlY/gJWytgy7kkkX8hhrTiFCBXQoxEblJFNuZQgz+jtWibrCq3sPcNW5IWkfa2zog1cAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164586; c=relaxed/simple;
	bh=tY96em0cPxM3qmt9aLvXHIRDzHt7YC/XnsxEIvOQhAQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S+kS8cmvu3+TsmJ6AGEFc3v2DiBMAggV4FcpI1ehBAiYqTgrjrO13xYQGF9ZCchNNTjPUPiZHz9hmSTrzpuC2IApGwpXSFfHovqw0wauZLz0+OPq0Ps3qszRNzVXjlAyASi76gEw2o3wXPk/hBunQw7RGYVmKTmymE2GCEfZSOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7FA0UTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7FA0UTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28121F00A3E;
	Mon, 27 Jul 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164584;
	bh=dabkjjlc7gniS1b/vxEQCHoKxtBhw3JEHyO2z4H6jpg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W7FA0UTusuFY76dOwk+bESTQD6Mk6IgTbY6mqR4+t+40pgneZTR4AgAc2O+TFeuEX
	 yKq4uRexxd8FRPnrh1oHQG3e0u6s6Vsm1/dhBdZvMTrpoGXkjMplexcBiNVG38580O
	 d2z1aY/0sYu0FiaK/HwJ/ZU5I/dVl/QpcQ0hdcyE6KMNSXGAxa7hC3B3jFfBgV8qgc
	 mK2mnFRXPlrQk9448hM6DNorrBRBRiCxFYQYPYiB/0tef/7dZVGBFVhTvysNW29clZ
	 4LKPFt+PK29zd8gUY44jtIyQV5p2DOMiDzvEnfzCEc0i6nZK+rk+dua7279J4ucwRG
	 OTtvGoOu3B1vA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/27] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-4-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:03:03 +0000
Message-Id: <20260727150304.A28121F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Round-robin path selection can enter an infinite loop under the SR=
CU read lock if the current path is concurrently removed.
- [High] If `blk_alloc_disk()` fails, an `ERR_PTR` is left in `mpath_head->=
disk`, which will cause a kernel panic during cleanup.
- [High] Missing requeue list flushes in `mpath_device_set_live` and `mpath=
_remove_disk` cause IO stalls and bio leaks.
- [High] `mpath_round_robin_path` incorrectly returns a deleted path when t=
he path list becomes singular.
--

--- Patch [3]: [PATCH v5 03/27] libmultipath: Add path selection support ---
commit 88605e74a8a44a0f658b820940be9c7cdbbebc25
Author: John Garry <john.garry@linux.dev>

libmultipath: Add path selection support

This commit adds path selection support for NVMe ANA, abstracting it into
enum mpath_access_state. It introduces round-robin, NUMA, and queue-depth
selection modes along with iopolicy configuration functions.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index d2e334259f3c1..2b22c74760868 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +static struct mpath_device *mpath_round_robin_path(
> +				struct mpath_head *mpath_head)
> +{
> +	struct mpath_device *mpath_device, *found =3D NULL;
> +	int node =3D numa_node_id();
> +	enum mpath_access_state access_state_old;
> +	struct mpath_device *old =3D
> +			srcu_dereference(mpath_head->current_path[node],
> +				&mpath_head->srcu);
> +
> +	if (unlikely(!old))
> +		return __mpath_find_path(mpath_head, node);
> +
> +	if (list_is_singular(&mpath_head->dev_list)) {
> +		if (mpath_path_is_disabled(mpath_head, old))
> +			return NULL;
> +		return old;
> +	}

[Severity: High]
If the cached path (old) was concurrently unlinked from the list, is it
possible that list_is_singular() evaluates to true because there is exactly
one other valid path remaining? If so, does this mistakenly return the
unlinked old path (or NULL) instead of evaluating the single remaining valid
path?

> +
> +	for (mpath_device =3D mpath_next_dev(mpath_head, old);
> +	    mpath_device && mpath_device !=3D old;
> +	    mpath_device =3D mpath_next_dev(mpath_head, mpath_device)) {

[Severity: High]
If the currently cached path (old) is concurrently removed via
list_del_rcu(), it is unlinked from dev_list. Since mpath_next_dev()
iterates through the list, will this loop fail to encounter the unlinked
old pointer? If all remaining paths are non-optimized or disabled, could
this result in an infinite loop inside an SRCU read-side critical section?

> +
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;

[ ... ]

> @@ -75,6 +312,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
>  	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>  		struct gendisk *disk =3D mpath_head->disk;
> =20
> +		mpath_synchronize(mpath_head);
>  		del_gendisk(disk);
>  	}

[Severity: High]
When the disk is removed, are there potentially stranded bios left in the
mpath_head->requeue_list? Without a call to mpath_schedule_requeue_work()
here to flush the list, do these queued bios leak?

>  }

[ ... ]

> @@ -96,7 +334,7 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_hea=
d,
>  			struct queue_limits *lim, int numa_node)
>  {
>  	if (!mpath_head->disk_groups || !mpath_head->parent ||
> -	    mpath_head->disk)
> +	     !mpath_head->iopolicy || mpath_head->disk)
>  		return -EINVAL;
> =20
>  	mpath_head->disk =3D blk_alloc_disk(lim, numa_node);

[Severity: High]
If blk_alloc_disk() fails, does it leave an ERR_PTR in mpath_head->disk?
If the error pointer is not cleared here, would the cleanup path in
mpath_put_disk() mistakenly evaluate "if (!mpath_head->disk)" as false
and attempt to call put_disk() on the error pointer?

[ ... ]

> @@ -130,6 +368,19 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  		}
>  		queue_work(mpath_wq, &mpath_head->partition_scan_work);
>  	}
> +
> +	mutex_lock(&mpath_head->lock);
> +	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
> +		int node, srcu_idx;
> +
> +		srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +		for_each_online_node(node)
> +			__mpath_find_path(mpath_head, node);
> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	}
> +	mutex_unlock(&mpath_head->lock);
> +
> +	mpath_synchronize(mpath_head);
>  }

[Severity: High]
When a new path becomes available and transitions to live, does this functi=
on
need to call mpath_schedule_requeue_work()? If bios were held in the
requeue_list while no paths were available, could omitting this flush lead
to permanent I/O stalls?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D3
