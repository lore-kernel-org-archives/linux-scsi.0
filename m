From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 16:07:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015220659.GA19530@codepoet.org>
References: <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org> <20021015191330.GC4391@redhat.com> <20021015193216.GE15778@codepoet.org> <20021015195516.GE4391@redhat.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015195516.GE4391@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue Oct 15, 2002 at 03:55:16PM -0400, Doug Ledford wrote:
> On Tue, Oct 15, 2002 at 01:32:16PM -0600, Erik Andersen wrote:
> > > about the scenario I asked about in my last email regarding a second disc 
> > > and the situation where no module needs loaded?  How is that handled?
> > 
> > Same deal.  The 1394 nodemgr invokes /sbin/hotplug.
> 
> That doesn't answer the question.  Your patch provided a kernel interface
> to be called by other kernel code (during module init time if I'm
> correct).  As such, hotplug itself is *not* attaching the disk, it is
> letting the module init take care of it.  If /sbin/hotplug isn't attaching
> the disk, but instead it is being done by the kernel driver during insmod
> (using the facilities provided by your patch), THEN HOW DOES IT HAPPEN
> WHEN THE MODULE IS ALREADY LOADED?  Are you loading *another* copy of the
> same module to handle the additional disk?  Do you have a facility by
> which the hotplug manager can tell an existing module about a new disk?  
> Or does it just not get added?  Or does the 1394 node manager notice that
> the module for the new disk is already loaded and tell the module about
> the new disk without even invoking hotplug?  Please answer this for me.

I added this 
    printk("ieee1394 nodmgr: invoking hotplug in the context "
	    "of '%s' (pid %d)\n", current->comm, current->pid);
to nodemgr_call_policy() in drivers/ieee1394/nodemgr.c.  I stuck
a similar printk into the sbp2 driver for when I was hooking and
unhooking devices into the SCSI subsystem.

When loading the ohci1394 module I see
    ieee1394 nodmgr: invoking hotplug in the context of 'knodemgrd' (pid 24179)

With my 1394 RAID array cold-plugged into my cardbus 1394 card,
the 4 drives are registered with the SCSI subsystem.  Looks like
I forgot to test my sbp2 patch with cold-plugging -- with my
patch in place the 4 drives end up being registered _twice_ with
the SCSI subsystem.  It got one copy of the devices from calling
scsi_register_host (I'm testing with 2.4.x), and then another
copy from me trying to hotplug the devices.  oops.  I'll sort
that bit out.  Anyways, when doing cold-plugging the sbp2 devices
are registered with the SCSI subsystem in the context of
'modprobe' (which was busy loading the sbp2 module at the time
things were registered with the SCSI subsystem).  So in the
coldplug case, /sbin/hotplug was not in any way involved.

Then when I hotplugged and hotunplugged the 1394 devices, hotplug
was again called in the context of 'knodemgrd'.  So I was wrong
about the context from which things were called.  Sorry about
that...

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
