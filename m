From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [RFC PATCH v2 8/8] [SCSI] sr: check and enable Zero-power ODD
 support
Date: Mon, 12 Mar 2012 12:53:53 +0800
Message-ID: <20120312045353.GA2798@localhost.amd.com>
References: <Pine.LNX.4.44L0.1203011059230.9392-100000@netrider.rowland.org>
 <1330671765.3412.7.camel@minggr>
 <CAOzJMDRTbq5o+jCyTtaAW_RPysfY3LhQ9gFC-tsvM8bsnh=rxQ@mail.gmail.com>
 <1330743921.6369.2.camel@hp6530s>
 <1331520598.3436.10.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1331520598.3436.10.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 12, 2012 at 10:49:58AM +0800, Lin Ming wrote:
> 
> Would you like the draft incremental patch below?
> I have not tested it yet.

Yes, this patch looks good to me, feel free to add my acked-by next time
you post it, thanks.

-Aaron

> 
> ---
>  drivers/ata/libata-core.c  |    3 +++
>  drivers/ata/libata-scsi.c  |    2 ++
>  drivers/scsi/sr.c          |   16 +++++++---------
>  drivers/scsi/sr.h          |    1 -
>  include/linux/ata.h        |    1 +
>  include/linux/libata.h     |    2 ++
>  include/scsi/scsi_device.h |    1 +
>  7 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 6742cc4..2a10701 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2368,6 +2368,9 @@ int ata_dev_configure(struct ata_device *dev)
>  			dma_dir_string = ", DMADIR";
>  		}
>  
> +		if (atapi_id_has_da(dev->id))
> +			dev->flags |= ATA_DFLAG_DA;
> +
>  		/* print device info to dmesg */
>  		if (ata_msg_drv(ap) && print_info)
>  			ata_dev_info(dev,
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 231c3ec..0bfbe41 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3445,6 +3445,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  				dev->sdev = sdev;
>  				scsi_device_put(sdev);
>  				ata_acpi_bind(dev);
> +				if (dev->flags & ATA_DFLAG_DA)
> +					sdev->power_off = 1;
>  			} else {
>  				dev->sdev = NULL;
>  			}
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 7cd0489..0a75613 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -87,7 +87,7 @@ static int sr_suspend(struct device *dev, pm_message_t mesg)
>  	struct scsi_cd *cd;
>  
>  	cd = dev_get_drvdata(dev);
> -	if (cd->zpodd)
> +	if (cd->device->power_off)
>  		dev->power.subsys_data->can_power_off = true;
>  
>  	return 0;
> @@ -98,7 +98,7 @@ static int sr_resume(struct device *dev)
>  	struct scsi_cd *cd;
>  
>  	cd = dev_get_drvdata(dev);
> -	if (cd->zpodd) {
> +	if (cd->device->power_off) {
>  		dev->power.subsys_data->can_power_off = false;
>  		cd->zpodd_event = 0;
>  	}
> @@ -245,7 +245,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
>  	int ret;
>  
>  	/* Not necessary to check events if enter ZPODD state */
> -	if (cd->zpodd && pm_runtime_suspended(&cd->device->sdev_gendev))
> +	if (cd->device->power_off &&
> +			pm_runtime_suspended(&cd->device->sdev_gendev))
>  		return 0;
>  
>  	/* no changer support */
> @@ -292,7 +293,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
>  	cd->media_present = scsi_status_is_good(ret) ||
>  		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
>  
> -	if (!cd->media_present && cd->zpodd && !cd->zpodd_event) {
> +	if (!cd->media_present && cd->device->power_off && !cd->zpodd_event) {
>  		scsi_autopm_put_device(cd->device);
>  		cd->zpodd_event = 1;
>  	}
> @@ -753,11 +754,8 @@ static int sr_probe(struct device *dev)
>  	disk->flags |= GENHD_FL_REMOVABLE;
>  	add_disk(disk);
>  
> -	/* TODO: add device attention bit check for ZPODD */
> -	if (device_run_wake(dev)) {
> -		cd->zpodd = 1;
> +	if (sdev->power_off)
>  		dev_pm_get_subsys_data(dev);
> -	}
>  
>  	sdev_printk(KERN_DEBUG, sdev,
>  		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
> @@ -1015,7 +1013,7 @@ static int sr_remove(struct device *dev)
>  	kref_put(&cd->kref, sr_kref_release);
>  	mutex_unlock(&sr_ref_mutex);
>  
> -	if (cd->zpodd)
> +	if (cd->device->power_off)
>  		dev_pm_put_subsys_data(dev);
>  
>  	return 0;
> diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> index 39b3d8c..e81da64 100644
> --- a/drivers/scsi/sr.h
> +++ b/drivers/scsi/sr.h
> @@ -42,7 +42,6 @@ typedef struct scsi_cd {
>  	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
>  	unsigned media_present:1;	/* media is present */
>  
> -	unsigned zpodd:1;	/* is ZPODD supported */
>  	unsigned zpodd_event:1;
>  
>  	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 32df2b6..6ee41cc 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
>  	  ((u64) (id)[(n) + 0]) )
>  
>  #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
> +#define atapi_id_has_da(id)	((id)[77] & (1 << 4))
>  
>  static inline bool ata_id_has_hipm(const u16 *id)
>  {
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 36970c6..3085bdc 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -161,6 +161,8 @@ enum {
>  	ATA_DFLAG_DETACH	= (1 << 24),
>  	ATA_DFLAG_DETACHED	= (1 << 25),
>  
> +	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
> +
>  	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
>  	ATA_DEV_ATA		= 1,	/* ATA device */
>  	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 8b6c247..4805d5a 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -151,6 +151,7 @@ struct scsi_device {
>  	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
> +	unsigned power_off:1; /* Device supports runtime power off */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>  	struct list_head event_list;	/* asserted events */
> 
> 
> 
> 

