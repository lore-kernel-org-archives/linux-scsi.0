From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 15:54:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014215416.GB25941@codepoet.org>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210142107.g9EL7IX04354@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Mon Oct 14, 2002 at 02:07:18PM -0700, James Bottomley wrote:
> andersen@codepoet.org said:
> > If the user space interface were perfectly adequate, I would not have
> > written this patch.  User space does not have sufficient information
> > to know _which_ devices must to be added or removed. The best we can
> > do from user space is a full rescan of _all_ scsi host adaptors (http:/
> > /www.garloff.de/kurt/linux/rescan-scsi-bus.sh)  using something like
> 
> The API you expose has identical inputs to the user space one.
> 
> Therefore it seems to me that your spb2 driver must already know the values to 
> fill in to use the API.  So what's wrong with triggering a hotplug event from 
> this driver that causes the add/remove single device to be done from user 
> level?

That would be another way to do it.  Right now the SBP-2 hotplug
mechanism works perfectly for loading and unloading all the
needed kernel modules in the correct order when hotplugging.  

To make the ieee1394 hotplug mechanism also properly register and
unregister SBP-2 devices from user space, we will need to also
export the host, channel, id, and lun from nodemgr_call_policy()
in drivers/ieee1394/nodemgr.c.  But this becomes a layering
problem since not all 1394 devices are SBP-2 devices, and
therefore the nodemgr has no concept of channel, id, and lun.
This is further complicated since the parameters exported by the
1394 hotplug subsystem were fixed around 2.4.10.  Changing that
would require coordination with all the distro maintainers (esp
since linux//Documentation/Changes does not list a required
version of the hotplug utilities).

I have a 4 slot firewire RAID system with 4 hotswapable 120 GB
drives in it connected via a single firewire cable.  This is very
small compared to the potential size.  Imagine someone plugs in a
63 device firewire RAID box.  Then nodemgr.c determines if the
device being hotplugged is an SBP-2 device and if so execs
/sbin/hotplug with some extra SBP-2 specific arguments.  Then
/sbin/hotplug writes some junk into /proc/scsi/scsi 63 times, and
so 63 times we context switch back into kernel space to
register/unregister a device and then 63 times we context switch
back into user space so we can continue doing the hotplug thing.

And the point of this exercise again was?  Its not like userspace
is setting policy -- the sbp2.c driver knew exactly what the
Right Thing(tm) was all along.  I think using the function calls
per my patch is a far cleaner solution,

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
