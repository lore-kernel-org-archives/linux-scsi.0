From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Tue, 18 Sep 2007 13:35:27 -0700 (PDT)
Message-ID: <822867.50383.qm@web31812.mail.mud.yahoo.com>
References: <1189792710.6030.3.camel@linux.site>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:47558 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755638AbXIRUmO (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2007 16:42:14 -0400
In-Reply-To: <1189792710.6030.3.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>, Linux-scsi@vger.kernel.org

--- Gilbert Wu <Gilbert_Wu@adaptec.com> wrote:
> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> option.)

I'm testing my own SATL with "-d sat".

>   The aic94xx need to return ATA output register for all ATA commands
> except ATA Read/Write commands.

This isn't necessarily true.  As an interconnect driver, you shouldn't
care.  A properly implemented SATL will tell you if/when the ending
fis is needed on a per command basis, and then you can set CSMI_TASK.

It is quite possible that SATL may issue the same command wanting
the ending fis at one time and not wanting the ending fis at another
time.

>   The aic94xx also mark out the DRQ bit from status register which is
> treated as AC_ERR_HSM (host state machine violation) error by top layer
> if it set to one.
>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
> and return ATA output register which is sent by the device.  So the DRQ
> bit may not reflect the last state of device when the command finished
> and it is no meaning for the caller.

Yes, of course, this isn't a bug in aic94xx, but in "libata" which
of course is *not* SATL.

   Luben


> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
> 
> diff -urN a/drivers/scsi/aic94xx/aic94xx_task.c
> b/drivers/scsi/aic94xx/aic94xx_task.c
> --- a/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-13 04:46:00.000000000 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-14 06:06:52.000000000 -0700
> @@ -25,6 +25,7 @@
>   */
>  
>  #include <linux/spinlock.h>
> +#include <linux/ata.h>
>  #include "aic94xx.h"
>  #include "aic94xx_sas.h"
>  #include "aic94xx_hwi.h"
> @@ -220,6 +221,7 @@
>  			memcpy(&resp->ending_fis[0], r+16, 24);
>  			ts->buf_valid_size = sizeof(*resp);
>  		}
> +		resp->ending_fis[2] &= ~ATA_DRQ;
>  	}
>  
>  	asd_invalidate_edb(escb, edb_id);
> @@ -257,6 +259,11 @@
>  		ts->stat = SAS_PROTO_RESPONSE;
>  		asd_get_response_tasklet(ascb, dl);
>  		break;
> +	case TC_CSMI:
> +		ts->resp = SAS_TASK_COMPLETE;
> +		ts->stat = SAM_GOOD;
> +		asd_get_response_tasklet(ascb, dl);
> +		break;
>  	case TF_OPEN_REJECT:
>  		ts->resp = SAS_TASK_UNDELIVERED;
>  		ts->stat = SAS_OPEN_REJECT;
> @@ -374,7 +381,32 @@
>  }
>  
>  /* ---------- ATA ---------- */
> +int is_ata_rw_cmd(u8 ata_cmd)
> +{
>  
> +	switch (ata_cmd) {
> +	case ATA_CMD_READ:
> +	case ATA_CMD_READ_EXT:
> +	case ATA_CMD_WRITE:
> +	case ATA_CMD_WRITE_EXT:
> +	case ATA_CMD_WRITE_FUA_EXT:
> +	case ATA_CMD_FPDMA_READ:
> +	case ATA_CMD_FPDMA_WRITE:
> +	case ATA_CMD_PIO_READ:
> +	case ATA_CMD_PIO_READ_EXT:
> +	case ATA_CMD_PIO_WRITE:
> +	case ATA_CMD_PIO_WRITE_EXT:
> +	case ATA_CMD_READ_MULTI:
> +	case ATA_CMD_READ_MULTI_EXT:
> +	case ATA_CMD_WRITE_MULTI:
> +	case ATA_CMD_WRITE_MULTI_EXT:
> +	case ATA_CMD_WRITE_MULTI_FUA_EXT:
> +	case ATA_CMD_VERIFY:
> +	case ATA_CMD_VERIFY_EXT:
> +		return 1;
> +	}
> +	return 0;
> +}
>  static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
>  			      gfp_t gfp_flags)
>  {
> @@ -427,6 +459,9 @@
>  			flags |= STP_AFFIL_POLICY;
>  		scb->ata_task.flags = flags;
>  	}
> +	if (!is_ata_rw_cmd(scb->ata_task.fis.command))
> +		scb->ata_task.ata_flags |= CSMI_TASK;
> +
>  	ascb->tasklet_complete = asd_task_tasklet_complete;
>  
>  	if (likely(!task->ata_task.device_control_reg_update))
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

