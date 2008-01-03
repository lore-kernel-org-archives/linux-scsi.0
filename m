From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
Date: Thu, 03 Jan 2008 17:01:11 +0200
Message-ID: <477CF8B7.90908@panasas.com>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org> <20080103135905X.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14710 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751005AbYACPBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 10:01:23 -0500
In-Reply-To: <20080103135905X.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp

On Thu, Jan 03 2008 at 6:56 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> To remove sense_buffer array in scsi_cmnd structure, this replaces
> sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in several LLDs.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/ata/libata-scsi.c           |    4 ++--
>  drivers/message/fusion/mptscsih.c   |    2 +-
>  drivers/message/i2o/i2o_scsi.c      |    2 +-
>  drivers/scsi/53c700.c               |   11 ++++++-----
>  drivers/scsi/BusLogic.c             |    2 +-
>  drivers/scsi/aacraid/aachba.c       |   12 ++++++------
>  drivers/scsi/advansys.c             |   14 +++++++-------
>  drivers/scsi/aha1542.c              |    4 ++--
>  drivers/scsi/aha1740.c              |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c  |    6 +++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c  |    6 +++---
>  drivers/scsi/aic7xxx_old.c          |   12 ++++++------
>  drivers/scsi/arcmsr/arcmsr_hba.c    |    6 +++---
>  drivers/scsi/arm/fas216.c           |   10 +++++-----
>  drivers/scsi/dc395x.c               |   16 +++++++---------
>  drivers/scsi/dpt_i2o.c              |    2 +-
>  drivers/scsi/eata.c                 |    4 ++--
>  drivers/scsi/eata_pio.c             |    2 +-
>  drivers/scsi/hptiop.c               |    2 +-
>  drivers/scsi/ips.c                  |   10 ++++------
>  drivers/scsi/ncr53c8xx.c            |    2 +-
>  drivers/scsi/qla1280.c              |    4 ++--
>  drivers/scsi/qla2xxx/qla_isr.c      |   12 ++++++------
>  drivers/scsi/qlogicpti.c            |    2 +-
>  drivers/scsi/scsi_error.c           |    6 +++---
>  drivers/scsi/scsi_lib.c             |    2 +-
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    5 ++---
>  drivers/scsi/tmscsim.c              |    6 +++---
>  drivers/scsi/u14-34f.c              |    4 ++--
>  drivers/scsi/ultrastor.c            |    2 +-
>  30 files changed, 85 insertions(+), 89 deletions(-)
> 

<snip>

> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index fb5f202..3bf186e 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2009,7 +2009,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
>  		 * have valid data in the sense buffer that could
>  		 * confuse the higher levels.
>  		 */
> -		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
> +		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  //printk("scsi%d.%c: sense buffer: ", info->host->host_no, '0' + SCpnt->device->id);
>  //{ int i; for (i = 0; i < 32; i++) printk("%02x ", SCpnt->sense_buffer[i]); printk("\n"); }
>  	/*
> @@ -2108,16 +2108,16 @@ request_sense:
>  	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
>  	SCpnt->cmnd[0] = REQUEST_SENSE;
>  	SCpnt->cmnd[1] = SCpnt->device->lun << 5;
> -	SCpnt->cmnd[4] = sizeof(SCpnt->sense_buffer);
> +	SCpnt->cmnd[4] = SCSI_SENSE_BUFFERSIZE;
>  	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
>  	SCpnt->SCp.buffer = NULL;
>  	SCpnt->SCp.buffers_residual = 0;
>  	SCpnt->SCp.ptr = (char *)SCpnt->sense_buffer;
> -	SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
> -	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
> +	SCpnt->SCp.this_residual = SCSI_SENSE_BUFFERSIZE;
> +	SCpnt->SCp.phase = SCSI_SENSE_BUFFERSIZE;
>  	SCpnt->SCp.Message = 0;
>  	SCpnt->SCp.Status = 0;
> -	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
> +	SCpnt->request_bufflen = SCSI_SENSE_BUFFERSIZE;
>  	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>  	SCpnt->use_sg = 0;
>  	SCpnt->tag = 0;

Tomo hi.

This driver has a patch in scsi-pending that removes exactly all
this code. And converts it to the new scsi_error API.

You have caught me in the middle of sweeping the entire tree,
converting all these drivers, to code like the patch 
to fas216.c. This is exactly what is needed to satisfy
the condition you stated, "is needed for farther cleanup".
(Though I admit this was done on a low priority, as I'm
busy with other stuff)

James
It is about time for this patch, it has even been
acknowledged by a maintainer. Also the second patch to
arm is do.

Boaz
