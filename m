From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/05] scsi: make scsi_queue_insert() use
 blk_requeue_request()
Date: Thu, 21 Apr 2005 09:20:32 +0900
Message-ID: <4266F1D0.2060003@gmail.com>
References: <20050419231435.D85F89C0@htj.dyndns.org>	 <20050419231435.329FA30B@htj.dyndns.org> <1114039446.5933.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.201]:21575 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261851AbVDUAUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 20:20:41 -0400
Received: by rproxy.gmail.com with SMTP id a41so223141rng
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 17:20:41 -0700 (PDT)
In-Reply-To: <1114039446.5933.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>


  Hello, James.

James Bottomley wrote:
> On Wed, 2005-04-20 at 08:15 +0900, Tejun Heo wrote:
> 
>>-	 * Insert this command at the head of the queue for it's device.
>>-	 * It will go before all other commands that are already in the queue.
>>-	 *
>>-	 * NOTE: there is magic here about the way the queue is plugged if
>>-	 * we have no outstanding commands.
>>-	 * 
>>-	 * Although this *doesn't* plug the queue, it does call the request
>>-	 * function.  The SCSI request function detects the blocked condition
>>-	 * and plugs the queue appropriately.
> 
> 
> This comment still looks appropriate to me ... why do you want to remove
> it?
> 

  Well, the thing is that we don't really care what exactly happens to 
the queue or how the queue is plugged or not.  All we need to do are to 
requeue the request and kick the queue in the ass.  Hmmm, maybe I should 
keep the comment about how the request will be put at the head of the 
queue, but the second part about plugging doesn't really belong here, I 
think.

> 
>>+	 * Requeue the command.
>> 	 */
>>-	blk_insert_request(device->request_queue, cmd->request, 1, cmd, 1);
>>+	spin_lock_irqsave(q->queue_lock, flags);
>>+	blk_requeue_request(q, cmd->request);
>>+	spin_unlock_irqrestore(q->queue_lock, flags);
>>+
>>+	scsi_run_queue(q);
> 
> 
> Really, wouldn't it be much more efficient simply to call blk_run_queue
> ()? since the blocked flags were set above, that's pretty much what
> scsi_run_queue() collapses to.
> 

  Yes, that will be more efficient but I don't think it would make any 
noticeable difference.  IMO, universally using scsi_run_queue() to kick 
scsi request queues is better than mixing blk_run_queue() and 
scsi_run_queue() for probably unnoticeable optimization.  If we start to 
mix'em, we need to rationalize why specific one is chosen in specific 
places and that's just unnecessary.

  Thanks.

-- 
tejun

