From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 14:46:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598B14@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:16172 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271925AbTGRVb7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 17:31:59 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>

Christoph,

Thank for the feedback -- comment within...

>  - Documentation/scsi/qla2xxx.txt seems to document a 2.4ish driver
>  - Documentation/scsi/qla2xxx.release.txt looks superflous, can you
>    merge it into the (updated) qla2xxx.txt?

Updates to the documentation is on my list of todos.

>  - drivers/scsi/qla2xxx/ has duplicates of the documentation
> 

Hmm, I just checked the kernel tar-ball, there aren't any docs
there. 

>  - the (v8) comments in drivers/scsi/qla2xxx/Kconfig are superflous
>  - drivers/scsi/qla2xxx/Makefile is a mess.  If you want to compile
>    a single source file multiple times in different ways create a
>    new source file that sets the needed defines and #includes the
>    source file.  But in general this should be avoided in favour of
>    a common library module..
> 

Funny, this is what we did for the 6.x series driver.  This is part of
a larger issue we'll (QLogic) will need to address.

>  - please document which files are shared with other operating systems
>    (some look like they do, don't they?)
>

All the firmware files (more on that later), a majority of the
failover code (qla_cfg(ln), qla_fo, qlfo), most definitions in
qla_def.h, all code in qla_sup.c, mailbox command handling semantics
in qla_mbx.c.  Short answer, we're still in the process of slicing and
splicing.

>  - the driver still has multipath support in the lowlevel driver which
>    we don't want in Linux


>  - UNIQUE_FW_NAME is still there.  shouldn't this be enabled 
> uncdontionally?
>

The firmware image is automatically built and distributed for all OS
platforms.  The only thing done specifically for the Linux driver is
the addition of the 'GPL' preamble to each firmware file.  I'd rather
not spin cycles cutting out #if's after each firmware drop.

>  - still tons of typedefs that want cleaning up
>

We're phasing-in the changes during each drop.  b5 will continue to
cut the cruft.

>  - your include structures is very confusing.  Please include 
> the linux
>    headers directly i nthe files using them (except of course for
>    source files shares with other OSes)
>  

We'll look into this.

>  - qla2x00_intr_handler should use spin_lock, not spin_lock_irqsave

Are you sure about that?  I'll need to refresh my interrupt handling
know-how...

>  - you're using down_interruptible without checking the return value

Noted..

>  - please switch to newstyle module/boot parameter handling 
> (module_param)
>    (oh, okay, found the TODO comment)

Will do.

>  - what is #if defined (CONFIG_SCSIFCHOTSWAP) || 
> defined(CONFIG_GAMAP)?
>    that's never defined in a 2.5 tree and the code looks ugly as hell.

Stuff that's already removed in my latest tree...

>  - .unchecked_isa_dma      = 0 in the host template is superflous,
>    it's 0 by default.

Done.

>  - what is CONFIG_MD_MULTIHOST_FC?

Removed.

>  - you are using a static buffer in qla2x00_info, there's a 
> lock needed
>    to protect it
>  - in qla2x00_queuecommand you need to call
>   spin_unlock_irq/spin_lock_irq on the hostlock, otherwise your whole
>  ->queuecommand runs with (local) interrupts disabled

Noted..

>  - qla2x00_biosparam is superflous, if there's no ->biosparam 
> the midlayer
>    calls scsicam_bios_param directly
>  - you don't need to call scsi_set_device if you pass the 
> proper struct device
>    to scsi_add_host

Thanks for the tip.

>  - please don't use scsi_assign_lock.  In 2.5 we already have 
> a per-HBA
>    lock and using a different one than the default one 
> doesn't make sense.

Yes, that patch shouldn't have gone into 8.x.

>  - you need to check the return value from scsi_add_host

Noted..

>  - please remove the "sanity check" in qla2x00_remove_device.  If you
>    can't trust the pci layer you have worse problems..
>  - ->proc_info is deprecated, please implement shost and sdev sysfs
>    attributes instead.
>  

Will do.

>  - all contents of qla_ip.c is surrounded by a big if 
> defined(FC_IP_SUPPORT),
>    please compile the file conditionally instead.  (also in 
> linux we prefer
>    #ifdef over #if defined)
>  - where is qla2200_ip_inquiry/qla2300_ip_inquiry called??  
> also it makes
>    more sense to pass the scsi_qla_host_t directrly to it 
> instead of an
>    adapter number that requires list walking
> 

With the latest fcdev/fcinitiator/ip_dev --> fcport consolidation
work, the IP code needs to be overhauled -- thus the #if 0.

Wow, thanks for the feedback!

Regards,
Andrew Vasquez
'...only 20 more 'announce' replies to go through...some friday...'
