From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 3/9] drivers: convert drivers setting the	change_queue_depth
 callback
Date: Wed, 26 Aug 2009 14:19:47 -0400
Message-ID: <4A957CC3.6080605@garzik.org>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <20090826180331.23396.77062.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45203 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZHZSTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:19:50 -0400
In-Reply-To: <20090826180331.23396.77062.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 08/26/2009 02:03 PM, Vasu Dev wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> This is a simple port of the drivers setting a change_queue_depth
> callback but were not tracking queue fulls. In the patch I just have
> these LLDs adjust the queue depth if the user was requesting it.

Where is the doc describing how, and why, queue-full tracking occurs?


> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 86a4058..fb28be9 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -1963,7 +1963,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
>   	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
>
>   	if (strncmp(model_num, "Maxtor", 6) == 0) {
> -		ata_scsi_change_queue_depth(sdev, 1);
> +		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_SYSFS_REQ);
>   		ata_dev_printk(dev, KERN_NOTICE,
>   			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
>   	}

This queue depth change was clearly not requested via sysfs...

	Jeff



