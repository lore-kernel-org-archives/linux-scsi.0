From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] libata: Whitelist SSDs that are known to properly
 return zeroes after TRIM
Date: Fri, 05 Dec 2014 17:45:04 +0100
Message-ID: <5481E110.2060309@redhat.com>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com> <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59751 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLEQpK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 11:45:10 -0500
In-Reply-To: <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de



On 07/11/2014 06:08, Martin K. Petersen wrote:
> The whitelist is only meant as a starting point and is by no means
> comprehensive:
> 
>    - All intel SSD models except for 510
>    - Micron M5*
>    - Samsung SSDs
>    - Seagate SSDs
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/ata/libata-core.c | 18 ++++++++++++++----
>  drivers/ata/libata-scsi.c | 10 ++++++----
>  include/linux/libata.h    |  1 +
>  3 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c5ba15af87d3..f41f24a8bc21 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4225,10 +4225,20 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
>  
>  	/* devices that don't properly handle queued TRIM commands */
> -	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
> -	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
> -	{ "Micron_M550*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
> -	{ "Crucial_CT*M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
> +	{ "Micron_M5?0*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
> +						ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +	{ "Crucial_CT???M5?0SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },

I have a Crucial_CT256MX1 (i.e. MX100) and it does reliably zero.

BTW. it's the same hardware as the M550, so probably the same set of
quirks should apply to both.

Paolo

> +
> +	/*
> +	 * DRAT/RZAT are weak guarantees. Explicitly black/whitelist
> +	 * SSDs that provide reliable zero after TRIM.
> +	 */
> +	{ "INTEL*SSDSC2MH*",		NULL,	0, }, /* Blacklist intel 510 */
> +	{ "INTEL*SSD*", 		NULL,	ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +	{ "SSD*INTEL*",			NULL,	ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +	{ "Samsung*SSD*",		NULL,	ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +	{ "SAMSUNG*SSD*",		NULL,	ATA_HORKAGE_ZERO_AFTER_TRIM, },
> +	{ "ST[1248][0248]0[FH]*",	NULL,	ATA_HORKAGE_ZERO_AFTER_TRIM, },
>  
>  	/*
>  	 * Some WD SATA-I drives spin up and down erratically when the link
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0586f66d70fa..deaa6e34ed4d 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2515,13 +2515,15 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
>  		rbuf[15] = lowest_aligned;
>  
>  		if (ata_id_has_trim(args->id)) {
> -			rbuf[14] |= 0x80; /* TPE */
> +			rbuf[14] |= 0x80; /* LBPME */
>  
> -			if (ata_id_has_zero_after_trim(args->id))
> -				rbuf[14] |= 0x40; /* TPRZ */
> +			if (ata_id_has_zero_after_trim(args->id) &&
> +			    dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM) {
> +				ata_dev_warn(dev, "Enabling discard_zeroes_data\n");
> +				rbuf[14] |= 0x40; /* LBPRZ */
> +			}
>  		}
>  	}
> -
>  	return 0;
>  }
>  
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index bd5fefeaf548..45ac825b8366 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -421,6 +421,7 @@ enum {
>  	ATA_HORKAGE_NO_NCQ_TRIM	= (1 << 19),	/* don't use queued TRIM */
>  	ATA_HORKAGE_NOLPM	= (1 << 20),	/* don't use LPM */
>  	ATA_HORKAGE_WD_BROKEN_LPM = (1 << 21),	/* some WDs have broken LPM */
> +	ATA_HORKAGE_ZERO_AFTER_TRIM = (1 << 22),/* guarantees zero after trim */
>  
>  	 /* DMA mask for user DMA control: User visible values; DO NOT
>  	    renumber */
> 
