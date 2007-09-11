From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH][RFC] Use bio markers for request callback
Date: Tue, 11 Sep 2007 12:49:13 -0400 (EDT)
Message-ID: <20070911.124913.59650277.k-ueda@ct.jp.nec.com>
References: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On Tue, 11 Sep 2007 12:44:46 +0200, Hannes Reinecke <hare@suse.de> wrote:
> this is a proposal for a different implementation of request  
> callbacks. The existing ->endio callback of a request is actually a  
> destructor function, to be called to terminate a request and free all  
> structures.
> 
> However, on certain occasions (like request-based multipathing) it is  
> desirable to have a callback function for a request which is called  
> right after the request is finished, ie in end_that_request_first()  
> before any bio->bi_endio callback is called.
> 
> So a simple solution for this is to clone the request and add a new  
> 'marker' bio in front of the bio list of the request. This callback  
> will be attached a structure in bi_private which keeps a pointer to  
> the cloned and the original request, thus serving as a callback for  
> the request itself.

Thank you for another idea for request-based multipath.

However, I disagree with the idea.
I think the design (bio->bi_end_io() completes a request) is complex
a little bit and is breaking layer stacking.
Also, I think that the design of completion handling by 2 hooks,
bio->bi_end_io() and rq->end_io(), makes error handing in dm-multipath
complex.
e.g. Even if we detect an error on the first bio->bi_end_io() hook,
     the request can't be retried until the second rq->end_io() hook
     is called, because the ownership of the request is still on
     low level drivers until the low level driver calls
     end_that_request_last().


Although this is just implementation issue, I think that the patch
can't handle leftover.
SCSI, scsi_end_request(), may have some leftovers in the request.
Then, the marker bio is freed in bio->bi_end_io() and the request
is resubmitted in SCSI level.  So the resubmitted request
doesn't have the marker bio any more.

Thanks,
Kiyoshi Ueda
