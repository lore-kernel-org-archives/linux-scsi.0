From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 2/3] PCI: Use device_match_always()
Date: Fri, 10 Jun 2016 11:13:43 -0500
Message-ID: <20160610161343.GH19309@localhost>
References: <20160606073238.1073-1-thierry.reding@gmail.com>
 <20160606073238.1073-2-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606073238.1073-2-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 06, 2016 at 09:32:37AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> There is now a common implementation for a match function that will
> always match, so the PCI-specific implementation can be removed.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I'm sort of OK with this.  It's clearly not going to break anything.

But I would far rather figure out a way to remove no_pci_devices()
completely.  There's only one in-tree caller, and it's sort of
dubious, although the idea was added by Linus (2bff5e94f1bf).

I suppose nowadays we would use ACPI or DMI to do this.  But I guess
this is OK as-is.  It'd be pretty hard to find a PC110 to test any
real driver changes.

I assume all three of these patches would get merged together by
somebody else.

> ---
>  drivers/pci/probe.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 8e3ef720997d..3db06d8d6497 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -62,11 +62,6 @@ static struct resource *get_pci_domain_busn_res(int domain_nr)
>  	return &r->res;
>  }
>  
> -static int find_anything(struct device *dev, void *data)
> -{
> -	return 1;
> -}
> -
>  /*
>   * Some device drivers need know if pci is initiated.
>   * Basically, we think pci is not initiated when there
> @@ -77,7 +72,7 @@ int no_pci_devices(void)
>  	struct device *dev;
>  	int no_devices;
>  
> -	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
> +	dev = bus_find_device(&pci_bus_type, NULL, NULL, device_match_always);
>  	no_devices = (dev == NULL);
>  	put_device(dev);
>  	return no_devices;
> -- 
> 2.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
