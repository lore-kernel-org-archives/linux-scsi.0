From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Mon, 04 Feb 2008 20:14:22 -0600
Message-ID: <1202177662.3096.168.camel@localhost.localdomain>
References: <922945.25870.qm@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758161AbYBECOl@vger.kernel.org>
In-Reply-To: <922945.25870.qm@web31811.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org


On Mon, 2008-02-04 at 18:01 -0800, Luben Tuikov wrote:
> --- On Mon, 2/4/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > The enclosure misc device is really just a
> > library providing
> > > > sysfs
> > > > support for physical enclosure devices and their
> > > > components.
> > > 
> > > Who is the target audience/user of those facilities?
> > > a) The kernel itself needing to read/write SES pages?
> > 
> > That depends on the enclosure integration, but right at the
> > moment, it
> > doesn't
> 
> Yes, I didn't suspect so.
> 
> > 
> > > b) A user space application using sysfs to read/write
> > >    SES pages?
> > 
> > Not an application so much as a user.  The idea of sysfs is
> > to allow
> > users to get and set the information in addition to
> > applications.
> 
> Exactly the same argument stands for a user-space
> application with a user-space library.
> 
> This is the classical case of where it is better to
> do this in user-space as opposed to the kernel.
> 
> The kernel provides capability to access the SES
> device.  The user space application and library
> provide interpretation and control.  Thus if the
> enclosure were upgraded, one doesn't need to
> upgrade their kernel in order to utilize the new
> capabilities of the SES device.  Plus upgrading
> a user-space application is a lot easier than
> the kernel (and no reboot necessary).

The implementation is modular, so it's remove and insert ...

> Consider another thing: vendors would really like
> unprecedented access to the SES device in the enclosure
> so as your ses/enclosure code keeps state it would
> get out of sync when vendor user-space enclosure
> applications access (and modify) the SES device's
> pages.

The state model doesn't assume nothing else will alter the state.

> You can test this yourself: submit a patch
> that removes SES /dev/sgX support; advertise your
> ses/class solution and watch the fun.
> 
> > > At the moment SES device management is done via
> > > an application (user-space) and a user-space library
> > > used by the application and /dev/sgX to send SCSI
> > > commands to the SES device.
> > 
> > I must have missed that when I was looking for
> > implementations; what's
> > the URL?
> 
> I'm not aware of any GPLed ones.  That doesn't
> necessarily mean that the best course of action is
> to bloat the kernel.  You can move your ses/enclosure
> stuff to a user space application library
> and thus start a GPLed one.

Certainly ... patches welcome.

> > But, if we have non-scsi enclosures to integrate, that
> > makes it harder
> > for a user application because it has to know all the
> > implementations.
> 
> So does the kernel.  And as I pointed out above, it
> is a lot easier to upgrade a user-space application and
> library than it is to upgrade a new kernel and having
> to reboot the computer to run the new kernel.

No, think again ... it's easy for SES based enclosures because they have
a SCSI transport.  We have no transport for SGPIO based enclosures nor
for any of the other more esoteric ones.

That's not to say it can't be done, but it does mean that it can't be
completely userspace.

> > A sysfs framework on the other hand is a universal known
> > thing for the
> > user applications.
> 
> So would a user-space ses library, a la libses.so.
> 
> > > One could have a very good argument to not bloat
> > > the kernel with this but leave it to a user-space
> > > application and a library to do all this and
> > > communicate with the SES device via the kernel's
> > /dev/sgX.
> > 
> > The same thing goes for other esoteric SCSI infrastructure
> > pieces like
> > cd changers.  On the whole, given that ATA is asking for
> > enclosure
> > management in kernel, it makes sense to consolidate the
> > infrastructure
> > and a ses ULD is a very good test bed.
> 
> What is wrong with exporting the SES device as /dev/sgX
> and having a user-space application and library to
> do all this?

How do you transport the enclosure commands over /dev/sgX?  Only SES has
SCSI command encapsulation ... the rest won't even be SCSI targets ...

James
