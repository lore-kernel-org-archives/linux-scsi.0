From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Wed, 14 Jan 2004 15:58:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114155848.A28421@beaverton.ibm.com>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:45517 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266502AbUANX7c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 18:59:32 -0500
Content-Disposition: inline
In-Reply-To: <20040114181241.GK27591@localhost>; from mort@wildopensource.com on Wed, Jan 14, 2004 at 01:12:41PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Jan 14, 2004 at 01:12:41PM -0500, Martin Hicks wrote:
> 
> Hi,
> 
> Here is round#3 of the patch.  I think I've addressed all of the points
> that were brought up by Christoph last time.

Nice, I can now easily see LUN to port mappings, though I don't easily get
port to LUN mapping.

> diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
> --- a/drivers/scsi/scsi_syms.c	Wed Jan 14 12:59:11 2004
> +++ b/drivers/scsi/scsi_syms.c	Wed Jan 14 12:59:11 2004
> @@ -21,6 +21,8 @@
>  #include <scsi/scsi_driver.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_transport_spi.h>
> +#include <scsi/scsi_transport_fc.h>
>  #include <scsi/scsicam.h>
>  #include "scsi.h"
>  
> @@ -107,3 +109,10 @@
>   */
>  EXPORT_SYMBOL(scsi_add_timer);
>  EXPORT_SYMBOL(scsi_delete_timer);
> +
> +#ifdef CONFIG_SCSI_SPI_ATTRS
> +EXPORT_SYMBOL(spi_transport_template);
> +#endif
> +#ifdef CONFIG_SCSI_FC_ATTRS
> +EXPORT_SYMBOL(fc_transport_template);
> +#endif

Can you move these exports to their respective source files? scsi_syms.c
should go away someday. And then we touch one less scsi core file.

> diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> --- a/drivers/scsi/scsi_sysfs.c	Wed Jan 14 12:59:11 2004
> +++ b/drivers/scsi/scsi_sysfs.c	Wed Jan 14 12:59:11 2004
> @@ -13,6 +13,9 @@
>  #include <linux/device.h>
>  
>  #include <scsi/scsi_host.h>
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_transport_spi.h>
> +#include <scsi/scsi_transport_fc.h>
>  #include "scsi.h"
>  
>  #include "scsi_priv.h"
> @@ -162,13 +165,31 @@
>  	int error;
>  
>  	error = bus_register(&scsi_bus_type);
> -	if (!error) {
> -		error = class_register(&sdev_class);
> -		if (error)
> -			bus_unregister(&scsi_bus_type);
> -	}
> +	if (error)
> +		return error;
>  
> +	error = class_register(&sdev_class);
> +	if (error)
> +		goto undo_bus;
> +
> +	error = scsi_spi_transport_init();
> +	if (error)
> +		goto undo_sdev;
> +
> +	error = scsi_fc_transport_init();
> +	if (error)
> +		goto undo_all;
> +
> + out:
>  	return error;
> +
> + undo_all:
> +	scsi_spi_transport_exit();
> + undo_sdev:
> +	class_unregister(&sdev_class);
> + undo_bus:
> +	bus_unregister(&scsi_bus_type);
> +	goto out;

What happened to making the transports their own module? Then their init
code can register their class, and we don't need to modify any scsi core
files if a new transport file is added.

Or, do a lazy init in the setup functions based on a static (and use a
semaphore to prevent races). That would also keep empty class
fc_transport and spi_transport directories from showing up for the most
scsi users (those with only usb mass storage devices).

> +/* the FiberChannel Tranport Attributes: */
> +fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
> +fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
> +fc_transport_rd_attr(port_id, "0x%x\n");

These are all per target attributes (are all fc level attributes?).

Does that matter? I think it's ok , though someday we should have a target
representation. 

Example:

[elm3b79 scsi]$ cat /sys/class/fc_transport/11\:0\:0\:*/port_name | head -4
0x200400a0b80b17a4
0x200400a0b80b17a4
0x200400a0b80b17a4
0x200400a0b80b17a4
[elm3b79 scsi]$ cat /sys/class/fc_transport/11\:0\:0\:*/port_id | head -4
0x210a13
0x210a13
0x210a13
0x210a13
[elm3b79 scsi]$ cat /sys/class/fc_transport/11\:0\:0\:*/node_name | head -4
0x200400a0b80b17a3
0x200400a0b80b17a3
0x200400a0b80b17a3
0x200400a0b80b17a3

-- Patrick Mansfield
