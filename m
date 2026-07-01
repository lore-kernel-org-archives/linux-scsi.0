Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB622D3750;
	Wed,  1 Jul 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914870; cv=none; b=FA3F5TX4Pb1pnCINyxQ/PKGNiHr/gQ4c+q6f0UDGz+8WXTuuTleKG4JDgo5OMl1gwlD9kgmcIkEFNk3G02XP4eOiq4aFpPn5gKExoo2Nzrf+jAipgtljMifrTUKXLcyPs67B3naikRL5ceQUxGyGDDSzT3vevY6rIGvXbP0HQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914870; c=relaxed/simple;
	bh=AyFzl1e02VhOmchQfYPrTlUQeugir/vOEv1kuiOUcYY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qHgKrbTumdISW48YYniiiQ41MN5ETSx0azhjfIJrG4je8UKP1FxVRHNRHjd+OaQKFuFIxuXMrLraolgyFc/0PIhX88RMU3SNUtZ7ddFh+ki/TAsFh312yRFu7koZSx4iPnikUuz4VUvgwIhzhXLRU4qhq8OASyB18l1CyKRNL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKVnCxFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKVnCxFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A18F1F000E9;
	Wed,  1 Jul 2026 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914868;
	bh=Kaia6u/iS0bxsMmPGoB4y1H8kEBBg4hcJBE4mmBoZ1Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PKVnCxFgB/Anc3Jw/2XK79nooEfbIUxZtadSHs96Hdb+yxDo0owYJ9nYiR3WC7bR2
	 VcFZDP0aUM2CLDXPqckwPI+vMuKdD4693CnNLscHtdYOGDvpABATrGeJxleRsoMLty
	 67inkIpgDPphTtEKzLRW0ZxyHnWYQBaDwhIzsm+73cyhUlGWk9LKCHv7sacQc7Pz/8
	 0pxxe377uItEe0mcmG7n4Hj23pkHxEAPNWdWte++MaffTh4rSiOQUjb5ALR59L3qoj
	 Myw2NswzkYAqX9e2qggNpfm8yV2pdajt4iCQ6lZrBdp0jgQPyjkBaZfWjVWlOunw8H
	 edYOObVX361AQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] PCI: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260701135015.81937-5-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
 <20260701135015.81937-5-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 14:07:47 +0000
Message-Id: <20260701140748.5A18F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] In `pci_register_host_bridge()`, a failure in `device_register=
(&bus->dev)` leads to a double-free of the `bridge->dev` object.
- [High] In `pci_device_add()`, failure of `device_add()` is ignored, leavi=
ng a partially-initialized device in the subsystem lists.
--

commit 32aeb814f8bbaee48b0baf0572f23452cd1e50da
Author: David Jeffery <djeffery@redhat.com>

PCI: Enable async shutdown support

This commit adds asynchronous shutdown support for PCI devices. It aims to
reduce overall shutdown time in the same way async suspend does.

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index dd0abbc63e18d..af23814464060 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1046,6 +1046,7 @@ static int pci_register_host_bridge(struct pci_host=
_bridge *bridge)
> =20
>  	bus->bridge =3D get_device(&bridge->dev);
>  	device_enable_async_suspend(bus->bridge);
> +	dev_set_async_shutdown(bus->bridge);

[Severity: Critical]
This is a pre-existing issue, and was not introduced by the patch under
review, but does the error handling in pci_register_host_bridge() lead to
a double-free of the bridge->dev object?

If device_register(&bus->dev) fails, the code jumps to the unregister label:

unregister:
	put_device(&bridge->dev);
	device_del(&bridge->dev);
free:
	...
	if (bus_registered)
		put_device(&bus->dev);

Because bus_registered is set to true right before checking the error from
device_register(), the free path calls put_device(&bus->dev).

Releasing the bus triggers release_pcibus_dev(), which implicitly drops the
pci_bus->bridge reference via put_device(pci_bus->bridge). Since the code
explicitly drops the reference at the unregister label as well, does this
drop the object's refcount to 0 prematurely?

[ ... ]

> @@ -2748,6 +2749,7 @@ void pci_device_add(struct pci_dev *dev, struct pci=
_bus *bus)
>  	pci_reassigndev_resource_alignment(dev);
> =20
>  	pci_init_capabilities(dev);
> +	dev_set_async_shutdown(&dev->dev);
> =20
>  	/*
>  	 * Add the device to our list of discovered devices

[Severity: High]
This isn't a bug introduced by this patch, but I noticed the failure of
device_add() is ignored later in pci_device_add():

	ret =3D device_add(&dev->dev);
	WARN_ON(ret < 0);

If device_add() fails, the device remains in the bus->devices list but is
not tracked by the driver core.

When the PCI device or bus is later removed, pci_destroy_dev() unconditiona=
lly
calls device_del(&dev->dev). Calling device_del() on a device that was never
successfully added via device_add() violates the driver core API.

Could this lead to a kernel crash or NULL pointer dereference when a PCI
device is enumerated under memory pressure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.8193=
7-1-djeffery@redhat.com?part=3D4
