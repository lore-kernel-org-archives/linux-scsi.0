From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 15 Mar 2004 22:37:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079408273.1804.399.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:14232 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262728AbUCPDiQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 22:38:16 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-03-15 at 18:43, Andrew Vasquez wrote:
> I'm curious then, how does this value (nr_hw_segments) differ from
> scsi_cmnd->use_sg?  

OK, here's a potted version of what goes on:

the block layer, when merging keeps two counters of request segments:

nr_phys_segments and nr_hw_segments.  The counts are slightly inaccurate
for efficiency, but guaranteed not to go over max_phys_segments and
max_hw_segments respectively (the latter is what sg_tablesize becomes).

max_phys_segments counts the size of the *input* sgtable (the one the
mid layer).  The mid layer (in scsi_alloc_sgtable) allocates enough
space for a table of nr_phys_segments elements.  Then we map the request
from the block layer (blk_rq_map_sg) which fills them in with the
physical pages.  blk_rq_map_sg() does an exact count of physical
segments and may find additional cases where pages are actually adjacent
and so can be merged, so the value it returns (which is what is put in
cmd->use_sg) is <= nr_phys_segments.  However, you don't care about this
part, the mid-layer does it all for you (well, except that
max_phys_segments is fixed in the mid-layer at 128, which means that
your sgtable can be in practice never more than 128 elements).

When you map the sgtable for use on by the HBA, using dma_map_sg(), the
bus physical addresses are filled in.  If the platform has no IOMMU,
this is usually simply the memory physical addresses and
nr_phys_segments == nr_hw_segments.

However, if there is an IOMMU in the system it may be able to take non
adjacent pages in physical memory and remap them to be adjacent in bus
physical address space.  This is called virtual merging and when it
happens, the size of the sgtable you get out of dma_map_sg shrinks.  The
size it shrinks down to is always <= nr_hw_segments (because the way the
iommu does the mapping has been parametrised for the block layer). 
Thus, the number of elements the driver will have to allocate is always
<= nr_hw_segments.

> But from later emails...it's beginning to sound like a 'better' fix
> would be to use the midlayer's own queueing mechanisms and strip out
> the qla2xxx driver's legacy pending-queue infrastructure in favor or
> returning:


Yes.

> On Sunday, March 14, 2004 2:27 PM, James Bottomley wrote:
> > For dynamic resource situations we have the queuecommand return
> > codes
> > 
> > SCSI_MLQUEUE_HOST_BUSY which means the entire host is temporarily
> > out of resources and causes the mid layer to hold off all commands
> > for that host until we get one back from any device on the host and
> > 
> 
> from queuecommand().  The 8.x series driver inherited alot of the
> queuing baggage created during driver development of [567].x to
> address some deficiecies of earlier midlayer implementations (all of
> which have been addressed in recent kernels).  I'll start to take a
> look at tearing out the pending_q.

Thanks,

James


