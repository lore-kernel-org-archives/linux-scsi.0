From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Thu, 20 Jan 2005 11:04:06 +0000
Message-ID: <20050120110406.GA32422@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F300@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9898 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262112AbVATLEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:04:08 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F300@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> >  o the host removal is still quite hackish and probably racy:
> >     - everything what's you're ding with FC_UNLOADING should 
> > be done in
> >       the midlayer where we already have a state machine for the
> >       Scsi_Host
> 
> There's only 2 uses for this flag...
> 
> - In the node state machine, which prevents upcalls to the midlayer
>   for port state changes and/or invoking scsi scan functions.
> 
>   As the driver must deal with FC nodes (remote ports) independently
>   of whether the SCSI layer (via scsi_host) is active on the adapter,
>   we need the functionality to block the scsi midlayer upcalls.
>   I don't see how this belongs in the midlayer....

The unloading is adapter-level, and Scsi_Host is a midlayer-managed
object.  So the scsi_scan_single_target you protected by FC_UNLOADING
will do the right thing called on a host that scsi_remove_host
has been called on.

For fc_remote_port_block/fc_remote_port_unblock/fc_remote_port_add
that should be true aswell, but as that's new code you've written
you should know it in more detail then me.

> - Stops new i/o issued via queuecommand.
> 
>   The check here can probably be removed as long as there's a guarantee
>   that there will be no queuecommand calls after scsi_remove_host
>   completes. I believe this to be true. The only question I had
>   concerns any in-progress scans when scsi_remove_host is called. Does
>   remove host cancel the scans (vs just depending on reference counts) ?

Currently it fails them, but doesn't cancel them in the sense of exiting
early.


> >     - target removal shouldn't happen from your remove method but via
> >       scsi_remove_host
> 
> Ok. Originally, this was thought to be more graceful than
> scsi_remove_host (less console messages). However, testing shows no
> discernable difference so we can easily do this.

What console messages do you see?  Looks like we'd have to add another
allowed state transition from BLOCKED?

> >  o the driver would benefit a _lot_ from driver private data in
> >    scsi_target, I think we should do that and basically get rid of
> >    phba->device_queue_hash
> 
> Doable - although this now requires yet another midlayer patch to allow
> host-private data to be allocated along with the target, and the 
> addition of target alloc/destroy callback functions. Note that the
> midlayer calling sequences for the scsi target, vs the scsi device,
> are rather interesting right now (slave alloc called before a target
> alloc would be called).

Yes, the allocation would need to be changed a little.  But hey, I don't
think we should block merging the driver on this one.  We'll probably
introduce it soon and I'll sign you up for testing that patch on the
lpfc drivewr when it's ready.

> >  o what about lpfc_target->rport?  This should probably better be in
> >    the fc_target structure, no?
> 
> Anything in lpfc_target would go into the scsi_target hostdata
> (not fc_target).

I meant fc_target_attrs actually, which is scsi_target transport-data.

The point here is that the rport is a transport-class transport object
that every driver fully converted to fc_transport needs, so it's better
in transport data aswell.

Now looking at lpfc_target given that the rport goes away we only
have the I/O counters left and the nodlist pointer.  The I/O counters
aren't really a driver thing and should probably move to the midlayer
which only leaves the nodelist as private data in the scsi_device.

Sounds like the way to go?

> >  o lpfc_target vs lpfc_nodelist.  I'd see these merged into a single
> >    structure.  In fact large parts of lpfc_nodelist should probably
> >    move into the transport class.
> 
> ?? lpfc_target would merge with scsi_target. lpfc_nodelist stays as is
> (and independent from the scsi_target).
 
> I disagree with moving the nodelist code (e.g. FC discovery state
> machines) into the transport. My opinion is this where you cross into
> an area that can be very hardware-dependent (some adapters do this
> completely within the adapter). I know that in our case, almost 1/2 of
> the states are induced by the way our driver must interact with our
> hardware. At this point, I don't see any benefits to taking this step.

OK.  I've just taken a short look at the state machine and those bits
I looked at looked generic enough.
