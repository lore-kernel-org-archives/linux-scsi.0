From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_allocate_request() reference
Date: Tue, 22 Mar 2005 09:34:53 -0600
Message-ID: <1111505693.5520.23.camel@mulgrave>
References: <20050321132604.GA25452@suse.de>
	 <1111417798.5504.8.camel@mulgrave> <20050321165751.GJ25452@suse.de>
	 <20050321235146.GA7994@htj.dyndns.org>  <20050322111721.GV19037@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:35036 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261369AbVCVPfA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 10:35:00 -0500
In-Reply-To: <20050322111721.GV19037@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-03-22 at 12:17 +0100, Jens Axboe wrote:
> You need to have io in progress. The one ref problem with
> scsi_allocate_request() is easy to trigger, if you just open/close the
> device repeatedly while inserting and removing it.

OK, this is the python program I've been using:

>>> while 1:
...     try:
...             fd=open("/dev/sda", "rw")
...     except IOError:
...             pass
...     fd.close();


The kernel trace from repeated insertion/removal of my pendrive is
below.  This is a vanilla 2.6.12-rc1 without your changes.  As you can
see, it works for me (and, as you can see, I had I/O active during
ejection).  (As I expect, since I did quite a bit of work around hot
ejection of USB CD's to have this work correctly).  The only known issue
is the panic in the usb-storage reset routines if we're in error
recovery after ejection.

Can you at least provide a trace on 2.6.12-rc1 where you can trigger
this?

Thanks,

James



usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: device descriptor read/64, error -71
SCSI subsystem initialized
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
  Vendor: SWISSBIT  Model: Victorinox        Rev: 1.89
  Type:   Direct-Access                      ANSI SCSI revision: 02
usb-storage: device scan complete
sda: Unit Not Ready, sense:
: Current: sense key: Unit Attention
    Additional sense: Not ready to ready change, medium may have changed
SCSI device sda: 126720 512-byte hdwr sectors (65 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 126720 512-byte hdwr sectors (65 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
 sda: unknown partition table
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
FAT: utf8 is not a recommended IO charset for FAT filesystems,
filesystem will be case sensitive!
usb 4-2: USB disconnect, address 2
usb 4-2: new full speed USB device using uhci_hcd and address 3
usb 4-2: device descriptor read/64, error -71
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
  Vendor: SWISSBIT  Model: Victorinox        Rev: 1.89
  Type:   Direct-Access                      ANSI SCSI revision: 02
sda: Unit Not Ready, sense:
: Current: sense key: Unit Attention
    Additional sense: Not ready to ready change, medium may have changed
SCSI device sda: 126720 512-byte hdwr sectors (65 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 126720 512-byte hdwr sectors (65 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
 sda: unknown partition table
Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
usb-storage: device scan complete
FAT: utf8 is not a recommended IO charset for FAT filesystems,
filesystem will be case sensitive!
VFS: busy inodes on changed media.
sda : READ CAPACITY failed.
sda : status=0, message=00, host=7, driver=00 
sda : sense not available. 
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: assuming drive cache: write through
VFS: busy inodes on changed media.
sda : READ CAPACITY failed.
sda : status=0, message=00, host=7, driver=00 
sda : sense not available. 
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: assuming drive cache: write through
usb 4-2: USB disconnect, address 3
VFS: busy inodes on changed media.
scsi1 (0:0): rejecting I/O to dead device
usb 4-2: new full speed USB device using uhci_hcd and address 4
usb 4-2: device descriptor read/64, error -71
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb 4-2: USB disconnect, address 4
usb 4-2: new full speed USB device using uhci_hcd and address 5
usb 4-2: device descriptor read/64, error -71
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usb 4-2: USB disconnect, address 5
usb 4-2: new full speed USB device using uhci_hcd and address 6
usb 4-2: device descriptor read/64, error -71
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usb 4-2: USB disconnect, address 6
usb 4-2: new full speed USB device using uhci_hcd and address 7
usb 4-2: device descriptor read/64, error -71
scsi5 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
  Vendor: SWISSBIT  Model: Victorinox        Rev: 1.89
  Type:   Direct-Access                      ANSI SCSI revision: 02
sdb: Unit Not Ready, sense:
: Current: sense key: Unit Attention
    Additional sense: Not ready to ready change, medium may have changed
SCSI device sdb: 126720 512-byte hdwr sectors (65 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
SCSI device sdb: 126720 512-byte hdwr sectors (65 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
 sdb: unknown partition table
Attached scsi removable disk sdb at scsi5, channel 0, id 0, lun 0
usb-storage: device scan complete
usb 4-2: USB disconnect, address 7
usb 4-2: new full speed USB device using uhci_hcd and address 8
usb 4-2: device descriptor read/64, error -71
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 8
usb-storage: waiting for device to settle before scanning
usb 4-2: USB disconnect, address 8
usb 4-1: new full speed USB device using uhci_hcd and address 9
usb 4-1: device descriptor read/64, error -71
scsi7 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 9
usb-storage: waiting for device to settle before scanning
  Vendor: SWISSBIT  Model: Victorinox        Rev: 1.89
  Type:   Direct-Access                      ANSI SCSI revision: 02
sdb: Unit Not Ready, sense:
: Current: sense key: Unit Attention
    Additional sense: Not ready to ready change, medium may have changed
SCSI device sdb: 126720 512-byte hdwr sectors (65 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
SCSI device sdb: 126720 512-byte hdwr sectors (65 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
 sdb: unknown partition table
Attached scsi removable disk sdb at scsi7, channel 0, id 0, lun 0
usb-storage: device scan complete
usb 4-1: USB disconnect, address 9


