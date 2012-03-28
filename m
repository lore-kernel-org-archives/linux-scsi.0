From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Wed, 28 Mar 2012 10:33:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34383 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753679Ab2C1Od0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2012 10:33:26 -0400
In-Reply-To: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>

On Wed, 28 Mar 2012, Lin Ming wrote:

> ZPODD(Zero Power Optical Disk Drive) is a new feature in
> SATA 3.1 specification. It provides a way to power off unused ODD.
> 
> ZPODD support is checked in in sr_probe().
> can_power_off flag is set during suspend if ZPODD is supported.
> 
> ATA port's runtime suspend callback will actually power off the ODD
> and its runtime resume callback will actually power on the ODD.
> 
> When ODD is powered off(D3Cold state), inserting disk will trigger a
> wakeup event(GPE). GPE AML handler notifies the associated device. Then
> ODD is resumed in the notify handler.

> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c

> @@ -80,12 +82,38 @@ static int sr_probe(struct device *);
>  static int sr_remove(struct device *);
>  static int sr_done(struct scsi_cmnd *);
>  
> +static int sr_suspend(struct device *dev, pm_message_t mesg)
> +{
> +	struct scsi_cd *cd;
> +
> +	cd = dev_get_drvdata(dev);
> +	if (cd->device->power_off)
> +		dev->power.subsys_data->can_power_off = true;
> +
> +	return 0;
> +}
> +
> +static int sr_resume(struct device *dev)
> +{
> +	struct scsi_cd *cd;
> +
> +	cd = dev_get_drvdata(dev);
> +	if (cd->device->power_off) {
> +		dev->power.subsys_data->can_power_off = false;
> +		cd->poweroff_event = 0;
> +	}
> +
> +	return 0;
> +}

Calling this flag "can_power_off" makes these routines look very 
strange.  Either the device can power off or it can't, i.e., either it 
supports ZPODD or it doesn't.  This doesn't change over time.

If you rename the flag "may_power_off" then its meaning will be more 
clear.

> @@ -216,6 +244,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
>  	unsigned int events;
>  	int ret;
>  
> +	/* Not necessary to check events if enter ZPODD state */
> +	if (cd->device->power_off &&
> +			pm_runtime_suspended(&cd->device->sdev_gendev))
> +		return 0;

The comment is wrong and the new code does the wrong thing.  You _do_
have to check for events even in the ZPODD state, which means
sr_check_events must power-up the device if necessary.  
sd_check_events in James Bottomley's scsi-misc tree now does the right
thing; see commit 4e2247b2bd289f079349d6c69755f8cff4e31f2b.

> +
>  	/* no changer support */
>  	if (CDSL_CURRENT != slot)
>  		return 0;
> @@ -260,6 +293,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
>  	cd->media_present = scsi_status_is_good(ret) ||
>  		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
>  
> +	if (!cd->media_present && cd->device->power_off && !cd->poweroff_event) {
> +		scsi_autopm_put_device(cd->device);

You can see your mistake here.  You call scsi_autopm_put_device here
without calling scsi_autopm_get_device earlier.

Alan Stern

