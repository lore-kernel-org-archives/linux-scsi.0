From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] ibmvscsi: Changeable queue depth
Date: Tue, 29 May 2007 13:14:28 -0500
Message-ID: <1180462468.3700.65.camel@mulgrave.il.steeleye.com>
References: <11804616242477-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34057 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762937AbXE2SOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 14:14:30 -0400
In-Reply-To: <11804616242477-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Tue, 2007-05-29 at 13:00 -0500, Brian King wrote:
> Adds support for a changeable queue depth to ibmvscsi.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth drivers/scsi/ibmvscsi/ibmvscsi.c
> --- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth	2007-05-29 09:31:43.000000000 -0500
> +++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-05-29 09:31:43.000000000 -0500
> @@ -1375,6 +1375,20 @@ static int ibmvscsi_slave_configure(stru
>  	return 0;
>  }
>  
> +/**
> + * ibmvscsi_change_queue_depth - Change the device's queue depth
> + * @sdev:	scsi device struct
> + * @qdepth:	depth to set
> + *
> + * Return value:
> + * 	actual depth set
> + **/
> +static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
> +{
> +	scsi_adjust_queue_depth(sdev, 0, qdepth);

Don't you want to check this against some system limit ... or will the
driver cope just fine when the user sets it to machine infinity and we
diligently try blasting away at it through the queuecommand() routine?

The usual limit, if you have variable queues ... is the maximum the
device could ever accept ... although some people adjust that downwards
because of device starvation fears.

> +	return sdev->queue_depth;
> +}

James


