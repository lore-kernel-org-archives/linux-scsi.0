From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: Error print if device is not bidi capable when refusing a bidi command
Date: Tue, 20 Jan 2009 15:15:17 +0100
Message-ID: <20090120141517.GM30821@kernel.dk>
References: <4975DC00.2090005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:15519 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760111AbZATOQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 09:16:49 -0500
Content-Disposition: inline
In-Reply-To: <4975DC00.2090005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Tue, Jan 20 2009, Boaz Harrosh wrote:
> 
> If a bidi command was issued to a request_queue not mark as
> QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
> an administrator would like to know about, which is otherwise
> hard to detect.

At the very least, put rate limit on that printk.

> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 44a2a0f..977547a 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -270,6 +270,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  
>  	if (rw == WRITE && hdr->din_xfer_len) {
>  		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
> +			printk(KERN_ERR "bsg: Attempt to send a bidi command "
> +			       "to a none bidi device\n");
>  			ret = -EOPNOTSUPP;
>  			goto out;
>  		}
> -- 
> 1.6.0.1
> 

-- 
Jens Axboe

