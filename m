From: sthumma@codeaurora.org
Subject: Re: Race condition in block layer runtime PM init and scsi disk
 driver
Date: Thu, 10 Oct 2013 04:55:07 -0000
Message-ID: <04811251e7b06dd74849872257d9bb7c.squirrel@www.codeaurora.org>
References: <6c835b531761fe70209d015daa6b87e8.squirrel@www.codeaurora.org>
    <4ed022cf2fedc9ee1049254ea274f705.squirrel@www.codeaurora.org>
    <52551CD3.2060803@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3JJEzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 00:55:08 -0400
In-Reply-To: <52551CD3.2060803@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: sthumma@codeaurora.org, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

> On 10/09/2013 04:32 PM, sthumma@codeaurora.org wrote:
>>> Hi Aaron,
>>>
>>> I found a race condition with the block layer runtime PM due to which
>>> the q->nr_pending is decremented to less than zero (0xFFFF_FFFF (-1))
>>> and hence the blk pre-runtime suspend always returns -EBUSY.
>>>
>>>
>>> The issue is easily reproduced with a scsi disk with disabled tagged
>>> command queuing
>>>
>>> sd_probe_async() ->
>>> 	add_disk() ->
>>> 		disk_add_event() ->
>>> 			schedule(disk_events_workfn)
>>> 	sd_revalidate_disk()
>>> 	blk_pm_runtime_init()
>>> return;
>>>
>>> Let's say the disk_events_workfn() calls sd_check_events() which tries
>>> to send test_unit_ready() and because of sd_revalidate_disk() trying to
>>> send another commands the test_unit_ready() might be re-queued as the
>>> tagged command queuing is disabled.
>>>
>>> So the race condition is -
>>>
>>> Thread 1 			  |		Thread 2
>>> sd_revalidate_disk()		  |	sd_check_events()
>>> ...nr_pending = 0 as q->dev = NULL|	scsi_queue_insert()
>>> blk_runtime_pm_init()		  | 	blk_pm_requeue_request() ->
>>> 				  |	nr_pending = -1 since
>>> 				  |	q->dev != NULL
>>>
>>> Do you have any suggestions on how to fix this issue?
>
> Thanks for the report. I wonder if the following patch helps?

Thanks it works. Would you like to send formal patch for this?
You can add my tested-by ack.

Tested-by: Sujit Reddy Thumma <sthumma@codeaurora.org>

>
> Do the runtime init related work before add_disk, so that every request
> is counted properly.
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e62d17d..5693f6d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2854,6 +2854,7 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
>  		gd->events |= DISK_EVENT_MEDIA_CHANGE;
>  	}
>
> +	blk_pm_runtime_init(sdp->request_queue, dev);
>  	add_disk(gd);
>  	if (sdkp->capacity)
>  		sd_dif_config_host(sdkp);
> @@ -2862,7 +2863,6 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
>
>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>  		  sdp->removable ? "removable " : "");
> -	blk_pm_runtime_init(sdp->request_queue, dev);
>  	scsi_autopm_put_device(sdp);
>  	put_device(&sdkp->dev);
>  }
>
> Thanks,
> Aaron
>
>>>
>>>
>>> --
>>> Regards,
>>> Sujit
>>>
>>
>>
>
>

