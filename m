From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: /dev/sda with 8 byte offset
Date: Sat, 29 Sep 2007 13:31:47 +0200 (CEST)
Message-ID: <tkrat.2208603358dde0a4@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
 <46FAC72F.5020304@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0709271916470.23129@valhalla.fs.tum.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54419 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbXI2LcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 07:32:22 -0400
In-Reply-To: <Pine.LNX.4.64.0709271916470.23129@valhalla.fs.tum.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Rutzinger <rutzi@fs.tum.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 27 Sep, Stefan Rutzinger wrote:
> On Wed, 26 Sep 2007, Stefan Richter wrote:
>> By the way, in addition to the 8 bytes offset which you found, there is
>> also a difference in the reported disk size.  The USB firmware says
>> 390721969 sectors, the FireWire firmware says 390721968 sectors.  The
>> USB firmware's value seems to be the wrong one.
> 
> Yes, i saw that as well. But one after the other. I'll send some more 
> logging info to make things complete. Take a look at the dmesg, 
> there's some failure in cache recognition. Hope it helps:
> 
> The disk worked well with 2.4 kernels. I can't track down the 2.6 kernel 
> histoy perfectly, but according to a memo, 2.6.15 was installed last year 
> November, while the disk was still fine in march. Seems reasonable that I 
> made a backup in march before another kernel upgrade without a full 
> hardware test afterwards.
> 
> And no, firmware was never touched or updated.
[...logs etc. snipped...]

I swapped the DVD-RW in my only PL3507 based enclosure out for a HDD.
The enclosure has a firmware written or modified by MacPower.

>From Linux 2.6.23-rc6, connected via USB:

usb 1-8: new high speed USB device using ehci_hcd and address 18
usb 1-8: configuration #1 chosen from 1 choice
scsi59 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 18
usb-storage: waiting for device to settle before scanning
scsi 59:0:0:0: Direct-Access     ST340083 2A               3.03 PQ: 0 ANSI: 0
sd 59:0:0:0: [sde] 781422769 512-byte hardware sectors (400088 MB)
sd 59:0:0:0: [sde] Write Protect is off
sd 59:0:0:0: [sde] Mode Sense: 03 00 00 00
sd 59:0:0:0: [sde] Assuming drive cache: write through
sd 59:0:0:0: [sde] 781422769 512-byte hardware sectors (400088 MB)
sd 59:0:0:0: [sde] Write Protect is off
sd 59:0:0:0: [sde] Mode Sense: 03 00 00 00
sd 59:0:0:0: [sde] Assuming drive cache: write through
 sde: sde1
sd 59:0:0:0: [sde] Attached SCSI disk
sd 59:0:0:0: Attached scsi generic sg4 type 0
usb-storage: device scan complete
sd 59:0:0:0: [sde] Sense Key : No Sense [current]
sd 59:0:0:0: [sde] Add. Sense: No additional sense information

# fdisk -l /dev/sde

Disk /dev/sde: 400.0 GB, 400088457728 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       48641   390708801   83  Linux

# dd if=/dev/sde of=mbr_usb bs=512 count=1
1+0 records in
1+0 records out
512 bytes (512 B) copied, 0.0214703 s, 23.8 kB/s


Connected via FireWire, using the new drivers:

scsi60 : SBP-2 IEEE-1394
firewire_core: created new fw device fw4 (3 config rom retries, S400)
firewire_core: phy config: card 1, new root=ffc0, gap_count=5
firewire_sbp2: logged in to fw4.0 LUN 0000 (0 retries)
scsi 60:0:0:0: Direct-Access-RBC ST340083 2A                    PQ: 0 ANSI: 4
sd 60:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 60:0:0:0: [sde] Write Protect is off
sd 60:0:0:0: [sde] Mode Sense: 11 00 00 00
sd 60:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 60:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 60:0:0:0: [sde] Write Protect is off
sd 60:0:0:0: [sde] Mode Sense: 11 00 00 00
sd 60:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde:<5>firewire_sbp2: sbp2_scsi_abort
sd 60:0:0:0: scsi: Device offlined - not ready after error recovery
sd 60:0:0:0: [sde] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sde, sector 0
Buffer I/O error on device sde, logical block 0
sd 60:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde, logical block 0
sd 60:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde, logical block 0
ldm_validate_partition_table(): Disk read failed.
sd 60:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde, logical block 0
sd 60:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde, logical block 0
 unable to read partition table
sd 60:0:0:0: [sde] Attached SCSI disk
sd 60:0:0:0: Attached scsi generic sg4 type 14


Connected via FireWire, using the old drivers:

scsi65 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node 1-00:1023: Max speed [S400] - Max payload [2048]
scsi 65:0:0:0: Direct-Access-RBC ST340083 2A                    PQ: 0 ANSI: 4
sd 65:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 65:0:0:0: [sdf] Write Protect is off
sd 65:0:0:0: [sdf] Mode Sense: 11 00 00 00
sd 65:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 65:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 65:0:0:0: [sdf] Write Protect is off
sd 65:0:0:0: [sdf] Mode Sense: 11 00 00 00
sd 65:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
sd 65:0:0:0: [sdf] Attached SCSI disk
sd 65:0:0:0: Attached scsi generic sg4 type 14

Before this there was a login failure, something which I'm used to with
this device.  A little bit of replugging or power cycling got it to log
in.

# fdisk -l /dev/sdf

Disk /dev/sdf: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1       48641   390708801   83  Linux

# dd if=/dev/sdf of=mbr_1394 bs=512 count=1
1+0 records in
1+0 records out
512 bytes (512 B) copied, 0.000914592 s, 560 kB/s

# diff mbr_*

So, while fw-sbp2 and sbp2 under Linux 2.6.23-rc (fw-sbp2 with patches
scheduled for 2.6.24) both have more or less difficulties to connect to
the device, the MBR is the same as with USB and I can mount the existing
partition and read data (which are the same as when I wrote them some
time ago using an OXUF922 based enclosure).

So either you have something else than a PL3507 or your firmware is too
different from mine or my setup somehow failed to trigger the bug --- at
least with the old drivers once they are able to log in, while the new
drivers consistently end up with an offlined SCSI device.  This could be
an unrelated bug in the new drivers though.

Note how I too get different disk sizes from USB and FireWire: 781422769
sectors = bogus USB value versus 781422768 sectors = most certainly the
correct value via FireWire.  (The firmwares for the USB and FireWire
parts of the PL3507 are AFAIK entirely separate.)  This off-by-one bug
in USB firmware is a quite common one.

Since you seem to have a Windows box at your disposal, try running the
Prolific firmware uploader.  I think it works through USB also for
updating the FireWire firmware.  The uploader should first tell you
whether it is a PL3507 at all and what firmware it has currently
installed.  
-- 
Stefan Richter
-=====-=-=== =--= ===-=
http://arcgraph.de/sr/

