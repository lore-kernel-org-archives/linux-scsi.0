From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 18:25:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014222515.GD1274@redhat.com>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014215416.GB25941@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Oct 14, 2002 at 03:54:17PM -0600, Erik Andersen wrote:
> 
> I have a 4 slot firewire RAID system with 4 hotswapable 120 GB
> drives in it connected via a single firewire cable.  This is very
> small compared to the potential size.  Imagine someone plugs in a
> 63 device firewire RAID box.  Then nodemgr.c determines if the
> device being hotplugged is an SBP-2 device and if so execs
> /sbin/hotplug with some extra SBP-2 specific arguments.  Then
> /sbin/hotplug writes some junk into /proc/scsi/scsi 63 times, and
> so 63 times we context switch back into kernel space to
> register/unregister a device and then 63 times we context switch
> back into user space so we can continue doing the hotplug thing.
> 
> And the point of this exercise again was?  Its not like userspace
> is setting policy -- the sbp2.c driver knew exactly what the
> Right Thing(tm) was all along.  I think using the function calls
> per my patch is a far cleaner solution,

First, 63 context switches is a red herring.  The total amount of work
required to attach a scsi disk is high enough that a context switch per
disk is totally lost noise.  Second, user space *does* set policy.  The
hot plug manager can end up doing things like changing the ownership of
the newly added device to that of the current console owner and then
automatically mounting it on /mnt/camera_drive (just an example).  IOW,
user space hot plug *needs* to be involved whether you make the kernel hot
plug work or not.  Secondly, once you accept that user space hot plug
*needs* to be involved, then letting it take care of the hot plugging for
you instead of writing a kernel patch makes more sense.

Also, it's likely that calling in from the hot plug manager is *much*
better from the kernel perspective for one very important reason, user
context.  The add_single_device operation will not be done from an
interrupt/tasklet/softirq/etc. context if the hot plug manager does it,
making sleeping, memory allocation, and such easier to get right.  What
context does the 1394 code call the scsi code from in your patch?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
