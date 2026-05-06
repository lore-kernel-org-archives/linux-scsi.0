Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B1B21ABD7;
	Wed,  6 May 2026 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778092083; cv=none; b=A744oz5c8dT3PxvWlB0bc1mZA3/MxYz1EV1e9mY0+p1O9CCsyINW7Q1N+gimc9MYbigRJnnDldT+9AgJwSWMHCFBCY84V3NjxuMES1Kp8QN7eh4xLbHUlqPZPIMrVvOnNFyESeMQeZzmIzezeq2Rlzwtbv02pEWfeRfH/yT90Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778092083; c=relaxed/simple;
	bh=jlQrcIbWomenhNoj/8xHLnSkp47Vutmn92tD24BRgHg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=aLMuLKC0boYKg9vMCORXAgQzS6+5yQvVHskAFUzmuNq0ReCycssoaekhAboveIBaY3rzVCo2/BUgJ8yoTfb40d1feEQ7pOvQyXGtbQyMeXOuxEDZp0MlWbHl57Cq90clHztNMxFGigiBCE5CPEiEJ2jTRY/rpPPVhXsHyo6QQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V80eYLLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V80eYLLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ABFC2BCB0;
	Wed,  6 May 2026 18:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778092083;
	bh=jlQrcIbWomenhNoj/8xHLnSkp47Vutmn92tD24BRgHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=V80eYLLvvYNvUDbpR0K4vfgvU37Du3P8q/mYdWap7aJMgYwDVfSO4wTCRAtDACD0h
	 if8CYVD1r+xRoM++8D5IRg2t6KdADvfkZ7Us4L9lL0g++faf+Avpg+E1BxS5O6Xzml
	 Ay3LeydT62BJan98OtknbEk9aIakGsdHkB4MfbajWSXZZseGtyJdg4X9G4Bc8Xl3L+
	 rh0RYgEgL0iEwPXt/YMWkj3rYtadi5KX5AqnxYROIBso6XsW186SWwX7wpJemQMiXE
	 7Z+lDPWBGitu+v/QDhOV3zcum8sBM9VdkmzvoUu4XzpmzA5fgse/7h3s6wcXDoSVx6
	 lQpbgbv+9SoDQ==
Date: Wed, 6 May 2026 13:28:01 -0500
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
	Laurence Oberman <loberman@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH 4/5] PCI: Enable async shutdown support
Message-ID: <20260506182801.GA805231@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429175016.7915-5-djeffery@redhat.com>

On Wed, Apr 29, 2026 at 01:50:15PM -0400, David Jeffery wrote:
> Like its async suspend support, allow PCI device shutdown to be performed
> asynchronously to reduce shutdown time.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

I'm concerned about tripping over driver issues, but it's a pretty big
benefit.  I think it's worth mentioning the "async_shutdown" module
parameter somewhere in the commit logs and putting an example in
Documentation/admin-guide/kernel-parameters.txt.

Might even consider keeping in -next for a cycle+ and targeting v7.3.

> ---
>  drivers/pci/probe.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index b63cd0c310bc..86e855090553 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1045,6 +1045,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
>  
>  	bus->bridge = get_device(&bridge->dev);
>  	device_enable_async_suspend(bus->bridge);
> +	device_enable_async_shutdown(bus->bridge);
>  	pci_set_bus_of_node(bus);
>  	pci_set_bus_msi_domain(bus);
>  	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
> @@ -2753,6 +2754,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
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
