From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Mon, 22 Sep 2014 10:25:30 -0600
Message-ID: <54204D7A.1070305@acm.org>
References: <541C27BF.6070609@acm.org> <20140922143731.GA15377@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140922143731.GA15377-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 22/09/2014 8:37, Christoph Hellwig wrote:
> One thing that is missing is generation multiqueue-aware tags at the
> blk-mq level, which should be as simple as always adding a queue
> prefix in the tag allocation code.

Hello Christoph,

Adding a queue prefix in the tag allocation code is an interesting idea. 
Encoding the hardware context index in the upper bits of the 'tag' field 
in 'struct request' is something I have considered. The reason I have 
not done that is because I think several block drivers assume that the 
rq->tag field is a number in the range [0..queue_depth-1]. Here is just 
one example from the mtip32xx driver:

         fis->sect_count  = ((rq->tag << 3) | (rq->tag >> 5));

> Did you consider switching srp to use the block layer provided tags?

This is on my to-do list. The only reason I have not yet done this is 
because I have not yet had the time to work on it. Another item that is 
on my to-do list is to eliminate per-request memory allocation and 
instead to use your patch that added a "cmd_size" field in the SCSI host 
template.

> Also do you have any performance numbers for just using multiple
> queues inside srp vs using blk-mq exposed queues?

So far I have only rerun the multithreaded write test. For that test I 
see about 15% more IOPS with this patch series (exploiting multiple 
hardware queues and a 1:1 mapping between hardware context and RDMA 
queue pair) compared to the previous implementation (one hardware queue 
and multiple RDMA queue pairs). Please keep in mind that in that test 
the CPU's of the target system are saturated so the performance 
potential of using multiple hardware queues is probably larger than the 
difference I measured.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
