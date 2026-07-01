Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9C2ED15F;
	Wed,  1 Jul 2026 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915107; cv=none; b=s3vQgFFKkY3T83MvacX6Dn19LNeo5X4m/bXfzkXjjCGsA3otcvaRk+DVIq1EYRG/VNnwY0iOiSMcmB5PqZr7vAEf51bgtktQYy+40ytU9XJkgRuqNZf4ESUv6i885P5pFF7Sfs5X8Kw8FphUpkTvjd6ymTPDBwKR4xidjgMtG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915107; c=relaxed/simple;
	bh=BD+0CGd+YAB2RovEcWoIZE9+hYynbslbP3zfG3AVNj4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P0HdOYGBzJ7HHXd5SUrojiWGoQHYM3EntoUb8hi5c982bQah1Qwu6uoZi2TciVdKwLmCFR6kCyyLn8NuVCTEXlp2oWdIDvbrUzQ1tgnggBv7mH3yAK1VxXlcZwmJqHXKUvmxfpOkg35gBFfMAMbttChXRlRbxBFvupEeAlPNNOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XlUx3vr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XlUx3vr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A611F000E9;
	Wed,  1 Jul 2026 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782915105;
	bh=036rLB9uZP4OtkAvySFQ5HS6TijA5qg9heuUiXFI0yY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XlUx3vr+oB/HcNz5Ls/gNSTUH2yML5JIuNkp5E0a4q+JZE1RxphGGWP9Sve0zC9U0
	 F16GivWXA0m+n05yzHPuO9uaWBJ5lIGalcYYtiUNKBr5o/b83OxsoYm5263cyfTAB+
	 vuT+MYIhr9bk2Eaa8PZEYIGGw0xPrV/nLSgpiX9UkuIeyNK2orHTUiP6m0ZT7Ini+p
	 ZyEfnWE47OBH3lOrx9i8nVT+V5Ck6ToaRn4xaEKg8wN8m2ioQZ393VI+KGdbgTy9t9
	 Xo/WZ3b6/PRCgyQco5bftYB8dVnc7lNS14wUOxO5uiRllitSjv3AGwdBOZAtJ9oOb3
	 Ev5iiSy8QU+BQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260701135015.81937-4-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
 <20260701135015.81937-4-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 14:11:44 +0000
Message-Id: <20260701141145.52A611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Modifying the core.async_shutdown module parameter during shutdown=
 causes synchronous suppliers to skip waiting for asynchronous consumers.
- [High] Unregistered consumer devices will cause a NULL pointer dereferenc=
e during async shutdown dependency waiting.
- [High] Adding a new device with async shutdown enabled while its synchron=
ous supplier is being processed leads to an unresolvable deadlock.
- [High] Dereferencing `dev->p->dead` without NULL checks causes a crash if=
 a concurrent `device_add()` fails.
--

commit cf98cdf76df805443cc885868cb3d9e13da5501c
Author: David Jeffery <djeffery@redhat.com>

driver core: async device shutdown infrastructure

This commit allows devices to opt into asynchronous shutdown, executing in
parallel with unrelated devices after their dependencies shut down. Synchro=
nous
shutdown devices will wait for their asynchronous dependencies. The feature=
 is
enabled by default and can be toggled via the core.async_shutdown parameter.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
[ ... ]
> +static bool wants_async_shutdown(struct device *dev)
> +{
> +	return async_shutdown && dev_async_shutdown(dev);
> +}
> +
> +static int wait_for_device_shutdown(struct device *dev, void *data)
> +{
> +	bool async =3D *(bool *)data;
> +
> +	if (async || wants_async_shutdown(dev))
> +		wait_for_completion(&dev->p->complete);
> +
> +	return 0;
> +}

[Severity: High]
If a user-space process toggles the 0644 core.async_shutdown sysfs parameter
from 1 to 0 during shutdown, could this cause synchronous suppliers to skip
waiting for their asynchronous consumers?

If start_async_shutdown_devices() schedules an async consumer, and then the
parameter is toggled before the sync loop processes its supplier, the call =
to
wants_async_shutdown(dev) here would evaluate to false.=20

This would skip the wait_for_completion(), potentially causing the supplier
(e.g., a PCI bus) to shut down while its consumer is still active.

[Severity: High]
Could this result in a NULL pointer dereference if the consumer is not yet
registered?

The device_link_add() function allows creating links to consumer devices th=
at
haven't been registered yet, meaning their dev->p is NULL because
device_private_init() hasn't run.

If wait_for_shutdown_dependencies() is called from the async pool, where the
async argument is forced to true, the wait_for_completion() will
unconditionally evaluate &dev->p->complete, crashing on the NULL pointer.

[ ... ]
> +static void __shutdown_one_device(struct device *dev)
>  {
>  	if (dev->p->dead)
>  		return;

[Severity: High]
Could this cause a NULL pointer dereference if a concurrent device_add() fa=
ils?

If a concurrent device_add() fails after calling kobject_add(), its error p=
ath
calls kobject_del() and then frees and nullifies dev->p. Evaluating
dev->p->dead without checking if dev->p is valid could crash here.

[ ... ]
> +static void start_async_shutdown_devices(void)
> +{
> +	struct device *dev, *next, *ndev, *needs_put =3D NULL;
[ ... ]
> +			needs_put =3D ndev;
> +			spin_lock(&devices_kset->list_lock);
> +			/*
> +			 * If the next device has been marked dead while the
> +			 * spinlock was released, it may no longer be on the
> +			 * devices_kset list. Restart the list walk to be safe
> +			 */
> +			if (ndev && ndev->p->dead)
> +				goto restart;

[Severity: High]
Could ndev->p be NULL if a concurrent device_add() fails?

If start_async_shutdown_devices() obtains a reference to next via
get_device(), and concurrently device_add() fails and clears dev->p,
reacquiring the lock and evaluating ndev->p->dead here could result in a NU=
LL
pointer dereference.

[ ... ]
>  void device_shutdown(void)
>  {
[ ... ]
> -		shutdown_one_device(dev);
> +		if (!wants_async_shutdown(dev) || !shutdown_device_async(dev)) {
> +			wait_for_shutdown_dependencies(dev, false);
> +			shutdown_one_device(dev);
> +		}
> =20
>  		spin_lock(&devices_kset->list_lock);
>  	}
>  	spin_unlock(&devices_kset->list_lock);

[Severity: High]
Can this sequence lead to an unresolvable deadlock if a new device is added
concurrently?

If a new device 'C' with DEV_FLAG_ASYNC_SHUTDOWN is added via hotplug
after its synchronous supplier 'S' has already been popped from
devices_kset by this loop, 'C' is appended to devices_kset.

'S' will call wait_for_shutdown_dependencies() and find 'C', blocking on
wait_for_completion(&C->p->complete) because wants_async_shutdown(C) is tru=
e.

Since 'C' was added after start_async_shutdown_devices() ran, it is not
running in the async pool. Because the sync loop is blocked on 'S', it will
never reach 'C' to start it, deadlocking the shutdown process permanently.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.8193=
7-1-djeffery@redhat.com?part=3D3
