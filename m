From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 15:43:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:18778 "EHLO avexch01.qlogic.org")
	by vger.kernel.org with ESMTP id S262649AbUCOXmw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 18:42:52 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Sunday, March 14, 2004 6:49 AM, James Bottomley wrote:
> On Sun, 2004-03-14 at 03:24, Andrew Vasquez wrote:
> > -	.sg_tablesize		= SG_ALL,
> > +	.sg_tablesize		= 32,
> 
> Are you sure you want to do this?  It limits the maximum transfer size
> per command to 128k (on x86) which is a bit small for FC.
> 

Ideally, no we don't want to do this...how about sending down larger
individual SG entries, the ISP only limits the total transfer of a
command to 2^32-1 bytes ;)

On Sunday, March 14, 2004 7:00 AM, James Bottomley wrote:
> On Sun, 2004-03-14 at 09:51, Jens Axboe wrote:
> > The explanation of why this was done (request queue limitations,
> > huh?) sounded pretty bogus as well.
> 
> Actually, to be fair, I think he means the qlogic request queue, not
> the block one.
> 

Yes, the ISPs request queue is the rate-limiting factor.

> The Qla chips are rather weird in that they have a single issue
> queue (whose size you can vary) but whose entry formats are fixed.
> If I remember correctly, an initial command can have 4 SG elements,
> but a follow on entry can have 7 (not sure of the figures).  But
> anyway, large SG commands end up having to find multiple entries in
> this queue (and being a single issue queue for the entire card, it
> has to be mutexed while you search).  The more resources you need,
> the more difficult the search and the more contention you generate
> on the resource mutex.
> 

Our intention with the SG_ALL -> 32 sg_tablesize patch was to
strike an (artificial and static) balance between request-queue
resource usage and the commands that consume them.  Let me digress for
a moment.

Since the driver specifies SG_ALL for the sg_tablesize, from testing
(x86 and ppc64), we've seen at most 128 SG entries attached to a
command request of 512K bytes (4K page size * 128).  
For each of those 128 SG entries commands, the driver requires:

	o 18 request entries with a DMA mask set to 0xffffffff.

		(128 - 3) / 7 + 1

	o 26 request entries with a DMA mask set to ~0ULL.

		(128 - 2) / 5 + 1

taking the 64bit DMA mask, the following table shows a rough
approximation of the maximum number of outstanding commands with each
having 128 SG entries:

	RequestQ Size		Max. Outstanding Commands

		1024		39
		2048		78
		....		...
		8192		315
		....		...

That's not very many (albeit large transfer) commands outstanding at
any given time across all targets and luns.

As I had stated, our initial though was to reduce the sg_tablesize to
provide a 'better' balence of outstanding I/Os to a number of devices.
In the 6.x and 7.x series drivers, we've limited the sg_tablesize to
32, offering a max command transfer size of 128K (still assuming
page-size SG entries with no merging).  Again, for each of the 32 SG
entries commands, the driver requires:

	o 5 request entries with a DMA mask set to 0xffffffff.

		(32 - 3) / 7 + 1

	o 6 request entries with a DMA mask set to ~0ULL.

		(32 - 2) / 5

Again taking the 64bit DMA mask as an example:

	RequestQ Size		Max. Outstanding Commands

		1024		170
		2048		341
		....		...
		8192		1365
		....		...

Superficially, this seems like a 'better' solution...but...

On Sunday, March 14, 2004 7:31 AM, James Bottomley wrote:
> On Sun, 2004-03-14 at 10:18, Anton Blanchard wrote:

> > With 2.6.3 on a ppc64 box connected to a shark with 8 LUNs I could
> > easily consume all the request slots on the card. At this point we
> > spent 50% of the cpu bouncing into qla2x00_start_scsi, doing a
> > pci_map_sg realising it wont fit and doing a pci_unmap_sg.
> 
> Well, since the pool is fixed size, can't the driver do some rule of
> thumb check before it actually gets to the map_sg (perhaps even
> pre-reserve the slots before mapping)?
> 

Well, 'PATCH [2/15] qla2xxx: Track DSDs used by an SRB' was meant to
fix this problem of needlessly (and repeatedly) calling pci_map_sg()
during a resource shortage.

> If you think you don't know how many resource slots you'll need,
> that's in scsi_cmnd->request->nr_hw_segments (give or take, this is
> always guaranteed to be at or over the actual number dma_map_sg
> eventually returns).
>

I'm curious then, how does this value (nr_hw_segments) differ from
scsi_cmnd->use_sg?  

Basically what the above patch did was track (once) the total number
of SG entries required (return value from pci_map_sg()) so that if a
resouce shortage occurred, the command would be internally requeued
for later processing without the need to call pci_map_sg().

But from later emails...it's beginning to sound like a 'better' fix
would be to use the midlayer's own queueing mechanisms and strip out
the qla2xxx driver's legacy pending-queue infrastructure in favor or
returning:

On Sunday, March 14, 2004 2:27 PM, James Bottomley wrote:
> For dynamic resource situations we have the queuecommand return
> codes
> 
> SCSI_MLQUEUE_HOST_BUSY which means the entire host is temporarily
> out of resources and causes the mid layer to hold off all commands
> for that host until we get one back from any device on the host and
> 

from queuecommand().  The 8.x series driver inherited alot of the
queuing baggage created during driver development of [567].x to
address some deficiecies of earlier midlayer implementations (all of
which have been addressed in recent kernels).  I'll start to take a
look at tearing out the pending_q.

<If you made it this far>  Thanks everyone for all your feedback.

Regards,
Andrew Vasquez
