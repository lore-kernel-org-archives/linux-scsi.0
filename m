Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F747FAFC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 12:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326895; cv=none; b=YuktTymGJsQthuJbq/XYAG7gyum09/1WxO3xNP6kJVeHzav30qy68vNEfW4CTyQi0ZuWVTJf7OtgfXQb1vx0/QtsRWfhCTcufDhr3eUucDDIKkstwWaQ+oWoCLzw8Jv/q6ZpotpgzRBdLxEua5EKN84osj+qXJQ/okM7bbv4u90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326895; c=relaxed/simple;
	bh=GebGhFXs/Vr6+O1rQeJazgaMG7+DPkEsguLf55dphls=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o6I2uLZsZVypndUU0RC9FXP0yd3Srzy/LbulxEcGONjWw/s7SemDA+8HOwItpaOwqANc4tHm4GtGXm9rLjUTkiLlrJ9orn9rSRx+aFza7ZXWks/5Jfxbyh9MRmEfSt9oajleXF+DQZK8Eb19+X0wRr6Q13uq8aMGmMTGcqmqvh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2MYgatO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2MYgatO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555561F000E9;
	Wed, 29 Jul 2026 12:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785326892;
	bh=tj+nQRhtVruLhC2medwWTzNtkP5hk3Z6jmYIG5gWyBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e2MYgatOkqCpzyhpqNO9TSoBYRPTD1O7wKkx4Oon1VHAikpyhDCpQakzwpVDO6YWg
	 dcZrdDApbGbzwW66WyzEXEPeJoVp3BkGqIwQ9Bn6qiYdEl8I1npUkKN1qhmLckWaLV
	 CvKQgJaJRWClBHQLg7rYmfcY9TMNijMklIQWeil9BKnHQvBbMuhVcWWskw41UJrQqb
	 uP5njp9K5z0fNPXsal+OqtNb0SwP9mcy1/y3pgDzZdTwlUYdWDwHAKYAyHSje8jPp8
	 vmzjsr70snDp4vQrBVusg51Hcmq4HV0Gsvkhcoq8wUsKKtspGSv4YG1Qu/VK49wiFS
	 LIFWypWYF8jyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/27] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-7-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:08:11 +0000
Message-Id: <20260729120812.555561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] mpath_remove_head_work() unconditionally removes the multipath hea=
d without verifying if paths have been concurrently added, leading to destr=
uction of an active device.
- [High] Missing cancellation of remove_work during multipath head teardown=
 leads to a use-after-free when the delayed work expires.
- [High] mpath_head->drv_module is never initialized, leading to silent fai=
lures or crashes on module unload.
- [High] Disabling delayed removal via sysfs leaves queued I/Os stuck indef=
initely.
- [Medium] Module reference count leak when mpath_can_remove_head() is call=
ed multiple times.
- [Medium] Large delayed removal values cause immediate removal instead of =
a long delay.
--

--- Patch [6]: [PATCH v6 06/27] libmultipath: Add delayed removal support -=
--
commit 87d6b13fc148098f06b11013c5f12523eb0d477f
Author: John Garry <john.garry@linux.dev>

libmultipath: Add delayed removal support

Add support for delayed removal, same as exists for NVMe, to keep the
multipath disk and cdev present for intermittent periods of no available
path.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 6b8f6e846987a..fada92bf9754c 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -66,6 +66,9 @@ int mpath_add_device(struct mpath_device *mpath_device,=
 struct gendisk *disk,
>  	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>  	mutex_unlock(&mpath_head->lock);
> =20
> +	if (cancel_delayed_work(&mpath_head->remove_work))
> +		module_put(mpath_head->drv_module);
> +
>  	return 0;
>  }

[Severity: High]
Can this race with the removal work?

If the delayed work is already executing, cancel_delayed_work() returns
false, but mpath_add_device() still returns success. Meanwhile, could
mpath_remove_head_work() execute without taking mpath_head->lock or
verifying if the device list is empty, unintentionally destroying the
multipath head while the driver believes a new path was successfully
added?

[ ... ]

> @@ -481,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *w=
ork)
>  	}
>  }
> =20
> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
> +{
> +	unsigned long delay;
> +	bool remove =3D false;
> +
> +	mutex_lock(&mpath_head->lock);
> +	/*
> +	 * Ensure that no one could remove this module while the head
> +	 * remove work is pending.
> +	 */
> +	if (mpath_head_queue_if_no_path(mpath_head) &&
> +	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&

[Severity: Medium]
What happens if a user configures a very large delayed removal value?

If check_mul_overflow() detects an overflow (e.g., on 32-bit systems where
a large sysfs input overflows unsigned long), it fails the condition and
falls through to the else block, setting remove =3D true. Does this cause an
immediate teardown instead of clamping the delay to a maximum value?

> +	    try_module_get(mpath_head->drv_module)) {
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);

[Severity: Medium]
Could this lead to a module reference leak?

If mod_delayed_work() returns true (meaning the work was already pending
and its timer was just modified), it doesn't queue a new work item.
Since try_module_get() was called unconditionally beforehand, and the
work callback only drops one module reference, do subsequent calls to
mpath_can_remove_head() leak a module reference permanently?

> +	} else {
> +		remove =3D true;
> +	}
> +
> +	mutex_unlock(&mpath_head->lock);
> +	return remove;
> +}

[ ... ]

> @@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_he=
ad,
>  	mpath_head->disk->private_data =3D mpath_head;
>  	mpath_head->disk->fops =3D &mpath_ops;
> =20
> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
> +	mpath_head->delayed_removal_secs =3D 0;
> +

[Severity: High]
Is drv_module properly initialized anywhere?

It seems drv_module is added to struct mpath_head but never assigned in
mpath_alloc_head_disk() or elsewhere in this patch. If it defaults to
NULL, try_module_get(NULL) succeeds but pins no module. Could this allow
the driver to unload while the delayed work is still pending, leading to
a kernel panic when the timer fires?

[Severity: High]
Is the remove_work guaranteed to be cancelled during object teardown?

The standard teardown sequence calls mpath_put_disk() and
mpath_head_uninit(). If cancel_delayed_work_sync(&mpath_head->remove_work)
is omitted during teardown, could the timer remain active on the
workqueue and execute on the freed mpath_head structure later?

>  	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> =20
>  	return 0;

[ ... ]

> @@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  }
>  EXPORT_SYMBOL_GPL(mpath_device_set_live);
> =20
> +ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
> +					char *buf)
> +{
> +	int ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	ret =3D sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
> +	mutex_unlock(&mpath_head->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
> +
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
> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;
> +}

[Severity: High]
If a user disables delayed removal by setting delayed_removal_secs to 0 via
sysfs while paths are missing, how do pending I/Os get handled?

We clear the flag and call mpath_synchronize(), but shouldn't we also
call mpath_schedule_requeue_work() here to flush and fail the I/Os that
are already parked in mpath_head->requeue_list?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D6
