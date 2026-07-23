Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B05542B303
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800667; cv=none; b=rHeIwdWeYWiWdowa9wXeSIwFZnosT3NL8oEc/V9xUUCW+4w9UwgHVWWt0ZgoouYTwZ62ZRpva5Rmpe8l7vyyfDhYbScsvWfvb5Q5uZS93Fp+YyUGIi6wCyWwAUXbGhXts6bDjTS8PMZ7vgbBSshxEKYcHXrhadA2MXYRtIENu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800667; c=relaxed/simple;
	bh=sTXvPRCt67kysWjG9wZXHEjKTNuzuzlCydJFRhk2Cvo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hn44wnBB4sUSAGT9sJuidIFUFac0Li/kZDPs4PPm/2o4QkaI/dz5wQDVvWH9SQ402Frad5QhfDXp26yIJO4NxDb1Y+Y7V/1iwnSGodHvD8CuUZg+wEVhnhzE4z8sOSddHqnU8gyg1dQgYFbAHatim7swRFF8ffiKBViE+AVHEHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pt+1zBIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pt+1zBIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90D21F000E9;
	Thu, 23 Jul 2026 09:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800665;
	bh=pRHYADzU8S6X499Z2ZICypk0jwSf/YWClZWu6BCuTn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pt+1zBITdZryTpFcrRUiBPfc/Nqe1rik/wXoqNQPT275+4OXIzooQRe2MoGgiM9Ou
	 IlMenvAM/6eWldXcjq02hG00hKztC6ItQQs5M10TDIcnuqNclYTu7UQIY4voRySlI1
	 dyFWcd2mRyGPaamo1XuyatQHXzveAxvkNI+wZTQr7Bt7YyM98V4V6t9kpVN5uxbh4k
	 H2Tf5J/kJFaJUBlfqAIAg5FksKv3dd/LSUG8FOMB6vLBzPRxNv82Vpiwe0wqzdDiCT
	 GGjv21Pffl9nZqyTQpCHWQbTwDsPbzXC2J6tsc0gL6j2UuUvwFGYEcNWMZk53Rzful
	 6gUCqb646f8tg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/28] libmultipath: Add basic gendisk support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-3-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:57:43 +0000
Message-Id: <20260723095745.A90D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] mpath_alloc_head_disk() leaves an ERR_PTR in mpath_head->disk on a=
llocation failure, causing a kernel panic during cleanup.
- [High] mpath_head_init() fails to initialize multiple work items (remove_=
work, requeue_work), leading to kernel warnings and crashes.
- [High] The mpath_ops block_device_operations struct lacks a .submit_bio c=
allback, causing device_add_disk() to fail unconditionally.
- [High] mpath_head_uninit() uses a synchronous wait for userspace file des=
criptors to close, deadlocking kernel unplug paths.
- [Medium] mpath_put_disk() claims to clean up pending bios but fails to sc=
hedule or flush requeue_work, leaking bios.
--

--- Patch [2]: [PATCH v4 02/28] libmultipath: Add basic gendisk support ---
commit 8b695b95ebd074db05fc7130622e9ffd48786c4d
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add basic gendisk support

This patch adds support to allocate and free a multipath gendisk. It
introduces the mpath_head_template to provide custom multipath functionalit=
y.
NVMe-like functions are added to manage multipath structures.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 9cc398d266adf..916d01a285284 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -35,6 +35,102 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(mpath_head_uninit);

[Severity: High]
Does mpath_head_uninit() use a synchronous wait for userspace file
descriptors to close?

It appears this function contains:
wait_var_event(&mpath_head->refcount,
    refcount_read(&mpath_head->refcount) =3D=3D 1);

If userspace holds the block device open (for example via udev or
monitoring tools), this regression might block the kernel thread executing
the device removal forever in TASK_UNINTERRUPTIBLE, leading to a deadlock.

[ ... ]

> +const struct block_device_operations mpath_ops =3D {
> +	.owner          =3D THIS_MODULE,
> +	.open		=3D mpath_bdev_open,
> +	.release	=3D mpath_bdev_release,
> +};

[Severity: High]
Is it intentional to omit the .submit_bio callback here?

When mpath_device_set_live() is called, it triggers device_add_disk(),
which uses the block layer's __add_disk() function. This function verifies
that bio-based disks have a valid ->submit_bio pointer.

Since it is missing, this regression might unconditionally fail with
-EINVAL, preventing the multipath disk from being added to the system.

[ ... ]

> +void mpath_put_disk(struct mpath_head *mpath_head)
> +{
> +	if (!mpath_head->disk)
> +		return;
> +
> +	/* make sure all pending bios are cleaned up */
> +	flush_work(&mpath_head->partition_scan_work);
> +	put_disk(mpath_head->disk);
> +}

[Severity: Medium]
Will pending bios actually be cleaned up without flushing requeue_work?

The comment indicates pending bios are handled, but drivers using the
requeue functionality might have bios stranded in mpath_head->requeue_list
unless mpath_head->requeue_work is also scheduled and flushed here.

[ ... ]

> +int mpath_alloc_head_disk(struct mpath_head *mpath_head,
> +			struct queue_limits *lim, int numa_node)
> +{
> +	if (!mpath_head->disk_groups || !mpath_head->parent)
> +		return -EINVAL;
> +
> +	mpath_head->disk =3D blk_alloc_disk(lim, numa_node);
> +	if (IS_ERR(mpath_head->disk))
> +		return PTR_ERR(mpath_head->disk);

[Severity: High]
Can this assignment leave an error pointer in mpath_head->disk on failure?

If blk_alloc_disk() fails, it returns an error pointer which is stored here
and not cleared before returning. Later, when standard teardown paths call
mpath_put_disk():

void mpath_put_disk(struct mpath_head *mpath_head)
{
    if (!mpath_head->disk)
        return;

The check will fail to catch the error pointer, which is then passed to
put_disk(). Could this regression result in a kernel panic when dereference=
d?

[ ... ]

> +int mpath_head_init(struct mpath_head *mpath_head)
> +{
> +	memset(mpath_head, 0, sizeof(*mpath_head));
> +	mutex_init(&mpath_head->lock);
> +	refcount_set(&mpath_head->refcount, 1);
> +
> +	INIT_WORK(&mpath_head->partition_scan_work,
> +		multipath_partition_scan_work);

[Severity: High]
Are there missing work initializations in this function?

While partition_scan_work is initialized, remove_work and requeue_work
from the mpath_head structure appear to be omitted.

When mpath_add_device() is called, it executes:
cancel_delayed_work(&mpath_head->remove_work)

Passing an uninitialized, zero-filled delayed_work structure into the
workqueue APIs can violate their contracts. Could this regression trigger
debug warnings or crashes in timer management code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D2
