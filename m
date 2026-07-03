Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50093BB10C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075508; cv=none; b=LP9PP3XwSSe7I3FYggTXDO3C9PB9iON0wgRzNEpsCCWZFHQwiVyFdjFP+PMR3sW1bJ3yDmCYEZLz8nU7ejpBHIb6n6MrDJ7DnX4U99M2fEKNaRNZ8Vevw52jfJmYXpJFzaMS38SQd2Ng5xruVjyzMt20C3Qsj2VULJVtlxl+48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075508; c=relaxed/simple;
	bh=j8pkVEqSf/46PfaHjEs/tIur6m6COjc2qB5C/ML68q4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p/hHkL2cwQRkYZSRcMAuanU8g4/iJDrAv9P3Ryycq/nYnOMGjJsFAP6XBS3uKo+L3RSo3xUFEDVzzMm1CO3t1aRenmYaFbJGFzeUIOICYTIzqTeEoS0UuDya6cSYcXiWJlDu9NIaUOLRG6u5ufq8V9AO4y0tk/mOQjHghxVJceo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZb/AzmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZb/AzmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF051F000E9;
	Fri,  3 Jul 2026 10:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075506;
	bh=51MIHWFxJZP7Ohizw1Cf7Vb6UBRLRp/J8PbETkNL6ow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RZb/AzmFEeGpP0HhjGfYhypmf+OtA2TxpwJRW2s3TWtiRbkIPZqCRFGOjum37HCqX
	 p8nhH4h5C3IOIsx8oVSGV03bTHx3ACwdINxLrdBV99EcA9TssAok4J2/sGvP9xo4WJ
	 99hjQ8C5sgaHEjxnZrNOuhj3rsO8YSWURWLw6Xp9ZlEXaG/5IQmthGc+K7MXivkQDc
	 /5SlzTepPiyCaJNLskNrzqaw92qx34Go28OLo3aR9sMSeq0UIXa+ZRxxpb6ZWguAJa
	 yCr8SpB8qZE3X3APT7TTb/ASNCIKnjqJQ8WEerXaZF07qfw5fx5ajD/F/Isv6J497L
	 ZRBGv2yfCVvIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/13] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-7-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:45:06 +0000
Message-Id: <20260703104506.9CF051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] Repeated calls to `mpath_can_remove_head()` leak module references=
 when removal work is already pending.
- [High] Race condition between `mpath_add_device()`, `mpath_can_remove_hea=
d()`, and `mpath_remove_head_work()` leads to use-after-free of mpath_head.
- [High] Missing cancellation of delayed removal work on `mpath_head` teard=
own results in Use-After-Free.
- [High] `mpath_head->drv_module` is never initialized by the subsystem API=
, leading to a silent failure to pin the driver module.
- [Medium] Disabling delayed removal via sysfs fails to cancel already pend=
ing removal work, leading to unexpected device removal.
- [Low] Incompatible pointer type passed to `kstrtouint()` causes compiler =
warnings.
- [Low] Integer overflow when calculating the delay for `mod_delayed_work()=
` results in severely shortened delays.
--

commit c00bb95222f826ebc3e8dbd55ff6884abf84858e
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add delayed removal support
   =20
Add support for delayed removal, same as exists for NVMe.
   =20
The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 007aa34796569..78f88b0664c78 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -61,6 +61,8 @@ void mpath_add_device(struct mpath_device *mpath_device,
>  	mutex_lock(&mpath_head->lock);
>  	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>  	mutex_unlock(&mpath_head->lock);
> +	if (cancel_delayed_work(&mpath_head->remove_work))
> +		module_put(mpath_head->drv_module);
>  }

[Severity: High]
Does this code introduce a use-after-free race condition?

If the delayed removal timer is already executing, cancel_delayed_work()
returns false.=20

mpath_add_device() will successfully add the device, but the
already-executing mpath_remove_head_work() unconditionally calls
mpath_head->mpdt->remove_head() without checking for newly added devices.

Could the newly added device access the destroyed mpath_head?

[ ... ]

> @@ -518,6 +530,39 @@ static void mpath_requeue_work(struct work_struct *w=
ork)
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

[Severity: High]
Is mpath_head->drv_module initialized anywhere in the subsystem API?

If it remains uninitialized (e.g., NULL from zero-allocated structures),
try_module_get(NULL) will silently succeed.=20

Could this lead to a failure to pin the driver module, potentially resulting
in a crash if the module is unloaded while the timer is pending?

> +
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
> +				mpath_head->delayed_removal_secs * HZ);

[Severity: High]
Does this unconditionally increment the module reference count even when the
timer is already pending?

If mpath_can_remove_head() is called multiple times, try_module_get()
will increment the reference count on each call.=20

However, mod_delayed_work() merely modifies the existing timer. When the
timer eventually fires, mpath_remove_head_work() calls module_put() only
once, leaking the additional module references and preventing unloading.

[Severity: Low]
Does this multiplication overflow on 32-bit systems?

mpath_head->delayed_removal_secs is an unsigned int, and HZ is typically
an integer.=20

Could their product overflow 32-bit arithmetic before being promoted to
unsigned long for mod_delayed_work(), leading to shortened delays?

> +	} else {
> +		remove =3D true;
> +	}
> +
> +	mutex_unlock(&mpath_head->lock);
> +	return remove;
> +}
> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);
> +
> +static void mpath_remove_head_work(struct work_struct *work)
> +{
> +	struct mpath_head *mpath_head =3D container_of(to_delayed_work(work),
> +			struct mpath_head, remove_work);
> +	struct module *drv_module =3D mpath_head->drv_module;
> +
> +	mpath_head->mpdt->remove_head(mpath_head);
> +	module_put(drv_module);
> +}

[ ... ]

> @@ -562,6 +607,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_he=
ad,
>  	mpath_head->disk->private_data =3D mpath_head;
>  	mpath_head->disk->fops =3D &mpath_ops;
> =20
> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
> +	mpath_head->delayed_removal_secs =3D 0;
> +
>  	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);

[Severity: High]
Is the delayed removal work reliably canceled during final teardown?

During explicit device teardown (like a driver unbind), functions like
mpath_head_cleanup() are called to free resources.=20

Since this patch doesn't add a cancel_delayed_work_sync() call to the
cleanup path, could an active timer fire after the mpath_head has been
freed, leading to a use-after-free?

[ ... ]

> @@ -605,6 +653,47 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	ssize_t ret;
> +	int sec;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);

[Severity: Low]
Does passing an int pointer to kstrtouint() cause compiler warnings?

sec is declared as an int, but kstrtouint() strictly expects an unsigned
int *.=20

Could this cause an incompatible pointer type warning and potential undefin=
ed
behavior on architectures with differing int/unsigned int layouts?

> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);

[Severity: Medium]
Should the active timer be canceled when delayed removal is disabled?

When a user writes 0 to disable the feature, this code clears the flag but
misses a call to cancel_delayed_work(&mpath_head->remove_work).=20

If the timer is already pending, will it continue to run and eventually
destroy the head, contrary to the user's configuration?

> +	mutex_unlock(&mpath_head->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D6
