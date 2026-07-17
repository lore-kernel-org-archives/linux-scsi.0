Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187125776;
	Fri, 17 Jul 2026 02:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256579; cv=none; b=mtEKkZbtKN4Lb7GEv7d0e5VxFYckEpKP9z9G+ObqxEdS5NKlbUzQq/5mV0EL/OLOLrhc9NvfZvueXIHze/kUvqdHw9GkzXt+sdh0zAk4B7lD4FbSMwMxkEQ88xWDHHEr07ZkpHoE46D1PoUd01Di73OuS29j30wfMDZwwuOtEPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256579; c=relaxed/simple;
	bh=h90xHStP6/O/Hybaurze0KSJTB+RbL84lb90DGhij04=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fUx/NNPUdVoLwSjpomTMAFjadGVxOse7/zFfC67kyhS+j3k6LULHm2JRWDWIOJRco/bFhQYMSgg7tVTYTflKFCzjjFATLnsGqQciWXR+2l5/4jMk8q6idJ/vDSOOOEF4pU2HX8EKJU4o8miVEnCifNv+tdEj6vZznZ1Oo4Zwjn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYm8s+Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYm8s+Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128D91F000E9;
	Fri, 17 Jul 2026 02:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256578;
	bh=oWbLYjJYww2HelOvUQeOFQkcZmyDoeLFy31PP2eEd80=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mYm8s+WhnTD5lY/6lkSb/knqA1Qe5maMC976ra/uSWchSAOQVW4GF2c5OtmpehpNg
	 Zp7rFTWyEXT1+zPkt5sU2379/HqbepJf8nCviyrt7ffi//bZBU6TVXlNM18IQtadOV
	 VU3ACpZ2JGjYldkKvJwR4/T22PYY9q7Aw5uaodiGReGKrIKC271d0Ps/7bPfiBs4Yq
	 p7wvHg2i8LwOt+v/Qr54YiNgjYOy0fs/fdmrQqTDXH4fFmpkazN4xj1cUb5S0ahKaI
	 qRznRNzxklbP5aIjkFuMxOyfke7UXr6VHQWSaIb6rtkziCdFtLpyWBATmW6+HNw/H7
	 hpU7e2e4I5EeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 3/7] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-4-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-4-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 02:49:37 +0000
Message-Id: <20260717024938.128D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The refactored `device_shutdown` discards the parent device pointe=
r returned by `get_device(dev->parent)` and re-reads `dev->parent` inside `=
shutdown_one_device()`, creating a TOCTOU race condition that can lead to r=
eference leaks and use-after-free.
--

--- Patch [3]: [PATCH v19 3/7] driver core: separate function to shutdown o=
ne device ---
commit c3cdb15ac9b6efba6077cade25c652c124eaa9c7
Author: David Jeffery <djeffery@redhat.com>

driver core: separate function to shutdown one device

This commit refactors device_shutdown() by extracting the shutdown logic fo=
r a
single device into a new separate function, shutdown_one_device(). This cha=
nge
is intended as a preparatory step for supporting asynchronous device shutdo=
wn.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 78b90326addb6..82a7af1f3ba2e 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4898,12 +4898,48 @@ int device_change_owner(struct device *dev, kuid_=
t kuid, kgid_t kgid)
>  	return error;
>  }
> =20
> +static void shutdown_one_device(struct device *dev)
> +{
> +	struct device *parent =3D dev->parent;

[Severity: High]
Does this lockless read of dev->parent introduce a race condition?

In the old code, the parent device pointer was captured and pinned in
device_shutdown() using parent =3D get_device(dev->parent).

With this refactoring, dev->parent is re-read here. If the parent changes
concurrently (for example, via device_move()), could we end up operating on=
 a
parent device that we do not hold a reference to?

> +
> +	/* hold lock to avoid race with probe/release */
> +	if (parent)
> +		device_lock(parent);

[ ... ]

> @@ -4925,7 +4961,7 @@ void device_shutdown(void)
>  		 * prevent it from being freed because parent's
>  		 * lock is to be held
>  		 */
> -		parent =3D get_device(dev->parent);
> +		get_device(dev->parent);

[Severity: High]
Is there a reference leak here since the return value of get_device() is now
discarded?

If dev->parent changes right after this call, the original parent's referen=
ce
will be leaked. Later, shutdown_one_device() will lock and drop a reference
to the new parent instead, potentially leading to unbalanced reference coun=
ts
and use-after-free.

Should we pass the pinned parent device pointer into shutdown_one_device()
as an argument to ensure we lock and release the exact same device we took a
reference to?

>  		get_device(dev);
>  		/*
>  		 * Make sure the device is off the kset list, in the

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D3
