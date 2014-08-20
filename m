From: worley@alum.mit.edu (Dale R. Worley)
Subject: Problem with USB-to-SATA adapters
Date: Wed, 20 Aug 2014 16:18:00 -0400
Message-ID: <201408202018.s7KKI03d018940@hobgoblin.ariadne.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:57458
	"EHLO qmta04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbaHTUTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2014 16:19:06 -0400
Received: from hobgoblin.ariadne.com (hobgoblin.ariadne.com [127.0.0.1])
	by hobgoblin.ariadne.com (8.14.7/8.14.7) with ESMTP id s7KKI1hO018941
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2014 16:18:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I don't know if this is the correct place for this problem, but you
people can probably tell me the correct place.

I have two "USB to SATA adapter" dongles.  In general, they work fine.
However I've discovered that one of them handles large (1 TB and
above) drives correctly and one does not.  In particular, when I use
the unsuccessful one, neither fdisk nor gdisk reports the disk size
correctly, and the kernel does not read the partition table.

More confusingly, both dongles work correctly with large disks on
Windows 7 Professional.

Both of the following cases are when a 3.0 TB drive is attached.

The successful device has the "Diablo" brand.  The most interesting
messages in the log when I plug in the USB are (the complete message
set is appended below):

Aug 18 21:56:53 hobgoblin kernel: [  294.229462] usb 2-1.3: New USB device found, idVendor=152d, idProduct=2338
Aug 18 21:56:53 hobgoblin kernel: [  294.229475] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
Aug 18 21:56:53 hobgoblin kernel: [  294.229482] usb 2-1.3: Product: USB to ATA/ATAPI bridge
Aug 18 21:56:53 hobgoblin kernel: [  294.229488] usb 2-1.3: Manufacturer: JMicron
Aug 18 21:56:53 hobgoblin kernel: [  294.229495] usb 2-1.3: SerialNumber: 000001D91CC4
Aug 18 21:56:54 hobgoblin kernel: [  295.236576] sd 7:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Aug 18 21:56:54 hobgoblin kernel: [  295.236955] sd 7:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)

The unsuccessful device has the "Ez-Connect" brand.  The most
interesting messages in the log when I plug in the USB are (the
complete message set is appended below):

Aug 18 21:54:06 hobgoblin kernel: [  127.674374] usb 2-2: new high-speed USB device number 4 using ehci-pci
Aug 18 21:54:06 hobgoblin kernel: [  127.791128] usb 2-2: New USB device found, idVendor=05e3, idProduct=0718
Aug 18 21:54:06 hobgoblin kernel: [  127.791135] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=2
Aug 18 21:54:06 hobgoblin kernel: [  127.791138] usb 2-2: Product: USB Storage
Aug 18 21:54:06 hobgoblin kernel: [  127.791142] usb 2-2: SerialNumber: 000000000033
Aug 18 21:54:07 hobgoblin kernel: [  128.847269] sd 6:0:0:0: [sdb] 1565565872 512-byte logical blocks: (801 GB/746 GiB)

Dale

----------------------------------------------------------------------
For the Diablo adapter:

Aug 18 21:56:53 hobgoblin kernel: [  294.153343] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug 18 21:56:53 hobgoblin kernel: [  294.229462] usb 2-1.3: New USB device found, idVendor=152d, idProduct=2338
Aug 18 21:56:53 hobgoblin kernel: [  294.229475] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
Aug 18 21:56:53 hobgoblin kernel: [  294.229482] usb 2-1.3: Product: USB to ATA/ATAPI bridge
Aug 18 21:56:53 hobgoblin kernel: [  294.229488] usb 2-1.3: Manufacturer: JMicron
Aug 18 21:56:53 hobgoblin kernel: [  294.229495] usb 2-1.3: SerialNumber: 000001D91CC4
Aug 18 21:56:53 hobgoblin kernel: [  294.231159] usb-storage 2-1.3:1.0: USB Mass Storage device detected
Aug 18 21:56:53 hobgoblin kernel: [  294.233951] scsi7 : usb-storage 2-1.3:1.0
Aug 18 21:56:53 hobgoblin mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.3"
Aug 18 21:56:53 hobgoblin mtp-probe: bus: 2, device: 5 was not an MTP device
Aug 18 21:56:54 hobgoblin kernel: [  295.235735] scsi 7:0:0:0: Direct-Access     WDC WD30 EZRX-00SPEB0          PQ: 0 ANSI: 5
Aug 18 21:56:54 hobgoblin kernel: [  295.236209] sd 7:0:0:0: Attached scsi generic sg2 type 0
Aug 18 21:56:54 hobgoblin kernel: [  295.236576] sd 7:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Aug 18 21:56:54 hobgoblin kernel: [  295.236955] sd 7:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Aug 18 21:56:54 hobgoblin kernel: [  295.237957] sd 7:0:0:0: [sdb] Write Protect is off
Aug 18 21:56:54 hobgoblin kernel: [  295.238957] sd 7:0:0:0: [sdb] No Caching mode page found
Aug 18 21:56:54 hobgoblin kernel: [  295.238962] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:56:54 hobgoblin kernel: [  295.239956] sd 7:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Aug 18 21:56:54 hobgoblin kernel: [  295.242334] sd 7:0:0:0: [sdb] No Caching mode page found
Aug 18 21:56:54 hobgoblin kernel: [  295.242339] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:56:54 hobgoblin kernel: [  295.305631] GPT:Primary header thinks Alt. header is not at the end of the disk.
Aug 18 21:56:54 hobgoblin kernel: [  295.305638] GPT:1565565871 != 5860533167
Aug 18 21:56:54 hobgoblin kernel: [  295.305639] GPT:Alternate GPT header not at the end of the disk.
Aug 18 21:56:54 hobgoblin kernel: [  295.305640] GPT:1565565871 != 5860533167
Aug 18 21:56:54 hobgoblin kernel: [  295.305642] GPT: Use GNU Parted to correct GPT errors.
Aug 18 21:56:54 hobgoblin kernel: [  295.305653]  sdb: sdb1 sdb2 sdb3 sdb4
Aug 18 21:56:54 hobgoblin kernel: [  295.308235] sd 7:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Aug 18 21:56:54 hobgoblin kernel: [  295.310974] sd 7:0:0:0: [sdb] No Caching mode page found
Aug 18 21:56:54 hobgoblin kernel: [  295.310980] sd 7:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:56:54 hobgoblin kernel: [  295.310984] sd 7:0:0:0: [sdb] Attached SCSI disk
----------------------------------------------------------------------
For the Ez-Connect adapter:

Aug 18 21:54:06 hobgoblin kernel: [  127.674374] usb 2-2: new high-speed USB device number 4 using ehci-pci
Aug 18 21:54:06 hobgoblin kernel: [  127.791128] usb 2-2: New USB device found, idVendor=05e3, idProduct=0718
Aug 18 21:54:06 hobgoblin kernel: [  127.791135] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=2
Aug 18 21:54:06 hobgoblin kernel: [  127.791138] usb 2-2: Product: USB Storage
Aug 18 21:54:06 hobgoblin kernel: [  127.791142] usb 2-2: SerialNumber: 000000000033
Aug 18 21:54:06 hobgoblin mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-2"
Aug 18 21:54:06 hobgoblin mtp-probe: bus: 2, device: 4 was not an MTP device
Aug 18 21:54:06 hobgoblin kernel: [  127.839825] usb-storage 2-2:1.0: USB Mass Storage device detected
Aug 18 21:54:06 hobgoblin kernel: [  127.839917] scsi6 : usb-storage 2-2:1.0
Aug 18 21:54:06 hobgoblin kernel: [  127.840721] usbcore: registered new interface driver usb-storage
Aug 18 21:54:07 hobgoblin kernel: [  128.844942] scsi 6:0:0:0: Direct-Access     WDC WD30 EZRX-00SPEB0     0041 PQ: 0 ANSI: 0
Aug 18 21:54:07 hobgoblin kernel: [  128.846146] sd 6:0:0:0: Attached scsi generic sg2 type 0
Aug 18 21:54:07 hobgoblin kernel: [  128.847269] sd 6:0:0:0: [sdb] 1565565872 512-byte logical blocks: (801 GB/746 GiB)
Aug 18 21:54:07 hobgoblin kernel: [  128.848303] sd 6:0:0:0: [sdb] Write Protect is off
Aug 18 21:54:07 hobgoblin kernel: [  128.849389] sd 6:0:0:0: [sdb] No Caching mode page found
Aug 18 21:54:07 hobgoblin kernel: [  128.849398] sd 6:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:54:07 hobgoblin kernel: [  128.853028] sd 6:0:0:0: [sdb] No Caching mode page found
Aug 18 21:54:07 hobgoblin kernel: [  128.853038] sd 6:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:54:08 hobgoblin kernel: [  129.638416]  sdb: sdb1 sdb2 sdb3
Aug 18 21:54:08 hobgoblin kernel: [  129.641877] sd 6:0:0:0: [sdb] No Caching mode page found
Aug 18 21:54:08 hobgoblin kernel: [  129.641884] sd 6:0:0:0: [sdb] Assuming drive cache: write through
Aug 18 21:54:08 hobgoblin kernel: [  129.641889] sd 6:0:0:0: [sdb] Attached SCSI disk
----------------------------------------------------------------------
