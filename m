Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C4438AC79;
	Mon, 23 Mar 2026 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260630; cv=none; b=A38gYXsg+Q0rsD3789klkZrh5vbjRMzxxFi6skcvLC6t8B0OlRFYQF7H7xX4J87STA2k6RvbZuqzf6KYywACQdE8GVeidodHiafElSd9vuNa2FQqMjIrxNp9J2Nq6cJ0RBAdwJjS26BMEurYMY/JK6v/lJvUzUWKv61mhQUq0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260630; c=relaxed/simple;
	bh=nKARx96LL90HGJciwaB/J+Mf9CdmUGOJzDBKGLoVhS8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=GvPkvC/1Cm3RytioBoh0/0RwWlwStIHRu7HvrCy1RdUyyySN/EG262+0zG9a0d1yLeI1QcxZznXu1bhuhPoLZ/73fzgEN1JlfksO5oMmuq/jc8+gZzXKb3Ol43AdC+FDrSO8gbM2rHI4ZnNJVt/iRJNrrWqwYIasi5ICJA7TasQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 52cee889 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 23 Mar 2026 10:43:44 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Mar 2026 10:43:44 +0100
Message-Id: <DHA2BZE56U6E.3V6HEWOPLHAXX@arkamax.eu>
Cc: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <tatashin@google.com>, =?utf-8?q?Micha=C5=82_C=C5=82api=C5=84ski?=
 <mclapinski@google.com>, "Jordan Richards" <jordanrichards@google.com>,
 "Ewan Milne" <emilne@redhat.com>, "John Meneghini" <jmeneghi@redhat.com>,
 "Lombardi, Maurizio" <mlombard@redhat.com>, "Stuart Hayes"
 <stuart.w.hayes@gmail.com>, "Laurence Oberman" <loberman@redhat.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "Bjorn Helgaas" <helgaas@kernel.org>
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "David Jeffery" <djeffery@redhat.com>, <linux-kernel@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <linux-pci@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Danilo Krummrich" <dakr@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260319141142.5781-1-djeffery@redhat.com>
 <20260319141142.5781-4-djeffery@redhat.com>
In-Reply-To: <20260319141142.5781-4-djeffery@redhat.com>

On Thu Mar 19, 2026 at 3:11 PM CET, David Jeffery wrote:
> Patterned after async suspend, allow devices to mark themselves as wantin=
g
> to perform async shutdown. Devices using async shutdown wait only for the=
ir
> dependencies to shutdown before executing their shutdown routine.
>
> Sync shutdown devices are shut down one at a time and will only wait for =
an
> async shutdown device if the async device is a dependency.
>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/base/base.h    |   2 +
>  drivers/base/core.c    | 104 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/device.h |  13 ++++++
>  3 files changed, 118 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index 79d031d2d845..ea2a039e7907 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -113,6 +113,7 @@ struct driver_type {
>   * @device - pointer back to the struct device that this structure is
>   * associated with.
>   * @driver_type - The type of the bound Rust driver.
> + * @complete - completion for device shutdown ordering
>   * @dead - This device is currently either in the process of or has been
>   *	removed from the system. Any asynchronous events scheduled for this
>   *	device should exit without taking any action.
> @@ -132,6 +133,7 @@ struct device_private {
>  #ifdef CONFIG_RUST
>  	struct driver_type driver_type;
>  #endif
> +	struct completion complete;
>  	u8 dead:1;
>  };
>  #define to_device_private_parent(obj)	\
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 2e9094f5c5aa..53568b820a13 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -9,6 +9,7 @@
>   */
> =20
>  #include <linux/acpi.h>
> +#include <linux/async.h>
>  #include <linux/blkdev.h>
>  #include <linux/cleanup.h>
>  #include <linux/cpufreq.h>
> @@ -37,6 +38,10 @@
>  #include "physical_location.h"
>  #include "power/power.h"
> =20
> +static bool async_shutdown =3D true;
> +module_param(async_shutdown, bool, 0644);
> +MODULE_PARM_DESC(async_shutdown, "Enable asynchronous device shutdown su=
pport");
> +
>  /* Device links support. */
>  static LIST_HEAD(deferred_sync);
>  static unsigned int defer_sync_state_count =3D 1;
> @@ -3538,6 +3543,7 @@ static int device_private_init(struct device *dev)
>  	klist_init(&dev->p->klist_children, klist_children_get,
>  		   klist_children_put);
>  	INIT_LIST_HEAD(&dev->p->deferred_probe);
> +	init_completion(&dev->p->complete);
>  	return 0;
>  }
> =20
> @@ -4782,6 +4788,37 @@ int device_change_owner(struct device *dev, kuid_t=
 kuid, kgid_t kgid)
>  	return error;
>  }
> =20
> +static bool wants_async_shutdown(struct device *dev)
> +{
> +	return async_shutdown && dev->async_shutdown;
> +}
> +
> +static int wait_for_device_shutdown(struct device *dev, void *data)
> +{
> +	bool async =3D *(bool *)data;
> +
> +	if (async || wants_async_shutdown(dev))
> +		wait_for_completion(&dev->p->complete);
> +
> +	return 0;
> +}
> +
> +static void wait_for_shutdown_dependencies(struct device *dev, bool asyn=
c)
> +{
> +	struct device_link *link;
> +	int idx;
> +
> +	device_for_each_child(dev, &async, wait_for_device_shutdown);
> +
> +	idx =3D device_links_read_lock();
> +
> +	dev_for_each_link_to_consumer(link, dev)
> +		if (!device_link_flag_is_sync_state_only(link->flags))
> +			wait_for_device_shutdown(link->consumer, &async);
> +
> +	device_links_read_unlock(idx);
> +}
> +
>  static void __shutdown_one_device(struct device *dev)
>  {
>  	device_lock(dev);
> @@ -4805,6 +4842,8 @@ static void __shutdown_one_device(struct device *de=
v)
>  		dev->driver->shutdown(dev);
>  	}
> =20
> +	complete_all(&dev->p->complete);
> +
>  	device_unlock(dev);
>  }
> =20
> @@ -4823,6 +4862,58 @@ static void shutdown_one_device(struct device *dev=
)
>  	put_device(dev);
>  }
> =20
> +static void async_shutdown_handler(void *data, async_cookie_t cookie)
> +{
> +	struct device *dev =3D data;
> +
> +	wait_for_shutdown_dependencies(dev, true);
> +	shutdown_one_device(dev);
> +}
> +
> +static bool shutdown_device_async(struct device *dev)
> +{
> +	if (async_schedule_dev_nocall(async_shutdown_handler, dev))
> +		return true;
> +	return false;
> +}
> +
> +
> +static void early_async_shutdown_devices(void)
> +{
> +	struct device *dev, *next, *needs_put =3D NULL;
> +
> +	if (!async_shutdown)
> +		return;
> +
> +	spin_lock(&devices_kset->list_lock);
> +
> +	list_for_each_entry_safe_reverse(dev, next, &devices_kset->list,
> +					 kobj.entry) {
> +		if (wants_async_shutdown(dev)) {
> +			get_device(dev->parent);
> +			get_device(dev);
> +
> +			if (shutdown_device_async(dev)) {
> +				list_del_init(&dev->kobj.entry);
> +			} else {
> +				/*
> +				 * async failed, clean up extra references
> +				 * and run from the standard shutdown loop
> +				 */
> +				needs_put =3D dev;
> +				break;
> +			}
> +		}
> +	}
> +
> +	spin_unlock(&devices_kset->list_lock);
> +
> +	if (needs_put) {
> +		put_device(needs_put->parent);
> +		put_device(needs_put);
> +	}
> +}
> +
>  /**
>   * device_shutdown - call ->shutdown() on each device to shutdown.
>   */
> @@ -4835,6 +4926,12 @@ void device_shutdown(void)
> =20
>  	cpufreq_suspend();
> =20
> +	/*
> +	 * Start async device threads where possible to maximize potential
> +	 * parallelism and minimize false dependency on unrelated sync devices
> +	 */
> +	early_async_shutdown_devices();
> +
>  	spin_lock(&devices_kset->list_lock);
>  	/*
>  	 * Walk the devices list backward, shutting down each in turn.
> @@ -4859,11 +4956,16 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> =20
> -		shutdown_one_device(dev);
> +		if (!wants_async_shutdown(dev) || !shutdown_device_async(dev)) {
> +			wait_for_shutdown_dependencies(dev, false);
> +			shutdown_one_device(dev);
> +		}
> =20
>  		spin_lock(&devices_kset->list_lock);
>  	}
>  	spin_unlock(&devices_kset->list_lock);
> +
> +	async_synchronize_full();
>  }
> =20
>  /*
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 0be95294b6e6..da1db7d235c9 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -551,6 +551,8 @@ struct device_physical_location {
>   * @dma_skip_sync: DMA sync operations can be skipped for coherent buffe=
rs.
>   * @dma_iommu: Device is using default IOMMU implementation for DMA and
>   *		doesn't rely on dma_ops structure.
> + * @async_shutdown: Device shutdown may be run asynchronously and in par=
allel
> + *		to the shutdown of unrelated devices
>   *
>   * At the lowest level, every device in a Linux system is represented by=
 an
>   * instance of struct device. The device structure contains the informat=
ion
> @@ -669,6 +671,7 @@ struct device {
>  #ifdef CONFIG_IOMMU_DMA
>  	bool			dma_iommu:1;
>  #endif
> +	bool			async_shutdown:1;
>  };
> =20
>  /**
> @@ -824,6 +827,16 @@ static inline bool device_async_suspend_enabled(stru=
ct device *dev)
>  	return !!dev->power.async_suspend;
>  }
> =20
> +static inline bool device_enable_async_shutdown(struct device *dev)
> +{
> +	return dev->async_shutdown =3D true;
> +}

Shouldn't this function just return void?

Maurizio
