From: Eero Volotinen <eero@ping-viini.org>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Sun, 24 Oct 2004 15:34:58 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417BA172.40203@ping-viini.org>
References: <Pine.LNX.4.44L0.0410201130460.638-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jlug.fi ([192.194.49.184]:33739 "EHLO jlug.fi")
	by vger.kernel.org with ESMTP id S261456AbUJXMfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 08:35:13 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410201130460.638-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Adriaan Penning <a.penning@luon.net>, Darsen Lu <darsen@micro.ee.nthu.edu.tw>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> People:
> 
> We would like to test a method for determining automatically when the 
> capacity value returned by a drive is too high.  If this works it means 
> that the unusual_devs.h entries for your devices can be removed, and we'll 
> never be troubled by similarly broken devices again.
> 
> Please try applying the patches below.  The first one removes the existing
> unusual_devs entries and the second one includes the code we want to test.  
> Test results are written to the system log, and you don't need to turn on
> the usb-storage verbose debugging.  In your replies, include the dmesg 
> output showing what happens when you plug in or turn on your drives.

Does not work on my machine. It detects disk and then it hangs.

usb 1-4: new high speed USB device using address 3
Initializing USB Mass Storage driver...
usb 1-4: control timeout on ep0in
usb 1-4: string descriptor 0 read error: -71
usb 1-4: string descriptor 0 read error: -71
usb 1-4: string descriptor 0 read error: -71
usb 1-4: string descriptor 0 read error: -71
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb 1-4: string descriptor 0 read error: -71
usb-storage: device found at 3
usb 1-4: string descriptor 0 read error: -71
usb-storage: waiting for device to settle before scanning
inserting floppy driver for 2.6.10-rc1alan
floppy0: no floppy controllers found
   Vendor: HDS72808  Model: 0PLAT20           Rev: PF2O
   Type:   Direct-Access                      ANSI SCSI revision: 00
sd_read_true_cap: sda: spec behavior
sd_read_format_cap: sda: no media or unformatted media
SCSI device sda: 160836481 512-byte hdwr sectors (82348 MB)
sda: assuming drive cache: write through
  sda:SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 160836480
Buffer I/O error on device sda, logical block 160836480
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 160836480
Buffer I/O error on device sda, logical block 160836480
  sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
usb-storage: device scan complete
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 1
Buffer I/O error on device sda, logical block 1
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 2
Buffer I/O error on device sda, logical block 2
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 3
Buffer I/O error on device sda, logical block 3
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 4
Buffer I/O error on device sda, logical block 4
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 5
Buffer I/O error on device sda, logical block 5
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 6
Buffer I/O error on device sda, logical block 6
usb 1-4: USB disconnect, address 3
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 7
Buffer I/O error on device sda, logical block 7
SCSI error : <0 0 0 0> return code = 0x70000
end_request: I/O error, dev sda, sector 8
Buffer I/O error on device sda, logical block 8
  target0:0:0: Illegal state transition <NULL>->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713

--
Eero
