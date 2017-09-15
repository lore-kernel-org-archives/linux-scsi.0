From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] sg: factor out sg_fill_request_table()
Date: Fri, 15 Sep 2017 15:44:21 -0400
Message-ID: <0d09af9d-3a82-e6b0-3707-c184b9f72331@interlog.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
 <1505477116-75013-2-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49465 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbdIOToa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 15:44:30 -0400
In-Reply-To: <1505477116-75013-2-git-send-email-hare@suse.de>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.com>

On 2017-09-15 08:05 AM, Hannes Reinecke wrote:
> Factor our sg_fill_request_table() for better readability.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 62 ++++++++++++++++++++++++++++++++-----------------------
>   1 file changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 03194c4..f1e20ca0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -857,6 +857,40 @@ static int max_sectors_bytes(struct request_queue *q)
>   	return max_sectors << 9;
>   }
>   
> +static void
> +sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
> +{
> +	Sg_request *srp;
> +	int val;
> +	unsigned int ms;
> +
> +	val = 0;
> +	list_for_each_entry(srp, &sfp->rq_list, entry) {
> +		if (val > SG_MAX_QUEUE)
> +			break;
> +		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
> +		rinfo[val].req_state = srp->done + 1;
> +		rinfo[val].problem =
> +			srp->header.masked_status &
> +			srp->header.host_status &
> +			srp->header.driver_status;
> +		if (srp->done)
> +			rinfo[val].duration =
> +				srp->header.duration;
> +		else {
> +			ms = jiffies_to_msecs(jiffies);
> +			rinfo[val].duration =
> +				(ms > srp->header.duration) ?
> +				(ms - srp->header.duration) : 0;
> +		}
> +		rinfo[val].orphan = srp->orphan;
> +		rinfo[val].sg_io_owned = srp->sg_io_owned;
> +		rinfo[val].pack_id = srp->header.pack_id;
> +		rinfo[val].usr_ptr = srp->header.usr_ptr;
> +		val++;
> +	}
> +}
> +
>   static long
>   sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   {
> @@ -1041,39 +1075,15 @@ static int max_sectors_bytes(struct request_queue *q)
>   			return -EFAULT;
>   		else {
>   			sg_req_info_t *rinfo;
> -			unsigned int ms;
>   
>   			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
>   								GFP_KERNEL);
>   			if (!rinfo)
>   				return -ENOMEM;
>   			read_lock_irqsave(&sfp->rq_list_lock, iflags);
> -			val = 0;
> -			list_for_each_entry(srp, &sfp->rq_list, entry) {
> -				if (val > SG_MAX_QUEUE)
> -					break;
> -				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
> -				rinfo[val].req_state = srp->done + 1;
> -				rinfo[val].problem =
> -					srp->header.masked_status &
> -					srp->header.host_status &
> -					srp->header.driver_status;
> -				if (srp->done)
> -					rinfo[val].duration =
> -						srp->header.duration;
> -				else {
> -					ms = jiffies_to_msecs(jiffies);
> -					rinfo[val].duration =
> -						(ms > srp->header.duration) ?
> -						(ms - srp->header.duration) : 0;
> -				}
> -				rinfo[val].orphan = srp->orphan;
> -				rinfo[val].sg_io_owned = srp->sg_io_owned;
> -				rinfo[val].pack_id = srp->header.pack_id;
> -				rinfo[val].usr_ptr = srp->header.usr_ptr;
> -				val++;
> -			}
> +			sg_fill_request_table(sfp, rinfo);
>   			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> +
>   			result = __copy_to_user(p, rinfo,
>   						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
>   			result = result ? -EFAULT : 0;
> 
