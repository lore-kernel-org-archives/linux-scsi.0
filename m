From: Asdo <asdo@shiftmail.org>
Subject: LSI SAS changes SCSI address and by-path on hot-swap
Date: Thu, 04 Mar 2010 17:55:14 +0100
Message-ID: <4B8FE5F2.2040506@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:63306 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab0CDQzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2010 11:55:37 -0500
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-b2 #31825) id <01NKCZ276NDSBFE89A@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Thu, 04 Mar 2010 17:55:13 +0100
Received: from [10.0.123.137] (firewall-itb.itb.cnr.it [155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-b2 #31826)
 with ESMTPSA id <01NKCZ24WZM6C51C7W@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Thu, 04 Mar 2010 17:55:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello all,

we need to buy new controllers for new storages we are building.

LSI SAS HBAs are very attractive for our purposes but I identified a 
problem with our existing mainboard-integrated LSI SAS 1068E . The 
problem is that it is apparently not possble to use the 
/dev/disk/by-path feature of Linux with it. At least not with the kernel 
2.6.24 we are using (excuse me if it has already been fixed on latest 
kernels: the server is in production now and it's not easy for us to check).

We need the /dev/disk/by-path feature because we commonly do hot-swaps 
with drives and we need to know for sure which HDD slot corresponds to a 
certain linux block device. With other controllers like 3ware 9650SE 
there is no such problem, ok but that's a SATA controller... I don't 
know if the problem is by design with SAS controllers.

Actually the problem is even more complicated because for the new 
storages we have planned to assemble there would be SAS expanders in the 
middle.

Look, here is an hot-swap seen from the dmesg:

        Feb 22 14:27:30 myserver kernel: [655437.601971] mptbase: ioc0: 
LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00)
        Feb 22 14:27:35 myserver kernel: [655442.781061] mptsas: ioc0: 
removing sata device, channel 0, id 0, phy 0
        Feb 22 14:27:35 myserver kernel: [655442.781453] sd 5:0:10:0: 
[sdu] Synchronizing SCSI cache
        Feb 22 14:27:35 myserver kernel: [655442.781495] sd 5:0:10:0: 
[sdu] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
        Feb 22 14:28:22 myserver kernel: [655489.237562] mptsas: ioc0: 
attaching sata device, channel 0, id 0, phy 0
        Feb 22 14:28:22 myserver kernel: [655489.241959] scsi 5:0:11:0: 
Direct-Access     ATA      WDC WD10EADS-00P 0A01 PQ: 0 ANSI: 5
        Feb 22 14:28:22 myserver kernel: [655489.242506] sd 5:0:11:0: 
[sdu] 1953525168 512-byte hardware sectors (1000205 MB)
        Feb 22 14:28:22 myserver kernel: [655489.248104] sd 5:0:11:0: 
[sdu] Write Protect is off
        Feb 22 14:28:22 myserver kernel: [655489.251847] sd 5:0:11:0: 
[sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
        Feb 22 14:28:22 myserver kernel: [655489.252161] sd 5:0:11:0: 
[sdu] 1953525168 512-byte hardware sectors (1000205 MB)
        Feb 22 14:28:22 myserver kernel: [655489.257758] sd 5:0:11:0: 
[sdu] Write Protect is off
        Feb 22 14:28:22 myserver kernel: [655489.261518] sd 5:0:11:0: 
[sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
        Feb 22 14:28:22 myserver kernel: [655489.261525]  sdu: unknown 
partition table
        Feb 22 14:28:22 myserver kernel: [655489.287152] sd 5:0:11:0: 
[sdu] Attached SCSI disk
        Feb 22 14:28:22 myserver kernel: [655489.287204] sd 5:0:11:0: 
Attached scsi generic sg21 type 0

You see, when I remove the disk it takes away device sd 5:0:10:0 and 
when I reinsert a new drive it becomes device sd 5:0:11:0.

the /dev/disk/by-path the file to the disk also changes, from:
     
/dev/disk/by-path/pci-0000:0b:00.0-sas-0x500e08101003c820:1:0-0x1221000000000000:0 

to:
     
/dev/disk/by-path/pci-0000:0b:00.0-sas-0x500e08101003c824:1:4-0x1221000000000000:0
(note: I'm not 100% sure that these two entries come from the same 
hot-swap as the dmesg above)

in rare cases I noticed that after an hot swap the file in 
/dev/disk/by-path for the device is not even recreated.

I also cannot trust drive letters because they can change across reboot, 
and they also change if I remove drive A, remove drive B, insert drive 
B, insert drive A... the letters would be swapped. So it's not reliable 
enough for our use.

So is this a real bug and is maybe fixed on newer kernels, or it is by 
design?

How can people reliably use hot-swap hardware in this situation...? Are 
there other ways to determine the physical connections from within linux 
(possibly through SAS expanders also), which I am not aware of?

Thank you
Asdo
