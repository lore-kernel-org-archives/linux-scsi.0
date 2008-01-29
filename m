From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9844] New: CONFIG_SCSI_MULTI_LUN hangs a camera HARD
Date: Tue, 29 Jan 2008 11:38:43 -0800 (PST)
Message-ID: <bug-9844-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757696AbYA2Tiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 14:38:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0TJchA8008910
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jan 2008 11:38:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9844

           Summary: CONFIG_SCSI_MULTI_LUN hangs a camera HARD
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.24
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: spamcan@abcbredband.net


I've tried posting this on lkml usig two different domain addresses, but none
got through... (too many capital letters in the subject?) Ah, well, here's the
text:

I am in need of setting CONFIG_SCSI_MULTI_LUN=y to access an SD(HC) slot
on (iAudio) COWON D2 flash player, but doing so hangs my Nikon CoolPix
5600 _hard_ when connecting that to an USB slot for picture downloading.

It is in fact so hard hung that the batteries must be removed to even
turn the camera off.

Bought the D2 last week, so don't know of a working kernel.

Messages from working/non-working scenarios - not very useful. Holler
if you want me to turn on debugging etc:

_Working - # CONFIG_SCSI_MULTI_LUN is not set_

Jan 27 19:55:42 sleipner kernel: Time: acpi_pm clocksource has been installed.
Jan 27 19:55:43 sleipner kernel: Clocksource tsc unstable (delta = -65041374
ns)
Jan 27 19:57:25 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 2
Jan 27 19:57:26 sleipner kernel: usb 2-2: configuration #1 chosen from 1 choice
Jan 27 19:57:26 sleipner kernel: Initializing USB Mass Storage driver...
Jan 27 19:57:26 sleipner kernel: scsi0 : SCSI emulation for USB Mass Storage
devices
Jan 27 19:57:26 sleipner kernel: usbcore: registered new interface driver
usb-storage
Jan 27 19:57:26 sleipner kernel: USB Mass Storage support registered.
Jan 27 19:57:31 sleipner kernel: scsi 0:0:0:0: Direct-Access     NIKON    NIKON
DSC E5600  1.00 PQ: 0 ANSI: 2
Jan 27 19:57:31 sleipner kernel: Driver 'sd' needs updating - please use
bus_type methods
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: [sda] 1984000 512-byte hardware
sectors (1016 MB)
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: [sda] 1984000 512-byte hardware
sectors (1016 MB)
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 27 19:57:31 sleipner kernel:  sda: sda1
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: [sda] Attached SCSI removable disk
Jan 27 19:57:31 sleipner kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0

_Not working - CONFIG_SCSI_MULTI_LUN=y_

Jan 27 20:17:13 sleipner kernel: Time: acpi_pm clocksource has been installed.
Jan 27 20:17:14 sleipner kernel: Clocksource tsc unstable (delta = -90855698
ns)
Jan 27 20:19:06 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 2
Jan 27 20:19:27 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 3
Jan 27 20:19:57 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 4
Jan 27 20:20:07 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 5

That was really strange ---^ with all the usages. Nothing at all happens
except for the camera dying. Forgot to check in kern.log, but an
additional kernel with CONFIG_USB_DEVICE_CLASS=y at least finds the
camera after ca 20 seconds, but can't really use it - and it's dead to
the world:

(This is from kern.log)

Jan 27 20:27:54 sleipner kernel: Time: acpi_pm clocksource has been installed.
Jan 27 20:27:55 sleipner kernel: Clocksource tsc unstable (delta = -86237258
ns)
Jan 27 20:28:04 sleipner kernel: ath0: no IPv6 routers present
Jan 27 20:29:23 sleipner kernel: usb 2-2: new full speed USB device using
uhci_hcd and address 2
Jan 27 20:29:23 sleipner kernel: usb 2-2: configuration #1 chosen from 1 choice
Jan 27 20:29:23 sleipner kernel: Initializing USB Mass Storage driver...
Jan 27 20:29:23 sleipner kernel: scsi0 : SCSI emulation for USB Mass Storage
devices
Jan 27 20:29:23 sleipner kernel: usbcore: registered new interface driver
usb-storage
Jan 27 20:29:23 sleipner kernel: USB Mass Storage support registered.
Jan 27 20:29:23 sleipner kernel: usb-storage: device found at 2
Jan 27 20:29:23 sleipner kernel: usb-storage: waiting for device to settle
before scanning
Jan 27 20:29:41 sleipner kernel: usb 2-2: usbfs: USBDEVFS_CONTROL failed cmd
kio_kamera rqt 33 rq 102 len 0 ret -110
Jan 27 20:30:13 sleipner last message repeated 2 times


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
