From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1 and excessive block IO errors
Date: Fri, 7 Dec 2007 15:05:37 -0800
Message-ID: <20071207150537.2ccdd53e.akpm@linux-foundation.org>
References: <1197060285.15428.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418AbXLGXFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 18:05:43 -0500
In-Reply-To: <1197060285.15428.20.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Fri, 07 Dec 2007 20:44:45 +0000
Zan Lynx <zlynx@acm.org> wrote:

> I am not sure if this problem has been addressed already.  I read some
> about the fast-fail issues and this may be related?
> 
> On nearly all my USB block devices, I have been getting zillions of I/O
> errors.  But they aren't real, they don't appear with 2.6.23 kernels.
> 
> I can often read and write data to the device, but these IO errors cause
> error aborts in user space applications in many cases, making it a
> chancy thing to run backup software, for example.
> 
> Here is a bit of dmesg from plugging in a perfectly good USB-2 flash
> drive.
> 
> hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0004
> ehci_hcd 0000:00:02.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
> hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
> hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
> ehci_hcd 0000:00:02.2: port 2 high speed
> ehci_hcd 0000:00:02.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
> usb 3-2: new high speed USB device using ehci_hcd and address 9
> ehci_hcd 0000:00:02.2: port 2 high speed
> ehci_hcd 0000:00:02.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
> usb 3-2: default language 0x0409
> usb 3-2: uevent
> usb 3-2: usb_probe_device
> usb 3-2: configuration #1 chosen from 1 choice
> usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> usb 3-2:1.0: uevent
> libusual 3-2:1.0: usb_probe_interface
> libusual 3-2:1.0: usb_probe_interface - got id
> usb-storage 3-2:1.0: usb_probe_interface
> usb-storage 3-2:1.0: usb_probe_interface - got id
> scsi4 : SCSI emulation for USB Mass Storage devices
> drivers/usb/core/inode.c: creating file '009'
> usb 3-2: New USB device found, idVendor=05dc, idProduct=a400
> usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-2: Product: JUMPDRIVE
> usb 3-2: Manufacturer: LEXAR MEDIA
> usb 3-2: SerialNumber: 0A4EEC05201219080904
> usb-storage: device found at 9
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 4:0:0:0: Direct-Access     LEXAR    JUMPDRIVE        1000 PQ: 0 ANSI: 0 CCS
> sd 4:0:0:0: [sdg] 2026592 512-byte hardware sectors (1038 MB)
> sd 4:0:0:0: [sdg] Write Protect is off
> sd 4:0:0:0: [sdg] Mode Sense: 43 00 00 00
> sd 4:0:0:0: [sdg] Assuming drive cache: write through
> sd 4:0:0:0: [sdg] 2026592 512-byte hardware sectors (1038 MB)
> sd 4:0:0:0: [sdg] Write Protect is off
> sd 4:0:0:0: [sdg] Mode Sense: 43 00 00 00
> sd 4:0:0:0: [sdg] Assuming drive cache: write through
>  sdg: sdg1
> sd 4:0:0:0: [sdg] Attached SCSI removable disk
> sd 4:0:0:0: Attached scsi generic sg7 type 0
> sd 4:0:0:0: [sdg] Result: hostbyte=0x01 driverbyte=0x00
> end_request: I/O error, dev sdg, sector 3984

Yes, this is breakage in the scsi tree.  I believe that the offending patch
has been found and I have a nasty fix somewhere in my inbox - it involves
reverting a patch which doesn't revert properly.  I haven't got onto
looking at it yet, sorry.
