From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Sat, 30 Jun 2007 23:27:35 -0700 (PDT)
Message-ID: <725061.42209.qm@web31801.mail.mud.yahoo.com>
References: <4686CA8D.20504@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:41520 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751761AbXGAG1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jul 2007 02:27:36 -0400
In-Reply-To: <4686CA8D.20504@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> SAM itself speaks of the LUN as 8 bytes quantity as well as 64 bits
> quantity (and 2 bytes quantity as well as 16 bits quantity).  Of course
> whether this dualism should be exposed in an API is another question.

"64 bit quantity", the keyword here is "quantity", _not_ "integer".
Any "u64" variation means "integer" since it dictates a BE or LE
interpretation.  A mere "64 bit quantity" does not expose a BE or LE
bit ordering, and thus does not represent itself as an integer.

It is though one such for human-readability.  Ideally, you'd not want
to expose this in the representation.

> SAS defines the SAS address as fitting into eight bytes.  It furthermore
> defines the SAS address as a bitfield consisting of 4, 24, and 36 bits
> wide parts.  (And it defines the SAM object Target port identifier to be
> implemented as SAS address.)
> 
> [u8 tpid[MAX_SIZE] or u8 tpid[] or union tpid]

Notice that you've already moved down to a protocol layer, in this
case SAS and have decomposed the tpid as defined in its protocol.
Thus, you've moved too "deep" into the internal choice of what
a SAS tpid is which is only interesting for people generating
such entities, deep into the details of the _protocol_.

I doubt that your intention is to expose the _composition_ itself
of the port identifier for _each_ protocol to SCSI Core.

> Target Port Identifier is a property of Target Port.  This has nothing
> to do with transport protocols.

Yes, in OOP(aradigm) this is a "virtual property".

> Of course the size, source, deeper meaning, and hence potential
> human-readable representations of Target Port Identifier are transport
> protocol dependent.

Classic OOP design.

> I acknowledge that this is a practical problem
> which can easily be solved by /not/ storing tpid in midlayer's struct
> scsi_target, thus also eliminating the need for a tpid datatype in
> midlayer's API.

> Well, it reproduces it, hence "says" it; but you are of course right in
> that it does not /define/ it.
> 
> [...]
> > Ask yourself these questions: "What does SCSI Core provide?", "What should
> > SCSI Core provide?", "What should SCSI Core not provide?", "Why?".
> > Give good justifications to your answers.
> 
> Among else:  It should provide a framework which enables userspace to
> find the unique object identifiers (that are required to uniquely and
> persistently identify logical units) always in the same place.  (That's
> just my opinion.  Current userspace tools like e.g. udev scripts are
> adapted to hunt those identifiers down in various places, and this works
> too.)

This information can be had by using default SPC commands, issued by
specialized userspace tools.  For example the SG tools maintained by Doug.

I'd rather have SCSI Core provide just _service_, i.e. means of getting
at those properties, but _not_ providing the properties themselves, i.e.
by trying to find them or figure them out on it's own. (I.e. by itself
issuing commands and what not.)

Of course, some of those identifiers and what not can be easily had
and seen simply by looking at the sysfs tree exported by the
respective protocol, just like my SAS Stack does. An example
of a 1-1 sysfs representation of a SAS domain can be seen here:
http://marc.info/?l=linux-scsi&m=112629509826900&w=2

But this is the exception.  I'd opt for using the SG tools exclusively.

> I acknowledge that this can be accomplished by only passing string
> representations of identifiers through to midlayer.

Tpid and such should only exist in the respective protocol layers.
It should NOT be exposed to SCSI Core.  The only thing that should be
is an opaque token by which the protocol layer identifies which target
port SCSI Core wants the command sent to, the LUN should be
identified in the SCSI Command struct!

There is a nice summary of this "opaque token" idea in the commentary to
sas_slave_alloc()::sas_scsi_host.c, and in
sas_do_lu_discovery()::sas_discover.c in my SAS stack (out of tree).

Also if you take a look at struct sas_task you'd see where the LUN
is.

> I also agree that
> midlayer should contain as little transport-dependent details as
> possible, and that much of what I wrote in my previous post was contrary
> to that.  (And now back to driver debugging... :-)

I think that from the beginning you had some great ideas which are
still current.  It also seems (and has always been the case) that
you have good understanding of the SCSI Architecture Model which is
a good thing.

   Luben

