From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 22:40:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016024016.GB4690@redhat.com>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org> <20021015191330.GC4391@redhat.com> <20021015193216.GE15778@codepoet.org> <20021015195516.GE4391@redhat.com> <20021015220659.GA19530@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015220659.GA19530@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Oct 15, 2002 at 04:07:00PM -0600, Erik Andersen wrote:
> I added this 
>     printk("ieee1394 nodmgr: invoking hotplug in the context "
> 	    "of '%s' (pid %d)\n", current->comm, current->pid);
> to nodemgr_call_policy() in drivers/ieee1394/nodemgr.c.  I stuck
> a similar printk into the sbp2 driver for when I was hooking and
> unhooking devices into the SCSI subsystem.
> 
> When loading the ohci1394 module I see
>     ieee1394 nodmgr: invoking hotplug in the context of 'knodemgrd' (pid 24179)

So nodmgr is a kernel thread named knodemgrd that then execs hotplug which 
then execs insmod, aka starting context is that of a kernel thread.  
That's safe for sleeping.  That's what I wanted to know.

> With my 1394 RAID array cold-plugged into my cardbus 1394 card,
> the 4 drives are registered with the SCSI subsystem.  Looks like
> I forgot to test my sbp2 patch with cold-plugging -- with my
> patch in place the 4 drives end up being registered _twice_ with
> the SCSI subsystem.  It got one copy of the devices from calling
> scsi_register_host (I'm testing with 2.4.x), and then another
> copy from me trying to hotplug the devices.  oops.  I'll sort
> that bit out.  Anyways, when doing cold-plugging the sbp2 devices
> are registered with the SCSI subsystem in the context of
> 'modprobe' (which was busy loading the sbp2 module at the time
> things were registered with the SCSI subsystem).  So in the
> coldplug case, /sbin/hotplug was not in any way involved.
> 
> Then when I hotplugged and hotunplugged the 1394 devices, hotplug
> was again called in the context of 'knodemgrd'.  So I was wrong
> about the context from which things were called.  Sorry about
> that...

The context name is only half of it.  Whether or not it's in interrupt or 
tasklet context is more important (and this doesn't change the name, being 
in knodemgrd context has current->comm == knodemgrd whether you are in the 
middle of an interrupt or not).  In this case though, it's pretty easy to 
tell it isn't interrupt context.  That's fine.  However, you still haven't 
tested the scenario I mentioned at the start of this particular part of 
the debate.  If you plug in one drive, then plug in another, does the 
second one get added?  Possible way to test this without having separate 
drives: load the sbp2 module *before* hotplugging your disks and see what 
happens.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
