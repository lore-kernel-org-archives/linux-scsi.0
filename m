From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
 interface - revised
Date: Mon, 27 Oct 2008 13:12:01 +0900
Message-ID: <20081027131110Z.fujita.tomonori@lab.ntt.co.jp>
References: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>
	<20081024125449T.fujita.tomonori@lab.ntt.co.jp>
	<49043A7C.8030105@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59530 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYJ0EMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 00:12:39 -0400
In-Reply-To: <49043A7C.8030105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, seokmann.ju@qlogic.com, jens.axboe@oracle.com, James.Smart@Emulex.Com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Sun, 26 Oct 2008 11:38:04 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > CC'ed Jens,
> > 
> > On Wed, 22 Oct 2008 19:27:35 -0700
> > Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> > 
> >> And it seems like that the panic is happening due to the fact that  
> >> blk_delete_timer() is not called upon having completion of the service.
> >> In other words, the block layer calls blk_add_timer() prior to  
> >> dispatch the service but, it doesn't call blk_delete_timer() when it  
> >> returned.
> > 
> > Yeah, we need to call blk_delete_timer somewhere.
> > 
> > 
> >> Just for heck of it, I've tried out by adding blk_delete_timer() in  
> >> the ~/block/blk-exec.c:blk_end_sync_rq() and it seems fixes the problem.
> > 
> > I think blk_end_sync_rq() is not the good place. From the perspective
> > of bsg, we need to handle both blk_execute_rq_nowait and
> > blk_execute_rq.
> > 
> > 
> >> Seems like that there are APIs in the block layer that are call the  
> >> blk_delete_timer(), including,
> >> - blk_end_io()
> >> - __blk_end_request()
> >>
> >> Could you guide me what is right way to fix the problem?
> > 
> > Exporting blk_delete_timer is one option, but it doesn't look very
> > nice (since the block layer doesn't export any details about its timer
> > infrastructure), I think. Modifying blk_end_io() to make it usable for
> > requests via something like bsg might be better.
> > 
> > Anyway, we need to ask Jens.
> > 
> > Jens, fc people have working on fc pass through support via bsg, which
> > hooks bsg's request queue on fc transport objects (We did the similar
> > thing for sas transport).
> > 
> > We want the timeout feature for fc pass through and I think that it's
> > nice to use the block layer timeout feature for it. But the users of
> > bsg request queue don't need (or call) APIs such as
> > end_that_request_last to call blk_delete_timer internally. How should
> > these users call blk_delete_timer?
> 
> TOMO Hi
> If a command is queued by bsg to a scsi device, which is posible. Then
> blk_end_request() is called by scsi-ml. So it does work.

It doesn't work for bsg's scsi transport pass through stuff such as
SMP (sas management protocol, we already support) and FC. Virtually,
they don't use scsi-ml.


> I think that all block-queue consumers should call one of
> blk_end_request(),

This is kinda what I suggested in the previous mail but as I wrote,
some of them don't now.


> there are lots to choose from. We don't need
> a new API. It will work with or without data, and it does what
> you want.
