From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Fri, 7 Jan 2005 22:51:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501072239270.13748-100000@netrider.rowland.org>
References: <200501081311.21579.harisri@internode.on.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:56074 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261773AbVAHDv0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 22:51:26 -0500
In-Reply-To: <200501081311.21579.harisri@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srihari Vijayaraghavan <harisri@internode.on.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 8 Jan 2005, Srihari Vijayaraghavan wrote:

> Though I could not trigger an OOPS with debug option yet, I have managed to 
> trigger a D state "hald" process:
> 
> Jan  8 12:41:45 desktop kernel: hald          D 000001003fb24478     0  3369      
> 1          4163  3006 (NOTLB)
> Jan  8 12:41:45 desktop kernel: 00000100374bb9b8 0000000000000006 
> 000000732d933078 000001003fb241f0
> Jan  8 12:41:45 desktop kernel:        00000000000b08ff 00000100371bc170 
> 0000010037d71440 000001002e0db800
> Jan  8 12:41:45 desktop kernel:        000001002d933078 00000100374bba58
> Jan  8 12:41:45 desktop kernel: Call 
> Trace:<ffffffff802c11eb>{wait_for_completion+139} 
> <ffffffff8012dc20>{default_wake_function+0}
> Jan  8 12:41:45 desktop kernel:        
> <ffffffff8012dc20>{default_wake_function+0} 
> <ffffffffa0004f7b>{:scsi_mod:scsi_wait_req+91}

That's not surprising.  It's waiting for the error handler to finish.

> This (kernel badness in scsi_lib.c:1717) I have it in the system logs just 
> before the process went in to D state:
> 
> Jan  8 12:34:00 desktop kernel: ehci_hcd 0000:00:10.4: port 5 reset error -110
> Jan  8 12:34:00 desktop kernel: hub 1-0:1.0: hub_port_status failed (err = 
> -32)
> Jan  8 12:34:00 desktop kernel: usb 1-5: new high speed USB device using 
> ehci_hcd and address 9
> Jan  8 12:34:00 desktop kernel: scsi9 : SCSI emulation for USB Mass Storage 
> devices
> Jan  8 12:34:05 desktop kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-107D  
> Rev: 1.13
> Jan  8 12:34:05 desktop kernel:   Type:   CD-ROM                             
> ANSI SCSI revision: 00
> Jan  8 12:34:05 desktop kernel: sr1: scsi3-mmc drive: 40x/40x writer cd/rw 
> xa/form2 cdda tray

I see you didn't have CONFIG_USB_STORAGE_DEBUG set when you ran this test.  
Or else you didn't have your syslog daemon configured to store the
debugging messages.  If you can get anything unusual to happen with the
debugging enabled, it would make things much easier to track down.

> Jan  8 12:34:05 desktop scsi.agent[6565]: cdrom 
> at /devices/pci0000:00/0000:00:10.4/usb1/1-5/1-5:1.0/host9/target9:0:0/9:0:0:0
> Jan  8 12:34:06 desktop kernel: usb 1-5: USB disconnect, address 9
> Jan  8 12:34:36 desktop kernel: scsi: Device offlined - not ready after error 
> recovery: host 9 channel 0 id 0 lun 0
> Jan  8 12:34:36 desktop kernel:  9:0:0:0: Illegal state transition 
> deleted->offline
> Jan  8 12:34:36 desktop kernel: Badness in scsi_device_set_state at 
> drivers/scsi/scsi_lib.c:1717
> Jan  8 12:34:36 desktop kernel:
> Jan  8 12:34:36 desktop kernel: Call 
> Trace:<ffffffffa0006808>{:scsi_mod:scsi_device_set_state+264}
> Jan  8 12:34:36 desktop kernel:        
> <ffffffffa000481c>{:scsi_mod:scsi_error_handler+2732}
> Jan  8 12:34:36 desktop kernel:        <ffffffff8010ebf3>{child_rip+8} 
> <ffffffffa0003d70>{:scsi_mod:scsi_error_handler+0}
> Jan  8 12:34:36 desktop kernel:        <ffffffff8010ebeb>{child_rip+0}

I thought these state transition problems had all been cleaned up?

> Jan  8 12:35:10 desktop kernel: ehci_hcd 0000:00:10.4: port 5 reset error -110
> Jan  8 12:35:10 desktop kernel: hub 1-0:1.0: hub_port_status failed (err = 
> -32)
> Jan  8 12:35:10 desktop kernel: ehci_hcd 0000:00:10.4: port 5 reset error -110
> Jan  8 12:35:10 desktop kernel: hub 1-0:1.0: hub_port_status failed (err = 
> -32)

Those errors are quite unusual.  They seem to indicate there's a problem
with your computer's USB hardware, as do the numerous spontaneous (?)  
disconnections in your log.  However I'm not familiar with all the details
of the EHCI driver.  It's faintly possible that plugging the drive into a 
different USB port would work better.

If you still can't get anything with the debugging option, try running
without the debugging code and rmmod ehci-hcd before plugging in the
device.  Maybe if you use a UHCI controller instead the errors won't
occur.

Alan Stern

