From: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Date: Mon, 05 Jan 2009 10:03:12 +0800
Message-ID: <1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104093103.46167d23@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090104093103.46167d23@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-01-04 at 09:31 -0800, Arjan van de Ven wrote:
> From 20af3efd07b775a27a997e3df1039e20ea18f62b Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous
> 
> the various ACPI bus drivers have non-overlapping devices and can
> each be run asynchronous. Some of the ACPI drivers (especially the
> battery one, but others as well) can take quite a long time to probe.
It seems that all the ACPI drivers are registered asynchronously after
this change. 
   But there exists some dependency between some ACPI device drivers. It
is not very reasonable that the device driver is loaded asynchronously
if there exists the dependency between some drivers. 

For example: 
   On some boxes the info of battery is related with Embedded
controller. The EC driver should be loaded completely before registering
battery driver.
   On some boxes there exist the devices of ACPI power resource. And the
device power state is transited by controlling power resource. In such
case the power resource device driver should be loaded completely before
transiting the device power state.


Best regards.

> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/acpi/scan.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 39b7233..a9e542d 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -8,6 +8,7 @@
>  #include <linux/acpi.h>
>  #include <linux/signal.h>
>  #include <linux/kthread.h>
> +#include <linux/async.h>
>  
>  #include <acpi/acpi_drivers.h>
>  #include <acpi/acinterp.h>	/* for acpi_ex_eisa_id_to_string() */
> @@ -578,6 +579,19 @@ static int acpi_start_single_object(struct acpi_device *device)
>  	return result;
>  }
>  
> +static void acpi_bus_register_async(void *data, async_cookie_t cookie)
> +{
> +	int ret;
> +	struct acpi_driver *driver = data;
> +	driver->drv.name = driver->name;
> +	driver->drv.bus = &acpi_bus_type;
> +	driver->drv.owner = driver->owner;
> +
> +	async_synchronize_cookie(cookie);
> +
> +	ret = driver_register(&driver->drv);
> +	WARN_ON(ret != 0);
> +}
>  /**
>   * acpi_bus_register_driver - register a driver with the ACPI bus
>   * @driver: driver being registered
> @@ -588,16 +602,11 @@ static int acpi_start_single_object(struct acpi_device *device)
>   */
>  int acpi_bus_register_driver(struct acpi_driver *driver)
>  {
> -	int ret;
>  
>  	if (acpi_disabled)
>  		return -ENODEV;
> -	driver->drv.name = driver->name;
> -	driver->drv.bus = &acpi_bus_type;
> -	driver->drv.owner = driver->owner;
> -
> -	ret = driver_register(&driver->drv);
> -	return ret;
> +	async_schedule(acpi_bus_register_async, driver);
> +	return 0;
>  }
>  
>  EXPORT_SYMBOL(acpi_bus_register_driver);
> -- 
> 1.6.0.6
> 
> 

