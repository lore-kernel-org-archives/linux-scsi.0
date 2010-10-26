From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Tue, 26 Oct 2010 22:50:50 +0000
Message-ID: <1288133450.8283.723.camel@mulgrave.site>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
	 <20101021150840.GA24309@linux.vnet.ibm.com>
	 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
	 <1288132071.8283.689.camel@mulgrave.site>
	 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0JZWu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 18:50:58 -0400
In-Reply-To: <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, 2010-10-26 at 15:34 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2010-10-26 at 17:27 -0500, James Bottomley wrote:
> > On Tue, 2010-10-26 at 15:08 -0700, Nicholas A. Bellinger wrote:
> > > [PATCH] scsi: Add SCSI_EH_SOFTIRQ_DONE usage
> > > 
> > > This patch introduces a SCSI_EH_SOFTIRQ_DONE flag that is set in scsi_softirq_done()
> > > from block soft_irq context that is used to signal when scsi_try_to_abort_cmd() should
> > > be calling __scsi_try_to_abort_cmd() for a timed out struct scsi_cmnd instead of
> > > returning SUCCESS via checking only blk_test_rq_complete().  This is done because
> > > blk_rq_timed_out_timer() calls blk_mark_rq_complete() before blk_rq_timed_out() ->
> > > struct request_queue->rq_timed_out_fn().
> > 
> > This is getting pretty far off into the weeds.  I think the first step
> > should be queue lock push down into ->queuecommand.  This would still
> > necessitate locking around the serial number.
> 
> Hmmm, I am not sure I understand what you mean here.  My understanding
> is that the whole point of the series was to remove any locking around
> the serial number in order to make scsi_dispatch_cmd() lockless,
> right..?

The point is that several things have to happen for that to be a
reality.  The easiest and most obvious thing is lock push down in
->queuecommand.

The next is most likely serial number elimination.

But the point is that we don't have to do the whole thing all at once
(and spend months trying to get the series right).

> That is what the current patch series already does, in that it makes the
> use of cmd->serial_number optional and requires LLDs who use this for
> anything beyond an informational purpose to explictly call
> scsi_cmd_get_serial(). 

OK, so this patch is a corner case where the error handler is using the
serial number value to deduce something the block layer already knows
(whether the command completed or not). I don't think introducing a
substitute flag is the right way, the information should just be
extracted properly.

But arguments about this don't have to impede the lock push down.

James

> > The next step might be
> > serial number elimination/reduction which might need to address issues
> > like this (or not ... block already knows the information, there's not
> > really much need for us to track it twice).  There might also be other
> > lock aquisition reduction as part of step 2.
> > 
> 
> Correct, with this series cmd->serial_number still exists, but is
> completly optional and no longer used for any SCSI ML functionality.  It
> remains used only beyond an information purpose by a handful of LLDs in
> their legacy error recovery handling, which have been updated in this
> series to explictly call scsi_cmd_get_serial().
> 
> So other than those handful special cases, all of the LLDs included in
> the series which explict set SHT->unlocked_qcmd=1 to run in
> scsi_dispatch_cmd() lockless mode will no longer need ->serial_number.
> 
> --nab
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


