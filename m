From: Aleksey Nogin <aleksey@nogin.org>
Subject: Re: [linux-usb-devel] Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Wed, 21 Apr 2004 12:54:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4086D17C.2050407@nogin.org>
References: <Pine.LNX.4.44L0.0404211041220.1106-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charter-242-037.caltech.edu ([131.215.242.37]:25472 "EHLO
	dell.nogin.org") by vger.kernel.org with ESMTP id S263642AbUDUTyy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 15:54:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404211041220.1106-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 21.04.2004 07:43, Alan Stern wrote:

> On Tue, 20 Apr 2004, Aleksey Nogin wrote:
> 
> 
>>Thanks a lot for your feedback. Unfortunately, your patch does not seem 
>>to affect anything.
> 
> 
> Yes, now you come to mention it, I see there isn't any code in there to 
> retry the INQUIRY command after a Unit Attention!  All right, try this 
> patch instead.

This works, thanks!

However, is still only works when connected directly. If connected 
through a hub, when I start copying files, after transferring in the 
range of 100-500KB, the system thinks that the hub was disconnected, 
data transfer gets stuck, then it thinks that the mouse (that is 
attached to the hub) is disconnected, then it thinks that the mouse is 
back, then everything becomes stuck. If I turn the camera off at this 
point, it results in a kernel oops...

Apr 21 12:36:26 dell kernel: sub 1-1.3: new full speed USB device using 
address 5
Apr 21 12:36:27 dell kernel: Initializing USB Mass Storage driver...
Apr 21 12:36:28 dell kernel: scsi0 : SCSI emulation for USB Mass Storage 
devices
Apr 21 12:36:28 dell kernel:   Vendor: FUJIFILM  Model: USB-DRIVEUNIT 
   Rev: 1.00
Apr 21 12:36:28 dell kernel:   Type:   Direct-Access 
   ANSI SCSI revision: 02
Apr 21 12:36:28 dell scsi.agent[2324]: disk at 
/devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.3/1-1.3:1.0/host0/0:0:0:0
Apr 21 12:36:40 dell kernel: usbcore: registered new driver usb-storage
Apr 21 12:36:40 dell kernel: USB Mass Storage support registered.
Apr 21 12:36:47 dell kernel: SCSI device sda: 512000 512-byte hdwr 
sectors (262 MB)
Apr 21 12:36:47 dell kernel: sda: assuming Write Enabled
Apr 21 12:36:47 dell kernel: sda: assuming drive cache: write through
Apr 21 12:36:47 dell kernel:  sda:<7>usb-storage: queuecommand called
Apr 21 12:36:47 dell kernel:  sda1
Apr 21 12:36:47 dell kernel: Attached scsi removable disk sda at scsi0, 
channel 0, id 0, lun 0
Apr 21 12:37:07 dell last message repeated 2 times
Apr 21 12:37:07 dell kernel: SELinux: initialized (dev sda1, type 
msdos), uses genfs_contexts
Apr 21 12:37:08 dell kernel: usb 1-1.1: USB disconnect, address 3
Apr 21 12:37:09 dell kernel: usb 1-1.1: new low speed USB device using 
address 6
Apr 21 12:37:10 dell usb.agent[3503]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:10 dell input.agent[3522]: ... no modules for INPUT product
Apr 21 12:37:10 dell input.agent[3532]: ... no modules for INPUT product
Apr 21 12:37:10 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:39 dell kernel: usb 1-1.1: USB disconnect, address 6
Apr 21 12:37:39 dell kernel: usb 1-1.1: new low speed USB device using 
address 7
Apr 21 12:37:39 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:39 dell kernel: usb 1-1.1: USB disconnect, address 7
Apr 21 12:37:40 dell usb.agent[3608]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:40 dell kernel: usb 1-1.1: new low speed USB device using 
address 8
Apr 21 12:37:40 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:41 dell usb.agent[3655]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:41 dell kernel: usb 1-1.1: USB disconnect, address 8
Apr 21 12:37:41 dell kernel: usb 1-1.1: new low speed USB device using 
address 9
Apr 21 12:37:42 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:42 dell usb.agent[3704]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:42 dell kernel: usb 1-1.1: USB disconnect, address 9
Apr 21 12:37:43 dell kernel: usb 1-1.1: new low speed USB device using 
address 10
Apr 21 12:37:43 dell usb.agent[3753]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:44 dell input.agent[3774]: ... no modules for INPUT product
Apr 21 12:37:44 dell input.agent[3784]: ... no modules for INPUT product
Apr 21 12:37:44 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:44 dell kernel: usb 1-1.1: USB disconnect, address 10
Apr 21 12:37:44 dell kernel: usb 1-1.1: new low speed USB device using 
address 11
Apr 21 12:37:45 dell usb.agent[3858]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:45 dell input.agent[3879]: ... no modules for INPUT product
Apr 21 12:37:45 dell input.agent[3889]: ... no modules for INPUT product
Apr 21 12:37:45 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:45 dell kernel: usb 1-1.1: USB disconnect, address 11
Apr 21 12:37:46 dell kernel: usb 1-1.1: new low speed USB device using 
address 12
Apr 21 12:37:46 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:47 dell usb.agent[3964]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:47 dell kernel: usb 1-1.1: USB disconnect, address 12
Apr 21 12:37:47 dell kernel: usb 1-1.1: new low speed USB device using 
address 13
Apr 21 12:37:48 dell usb.agent[4013]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:48 dell input.agent[4041]: ... no modules for INPUT product
Apr 21 12:37:48 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:48 dell input.agent[4034]: ... no modules for INPUT product
Apr 21 12:37:48 dell kernel: usb 1-1.1: USB disconnect, address 13
Apr 21 12:37:49 dell kernel: usb 1-1.1: new low speed USB device using 
address 14
Apr 21 12:37:50 dell usb.agent[4118]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:50 dell input.agent[4146]: ... no modules for INPUT product
Apr 21 12:37:50 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:50 dell input.agent[4139]: ... no modules for INPUT product
Apr 21 12:37:50 dell kernel: usb 1-1.1: USB disconnect, address 14
Apr 21 12:37:50 dell kernel: usb 1-1.1: new low speed USB device using 
address 15
Apr 21 12:37:50 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:51 dell kernel: usb 1-1.1: USB disconnect, address 15
Apr 21 12:37:51 dell usb.agent[4223]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:52 dell kernel: usb 1-1.1: new low speed USB device using 
address 16
Apr 21 12:37:52 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:52 dell usb.agent[4269]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:53 dell kernel: usb 1-1.1: USB disconnect, address 16
Apr 21 12:37:53 dell kernel: usb 1-1.1: new low speed USB device using 
address 17
Apr 21 12:37:53 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:37:54 dell usb.agent[4322]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:54 dell kernel: usb 1-1.1: USB disconnect, address 17
Apr 21 12:37:54 dell kernel: usb 1-1.1: new low speed USB device using 
address 18
Apr 21 12:37:55 dell usb.agent[4369]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:55 dell input.agent[4390]: ... no modules for INPUT product
Apr 21 12:37:55 dell input.agent[4400]: ... no modules for INPUT product
Apr 21 12:37:55 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:55 dell kernel: usb 1-1.1: USB disconnect, address 18
Apr 21 12:37:56 dell kernel: usb 1-1.1: new low speed USB device using 
address 19
Apr 21 12:37:57 dell usb.agent[4474]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:57 dell input.agent[4495]: ... no modules for INPUT product
Apr 21 12:37:57 dell input.agent[4505]: ... no modules for INPUT product
Apr 21 12:37:57 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:57 dell kernel: usb 1-1.1: USB disconnect, address 19
Apr 21 12:37:57 dell kernel: usb 1-1.1: new low speed USB device using 
address 20
Apr 21 12:37:58 dell usb.agent[4579]: ... no modules for USB product 
46d/c501/910
Apr 21 12:37:58 dell input.agent[4600]: ... no modules for INPUT product
Apr 21 12:37:58 dell input.agent[4610]: ... no modules for INPUT product
Apr 21 12:37:58 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:37:59 dell kernel: usb 1-1.1: USB disconnect, address 20
Apr 21 12:37:59 dell kernel: usb 1-1.1: new low speed USB device using 
address 21
Apr 21 12:37:59 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:38:00 dell usb.agent[4685]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:00 dell kernel: usb 1-1.1: USB disconnect, address 21
Apr 21 12:38:00 dell kernel: usb 1-1.1: new low speed USB device using 
address 22
Apr 21 12:38:01 dell usb.agent[4735]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:01 dell input.agent[4765]: ... no modules for INPUT product
Apr 21 12:38:01 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:38:01 dell input.agent[4756]: ... no modules for INPUT product
Apr 21 12:38:01 dell kernel: usb 1-1.1: USB disconnect, address 22
Apr 21 12:38:02 dell kernel: usb 1-1.1: new low speed USB device using 
address 23
Apr 21 12:38:03 dell usb.agent[4841]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:03 dell input.agent[4872]: ... no modules for INPUT product
Apr 21 12:38:03 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:38:03 dell input.agent[4863]: ... no modules for INPUT product
Apr 21 12:38:03 dell kernel: usb 1-1.1: USB disconnect, address 23
Apr 21 12:38:04 dell kernel: usb 1-1.1: new low speed USB device using 
address 24
Apr 21 12:38:04 dell kernel: hid: probe of 1-1.1:1.0 failed with error -5
Apr 21 12:38:04 dell usb.agent[4948]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:04 dell kernel: usb 1-1.1: USB disconnect, address 24
Apr 21 12:38:05 dell kernel: usb 1-1.1: new low speed USB device using 
address 25
Apr 21 12:38:06 dell usb.agent[4997]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:06 dell input.agent[5018]: ... no modules for INPUT product
Apr 21 12:38:06 dell input.agent[5028]: ... no modules for INPUT product
Apr 21 12:38:06 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:38:06 dell kernel: usb 1-1.1: USB disconnect, address 25
Apr 21 12:38:06 dell kernel: usb 1-1.1: new low speed USB device using 
address 26
Apr 21 12:38:07 dell usb.agent[5102]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:07 dell input.agent[5123]: ... no modules for INPUT product
Apr 21 12:38:07 dell input.agent[5133]: ... no modules for INPUT product
Apr 21 12:38:07 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:38:08 dell kernel: usb 1-1.1: USB disconnect, address 26
Apr 21 12:38:08 dell kernel: usb 1-1.1: new low speed USB device using 
address 27
Apr 21 12:38:09 dell usb.agent[5207]: ... no modules for USB product 
46d/c501/910
Apr 21 12:38:09 dell input.agent[5228]: ... no modules for INPUT product
Apr 21 12:38:09 dell input.agent[5238]: ... no modules for INPUT product
Apr 21 12:38:09 dell kernel: input: USB HID v1.10 Mouse [Logitech USB 
Receiver] on usb-0000:00:1d.0-1.1
Apr 21 12:38:10 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:38:14 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:14 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:15 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:15 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:16 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:38:19 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:19 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:21 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:21 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:22 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:38:24 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:24 dell kernel: hub 1-1:1.0: hub_hub_status failed (err = -110)
Apr 21 12:38:24 dell kernel: hub 1-1:1.0: get_hub_status failed
Apr 21 12:38:27 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:27 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:28 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:38:29 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:29 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:32 dell shutdown: shutting down for system reboot
Apr 21 12:38:34 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:34 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:34 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:34 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:35 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:38:39 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:39 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:40 dell kernel: usb 1-1: control timeout on ep0in
Apr 21 12:38:40 dell kernel: hub 1-1:1.0: hub_port_status failed (err = 
-110)
Apr 21 12:38:40 dell kernel: hub 1-1:1.0: Cannot enable port 3.  Maybe 
the USB cable is bad?
Apr 21 12:38:41 dell kernel: usb 1-1: control timeout on ep0out
Apr 21 12:39:22 dell kernel: hub 1-1:1.0: cannot disable port 3 (err = -110)
Apr 21 12:39:22 dell kernel: scsi: Device offlined - not ready after 
error recovery: host 0 channel 0 id 0 lun 0
Apr 21 12:39:22 dell kernel: SCSI error : <0 0 0 0> return code = 0x50000
Apr 21 12:39:22 dell kernel: end_request: I/O error, dev sda, sector 512
Apr 21 12:39:22 dell kernel: Buffer I/O error on device sda1, logical 
block 463
Apr 21 12:39:22 dell kernel: scsi0 (0:0): rejecting I/O to offline device
Apr 21 12:39:22 dell kernel: Buffer I/O error on device sda1, logical 
block 464
Apr 21 12:39:22 dell kernel: Buffer I/O error on device sda1, logical 
block 465


-- 
Aleksey Nogin

Home Page: http://nogin.org/
E-Mail: nogin@cs.caltech.edu (office), aleksey@nogin.org (personal)
Office: Jorgensen 70, tel: (626) 395-2907
