From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 12:18:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015181859.GC15778@codepoet.org>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org> <20021015153336.GB4288@redhat.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015153336.GB4288@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue Oct 15, 2002 at 11:33:36AM -0400, Doug Ledford wrote:
> > When I plug a Adaptec 1480 Cardbus SCSI adaptor into my laptop, I
> > don't need /sbin/hotplug to register the drives.  They just
> > magically get registered.  Similarly, if I have 3 SBP-2 drives
> > plugged into an Adaptec AFW-1430 card when I plug in the card,
> > the 3 SBP-2 drives are magically registered with the SCSI
> > subsystem.  So if we require /sbin/hotplug to be involved, we
> > will need to unify the coldplug and hotplug cases to ensure
> > identical behavior....
> 
> More red herrings (who ever said the code paths for hotplug and coldplug
> would ever be different?).  Can you please quit making up bogus arguments
> and stick to the argument at hand?  Besides, I don't know what system you

But they ARE DIFFERENT!  I'm not making this up.  Try looking at
the code for a second, because I am bringing up a very real
issue.  Hotplug and coldplug are fundamentally different types 
of events, and handwaving does not change that.  I'll grant that
perhaps this difference may be unique to 1394.  I dunno.

In the hotplug case, SBP-2 devices are currently not registered
with SCSI at all. My patch allows them to be registered, as would
your proposal to let /sbin/hotplug do the heavy lifting.  No
problem here as either solution can work and will have the
expected results.

As the kernel is currently shipped, in the coldplug case (i.e.
devices are connected to the host adaptor at module load time)
devices get registered with the SCSI subsystem when the host
adaptor is registered (via a call to scsi_register_host() or
scsi_register_module() depending on the kernel version).  In this
case there is no call to /sbin/hotplug since this is not a
hotplug event.  

So I was poinging out that if you want to expand the role of
/sbin/hotplug, you will also need to modify the coldplug case to
ensure that /sbin/hotplug is involved.

> are running, but on every Red Hat system shipped to date, the drives don't
> *magically* get added when you plug in the card, they get added by the
> *user space* cardmgr daemon (because it triggers the kernel actions
> needed, just like I've been arguing for).

I use Debian on my devel laptop and I also build my own systems
by hand, but it doesn't really matter.  I have the cardmgr daemon
handle just the 16bit pcmcia cards (i.e.  Adaptec 1460).  I have
the kernel hotplug subsystem (with the /sbin/hotplug user space
helper) handle the cardbus cards since pcmcia-cs support for the
cardbus devices I use, is pretty lousy.

> If it's that important to you that the driver call in to attach the device
> instead of a user space funtion, then so be it.

So we agree that kernel space is allowed to attach devices to the
SCSI subsystem.  Cool. 

>                                                  But, it will *NOT* be
> done the way your patch does it.

Ok.  So tell what you consider an allowable way to do it.  This
is the part I've been waiting to hear.

>                                   There are more things out there than
> just usb and ieee1394 that want to do hot plug drives.  Fiber channel in

My patch is not at all usb or ieee1394 specific.

> particular is one where if I don't provide an interrupt context safe
> method of triggering this action, then the driver has to queue up the
> action, set a timer, wait for the timer to wake it up, then unqueue and
> finish the action from the timer.  I flat refuse to add a disc attach
> method that won't work for all the different classes of drivers that want
> this functionality.

Ok.

> Since disc attachment can take a long time, especially if a disc needs
> spun up, it *must* be done from a process or similar context.  If it isn't
> user space, then it needs to be a kernel thread.  Since not all of the
> sources for calls into this function have that context easily at hand, one
> needs to be created.  Call it the scsi-manager thread, fire it up when you
> start up the scsi subsystem, then allow drivers and other things to queue
> up actions that the manager thread can complete at its leisure.  That's
> the only way I want an internal kernel call for adding discs that drivers
> can call into.

Ok.  That sounds workable.

> Of course, doing it this way now presents a new problem for the hot plug 
> manager.  Since the action is queue up but the trigger call returns 
> immediately, you now have to program the hot plug manager to wait for the 
> queued action to complete if you want it to be able to do anything else 
> with the drive...

I think we need four entry points then into the scsi-manager
thread.  How about the following?

    extern int scsi_add_single_device(struct Scsi_Host *shpnt, 
	   int channel, int id, int lun);
    extern int scsi_remove_single_device(struct Scsi_Host *shpnt, 
	   int channel, int id, int lun);

    extern int blocking_scsi_add_single_device(struct Scsi_Host *shpnt, 
	   int channel, int id, int lun);
    extern int blocking_scsi_remove_single_device(struct Scsi_Host *shpnt, 
	   int channel, int id, int lun);

in this way, Fiber channel devices calling from interrupt context
and similar can call the non-blocking versions.  The blocking
versions will simply put the caller to sleep till the
registration is completed.  Agreeable?

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
