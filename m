From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 01:48:01 -0800 (PST)
Message-ID: <875344.96222.qm@web31808.mail.mud.yahoo.com>
References: <1202841935.3137.94.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763435AbYBMJs0@vger.kernel.org>
In-Reply-To: <1202841935.3137.94.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

--- On Tue, 2/12/08, James Bottomley James.Bottomley@HansenPartnership.com> wrote:
> > I apologize for taking so long to review this patch. 
> I obviously agree
> > wholeheartedly with Luben.  The problem I ran into
> while trying to
> > design an enclosure management interface for the SATA
> devices is that
> > there is all this vendor defined stuff.  For example,
> for the AHCI LED
> > protocol, the only "defined" LED is
> 'activity'.  For LED2 and LED3 it
> > is up to hardware vendors to define these.  For SGPIO
> there's all kinds
> > of ways for hw vendors to customize.  I felt that it
> was going to be a
> > maintainance nightmare to have to keep track of
> various vendors
> > enclosure implementations in the ahci driver, and that
> it'd be better
> > to just have user space libraries take care of that. 
> Plus, that way a
> > vendor doesn't have to get a patch into the kernel
> to get their new
> > spiffy wizzy bang blinky lights working (think of how
> long it takes
> > something to even get into a vendor kernel, which is
> what these guys
> > care about...).  So I'm still not sold on having
> an enclosure
> > abstraction in the kernel - at least for the SATA
> controllers.
> 
> Correct me if I'm wrong, but didn't the original
> AHCI enclosure patch
> expose activity LEDs via sysfs?
> 
> I'm not saying there aren't a lot of non standard
> pieces that need to be
> activated by direct commands or other user activated
> protocol.  I am
> saying there are a lot of standard pieces that we could do
> with showing
> in a uniform manner.

Which is already the case without the SES kernel bloat.
Case in point, the excellent user-space application
"lsscsi" would clearly show which device is SES.

And the excellent user-space application "sg_ses" could
control an SES device.

> The pieces I think are absolutely standard are
> 
> 1. Actual enclosure presence (is this device in an
> enclosure)

"lsscsi"

> 2. Activity LED, this seems to be a feature of every
> enclosure.

So that means that it needs a kernel representation?
If this indeed were the case, for every "feature" of every
type of device (not only SCSI) then the kernel itself would
be insurmountably big.

> I also think the following are reasonably standard (based
> on the fact
> that most enclosure standards recommend but don't
> require this):
> 
> 3. Locate LED (for locating the device).  Even if you only
> have an
> activity LED, this is usually done by flashing the activity
> LED in a
> well defined pattern.
> 4. Fault.  this is the least standardised of the lot, but
> does seem to
> be present in about every enclosure implementation.
> 
> All I've done is standardise these four pieces ... the
> services actually
> take into account that it might not be possible to do
> certain of these
> (like fault).

And none of this means that it needs a kernel representation.

1. You're not "standardizing" any known, in-practice,
kernel representation, that is already in practice and
thusly needs a kernel representation.

2. The kernel itself is not using nor needing this
"representation" in order to function properly (the kernel).

Leaving control of SES devices to user-space makes both
the kernel and the vendors happy.  All the kernel needs
to do is expose the SES device to user-space as it currently
does.  It makes it so much easier both to vendors and to
the kernel to stay out of unnecessary representations.

Vendors may choose to distribute their own applications
to control their hardware, as long as the kernel exposes
an SES device and provides functionality, as opposed to
policy of any kind.

    Luben
