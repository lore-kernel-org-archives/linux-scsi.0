Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D4495052;
	Fri, 21 Aug 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322855; cv=none; b=k1OSwD9M209BXtgZMvDPOKQiCcxrZXTcC26XRg0O/4MkVdaTp8PY/44sHss7WjSLtFbs95QStcQV8+++kZfIxwavYgpm/F2bAQAWxDQC6qOxXGc0UgaGwJgfpoSlNFtA60RnDhpRtuBDp5CeNm/3x4XmJ+VmbI14qkIALvpbpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322855; c=relaxed/simple;
	bh=UwwRTVkxUIMODKXM4UDVw0sJVgwZ8b0X5rCpEIPbt6s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iPRU6Fgvr/616747dloyXnDViYJTqRnPsmpF6hmaoEwnwl8D2tUf0tVKhdv2fMUKTW3E6NKb2XfoYYbIm/dvzFZrqBqMd2M+flnAXXcVZg4fQi3tbS8eVPgMXvyzSbLLe0BSyXr0EgrIppIPB4xtISpjXzkBL4+v/xUE19Ti2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYJppTYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYJppTYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5AF1F000E9;
	Fri, 21 Aug 2026 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322853;
	bh=b+m20f91dQsyrhJg6EKKUIU9aKaknQ+Qu1431+vSYjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PYJppTYOvnmLKQAPQ61C3EglzMxuCDh+x0oXpT6kXW7oM/kViw4D6eS+AEm3HUaKH
	 j4svn6tdAWhS9KAS2o2nSigu4iL6LGEgBgJcU6ykTR+DHt66ItpAkm63p4q6Qijn/3
	 GsTTyVCk0pRtNEF5MlbuD1q0ta2ZHZpx+1F5aAXOwvS0Tz8x1p4ATwrjQAeX6bv2ug
	 zk9me2Hg0TpLuTIc19tIHaiCCEiEQJszferXpe5qs5aeuvlqqZ4zvUlFtLg8iVbCkt
	 Y7x07b7OMu5oRg41/Hr82VzEWlJprPSGTMHAmRMx96L/tH3zDaiJjmePDQqXzbqBCL
	 YSGQxvDXDH47Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] driver core: warn should device_move try to move a
 need_parent_lock device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260821142414.150892-4-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-4-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:34:13 +0000
Message-Id: <20260821143413.AB5AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent execution of device_move() and PM runtime operation=
s causes a Use-After-Free on the parent device pointer.
- [High] device_move() corrupts PM runtime child_count accounting, potentia=
lly causing active devices to panic when their parent is prematurely suspen=
ded.
--

--- Patch [3]: [PATCH 3/9] driver core: warn should device_move try to move=
 a need_parent_lock device ---
commit da39f0a4e63233986f7aa69f70fc28bb25510d0a
Author: David Jeffery <djeffery@redhat.com>

driver core: warn should device_move try to move a need_parent_lock device

Currently, no device has need_parent_lock set and is moved by
device_move. need_parent_lock is only set by the usb bus and very
few device types ever use device_move.

Adds a warning to device_move to catch should it ever be used on a
device with need_parent_lock set.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 78b90326addb6..20b37ee07b5ac 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4708,6 +4708,14 @@ int device_move(struct device *dev, struct device =
*new_parent,
>  	if (!dev)
>  		return -EINVAL;
> =20
> +	/*
> +	 * device_move() should not be used on devices with need_parent_lock
> +	 * set. Concurrent reparenting will violate the immutable
> +	 * relationship needed while locking and unlocking both parent and
> +	 * child.
> +	 */
> +	WARN_ON(dev->bus && dev->bus->need_parent_lock);
> +
>  	device_pm_lock();
>  	new_parent =3D get_device(new_parent);
>  	new_parent_kobj =3D get_device_parent(dev, new_parent);

[Severity: Critical]
This is a pre-existing issue, but does this code allow a use-after-free of
the parent pointer if rpm_resume() runs concurrently with device_move()?

In drivers/base/power/runtime.c:rpm_resume(), dev->parent is read into a
local variable while holding dev->power.lock, but the lock is released
before pm_runtime_get_noresume() takes a reference to it:

drivers/base/power/runtime.c:rpm_resume() {
    ...
	parent =3D dev->parent;
	if (dev->power.irq_safe)
		goto skip_parent;

	spin_unlock(&dev->power.lock);

	pm_runtime_get_noresume(parent);
    ...
}

Meanwhile, device_move() modifies dev->parent and drops the reference to
old_parent without holding dev->power.lock:

drivers/base/core.c:device_move() {
    ...
	old_parent =3D dev->parent;
	dev->parent =3D new_parent;
    ...
	put_device(old_parent);
    ...
}

If device_move() frees old_parent during the lockless window in rpm_resume(=
),
this could cause a use-after-free memory corruption.

[Severity: High]
This isn't a bug introduced by this patch, but when device_move() reparents
an active device, could it corrupt the PM runtime child_count accounting?

When reparenting an active device, device_move() does not transfer the PM
runtime child_count from the old parent to the new parent:

drivers/base/core.c:device_move() {
    ...
	old_parent =3D dev->parent;
	dev->parent =3D new_parent;
    ...
}

When the moved device later suspends, rpm_suspend() decrements the child_co=
unt
of the new parent:

drivers/base/power/runtime.c:rpm_suspend() {
    ...
	if (dev->parent) {
		parent =3D dev->parent;
		atomic_add_unless(&parent->power.child_count, -1, 0);
	}
    ...
}

If the new parent has other active children, its child_count will premature=
ly
reach zero. This could cause the PM core to suspend the parent while its
other children are still actively performing I/O, potentially resulting in a
kernel panic or hardware lockup.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D3
