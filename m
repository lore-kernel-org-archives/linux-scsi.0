From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 25 Dec 2012 12:17:23 -0500
Message-ID: <20121225171723.GI10220@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <35648985.61QNrr0Knq@vostro.rjw.lan>
 <1353906191.2523.25.camel@dabdike>
 <21511277.LLinyDpbAK@vostro.rjw.lan>
 <20121128013928.GB15971@htj.dyndns.org>
 <1354092969.2276.49.camel@dabdike>
 <20121203081321.GA9990@mint-spring.sh.intel.com>
 <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com>
 <20121203162323.GB19802@htj.dyndns.org>
 <50D2AB1D.9050602@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50D2AB1D.9050602@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Thu, Dec 20, 2012 at 02:07:25PM +0800, Aaron Lu wrote:
> +static int is_gendisk_part0(struct device *dev, void *data)
> +{
> +	struct device **child = data;
> +
> +	if (dev->class == &block_class && dev->type == &disk_type) {
> +		*child = dev;
> +		return 1;
> +	} else
> +		return 0;
> +}
> +
> +/**
> + * disk_from_device - Get the gendisk pointer for this device.
> + * @dev: the device this gendisk is created for, i.e. gendisk->driverfs_dev
> + *
> + * LLD sometimes need to play with the gendisk without HLD's aware,
> + * this routine gives LLD the required access to gendisk.
> + *
> + * CONTEXT:
> + * Don't care.
> + */
> +struct gendisk *disk_from_device(struct device *dev)
> +{
> +	struct device *child;
> +
> +	if (device_for_each_child(dev, &child, is_gendisk_part0))
> +		return dev_to_disk(child);
> +	else
> +		return NULL;
> +}
> +EXPORT_SYMBOL(disk_from_device);

This is really a round-about way to find out the matching device and
it wouldn't work if the disk device nests deeper.  Doesn't really look
like a good idea to me.

> Then together with disk_try_block_events and disk_unblock_events, we can
> avoid touching SCSI layer to let ODD stay in zero power state.

Also, I'd much prefer something along the line of
block_events_nowait() instead of try_block.

Thanks.

-- 
tejun
