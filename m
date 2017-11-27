From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: debug: remove jiffies_to_timespec
Date: Mon, 27 Nov 2017 14:29:58 +0100
Message-ID: <2ef3fdc8-8e61-0e67-a3f9-be2dc36d8e50@interlog.com>
References: <20171127113647.2352914-1-arnd@arndb.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57963 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752065AbdK0NaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Nov 2017 08:30:13 -0500
In-Reply-To: <20171127113647.2352914-1-arnd@arndb.de>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2017-11-27 12:36 PM, Arnd Bergmann wrote:
> There is no need to go through an intermediate timespec to convert
> to ktime_t when we just want a simple multiplication. This gets
> rid of one of the few users of jiffies_to_timespec, which I
> hope to remove as part of the y2038 cleanup.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index e4f037f0f38b..df7e9db44d44 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4085,10 +4085,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   		ktime_t kt;
>   
>   		if (delta_jiff > 0) {
> -			struct timespec ts;
> -
> -			jiffies_to_timespec(delta_jiff, &ts);
> -			kt = ktime_set(ts.tv_sec, ts.tv_nsec);
> +			kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
>   		} else
>   			kt = sdebug_ndelay;
>   		if (NULL == sd_dp) {
> 
