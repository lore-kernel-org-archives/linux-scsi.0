From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler
Date: Mon, 3 Sep 2007 09:45:49 +0200
Message-ID: <20070903074549.GJ4253@kernel.dk>
References: <20070831.183955.122623475.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25176 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbXICHuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2007 03:50:07 -0400
Content-Disposition: inline
In-Reply-To: <20070831.183955.122623475.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Fri, Aug 31 2007, Kiyoshi Ueda wrote:
> Hello,
> 
> This set of patches changes request completion interface
> between device drivers and block layer to 1 step procedure
> from current 2 step procedures using end_that_request_{first/chunk}
> and end_that_request_last().
> 
> This change allows request-based multipath to hook in before
> completing each chunk of request, check errors for it and
> retry it using another path if error is detected.
> 
> Summaries of each patch are below:
>   1/7: add new request completion interface, blk_end_request()
>   2/7: add some macros to get the size of request in bytes
>   3/7: convert normal drivers to use blk_end_request()
>   4/7: convert odd drivers like cciss/cpqarray/xsysace to use
>        blk_end_request()
>   5/7: convert ide-cd (cdrom_newpc_intr) to use blk_end_request()
>   6/7: remove/unexport no longer needed end_that_request_*
>   7/7: change rq->end_io to cover request completion as a whole
> 
> I have tested the patch on two machines, ia64+QLA1280+QLA2200
> and x86_64+SATA+IDE-CDROM.
> I can't test other device drivers for which I don't have hardware.
> So testing help and any comments would be very much appreciated.
> 
> The interface change causes code modifications of *ALL DEVICE DRIVERS*
> which are using end_that_request_{first/chunk/last} to complete request.
> But it should not affect the behavior.
> 
> Please review and apply if no problem.
> This patch-set should be applied on top of 2.6.23-rc3-mm1.
> 
> 
> BACKGROUND
> ==========
> The patch is necessary to allow device stacking at request level,
> that is request-based device-mapper multipath.
> Currently, device-mapper is implemented as a stacking block device
> at BIO level.  OTOH, request-based DM will stack at request level to
> allow better multipathing decision.
> To allow device stacking at request level, the completion procedure
> need to provide a hook for it.
> For example, dm-multipath has to check errors and retry with other
> paths if necessary before returning the I/O result to upper layer.
> struct request has 'end_io' hook currently.  But it's called at
> the very late stage of completion handling where the I/O result
> is already returned to the upper layer.
> So we need something here.
> 
> The first approach to hook in completion of each chunk of request
> was adding a new rq->end_io_first() hook and calling it on the top
> of __end_that_request_first().
>   - http://marc.theaimsgroup.com/?l=linux-scsi&m=115520444515914&w=2
>   - http://marc.theaimsgroup.com/?l=linux-kernel&m=116656637425880&w=2
> However, Jens pointed out that redesigning rq->end_io() as a full
> completion handler would be better:
> 
> On Thu, 21 Dec 2006 08:49:47 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Ok, I see what you are getting at. The current ->end_io() is called when
> > the request has fully completed, you want notification for each chunk
> > potentially completed.
> > 
> > I think a better design here would be to use ->end_io() as the full
> > completion handler, similar to how bio->bi_end_io() works. A request
> > originating from __make_request() would set something ala:
> .....
> > instead of calling the functions manually. That would allow you to get
> > notification right at the beginning and do what you need, without adding
> > a special hook for this.
> 
> I thought his comment was reasonable.
> So I modified the patches based on his suggestion.
> 
> 
> WHAT IS CHANGED
> ===============
> The change is basically illustlated by the following pseudo code:
> 
> [Before]
>   if (end_that_request_{first/chunk} succeeds) { <-- completes bios
>      <do something driver specific>
>      end_that_request_last() <-- calls end_io()
>      <the request is free from the driver>
>   } else {
>      <the request was incomplete, retry for leftover or ignoring>
>   }
> 
> [After]
>   if (blk_end_request() succeeds) { <-- calls end_io(), completes bios
>      <the request is free from the driver>
>   } else {
>      <the request was incomplete, retry for leftover or ignoring>
>   }
> 
> 
> In detail, request completion procedures are changed like below.
> 
> [Before]
>   o 2 steps completion using end_that_request_{first/chunk}
>     and end_that_request_last().
>   o Device drivers have ownership of a request until they
>     call end_that_request_last().
>   o rq->end_io() is called at the last stage of
>     end_that_request_last() for some block layer codes need
>     specific request handling when completing it.
> 
> [After]
>   o 1 step completion using blk_end_request().
>     (end_that_request_* are no longer used from device drivers.)
>   o Device drivers give over ownership of a request
>     when calling blk_end_request().
>     If it returns 0, the request is completed.
>     If it returns 1, the request isn't completed and
>     the ownership is returned to the device driver again.
>   o rq->end_io() is called at the top of blk_end_request() to
>     allow to hook all parts of request completion.
>     Existing users of rq->end_io() must be changed to do
>     all parts of request completion.
> 
> 
> EXAMPLE CODE
> ============
> Request-based Device-mapper multipath patch-set is attached as appendix,
> although it still needs some work and isn't ready for review.
> It checks error of a request and retries the request using other paths
> if error is detected, before completing bios in the request.
> (See clone_end_request() in appendix#1.)

This looks good, thanks for following up on this! I've replied with
comments on changes for the core bits, the interface I quite agree with.
So if you fix up the things I ask for, I'll merge this up.

-- 
Jens Axboe

