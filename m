From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
Subject: Problem with USB-to-SATA adapters (was: AS2105-based enclosure size issues with >2TB HDDs)
Date: Tue, 26 Aug 2014 15:39:42 -0400
Message-ID: <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br> <1408972618.10300.35.camel@linux-fkkt.site>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1408972618.10300.35.camel-B2T3B9s34ElbnMAlSieJcQ@public.gmane.org> (oneukum-l3A5Bk7waGM@public.gmane.org)
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is almost certainly a form of the problem reported in
"AS2105-based enclosure size issues with >2TB HDDs".  I'm repeating my
original message here so linux-usb can see it, and so it can be
connected to the older thread.  I'll address it in another message.

I've appended James Bottomley's response, to avoid creating an
additional message.

Dale
----------
Date:	Wed, 20 Aug 2014 16:18:00 -0400
From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Problem with USB-to-SATA adapters

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
Subject: Re: Problem with USB-to-SATA adapters
From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Date: Wed, 20 Aug 2014 17:45:48 -0500

[clipped]

So the basic problem here seems to be that this adapter has wrapped the
INQUIRY response instead of giving us the the conventional response that
means my device is too big.  This could be because the processing engine
on the card doesn't understand 16 byte commands (which are required for
addressing capacity > 2TB) or it could just be a firmware SCSI emulator
mistake.  The best way of telling might be to use the SG_IO interface to
send a read capacity 16.  sg_readcap --16 should be able to do this.

If you get a sensible response, chances are we should just quirk this
device to apply RC16 first.  If something goes wrong, it's likely
unfixably broken for devices > 2TB

James
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
