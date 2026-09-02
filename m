Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2E4ACC9D;
	Wed,  2 Sep 2026 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369865; cv=none; b=iScrDdsEfM7/G9KJ8pOK3tuRpKUOJ9/8mbOVzq7PjEyqU2y6Oum/TwGgFcNdFuybfMINRnpjbwDs1GiRH3jWEEObfFIWd0FO/An2fM57721lY/YLJZnFCOmbm7cYuFT43Wa53/Pq78RhRgzxaX6Xc1xI9WBKuwsDa+QdCeKt2k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369865; c=relaxed/simple;
	bh=eeLRw7d1grT4dsdje/AGv8bA6TLqEHQqgitZ7cG2VmE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R4qHVCvMvMmsqDaa/xmDvjHPhrSOOHCSBQrEgbzKz9YnRG0T1Iqk5PlVwxuOxaQBV/ElZHRL4FUtXzDLTkFwhUq/pYEIaLsI0MNQk3NMS8wS3PLaw3K+P/AGn+Gcg8T7/pNkD+f/e2rwXcAr7hfO108YAOVz1GFZGzZLFgu6bRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgVxwDnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgVxwDnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B9B1F000E9;
	Wed,  2 Sep 2026 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369863;
	bh=o9QVaXvhVFf3OAMWsq7YQ5bnPF6nwdCB8djYgDCUIy0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HgVxwDnIn/s5XFBnKzZK6tKXuXHxUlCMbZmgIbpiUn60RqRrAtBZA+0cMhui8L7HH
	 b9YQAbUidAC5nZZn+m1JL3O6u6SqdH66g5bB/ZlKAQMpdb2PcRr63bnI9FXdM0twB7
	 8WbtVNsCtsA9jbpHuiGDhrKoqsX4VuKFJyit0PBf1movFFd2TBfGje3IRahnvsCya0
	 BgRMiqxvJtrzyfSepStNn/F8n/Km+1HAe7FXZrtNenwJ4qptj7ExqxuOSSbpofozCZ
	 D7k5UzvFt8aK3MN8J8XU4IWxqa8R6QHrCtBAbphWgwZO1+8AiJ3Lx56XsXd5ELmBy8
	 aJkaknmUHNjdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] PCI: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260902170734.95504-9-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-9-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:24:22 +0000
Message-Id: <20260902172423.22B9B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Double free and subsequent use-after-free of `bridge->dev` on =
`pci_register_host_bridge` error path.
--

commit 54e023865d6e2709d08edb15dbcb7e1249cfbfb7
Author: David Jeffery <djeffery@redhat.com>

PCI: Enable async shutdown support
   =20
Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 27008e2ea5afc..101a96718acd9 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1038,6 +1038,7 @@ static int pci_register_host_bridge(struct pci_host=
_bridge *bridge)
>  	if (err)
>  		goto free;
> =20
> +	dev_set_async_shutdown(&bridge->dev);
>  	/* Temporarily move resources off the list */
>  	list_splice_init(&bridge->windows, &resources);
>  	err =3D device_add(&bridge->dev);

[Severity: Critical]
This isn't a bug introduced by this patch, but does the error handling path
for pci_register_host_bridge() have a double free and use-after-free of
bridge->dev?

If device_register(&bus->dev) fails later in this function, it jumps to
unregister:

drivers/pci/probe.c:pci_register_host_bridge() {
	...
unregister:
	put_device(&bridge->dev);
	device_del(&bridge->dev);
free:
	...
	if (bus_registered)
		put_device(&bus->dev);
}

The first explicit put_device(&bridge->dev) drops a reference to the
bridge. Then if bus_registered is true, it calls put_device(&bus->dev).

This triggers the bus release function release_pcibus_dev(), which
unconditionally drops a second reference to bridge->dev:

drivers/pci/probe.c:release_pcibus_dev() {
	...
	put_device(pci_bus->bridge);
	...
}

This drops the reference count of the bridge to 0, freeing the bridge objec=
t.

When pci_register_host_bridge() returns the error, callers like
pci_create_root_bus() will then try to drop their initial reference:

drivers/pci/probe.c:pci_create_root_bus() {
	...
err_out:
	put_device(&bridge->dev);
	...
}

Will this dereference the already freed bridge object, causing a
use-after-free and double free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D8
