From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mpt2sas errors help
Date: Tue, 27 Sep 2011 19:19:00 -0400
Message-ID: <20110927231900.GF9158@animx.eu.org>
References: <7863850E8C98C748980632D9D3B7C1990A275C6AA6@inbmail02.lsi.com>
 <A6888A6805518E4EA4AF7072A28264A6042AE85B1B@inbmail02.lsi.com>
 <20110927105634.GD10514@animx.eu.org>
 <A6888A6805518E4EA4AF7072A28264A6042AE85B80@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:55570 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab1I0XTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2011 19:19:03 -0400
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6042AE85B80@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Nandigama, Nagalakshmi wrote:
> Request to upgrade your controller card to latest firmware and test.
> The latest firmware can be downloaded from http://www.lsi.com/channel/products/storagecomponents/Pages/HBAs.aspx

Ok, I did that.  I have not rebooted, but the program did reset the
controller.  I did a test on 1 drive like this:

sdb is on phy-0 on the card (which is the one I had problems with)
# dd if=/dev/sdb of=/dev/null bs=128k count=50000 
50000+0 records in
50000+0 records out
6553600000 bytes (6.6 GB) copied, 47.4533 s, 138 MB/s
#
By the time I get to 500mb, I would have had errors before, no errors at
all.

I have a raid5 (currently degraded as one drive died) as md2 with the disks
at phy-[012].  I ran the same dd (x10 count)
# dd if=/dev/md2 of=/dev/null bs=128k count=500000
437964+0 records in
437963+0 records out
57404686336 bytes (57 GB) copied, 184.517 s, 311 MB/s
500000+0 records in
500000+0 records out
65536000000 bytes (66 GB) copied, 206.341 s, 318 MB/s
#

No errors again (NOTE: I sent USR1 to dd to get the status).  I do find it
odd that the speed is faster at the end.

Thanks for your help.

> -----Original Message-----
> From: Wakko Warner [mailto:wakko@animx.eu.org]
> Sent: Tuesday, September 27, 2011 4:27 PM
> To: Nandigama, Nagalakshmi
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: mpt2sas errors help
> 
> Nandigama, Nagalakshmi wrote:
> > Can you provide the dmesg when the driver is loaded. We need to know the firmware version.
> 
> Sure.
> 
> FWVersion(02.00.50.00), ChipRevision(0x02), BiosVersion(07.01.00.00)
> 
> Here's the relevent dmesg.  The driver is compiled into the kernel.
> 
> 2011-09-24 20:06:15 kame kernel:[    1.593758] scsi0 : Fusion MPT SAS Host
> 2011-09-24 20:06:15 kame kernel:[    1.593968] mpt2sas 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> 2011-09-24 20:06:15 kame kernel:[    1.594041] mpt2sas 0000:03:00.0: setting latency timer to 64
> 2011-09-24 20:06:15 kame kernel:[    1.594044] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (12301640 kB)
> 2011-09-24 20:06:15 kame kernel:[    1.594162] mpt2sas0: IO-APIC enabled: IRQ 16
> 2011-09-24 20:06:15 kame kernel:[    1.594222] mpt2sas0: iomem(0x00000000fac3c000), mapped(0xffffc90000020000), size(16384)
> 2011-09-24 20:06:15 kame kernel:[    1.594306] mpt2sas0: ioport(0x000000000000a000), size(256)
> 2011-09-24 20:06:15 kame kernel:[    1.880709] mpt2sas0: sending diag reset !!
> 2011-09-24 20:06:15 kame kernel:[    2.359691] Refined TSC clocksource calibration: 2133.333 MHz.
> 2011-09-24 20:06:15 kame kernel:[    2.359763] Switching to clocksource tsc
> 2011-09-24 20:06:15 kame kernel:[    2.822788] mpt2sas0: diag reset: SUCCESS
> 2011-09-24 20:06:15 kame kernel:[    2.978161] mpt2sas0: Allocated physical memory: size(4005 kB)
> 2011-09-24 20:06:15 kame kernel:[    2.978226] mpt2sas0: Current Controller Queue Depth(1754), Max Controller Queue Depth(2015)
> 2011-09-24 20:06:15 kame kernel:[    2.978310] mpt2sas0: Scatter Gather Elements per IO(128)
> 2011-09-24 20:06:15 kame kernel:[    3.210350] mpt2sas0: LSISAS2008: FWVersion(02.00.50.00), ChipRevision(0x02), BiosVersion(07.01.00.00)
> 2011-09-24 20:06:15 kame kernel:[    3.210449] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> 2011-09-24 20:06:15 kame kernel:[    3.210999] mpt2sas0: sending port enable !!
> 2011-09-24 20:06:15 kame kernel:[    4.947725] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b001d0ab00), phys(8)
> 2011-09-24 20:06:15 kame kernel:[   11.931002] mpt2sas0: port enable: SUCCESS
-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
