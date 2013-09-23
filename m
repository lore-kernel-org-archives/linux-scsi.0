From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] ufs: adjust queue settings to PRDT limitations
Date: Mon, 23 Sep 2013 13:18:01 +0530
Message-ID: <523FF231.7080300@codeaurora.org>
References: <1379745419-7099-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60377 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3IWHsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 03:48:07 -0400
In-Reply-To: <1379745419-7099-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 9/21/2013 12:06 PM, Akinobu Mita wrote:
> The data byte count field of PRDT indicates the length of data block
> which is a segment of data transfer for SCSI commands.  The value of
> this field shall have Dword granularity and the the maximum of length
> is 256KB.
>
> This adjusts dma pad mask and max segment size to the above-mentioned
> PRDT limitations.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
>   drivers/scsi/ufs/ufshci.h |  3 +++
>   2 files changed, 18 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7ef9c17..c60537f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1919,6 +1919,20 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
>   }
>   
>   /**
> + * ufshcd_slave_configure - adjust SCSI device configurations
> + * @sdev: pointer to SCSI device
> + */
> +static int ufshcd_slave_configure(struct scsi_device *sdev)
> +{
> +	struct request_queue *q = sdev->request_queue;
> +
> +	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
> +	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
> +
> +	return 0;
> +}
> +
> +/**
>    * ufshcd_slave_destroy - remove SCSI device configurations
>    * @sdev: pointer to SCSI device
>    */
> @@ -2749,6 +2763,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>   	.proc_name		= UFSHCD,
>   	.queuecommand		= ufshcd_queuecommand,
>   	.slave_alloc		= ufshcd_slave_alloc,
> +	.slave_configure	= ufshcd_slave_configure,
>   	.slave_destroy		= ufshcd_slave_destroy,
>   	.eh_abort_handler	= ufshcd_abort,
>   	.eh_device_reset_handler = ufshcd_device_reset,
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 0475c66..c8de354 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -296,6 +296,9 @@ enum {
>   	MASK_OCS			= 0x0F,
>   };
>   

Ideally there should be comment here to explain the reason for this 
limitation. I see comments in commit text but not here in code.
Its not general practice to browse through history to understand the 
reason behind this limitations. so it always helps to add comments in 
code itself.

Regards,
Subhash

> +#define PRDT_DATA_BYTE_COUNT_MAX	(256 * 1024)
> +#define PRDT_DATA_BYTE_COUNT_PAD	4
> +
>   /**
>    * struct ufshcd_sg_entry - UFSHCI PRD Entry
>    * @base_addr: Lower 32bit physical address DW-0

