From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Fri, 03 Apr 2009 05:58:54 -0400
Message-ID: <49D5DDDE.9090407@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090403094909.GQ5178@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> This wont work, GFP_NOIO inside the queue lock. You are also only
> cloning the front bio, what happens if you have > 1 bio on the request?
> You seem to dequeue the request and complete all of it, regardless of
> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
> because of how the osd_req_{read,write} works, so I'd suggest storing
> the byte size in your osdblk_request and only completing that in
> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
> only dequeue if you manage to start an osd request for each of them,
> THEN moving on to the next request.

Thanks for the review.  Will fix...

	Jeff


