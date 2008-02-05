From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 5 Feb 2008 11:33:15 -0800 (PST)
Message-ID: <471033.35291.qm@web31813.mail.mud.yahoo.com>
References: <1202223716.3133.10.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202223716.3133.10.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org

--- On Tue, 2/5/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > I guess the same could be said for STGT and
> SCST,
> > > right?
> > > 
> > > You mean both of their kernel pieces are modular?
> 
> > > That's correct.
> > 
> > No, you know very well what I mean.
> > 
> > By the same logic you're preaching to include your
> > solution part of the kernel, you can also apply to
> > SCST.
> 
> Ah, but it's not ... the current patch is merely
> exporting an interface.
> The debate in STGT vs SCST is not whether to export an
> interface but
> where to draw the line.

"draw the line" -- I see.
BTW, what is wrong with "exporting the interface"?

What is wrong if both implementations are in the kernel
and then let the users and distros decide which one
they like best and use more?  It'll not be the fist time
this has happened in the kernel.  Both are actively
maintained.

It seems highly arbitrary to say: "X is in the kernel, Y
is not. If you want Y, just forget about it and fix X."
Give people choice at config time.

This is off topic anyway.

> You could also argue in the same vein that sd is redundant
> because a
> filesystem could talk directly to the device via /dev/sgX
> (in fact OSD
> based filesystems already do this).

Yes, I've mentioned this thing before on this list.  Oh, maybe 3
years ago.  This is why I had wanted for transport protocols
to export ... (oh, let's not get this off topic).

(Apparently it takes 3 years...)

> The argument is true,
> but misses
> the bigger picture that the interfaces exported by sd are
> more portable
> (apply to non-SCSI block devices) and easier to use.

It isn't quite the same thing.  It's like comparing
apples to oranges.

> 
> > > > Yes, for which the transport layer,
> implements the
> > > > scsi device node for the SES device.  It
> doesn't
> > > really
> > > > matter if the SCSI commands sent to the SES
> device go
> > > > over SGPIO or FC or SAS or Bluetooth or I2C,
> etc, the
> > > > transport layer can implement that and
> present the
> > > > /dev/sgX node.
> > > 
> > > But it does matter if the enclosure device
> doesn't
> > > speak SCSI.
> > 
> > Enclosure management isn't as simple as you're
> > portraying it here.  The enclosure management
> > device speaks either SES or SAF-TE.  The transport
> > protocol to access it could be SGPIO or I2C or...
> 
> Look, just read the spec; SGPIO is a bus for driving
> enclosures ...

I thought Serial General Purpose Input Output
(SGPIO) was a method to serialize general purpose
IO signals.

> it
> doesn't require SES or SAF-TE or even any SCSI
> protocol.

That's true.  And this is why I mentioned a couple
of emails ago to simply export a sgpio device node *IF*
this is what is needed.  Of course devices that use SGPIO
abstract it away for their functional purpose, e.g.
enclosures, LED, etc, and provide a more general way to
control it -- highly hardware specific on one side.

Your abstraction currently deals with "SES" devices
and I'd rather leave that to user-space.  Alternatively,
which I presume is what you're thinking, a HW specific
core would be using your "abstraction" to provide
some unified access to raw features, and that "unified
access" isn't defined anywhere, and would likely not
be.  Alternatively that "unified access" is things
like SES and SAF-TE, which is what vendors prefer
to export, or they prefer to drive this directly
via other means.

That is, I fail to see the kernel bloat, for things
that aren't necessary in the kernel.

If you want your abstraction to fly, it first needs
a common usage model to abstract, and the latter is
missing _from the kernel_.

Unless I don't know the details and you've been
asked to implement this for a single vendor's HW solution.

> > >  SGPIO
> > > isn't a SCSI protocol ... it's a general
> purpose
> > > serial bus protocol.
> > > It's pretty simple and register based, but it
> might (or
> > > might not) be
> > > accessible via a SCSI bridge.
> > 
> > I see.  You've just discovered SGPIO -- good for
> you.
> > 
> > At any rate, I told you already that what is needed
> > is not what you've provided but a _device node_
> > exported by the kernel, either a processor or
> > enclosure type.
> 
> Wrong ... we don't export non-SCSI devices as SCSI
> (with the single and
> rather annoying exception of ATA via SAT).

I didn't say you should do that.  I had already
mentioned that vendors export such controls
as either enclosure or processor type devices,
and this is why I told you that that is what
needs to be exported, which incidentally is
a device node of that type.

Without a common usage model already in the kernel
to abstract (e.g. sd for block device, since you brought
that up) your abstraction seems redundant and arbitrary.

Your kernel code already uses READ DIAGNOSTIC, etc,
and I'd rather leave that to user-space.

   Luben

