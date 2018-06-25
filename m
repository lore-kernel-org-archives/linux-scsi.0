From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH] scsi_transport_fc: use 64-bit timestamps consistently
Date: Mon, 25 Jun 2018 12:56:59 -0700
Message-ID: <cb2a2d5b-3293-8cd8-2d81-5bbc5e7d072c@gmail.com>
References: <20180618153004.1808419-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618153004.1808419-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/18/2018 8:29 AM, Arnd Bergmann wrote:
> The get_seconds() helper returns an 'unsigned long' value, which can
> overflow on 32-bit architectures. Since the interface we pass it into
> already uses a 64-bit type, we can just use ktime_get_real_seconds()
> instead.
> 
> While we generally prefer local timestamps in CLOCK_MONOTONIC format
> (ktime_get_seconds), this keeps using the CLOCK_REALTIME version
> in order to maintain compatibility with existing code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/scsi_transport_fc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 1da3d71e9f61..bb6de88aa724 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -567,7 +567,7 @@ fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
>   
>   	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
>   				FC_NL_ASYNC_EVENT, len);
> -	event->seconds = get_seconds();
> +	event->seconds = ktime_get_real_seconds();
>   	event->vendor_id = 0;
>   	event->host_no = shost->host_no;
>   	event->event_datalen = sizeof(u32);	/* bytes */
> @@ -635,7 +635,7 @@ fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
>   
>   	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
>   				FC_NL_ASYNC_EVENT, len);
> -	event->seconds = get_seconds();
> +	event->seconds = ktime_get_real_seconds();
>   	event->vendor_id = vendor_id;
>   	event->host_no = shost->host_no;
>   	event->event_datalen = data_len;	/* bytes */
> 

looks good

Reviewed-by:  James Smart  <james.smart@broadcom.com>
