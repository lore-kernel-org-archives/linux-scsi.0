From: Olaf Hering <olh@suse.de>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Wed, 16 Feb 2005 14:12:56 +0100
Message-ID: <20050216131256.GA6009@suse.de>
References: <20050214072005.GA8586@suse.de> <Pine.LNX.4.44L0.0502141204460.1175-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Received: from mail-ex.suse.de ([195.135.220.2]:8171 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262012AbVBPNM5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 08:12:57 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502141204460.1175-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

 On Mon, Feb 14, Alan Stern wrote:

> On Mon, 14 Feb 2005, Olaf Hering wrote:
> 
> >  On Thu, Feb 10, Alan Stern wrote:
> > 
> > > And Mike Anderson's response was
> > > 
> > > http://marc.theaimsgroup.com/?l=linux-scsi&m=110538854224319&w=2
> > > 
> > > His explanation was "Currently scsi_host_cancel being called from
> > > scsi_remove_host appears to not do anything as scsi_forget_host removes
> > > the devices from the list it iterates over."  I don't know whether this 
> > > problem has been fixed yet.
> > 
> > So, does anyone else know if that has been fixed, are there any patches
> > I can try?
> > Just plugging it in and out with init=/bin/bash doesnt trigger the oops.
> 
> In fact I wrote a patch back in November that ought to work around the 
> problem, assuming this really is the problem you are seeing.  The patch 
> still applies with a few offsets.  It's available at
> 
> https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-November/001201.html

I will try this patch now. Here is another oops without this patch,
removing and adding the stick with a few seconds delay between plug/unplug.

2.6.11-rc4-bk3-200502151447-usbtest

Feb 16 13:09:50 cowberry kernel: usb 2-1: USB disconnect, address 7
Feb 16 13:09:50 cowberry udev[6257]: removing device node '/dev/sg0'
Feb 16 13:09:50 cowberry kernel: Oops: kernel access of bad area, sig: 11 [#1]
Feb 16 13:09:50 cowberry kernel: NIP: C0011544 LR: C0042884 SP: C1BF5D20 REGS: c1bf5c70 TRAP: 0300    Not tainted
Feb 16 13:09:50 cowberry kernel: MSR: 00001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
Feb 16 13:09:50 cowberry kernel: DAR: EF1F1E40, DSISR: 40000000
Feb 16 13:09:50 cowberry kernel: TASK = c1acb160[53] 'khubd' THREAD: c1bf4000
Feb 16 13:09:50 cowberry kernel: Last syscall: 120 
Feb 16 13:09:50 cowberry kernel: GPR00: 00000000 C1BF5D20 C1ACB160 CA032210 EF1F1E3C DAE403CC CA03220C 1B5C8079 
Feb 16 13:09:50 cowberry kernel: GPR08: 00000000 FFFFFFFC CA42F070 CA032210 00020734 00000000 C07CF7B8 00000004 
Feb 16 13:09:50 cowberry kernel: GPR16: C07DFB9A C07DD9D0 C0360000 C07DFB4C C07CF7B8 C07DD800 C07CF7A0 C07DD800 
Feb 16 13:09:50 cowberry kernel: GPR24: 00000000 00000001 00000001 CA032200 CA032210 00000000 251BFC30 C946FF0C 
Feb 16 13:09:50 cowberry kernel: NIP [c0011544] memcpy+0x1c/0x9c
Feb 16 13:09:50 cowberry kernel: LR [c0042884] cache_flusharray+0x74/0xdc
Feb 16 13:09:50 cowberry kernel: Call trace:
Feb 16 13:09:50 cowberry kernel:  [c00429f8] kmem_cache_free+0x68/0x84
Feb 16 13:09:50 cowberry kernel:  [cdcd8128] scsi_destroy_command_freelist+0x4c/0x10c [scsi_mod]
Feb 16 13:09:50 cowberry kernel:  [cdcd86e8] scsi_host_dev_release+0x84/0xc0 [scsi_mod]
Feb 16 13:09:50 cowberry kernel:  [c01ce37c] device_release+0x30/0x64
Feb 16 13:09:50 cowberry kernel:  [c01503e8] kobject_cleanup+0xc0/0xc4
Feb 16 13:09:50 cowberry kernel:  [c01514e0] kref_put+0x60/0x70
Feb 16 13:09:50 cowberry kernel:  [c0150318] kobject_put+0x24/0x34
Feb 16 13:09:50 cowberry kernel:  [c01ce644] put_device+0x1c/0x2c
Feb 16 13:09:50 cowberry kernel:  [cdcd8624] scsi_host_put+0x14/0x24 [scsi_mod]
Feb 16 13:09:50 cowberry kernel:  [cdd49384] usb_stor_release_resources+0xf4/0x144 [usb_storage]
Feb 16 13:09:50 cowberry kernel:  [cdd49480] storage_disconnect+0xac/0x110 [usb_storage]
Feb 16 13:09:50 cowberry kernel:  [c021add0] usb_unbind_interface+0x94/0xd4
Feb 16 13:09:50 cowberry kernel:  [c01cfdbc] device_release_driver+0x98/0x9c
Feb 16 13:09:50 cowberry kernel:  [c01cffb4] bus_remove_device+0xc0/0x12c
Feb 16 13:09:50 cowberry kernel:  [c01ce6f8] device_del+0xa4/0x114
Feb 16 13:09:50 cowberry udev[6265]: removing device node '/dev/sdb1'


