Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA43324A07C;
	Fri, 17 Jul 2026 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256995; cv=none; b=PzRF6+IWiN3XmkhHT/1hzShQkKfZXmWfZVQUTrFEOLweayx0VAoZQ6oFyI/eI/DMzHQP+a70sudMPsmg2u52r0SrFXwKVcWkvb6VWEcrN765YB7LhutRACZ34oB2lXUdvFqtVRazCl3vkkiITdbRu/fiGXgnulj3GDjgOrZwx3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256995; c=relaxed/simple;
	bh=1YCLJyZWQZUHcVv4R9k+EpfA3D+1Ojod0229yeLsyC0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tbxc6KPi31R9OMRePAUrICDOB4DlcNB+6tuJnroNvxIamDaaZ1kir8V/xexixdP6MhWAsGCSNV0DOeGf/4KgjNvtLUhzjo5G/Vfacf1s19nNvXjT1cGGi7eYmj/7N0tyWzvR53mverOqZPBV438RdMdGDYkr3B0Hzgq8zOo8uTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6URR/1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6URR/1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBCA1F000E9;
	Fri, 17 Jul 2026 02:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256994;
	bh=ARD4l/0GTJIZjEbTrQBfBglePDHouDGBRWKMwL6fwXQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k6URR/1VP3KO61TWhNLFuwBMEzSUryDvSXgCFlLisRIaIoRjF3AavZg7xc5jmi8gK
	 fL7r4mhBQnBH6YKLc4MnIrskA1II7byT0ZXWsr3+hk39VZpQrwxg1HNGIZNqa0Os+O
	 6aHOk2kvtBn5duEW3nkRHoOLGdH7jL04mWZRfB/PS5MGSRM2w2xVhwWj2qYY8R575I
	 XL9RBAh7euMNiQ2yb7ijcExcuExN5CJuBdk2tNlrpJxm8uRzcJ/4HyEXSQ6olZMTHQ
	 ndfJrziFDJh+2jqt7QIhlWMs5h7ElShE7Er4LQdX/39K/nj2lbKAb3H0Vkv1dibF1L
	 ejXQtC7tryFfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 6/7] PCI: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-7-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-7-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 02:56:33 +0000
Message-Id: <20260717025634.0DBCA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but there is a doubl=
e-put bug in `pci_register_host_bridge()`'s error handling path when `devic=
e_register(&bus->dev)` fails, leading to a Use-After-Free and Double Free o=
n the host bridge device.
--

--- Patch [6]: [PATCH v19 6/7] PCI: Enable async shutdown support ---
commit bf029d21ad5b4df727aa0c1ae7b24c789b0e433a
Author: David Jeffery <djeffery@redhat.com>

PCI: Enable async shutdown support

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
> +	dev_set_async_shutdown(bus->bridge);
>  	pci_set_bus_of_node(bus);
>  	pci_set_bus_msi_domain(bus);

[Severity: High]
This problem wasn't introduced by this patch, but there appears to be a
pre-existing double-put bug in pci_register_host_bridge() when handling
registration failures.

Further down in pci_register_host_bridge(), if device_register(&bus->dev)
fails, the code jumps to the unregister label:

unregister:
        put_device(&bridge->dev);
        device_del(&bridge->dev);
free:

Does this path drop the caller's initial reference prematurely?

In the free block, because bus_registered is true, it calls
put_device(&bus->dev). The device's release function (release_pcibus_dev)
explicitly calls put_device(pci_bus->bridge), dropping the reference
correctly taken by bus->bridge =3D get_device(&bridge->dev).

Because the unregister block explicitly drops the caller's initial reference
early, the bridge is freed. The function then returns an error to the calle=
r,
which will likely call put_device(&bridge->dev) to clean up its initial
reference.

Can this sequence cause a double-free and use-after-free on the already fre=
ed
bridge pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D6
