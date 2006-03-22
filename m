From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 04/15] libata: ata_scsi_queuecmd cleanup
Date: Tue, 21 Mar 2006 20:51:44 -0500
Message-ID: <4420ADB0.10904@pobox.com>
References: <200603172304.k2HN4LDp014215@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200603172304.k2HN4LDp014215@d03av03.boulder.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Encapsulate part of ata_scsi_queuecmd so that it can be
> reused by future SAS patches.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  libata-dev-bjking1/drivers/scsi/libata-scsi.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff -puN drivers/scsi/libata-scsi.c~libata_scsi_queuecmd drivers/scsi/libata-scsi.c
> --- libata-dev/drivers/scsi/libata-scsi.c~libata_scsi_queuecmd	2006-03-14 13:55:38.000000000 -0600
> +++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-03-14 13:55:38.000000000 -0600
> @@ -2565,6 +2565,21 @@ static inline void ata_scsi_dump_cdb(str
>  #endif
>  }
>  
> +static void __ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),

static inline, please


> +				struct ata_port *ap, struct ata_device *dev)
> +{
> +	if (dev->class == ATA_DEV_ATA) {
> +		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
> +							      cmd->cmnd[0]);
> +
> +		if (xlat_func)
> +			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
> +		else
> +			ata_scsi_simulate(ap, dev, cmd, done);
> +	} else
> +		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
> +}
> +
>  /**
>   *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
>   *	@cmd: SCSI command to be sent
> @@ -2605,16 +2620,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
>  		goto out_unlock;
>  	}
>  
> -	if (dev->class == ATA_DEV_ATA) {
> -		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
> -							      cmd->cmnd[0]);
> -
> -		if (xlat_func)
> -			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
> -		else
> -			ata_scsi_simulate(ap, dev, cmd, done);
> -	} else
> -		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
> +	__ata_scsi_queuecmd(cmd, done, ap, dev);

might as well kill the out_unlock goto target, and do something like

	if (likely(dev))
		__ata_scsi_queuecmd()
	else
		BAD TARGET

