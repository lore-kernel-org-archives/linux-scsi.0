From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v2 2/8] ACPI: Add interface to register/unregister
 device to/from power resources
Date: Mon, 19 Mar 2012 09:32:07 +0800
Message-ID: <CAF1ivSa00P8Yx1vhAf3MV56zSLbZVmjWEnhigvJdwfkzcJUNog@mail.gmail.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	<1330592577-16546-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1330592577-16546-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 1, 2012 at 5:02 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Devices may share same list of power resources in _PR0, for example
>
> Device(Dev0)
> {
> =A0 =A0 =A0 =A0Name (_PR0, Package (0x01)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0P0PR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0P1PR
> =A0 =A0 =A0 =A0})
> }
>
> Device(Dev1)
> {
> =A0 =A0 =A0 =A0Name (_PR0, Package (0x01)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0P0PR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0P1PR
> =A0 =A0 =A0 =A0}
> }
>
> Assume Dev0 and Dev1 were runtime suspended.
> Then Dev0 is resumed first and it goes into D0 state.
> But Dev1 is left in D0_Uninitialised state.
>
> This is wrong. In this case, Dev1 must be resumed too.
>
> In order to hand this case, each power resource maintains a list of
> devices which relies on it.
>
> When power resource is ON, it will check if the devices on its list
> can be resumed. The device can only be resumed when all the power
> resouces of its _PR0 are ON.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Hi Rafael,

This version addressed your comment at:
https://lkml.org/lkml/2012/2/13/355

Now we support all combinations of device/power resource.

Do you like it?

Thanks,
Lin Ming

> ---
> =A0drivers/acpi/power.c =A0 =A0| =A0162 +++++++++++++++++++++++++++++=
++++++++++++++++++
> =A0include/acpi/acpi_bus.h | =A0 =A02 +
> =A02 files changed, 164 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 0d681fb..7049a7d 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -40,9 +40,11 @@
> =A0#include <linux/init.h>
> =A0#include <linux/types.h>
> =A0#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> =A0#include <acpi/acpi_bus.h>
> =A0#include <acpi/acpi_drivers.h>
> =A0#include "sleep.h"
> +#include "internal.h"
>
> =A0#define PREFIX "ACPI: "
>
> @@ -77,6 +79,20 @@ static struct acpi_driver acpi_power_driver =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0},
> =A0};
>
> +/*
> + * A power managed device
> + * A device may rely on multiple power resources.
> + * */
> +struct acpi_power_managed_device {
> + =A0 =A0 =A0 struct device *dev; /* The physical device */
> + =A0 =A0 =A0 acpi_handle *handle;
> +};
> +
> +struct acpi_power_resource_device {
> + =A0 =A0 =A0 struct acpi_power_managed_device *device;
> + =A0 =A0 =A0 struct acpi_power_resource_device *next;
> +};
> +
> =A0struct acpi_power_resource {
> =A0 =A0 =A0 =A0struct acpi_device * device;
> =A0 =A0 =A0 =A0acpi_bus_id name;
> @@ -84,6 +100,9 @@ struct acpi_power_resource {
> =A0 =A0 =A0 =A0u32 order;
> =A0 =A0 =A0 =A0unsigned int ref_count;
> =A0 =A0 =A0 =A0struct mutex resource_lock;
> +
> + =A0 =A0 =A0 /* List of devices relying on this power resource */
> + =A0 =A0 =A0 struct acpi_power_resource_device *devices;
> =A0};
>
> =A0static struct list_head acpi_power_resource_list;
> @@ -183,8 +202,26 @@ static int acpi_power_get_list_state(struct acpi=
_handle_list *list, int *state)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/* Resume the device when all power resources in _PR0 are on */
> +static void acpi_power_on_device(struct acpi_power_managed_device *d=
evice)
> +{
> + =A0 =A0 =A0 struct acpi_device *acpi_dev;
> + =A0 =A0 =A0 acpi_handle handle =3D device->handle;
> + =A0 =A0 =A0 int state;
> +
> + =A0 =A0 =A0 if (acpi_bus_get_device(handle, &acpi_dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 if(acpi_power_get_inferred_state(acpi_dev, &state))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 if (state =3D=3D ACPI_STATE_D0 && pm_runtime_suspended(=
device->dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_request_resume(device->dev);
> +}
> +
> =A0static int __acpi_power_on(struct acpi_power_resource *resource)
> =A0{
> + =A0 =A0 =A0 struct acpi_power_resource_device *device_list =3D reso=
urce->devices;
> =A0 =A0 =A0 =A0acpi_status status =3D AE_OK;
>
> =A0 =A0 =A0 =A0status =3D acpi_evaluate_object(resource->device->hand=
le, "_ON", NULL, NULL);
> @@ -197,6 +234,12 @@ static int __acpi_power_on(struct acpi_power_res=
ource *resource)
> =A0 =A0 =A0 =A0ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] t=
urned on\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0resource->name));
>
> + =A0 =A0 =A0 while (device_list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_power_on_device(device_list->devic=
e);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 device_list =3D device_list->next;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -299,6 +342,125 @@ static int acpi_power_on_list(struct acpi_handl=
e_list *list)
> =A0 =A0 =A0 =A0return result;
> =A0}
>
> +static void __acpi_power_resource_unregister_device(struct device *d=
ev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_handle res_handle)
> +{
> + =A0 =A0 =A0 struct acpi_power_resource *resource =3D NULL;
> + =A0 =A0 =A0 struct acpi_power_resource_device *prev, *curr;
> +
> + =A0 =A0 =A0 if (acpi_power_get_context(res_handle, &resource))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 mutex_lock(&resource->resource_lock);
> + =A0 =A0 =A0 prev =3D NULL;
> + =A0 =A0 =A0 curr =3D resource->devices;
> + =A0 =A0 =A0 while (curr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (curr->device->dev =3D=3D dev) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!prev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resourc=
e->devices =3D curr->next;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prev->n=
ext =3D curr->next;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(curr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 prev =3D curr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 curr =3D curr->next;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mutex_unlock(&resource->resource_lock);
> +}
> +
> +/* Unlink dev from all power resources in _PR0 */
> +void acpi_power_resource_unregister_device(struct device *dev, acpi_=
handle handle)
> +{
> + =A0 =A0 =A0 struct acpi_device *acpi_dev;
> + =A0 =A0 =A0 struct acpi_handle_list *list;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 if (!dev || !handle)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 if (acpi_bus_get_device(handle, &acpi_dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 list =3D &acpi_dev->power.states[ACPI_STATE_D0].resourc=
es;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < list->count; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __acpi_power_resource_unregister_device=
(dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list->handles[i]);
> +}
> +
> +static int __acpi_power_resource_register_device(
> + =A0 =A0 =A0 struct acpi_power_managed_device *powered_device, acpi_=
handle handle)
> +{
> + =A0 =A0 =A0 struct acpi_power_resource *resource =3D NULL;
> + =A0 =A0 =A0 struct acpi_power_resource_device *power_resource_devic=
e;
> + =A0 =A0 =A0 int result;
> +
> + =A0 =A0 =A0 result =3D acpi_power_get_context(handle, &resource);
> + =A0 =A0 =A0 if (result)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return result;
> +
> + =A0 =A0 =A0 power_resource_device =3D kzalloc(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(*power_resource_device), GFP_KER=
NEL);
> + =A0 =A0 =A0 if (!power_resource_device)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 power_resource_device->device =3D powered_device;
> +
> + =A0 =A0 =A0 mutex_lock(&resource->resource_lock);
> + =A0 =A0 =A0 power_resource_device->next =3D resource->devices;
> + =A0 =A0 =A0 resource->devices =3D power_resource_device;
> + =A0 =A0 =A0 mutex_unlock(&resource->resource_lock);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* Link dev to all power resources in _PR0 */
> +int acpi_power_resource_register_device(struct device *dev, acpi_han=
dle handle)
> +{
> + =A0 =A0 =A0 struct acpi_device *acpi_dev;
> + =A0 =A0 =A0 struct acpi_handle_list *list;
> + =A0 =A0 =A0 struct acpi_power_managed_device *powered_device;
> + =A0 =A0 =A0 int i, ret;
> +
> + =A0 =A0 =A0 if (!dev || !handle)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> +
> + =A0 =A0 =A0 ret =3D acpi_bus_get_device(handle, &acpi_dev);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no_power_resource;
> +
> + =A0 =A0 =A0 if (!acpi_dev->power.flags.power_resources)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no_power_resource;
> +
> + =A0 =A0 =A0 powered_device =3D kzalloc(sizeof(*powered_device), GFP=
_KERNEL);
> + =A0 =A0 =A0 if (!powered_device)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 powered_device->dev =3D dev;
> + =A0 =A0 =A0 powered_device->handle =3D handle;
> +
> + =A0 =A0 =A0 list =3D &acpi_dev->power.states[ACPI_STATE_D0].resourc=
es;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < list->count; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __acpi_power_resource_register_=
device(powered_device,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list->handles[i]);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_power_resource_unr=
egister_device(dev, handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return ret;
> +
> +no_power_resource:
> + =A0 =A0 =A0 printk(KERN_WARNING PREFIX "Invalid Power Resource to r=
egister!");
> + =A0 =A0 =A0 return -ENODEV;
> +}
> +
> =A0/**
> =A0* acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (de=
precated in
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ACPI 3.0) _PS=
W (Power State Wake)
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 6cd5b64..e168fff 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -323,6 +323,8 @@ int acpi_bus_set_power(acpi_handle handle, int st=
ate);
> =A0int acpi_bus_update_power(acpi_handle handle, int *state_p);
> =A0bool acpi_bus_power_manageable(acpi_handle handle);
> =A0bool acpi_bus_can_wakeup(acpi_handle handle);
> +int acpi_power_resource_register_device(struct device *dev, acpi_han=
dle handle);
> +void acpi_power_resource_unregister_device(struct device *dev, acpi_=
handle handle);
> =A0#ifdef CONFIG_ACPI_PROC_EVENT
> =A0int acpi_bus_generate_proc_event(struct acpi_device *device, u8 ty=
pe, int data);
> =A0int acpi_bus_generate_proc_event4(const char *class, const char *b=
id, u8 type, int data);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
