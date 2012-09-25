From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Tue, 25 Sep 2012 15:02:29 +0400
Message-ID: <1348570949.2457.36.camel@dabdike>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
	 <201209241506.11631.rjw@sisk.pl>
	 <20120924150449.GB3293@mint-spring.sh.intel.com>
	 <201209242346.03414.rjw@sisk.pl>
	 <20120925081825.GA1666@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120925081825.GA1666@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-09-25 at 16:18 +0800, Aaron Lu wrote:
> A example patch would be something like the following, I didn't seperate
> these ACPI calls in sr.c as this is just a concept proof, if this is the
> right thing to do, I will separate them into another file sr-acpi.c and
> make empty stubs for them in sr.h for systems do not have ACPI configured.

Apart from the needed separation to compile in the !ACPI case

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index ef72682..94d17f1 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -46,6 +46,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/acpi.h>
>  #include <asm/uaccess.h>
>  
>  #include <scsi/scsi.h>
> @@ -57,6 +58,8 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
>  
> +#include <acpi/acpi_bus.h>
> +
>  #include "scsi_logging.h"
>  #include "sr.h"
>  
> @@ -212,8 +220,8 @@ static int sr_resume(struct device *dev)
>  	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
>  
>  	/* If user wakes up the ODD, eject the tray */
> -	if (cd->device->need_eject) {
> -		cd->device->need_eject = 0;
> +	if (cd->need_eject) {
> +		cd->need_eject = false;
>  		/* But only for tray type ODD when door is not locked */
>  		if (!(cd->cdi.mask & CDC_CLOSE_TRAY) && !cd->door_locked)
>  			sr_tray_move(&cd->cdi, 1);
> @@ -704,6 +711,58 @@ static void sr_release(struct cdrom_device_info *cdi)
>  
>  }
>  
> +static void sr_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> +{
> +	struct device *dev = context;
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +
> +	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
> +		cd->need_eject = true;
> +		pm_runtime_resume(dev);
> +	}
> +}
> +
> +static void sr_acpi_add_pm_notifier(struct device *dev)
> +{
> +	struct acpi_device *acpi_dev;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = dev->archdata.acpi_handle;

This is a complete no-no.  archdata is defined to be specific to the
architecture it's supposed to be opaque to non-arch code.  You'll find
that only x86 and ia64 defines an acpi_handle there.  This will
instantly fail to compile on non intel.  If you need the handle, it
should be obtained via some accessor like dev_to_acpi_handle() which
will allow this to continue to function when, say, arm acquires ACPI.

I've got to say, this looks like a fault in ACPI itself.  If the handles
are 1:1 with struct device, then why not have all the functions taking
handles take the device instead and leave the embedded handle safely in
the architecture specific code?

James


