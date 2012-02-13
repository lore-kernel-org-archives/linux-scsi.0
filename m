From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Mon, 13 Feb 2012 21:48:04 +0100
Message-ID: <201202132148.04961.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com> <1329124271-29464-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, February 13, 2012, Lin Ming wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> ACPI Power Resource can power on/off a couple of devices.
> Introduce interfaces to register/unregister a device to/from
> an ACPI Power Resource.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/power.c    |  128 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    2 +
>  2 files changed, 130 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 0d681fb..a7e2305 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -84,10 +84,25 @@ struct acpi_power_resource {
>  	u32 order;
>  	unsigned int ref_count;
>  	struct mutex resource_lock;
> +	struct list_head devices; /* list for devices powered by this PR */
>  };
>  
>  static struct list_head acpi_power_resource_list;
>  
> +/*
> + * When a power resource is turned on, all the devices are put to an uninitialized
> + * state although their ACPI states are still D0.
> + * To handle this, we need to keep a list of all devices powered by the power resource,
> + * and resume all of them.
> + * Currently, we only support this case:
> + * 1) multiple devices share the same power resoruce,
> + * 2) One device uses One Power Resource ONLY.

This is incorrect.  We actually support all combinations.  However, we don't
generally support checking what devices depend on the given power resource.

> + */
> +struct acpi_powered_device {
> +	struct list_head node;
> +	struct device *dev;
> +};
> +
>  /* --------------------------------------------------------------------------
>                               Power Resource Management
>     -------------------------------------------------------------------------- */
> @@ -455,6 +470,118 @@ int acpi_disable_wakeup_device_power(struct acpi_device *dev)
>                               Device Power Management
>     -------------------------------------------------------------------------- */
>  
> +int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
> +{
> +	struct acpi_power_resource *resource;
> +	struct acpi_device *acpi_dev, *res_dev;
> +	acpi_handle res_handle = NULL;
> +	struct acpi_powered_device *apd;
> +	int i;
> +	int ret;
> +
> +	if (!handle || !dev)
> +		return -EINVAL;
> +
> +	ret = acpi_bus_get_device(handle, &acpi_dev);
> +	if (ret)
> +		goto no_power_resource;
> +
> +	if (!acpi_dev->power.flags.power_resources)
> +		goto no_power_resource;
> +
> +	for (i = 0; i <= ACPI_STATE_D3; i++) {
> +		struct acpi_device_power_state *ps = &acpi_dev->power.states[i];
> +
> +		if (!ps->flags.valid)
> +			continue;
> +
> +		if (ps->resources.count > 1)
> +			return 0;
> +
> +		if (!res_handle)
> +			res_handle = ps->resources.handles[0];
> +		else if (res_handle != ps->resources.handles[0])
> +			return 0;
> +	}

I'm not sure what the above checks are needed for.  It seems that this function
will only be called from acpi_bus_add_power_resource() (which needs to be
modified for this purpose, BTW), so it doesn't need to check all those things
(those checks have been made already).

> +
> +	ret = acpi_bus_get_device(res_handle, &res_dev);
> +	if (ret)
> +		goto no_power_resource;
> +
> +	resource = res_dev->driver_data;
> +	if (!resource)
> +		goto no_power_resource;
> +
> +	apd = kzalloc(sizeof(struct acpi_powered_device), GFP_KERNEL);
> +	if (!apd)
> +		return -ENOMEM;
> +
> +	apd->dev = dev;
> +	mutex_lock(&resource->resource_lock);
> +	list_add_tail(&apd->node, &resource->devices);
> +	mutex_unlock(&resource->resource_lock);
> +	printk(KERN_INFO PREFIX "Device %s uses Power Resource %s\n", dev->kobj.name, acpi_device_name(res_dev));
> +
> +	return 0;
> +
> +no_power_resource:
> +	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
> +	return -ENODEV;
> +}
> +
> +void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle)
> +{

Who is supposed to call this one?

> +	struct acpi_power_resource *resource;
> +	struct acpi_device *acpi_dev, *res_dev;
> +	acpi_handle res_handle = NULL;
> +	struct acpi_powered_device *apd, *tmp;
> +	int i;
> +	int ret;
> +
> +	if (!handle || !dev)
> +		return;
> +
> +	ret = acpi_bus_get_device(handle, &acpi_dev);
> +	if (ret)
> +		return;
> +
> +	if (!acpi_dev->power.flags.power_resources)
> +		return;
> +
> +	for (i = 0; i <= ACPI_STATE_D3; i++) {
> +		struct acpi_device_power_state *ps = &acpi_dev->power.states[i];
> +
> +		if (!ps->flags.valid)
> +			continue;
> +
> +		if (ps->resources.count > 1)
> +			return;
> +
> +		res_handle = ps->resources.handles[0];
> +		break;
> +	}
> +
> +	if (!res_handle)
> +		return;
> +
> +	ret = acpi_bus_get_device(res_handle, &res_dev);
> +	if (ret)
> +		return;
> +
> +	resource = res_dev->driver_data;
> +	if (!resource)
> +		return;
> +
> +	mutex_lock(&resource->resource_lock);
> +	list_for_each_entry_safe(apd, tmp, &resource->devices, node) {
> +		if (apd->dev == dev) {
> +			list_del(&apd->node);
> +			kfree(apd);
> +		}
> +	}
> +	mutex_unlock(&resource->resource_lock);
> +}
> +
>  int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
>  {
>  	int result = 0;
> @@ -550,6 +677,7 @@ static int acpi_power_add(struct acpi_device *device)
>  
>  	resource->device = device;
>  	mutex_init(&resource->resource_lock);
> +	INIT_LIST_HEAD(&resource->devices);
>  	strcpy(resource->name, device->pnp.bus_id);
>  	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
>  	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 6cd5b64..32fb899 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -322,6 +322,8 @@ int acpi_bus_get_status(struct acpi_device *device);
>  int acpi_bus_set_power(acpi_handle handle, int state);
>  int acpi_bus_update_power(acpi_handle handle, int *state_p);
>  bool acpi_bus_power_manageable(acpi_handle handle);
> +int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
> +void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
>  bool acpi_bus_can_wakeup(acpi_handle handle);
>  #ifdef CONFIG_ACPI_PROC_EVENT
>  int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);

Thanks,
Rafael
