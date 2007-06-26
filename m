From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 17:35:30 -0700 (PDT)
Message-ID: <708898.53236.qm@web31811.mail.mud.yahoo.com>
References: <468039C0.4070109@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:25285 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752277AbXFZAfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 20:35:31 -0400
In-Reply-To: <468039C0.4070109@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> My thought was that SCSI core's role would only be to create the
> respective sysfs attributes (thus enforcing uniform naming of the
> attributes), but that the transport layer implementations are
> responsible to feed string representations there; in one way or another.

This way one gets cross-contamination of object properties.
But I guess SCSI Core doesn't have to be perfect, consistent
or complete.  Business-wise it's much better if it weren't.

> > and because it is a property of the SCSI Target,
> > not the SCSI device (struct scsi device).  And currently SCSI Core
> > has no representation of SCSI Targets.
> 
> And because SCSI targets are not represented in sysfs, I'd lazily add
> target-related information to the LU's sysfs representation.

LOL, okay. :-)

> Of course, if a representation of the target in sysfs is preferred, we
> should add this before tainting the LU's sysfs representation with
> attributes that belong to the target.

I didn't have sysfs/ in mind.  I had internal representation of
the external world (storage domain) in mind.  Then sysfs/ would
follow suit and represent the internal picture, thus representing
the physical world of the entities and their relationship in the
storage domain.  (Just like it is done in my SAS/SATL stack.)

I guess either way this is done sysfs->SCSI Core, or SCSI Core->sysfs,
it's all good for business.

> So, would people like targets reflected as sysfs devices ( = parent of
> any LU devices)?  We should be able to add or remove parent devices into

I had actually always wanted full scsi target support in SCSI Core first,
and then SCSI Core to discover the LUs (i.e. struct scsi_dev) and register
them with the block layer.

This greatly simplifies low(er) level transport storage stacks design
whereby the only entity "registered" with SCSI Core is the scsi target.

It also simplifies the SAM event model which currently needs to be
hackishly emulated by the transport stacks, as opposed to just
passing the event to SCSI Core where it belongs and let it handle it.

> sysfs device paths without breaking userspace, says Kay Sievers at the
> end of http://lkml.org/lkml/2007/6/8/491 .

That is an excellent write-up!

> > Ideally SCSI Core is presented with an opaque token (void *, unsigned long (long),
> > etc) which represents a target port, which it uses to send SPC commands
> > to the target to find out how many if any LUs the target has, INQUIRY them,
> > and then create struct scsi_dev for each LU.
> > 
> > When presented with this opaque token*, SCSI Core allocates and
> > initializes a struct scsi_target, whose children are LUs, later
> > to be discovered by SCSI Core.  SCSI Core then uses that opaque token
> > to ask the transport protocol layer to send commands to the I_T_L
> > nexus (WLUN or LUN if it knows it from previous discovery attempt).
> 
> Won't work with SBP-2/3.  There the LUs are discovered via IEEE 1212
> mechanisms (configuration ROM) rather than SPC.  Plus there is SBP-2/3
> login protocol.

And there are others too.  The model mentioned above isn't absolute.
It makes sense to leave a "backdoor" where transport stacks can register
an LU themselves, possibly pointing to an already registered scsi target
(opaque token).

   Luben

