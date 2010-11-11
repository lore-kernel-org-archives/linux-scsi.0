From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd
 numbered atomic_t counter
Date: Thu, 11 Nov 2010 15:55:49 -0600
Message-ID: <1289512549.2982.44.camel@mulgrave.site>
References: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
	 <1289490783.2982.33.camel@mulgrave.site>
	 <1289511475.2867.138.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab0KKVz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 16:55:56 -0500
In-Reply-To: <1289511475.2867.138.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, Mike Anderson <andmike@linux.vnet.ibm.com>

On Thu, 2010-11-11 at 13:37 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2010-11-11 at 09:53 -0600, James Bottomley wrote:
> > On Thu, 2010-11-11 at 02:46 -0800, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > This patch converts struct scsi_host->cmd_serial_number to a 'odd incremented by 2'
> > > atomic_t counter in scsi_cmd_get_serial(), and moves the host_lock held call in
> > > jgarzik's DEF_SCSI_QCMD() wrapper back into it's original location in scsi_dispatch_cmd().
> > 
> > Actually, no ... this isn't really a good idea; you're lengthening our
> > critical path here (an atomic costs a lot more than a simple add under
> > spinlock).
> >
> 
> Fair enough, but this is only less expensive with a spinlock w/p
> interrupts disabled, yes..?

It's less expensive than the explicit lock around just the serial
number, yes ... but if all use cases use an explicit lock, we can just
use a simple inc in there without bothering with atomics.

> > There are only a few drivers left that actually make use of a serial
> > number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
> > megaraid.
> > 
> 
> I am not exactly sure that qla4 or lpfc is on the list of LLDs that use
> and still need a cmd->serial_number for anything beyond simple printk()
> purposes..  
> 
> > So the next logical step seems to be eliminate the overloading of the
> > serial number zero value, which removes the last mid-layer use (dpt_i2o
> > seems to abuse this unnecessarily as well), then the serial number code
> > can be pushed down into the queuecommand routines of only those drivers
> > that actually use it.
> 
> Correct, this is what we where originally doing in the
> host_lock-less-for-37-v6 series here:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=commitdiff;h=72a72033661506ead54e0f366218fd0aef2e5339
> 
> The LLDs that ended up requring the explict calls for:
> 
> mpt2sas: Add scsi_cmd_get_serial() call and set SHT->queuecommand_unlocked()
> mpt/fusion: Add scsi_cmd_get_serial() call and set SHT->queuecommand_unlocked()
> dpt_i2o: Add scsi_cmd_get_serial() call
> eata: Add scsi_cmd_get_serial() call
> u14-34f: Add scsi_cmd_get_serial() call
> 
> > None of the modern ones seems to have a
> > legitimate use, so I think their uses can mostly be eliminated.
> 
> >From the above 5 LLDs, they all appear to be releated to using
> cmd->serial_number in their internal error recovery handling.
> 
> > Thus,
> > we might be able to get away with a simple queuecommand push down and
> > never bother with atomics for this (since it's unlikely the legacy users
> > would convert away from a lock wrapping their queuecommand routines).
> > 
> 
> Sounds good to me, but you will recall the last attempt to make
> scsi_cmd_get_serial() optional for the special case LLDs, that we
> started running quickly in the legacy usage of cmd->serial_number in
> scsi_softirq_done() and the side effects in scsi_try_to_abort_cmd(), who
> use is complex enough that we have not found a proper resolution
> sufficent to andmike discussed here:

Yes, that's what I meant by "eliminate the overloading of the serial
number zero value" above.  This needs fixing before the serial number
can be dumped for fast hba drivers.

James


> http://marc.info/?l=linux-scsi&m=128535319915212&w=2
> http://marc.info/?l=linux-scsi&m=128820726325009&w=2
> 
> Any takers..?  ;)
> 
> --nab
> 
> > James
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


