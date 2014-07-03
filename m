From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
 found
Date: Thu, 03 Jul 2014 11:25:54 -0400
Message-ID: <53B57602.2030903@interlog.com>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52406 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbaGCPZ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2014 11:25:59 -0400
In-Reply-To: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, =james.bottomley@parallels.com
Cc: elliott@hp.com, stephenmcameron@gmail.com, hch@lst.de, linux-scsi@vger.kernel.org

On 14-07-03 11:05 AM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Don't loop through all the devices even after
> finding the one we're looking for
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Reviewed-by: Robert Elliott <elliott@hp.com>

With my scsi_debug testing on Christoph's core-for-3.17
tree I can simulate infrequent TSF conditions using the
every_nth mechanism. When one is triggered, all scsi
devices (that scsi_debug is monitoring) get their
queue_depth adjusted.

So:
Acked-by: Douglas Gilbert <dgilbert@interlog.com>


> ---
>   drivers/scsi/scsi_error.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index cbe38e5..db8a488 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -635,6 +635,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
>   		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
>   					SCSI_QDEPTH_RAMP_UP);
>   		sdev->last_queue_ramp_up = jiffies;
> +		break;
>   	}
>   }
>
> @@ -657,6 +658,7 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
>   		 */
>   		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
>   					SCSI_QDEPTH_QFULL);
> +		break;
>   	}
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

