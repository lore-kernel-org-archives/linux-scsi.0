From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [patch 1/1] megaraid: Add support for change_queue_depth
Date: Thu, 6 Jul 2006 06:16:02 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BE4C@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2442 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030226AbWGFMQH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 08:16:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@charter.net, "Kolli, Neela" <Neela.Kolli@engenio.com>
Cc: linux-scsi@vger.kernel.org

Hi,
Wednesday, July 05, 2006 6:00 PM, brking wrote:
> Adds support for change_queue_depth so that device
> queue depth can be changed at runtime through sysfs. 
Can you share any reason to have queue depth chanaged at runtime?
It is set with MBOX_MAX_SCSI_CMDS at driver attach.

Thank you,

Seokmann

> -----Original Message-----
> From: brking@charter.net [mailto:brking@charter.net] 
> Sent: Wednesday, July 05, 2006 6:00 PM
> To: Kolli, Neela
> Cc: Ju, Seokmann; linux-scsi@vger.kernel.org; brking@charter.net
> Subject: [patch 1/1] megaraid: Add support for change_queue_depth
> 
> 
> Adds support for change_queue_depth so that device
> queue depth can be changed at runtime through sysfs.
> 
> Signed-off-by: <brking@charter.net>
> ---
> 
> 
> diff -puN 
> drivers/scsi/megaraid/megaraid_mbox.c~megaraid_change_queue_de
> pth drivers/scsi/megaraid/megaraid_mbox.c
> --- 
> linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_chang
> e_queue_depth	2006-07-05 14:00:04.000000000 -0500
> +++ linux-2.6-brking/drivers/scsi/megaraid/megaraid_mbox.c	
> 2006-07-05 16:53:36.000000000 -0500
> @@ -330,6 +330,21 @@ static struct device_attribute *megaraid
>  	NULL,
>  };
>  
> +/**
> + * megaraid_change_queue_depth - Change the device's queue depth
> + * @sdev:	scsi device struct
> + * @qdepth:	depth to set
> + *
> + * Return value:
> + * 	actual depth set
> + **/
> +static int megaraid_change_queue_depth(struct scsi_device 
> *sdev, int qdepth)
> +{
> +	if (qdepth > MBOX_MAX_SCSI_CMDS)
> +		qdepth = MBOX_MAX_SCSI_CMDS;
> +	scsi_adjust_queue_depth(sdev, 0, qdepth);
> +	return sdev->queue_depth;
> +}
>  
>  /*
>   * Scsi host template for megaraid unified driver
> @@ -343,6 +358,7 @@ static struct scsi_host_template megarai
>  	.eh_device_reset_handler	= megaraid_reset_handler,
>  	.eh_bus_reset_handler		= megaraid_reset_handler,
>  	.eh_host_reset_handler		= megaraid_reset_handler,
> +	.change_queue_depth		= megaraid_change_queue_depth,
>  	.use_clustering			= ENABLE_CLUSTERING,
>  	.sdev_attrs			= megaraid_sdev_attrs,
>  	.shost_attrs			= megaraid_shost_attrs,
> _
> 
