From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Sat, 27 Aug 2005 15:08:07 +1000
Message-ID: <430FF537.7010705@torque.net>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de> <430B1799.1060800@torque.net> <430FDD73.6050200@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <430FDD73.6050200@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Does the attached look OK to everybody?
> 

Jeff,
Yes.

And after an exchange with Jens, it would probably be
safer to map transfer_length=0 for READ_10 and READ_16
(as well as WRITE_10 and WRITE_16) to a nop on the ATA
side. Otherwise an ATA disk may attempt to transfer 2**16
sectors. [Only READ_6 and WRITE_6 have the quirky "0 means
256" definition, in the larger commands "0 means 0".]

Doug Gilbert

> 
> ------------------------------------------------------------------------
> 
> diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
> --- a/drivers/scsi/libata-scsi.c
> +++ b/drivers/scsi/libata-scsi.c
> @@ -581,6 +581,12 @@ static unsigned int ata_scsi_rw_xlat(str
>  
>  	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
>  		qc->nsect = tf->nsect = scsicmd[4];
> +		if (!qc->nsect) {
> +			qc->nsect = 256;
> +			if (lba48)
> +				tf->hob_nsect = 1;
> +		}
> +
>  		tf->lbal = scsicmd[3];
>  		tf->lbam = scsicmd[2];
>  		tf->lbah = scsicmd[1] & 0x1f; /* mask out reserved bits */

