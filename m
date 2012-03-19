From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v2 5/8] libata-acpi: add ata port runtime D3Cold
 support
Date: Mon, 19 Mar 2012 13:27:00 +0800
Message-ID: <1332134820.17875.17.camel@minggr>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	 <1330592577-16546-6-git-send-email-ming.m.lin@intel.com>
	 <20120319033616.GA32695@localhost.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120319033616.GA32695@localhost.amd.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-03-19 at 11:36 +0800, Aaron Lu wrote:
> Hi,
> 
> On Thu, Mar 01, 2012 at 05:02:54PM +0800, Lin Ming wrote:
> > ATA port may support runtime D3Cold state, for example, Zero-power ODD case.
> > This patch adds wakeup notifier and enable/disable run_wake during
> > supend/resume.
> 
> I've been thinking this for some time and realized that it would be
> impossible for AMD's platform to work with this patch, the reason:
> There is no _PRW in AMD's acpi implementation. And no _PRW would mean
> the device is not wake up capable in current Linux ACPI implementation.
> 
> I've checked the ACPI spec and it said: 'the _PRW is only required for
> devices that have the ability to wake the system from a system sleeping
> state.'
> So I'm not sure if _PRW fits here, since the most common use case for
> zpodd would be: odd put to D3 cold and system is at S0, and odd is back
> to D0 when necessary without affecting the system sleep state.
> 
> I suggest we install the acpi pm notifier on the handle based on the
> following two criteria:
> 1 This ata device is DA capable;
> 2 Its acpi device indicates it is able to wake up itself in S0(_S0W
> evaluates 4).

OK, reasonable to me.

> 
> Does this make sense and will this work for your platform?

Yes.

> 
> Another problem is how to place this ODD device into D3 cold state,
> since our platform uses _PS3 control method to power off it. Do you have
> any suggestions?

acpi_bus_set_power will execute _PS3 too.

So I think no problem for AMD's platform.

Thanks,
Lin Ming

> 
> Thanks,
> Aaron
> 
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/ata/libata-acpi.c |   82 +++++++++++++++++++++++++++++++++++++++++---
> >  drivers/ata/libata-scsi.c |    6 ++--
> >  drivers/ata/libata.h      |    8 ++--
> >  3 files changed, 83 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index 104c1d0..c2a4db6 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/libata.h>
> >  #include <linux/pci.h>
> >  #include <linux/slab.h>
> > +#include <linux/pm_runtime.h>
> >  #include <scsi/scsi_device.h>
> >  #include "libata.h"
> >  
> > @@ -852,10 +853,23 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
> >  
> >  	ata_for_each_dev(dev, &ap->link, ENABLED) {
> >  		handle = ata_dev_acpi_handle(dev);
> > -		if (handle)
> > -			acpi_bus_set_power(handle,
> > -				state.event == PM_EVENT_ON ?
> > -					ACPI_STATE_D0 : ACPI_STATE_D3);
> > +		if (!handle)
> > +			continue;
> > +
> > +		if (state.event != PM_EVENT_ON) {
> > +			acpi_state = acpi_pm_device_sleep_state(
> > +				&dev->sdev->sdev_gendev, NULL);
> > +			if (acpi_state > 0)
> > +				acpi_bus_set_power(handle, acpi_state);
> > +			if (ap->tdev.power.request == RPM_REQ_SUSPEND)
> > +				acpi_pm_device_run_wake(
> > +					&dev->sdev->sdev_gendev, true);
> > +		} else {
> > +			if (ap->tdev.power.request == RPM_REQ_RESUME)
> > +				acpi_pm_device_run_wake(
> > +					&dev->sdev->sdev_gendev, false);
> > +			acpi_bus_set_power(handle, ACPI_STATE_D0);
> > +		}
> >  	}
> >  
> >  	handle = ata_ap_acpi_handle(ap);
> > @@ -955,7 +969,7 @@ void ata_acpi_on_disable(struct ata_device *dev)
> >  	ata_acpi_clear_gtf(dev);
> >  }
> >  
> > -void ata_acpi_bind_dock(struct ata_device *dev)
> > +static void ata_acpi_bind_dock(struct ata_device *dev)
> >  {
> >  	struct device **docks;
> >  
> > @@ -965,7 +979,7 @@ void ata_acpi_bind_dock(struct ata_device *dev)
> >  	kfree(docks);
> >  }
> >  
> > -void ata_acpi_unbind_dock(struct ata_device *dev)
> > +static void ata_acpi_unbind_dock(struct ata_device *dev)
> >  {
> >  	struct device **docks;
> >  
> > @@ -975,6 +989,62 @@ void ata_acpi_unbind_dock(struct ata_device *dev)
> >  	kfree(docks);
> >  }
> >  
> > +static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> > +{
> > +	struct ata_device *ata_dev = context;
> > +
> > +	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev)
> > +		scsi_autopm_get_device(ata_dev->sdev);
> > +}
> > +
> > +static void ata_acpi_add_pm_notifier(struct ata_device *dev)
> > +{
> > +	struct acpi_device *acpi_dev;
> > +	acpi_handle handle;
> > +	acpi_status status;
> > +
> > +	handle = ata_dev_acpi_handle(dev);
> > +	if (!handle)
> > +		return;
> > +
> > +	status = acpi_bus_get_device(handle, &acpi_dev);
> > +	if (ACPI_SUCCESS(status) && acpi_dev->wakeup.flags.run_wake) {
> > +		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> > +			ata_acpi_wake_dev, dev);
> > +		device_set_run_wake(&dev->sdev->sdev_gendev, true);
> > +	}
> > +}
> > +
> > +static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
> > +{
> > +	struct acpi_device *acpi_dev;
> > +	acpi_handle handle;
> > +	acpi_status status;
> > +
> > +	handle = ata_dev_acpi_handle(dev);
> > +	if (!handle)
> > +		return;
> > +
> > +	status = acpi_bus_get_device(handle, &acpi_dev);
> > +	if (ACPI_SUCCESS(status) && acpi_dev->wakeup.flags.run_wake) {
> > +		device_set_run_wake(&dev->sdev->sdev_gendev, false);
> > +		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> > +			ata_acpi_wake_dev);
> > +	}
> > +}
> > +
> > +void ata_acpi_bind(struct ata_device *dev)
> > +{
> > +	ata_acpi_bind_dock(dev);
> > +	ata_acpi_add_pm_notifier(dev);
> > +}
> > +
> > +void ata_acpi_unbind(struct ata_device *dev)
> > +{
> > +	ata_acpi_unbind_dock(dev);
> > +	ata_acpi_remove_pm_notifier(dev);
> > +}
> > +
> >  static int is_pci_ata(struct device *dev)
> >  {
> >  	struct pci_dev *pdev;
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index f08c447..231c3ec 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -3444,7 +3444,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
> >  			if (!IS_ERR(sdev)) {
> >  				dev->sdev = sdev;
> >  				scsi_device_put(sdev);
> > -				ata_acpi_bind_dock(dev);
> > +				ata_acpi_bind(dev);
> >  			} else {
> >  				dev->sdev = NULL;
> >  			}
> > @@ -3541,12 +3541,12 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
> >  	mutex_lock(&ap->scsi_host->scan_mutex);
> >  	spin_lock_irqsave(ap->lock, flags);
> >  
> > +	ata_acpi_unbind(dev);
> > +
> >  	/* clearing dev->sdev is protected by host lock */
> >  	sdev = dev->sdev;
> >  	dev->sdev = NULL;
> >  
> > -	ata_acpi_unbind_dock(dev);
> > -
> >  	if (sdev) {
> >  		/* If user initiated unplug races with us, sdev can go
> >  		 * away underneath us after the host lock and
> > diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> > index e61ba10..2ec7c38 100644
> > --- a/drivers/ata/libata.h
> > +++ b/drivers/ata/libata.h
> > @@ -117,8 +117,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
> >  extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
> >  extern int ata_acpi_register(void);
> >  extern void ata_acpi_unregister(void);
> > -extern void ata_acpi_bind_dock(struct ata_device *dev);
> > -extern void ata_acpi_unbind_dock(struct ata_device *dev);
> > +extern void ata_acpi_bind(struct ata_device *dev);
> > +extern void ata_acpi_unbind(struct ata_device *dev);
> >  #else
> >  static inline void ata_acpi_dissociate(struct ata_host *host) { }
> >  static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
> > @@ -129,8 +129,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
> >  				      pm_message_t state) { }
> >  static inline int ata_acpi_register(void) { return 0; }
> >  static void ata_acpi_unregister(void) { }
> > -static void ata_acpi_bind_dock(struct ata_device *dev) { }
> > -static void ata_acpi_unbind_dock(struct ata_device *dev) { }
> > +static void ata_acpi_bind(struct ata_device *dev) { }
> > +static void ata_acpi_unbind(struct ata_device *dev) { }
> >  #endif
> >  
> >  /* libata-scsi.c */
> > -- 
> > 1.7.2.5
> > 
> > 
> 


