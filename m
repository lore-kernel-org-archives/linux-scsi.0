From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch 15/26] g_NCR5380: fix missing pnp_device_detach and
 scsi_unregister on rmmod
Date: Thu, 11 Mar 2010 16:37:43 -0600
Message-ID: <1268347063.5344.90.camel@mulgrave.site>
References: <201003112209.o2BM9lo2013651@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0CKWht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:37:49 -0500
In-Reply-To: <201003112209.o2BM9lo2013651@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux@rainbow-software.org

On Thu, 2010-03-11 at 14:09 -0800, akpm@linux-foundation.org wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
> 
> Add missing pnp_device_detach() and scsi_unregister() at rmmod time.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/g_NCR5380.c |    7 ++++++-
>  drivers/scsi/g_NCR5380.h |    5 +++--
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod drivers/scsi/g_NCR5380.c
> --- a/drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod
> +++ a/drivers/scsi/g_NCR5380.c
> @@ -290,6 +290,7 @@ int __init generic_NCR5380_detect(struct
>  #ifndef SCSI_G_NCR5380_MEM
>  	int i;
>  	unsigned long region_size = 16;
> +	struct pnp_dev *pnpdevs[NO_OVERRIDES];

This is a stack array, so initialised with random crap

>  #endif
>  	static unsigned int __initdata ncr_53c400a_ports[] = {
>  		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
> @@ -337,6 +338,7 @@ int __init generic_NCR5380_detect(struct
>  				pnp_device_detach(dev);
>  				continue;
>  			}
> +			pnpdevs[count] = dev;

This is only hit on isapnp_present() being true

>  			if (pnp_irq_valid(dev, 0))
>  				overrides[count].irq = pnp_irq(dev, 0);
>  			else
> @@ -449,6 +451,7 @@ int __init generic_NCR5380_detect(struct
>  		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
>  #ifndef SCSI_G_NCR5380_MEM
>  		instance->n_io_port = region_size;
> +		((struct NCR5380_hostdata *)instance->hostdata)->pnpdev = pnpdevs[current_override];

This is unconditional, so in the non-pnp case it will transfer crap to
->pnpdev.

>  #else
>  		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
>  #endif
> @@ -520,12 +523,14 @@ int generic_NCR5380_release_resources(st
>  
>  #ifndef SCSI_G_NCR5380_MEM
>  	release_region(instance->NCR5380_instance_name, instance->n_io_port);
> +	if (((struct NCR5380_hostdata *)instance->hostdata)->pnpdev)
> +		pnp_device_detach(((struct NCR5380_hostdata *)instance->hostdata)->pnpdev);

And here we'll feed random crap into php_device_detach, which I rather
think will oops.

This looks fixable with a memset, but it's a rather icky way to do
things.

James


