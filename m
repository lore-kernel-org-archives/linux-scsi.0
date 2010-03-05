From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: LSI SAS changes SCSI address and by-path on hot-swap
Date: Fri, 05 Mar 2010 11:52:52 +0530
Message-ID: <1267770172.8894.24.camel@mulgrave.site>
References: <4B8FE5F2.2040506@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0CEGXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2010 01:23:03 -0500
In-Reply-To: <4B8FE5F2.2040506@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2010-03-04 at 17:55 +0100, Asdo wrote: 
> we need to buy new controllers for new storages we are building.
> 
> LSI SAS HBAs are very attractive for our purposes but I identified a 
> problem with our existing mainboard-integrated LSI SAS 1068E . The 
> problem is that it is apparently not possble to use the 
> /dev/disk/by-path feature of Linux with it. At least not with the kernel 
> 2.6.24 we are using (excuse me if it has already been fixed on latest 
> kernels: the server is in production now and it's not easy for us to check).
> 
> We need the /dev/disk/by-path feature because we commonly do hot-swaps 
> with drives and we need to know for sure which HDD slot corresponds to a 
> certain linux block device. With other controllers like 3ware 9650SE 
> there is no such problem, ok but that's a SATA controller... I don't 
> know if the problem is by design with SAS controllers.
> 
> Actually the problem is even more complicated because for the new 
> storages we have planned to assemble there would be SAS expanders in the 
> middle.
> 
> Look, here is an hot-swap seen from the dmesg:
> 
>         Feb 22 14:27:30 myserver kernel: [655437.601971] mptbase: ioc0: 
> LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00)
>         Feb 22 14:27:35 myserver kernel: [655442.781061] mptsas: ioc0: 
> removing sata device, channel 0, id 0, phy 0
>         Feb 22 14:27:35 myserver kernel: [655442.781453] sd 5:0:10:0: 
> [sdu] Synchronizing SCSI cache
>         Feb 22 14:27:35 myserver kernel: [655442.781495] sd 5:0:10:0: 
> [sdu] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>         Feb 22 14:28:22 myserver kernel: [655489.237562] mptsas: ioc0: 
> attaching sata device, channel 0, id 0, phy 0
>         Feb 22 14:28:22 myserver kernel: [655489.241959] scsi 5:0:11:0: 
> Direct-Access     ATA      WDC WD10EADS-00P 0A01 PQ: 0 ANSI: 5
>         Feb 22 14:28:22 myserver kernel: [655489.242506] sd 5:0:11:0: 
> [sdu] 1953525168 512-byte hardware sectors (1000205 MB)
>         Feb 22 14:28:22 myserver kernel: [655489.248104] sd 5:0:11:0: 
> [sdu] Write Protect is off
>         Feb 22 14:28:22 myserver kernel: [655489.251847] sd 5:0:11:0: 
> [sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>         Feb 22 14:28:22 myserver kernel: [655489.252161] sd 5:0:11:0: 
> [sdu] 1953525168 512-byte hardware sectors (1000205 MB)
>         Feb 22 14:28:22 myserver kernel: [655489.257758] sd 5:0:11:0: 
> [sdu] Write Protect is off
>         Feb 22 14:28:22 myserver kernel: [655489.261518] sd 5:0:11:0: 
> [sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>         Feb 22 14:28:22 myserver kernel: [655489.261525]  sdu: unknown 
> partition table
>         Feb 22 14:28:22 myserver kernel: [655489.287152] sd 5:0:11:0: 
> [sdu] Attached SCSI disk
>         Feb 22 14:28:22 myserver kernel: [655489.287204] sd 5:0:11:0: 
> Attached scsi generic sg21 type 0
> 
> You see, when I remove the disk it takes away device sd 5:0:10:0 and 
> when I reinsert a new drive it becomes device sd 5:0:11:0.
> 
> the /dev/disk/by-path the file to the disk also changes, from:
>      
> /dev/disk/by-path/pci-0000:0b:00.0-sas-0x500e08101003c820:1:0-0x1221000000000000:0 
> 
> to:
>      
> /dev/disk/by-path/pci-0000:0b:00.0-sas-0x500e08101003c824:1:4-0x1221000000000000:0
> (note: I'm not 100% sure that these two entries come from the same 
> hot-swap as the dmesg above)
> 
> in rare cases I noticed that after an hot swap the file in 
> /dev/disk/by-path for the device is not even recreated.
> 
> I also cannot trust drive letters because they can change across reboot, 
> and they also change if I remove drive A, remove drive B, insert drive 
> B, insert drive A... the letters would be swapped. So it's not reliable 
> enough for our use.
> 
> So is this a real bug and is maybe fixed on newer kernels, or it is by 
> design?
> 
> How can people reliably use hot-swap hardware in this situation...? Are 
> there other ways to determine the physical connections from within linux 
> (possibly through SAS expanders also), which I am not aware of?

So what I think I hear in the foregoing is that you actually want to
identify a device by slot number in the chassis?

For that, /dev/disk/by-path will never work; you need to be using
enclosure services.

However, since you mention you'll be using SAS and expanders, there is a
way to get to the slot numbers without using enclosure services:  They
phy numbers of the expander (and HBA) ports usually correspond one for
one with the slot.

So for sda, if, in my system, you look at /sys/block/sda/device, it's a
symbolic link for

/sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/0000:03:04.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:0

The thing you want is the port-3.0.  If you look in sysfs at this:

ls /sys/class/sas_port/port-3\:0/device

Mine contains phy-3:4  Showing this disk is actually connected to phy 4
of the output device (as the HBA counts).

For expanders it's a little more complex, you'll see multiple ports in
the path, but it's the phy of the last one you want.

James


