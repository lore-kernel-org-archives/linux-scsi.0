From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Mon, 4 Feb 2008 21:35:40 -0800 (PST)
Message-ID: <150265.33450.qm@web31808.mail.mud.yahoo.com>
References: <1202186263.3096.183.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:21649 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756155AbYBEFfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 00:35:41 -0500
In-Reply-To: <1202186263.3096.183.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>

--- On Mon, 2/4/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > --- On Mon, 2/4/08, James Bottomley
> <James.Bottomley@HansenPartnership.com> wrote:
> > > On Mon, 2008-02-04 at 18:01 -0800, Luben Tuikov
> wrote:
> > > > --- On Mon, 2/4/08, James Bottomley
> > > <James.Bottomley@HansenPartnership.com>
> wrote:
> > > > > > > The enclosure misc device is
> really
> > > just a
> > > > > library providing
> > > > > > > sysfs
> > > > > > > support for physical
> enclosure devices
> > > and their
> > > > > > > components.
> > > > > > 
> > > > > > Who is the target audience/user of
> those
> > > facilities?
> > > > > > a) The kernel itself needing to
> read/write
> > > SES pages?
> > > > > 
> > > > > That depends on the enclosure
> integration, but
> > > right at the
> > > > > moment, it
> > > > > doesn't
> > > > 
> > > > Yes, I didn't suspect so.
> > > > 
> > > > > 
> > > > > > b) A user space application using
> sysfs to
> > > read/write
> > > > > >    SES pages?
> > > > > 
> > > > > Not an application so much as a user. 
> The idea
> > > of sysfs is
> > > > > to allow
> > > > > users to get and set the information in
> addition
> > > to
> > > > > applications.
> > > > 
> > > > Exactly the same argument stands for a
> user-space
> > > > application with a user-space library.
> > > > 
> > > > This is the classical case of where it is
> better to
> > > > do this in user-space as opposed to the
> kernel.
> > > > 
> > > > The kernel provides capability to access the
> SES
> > > > device.  The user space application and
> library
> > > > provide interpretation and control.  Thus if
> the
> > > > enclosure were upgraded, one doesn't
> need to
> > > > upgrade their kernel in order to utilize the
> new
> > > > capabilities of the SES device.  Plus
> upgrading
> > > > a user-space application is a lot easier
> than
> > > > the kernel (and no reboot necessary).
> > > 
> > > The implementation is modular, so it's remove
> and
> > > insert ...
> > 
> > I guess the same could be said for STGT and SCST,
> right?
> 
> You mean both of their kernel pieces are modular? 
> That's correct.

No, you know very well what I mean.

By the same logic you're preaching to include your
solution part of the kernel, you can also apply to
SCST.

> > LOL, no seriously, this is unnecessary kernel bloat,
> > or rather at the wrong place (see below).
> > 
> > > 
> > > > Consider another thing: vendors would really
> like
> > > > unprecedented access to the SES device in
> the
> > > enclosure
> > > > so as your ses/enclosure code keeps state it
> would
> > > > get out of sync when vendor user-space
> enclosure
> > > > applications access (and modify) the SES
> device's
> > > > pages.
> > > 
> > > The state model doesn't assume nothing else
> will alter
> > > the state.
> > 
> > But it would be trivial exercise to show that an
> > inconsistent state can be had by modifying pages
> > of the SES device directly from userspace bypassing
> > your implementation.
> 
> I don't think so ... if you actually look at the code,
> you'll see it
> doesn't really have persistent state for the enclosure.
> 
> > > > You can test this yourself: submit a patch
> > > > that removes SES /dev/sgX support; advertise
> your
> > > > ses/class solution and watch the fun.
> > > > 
> > > > > > At the moment SES device
> management is done
> > > via
> > > > > > an application (user-space) and a
> user-space
> > > library
> > > > > > used by the application and
> /dev/sgX to send
> > > SCSI
> > > > > > commands to the SES device.
> > > > > 
> > > > > I must have missed that when I was
> looking for
> > > > > implementations; what's
> > > > > the URL?
> > > > 
> > > > I'm not aware of any GPLed ones.  That
> doesn't
> > > > necessarily mean that the best course of
> action is
> > > > to bloat the kernel.  You can move your
> ses/enclosure
> > > > stuff to a user space application library
> > > > and thus start a GPLed one.
> > > 
> > > Certainly ... patches welcome.
> > 
> > I've non at the moment, plus I don't think
> you'd be
> > the point of contact for a user-space SES library.
> > Unless of course you've already started something
> up
> > on sourceforge.
> > 
> > Really, such an effort already exists: it is called
> > sg_ses(8).
> > 
> > > 
> > > > > But, if we have non-scsi enclosures to
> integrate,
> > > that
> > > > > makes it harder
> > > > > for a user application because it has
> to know all
> > > the
> > > > > implementations.
> > > > 
> > > > So does the kernel.  And as I pointed out
> above, it
> > > > is a lot easier to upgrade a user-space
> application
> > > and
> > > > library than it is to upgrade a new kernel
> and having
> > > > to reboot the computer to run the new
> kernel.
> > > 
> > > No, think again ... it's easy for SES based
> enclosures
> > > because they have
> > > a SCSI transport.  We have no transport for SGPIO
> based
> > > enclosures nor
> > > for any of the other more esoteric ones.
> > 
> > Yes, for which the transport layer, implements the
> > scsi device node for the SES device.  It doesn't
> really
> > matter if the SCSI commands sent to the SES device go
> > over SGPIO or FC or SAS or Bluetooth or I2C, etc, the
> > transport layer can implement that and present the
> > /dev/sgX node.
> 
> But it does matter if the enclosure device doesn't
> speak SCSI.

Enclosure management isn't as simple as you're
portraying it here.  The enclosure management
device speaks either SES or SAF-TE.  The transport
protocol to access it could be SGPIO or I2C or...

>  SGPIO
> isn't a SCSI protocol ... it's a general purpose
> serial bus protocol.
> It's pretty simple and register based, but it might (or
> might not) be
> accessible via a SCSI bridge.

I see.  You've just discovered SGPIO -- good for you.

At any rate, I told you already that what is needed
is not what you've provided but a _device node_
exported by the kernel, either a processor or
enclosure type.

> > Case in point: the protocol FW running on the ASIC
> > provides this capability so really the LLDD would
> > only see a the pure SCSI SES or processor device and
> > register that with the kernel.  At which point no new
> > kernel bloat is required.
> > 
> > Your code doesn't quite do that at the moment as
> it
> > actually goes further in to read and present SES
> pages.
> > Ideally it would simply provide capability for
> transport
> > layers to register a SCSI device of type SES, or
> processor.
> 
> Yes, it provides a glue between the enclosure services and
> the SES
> protocol.

You're jumping over layers here.

And that's not what's needed.  What is needed
is an instrumentation by the kernel to present the
enclosure device as a device node to user space
so that general utilities tools, like for example
sg_ses(8) can work with it.

Your solution seems to be interpreting SES in the
kernel and this is really unwieldy. 

Just provide the device node to user space.
You shouldn't have to interpret SES in the kernel
as you're currently doing since the kernel itself
has no use of it.

> > Architecturally, the LLDD/transport layer would
> register
> > the SGPIO device on one end with the SGPIO layer and
> on
> > the other end as a SCSI SES/processpr device.  After
> that
> > sg_ses(8) or sglib, fits the bill for user space
> applications.
> 
> That's possible, but none of these layers exist yet ...
> although I think
> (assuming I can find a SGPIO enclosure) that SGPIO might be
> next.

Vendors prefer to abstract the transport protocol
in HW/FW so that to ULD the device is of
type processor or enclosure.

This makes it easy for the vendor (in terms of
support) and for the customer (in terms of
usability).

> 
> > > That's not to say it can't be done, but
> it does
> > > mean that it can't be
> > > completely userspace.
> > 
> > See previous paragraph.
> > 
> > > 
> > > > > A sysfs framework on the other hand is
> a
> > > universal known
> > > > > thing for the
> > > > > user applications.
> > > > 
> > > > So would a user-space ses library, a la
> libses.so.
> > > > 
> > > > > > One could have a very good
> argument to not
> > > bloat
> > > > > > the kernel with this but leave it
> to a
> > > user-space
> > > > > > application and a library to do
> all this and
> > > > > > communicate with the SES device
> via the
> > > kernel's
> > > > > /dev/sgX.
> > > > > 
> > > > > The same thing goes for other esoteric
> SCSI
> > > infrastructure
> > > > > pieces like
> > > > > cd changers.  On the whole, given that
> ATA is
> > > asking for
> > > > > enclosure
> > > > > management in kernel, it makes sense to
> > > consolidate the
> > > > > infrastructure
> > > > > and a ses ULD is a very good test bed.
> > > > 
> > > > What is wrong with exporting the SES device
> as
> > > /dev/sgX
> > > > and having a user-space application and
> library to
> > > > do all this?
> > > 
> > > How do you transport the enclosure commands over
> /dev/sgX? 
> > > Only SES has
> > > SCSI command encapsulation ... the rest won't
> even be
> > > SCSI targets ...
> > 
> > What is the protocol of those "rest" that
> you talk about?
> 
> At the moment it looks to be SES, SGPIO and AHCI.

You should separate "what it talks" by "how it
gets there".

> 
> > At any rate, this capability lies in the kernel
> providing
> > a _device node_ -- not quite what your patch is doing.
> 
> So your idea is to provide a separate interface per
> enclosure in kernel?

No.  My idea is to provide a device node of
type processor or enclosure for each enclosure.

Expanders already do this by providing a virtual
phy which is "connected" to the SES-2 device, so
a device of type SES is discovered and registered
with the kernel as any other device on the domain.
Then the enclosure can be controlled via sg_ses(8)
from user space.

Host adapters already do this in their FW, since
it is there where they do the transport protocol
abstraction as well.

You can help AHCI (if this really is needed of
course) to achieve the same thing by providing
code so that a LLDD/etc can register a
processor/enclosure device accessible via the
ASIC.  At any rate the actual protocol to talk
to the enclosure device is abstracted away by
the HW solution (either in FW or HW).

At this moment I see all this effort in vain
for reasons I've described above.

> Sure ... like I said patches welcome.  I just did a common
> in-kernel
> interface that abstracts common enclosure services.

I know -- this is why and where I responded to your
patches.

So I guess by what you just said, we're back
at square one? ... is this really needed, who is the
intended user/audience... why not just a device
node to be controlled via sg_ses(8) from user
space, as is already done for other enclosure
devices... etc.

      Luben

