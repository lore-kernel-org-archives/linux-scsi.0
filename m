From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Mon, 10 Jan 2005 12:33:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501101212160.1334-100000@ida.rowland.org>
References: <200501102114.37744.harisri@internode.on.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <200501102114.37744.harisri@internode.on.net>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>, Srihari Vijayaraghavan <harisri@internode.on.net>, Greg KH <greg@kroah.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

If James Bottomley, Mike Anderson, or anyone else from linux-scsi can
comment on the material below, I would appreciate it.


On Mon, 10 Jan 2005, Srihari Vijayaraghavan wrote:

> I am unable to trigger the bug, despite my sincere efforts.

If nothing else, I have to admire your persistence in plugging and 
unplugging the drive 120 times over the course of a half-hour!

> Please refer to the attachment for the complete kernel log.
> 
> I think I understand the problem (conceptually I guess):
> 1. Connect the USB DVD-RW drive
> 2. USB Storage says: "usb-storage: device found at nnn" and "usb-storage: 
> waiting for device to settle before scanning"
> 3. And then it waits for 5+ seconds
> 4. Then it initialises the peripheral and then says: "Vendor: PIONEER   Model: 
> DVD-RW  DVR-107D  Rev: 1.13 ..." and "usb-storage: device scan complete"

That's right.  But there's more going on behind the scenes that you aren't 
aware of.  Hotplug programs, haldaemon, automounters, and who knows what 
else.

> I think if I unplug the device precisely the same moment when it initialises 
> (step 4), and by time that routine completes kernel is really unhappy (D 
> state process,  Badness in scsi_device_set_state at 
> drivers/scsi/scsi_lib.c:1717, and/or oops) to discover that the drive is not 
> there anymore :-).

It's not that simple.  Your log contained two different sorts of errors.  
The first occurred right near the start:

Jan 10 20:24:46 desktop kernel: usb 1-3: USB disconnect, address 3
Jan 10 20:24:46 desktop kernel: 50-fstab-sync.h[5147]: segfault at 0000000000000000 rip 000000379706f6b2 rsp 0000007fbffff388 error 4
Jan 10 20:24:46 desktop kernel: 50-fstab-sync.h[5161]: segfault at 0000000000000000 rip 000000379706f6b2 rsp 0000007fbffff6d8 error 4

This looks like a problem in a user program, not in the kernel.  I have no 
idea what 50-fstab-sync.h is.  Part of udev perhaps?  Greg, do you know?


The second problem occurred during a period in which you replugged the
drive three times!  Here's the relevant part of the log:

Jan 10 20:48:37 desktop kernel: usb 1-3: new high speed USB device using ehci_hcd and address 111
Jan 10 20:48:37 desktop kernel: scsi111 : SCSI emulation for USB Mass Storage devices
Jan 10 20:48:37 desktop kernel: usb-storage: device found at 111
Jan 10 20:48:37 desktop kernel: usb-storage: waiting for device to settle before scanning
Jan 10 20:48:42 desktop kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-107D  Rev: 1.13
Jan 10 20:48:42 desktop kernel:   Type:   CD-ROM                             ANSI SCSI revision: 00
Jan 10 20:48:42 desktop kernel: sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Jan 10 20:48:42 desktop kernel: Attached scsi CD-ROM sr1 at scsi111, channel 0, id 0, lun 0
Jan 10 20:48:42 desktop kernel: usb-storage: device scan complete
Jan 10 20:48:42 desktop kernel: usb 1-3: USB disconnect, address 111

That looks okay.  But you don't see the hotplug etc. programs that are 
still running, keeping the device below scsi111 open.

Jan 10 20:48:56 desktop kernel: usb 1-3: new high speed USB device using ehci_hcd and address 112
Jan 10 20:48:56 desktop kernel: scsi112 : SCSI emulation for USB Mass Storage devices
Jan 10 20:48:56 desktop kernel: usb-storage: device found at 112
Jan 10 20:48:56 desktop kernel: usb-storage: waiting for device to settle before scanning
Jan 10 20:49:01 desktop kernel: usb-storage: device scan complete
Jan 10 20:49:01 desktop kernel: usb 1-3: USB disconnect, address 112

That's normal also.  Host scsi112 was created and apparently destroyed.

Jan 10 20:49:08 desktop kernel: usb 1-3: new high speed USB device using ehci_hcd and address 113
Jan 10 20:49:08 desktop kernel: scsi113 : SCSI emulation for USB Mass Storage devices
Jan 10 20:49:08 desktop kernel: usb-storage: device found at 113
Jan 10 20:49:08 desktop kernel: usb-storage: waiting for device to settle before scanning
Jan 10 20:49:12 desktop kernel: In bus_reset, srb: 0000010037d71640
Jan 10 20:49:12 desktop kernel:   device: 0000010038e3d000
Jan 10 20:49:12 desktop kernel:   host: 000001002b500c00
Jan 10 20:49:12 desktop kernel:   hostdata: 000001002b549c00

This is the first indication of something funny.  I can't think how a bus
reset would get initiated by the kernel -- that only happens after a
timeout.  Maybe it came from a user program?

Jan 10 20:49:12 desktop kernel: ehci_hcd 0000:00:10.4: port 3 reset error -110
Jan 10 20:49:12 desktop kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jan 10 20:49:13 desktop kernel: usb 1-3: reset high speed USB device using ehci_hcd and address 113
Jan 10 20:49:13 desktop kernel: scsi: Device offlined - not ready after error recovery: host 111 channel 0 id 0 lun 0
Jan 10 20:49:13 desktop kernel:  111:0:0:0: Illegal state transition deleted->offline
Jan 10 20:49:13 desktop kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
Jan 10 20:49:13 desktop kernel: 
Jan 10 20:49:13 desktop kernel: Call Trace:<ffffffffa0006808>{:scsi_mod:scsi_device_set_state+264} 
Jan 10 20:49:13 desktop kernel:        <ffffffffa000481c>{:scsi_mod:scsi_error_handler+2732} 
Jan 10 20:49:13 desktop kernel:        <ffffffff8010ebf3>{child_rip+8} <ffffffffa0003d70>{:scsi_mod:scsi_error_handler+0} 
Jan 10 20:49:13 desktop kernel:        <ffffffff8010ebeb>{child_rip+0} 

And here's the weird part.  Apparently the bus reset was not for the
current device attached to scsi113, but for the old incarnation attached
to scsi111 -- which is long since gone!  That accounts for the illegal
state transition.  But why did it happen like this in the first place?  
Could it be caused by a user program doing an SG_SCSI_RESET ioctl while
still holding the device open after scsi_remove_host has finished?

Jan 10 20:49:13 desktop kernel: usb 1-3: USB disconnect, address 113
Jan 10 20:49:18 desktop kernel: In bus_reset, srb: 0000010037d71240
Jan 10 20:49:18 desktop kernel:   device: 0000010038f09000
Jan 10 20:49:18 desktop kernel:   host: 000001002b500400
Jan 10 20:49:18 desktop kernel:   hostdata: 000001002b549c00
Jan 10 20:49:18 desktop kernel: scsi: Device offlined - not ready after error recovery: host 113 channel 0 id 0 lun 0
Jan 10 20:49:18 desktop kernel: usb-storage: device scan complete

Now it's not surprising that the reset, which was intended for scsi111, 
has interfered with the proper operation of scsi113.

Alan Stern



-------------------------------------------------------
The SF.Net email is sponsored by: Beat the post-holiday blues
Get a FREE limited edition SourceForge.net t-shirt from ThinkGeek.
It's fun and FREE -- well, almost....http://www.thinkgeek.com/sfshirt
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
