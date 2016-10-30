From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: fix wrong scsi_device_put() in
 alua_rtpg_queue()
Date: Sun, 30 Oct 2016 13:54:57 +0100
Message-ID: <379a3618-7ecd-97b5-eadb-a946e8c61c02@suse.de>
References: <1477642877-10228-1-git-send-email-tang.junhui@zte.com.cn>
 <96621137-8209-634e-3d70-ffd89319f103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753014AbcJ3MzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Oct 2016 08:55:10 -0400
In-Reply-To: <96621137-8209-634e-3d70-ffd89319f103@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, tang.junhui@zte.com.cn, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

On 10/28/2016 05:05 PM, Bart Van Assche wrote:
> On 10/28/2016 01:21 AM, tang.junhui@zte.com.cn wrote:
>> From: "tang.junhui" <tang.junhui@zte.com.cn>
>>
>> scsi_device_put() is called when the conditions pg->rtpg_sdev!=NULL
>> and queue_delayed_work() failure satisfied, actually it should be not
>> to call because scsi_device_get() is not called previous in this scene.
>>
>> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 241829e..78081df 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -866,6 +866,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>>  			    struct alua_queue_data *qdata, bool force)
>>  {
>>  	int start_queue = 0;
>> +	int sdev_geted = 0;
>>  	unsigned long flags;
>>  	struct workqueue_struct *alua_wq = kaluad_wq;
>>
>> @@ -884,6 +885,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>>  		kref_get(&pg->kref);
>>  		pg->rtpg_sdev = sdev;
>>  		scsi_device_get(sdev);
>> +		sdev_geted = 1;
>>  		start_queue = 1;
>>  	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
>>  		pg->flags |= ALUA_PG_RUN_RTPG;
>> @@ -901,7 +903,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>>  	if (start_queue &&
>>  	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
>>  				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
>> -		scsi_device_put(sdev);
>> +		if (sdev_geted)
>> +			scsi_device_put(sdev);
>>  		kref_put(&pg->kref, release_port_group);
>>  	}
>>  }
>
> Hello Tang Junhui,
>
> Personally I prefer the patch below because that patch does not introduce
> a new variable. This is a patch I started testing four weeks ago and it has
> survived all my ALUA tests so far. Please note that I do not know whether
> my tests hit the !(pg->flags & ALUA_PG_RUNNING) code path.
>
> From: Bart Van Assche <bart.vanassche@sandisk.com>
> Date: Thu, 29 Sep 2016 10:06:51 -0700
> Subject: [PATCH] scsi_dh_alua: Fix a reference counting bug
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 241829e..23835f7 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -890,6 +890,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  		/* Do not queue if the worker is already running */
>  		if (!(pg->flags & ALUA_PG_RUNNING)) {
>  			kref_get(&pg->kref);
> +			sdev = NULL;
>  			start_queue = 1;
>  		}
>  	}
> @@ -901,7 +902,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  	if (start_queue &&
>  	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
>  				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
> -		scsi_device_put(sdev);
> +		if (sdev)
> +			scsi_device_put(sdev);
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  }
>
Yes, this looks far better.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
