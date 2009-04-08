From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Tue, 07 Apr 2009 21:29:05 -0400
Message-ID: <49DBFDE1.9010303@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk> <49D5DDDE.9090407@garzik.org> <49D8856E.3090903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49D8856E.3090903@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On 04/03/2009 12:58 PM, Jeff Garzik wrote:
>> Jens Axboe wrote:
>>> This wont work, GFP_NOIO inside the queue lock. You are also only
>>> cloning the front bio, what happens if you have > 1 bio on the request?
>>> You seem to dequeue the request and complete all of it, regardless of
>>> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
>>> because of how the osd_req_{read,write} works, so I'd suggest storing
>>> the byte size in your osdblk_request and only completing that in
>>> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
>>> only dequeue if you manage to start an osd request for each of them,
>>> THEN moving on to the next request.
> 
> There is nothing preventing from issuing a linked bio list. The only thing
> is that osd_read/write looks at the first bio for total size.
> If the first bio->bi_size does not specify the full length of the chain
> then we should add another parameter to osd_read/write for that.
> 
> The original idea was to specifically allow chained bios.
> 
> Please advise?

As passed to us from the block layer, there is nothing special about the 
size of the first bio, AFAIK.

This seems like a libosd bug?  If you want to support chained bio's, I 
would presume you would either walk the list and sum all sizes, or in 
some other way input the total request size?

	Jeff



