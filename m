Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B178431E74
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800635; cv=none; b=u/fQYGJNa3NPzjZJOpXerECtttlgh/GwomBH9N4mgL6UGtGT+zII/x3s41kfuWIqrH+acqzfl6Io8R9O7l1eYkuSH2CMAPK374VzuN0MSKI+1AX94XDGpeSM4FrpJ6FvLEYWL2A5PHU2akyiqdtpm9vJ010PIggJx95faLxF7gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800635; c=relaxed/simple;
	bh=0/IVj3Mh/8vPaXb+KXwociqddUSccZ2HmNLX0ehW9kw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I86ql5zhXS8FX6tOS7lw6+zohvsBBSLK7RTcZ4sQ+0WIwmMUKbDs9k7PuBtzYwwzPOGq0evmpszJazt80hpPURk05ic/9uarYlOH8Trun6iBsXFQHey7UemCpDABmJE59Qoitc98oWbH/+AHvxBugEeHHifo5//McTnIhLLIqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayq8wzJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayq8wzJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD361F000E9;
	Thu, 23 Jul 2026 09:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800633;
	bh=ZwCAXcMRMSv1/TyOebBigqpM+c4ANolPeGymf53gErI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ayq8wzJpG0btPZTKJE/t2MPTGsA9BWTLp93jlj/APNY99Kzm3y3LmJON55KDdvCe1
	 15UR4v7zDQDPCwAy07bj9vKW67fgTba3F0cJ1eU1dspklxPLfIY9HRUV1kpRuit/dC
	 vyl99xObKjXNV8PXK0ejYSXkOIrwlEkipV/D0oYF/wdD8MBoywwazGxZp9xRbc1t9y
	 8eYts5XBzbyiNJVElrXLAOtjA/VyRBgZLaLp3KJYoLOxUjzPOlpeaZKADGbBqXCAwf
	 58ESG1519gdICepyVOWE/FCUa3oO1V6lb3wfzFo1C2t74a4k0xl3jU/z5VBW11OUmi
	 h4Zk3F7NuyLzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/28] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-7-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:57:12 +0000
Message-Id: <20260723095713.5BD361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Concurrent path addition and delayed removal execution causes a us=
e-after-free by destroying an active multipath head.
- [High] Missing synchronous cancellation of `remove_work` during `mpath_he=
ad` teardown leaks the delayed work.
- [Medium] Module reference count leak in `mpath_can_remove_head()` when ca=
lled multiple times.
- [Medium] Passing a signed `int *` to `kstrtouint()` causes sign-extension=
 and massively inflated timeouts.
--

--- Patch [6]: [PATCH v4 06/28] libmultipath: Add delayed removal support -=
--
commit e89d624119c3a1b6148c925347d05a0886a18e1d
Author: John Garry <john.garry@linux.dev>

libmultipath: Add delayed removal support

Add support for delayed removal, same as exists for NVMe. The purpose
of this feature is to keep the multipath disk and cdev present for
intermittent periods of no available path. A removal work callback is
supplied by the driver.

> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index 6915c2a979642..44e26c16b3dc4 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h

[ ... ]

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 20c633ad7e1df..1fa4bd6677051 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device,
>  	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>  	mutex_unlock(&mpath_head->lock);
> =20
> +	if (cancel_delayed_work(&mpath_head->remove_work))
> +		module_put(mpath_head->drv_module);
> +

[Severity: High]
Could this lead to a use-after-free if the delayed work is already executin=
g?

When mpath_add_device() calls cancel_delayed_work():

lib/multipath.c:mpath_add_device() {
    ...
    if (cancel_delayed_work(&mpath_head->remove_work))
        module_put(mpath_head->drv_module);
    return 0;
}

If the timer has already expired and mpath_remove_head_work() is actively
running, cancel_delayed_work() returns false and this function proceeds to
add the device and return success.=20

Concurrently, mpath_remove_head_work() executes mpdt->remove_head(mpath_hea=
d)
without taking mpath_head->lock, which destroys the multipath head while we
are adding a new path to it.

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
> +
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
> +				mpath_head->delayed_removal_secs * HZ);

[Severity: Medium]
Is there a module reference leak if this is called multiple times while the
timer is already pending?

If mpath_can_remove_head() is called multiple times in succession,
try_module_get() acquires a new reference each time. However, if the work
is already queued, mod_delayed_work() returns true but does not queue a
duplicate work item.

When the timer expires, mpath_remove_head_work() executes only once and cal=
ls
module_put() only once, leaking the additional references acquired during
the subsequent calls.

> +	} else {
> +		remove =3D true;
> +	}

[ ... ]

> @@ -524,6 +570,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_he=
ad,
>  	mpath_head->disk->private_data =3D mpath_head;
>  	mpath_head->disk->fops =3D &mpath_ops;
> =20
> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
> +	mpath_head->delayed_removal_secs =3D 0;
> +

[Severity: High]
Should there be a matching cancellation of remove_work during the teardown
path?

The delayed work is initialized here, but mpath_put_disk() only flushes
requeue_work and partition_scan_work before putting the disk. If the
multipath device is torn down while the delayed removal timeout is still
pending, does this leak the active timer and result in a use-after-free
when mpath_remove_head_work() eventually executes on the freed memory?

>  	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> =20
>  	return 0;

[ ... ]

> @@ -567,6 +616,47 @@ void mpath_device_set_live(struct mpath_device *mpat=
h_device)
>  }
>  EXPORT_SYMBOL_GPL(mpath_device_set_live);

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	ssize_t ret;
> +	int sec;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);

[Severity: Medium]
Does passing a signed integer to kstrtouint() cause sign-extension issues
for large values?

The variable sec is declared as a signed int, but kstrtouint() expects an
unsigned int pointer. If a user writes a value greater than or equal to
2147483648, kstrtouint() will parse it correctly, but it will be stored as
a negative value in the signed int.

When sec is later assigned to mpath_head->delayed_removal_secs (which is
an unsigned long), it will undergo sign extension on 64-bit platforms,
resulting in a massive positive timeout value.

> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D6
