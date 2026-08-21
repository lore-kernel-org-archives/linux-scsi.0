Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2F2421238;
	Fri, 21 Aug 2026 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323416; cv=none; b=pfrgIdCi0CYyIg+44cXvZl3whTgrTHpTZ6NfvLKwOETy44K+fvIY3OV1Hs2/pZpYUKWVUV1okigAueOeVcdpcmDZilzEBAV7IJwPO+PFdh03Kd+AGvhWvrzAojjiFAiTJYqVIrHSNV4y2mqOyTdc2HF1y5Mb+R+7YPIveuld31I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323416; c=relaxed/simple;
	bh=c4oHNF7z5bJGgAuGIwyFwuN0KhSF0wqTt9ckM8xl9Wc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qxIL51MS4def9Bp/Rs00MLM7CYWwXhH9fpISgYZnTYcOEWf3W55iR6TE5VfvmZ43LcMSx4RHSXwi6sufwU1TZvjPrTGBDaosQWEFl+CobX+PfFTHwyZNjQrM8ldTvc+0wA0pd4JZag50cKCrfwsdVJU7gZAot1mCZIlArZwJ3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKUlJ5FQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKUlJ5FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE1F1F000E9;
	Fri, 21 Aug 2026 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787323415;
	bh=kl+rulfmOjMb427yFUDHKO/SQjIADnoXMoWRrF9n+uQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GKUlJ5FQwX1S8yBDtC2Y4Q5zMY00N11KFVf8ysRw2pZAGKCegRoBirRcUEDJIljWb
	 0hTgY1ggKS5AsrBOw77w3Ef/QORzjQ9r1oMSJ9qeuZY4T5+VEbZpMniACMwryT0EIh
	 2FxPvRlBLBCDtgMXfiH6CyJ8X0YPS1kx7Orhp4NEiq/aFYgEYdnYZL5A5wI9PdivPL
	 5ZUjRgYBuzoO1YxMM2Jj7JzQJj+z5Wl4kr0KkSYowC0MVycforKVjJAJdgqtGQs/sI
	 WtHO9zBHsZ9fFcUWMTydxuzQQj6ZOEuoXhjSQMIH/5+tYFTVaJUCqFYJ49fTpppapP
	 L87xBDkvF36BA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] driver core: prevent device_add() during system
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260821142414.150892-3-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-3-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:43:34 +0000
Message-Id: <20260821144335.1BE1F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Race condition in device_add() abort path during system shutdown l=
eading to Use-After-Free.
--

--- Patch [2]: [PATCH 2/9] driver core: prevent device_add() during system =
shutdown ---
commit 17748fb46ccfdb0adadd634adbfe70a9fd601b9a
Author: Tarun Sahu <tarunsahu@google.com>

driver core: prevent device_add() during system shutdown

This commit adds system state checks to device_add() to prevent new
devices from being added while the system is halting, powering off, or
restarting. It re-checks the state under devices_kset->list_lock to
avoid a TOCTOU race window with device_shutdown().

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
[ ... ]
> @@ -3699,6 +3720,18 @@ int device_add(struct device *dev)
>  		goto Error;
>  	}
> =20
> +	/*
> +	 * Check system_state again under list_lock to prevent a TOCTOU race
> +	 * where device_shutdown() runs concurrently and misses this device.
> +	 */
> +	spin_lock(&devices_kset->list_lock);
> +	if (unlikely(system_is_shutting_down())) {
> +		spin_unlock(&devices_kset->list_lock);
> +		error =3D -ESHUTDOWN;
> +		goto ShutdownError;

[Severity: High]
Does this error path introduce a use-after-free race with device_shutdown()?

If device_add() successfully links the device to devices_kset->list via
kobject_add(), device_shutdown() could concurrently run and pull the
newly added device from the list:

device_shutdown() {
    ...
    spin_lock(&devices_kset->list_lock);
    ...
    dev =3D list_entry(devices_kset->list.prev, struct device, kobj.entry);
    ...
    list_del_init(&dev->kobj.entry);
    spin_unlock(&devices_kset->list_lock);
    ...
}

If device_add() then resumes, acquires the list lock, and sees
system_is_shutting_down(), it will jump to ShutdownError and return
-ESHUTDOWN.

The caller of device_add() will typically treat this as a failure and
free the device and its associated private data. Meanwhile,
device_shutdown() is already outside the lock and actively executing the
shutdown callbacks on that exact same device:

device_shutdown() {
    ...
    if (dev->bus && dev->bus->shutdown) {
        ...
        dev->bus->shutdown(dev);
    }
    ...
}

Can this lead to device_shutdown() accessing freed device memory?

> +	}
> +	spin_unlock(&devices_kset->list_lock);
> +
>  	/* notify platform of device entry */
>  	device_platform_notify(dev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D2
