From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 6/9] libata: handle power transition of ODD
Date: Mon, 7 Jan 2013 10:42:45 -0800
Message-ID: <20130107184245.GS3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
 <1357440509-28108-7-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357440509-28108-7-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 06, 2013 at 10:48:26AM +0800, Aaron Lu wrote:
> +bool zpodd_zpready(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +	return zpodd->zp_ready;
> +}
> +
> +void zpodd_pre_poweroff(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +
> +	zpodd->powered_off = true;
> +	device_set_run_wake(&dev->sdev->sdev_gendev, true);
> +	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
> +}
> +
> +void zpodd_pre_poweron(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +
> +	if (zpodd->powered_off) {
> +		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
> +		device_set_run_wake(&dev->sdev->sdev_gendev, false);
> +	}
> +}
> +
> +void zpodd_post_resume(struct ata_device *dev)
> +{
> +	struct zpodd *zpodd = dev->zpodd;
> +
> +	if (!zpodd->powered_off)
> +		return;
> +
> +	zpodd->powered_off = false;
> +
> +	if (zpodd->from_notify) {
> +		zpodd->from_notify = false;
> +		if (zpodd->drawer)
> +			eject_tray(dev);
> +	}
> +
> +	zpodd->last_ready = 0;
> +	zpodd->zp_ready = false;
> +}

I would really appreciate some comments at least on functions visible
outside zpodd.c.  Please add proper function comments explaining what
they're doing to achieve what.

Thanks.

-- 
tejun
