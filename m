From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sanity check for timeout in sg_io()
Date: Wed, 10 May 2017 08:34:36 -0500
Message-ID: <1494423276.2396.4.camel@HansenPartnership.com>
References: <1494422676-72745-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1494422676-72745-1-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-10 at 15:24 +0200, Hannes Reinecke wrote:
> sg_io() is using msecs_to_jiffies() to convert a passed in timeout
> value (in milliseconds) to a jiffies value. However, if the value
> is too large msecs_to_jiffies() will return MAX_JIFFY_OFFSET, which
> will be truncated to -2 and cause the timeout to be set to 1.3
> _years_. Which is probably too long for most applications.

What makes you think that?  If a user specified timeout in ms is over
MAX_JIFFY_OFFSET on, say a 250HZ machine, then they're already asking
for something around this length of time in ms, which is probably their
attempt at machine infinity, meaning they want effectively no timeout. 
 Your patch would now give them the default timeout, which looks way
too short.

James

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  block/scsi_ioctl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 4a294a5..53b95ea 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -231,6 +231,7 @@ static int blk_fill_sghdr_rq(struct request_queue
> *q, struct request *rq,
>  			     struct sg_io_hdr *hdr, fmode_t mode)
>  {
>  	struct scsi_request *req = scsi_req(rq);
> +	unsigned long timeout;
>  
>  	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
>  		return -EFAULT;
> @@ -242,7 +243,11 @@ static int blk_fill_sghdr_rq(struct
> request_queue *q, struct request *rq,
>  	 */
>  	req->cmd_len = hdr->cmd_len;
>  
> -	rq->timeout = msecs_to_jiffies(hdr->timeout);
> +	timeout = msecs_to_jiffies(hdr->timeout);
> +	if (timeout == MAX_JIFFY_OFFSET)
> +		rq->timeout = 0;
> +	else
> +		rq->timeout = timeout;
>  	if (!rq->timeout)
>  		rq->timeout = q->sg_timeout;
>  	if (!rq->timeout)
