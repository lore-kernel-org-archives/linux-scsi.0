From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/05] scsi: make scsi_queue_insert() use
 blk_requeue_request()
Date: Thu, 21 Apr 2005 11:29:11 +0900
Message-ID: <42670FF7.3020404@home-tj.org>
References: <20050419231435.D85F89C0@htj.dyndns.org>	 <20050419231435.329FA30B@htj.dyndns.org>	 <1114039446.5933.17.camel@mulgrave>  <4266F1D0.2060003@gmail.com> <1114049793.5000.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.205]:47208 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261184AbVDUC3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 22:29:21 -0400
Received: by rproxy.gmail.com with SMTP id i8so303468rne
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 19:29:18 -0700 (PDT)
In-Reply-To: <1114049793.5000.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-04-21 at 09:20 +0900, Tejun Heo wrote:
> 
>>  Hello, James.
>>
>>James Bottomley wrote:
>>
>>>On Wed, 2005-04-20 at 08:15 +0900, Tejun Heo wrote:
>>>
>>>
>>>>-	 * Insert this command at the head of the queue for it's device.
>>>>-	 * It will go before all other commands that are already in the queue.
>>>>-	 *
>>>>-	 * NOTE: there is magic here about the way the queue is plugged if
>>>>-	 * we have no outstanding commands.
>>>>-	 * 
>>>>-	 * Although this *doesn't* plug the queue, it does call the request
>>>>-	 * function.  The SCSI request function detects the blocked condition
>>>>-	 * and plugs the queue appropriately.
>>>
>>>
>>>This comment still looks appropriate to me ... why do you want to remove
>>>it?
>>>
>>
>>  Well, the thing is that we don't really care what exactly happens to 
>>the queue or how the queue is plugged or not.  All we need to do are to 
>>requeue the request and kick the queue in the ass.  Hmmm, maybe I should 
>>keep the comment about how the request will be put at the head of the 
>>queue, but the second part about plugging doesn't really belong here, I 
>>think.
> 
> 
> Really?  We do care greatly.  If you requeue with no other outstanding
> commands to the device, the block queue will never restart unless it's
> plugged, and the device will hang. The comment is explaining how this
> happens.
> 

 Yes, you're right.  My point was that that's scsi_run_queue()'s
business.  We don't need to comment that deep when we're requeueing a
request.  After we put a request on a queue, we kick the queue.  It's
the queue running function's responsibility to determine whether to run
the request right away or to defer processing (and thus plug).  I wasn't
saying that the eventual plugging isn't necessary, but that the comment
is sort of excessive.

 Anyways, if you think the comment is necessary, I don't feel strong
against it.  I'll rewrite above comment to fit the new code and repost
this patch soon.

> 
>>  Yes, that will be more efficient but I don't think it would make
>>any 
>>noticeable difference.  IMO, universally using scsi_run_queue() to
>>kick 
>>scsi request queues is better than mixing blk_run_queue() and 
>>scsi_run_queue() for probably unnoticeable optimization.  If we start
>>to 
>>mix'em, we need to rationalize why specific one is chosen in specific 
>>places and that's just unnecessary.
> 
> 
> Fair enough.

 Thanks.

--
tejun
