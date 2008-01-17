From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/8] scsi-drivers Don't use SG_ALL as allocation size
Date: Thu, 17 Jan 2008 09:47:45 -0800
Message-ID: <20080117174745.GB20186@plap3.qlogic.org>
References: <478F8435.5000907@panasas.com> <478F85E7.20503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31436 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYAQRrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:47:53 -0500
Content-Disposition: inline
In-Reply-To: <478F85E7.20503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 17 Jan 2008, Boaz Harrosh wrote:

>   below list of drivers have used SG_ALL as a size to
>   preallocate maximum possible command's sg-count.
>   This is no longer possible since the maximum is not
>   set at compile time but as a run time configuration.
> 
>   A better schema can be advised with a more dynamic allocation.
>   Perhaps from a kmem_cache.
> 
>   Affected drivers/files:
> 	drivers/scsi/atari_scsi.[ch]
> 	drivers/scsi/eata_pio.c
> 	drivers/scsi/ibmvscsi/ibmvscsi.[ch]
> 	drivers/scsi/mac53c94.c
> 	drivers/scsi/mesh.c
> 	drivers/scsi/nsp32.h
> 	drivers/scsi/qla1280.c
> 	drivers/scsi/qla2xxx/qla_os.c
> 	drivers/scsi/qla4xxx/ql4_def.h
...

There's no functional change in your patches to qla2xxx and qla4xxx.
Perhaps a cut-n-paste typo from qla1280.c (which should be capped):

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 78d1103..e368f38 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -111,6 +111,8 @@ static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
>  static int qla2x00_change_queue_depth(struct scsi_device *, int);
>  static int qla2x00_change_queue_type(struct scsi_device *, int);
>  
> +#define QLA2XXX_MAX_SG 255
> +
>  struct scsi_host_template qla2x00_driver_template = {
>  	.module			= THIS_MODULE,
>  	.name			= QLA2XXX_DRIVER_NAME,
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index accaf69..64cd43b 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -101,6 +101,7 @@
>  #define MBOX_AEN_REG_COUNT	5
>  #define MAX_INIT_RETRIES	5
>  #define IOCB_HIWAT_CUSHION	16
> +#define QLA_MAX_SG		255


I don't forsee any issues with maintaining SG_ALL (~0) usage within
qla2xxx and qla4xxx, as the number of unused entries on the HBA's
request-queue shall ultimately be the rate-limiting factor.

--
av
