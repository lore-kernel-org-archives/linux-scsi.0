From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 12 Feb 2008 10:22:44 -0800
Message-ID: <20080212102244.32869382@appleyard>
References: <1202172065.3096.154.camel@localhost.localdomain>
	<922945.25870.qm@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594AbYBLS37 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 13:29:59 -0500
In-Reply-To: <922945.25870.qm@web31811.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

On Mon, 4 Feb 2008 18:01:36 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> --- On Mon, 2/4/08, James Bottomley
> <James.Bottomley@HansenPartnership.com> wrote:
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
> 
> Consider another thing: vendors would really like
> unprecedented access to the SES device in the enclosure
> so as your ses/enclosure code keeps state it would
> get out of sync when vendor user-space enclosure
> applications access (and modify) the SES device's
> pages.
> 
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
> 
> > But, if we have non-scsi enclosures to integrate, that
> > makes it harder
> > for a user application because it has to know all the
> > implementations.
> 
> So does the kernel.  And as I pointed out above, it
> is a lot easier to upgrade a user-space application and
> library than it is to upgrade a new kernel and having
> to reboot the computer to run the new kernel.
> 
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
> 
>     Luben
> 

Hi,
I apologize for taking so long to review this patch.  I obviously agree
wholeheartedly with Luben.  The problem I ran into while trying to
design an enclosure management interface for the SATA devices is that
there is all this vendor defined stuff.  For example, for the AHCI LED
protocol, the only "defined" LED is 'activity'.  For LED2 and LED3 it
is up to hardware vendors to define these.  For SGPIO there's all kinds
of ways for hw vendors to customize.  I felt that it was going to be a
maintainance nightmare to have to keep track of various vendors
enclosure implementations in the ahci driver, and that it'd be better
to just have user space libraries take care of that.  Plus, that way a
vendor doesn't have to get a patch into the kernel to get their new
spiffy wizzy bang blinky lights working (think of how long it takes
something to even get into a vendor kernel, which is what these guys
care about...).  So I'm still not sold on having an enclosure
abstraction in the kernel - at least for the SATA controllers.

Kristen
