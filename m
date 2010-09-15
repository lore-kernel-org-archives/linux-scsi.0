From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 4/5] acpi: Add support for linking docks to the objects
 they contain
Date: Wed, 15 Sep 2010 13:05:04 -0700
Message-ID: <20100915130504.099bbeb6.randy.dunlap@oracle.com>
References: <1284580683-2386-1-git-send-email-mjg@redhat.com>
	<1284580683-2386-4-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1284580683-2386-4-git-send-email-mjg@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, lenb@kernel.org, James.Bottomley@suse.de, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 15 Sep 2010 15:58:02 -0400 Matthew Garrett wrote:

> When undocking, it's helpful to know which devices are going to disappear.
> This patch adds support for adding symlinks to the device into the docking
> bay.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/dock.c         |   82 +++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_drivers.h |   10 +++++
>  2 files changed, 92 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 3fe29e9..685aac9 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -276,6 +276,88 @@ int is_dock_device(acpi_handle handle)
>  EXPORT_SYMBOL_GPL(is_dock_device);
>  
>  /**
> + *
> + * dock_link_device - link a device from the dock
> + * @handle: acpi handle of the potentially dependent device
> + *
> + */

Nope, kernel-doc does not allow extra line(s) between the beginning /**
and the function name.  Please delete that above & below.

> +struct device **dock_link_device(acpi_handle handle)
> +{
> +	struct device *dev = acpi_get_physical_device(handle);
> +	struct dock_station *dock_station;
> +	int ret, dock = 0;
> +	struct device **devices;
> +
> +	devices = kmalloc(dock_station_count * sizeof(struct device *),
> +			  GFP_KERNEL);
> +
> +	if (!dev)
> +		return NULL;
> +
> +	if (is_dock(handle)) {
> +		put_device(dev);
> +		return NULL;
> +	}
> +
> +	list_for_each_entry(dock_station, &dock_stations, sibling) {
> +		if (find_dock_dependent_device(dock_station, handle)) {
> +			ret = sysfs_create_link(&dock_station->dock_device->dev.kobj,
> +						&dev->kobj, dev_name(dev));
> +			WARN_ON(ret);
> +			devices[dock] = &dock_station->dock_device->dev;
> +			dock++;
> +		}
> +	}
> +	if (!dock)
> +		put_device(dev);
> +
> +	devices[dock] = NULL;
> +	return devices;
> +}
> +EXPORT_SYMBOL_GPL(dock_link_device);
> +
> +/**
> + *
> + * dock_unlink_device - unlink a device from the dock
> + * @handle: acpi handle of the potentially dependent device
> + *
> + */
> +struct device **dock_unlink_device(acpi_handle handle)
> +{
> +	struct device *dev = acpi_get_physical_device(handle);
> +	struct dock_station *dock_station;
> +	int dock = 0;
> +	struct device **devices =
> +		kmalloc(dock_station_count * sizeof(struct device *),
> +			GFP_KERNEL);
> +
> +	if (!dev)
> +		return NULL;
> +
> +	if (is_dock(handle)) {
> +		put_device(dev);
> +		return NULL;
> +	}
> +
> +	list_for_each_entry(dock_station, &dock_stations, sibling) {
> +		if (find_dock_dependent_device(dock_station, handle)) {
> +			sysfs_remove_link(&dock_station->dock_device->dev.kobj,
> +					  dev_name(dev));
> +			devices[dock] = &dock_station->dock_device->dev;
> +			dock++;
> +		}
> +	}
> +	/* An extra reference has been held while the link existed */
> +	if (dock)
> +		put_device(dev);
> +
> +	put_device(dev);
> +	devices[dock] = NULL;
> +	return devices;
> +}
> +EXPORT_SYMBOL_GPL(dock_unlink_device);
> +
> +/**
>   * dock_present - see if the dock station is present.
>   * @ds: the dock station
>   *


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
