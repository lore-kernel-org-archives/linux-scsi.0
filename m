From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 23:25:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015052521.GA1967@codepoet.org>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014222515.GD1274@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon Oct 14, 2002 at 06:25:15PM -0400, Doug Ledford wrote:
> On Mon, Oct 14, 2002 at 03:54:17PM -0600, Erik Andersen wrote:
> > 
> > I have a 4 slot firewire RAID system with 4 hotswapable 120 GB
> > drives in it connected via a single firewire cable.  This is very
> > small compared to the potential size.  Imagine someone plugs in a
> > 63 device firewire RAID box.  Then nodemgr.c determines if the
> > device being hotplugged is an SBP-2 device and if so execs
> > /sbin/hotplug with some extra SBP-2 specific arguments.  Then
> > /sbin/hotplug writes some junk into /proc/scsi/scsi 63 times, and
> > so 63 times we context switch back into kernel space to
> > register/unregister a device and then 63 times we context switch
> > back into user space so we can continue doing the hotplug thing.
> > 
> > And the point of this exercise again was?  Its not like userspace
> > is setting policy -- the sbp2.c driver knew exactly what the
> > Right Thing(tm) was all along.  I think using the function calls
> > per my patch is a far cleaner solution,
> 
> First, 63 context switches is a red herring.  The total amount of work
> required to attach a scsi disk is high enough that a context switch per
> disk is totally lost noise.

Ok, I'll agree that the overhead is small compared to the rest of
the process.  Though I contend that it is still needless additional 
overhead.

>                              Second, user space *does* set policy.  The
> hot plug manager can end up doing things like changing the ownership of
> the newly added device to that of the current console owner and then
> automatically mounting it on /mnt/camera_drive (just an example).  IOW,

I suppose hotplug _could_ do these things.  It currently doesn't
do anything of the sort.  If someone wishes to modify
/etc/hotplug/ieee1394.agent to do these things, thats fine.  It
sounds to me like you are wishing for /sbin/hotplug to take on
some sortof devfsd type role.  If that is what you want to build,
thats up to you I suppose.  I really don't need or want that.  So
sure, I'll also agree with you that user space does set policy.

I personally perfer a policy of minimalism.  I'd prefer the
kernel continue to allocate SCSI drives (/dev/sdXXX) on a
first-come-first-served basis as it currently does and then use
things like UUIDs to keep mount points consistant.  That seems
far more palatable then to having /sbin/hotplug mounting things
and mucking with perms.

> user space hot plug *needs* to be involved whether you make the kernel hot
> plug work or not.  Secondly, once you accept that user space hot plug
> *needs* to be involved, then letting it take care of the hot plugging for
> you instead of writing a kernel patch makes more sense.

I'll grant that having /sbin/hotplug load needed kernel modules
is a good thing.  With some hacking I suppose it could muck about
with your device nodes if you are into that sortof thing.  But I
still have not conceeded that we need /sbin/hotplug involved in
registering and unregistering devices with the SCSI subsystem.

When I plug a Adaptec 1480 Cardbus SCSI adaptor into my laptop, I
don't need /sbin/hotplug to register the drives.  They just
magically get registered.  Similarly, if I have 3 SBP-2 drives
plugged into an Adaptec AFW-1430 card when I plug in the card,
the 3 SBP-2 drives are magically registered with the SCSI
subsystem.  So if we require /sbin/hotplug to be involved, we
will need to unify the coldplug and hotplug cases to ensure
identical behavior....

> Also, it's likely that calling in from the hot plug manager is *much*
> better from the kernel perspective for one very important reason, user
> context.  The add_single_device operation will not be done from an
> interrupt/tasklet/softirq/etc. context if the hot plug manager does it,
> making sleeping, memory allocation, and such easier to get right.  What
> context does the 1394 code call the scsi code from in your patch?

It is called from within the insmod's context.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
