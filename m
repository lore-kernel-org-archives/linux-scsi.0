From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 11:33:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015153336.GB4288@redhat.com>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015052521.GA1967@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Oct 14, 2002 at 11:25:22PM -0600, Erik Andersen wrote:
> On Mon Oct 14, 2002 at 06:25:15PM -0400, Doug Ledford wrote:
> >                              Second, user space *does* set policy.  The
> > hot plug manager can end up doing things like changing the ownership of
> > the newly added device to that of the current console owner and then
> > automatically mounting it on /mnt/camera_drive (just an example).  IOW,
> 
> I suppose hotplug _could_ do these things.  It currently doesn't
> do anything of the sort.  If someone wishes to modify
> /etc/hotplug/ieee1394.agent to do these things, thats fine.  It
> sounds to me like you are wishing for /sbin/hotplug to take on
> some sortof devfsd type role.  If that is what you want to build,
> thats up to you I suppose.  I really don't need or want that.  So
> sure, I'll also agree with you that user space does set policy.

Well, currently we ship this capability in our products (although not for
ieee1394).  It's a combination of the pcmcia card manager daemon, PAM
modules, and the system security profile that make this happen (and our
hotplug program currently only does USB, but I seem to recall murmurs
about unifying it to do USB, ieee1394, and pcmcia so we could have one
central place to configure all these things).  The net result of all this
though is that when my wife inserts the 64MB Compact Flash card into her
laptop, it *is* recognized by the cardmgr, it is mounted on /mnt/camera,
it's ownership is changed to her uid.gid, and it's left for her to umount
(by right clicking on the drive icon on her desktop and then selecting
unmount volume) and eject when she feels like it.  You may not want this,
but a *large* percentage of the rest of the world *does* want this sort of
convenience.  Now, my point, again, is that if we are going to do this
stuff in user space, then the user space code can do the attach as well.  
No real need to split it up.

> I personally perfer a policy of minimalism.  I'd prefer the
> kernel continue to allocate SCSI drives (/dev/sdXXX) on a
> first-come-first-served basis as it currently does and then use
> things like UUIDs to keep mount points consistant.  That seems
> far more palatable then to having /sbin/hotplug mounting things
> and mucking with perms.

Who says /sbin/hotplug wouldn't use the UUID and volume label to mount it
properly?  You aren't even arguing the point, instead you're making stuff
up!  Who ever said that the recognition would be different, or that it
would not be on a first-come-first-served basis?  These are more red
herrings.  The *only* difference I'm talking about is where the device add
trigger gets triggered at.  Either the driver calls an internal scsi
function to trigger the device attachment, or the driver notifies hotplug
that the device is there and the hotplug manager (after suitable
modification to the hot plug driver to support this) calls into the scsi
function to trigger an attach.  Either way, it's the same scsi function
and it does the same thing.  The only difference then becomes which
context the scsi function is called from.

As someone who works on the scsi mid layer, I would prefer that all of the
entries into the disc attach code come from one place.  It's easier on me
if one program always calls the attach function instead of one program for
SES enclosures on SCSI parallel busses (a requirement because the scsi
busses can't detect a drive addition, only an ses knowledgable program
occasionally polling the ses enclosure would know about it), scsi drivers
for fiber channel fabrics (which the would get notification of during an
interrupt context, so they would have to find some means of getting to a
non-interrupt context and then calling the entry point or else the entry
point must be interrupt context safe), and scsi bridge drivers for
ieee1394 and usb busses (context is dependant on the method by which the
attach is done).  If we go your way, I have to worry about the independant
drivers and making sure they all call me from the proper context, etc.  
If I only have to worry about the hotplug manager, it's easier to make 
sure everything is right.

> > user space hot plug *needs* to be involved whether you make the kernel hot
> > plug work or not.  Secondly, once you accept that user space hot plug
> > *needs* to be involved, then letting it take care of the hot plugging for
> > you instead of writing a kernel patch makes more sense.
> 
> I'll grant that having /sbin/hotplug load needed kernel modules
> is a good thing.  With some hacking I suppose it could muck about
> with your device nodes if you are into that sortof thing.  But I
> still have not conceeded that we need /sbin/hotplug involved in
> registering and unregistering devices with the SCSI subsystem.
> 
> When I plug a Adaptec 1480 Cardbus SCSI adaptor into my laptop, I
> don't need /sbin/hotplug to register the drives.  They just
> magically get registered.  Similarly, if I have 3 SBP-2 drives
> plugged into an Adaptec AFW-1430 card when I plug in the card,
> the 3 SBP-2 drives are magically registered with the SCSI
> subsystem.  So if we require /sbin/hotplug to be involved, we
> will need to unify the coldplug and hotplug cases to ensure
> identical behavior....

More red herrings (who ever said the code paths for hotplug and coldplug
would ever be different?).  Can you please quit making up bogus arguments
and stick to the argument at hand?  Besides, I don't know what system you
are running, but on every Red Hat system shipped to date, the drives don't
*magically* get added when you plug in the card, they get added by the
*user space* cardmgr daemon (because it triggers the kernel actions
needed, just like I've been arguing for).

If it's that important to you that the driver call in to attach the device
instead of a user space funtion, then so be it.  But, it will *NOT* be
done the way your patch does it.  There are more things out there than
just usb and ieee1394 that want to do hot plug drives.  Fiber channel in
particular is one where if I don't provide an interrupt context safe
method of triggering this action, then the driver has to queue up the
action, set a timer, wait for the timer to wake it up, then unqueue and
finish the action from the timer.  I flat refuse to add a disc attach
method that won't work for all the different classes of drivers that want
this functionality.
  
Since disc attachment can take a long time, especially if a disc needs
spun up, it *must* be done from a process or similar context.  If it isn't
user space, then it needs to be a kernel thread.  Since not all of the
sources for calls into this function have that context easily at hand, one
needs to be created.  Call it the scsi-manager thread, fire it up when you
start up the scsi subsystem, then allow drivers and other things to queue
up actions that the manager thread can complete at its leisure.  That's
the only way I want an internal kernel call for adding discs that drivers
can call into.

Of course, doing it this way now presents a new problem for the hot plug 
manager.  Since the action is queue up but the trigger call returns 
immediately, you now have to program the hot plug manager to wait for the 
queued action to complete if you want it to be able to do anything else 
with the drive...

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
