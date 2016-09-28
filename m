From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 9/9] [RFC] nvme: Fix a race condition
Date: Wed, 28 Sep 2016 09:23:03 -0500
Message-ID: <009601d21993$d2d33670$7879a350$@opengridcomputing.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com> <9c372b04-a194-58c4-a64f-b155b52a5244@sandisk.com> <013c01d218dc$8a5406c0$9efc1440$@opengridcomputing.com> <9d8e0f32-6703-cf23-d424-bcecb65c2a26@sandisk.com> <1474995360.2716.19.camel@linux.vnet.ibm.com> <3fb86a78-de3a-b764-a493-cb5bc5b6d8b6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3fb86a78-de3a-b764-a493-cb5bc5b6d8b6-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'James Bottomley' <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, 'Jens Axboe' <axboe-b10kYP2dOMg@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Mike Snitzer' <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Keith Busch' <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> 
> Hello James and Steve,
> 
> I will add a comment.
> 
> Please note that the above patch does not change the behavior of
> nvme_stop_queues() except that it causes nvme_stop_queues() to wait
> until any ongoing nvme_queue_rq() calls have finished.
> blk_resume_queue() does not affect the value of the BLK_MQ_S_STOPPED bit
> that has been set by blk_mq_stop_hw_queues(). All it does is to resume
> pending blk_queue_enter() calls and to ensure that future
> blk_queue_enter() calls do not block. Even after blk_resume_queue() has
> been called if a new request is queued queue_rq() won't be invoked
> because the BLK_MQ_S_STOPPED bit is still set. Patch "dm: Fix a race
> condition related to stopping and starting queues" realizes a similar
> change in the dm driver and that change has been tested extensively.
> 

Thanks for the detailed explanation!  I think your code, then, is correct as-is.   And this series doesn't fix the issue I'm hitting, so I'll keep digging. :)

Steve.  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
