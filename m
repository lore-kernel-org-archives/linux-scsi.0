From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Tue, 18 Jan 2005 17:43:47 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F300@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23727 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261457AbVARWoJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 17:44:09 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, January 17, 2005 5:23 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
> 
> 
> I started to look through it, here's some thing I found so far:
> 
>  o there's still a ->proc_info method which we don't want for 
> new drivers

OK.

>  o the host removal is still quite hackish and probably racy:
>     - everything what's you're ding with FC_UNLOADING should 
> be done in
>       the midlayer where we already have a state machine for the
>       Scsi_Host

There's only 2 uses for this flag...

- In the node state machine, which prevents upcalls to the midlayer
  for port state changes and/or invoking scsi scan functions.

  As the driver must deal with FC nodes (remote ports) independently
  of whether the SCSI layer (via scsi_host) is active on the adapter,
  we need the functionality to block the scsi midlayer upcalls.
  I don't see how this belongs in the midlayer....

- Stops new i/o issued via queuecommand.

  The check here can probably be removed as long as there's a guarantee
  that there will be no queuecommand calls after scsi_remove_host
  completes. I believe this to be true. The only question I had
  concerns any in-progress scans when scsi_remove_host is called. Does
  remove host cancel the scans (vs just depending on reference counts) ?

>     - target removal shouldn't happen from your remove method but via
>       scsi_remove_host

Ok. Originally, this was thought to be more graceful than
scsi_remove_host (less console messages). However, testing shows no
discernable difference so we can easily do this.

>  o the driver would benefit a _lot_ from driver private data in
>    scsi_target, I think we should do that and basically get rid of
>    phba->device_queue_hash

Doable - although this now requires yet another midlayer patch to allow
host-private data to be allocated along with the target, and the 
addition of target alloc/destroy callback functions. Note that the
midlayer calling sequences for the scsi target, vs the scsi device,
are rather interesting right now (slave alloc called before a target
alloc would be called).

To be honest - I don't think the gain will be that large. There are
really only 5 elements that are target specific (e.g. lpfc_target),
3 of them stats counters. (Note: this has the assumption that nodes
are not combined with scsi targets).

device_queue_hash is used whenever we have to look up entries by
target id. In general, we used this mainly in the eh_xxx routines,
but I guess they can take a little longer to search for the node
associated to the target id.

>  o what about lpfc_target->rport?  This should probably better be in
>    the fc_target structure, no?

Anything in lpfc_target would go into the scsi_target hostdata
(not fc_target).

>  o lpfc_target vs lpfc_nodelist.  I'd see these merged into a single
>    structure.  In fact large parts of lpfc_nodelist should probably
>    move into the transport class.

?? lpfc_target would merge with scsi_target. lpfc_nodelist stays as is
(and independent from the scsi_target).

I disagree with moving the nodelist code (e.g. FC discovery state
machines) into the transport. My opinion is this where you cross into
an area that can be very hardware-dependent (some adapters do this
completely within the adapter). I know that in our case, almost 1/2 of
the states are induced by the way our driver must interact with our
hardware. At this point, I don't see any benefits to taking this step.

>  o the memory allocation for non-I/O path stilled looked 
> total overkill
>    to me, but it seems you're doing an awfull lot from the 
> interrupt handler
>    still.  Wouldn't it be easier to do much of it from process context
>    via the kernel thread?

Yes - we're still looking at the memory allocations outside of the i/o
path and expected to resolve it while addressing new comments (such as
these :).  There's a couple of issues we're addressing relative to
calls made in the interrupt handler, so - yes, well move much of this
over to the kernel thread.

-- James S
