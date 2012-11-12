From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 12 Nov 2012 11:13:03 -0800
Message-ID: <20121112191303.GE5560@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-7-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352443922-13734-7-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Nov 09, 2012 at 02:51:58PM +0800, Aaron Lu wrote:
> @@ -784,7 +784,13 @@ static int ata_acpi_push_id(struct ata_device *dev)
>   */
>  int ata_acpi_on_suspend(struct ata_port *ap)
>  {
> -	/* nada */
> +	struct ata_device *dev;
> +
> +	ata_for_each_dev(dev, &ap->link, ENABLED) {
> +		if (zpodd_dev_enabled(dev))
> +			zpodd_check_zpready(dev);
> +	}
> +

Why is it running off ata_acpi_on_suspend() instead of hooking
directly into EH suspend routine?

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index e3bda07..6f235b9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2665,6 +2665,10 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
>  			ata_scsi_rbuf_put(cmd, true, &flags);
>  		}
>  
> +		if (zpodd_dev_enabled(qc->dev) &&
> +				scsicmd[0] == GET_EVENT_STATUS_NOTIFICATION)
> +			zpodd_snoop_status(qc->dev, cmd);
> +

Brief comment explaining what's going on here wouldn't hurt.

> +#define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
> +
>  struct zpodd {
>  	bool slot:1;
>  	bool drawer:1;
>  	bool from_notify:1;	/* resumed as a result of acpi notification */
> +	bool status_ready:1;	/* ready status derived from media event poll,
> +				   it is not accurate, but serves as a hint */
> +	bool zp_ready:1;	/* zero power ready state */
> +
> +	unsigned long last_ready; /* last zero power ready timestamp */
>  
>  	struct ata_device *dev;
>  };

How are accesses to the bit fields synchronized?

> +/*
> + * Snoop the result of GET_STATUS_NOTIFICATION_EVENT, the media
> + * status byte has information on media present/door closed.
> + *
> + * This information serves only as a hint, as it is not accurate.
> + * The sense code method will be used when deciding if the ODD is
> + * really zero power ready.
> + */

It would be great if you can make the above a proper dockbook function
comment.  Also, as the snooping for hint thing isn't too obvious it
would be great if the comment contains more info which is explained in
the commit message.

> +void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd)
> +{
> +	bool ready;
> +	char buf[8];
> +	struct event_header *eh = (void *)buf;
> +	struct media_event_desc *med = (void *)(buf + 4);
> +	struct sg_table *table = &scmd->sdb.table;
> +	struct zpodd *zpodd = dev->private_data;

Don't people usually put variables definitions w/ assignments above
the ones without?

> +/*
> + * Check ODD's zero power ready status.
> + *
> + * This function is called during ATA port's suspend path,
> + * when the port is not frozen yet, so that we can still make
> + * some IO to the ODD to decide if it is zero power ready.
> + *
> + * The ODD is regarded as zero power ready when it is in zero
> + * power ready state for some time(defined by POWEROFF_DELAY).
> + */
> +void zpodd_check_zpready(struct ata_device *dev)
> +{
> +	bool zp_ready;
> +	unsigned long expires;
> +	struct zpodd *zpodd = dev->private_data;
> +
> +	if (!zpodd->status_ready) {
> +		zpodd->last_ready = 0;
> +		return;
> +	}
> +
> +	if (!zpodd->last_ready) {
> +		zp_ready = zpready(dev);
> +		if (zp_ready)
> +			zpodd->last_ready = jiffies;
> +		return;
> +	}
> +
> +	expires = zpodd->last_ready + msecs_to_jiffies(POWEROFF_DELAY);
> +	if (time_before(jiffies, expires))
> +		return;
> +
> +	zpodd->zp_ready = zpready(dev);
> +	if (!zpodd->zp_ready)
> +		zpodd->last_ready = 0;
> +}

Hmmm... so, the "full" check only happens when autopm kicks in, right?
Is it really worth avoiding an extra TUR on autopm events?  That's not
really a hot path.  It seems a bit over-engineered to me.

Thanks.

-- 
tejun
