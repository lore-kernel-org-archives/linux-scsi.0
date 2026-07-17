Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55085B21A;
	Fri, 17 Jul 2026 02:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784257155; cv=none; b=XAZ+AHBsACJLnodpb2E31d8cpLhwWdfeyD4wX72e2YAxmkhe+VIVGao3T9ukrWgaQivDjB01V+N7M080webr93Ij+3jZaz6YShfnXw2uTqBETCyClb/32NRrZ304RKbz9+nMSMdzmMhyAfzBiCk1579CZGKOY5aGXbg21Y58B5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784257155; c=relaxed/simple;
	bh=4QFFlfToTTIc6tbG+tGOgf3kxFm6YBAvQqfgyWOl7Rc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qSSjM6awEjFV77PHCNejNzpt0Now7Y5VoYN18MDUdp1iD1DrS0dnwYWJbtCYwvf3/liyVVcBkgcoYzBiSeW7X+C+t1F3ziHoU046Jw70lZ4ikvJjtbILDbvSTfHhFPVwrMxc5zUAETB2qp6xpL/OvDfoDON0x8sMVLk2frjKk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0BxUIeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0BxUIeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067B41F000E9;
	Fri, 17 Jul 2026 02:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784257154;
	bh=f8rbkNTaw6kXqncCnpst/S3iLnGcwBl8ezEciA1EKps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U0BxUIeBpEO2w3m2SdycaAjGPxWLLgKiv2eHnFk9yxO8sOqvD/FpcMrBc9ZnLr6A2
	 Qlwpz98txwD+kCPIR41qcMmCuDQKiIaWXocs3iDBab527WM8gJb9yNSARygpOSxyoc
	 zFIJYsc3qmc1zR8soynwhDtnnnod6jPJOnnlxLgtLQfrad37jQ1XkCbPKhSsRITVLG
	 aHhg7w7XjDnHSkwudFbCIesTUX0MvRy5Fw53J1V4PrunxkGUrDIEVPLyTi4EsSAL87
	 N/evP+qb+quLpivE6EqvK3JPIY1QEtzkHUxO9g4aUW63o+EqQpIqR/9eTocIjI19DF
	 eWRMdBN6Yh8sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 4/7] driver core: do not always lock parent in
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-5-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-5-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 02:59:12 +0000
Message-Id: <20260717025913.067B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unprotected read of dev->parent introduces a Use-After-Free race w=
ith device_move() during reference acquisition.

Pre-existing issues:
- [High] Dropping and re-acquiring device_lock(dev) allows dev->parent to c=
hange, resulting in locking an obsolete parent.
--

--- Patch [4]: [PATCH v19 4/7] driver core: do not always lock parent in sh=
utdown ---
commit 6be56e5bea0fe214a5199c9f806c49e62e60127f
Author: David Jeffery <djeffery@redhat.com>

driver core: do not always lock parent in shutdown

This patch modifies the device shutdown process to only lock a parent device
if it is strictly needed, rather than unconditionally. It also defers
acquiring a reference to the parent device until the point where the parent
needs to be locked.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 82a7af1f3ba2e..31f95e86856e0 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c

[ ... ]

> @@ -4925,12 +4921,32 @@ static void shutdown_one_device(struct device *de=
v)
>  static void shutdown_one_device(struct device *dev)
>  {
> +	struct device *parent;
> +
> +	device_lock(dev);
> +
> +	/* use parent lock if needed to avoid race with probe/release */
> +	if (dev->bus && dev->bus->need_parent_lock && dev->p && !dev->p->dead &&
> +	    (parent =3D get_device(dev->parent))) {

[Severity: High]
Does moving the parent reference acquisition out of the list_lock critical
section introduce a race condition where the parent could be freed?

In device_shutdown(), get_device(dev->parent) was previously called while
holding devices_kset->list_lock. Now that it is evaluated locklessly in
shutdown_one_device():

CPU1
shutdown_one_device()
    evaluates dev->parent, but is preempted before get_device() is called

CPU2
device_move()
    changes dev->parent and calls put_device(old_parent)
    dropping the last reference and freeing the memory

When CPU1 resumes, could it pass the freed pointer into get_device() and
dereference it?

> +		/* the parent lock needs to be acquired first, so re-lock */
> +		device_unlock(dev);
> +
> +		device_lock(parent);
> +		device_lock(dev);
> +
> +		__shutdown_one_device(dev);

[Severity: High]
This is a pre-existing issue, but does dropping and re-acquiring the device
lock here allow the topology to change?

If a concurrent device_move() reparents the device while device_lock(dev)
is dropped, it appears we might lock the obsolete parent. When we re-lock
dev and call __shutdown_one_device(), we haven't verified that dev->parent
still matches the locked parent.

Could this defeat the need_parent_lock synchronization and allow a
concurrent probe or release on the new parent to race with the shutdown?

> +		device_unlock(dev);
>  		device_unlock(parent);
> +		put_device(parent);
> +	} else {
> +		__shutdown_one_device(dev);
> +		device_unlock(dev);
> +	}
> =20
>  	put_device(dev);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D4
