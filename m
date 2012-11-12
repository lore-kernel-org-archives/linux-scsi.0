From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 03/10] ata: zpodd: identify and init ZPODD devices
Date: Mon, 12 Nov 2012 10:53:01 -0800
Message-ID: <20121112185301.GB5560@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-4-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352443922-13734-4-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Nov 09, 2012 at 02:51:55PM +0800, Aaron Lu wrote:
>  void ata_acpi_unbind(struct ata_device *dev)
>  {
> +	if (zpodd_dev_enabled(dev))
> +		zpodd_deinit(dev);

Maybe zpodd_exit() instead?

> +void zpodd_init(struct ata_device *dev)
> +{
> +	int ret;
> +	struct zpodd *zpodd;
> +
> +	if (dev->private_data)
> +		return;
> +
> +	if (!device_can_poweroff(dev))
> +		return;
> +
> +	if ((ret = check_loading_mechanism(dev)) == -ENODEV)
> +		return;
> +
> +	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
> +	if (!zpodd)
> +		return;
> +
> +	if (ret)
> +		zpodd->drawer = true;
> +	else
> +		zpodd->slot = true;
> +
> +	zpodd->dev = dev;
> +	dev->private_data = zpodd;

I don't think you're supposed to use dev->private_data from libata
core layer.  Just add a new field.  Nobody cares about adding 8 more
bytes to struct ata_device and spending 8 more bytes is way better
than muddying the ownership of ->private_data.

> +/* libata-zpodd.c */
> +#ifdef CONFIG_SATA_ZPODD
> +void zpodd_init(struct ata_device *dev);
> +void zpodd_deinit(struct ata_device *dev);
> +static inline bool zpodd_dev_enabled(struct ata_device *dev)
> +{
> +	if (dev->flags & ATA_DFLAG_DA && dev->private_data)
> +		return true;
> +	else
> +		return false;
> +}

And this gets completely wrong.  What if the device supports DA and
low level driver makes use of ->private_data?

Thanks.

-- 
tejun
