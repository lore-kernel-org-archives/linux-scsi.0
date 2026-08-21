Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB85499F26;
	Fri, 21 Aug 2026 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323169; cv=none; b=Un3yvixuKasjFWw3aRPNb3e4OwdyD1KRoI1spcDSSOxibp3J61q9+2rUrOIlN5QAK5hmxFuezdRZGAoZkXEEAV38X0H54IPRt36uPqvvvjyQNHf7X1c/1mBNJjdwnKBQgTkmMmtea1ek90Mz3vMGToVzmKdCWSIzA0YqSFqAcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323169; c=relaxed/simple;
	bh=rgy0APk7BgIlcJNWRWQdrn6OmIdF7mErwVVj7dI8YpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hjh8ALl/+ksopxt69HjRwSTTh3Vmw8DeI4xhlj7zyIpzk4pCNZsB4bj/fHq6SlqYpRABIPb3fKjLU6UgZ6ZdobhkPUzHXmAGqezKS8xoVc878DPF0H2CowoauU68TOPrhl5m5DCsTY/0Pk5dQykoM4uHzJB1skmwD6oVeCPLgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nw2jmTCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nw2jmTCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69441F00ACF;
	Fri, 21 Aug 2026 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787323167;
	bh=zgzUoieUcClgeUqGY7Sf1EaPji1ajkgDY/1ls28KB8k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nw2jmTCAjANkdrx28BntNJ5dfw6JBkcf91/YMIP9ygMoLHJF1k8nmvwbGYMVmB+4w
	 8W0z+9uEBni2QqQd3k02y3Hchwhh9B08Ha/WKtqHpX28JKqSa3eSwq2A6Z5TtChs43
	 SjO/1hmY/31wv3UIKPfzLPCDT+NVUwPACnLBNGQrbBvT94jZckvvc1TTkxXYyC8WkA
	 ++CIi9a9Fwaj1Cey/ge0meRcaiQavpyeLodqGsK+dJN3606js0lwTt0l25hWfkKS9i
	 aM8dsdsK7FcOuaMof0HIkMeJZM5flMzGW01u6YiZZpGKTS3ArzyZVMNElaQfiACD0h
	 Q2LLX9/8fe+Ag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] PCI: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260821142414.150892-9-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-9-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:39:27 +0000
Message-Id: <20260821143927.A69441F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Medium] Setting the device async shutdown flag after exposing the device=
 via device_add() creates a race condition.

Pre-existing issues:
- [High] Double put_device() on error path leads to premature freeing and s=
ubsequent use-after-free of the host bridge device.
- [High] Unhandled device_add() failure leaves PCI device in an indetermina=
te state and globally visible in the bus list.
- [High] Modifying PM bitfields without locking after a device is exposed c=
auses data corruption if the PM core is active.
--

--- Patch [8]: [PATCH 8/9] PCI: Enable async shutdown support ---
commit f9f4c656f43f8b78ec5f8dac98964decb5920b89
Author: David Jeffery <djeffery@redhat.com>
Subject: PCI: Enable async shutdown support

Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index dd0abbc63e18d..af23814464060 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1046,6 +1046,7 @@ static int pci_register_host_bridge(struct pci_host=
_bridge *bridge)
> =20
>  	bus->bridge =3D get_device(&bridge->dev);
>  	device_enable_async_suspend(bus->bridge);

[Severity: High]
This is a pre-existing issue, but does calling device_enable_async_suspend()
here after the device is exposed to the PM core cause a data corruption rac=
e?

Since this performs an unlocked read-modify-write on the PM bitfields,
concurrent PM operations like dpm_prepare() could clobber these flags.

> +	dev_set_async_shutdown(bus->bridge);

[Severity: Medium]
Since this is called right after device_add() exposed the bridge device, co=
uld
this create a race condition where a concurrent system shutdown observes the
device before the async_shutdown flag is set?

>  	pci_set_bus_of_node(bus);
>  	pci_set_bus_msi_domain(bus);
>  	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&

[Severity: High]
This isn't a bug introduced by this patch, but looking further down in the
error path of pci_register_host_bridge(), does the code introduce a
use-after-free?

If device_register() fails, the unregister path calls
put_device(&bridge->dev) and then falls through to the free path which
calls put_device(&bus->dev).

Since release_pcibus_dev() internally drops a reference to
pci_bus->bridge, this would drop a second reference to bridge->dev,
improperly consuming the caller's initial reference.

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
This isn't a bug introduced by this patch, but looking further down in
pci_device_add(), does ignoring a failure from device_add() leave the PCI
device in an indeterminate state?

If device_add() fails, it only logs a WARN_ON and returns without cleaning
up the device from bus->devices, which could crash subsystems iterating over
the global bus list.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D8
