From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: need help solving mpt2sas target unplug can hang worker thread
Date: Tue, 28 Feb 2012 17:18:53 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E672DE4@inbmail02.lsi.com>
References: <20120214131541.GA28005@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E49FF7F@inbmail02.lsi.com>
 <20120222001650.GA16640@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:59234 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965451Ab2B1LtC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2012 06:49:02 -0500
In-Reply-To: <20120222001650.GA16640@crust.elkhashab.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

It seems like you are using older version of mpt2sas driver. Current version of mpt2sas driver is 12.100.00.00. Will it be possible to you to test with the latest or any stable driver? Also can you take update the latest firmware?

Regards,
Nagalakshmi


-----Original Message-----
From: Ayman El-Khashab [mailto:ayman@elkhashab.com]
Sent: Wednesday, February 22, 2012 5:47 AM
To: Nandigama, Nagalakshmi
Cc: linux-scsi@vger.kernel.org
Subject: Re: need help solving mpt2sas target unplug can hang worker thread

On Thu, Feb 16, 2012 at 10:42:07AM +0530, Nandigama, Nagalakshmi wrote:
> Please provide the mpt2sas driver version that you are also using.
>
> Please set the driver logging level to 0x421F8 (echo 0x421F8 > /sys/module/mpt2sas/parameters/logging_level) and the scsi logging level to 0x180000F1 (echo 0x180000F1 > /proc/sys/dev/scsi/logging_level) and recreate the issue and provide the var/log/message.
>

I've pasted the logs below.  This is the mpt2sas driver (as
a module) from 2.6.37.6.  We've made some changes to it for
our instrumentation purposes, but we don't get past the
enumeration so we don't get to our changes in the code.  The
only change we do have is one that I submitted  a patch for
a while back to allow this driver to work on 32 bit systems
with > 32 bit physical address space.   The firmware version
is 9.0.  In general, this works fine with SAS and most SATA
drives.

There are 2 dumps below.  The conditions are identical, it
just took me 2 runs to get it to fail.  Then after some
period of time, the kernel spews some information about a
hung thread (at the very end of the data).

>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ayman El-Khashab
> Sent: Tuesday, February 14, 2012 6:46 PM
> To: linux-scsi@vger.kernel.org
> Subject: need help solving mpt2sas target unplug can hang worker thread
>
> I'm doing this on powerpc/4xx (if that matters).  Basically
> I can normally hot-plug or hot-remove disks from the mpt2sas
> just fine.  It is easy to replicate on my system if I unplug
> the drive during the enumeration process.  Based on what I
> see, I gather it is in the scsi layer rather than the
> mpt2sas driver, but I don't have that much experience in the
> scsi driver to be certain.
>
> There are 2 cases that cause this ...
>
> 1) Device never finishes the initial enumerate sequence
> because there is something wrong with the drive, firmware on
> the drive, etc.
>
> 2) The drive was unplugged before the enumeration completes.
>
> *MAYBE* this is addressed by the null pointer dereference
> patches I've seen posted.  In any case, I get the thread
> dumping every 120s, I cannot remove the driver module from
> the kernel.  My only option is to reboot.  It would be great
> if it didn't happen at all, but even if I can reset the
> controller and get things back to a happier time, that would
> be perfect.  Any tips for how I might accomplish that or is
> there a particular patch I should take a look at / apply?



# cat /var/log/messages
Feb 22 00:01:53 SX2A syslog.info syslogd started: BusyBox v1.18.4
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas version 06.100.00.00 loaded
Feb 22 00:02:11 SX2A user.info kernel: registered callbacks io=5,4 qc=3,2
Feb 22 00:02:11 SX2A user.info kernel: scsi0 : Fusion MPT SAS Host
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas 0000:01:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:11 SX2A user.debug kernel: mpt2sas 0000:01:00.0: enabling bus mastering
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: IO-APIC enabled: IRQ 18
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: iomem(0x0000000e00040000), mapped(0xf4fe0000), size(16384)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: ioport(0x00000000fffe1000), size(256)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Allocated physical memory: size(739 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: sending port enable !!
Feb 22 00:02:14 SX2A user.info kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas0: port enable: SUCCESS
Feb 22 00:02:19 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3a260 io=5,4 qc=5,2
Feb 22 00:02:19 SX2A user.info kernel: scsi1 : Fusion MPT SAS Host
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas 0001:41:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:19 SX2A user.debug kernel: mpt2sas 0001:41:00.0: enabling bus mastering
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: IO-APIC enabled: IRQ 19
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: iomem(0x0000000e80040000), mapped(0xf4fe8000), size(16384)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: ioport(0x0000000000001000), size(256)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Allocated physical memory: size(739 kB)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: sending port enable !!
Feb 22 00:02:23 SX2A user.info kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:28 SX2A user.info kernel: mpt2sas1: port enable: SUCCESS
Feb 22 00:02:28 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3d260 io=5,4 qc=5,2
Feb 22 00:02:54 SX2A user.info kernel: setting logging_level(0x000421f8)
Feb 22 00:03:34 SX2A user.debug kernel: mapping 1073741824 bytes
Feb 22 00:03:34 SX2A user.info kernel: Mapped 1073741824 bytes at address 0x48002000 to tanomem file descriptor...
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  port-0:0: add: handle(0x0009), sas_addr(0x4433221106000000), phy(6)
Feb 22 00:03:40 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:42 SX2A user.notice kernel: scsi 0:0:0:0: Direct-Access     ATA      Micron EEFDDAC25 0006 PQ: 0 ANSI: 5
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221106000000), phy(6), device
_name(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 22 00:03:42 SX2A user.info kernel:  end_device-0:0: add: handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write Protect is off
Feb 22 00:03:42 SX2A user.debug kernel: sd 0:0:0:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  sda: unknown partition table
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:43 SX2A user.notice kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  port-0:1: add: handle(0x000a), sas_addr(0x4433221100000000), phy(0)
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:1:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221100000000), phy(0), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: Attached scsi generic sg1 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:1: add: handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  port-0:2: add: handle(0x000b), sas_addr(0x4433221102000000), phy(2)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write Protect is off
Feb 22 00:03:48 SX2A user.debug kernel: sd 0:0:1:0: [sdb] Mode Sense: 7f 00 00 08
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:2:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.info kernel:  sdb: unknown partition table
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: [sdc] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: Attached scsi generic sg2 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:2: add: handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Attached SCSI disk
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write Protect is off
Feb 22 00:03:49 SX2A user.debug kernel: sd 0:0:2:0: [sdc] Mode Sense: 7f 00 00 08
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:49 SX2A user.info kernel:  sdc: unknown partition table
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Attached SCSI disk
Feb 22 00:03:52 SX2A daemon.err ata_id[2747]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:0'
Feb 22 00:03:58 SX2A daemon.err ata_id[2770]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Feb 22 00:03:58 SX2A daemon.err ata_id[2792]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:32'
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:2: remove: sas_addr(0x4433221102000000), phy(2)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:0: remove: sas_addr(0x4433221106000000), phy(6)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:1: remove: sas_addr(0x4433221100000000), phy(0)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
# echo 0x180000F1 > /proc/sys/dev/scsi/logging_level
# cat /var/log/messages
Feb 22 00:01:53 SX2A syslog.info syslogd started: BusyBox v1.18.4
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas version 06.100.00.00 loaded
Feb 22 00:02:11 SX2A user.info kernel: registered callbacks io=5,4 qc=3,2
Feb 22 00:02:11 SX2A user.info kernel: scsi0 : Fusion MPT SAS Host
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas 0000:01:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:11 SX2A user.debug kernel: mpt2sas 0000:01:00.0: enabling bus mastering
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: IO-APIC enabled: IRQ 18
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: iomem(0x0000000e00040000), mapped(0xf4fe0000), size(16384)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: ioport(0x00000000fffe1000), size(256)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Allocated physical memory: size(739 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: sending port enable !!
Feb 22 00:02:14 SX2A user.info kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas0: port enable: SUCCESS
Feb 22 00:02:19 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3a260 io=5,4 qc=5,2
Feb 22 00:02:19 SX2A user.info kernel: scsi1 : Fusion MPT SAS Host
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas 0001:41:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:19 SX2A user.debug kernel: mpt2sas 0001:41:00.0: enabling bus mastering
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: IO-APIC enabled: IRQ 19
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: iomem(0x0000000e80040000), mapped(0xf4fe8000), size(16384)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: ioport(0x0000000000001000), size(256)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Allocated physical memory: size(739 kB)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: sending port enable !!
Feb 22 00:02:23 SX2A user.info kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:28 SX2A user.info kernel: mpt2sas1: port enable: SUCCESS
Feb 22 00:02:28 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3d260 io=5,4 qc=5,2
Feb 22 00:02:54 SX2A user.info kernel: setting logging_level(0x000421f8)
Feb 22 00:03:34 SX2A user.debug kernel: mapping 1073741824 bytes
Feb 22 00:03:34 SX2A user.info kernel: Mapped 1073741824 bytes at address 0x48002000 to tanomem file descriptor...
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  port-0:0: add: handle(0x0009), sas_addr(0x4433221106000000), phy(6)
Feb 22 00:03:40 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:42 SX2A user.notice kernel: scsi 0:0:0:0: Direct-Access     ATA      Micron EEFDDAC25 0006 PQ: 0 ANSI: 5
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221106000000), phy(6), device
_name(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 22 00:03:42 SX2A user.info kernel:  end_device-0:0: add: handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write Protect is off
Feb 22 00:03:42 SX2A user.debug kernel: sd 0:0:0:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  sda: unknown partition table
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:43 SX2A user.notice kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  port-0:1: add: handle(0x000a), sas_addr(0x4433221100000000), phy(0)
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:1:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221100000000), phy(0), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: Attached scsi generic sg1 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:1: add: handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  port-0:2: add: handle(0x000b), sas_addr(0x4433221102000000), phy(2)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write Protect is off
Feb 22 00:03:48 SX2A user.debug kernel: sd 0:0:1:0: [sdb] Mode Sense: 7f 00 00 08
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:2:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.info kernel:  sdb: unknown partition table
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: [sdc] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: Attached scsi generic sg2 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:2: add: handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Attached SCSI disk
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write Protect is off
Feb 22 00:03:49 SX2A user.debug kernel: sd 0:0:2:0: [sdc] Mode Sense: 7f 00 00 08
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:49 SX2A user.info kernel:  sdc: unknown partition table
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Attached SCSI disk
Feb 22 00:03:52 SX2A daemon.err ata_id[2747]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:0'
Feb 22 00:03:58 SX2A daemon.err ata_id[2770]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Feb 22 00:03:58 SX2A daemon.err ata_id[2792]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:32'
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:2: remove: sas_addr(0x4433221102000000), phy(2)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:0: remove: sas_addr(0x4433221106000000), phy(6)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:1: remove: sas_addr(0x4433221100000000), phy(0)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)


2nd run (crashing run)

Feb 22 00:06:19 SX2A user.info kernel: mpt2sas version 06.100.00.00 unloading
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas1: sending message unit reset !!
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas1: message unit reset: SUCCESS
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas0: sending message unit reset !!
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas0: message unit reset: SUCCESS
Feb 22 00:06:29 SX2A user.debug kernel: mapping 1073741824 bytes
Feb 22 00:06:29 SX2A user.info kernel: Mapped 1073741824 bytes at address 0x48002000 to tanomem file descriptor...
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas version 06.100.00.00 loaded
Feb 22 00:06:29 SX2A user.info kernel: registered callbacks io=5,4 qc=3,2
Feb 22 00:06:29 SX2A user.info kernel: scsi2 : Fusion MPT SAS Host
Feb 22 00:06:29 SX2A user.debug kernel: mpt2sas 0000:01:00.0: enabling bus mastering
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: IO-APIC enabled: IRQ 18
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: iomem(0x0000000e00040000), mapped(0xf7060000), size(16384)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: ioport(0x00000000fffe1000), size(256)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Allocated physical memory: size(739 kB)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: sending port enable !!
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: port enable: SUCCESS
Feb 22 00:06:30 SX2A user.warn kernel: assigning ioc callbacks ioc=eba78260 io=5,4 qc=5,2
Feb 22 00:06:30 SX2A user.info kernel: scsi3 : Fusion MPT SAS Host
Feb 22 00:06:30 SX2A user.debug kernel: mpt2sas 0001:41:00.0: enabling bus mastering
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: IO-APIC enabled: IRQ 19
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: iomem(0x0000000e80040000), mapped(0xf7068000), size(16384)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: ioport(0x0000000000001000), size(256)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: host_add: handle(0x0002), sas_addr(0x5000000080000001), phys(8)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Allocated physical memory: size(739 kB)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: sending port enable !!
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: port enable: SUCCESS
Feb 22 00:06:31 SX2A user.warn kernel: assigning ioc callbacks ioc=eba7a260 io=5,4 qc=5,2
Feb 22 00:06:31 SX2A user.info kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:06:37 SX2A user.notice kernel: scsi 2:0:0:0: Direct-Access     ATA      Micron EEFDDAC25 5148 PQ: 0 ANSI: 5
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: SATA: handle(0x000b), sas_addr(0x4433221104000000), phy(4), device
_name(0x0000000000000000)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: Attached scsi generic sg0 type 0
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] Write Protect is off
Feb 22 00:06:37 SX2A user.debug kernel: sd 2:0:0:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:38 SX2A user.notice kernel: scsi 2:0:1:0: Direct-Access     ATA      Micron EEFDDAC25 0006 PQ: 0 ANSI: 5
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: SATA: handle(0x000c), sas_addr(0x4433221106000000), phy(6), device
_name(0x0000000000000000)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: Attached scsi generic sg1 type 0
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Write Protect is off
Feb 22 00:06:38 SX2A user.debug kernel: sd 2:0:1:0: [sdb] Mode Sense: 7f 00 00 08
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:38 SX2A user.info kernel:  sdb: unknown partition table
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Attached SCSI disk
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] Unhandled error code
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 00 00 00 00 00 08 00
Feb 22 00:06:39 SX2A user.err kernel: end_request: I/O error, dev sda, sector 0
Feb 22 00:06:39 SX2A user.err kernel: Buffer I/O error on device sda, logical block 0
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] Unhandled error code
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 00 00 00 00 00 08 00
Feb 22 00:06:39 SX2A user.err kernel: end_request: I/O error, dev sda, sector 0
Feb 22 00:06:39 SX2A user.err kernel: Buffer I/O error on device sda, logical block 0
Feb 22 00:06:39 SX2A user.info kernel:  sda: unable to read partition table
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] READ CAPACITY failed
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] Sense not available.
Feb 22 00:06:39 SX2A user.err kernel: sd 2:0:0:0: [sda] Asking for cache data failed
Feb 22 00:06:39 SX2A user.err kernel: sd 2:0:0:0: [sda] Assuming drive cache: write through
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] Attached SCSI disk
Feb 22 00:06:39 SX2A user.info kernel: mpt2sas0: removing handle(0x000b), sas_addr(0x4433221104000000)
Feb 22 00:06:39 SX2A daemon.err usb_id[3066]: usb_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0/h
ost2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:39 SX2A daemon.err scsi_id[3072]: scsi_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0
/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:40 SX2A daemon.err scsi_id[3073]: scsi_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0
/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:44 SX2A user.notice kernel: scsi 2:0:2:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: SATA: handle(0x000e), sas_addr(0x4433221102000000), phy(2), device
_name(0x0000000000000000)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: Attached scsi generic sg0 type 0
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] Write Protect is off
Feb 22 00:06:44 SX2A user.debug kernel: sd 2:0:2:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:44 SX2A user.notice kernel: scsi 2:0:3:0: Direct-Access     ATA      Micron EEFDDAC25 5148 PQ: 0 ANSI: 5
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device
_name(0x0000000000000000)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: Attached scsi generic sg2 type 0
Feb 22 00:06:44 SX2A user.info kernel:  sda: unknown partition table
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] Write Protect is off
Feb 22 00:06:44 SX2A user.debug kernel: sd 2:0:3:0: [sdc] Mode Sense: 7f 00 00 08
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:45 SX2A user.notice kernel: sd 2:0:2:0: [sda] Attached SCSI disk
Feb 22 00:06:50 SX2A daemon.err ata_id[3141]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Feb 22 00:06:54 SX2A daemon.err ata_id[3163]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:0'
# cat /var/log/messages
Feb 22 00:01:53 SX2A syslog.info syslogd started: BusyBox v1.18.4
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas version 06.100.00.00 loaded
Feb 22 00:02:11 SX2A user.info kernel: registered callbacks io=5,4 qc=3,2
Feb 22 00:02:11 SX2A user.info kernel: scsi0 : Fusion MPT SAS Host
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas 0000:01:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:11 SX2A user.debug kernel: mpt2sas 0000:01:00.0: enabling bus mastering
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: IO-APIC enabled: IRQ 18
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: iomem(0x0000000e00040000), mapped(0xf4fe0000), size(16384)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: ioport(0x00000000fffe1000), size(256)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Allocated physical memory: size(739 kB)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:11 SX2A user.info kernel: mpt2sas0: sending port enable !!
Feb 22 00:02:14 SX2A user.info kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas0: port enable: SUCCESS
Feb 22 00:02:19 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3a260 io=5,4 qc=5,2
Feb 22 00:02:19 SX2A user.info kernel: scsi1 : Fusion MPT SAS Host
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas 0001:41:00.0: enabling device (0000 -> 0002)
Feb 22 00:02:19 SX2A user.debug kernel: mpt2sas 0001:41:00.0: enabling bus mastering
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: IO-APIC enabled: IRQ 19
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: iomem(0x0000000e80040000), mapped(0xf4fe8000), size(16384)
Feb 22 00:02:19 SX2A user.info kernel: mpt2sas1: ioport(0x0000000000001000), size(256)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Allocated physical memory: size(739 kB)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:02:20 SX2A user.info kernel: mpt2sas1: sending port enable !!
Feb 22 00:02:23 SX2A user.info kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:02:28 SX2A user.info kernel: mpt2sas1: port enable: SUCCESS
Feb 22 00:02:28 SX2A user.warn kernel: assigning ioc callbacks ioc=ebb3d260 io=5,4 qc=5,2
Feb 22 00:02:54 SX2A user.info kernel: setting logging_level(0x000421f8)
Feb 22 00:03:34 SX2A user.debug kernel: mapping 1073741824 bytes
Feb 22 00:03:34 SX2A user.info kernel: Mapped 1073741824 bytes at address 0x48002000 to tanomem file descriptor...
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-1:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:38 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:38 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:38 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:40 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:40 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:40 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:40 SX2A user.info kernel:  port-0:0: add: handle(0x0009), sas_addr(0x4433221106000000), phy(6)
Feb 22 00:03:40 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:42 SX2A user.notice kernel: scsi 0:0:0:0: Direct-Access     ATA      Micron EEFDDAC25 0006 PQ: 0 ANSI: 5
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221106000000), phy(6), device
_name(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:42 SX2A user.info kernel: scsi 0:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 22 00:03:42 SX2A user.info kernel:  end_device-0:0: add: handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write Protect is off
Feb 22 00:03:42 SX2A user.debug kernel: sd 0:0:0:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:03:42 SX2A user.notice kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:42 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:42 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:42 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  sda: unknown partition table
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.warn kernel: ttyS0: 1 input overrun(s)
Feb 22 00:03:43 SX2A user.notice kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:43 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:43 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:43 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:43 SX2A user.info kernel:  port-0:1: add: handle(0x000a), sas_addr(0x4433221100000000), phy(0)
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:1:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221100000000), phy(0), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:1:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: Attached scsi generic sg1 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:1: add: handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(0)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(6)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:03:48 SX2A user.info kernel:  link_rate(0x0a), phy(2)
Feb 22 00:03:48 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:48 SX2A user.info kernel:  port-0:2: add: handle(0x000b), sas_addr(0x4433221102000000), phy(2)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write Protect is off
Feb 22 00:03:48 SX2A user.debug kernel: sd 0:0:1:0: [sdb] Mode Sense: 7f 00 00 08
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:48 SX2A user.notice kernel: scsi 0:0:2:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device
_name(0x0000000000000000)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:03:48 SX2A user.info kernel: scsi 0:0:2:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:03:48 SX2A user.info kernel:  sdb: unknown partition table
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: [sdc] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:03:48 SX2A user.notice kernel: sd 0:0:2:0: Attached scsi generic sg2 type 0
Feb 22 00:03:48 SX2A user.info kernel:  end_device-0:2: add: handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:1:0: [sdb] Attached SCSI disk
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write Protect is off
Feb 22 00:03:49 SX2A user.debug kernel: sd 0:0:2:0: [sdc] Mode Sense: 7f 00 00 08
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:03:49 SX2A user.info kernel:  sdc: unknown partition table
Feb 22 00:03:49 SX2A user.notice kernel: sd 0:0:2:0: [sdc] Attached SCSI disk
Feb 22 00:03:52 SX2A daemon.err ata_id[2747]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:0'
Feb 22 00:03:58 SX2A daemon.err ata_id[2770]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Feb 22 00:03:58 SX2A daemon.err ata_id[2792]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:32'
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:11 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:11 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:11 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000a), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x000b), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0009), sas_addr(0x0000000000000000)
Feb 22 00:04:12 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:12 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:12 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:2: remove: sas_addr(0x4433221102000000), phy(2)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000b), sas_addr(0x4433221102000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:0: remove: sas_addr(0x4433221106000000), phy(6)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x0009), sas_addr(0x4433221106000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  port-0:1: remove: sas_addr(0x4433221100000000), phy(0)
Feb 22 00:04:13 SX2A user.info kernel: mpt2sas0: removing handle(0x000a), sas_addr(0x4433221100000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:0: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(0)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:1: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(1)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:2: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(2)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:3: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(3)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:4: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(4)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:5: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(5)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:6: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(6)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:04:13 SX2A user.info kernel:  phy-0:7: refresh: parent sas_addr(0x5000000080000000),
Feb 22 00:04:13 SX2A user.info kernel:  link_rate(0x00), phy(7)
Feb 22 00:04:13 SX2A user.info kernel:  attached_handle(0x0000), sas_addr(0x0000000000000000)
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas version 06.100.00.00 unloading
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas1: sending message unit reset !!
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas1: message unit reset: SUCCESS
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas0: sending message unit reset !!
Feb 22 00:06:19 SX2A user.info kernel: mpt2sas0: message unit reset: SUCCESS
Feb 22 00:06:29 SX2A user.debug kernel: mapping 1073741824 bytes
Feb 22 00:06:29 SX2A user.info kernel: Mapped 1073741824 bytes at address 0x48002000 to tanomem file descriptor...
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas version 06.100.00.00 loaded
Feb 22 00:06:29 SX2A user.info kernel: registered callbacks io=5,4 qc=3,2
Feb 22 00:06:29 SX2A user.info kernel: scsi2 : Fusion MPT SAS Host
Feb 22 00:06:29 SX2A user.debug kernel: mpt2sas 0000:01:00.0: enabling bus mastering
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: IO-APIC enabled: IRQ 18
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: iomem(0x0000000e00040000), mapped(0xf7060000), size(16384)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: ioport(0x00000000fffe1000), size(256)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Allocated physical memory: size(739 kB)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:06:29 SX2A user.info kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: sending port enable !!
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: port enable: SUCCESS
Feb 22 00:06:30 SX2A user.warn kernel: assigning ioc callbacks ioc=eba78260 io=5,4 qc=5,2
Feb 22 00:06:30 SX2A user.info kernel: scsi3 : Fusion MPT SAS Host
Feb 22 00:06:30 SX2A user.debug kernel: mpt2sas 0001:41:00.0: enabling bus mastering
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (1035112 kB)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: IO-APIC enabled: IRQ 19
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: iomem(0x0000000e80040000), mapped(0xf7068000), size(16384)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: ioport(0x0000000000001000), size(256)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas0: host_add: handle(0x0002), sas_addr(0x5000000080000001), phys(8)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Allocated physical memory: size(739 kB)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Current Controller Queue Depth(467), Max Controller Queue Depth(3712)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(00
.00.00.00)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Di
ag Trace Buffer,Task Set Full,NCQ)
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: sending port enable !!
Feb 22 00:06:30 SX2A user.info kernel: mpt2sas1: port enable: SUCCESS
Feb 22 00:06:31 SX2A user.warn kernel: assigning ioc callbacks ioc=eba7a260 io=5,4 qc=5,2
Feb 22 00:06:31 SX2A user.info kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
Feb 22 00:06:37 SX2A user.notice kernel: scsi 2:0:0:0: Direct-Access     ATA      Micron EEFDDAC25 5148 PQ: 0 ANSI: 5
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: SATA: handle(0x000b), sas_addr(0x4433221104000000), phy(4), device
_name(0x0000000000000000)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:37 SX2A user.info kernel: scsi 2:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: Attached scsi generic sg0 type 0
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] Write Protect is off
Feb 22 00:06:37 SX2A user.debug kernel: sd 2:0:0:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:06:37 SX2A user.notice kernel: sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:38 SX2A user.notice kernel: scsi 2:0:1:0: Direct-Access     ATA      Micron EEFDDAC25 0006 PQ: 0 ANSI: 5
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: SATA: handle(0x000c), sas_addr(0x4433221106000000), phy(6), device
_name(0x0000000000000000)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:38 SX2A user.info kernel: scsi 2:0:1:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: Attached scsi generic sg1 type 0
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Write Protect is off
Feb 22 00:06:38 SX2A user.debug kernel: sd 2:0:1:0: [sdb] Mode Sense: 7f 00 00 08
Feb 22 00:06:38 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:38 SX2A user.info kernel:  sdb: unknown partition table
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:1:0: [sdb] Attached SCSI disk
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] Unhandled error code
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 00 00 00 00 00 08 00
Feb 22 00:06:39 SX2A user.err kernel: end_request: I/O error, dev sda, sector 0
Feb 22 00:06:39 SX2A user.err kernel: Buffer I/O error on device sda, logical block 0
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] Unhandled error code
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 00 00 00 00 00 08 00
Feb 22 00:06:39 SX2A user.err kernel: end_request: I/O error, dev sda, sector 0
Feb 22 00:06:39 SX2A user.err kernel: Buffer I/O error on device sda, logical block 0
Feb 22 00:06:39 SX2A user.info kernel:  sda: unable to read partition table
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] READ CAPACITY failed
Feb 22 00:06:39 SX2A user.info kernel: sd 2:0:0:0: [sda]  Result: hostbyte=0x01 driverbyte=0x00
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] Sense not available.
Feb 22 00:06:39 SX2A user.err kernel: sd 2:0:0:0: [sda] Asking for cache data failed
Feb 22 00:06:39 SX2A user.err kernel: sd 2:0:0:0: [sda] Assuming drive cache: write through
Feb 22 00:06:39 SX2A user.notice kernel: sd 2:0:0:0: [sda] Attached SCSI disk
Feb 22 00:06:39 SX2A user.info kernel: mpt2sas0: removing handle(0x000b), sas_addr(0x4433221104000000)
Feb 22 00:06:39 SX2A daemon.err usb_id[3066]: usb_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0/h
ost2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:39 SX2A daemon.err scsi_id[3072]: scsi_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0
/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:40 SX2A daemon.err scsi_id[3073]: scsi_id: unable to access '/devices/pci0000:00/0000:00:00.0/0000:01:00.0
/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
Feb 22 00:06:44 SX2A user.notice kernel: scsi 2:0:2:0: Direct-Access     ATA      C400-MTFDDAC512M 0002 PQ: 0 ANSI: 5
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: SATA: handle(0x000e), sas_addr(0x4433221102000000), phy(2), device
_name(0x0000000000000000)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:2:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: Attached scsi generic sg0 type 0
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] Write Protect is off
Feb 22 00:06:44 SX2A user.debug kernel: sd 2:0:2:0: [sda] Mode Sense: 7f 00 00 08
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:44 SX2A user.notice kernel: scsi 2:0:3:0: Direct-Access     ATA      Micron EEFDDAC25 5148 PQ: 0 ANSI: 5
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device
_name(0x0000000000000000)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb 22 00:06:44 SX2A user.info kernel: scsi 2:0:3:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_q
ue(1)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] 250069680 512-byte logical blocks: (128 GB/119 GiB)
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: Attached scsi generic sg2 type 0
Feb 22 00:06:44 SX2A user.info kernel:  sda: unknown partition table
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] Write Protect is off
Feb 22 00:06:44 SX2A user.debug kernel: sd 2:0:3:0: [sdc] Mode Sense: 7f 00 00 08
Feb 22 00:06:44 SX2A user.notice kernel: sd 2:0:3:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support D
PO or FUA
Feb 22 00:06:45 SX2A user.notice kernel: sd 2:0:2:0: [sda] Attached SCSI disk
Feb 22 00:06:50 SX2A daemon.err ata_id[3141]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Feb 22 00:06:54 SX2A daemon.err ata_id[3163]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:0'


// After some time, this dumps to the console

INFO: task kworker/u:1:7 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u:1   D 00000000     0     7      2 0x00000000
Call Trace:
[ef845b10] [c0438594] 0xc0438594 (unreliable)
[ef845bd0] [c0006e28] __switch_to+0x98/0xb0
[ef845be0] [c032b858] schedule+0x180/0x334
[ef845c10] [c0054850] async_synchronize_cookie_domain+0x100/0x1a4
[ef845c60] [c0054ad4] async_synchronize_full+0x2c/0x58
[ef845c80] [c01c8904] sd_remove+0x20/0xa4
[ef845ca0] [c01b065c] __device_release_driver+0x68/0xc8
[ef845cb0] [c01b0ccc] device_release_driver+0x28/0x44
[ef845cd0] [c01af848] bus_remove_device+0xa4/0xd8
[ef845ce0] [c01ad5f0] device_del+0x110/0x18c
[ef845d00] [c01c232c] __scsi_remove_device+0xc0/0xc4
[ef845d10] [c01c235c] scsi_remove_device+0x2c/0x48
[ef845d30] [c01c2460] __scsi_remove_target+0xe8/0xfc
[ef845d50] [c01c2510] __remove_child+0x28/0x40
[ef845d60] [c01acc6c] device_for_each_child+0x44/0x80
[ef845d90] [c01c24cc] scsi_remove_target+0x58/0x74
[ef845db0] [c01c5ddc] sas_rphy_remove+0x94/0xc0
[ef845dc0] [c01c5e20] sas_rphy_delete+0x18/0x30
[ef845de0] [c01c5e5c] sas_port_delete+0x24/0x10c
[ef845e00] [f702c39c] mpt2sas_transport_port_remove+0x21c/0x248 [tan_mpt2sas]
[ef845e30] [f7024864] _scsih_remove_device+0x78/0xa8 [tan_mpt2sas]
[ef845ea0] [f7028f74] _firmware_event_work+0x10e0/0x1358 [tan_mpt2sas]
--- Exception: c055897c at 0x3000040
    LR =   (null)
[ef845f60] [c004787c] process_one_work+0x104/0x320 (unreliable)
[ef845f90] [c0048f78] worker_thread+0x1d4/0x2c4
[ef845fb0] [c004d240] kthread+0x7c/0x80
[ef845ff0] [c000c5b8] kernel_thread+0x4c/0x68
INFO: task kworker/u:2:2603 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u:2   D 00000000     0  2603      2 0x00000000
Call Trace:
[eb919b70] [00000001] 0x1 (unreliable)
[eb919c30] [c0006e28] __switch_to+0x98/0xb0
[eb919c40] [c032b858] schedule+0x180/0x334
[eb919c70] [c032bb38] io_schedule+0x40/0x74
[eb919c90] [c006b5c8] sync_page+0x54/0x74
[eb919ca0] [c032bfac] __wait_on_bit_lock+0x94/0x124
[eb919cc0] [c006b540] __lock_page+0x50/0x60
[eb919cf0] [c006bd50] do_read_cache_page+0x18c/0x190
[eb919d20] [c006bdac] read_cache_page+0x14/0x28
[eb919d30] [c00eaec8] read_dev_sector+0x40/0xa0
[eb919d50] [c00ebe0c] msdos_partition+0xb4/0x950
[eb919e20] [c00eba34] rescan_partitions+0x1bc/0x4c8
[eb919e80] [c00cbdf8] __blkdev_get+0x1a0/0x368
[eb919ec0] [c00eb808] register_disk+0x17c/0x194
[eb919ef0] [c0157950] add_disk+0xf4/0x144
[eb919f20] [c01ca734] sd_probe_async+0xf4/0x1bc
[eb919f40] [c0054b80] async_run_entry_fn+0x80/0x1c4
[eb919f60] [c004787c] process_one_work+0x104/0x320
[eb919f90] [c0048f78] worker_thread+0x1d4/0x2c4
[eb919fb0] [c004d240] kthread+0x7c/0x80
[eb919ff0] [c000c5b8] kernel_thread+0x4c/0x68

