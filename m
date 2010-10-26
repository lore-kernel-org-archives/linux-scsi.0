From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Tue, 26 Oct 2010 16:31:58 -0700
Message-ID: <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
	 <20101021150840.GA24309@linux.vnet.ibm.com>
	 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
	 <1288132071.8283.689.camel@mulgrave.site>
	 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
	 <1288133450.8283.723.camel@mulgrave.site>
	 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
	 <1288134713.19649.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.210]:39486 "HELO
	nm16-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757691Ab0JZXgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 19:36:55 -0400
In-Reply-To: <1288134713.19649.11.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, 2010-10-26 at 18:11 -0500, James Bottomley wrote:
> On Tue, 2010-10-26 at 16:00 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2010-10-26 at 22:50 +0000, James Bottomley wrote:
> > > On Tue, 2010-10-26 at 15:34 -0700, Nicholas A. Bellinger wrote:
> > > > On Tue, 2010-10-26 at 17:27 -0500, James Bottomley wrote:
> > > > > On Tue, 2010-10-26 at 15:08 -0700, Nicholas A. Bellinger wrote:
> > > > > > [PATCH] scsi: Add SCSI_EH_SOFTIRQ_DONE usage
> > > > > > 
> > > > > > This patch introduces a SCSI_EH_SOFTIRQ_DONE flag that is set in scsi_softirq_done()
> > > > > > from block soft_irq context that is used to signal when scsi_try_to_abort_cmd() should
> > > > > > be calling __scsi_try_to_abort_cmd() for a timed out struct scsi_cmnd instead of
> > > > > > returning SUCCESS via checking only blk_test_rq_complete().  This is done because
> > > > > > blk_rq_timed_out_timer() calls blk_mark_rq_complete() before blk_rq_timed_out() ->
> > > > > > struct request_queue->rq_timed_out_fn().
> > > > > 
> > > > > This is getting pretty far off into the weeds.  I think the first step
> > > > > should be queue lock push down into ->queuecommand.  This would still
> > > > > necessitate locking around the serial number.
> > > > 
> > > > Hmmm, I am not sure I understand what you mean here.  My understanding
> > > > is that the whole point of the series was to remove any locking around
> > > > the serial number in order to make scsi_dispatch_cmd() lockless,
> > > > right..?
> > > 
> > > The point is that several things have to happen for that to be a
> > > reality.  The easiest and most obvious thing is lock push down in
> > > ->queuecommand.
> > > 
> > 
> > Ok, can you please explain to me what you mean here..?  As I really
> > thought we came to consensus that:
> > 
> > *) running in unlocked_qcmd=1 was to be made the default for LLDs using
> > the legacy optimization of ->queuecommand() -> unlock() ->
> > do_some_lld_work() -> lock() -> return to scsi_dispatch_cmd()
> 
> So I was thinking no flag for changing locking behaviour ... simply push
> the lock down into the ->queuecommand routines that need it, like we did
> for the error handler.
> 

Yes, I think this makes alot of sense as the next step beyond what has
been currently proposed so far with these series for .37.  The main bit
with this approach is that is requires touching every single legacy
LLD's ->queuecommand() which honestly is a bit scary on some of the
legacy stuff.  This instead of the approach this series has taken so far
to simply to still be able to use the LLDs we are unsure about running
in host_lock less mode in mainline+ out of tree (who do not muck with
host_lock in ->queuecommand of course :) will still 'just work'.

Its hard to say how to say which approach is better at this point, but I
am still leaning toward IMHO the unlocked_qcmds=1 would be the safest
incremental first step for .37, and then do the second series for .38 to
get any LLD needing host_lock using it directly inside of their
->queuecommand().

This sounds like a pretty reasonable compromise that I think is slightly
less risky for the LLDs with the ghosts and cob-webs hanging off of
them.

What do you think..?

--nab

> James
> 
> > *) For the mpt-fusion / mpt2sas drivers which did not use the legacy
> > optimization, but Tim Chen has tested with the former and I am awaiting
> > an ACK from LSI on the latter.
> > 
> > *) All other drivers will function with host_lock held (eg: legacy mode)
> > in scsi_dispatch_cmd().
> > 
> > *) All drivers using cmd->serial_number for anything beyond an
> > informational purpose converted to use scsi_cmd_get_serial().
> > 
> > > The next is most likely serial number elimination.
> > > 
> > > But the point is that we don't have to do the whole thing all at once
> > > (and spend months trying to get the series right).
> > 
> > Not exactly correct, we have the whole thing ready right now with libfc
> > running unlocked_qcmd=0 legacy mode.
> > 
> > Once I verify START_STOP case in scsi_error.c, I am happy to respin a
> > mergeable tree from linus HEAD for you to pull ASAP.
> > 
> > > 
> > > > That is what the current patch series already does, in that it makes the
> > > > use of cmd->serial_number optional and requires LLDs who use this for
> > > > anything beyond an informational purpose to explictly call
> > > > scsi_cmd_get_serial(). 
> > > 
> > > OK, so this patch is a corner case where the error handler is using the
> > > serial number value to deduce something the block layer already knows
> > > (whether the command completed or not). I don't think introducing a
> > > substitute flag is the right way, the information should just be
> > > extracted properly.
> > > 
> > 
> > Well, according to andmike this is two corner cases that are a result of
> > the drop-host_lock-v4 series using only blk_test_rq_complete() in
> > scsi_try_to_abort_cmd(), which will be true because of:
> > 
> > blk_rq_timed_out_timer() ->  blk_mark_rq_complete()
> > 
> > > But arguments about this don't have to impede the lock push down.
> > > 
> > 
> > Sure, but I assume you mean the lock push down only for the legacy LLDs
> > that are not already internally unlocking host_lock in
> > SHT->queuecommand() in mainline code right..?  
> > 
> > --nab
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

