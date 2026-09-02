Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D214AC14F;
	Wed,  2 Sep 2026 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369925; cv=none; b=pqwSbpUyOuDedw9QMKGuQwtJRvUr7Eni/Lky8ExLJe4Dh82kUN4jPO+Bre+iVbFm4lGANiG/gUYLbJX34ufTmXxibYHa89rKgYSoJg+Ag8Embv5iWrWv+hrt40TBmJUOHpHmz9ddP7YjoTugqPFISGfaINjDPGsS/HleYenhb5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369925; c=relaxed/simple;
	bh=yYDQFxfQU1H7CFKqQI64S+eVxBQIPhTJ9tHFeQ9EG/I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ratTRDoBbrKdXWFg9H0HvoNm65ypWSO2xIrX1I9CQIvYrcvf/8jiC4B9zvioml7caj8lZva9okDGl8nciRVPnM95Z9fw0vvuhqKdIT9lFighyMi68j8HMbwJy/uOzYgSx+zyf7yqvXVKxqUnh2eDlgVpqVbtyqzqUX3tfLijHfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jV/mnstK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jV/mnstK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99101F000E9;
	Wed,  2 Sep 2026 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369924;
	bh=PtgQHWkTF3ZHcJbNave0cwUqfuQ91iZ38NCtFsNv9yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jV/mnstKv78tjJJZmjs4M591nlVhOzrma0RedVofgdBcGvFrFurrOP6CvfiM+ocPD
	 jMmdasPrC5vGO/QudC5SR6Awy4dbmPVdui9IZ2hyWJpk4oBBBopYj6no4Mc1m+dTuZ
	 c34z77xId+iwLW9HReuLQm4hxhpfrLSEfErczXYBhbmz8gwIlmK0bv+d8kpYgDXYJq
	 KpUCUB/SVRL59vefLhE4Xq2cSiEhNwJMx5mHG5ZkHnIR5H6G82Haf22XzJuk46Iw8o
	 /zMQObLW85KWeW9SO3rG+8DMNk+zm6kKyja+rCUVq59932SoCsrbLygMVHUzpKWO2Z
	 U9nQLjX5KTEDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] driver core: do not always lock parent in shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-6-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-6-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:25:23 +0000
Message-Id: <20260902172523.C99101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incorrect condition ordering leads to a potential Use-After-Free o=
f `dev->bus` during device shutdown.
--

commit b894dd7ffd5113988601f8e495c49a29524ecb74
Author: David Jeffery <djeffery@redhat.com>

driver core: do not always lock parent in shutdown

This commit avoids unconditionally locking a parent device during device
shutdown. It introduces __shutdown_one_device and updates
shutdown_one_device to only acquire the parent lock when needed to prevent
races with probe or release operations.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 7fe3fa6870a72..05285fae143d3 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
[ ... ]
> @@ -4928,13 +4926,33 @@ static void shutdown_one_device(struct device *de=
v, struct device *parent)
>  			dev_info(dev, "shutdown\n");
>  		dev->driver->shutdown(dev);
>  	}
> +}
> =20
> -	device_unlock(dev);
> -	if (parent)
> +static void shutdown_one_device(struct device *dev)
> +{
> +	struct device *parent;
> +
> +	device_lock(dev);
> +
> +	/* use parent lock if needed to avoid race with probe/release */
> +	if (dev->bus && dev->bus->need_parent_lock && dev->p && !dev->p->dead &&
[Severity: High]
Could this condition ordering lead to a use-after-free during device shutdo=
wn?

If a module is unloaded concurrently with system shutdown, device_del() sets
dev->p->dead to true and removes the device from the bus.

Since device_shutdown() already incremented the device's refcount, the
device structure is preserved. However, when the module finishes unloading,=
 it
unregisters the bus and frees the bus_type structure.

Because of left-to-right evaluation in this if statement,
dev->bus->need_parent_lock is accessed before checking !dev->p->dead.

Would checking dev->p && !dev->p->dead before accessing bus properties
prevent reading from the potentially unmapped bus structure?

> +	    (parent =3D get_device(dev->parent))) {
> +		/* the parent lock needs to be acquired first, so re-lock */
> +		device_unlock(dev);
> +
> +		device_lock(parent);
> +		device_lock(dev);
> +
> +		__shutdown_one_device(dev);
> +		device_unlock(dev);
>  		device_unlock(parent);
> +		put_device(parent);
> +	} else {
> +		__shutdown_one_device(dev);
> +		device_unlock(dev);
> +	}
> =20
>  	put_device(dev);
> -	put_device(parent);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D5
