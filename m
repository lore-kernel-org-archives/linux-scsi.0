From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SAS transport class
Date: Tue, 6 Sep 2005 16:00:59 +0200
Message-ID: <20050906140059.GA1417@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A75@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56711 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964854AbVIFOBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 10:01:07 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A75@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 06, 2005 at 09:40:43AM -0400, James.Smart@Emulex.Com wrote:
> > +	parent = sas_port_lookup(grandparent, port);
> > +	if (!parent)
> > +		return NULL;
> 
> So this is odd... grandparent ?  why pass in port # (you should
> know the object already)?  why is channel skipping over / not
> associated with the local port ?

I didn't really want to need the drivers to keep around arrays
or lists of sas_port objects.

> What I would have expected is : 
> 
> - sas_port_alloc() to either:
>   a) also have a "channel" argument, which gets saved in the local
>      port.
>   -or-
>   b) The port # is actually used as the channel #.

I'm probably going to be with b).  It's on my TODO list for the same
time when I'm switching over to not pass in a target ID anymore in
favour of allocating one internal to the transport class.

> - sas_rport_alloc() becomes:
>     sas_rport_alloc(struct device *parent, uint id)
>   Where parent is the local port. You can still obtain the shost
>   via dev_to_shost(parent), and you can kill all that port searching
>   logic.

Actually the id will also go away.

> I'll point out, but not delve into - that you've avoided the target
> id bindings again, thus forcing the lldd's/adapters to maintain tables
> of port#/SASaddr to target id (if they care, and I believe enterprise
> storage will care!).  I can understand if you're going to eventually
> insert a generic abstraction layer for scsi's b/c/t/l addressing
> scheme, but since it's not here today, I expect you to hold SAS to the
> same "code sharing" level as FC.

Expect some updates in that area with the next code drop.

> Also, to deal with cable pulls, SAS reconfiguration and rescanning,
> I expect that you will need to add in the block/unblock functionality
> that the FC transport has.  [Note: we've seen an issue in the current
> FC design, so expect a transport update].

yes, this will be added.  Primary goal for this first stage of work
is to support a basic topology representation.  Stage two will be support
for all kinds of runtime-events, aka addition of new devices, remove of
devices including the unplug timer bits, and stage3 will support for a
full managment interface.  I hope parallel to that or shortly after
Adaptec or someone else will provide support for full host-base SAS
discovery aswell.

> > +void sas_rport_add(struct sas_rport *rport)
> > +{
> > ....
> > +	if (identify->device_type == SAS_END_DEVICE &&
> > +	    (identify->target_port_protocols &
> > +	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
> > +		scsi_scan_target(&rport->dev, rport->channel,
> > +				rport->id, ~0, 0);
> 
> I highly recommend the use of workqueues for the scan function as we
> did in the fc transport.

This will happen in stage two, as part of the support for run-time
addition of devices.
