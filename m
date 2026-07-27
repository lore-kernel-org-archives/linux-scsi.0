Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485D23D283
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164447; cv=none; b=hWUBh5JOrxuyPabg2iao5UecWijUc+qoCarUxOS+UFtRgEgq4DwSnHj6jmowdSk8cyh/ZNhKSm/QoO5QueI9/LxpL7HpQF0BEKQh8eSpMCYtgARYjxQLpQ2uCPRb9zcNXPoq5wV2buKuzw0HbZzwWNXhvKld0N0VRXzQ9L0r8+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164447; c=relaxed/simple;
	bh=CEmBjy9QGe2uA7ZUDnnP8hh+ZUGUGt25vQUWB9y0BwA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KslD08xOAdQB/11+TRb71a5vr9e08mBnjbj1QSHAxGWAmgM0rQkzOZRRGxdI+1WmTbWH5hj6mvuccDn/P+HEGViG3sjQcpuAUJF4COg/moJeKA6yCe4VRQdEIs4zMrv4hexvDxNJE1LEmfK2yTN+hg8OsSzs3VDqVqSauJuoTKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmLh/UQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmLh/UQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19231F000E9;
	Mon, 27 Jul 2026 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164445;
	bh=Y672xbyueNHvSod7+88W9rQ0TktRCOgbFMFrYYP9DOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HmLh/UQGZhxL7rqhskTwvYdJAm1G2Z+0uQE80BJhXO4za3KjSHl0mZX0LYomQRNsZ
	 IesbJPumH/YnZ3g56pPNdXj9h32XF4oi6E+dO7hsS7Aa/5BjsRG4Yxn10wsId0Vx2Z
	 TIotABwihjxr9fWaDEIZlPNtmaLaL4aAuurzlyfZAqBycJDvHw5V/vF7ZPYhnnAawk
	 alYUqasSyAoHASKMl3Uzt8jFAS3dvnK0T56tIoI/fcr1JN/7rf8A0aFYU/xXGSPEVj
	 MrrUDAaH0fHjH2XbzXM845q3GZpAZfw04Bznil5fm0L+Es8HOU9F2ZgUCsjqo0Z48/
	 TLNRaWpXkXDIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/27] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-7-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:00:45 +0000
Message-Id: <20260727150045.B19231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Missing synchronization between path addition and delayed removal =
causes Use-After-Free.
- [High] Missing cancellation of `remove_work` during head teardown causes =
Use-After-Free.
- [High] Disabling delayed removal via sysfs leaves queued I/Os stuck indef=
initely.
- [Medium] Module reference leak in `mpath_can_remove_head()` when delayed =
work is already pending.
- [Medium] 32-bit integer overflow in delayed removal seconds calculation.
--

--- Patch [6]: [PATCH v5 06/27] libmultipath: Add delayed removal support -=
--
commit c3a14a8d55791e59aaf6def4186888f9333f0985
Author: John Garry <john.garry@linux.dev>

libmultipath: Add delayed removal support

This patch adds support for delayed removal of multipath devices, similar to
NVMe. It introduces a configurable delayed removal window to retain the disk
and cdev during transient path loss.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index f70049b6cede9..ede06e5e901c8 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device,=
 struct gendisk *disk,
>  	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>  	mutex_unlock(&mpath_head->lock);
> =20
> +	if (cancel_delayed_work(&mpath_head->remove_work))
> +		module_put(mpath_head->drv_module);
> +

[Severity: High]
If mpath_remove_head_work() is already executing when we call
cancel_delayed_work(), the cancellation will fail and return false. By
dropping the lock before this check, is it possible for mpath_remove_head_w=
ork()
to unconditionally tear down the mpath_head without realizing a new path was
just added?

This might leave the newly added path with dangling pointers to the freed
multipath head. Should we hold the lock or verify the execution state of the
work item?

>  	return 0;
>  }

[ ... ]

> @@ -480,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *w=
ork)
>  	}
>  }
> =20
> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
> +{
> +	bool remove =3D false;
> +
> +	mutex_lock(&mpath_head->lock);
> +	/*
> +	 * Ensure that no one could remove this module while the head
> +	 * remove work is pending.
> +	 */
> +	if (mpath_head_queue_if_no_path(mpath_head) &&
> +		try_module_get(mpath_head->drv_module)) {

[Severity: Medium]
If the delayed work is already pending from a previous path failure,
mod_delayed_work() will update the timer and return true, but it will not
queue a new execution of the work item.

Since try_module_get() unconditionally increments the reference count before
this, will subsequent calls to mpath_can_remove_head() leak module referenc=
es
since mpath_remove_head_work() only executes once?

> +		unsigned long delay =3D mpath_head->delayed_removal_secs * HZ;

[Severity: Medium]
Could this multiplication overflow on 32-bit systems? Both
mpath_head->delayed_removal_secs (unsigned int) and HZ are 32-bit types, so=
 the
multiplication is evaluated in 32-bit arithmetic before being promoted to
unsigned long.

If a user writes a large value to the sysfs attribute, could this result in=
 an
unintended short delay or immediate removal?

> +
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
> +	} else {
> +		remove =3D true;
> +	}
> +
> +	mutex_unlock(&mpath_head->lock);
> +	return remove;
> +}
> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);

[ ... ]

> @@ -525,6 +571,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_he=
ad,
>  	mpath_head->disk->private_data =3D mpath_head;
>  	mpath_head->disk->fops =3D &mpath_ops;
> =20
> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);

[Severity: High]
Since this work is initialized here, do we need to ensure it is cancelled
during head teardown?

Looking at mpath_put_disk(), it flushes requeue_work and partition_scan_work
but does not appear to call cancel_delayed_work_sync() for remove_work. Cou=
ld
this leave the delayed work active in the workqueue after mpath_head is fre=
ed?

> +	mpath_head->delayed_removal_secs =3D 0;
> +
>  	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> =20
>  	return 0;

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	unsigned int sec;
> +	ssize_t ret;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);

[Severity: High]
When delayed removal is disabled by writing 0, the MPATH_HEAD_QUEUE_IF_NO_P=
ATH
flag is cleared. However, does this leave bios already queued in requeue_li=
st
stuck indefinitely?

Should we call mpath_schedule_requeue_work() here to ensure previously queu=
ed
I/Os are flushed and failed?

> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D6
