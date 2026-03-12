Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A801C36D4FD;
	Thu, 12 Mar 2026 05:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773292151; cv=none; b=iFYFdobJrm5W74L2ATR6Az2Kgj+G2KiM6vBQirmuKZP0kNQdhlfB0Gu3IfnbPnguMC8WsN9LKvPomSklZDs3+q9ec6o1xMX1Eys3dVixfLQgUD9oapylJCOnfLC8WM+2TuGh9D25dvNwMNH4+vCtLyFK1BNtTPBkXgg4Ztt+4D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773292151; c=relaxed/simple;
	bh=ofmlJV+eDptC2ebvddEkwl/PGrvGZT+P7BJ4ncV2Ve0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThawWUw8y0bhcT3ZRI0tKVEKry5oEshig803Hfqwl6LGkLIpGjrzkQ6pM+alzcHNWYtMYdzzLXgxZWGL1bK4twoMpXAoo20oC0Y3mlIROkYqterob8zKxtH1AL5GUQQlRUjRegvheJpFLCNnXZ9zAe2BtnyMkYoEBzdk/PG1w78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADkae1Jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADkae1Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0F4C4CEF7;
	Thu, 12 Mar 2026 05:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773292151;
	bh=ofmlJV+eDptC2ebvddEkwl/PGrvGZT+P7BJ4ncV2Ve0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ADkae1Jp1zIlk+Lu6wIyPP4fUvPqCSGYd2mXgDJvbvIoV4wtkQ8PQVk6/SoZuO7dx
	 ostgWIq0pMzw357j+VvA3qpGfvKF8JBz3ywXm5cMxpguxFfl/Ju7yqzR4Oy9hqcrrC
	 UQkoT7I9zT2wJwpdJhmObbLSMc0DGX0EGc49TOpU=
Date: Thu, 12 Mar 2026 06:09:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
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
Message-ID: <2026031229-coastland-ducktail-c4b9@gregkh>
References: <20260311171209.9205-1-djeffery@redhat.com>
 <20260311171209.9205-4-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311171209.9205-4-djeffery@redhat.com>

On Wed, Mar 11, 2026 at 01:12:08PM -0400, David Jeffery wrote:
> Like its async suspend support, allow pci device shutdown to be performed
> asynchronously to improve shutdown time.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
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

For all PCI devices?  Are you sure this is ok?  That feels like it is
going to be ripe with race conditions...

How was this tested?

thanks,

greg k-h
