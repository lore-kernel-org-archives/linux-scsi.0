From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 9734] New: I/O error when inserting a second firewire
	sata disk
Date: Sat, 12 Jan 2008 19:11:44 -0600
Message-ID: <1200186705.3656.83.camel@localhost.localdomain>
References: <bug-9734-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56618 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbYAMBLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 20:11:54 -0500
In-Reply-To: <bug-9734-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Kristian Hoegsberg <krh@bitplanet.net>, linux1394-devel@lists.sourceforge.net

Firewire list cc'd

On Sat, 2008-01-12 at 07:47 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9734
> 
>            Summary: I/O error when inserting a second firewire sata disk
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.24 rc7
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: sbu@squadrainformatica.com
> 
> 
> Latest working kernel version: 2.6.18-5
> (can't test any other kernel between 2.6.18-5 and 2.6.22-3 because aren't in
> the repo)
> 
> Earliest failing kernel version: 2.6.22-3
> 
> Distribution: debian lenny 32bit AND 64 bit (it happens the same on both)
> 
> Hardware Environment: ibm x3400 quad core 2GB ram type/number 7976-KBG bios
> version 1.56 http://www-03.ibm.com/systems/x/tower/x3400/specs.html
> cpu info: -> http://www.pastebin.org/15078
> lspci firewire: -> http://www.pastebin.org/15081
> lsmod: -> http://www.pastebin.org/15083
> 
> Software Environment: bash
> 
> Problem Description:
> We have a 64bit pci double firewire 800 port to which I attach 2 sata hdd (it
> doesn't matter the brand of the hdd. We tried many)
> Everything works well until we use only one disk. Connecting a second disk when
> we are working on the first one (i.e. writing to the first device)  causes the
> interruption of the first job. once happened also a kernel freeze but we can't
> document and reproduce it right now.
> 
> Steps to reproduce:
> We attach a sata disk to the first port of the pci firewire B controller
> 
> 08:02.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b Link Layer
> Controller (rev 01)
> Jan 12 16:19:13 x3400 kernel: ieee1394: Error parsing configrom for node
> 1-00:1023
> Jan 12 16:19:13 x3400 kernel: ieee1394: Node changed: 1-00:1023 -> 1-01:1023
> Jan 12 16:19:14 x3400 kernel: ieee1394: Node resumed: ID:BUS[1-00:1023] 
> GUID[0030e002e0454697]
> Jan 12 16:19:14 x3400 kernel: scsi9 : SBP-2 IEEE-1394
> Jan 12 16:19:15 x3400 kernel: ieee1394: sbp2: Logged into SBP-2 device
> Jan 12 16:19:15 x3400 kernel: ieee1394: Node 1-00:1023: Max speed [S800] - Max
> payload [4096]
> Jan 12 16:19:15 x3400 kernel:   Vendor: WDC WD16  Model: 00JD-00HBC0       Rev:
> 08.0
> Jan 12 16:19:15 x3400 kernel:   Type:   Direct-Access-RBC                  ANSI
> SCSI revision: 04
> Jan 12 16:19:15 x3400 kernel: SCSI device sdc: 312579695 512-byte hdwr sectors
> (160041 MB)
> Jan 12 16:19:15 x3400 kernel: sdc: Write Protect is off
> Jan 12 16:19:15 x3400 kernel: sdc: Mode Sense: 11 00 00 00
> Jan 12 16:19:15 x3400 kernel: SCSI device sdc: drive cache: write back
> Jan 12 16:19:15 x3400 kernel: SCSI device sdc: 312579695 512-byte hdwr sectors
> (160041 MB)
> Jan 12 16:19:15 x3400 kernel: sdc: Write Protect is off
> Jan 12 16:19:15 x3400 kernel: sdc: Mode Sense: 11 00 00 00
> Jan 12 16:19:15 x3400 kernel: SCSI device sdc: drive cache: write back
> Jan 12 16:19:15 x3400 kernel:  sdc: unknown partition table
> Jan 12 16:19:15 x3400 kernel: sd 9:0:0:0: Attached scsi disk sdc
> 
> now we launch :
> dd if=/dev/zero of=/dev/sdc
> 
> everything ok until now
> 
> now we attach another sata disc to the second port of the pci firewire
> controller:
> 
> Jan 12 16:20:09 x3400 kernel: ieee1394: Error parsing configrom for node
> 1-00:1023
> Jan 12 16:20:09 x3400 kernel: ieee1394: Node changed: 1-00:1023 -> 1-01:1023
> Jan 12 16:20:09 x3400 kernel: ieee1394: Node changed: 1-01:1023 -> 1-02:1023
> Jan 12 16:20:10 x3400 kernel: ieee1394: Reconnected to SBP-2 device
> Jan 12 16:20:10 x3400 kernel: ieee1394: Node 1-01:1023: Max speed [S800] - Max
> payload [4096]
> 
> using 2.6.18-5-686 everything works well
> dd still works
> 
> now we disconnect the disk from the second port 
> 
> Jan 12 16:21:13 x3400 kernel: ieee1394: Node changed: 1-01:1023 -> 1-00:1023
> Jan 12 16:21:13 x3400 kernel: ieee1394: Node changed: 1-02:1023 -> 1-01:1023
> Jan 12 16:21:13 x3400 kernel: ieee1394: Reconnected to SBP-2 device
> Jan 12 16:21:13 x3400 kernel: ieee1394: Node 1-00:1023: Max speed [S800] - Max
> payload [4096]
> 
> everything ok also disconnecting the second device
> 
> -------------------------------------------------------
> 
> now the same issue using 2.6.24-rc7-686:
> 
> we attach a sata disk to the first port of the pci firewire B controller
> 
> Jan 12 16:49:45 x3400 kernel: firewire_core: phy config: card 1, new root=ffc1,
> gap_count=5
> Jan 12 16:49:46 x3400 kernel: scsi11 : SBP-2 IEEE-1394
> Jan 12 16:49:46 x3400 kernel: firewire_core: created new fw device fw2 (2
> config rom retries, S800)
> Jan 12 16:49:46 x3400 kernel: firewire_sbp2: logged in to fw2.0 LUN 0000 (0
> retries)
> Jan 12 16:49:46 x3400 kernel: scsi 11:0:0:0: Direct-Access-RBC WDC WD16
> 00JD-00HBC0      08.0 PQ: 0 ANSI: 4
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] 312579695 512-byte hardware
> sectors (160041 MB)
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Write Protect is off
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Mode Sense: 11 00 00 00
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] 312579695 512-byte hardware
> sectors (160041 MB)
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Write Protect is off
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Mode Sense: 11 00 00 00
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Jan 12 16:49:46 x3400 kernel:  sdc: unknown partition table
> Jan 12 16:49:46 x3400 kernel: sd 11:0:0:0: [sdc] Attached SCSI disk
> 
> now we launch :
> dd if=/dev/zero of=/dev/sdc
> 
> now we attach another sata disk to the second port of the pci firewire B
> controller:
> 
> Jan 12 16:50:49 x3400 kernel: firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK

Best I can tell, this is the source of the problem.  The sbp2 driver is
replying DID_BUS_BUSY until that gets sorted out, which seems to be
never.

So, first pass analysis indicates the error to be in the firewire
subsystem.  I'm guessing from the message that it's actually
drivers/firewire, not drivers iee1934?

> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2942302
> Jan 12 16:50:49 x3400 kernel: printk: 571588 messages suppressed.
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942302
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942303
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942304
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942305
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942306
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942307
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942308
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942309
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942310
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: Buffer I/O error on device sdc, logical block
> 2942311
> Jan 12 16:50:49 x3400 kernel: lost page write due to I/O error on sdc
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2942557
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2942812
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2943067
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2943322
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2943577
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2943832
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2944087
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2944342
> Jan 12 16:50:49 x3400 kernel: sd 11:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY
> driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 12 16:50:49 x3400 kernel: end_request: I/O error, dev sdc, sector 2944597
> 
> it goes on this way until when we kill the dd
> 
> thanks in advance
> 
> damko & divilinux

James


