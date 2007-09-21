From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 09:12:03 -0500
Message-ID: <1190383924.3333.2.camel@localhost.localdomain>
References: <20070921094825.GA15940@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070921094825.GA15940@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-09-21 at 05:48 -0400, Jeff Garzik wrote:
> commit a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Sep 21 05:07:19 2007 -0400
> 
>     [libata] SCSI: support INQUIRY page 89h (ATA info page)
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
>  drivers/ata/libata-scsi.c |   82 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 78 insertions(+), 4 deletions(-)
> 
> a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7ad046b..bb5a5c1 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1804,6 +1804,71 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
>  }
>  
>  /**
> + *	ata_scsiop_inq_89 - Simulate INQUIRY VPD page 89, ATA info
> + *	@args: device IDENTIFY data / SCSI command of interest.
> + *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
> + *	@buflen: Response buffer length.
> + *
> + *	Yields SAT-specified ATA VPD page.
> + *
> + *	LOCKING:
> + *	spin_lock_irqsave(host lock)
> + */
> +
> +unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
> +			      unsigned int buflen)
> +{
> +	struct ata_device *dev = args->dev;
> +	u8 pbuf[60];
> +	bool is_atapi = (dev->class == ATA_DEV_ATAPI);

I thought this was only used in the dev->class == ATA_DEV_ATA leg of the
ata_scsi_queuecommand(), so isn't this always false?

> +	struct ata_taskfile tf;
> +	unsigned int i;
> +
> +	if (!buflen)
> +		return 0;
> +
> +	memset(&pbuf, 0, sizeof(pbuf));
> +	memset(&tf, 0, sizeof(tf));
> +
> +	if (is_atapi)
> +		pbuf[0] = 0x5;	/* FIXME: hardcodes MMC */

Actually, in MMC implementation of INQUIRY per SPC-3 (or earlier if MMC
< 5) is mandatory.  The problem cases I can see are non-standard ATAPI
devices (probably scanners).

James


