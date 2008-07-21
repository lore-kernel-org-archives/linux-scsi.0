From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Bug 11125] New: iRiver T10 is incorrectly handled because of
 commit bdb2b8ca
Date: Mon, 21 Jul 2008 11:15:13 -0400
Message-ID: <4884A801.8000203@torque.net>
References: <bug-11125-11613@http.bugzilla.kernel.org/>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:40850 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYGUPP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2008 11:15:27 -0400
In-Reply-To: <bug-11125-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11125
> 
>            Summary: iRiver T10 is incorrectly handled because of commit
>                     bdb2b8ca
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.26
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: wrar@altlinux.org
> 
> 
> iRiver T10 mp3 player, which is basically an USB mass storage, isn't working
> anymore:
> 
> usb 5-1: new high speed USB device using ehci_hcd and address 5
> usb 5-1: configuration #1 chosen from 1 choice
> usb 5-1: New USB device found, idVendor=4102, idProduct=1020
> usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 5-1: Product: iriver MP3 T10
> usb 5-1: Manufacturer: iriver Limited
> usbcore: registered new interface driver libusual
> Initializing USB Mass Storage driver...
> scsi4 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 5
> usb-storage: waiting for device to settle before scanning
> scsi scan: INQUIRY result too short (5), using 36
> scsi 4:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
> sd 4:0:0:0: [sdc] Sector size 0 reported, assuming 512.
> sd 4:0:0:0: [sdc] 1 512-byte hardware sectors (0 MB)
> sd 4:0:0:0: [sdc] Write Protect is off
> sd 4:0:0:0: [sdc] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sdc] Assuming drive cache: write through
> sd 4:0:0:0: [sdc] Sector size 0 reported, assuming 512.
> sd 4:0:0:0: [sdc] 1 512-byte hardware sectors (0 MB)
> sd 4:0:0:0: [sdc] Write Protect is off
> sd 4:0:0:0: [sdc] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sdc] Assuming drive cache: write through
>  sdc:
> sd 4:0:0:0: [sdc] Attached SCSI disk
> sd 4:0:0:0: Attached scsi generic sg4 type 0
> usb-storage: device scan complete
> 
> 
> If I revert bdb2b8ca, it starts to work again:
> 
> usb 5-1: new high speed USB device using ehci_hcd and address 6
> usb 5-1: configuration #1 chosen from 1 choice
> scsi5 : SCSI emulation for USB Mass Storage devices
> usb 5-1: New USB device found, idVendor=4102, idProduct=1020
> usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 5-1: Product: iriver MP3 T10
> usb 5-1: Manufacturer: iriver Limited
> usb-storage: device found at 6
> usb-storage: waiting for device to settle before scanning
> scsi 5:0:0:0: Direct-Access     iriver   MP3 T10E         0.83 PQ: 0 ANSI: 2
> sd 5:0:0:0: [sdc] 1929216 512-byte hardware sectors (988 MB)
> sd 5:0:0:0: [sdc] Write Protect is off
> sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
> sd 5:0:0:0: [sdc] Assuming drive cache: write through
> sd 5:0:0:0: [sdc] 1929216 512-byte hardware sectors (988 MB)
> sd 5:0:0:0: [sdc] Write Protect is off
> sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
> sd 5:0:0:0: [sdc] Assuming drive cache: write through
>  sdc:
> sd 5:0:0:0: [sdc] Attached SCSI removable disk
> sd 5:0:0:0: Attached scsi generic sg4 type 0
> usb-storage: device scan complete
> 

I'm seeing exactly the same failure with a JetFlash 2GB
USB stick. Works fine with production Ubuntu 8.04 and
Fedora 9 (latest updates) but fails as shown above in
lk 2.6.26 . With my tools (sg3_utils) it just yields an
empty response to an INQUIRY command, MODE SENSE fails but
READ CAPACITY half works. When I use my tools on XP with
the same device there is no problem.

Looks like resid is wrong.


# sg_inq -vvvv /dev/sg2
open /dev/sg2 with flags=0x800
     inquiry cdb: 12 00 00 00 24 00
       duration=4 ms
     inquiry: requested 36 bytes but got 0 bytes
inquiry: got too few bytes (0)
     inquiry: failed requesting 36 byte response: res=97


 From /var/log/messages:
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0xe L 36 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xe R 36 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.


# sg_readcap -vvvv /dev/sg2
open /dev/sg2 with flags=0x800
     read capacity (10) cdb: 25 00 00 00 00 00 00 00 00 00
       duration=0 ms
     read capacity (10): requested 8 bytes but got 0 bytes
Read Capacity results:
    Last logical block address=3969023 (0x3c8fff), Number of blocks=3969024
    Logical block length=512 bytes
Hence:
    Device size: 2032140288 bytes, 1938.0 MiB, 2.03 GB

dmesg:
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0xf L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xf R 8 Stat 0x0
usb-storage: -- unexpectedly short transfer
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping



Doug Gilbert

