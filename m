Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48C13A169C;
	Wed, 11 Mar 2026 23:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270535; cv=none; b=fbWqNgWcGo+smyBJd2aahg3zyV0A89buch/8nRd/mpBuyMMPSAF/BzKGlxIK8ClH+JUSo/aJKs81RLXZHHtjJE2iCQuzN/r8vgB4kxRovxV1oWHBtuA4immG4opm6WTTddqdniYFQhsY8PsQ8W5RIBy9llzatZV1DPKscU+80Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270535; c=relaxed/simple;
	bh=S/ibHJvp2x1a2muY4IWA+W1D7+RXVJaPAnBOADTEWhs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AfT52Mz31KAyFZ5nGwVdkjZTyGSB3be6+UZzdyrv0y1g9sdK+y9yPXE1VVm9FsF4sNt1h8EdfO86x1zaLlQFUoVVYuyGCHTkB385Ebte4n9xfY6673fJTQ83/oH9OKTA4fPf7kz9FFeL0Vqy03oHmjhUx8uJjIVYvCkRhwogIQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8hn2o/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8hn2o/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B38C4CEF7;
	Wed, 11 Mar 2026 23:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270535;
	bh=S/ibHJvp2x1a2muY4IWA+W1D7+RXVJaPAnBOADTEWhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=j8hn2o/mjXWtN0T82SyFB0ZXRFHWDLWVYzDVKZRmMLd3vWpebp9YpaF4C9+81By78
	 0ZsJpyxif5POxZPGjfDGm61zX198zPGEHdgHJT182GXXOlaY1WlPpTSXjqIraSNb/6
	 cKzP9FqoZYh2HMABCEO56L4rjqx1wSf8MEfaKA6JUrjUK9IuA8km7ZOYUSKgVNv//f
	 NvGPp4EniJQ/Z9r5wjudNQTl55kXW7irAXpQMK5XZO0S1CXWAHJwTBLMWFMCc6zQtV
	 uQt6Xt/GE2EVY4TF+Ad9c+BlZI+6WbJmSYXpv9FwGUIPBHmWzllY11kiUN8mBs3E0u
	 JtSkFOJFaehDQ==
Date: Wed, 11 Mar 2026 18:08:54 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 4/5] pci: enable async shutdown support
Message-ID: <20260311230854.GA1051125@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311171209.9205-4-djeffery@redhat.com>

In subject, to match history:

  PCI: Enable async shutdown support

On Wed, Mar 11, 2026 at 01:12:08PM -0400, David Jeffery wrote:
> Like its async suspend support, allow pci device shutdown to be performed
> asynchronously to improve shutdown time.

s/pci/PCI/
s/improve/reduce/

I like how simple this looks, so I hope it all works out.

BTW, something seems messed up in your post threading.  I assume this
series is supposed to go with the cover letter at
https://lore.kernel.org/all/20260311170956.9146-1-djeffery@redhat.com,
but the patches don't seem to be replies to the cover letter.

>  drivers/pci/probe.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bccc7a4bdd79..4d98bab2163d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1040,6 +1040,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
>  
>  	bus->bridge = get_device(&bridge->dev);
>  	device_enable_async_suspend(bus->bridge);
> +	device_enable_async_shutdown(bus->bridge);
>  	pci_set_bus_of_node(bus);
>  	pci_set_bus_msi_domain(bus);
>  	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
> @@ -2749,6 +2750,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  	pci_reassigndev_resource_alignment(dev);
>  
>  	pci_init_capabilities(dev);
> +	device_enable_async_shutdown(&dev->dev);
>  
>  	/*
>  	 * Add the device to our list of discovered devices
> -- 
> 2.53.0
> 
