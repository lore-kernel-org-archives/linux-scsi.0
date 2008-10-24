From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
 interface - revised
Date: Fri, 24 Oct 2008 12:54:23 +0900
Message-ID: <20081024125449T.fujita.tomonori@lab.ntt.co.jp>
References: <51A5EBA1-15ED-4568-98B1-824B52D6F4F6@qlogic.com>
	<20081020223617E.fujita.tomonori@lab.ntt.co.jp>
	<32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54057 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYJXDzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 23:55:43 -0400
In-Reply-To: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com

CC'ed Jens,

On Wed, 22 Oct 2008 19:27:35 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> And it seems like that the panic is happening due to the fact that  
> blk_delete_timer() is not called upon having completion of the service.
> In other words, the block layer calls blk_add_timer() prior to  
> dispatch the service but, it doesn't call blk_delete_timer() when it  
> returned.

Yeah, we need to call blk_delete_timer somewhere.


> Just for heck of it, I've tried out by adding blk_delete_timer() in  
> the ~/block/blk-exec.c:blk_end_sync_rq() and it seems fixes the problem.

I think blk_end_sync_rq() is not the good place. From the perspective
of bsg, we need to handle both blk_execute_rq_nowait and
blk_execute_rq.


> Seems like that there are APIs in the block layer that are call the  
> blk_delete_timer(), including,
> - blk_end_io()
> - __blk_end_request()
> 
> Could you guide me what is right way to fix the problem?

Exporting blk_delete_timer is one option, but it doesn't look very
nice (since the block layer doesn't export any details about its timer
infrastructure), I think. Modifying blk_end_io() to make it usable for
requests via something like bsg might be better.

Anyway, we need to ask Jens.

Jens, fc people have working on fc pass through support via bsg, which
hooks bsg's request queue on fc transport objects (We did the similar
thing for sas transport).

We want the timeout feature for fc pass through and I think that it's
nice to use the block layer timeout feature for it. But the users of
bsg request queue don't need (or call) APIs such as
end_that_request_last to call blk_delete_timer internally. How should
these users call blk_delete_timer?
