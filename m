From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11125] New: iRiver T10 is incorrectly handled because of commit bdb2b8ca
Date: Sat, 19 Jul 2008 12:39:30 -0700 (PDT)
Message-ID: <bug-11125-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbYGSTjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2008 15:39:32 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6JJdVMp004570
	for <linux-scsi@vger.kernel.org>; Sat, 19 Jul 2008 12:39:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11125

           Summary: iRiver T10 is incorrectly handled because of commit
                    bdb2b8ca
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wrar@altlinux.org


iRiver T10 mp3 player, which is basically an USB mass storage, isn't working
anymore:

usb 5-1: new high speed USB device using ehci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=4102, idProduct=1020
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: iriver MP3 T10
usb 5-1: Manufacturer: iriver Limited
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
scsi4 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
scsi scan: INQUIRY result too short (5), using 36
scsi 4:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
sd 4:0:0:0: [sdc] Sector size 0 reported, assuming 512.
sd 4:0:0:0: [sdc] 1 512-byte hardware sectors (0 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
sd 4:0:0:0: [sdc] Sector size 0 reported, assuming 512.
sd 4:0:0:0: [sdc] 1 512-byte hardware sectors (0 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
 sdc:
sd 4:0:0:0: [sdc] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg4 type 0
usb-storage: device scan complete


If I revert bdb2b8ca, it starts to work again:

usb 5-1: new high speed USB device using ehci_hcd and address 6
usb 5-1: configuration #1 chosen from 1 choice
scsi5 : SCSI emulation for USB Mass Storage devices
usb 5-1: New USB device found, idVendor=4102, idProduct=1020
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: iriver MP3 T10
usb 5-1: Manufacturer: iriver Limited
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 5:0:0:0: Direct-Access     iriver   MP3 T10E         0.83 PQ: 0 ANSI: 2
sd 5:0:0:0: [sdc] 1929216 512-byte hardware sectors (988 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
sd 5:0:0:0: [sdc] Assuming drive cache: write through
sd 5:0:0:0: [sdc] 1929216 512-byte hardware sectors (988 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
sd 5:0:0:0: [sdc] Assuming drive cache: write through
 sdc:
sd 5:0:0:0: [sdc] Attached SCSI removable disk
sd 5:0:0:0: Attached scsi generic sg4 type 0
usb-storage: device scan complete


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
