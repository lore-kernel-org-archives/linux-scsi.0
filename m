From: Tejun Heo <tj@kernel.org>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Tue, 02 Dec 2008 12:43:45 +0900
Message-ID: <4934AEF1.4080009@kernel.org>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>	 <1228183480.13241.163.camel@haakon2.linux-iscsi.org>	 <1228187439.13241.176.camel@haakon2.linux-iscsi.org> <1228188330.13241.184.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:41073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYLBDnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 22:43:49 -0500
In-Reply-To: <1228188330.13241.184.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Hello, Nicholas.

Nicholas A. Bellinger wrote:
> Ok, I am up and running using the following patch against v2.6.28-rc6
> (along with Tejun's patch).   Comments please..?
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f5d3b96..77f1fe0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1505,7 +1507,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
>         struct scsi_target *starget = scsi_target(sdev);
>         struct Scsi_Host *shost = sdev->host;
>  
> -       blkdev_dequeue_request(req);
> +       elv_dequeue_request(req->q, req);

I don't think this really matters.  Either one wouldn't really matter.

>         if (unlikely(cmd == NULL)) {
>                 printk(KERN_CRIT "impossible request in %s.\n",
> @@ -1634,7 +1636,7 @@ static void scsi_request_fn(struct request_queue *q)
>                  * Remove the request from the request list.
>                  */
>                 if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
> -                       blkdev_dequeue_request(req);
> +                       elv_dequeue_request(req->q, req);
>                 sdev->device_busy++;
>  
>                 spin_unlock(q->queue_lock);

And this change is incorrect.  Timer should start here.  I don't think
you're seeing the same problem.  I'll reply to the original message.

Thanks.

-- 
tejun
