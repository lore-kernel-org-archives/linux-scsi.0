From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] further sim710 updates
Date: 10 Feb 2003 09:27:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044890849.2008.71.camel@mulgrave>
References: <20030210085920.A11560@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA00959
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2003 07:27:33 -0800
In-Reply-To: <20030210085920.A11560@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-10 at 01:59, Christoph Hellwig wrote:
> and I think there's more that should be done, but this would change
> user-visiable attributes:
> 
>   - remove the ugly single module option code and the command line
>     parsing in favour of Rusty's new module_param stuff
>   - split the driver into two drivers: 53c700_eisa and 53c700_mca.
>     There's no logic shared between those two busses, just a little
>     bit of helper in the setup/remove code

Sounds good if you want to do a patch.

> And after looking a this driver I have some rants about the new
> mac/eisa code:
> 
>   - mca_register_driver/mca_unregister_driver should check for
>     the precense of an MCA bus by themselves instead of leaving
>     it to the caller

The if(MCA_bus) is unnecessary.  If there's no MCA bus, no IDs will be
stored, so nothing will get attached.

>   - eisa_driver_register should really return 0 for sucess

Yes.

>   - mca_register_driver/mca_unregister_driver should be named
>     mca_driver_register/mca_driver_unregister to be more similar
>     to the other *driver_(un)registers.

Which others?  I modelled the interface on PCI, which has
pci_register_driver() etc.  I agree on standardisation, but the way I
did it was standard when the MCA bus code was written...

> --- 1.8/drivers/scsi/sim710.c	Sun Feb  9 11:07:34 2003
> +++ edited/drivers/scsi/sim710.c	Mon Feb 10 08:03:50 2003
> @@ -32,51 +32,18 @@
>  #include <linux/blk.h>
>  #include <linux/device.h>
>  #include <linux/init.h>
> -#ifdef CONFIG_MCA
>  #include <linux/mca.h>
> -#endif

This can't be done otherwise the driver won't compile on non x86 archs
(yes, I know, I'll fix the MCA header file...)

> +	/*
> +	 * The eise_driver_register return values are strange.  I have
> +	 * no idea why we don't just use river_register directly anyway..
> +	 */

I can answer that: Some of the driver registration routines have to do
bus and device fixups.  There's no mechanism in the current
device_driver template.  When taxed with the problem, Patrick Mochel
decided that retaining bus specific registration routines was the better
way forward.

James



