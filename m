From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Reducing the verbosity of inserting a USB storage device
Date: Sun, 20 Sep 2009 16:53:49 -0600
Message-ID: <20090920225348.GB3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


The current kernel is very verbose when you insert a new USB storage
device:

usb 1-2: new high speed USB device using ehci_hcd and address 9
usb 1-2: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 9
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 4:0:0:0: Direct-Access     GENERIC  USB DISK DEVICE  0100 PQ: 0 ANSI: 0 CCS
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: [sdc] 15728128 512-byte hardware sectors: (8.05 GB/7.49 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 12 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
sd 4:0:0:0: [sdc] Assuming drive cache: write through
 sdc:
sd 4:0:0:0: [sdc] Attached SCSI removable disk

I think we can print a bit less information, and format it more densely.
With the following three patches, my kernel prints:

usb 1-4: new high speed USB device using ehci_hcd and address 5
usb 1-4: configuration #1 chosen from 1 choice
scsi 6:0:0:0: Direct-Access              Flash Disk       5.00 PQ: 0 ANSI: 2
sd 6:0:0:0: Attached scsi generic sg1 type 0
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 2009088 512-byte logical blocks: (1.02 GB/981 MiB)
sd 6:0:0:0: [sdb] Removable disk, Write Protect is off
 sdb: unknown partition table

which doesn't take up nearly as much of my syslog ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
