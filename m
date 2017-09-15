From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 15:44:33 -0400
Message-ID: <2ecd9e8e-6c65-d036-cc49-e5124bfe47de@interlog.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
 <1505477116-75013-3-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49484 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751738AbdIOToj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 15:44:39 -0400
In-Reply-To: <1505477116-75013-3-git-send-email-hare@suse.de>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.com>

On 2017-09-15 08:05 AM, Hannes Reinecke wrote:
> When calling SG_GET_REQUEST_TABLE ioctl that only a half-filled
> table is returned; the remaining part will then contain stale
> kernel memory information.
> This patch zeroes out the entire table to avoid this issue.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f1e20ca0..7f98ab4 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -868,7 +868,6 @@ static int max_sectors_bytes(struct request_queue *q)
>   	list_for_each_entry(srp, &sfp->rq_list, entry) {
>   		if (val > SG_MAX_QUEUE)
>   			break;
> -		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
>   		rinfo[val].req_state = srp->done + 1;
>   		rinfo[val].problem =
>   			srp->header.masked_status &
> @@ -1076,8 +1075,8 @@ static int max_sectors_bytes(struct request_queue *q)
>   		else {
>   			sg_req_info_t *rinfo;
>   
> -			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
> -								GFP_KERNEL);
> +			rinfo = kzalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
> +					GFP_KERNEL);
>   			if (!rinfo)
>   				return -ENOMEM;
>   			read_lock_irqsave(&sfp->rq_list_lock, iflags);
> 
