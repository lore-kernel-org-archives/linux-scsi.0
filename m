From: Steve Sutphen <steve@cs.ualberta.ca>
Subject: Re: Megaraid and Dell PERC 4 controllers
Date: Tue, 30 Aug 2005 01:43:30 -0600
Message-ID: <20050830074330.GR1830@cs.ualberta.ca>
References: <0E3FA95632D6D047BA649F95DAB60E5703662AFB@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sfyO1m2EN8ZOtJL6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sunkay.cs.ualberta.ca ([129.128.4.11]:51707 "EHLO
	sunkay.cs.ualberta.ca") by vger.kernel.org with ESMTP
	id S1751196AbVH3Hnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 03:43:39 -0400
Received: (from localhost user: 'steve' uid#10 fake: STDIN (steve@snaring))
	by sunkay.cs.ualberta.ca id S566687AbVH3Hna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 01:43:30 -0600
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662AFB@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: linux-scsi@vger.kernel.org, 'Jonathan Fischer' <jfischer@csusm.edu>, "Kolli, Neela Syam" <knsyam@lsil.com>


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Seokmann,
This sounds identical to a crash that I had on Saturday.
I have a server that has a dual Opteron/244 with 2GB of memory (4x512MB
400MHz, Registered ECC, Corsair CM72SD512RLP-3) on a Tyan Opteron 8131
motherboard.  The controller is the LSI MegaRAID SATA II 300-8X PCI-X
(P/N LSI00005 with the LSI00012 battery backup).  The system is fairly new,
it was manufactured on 06/22/05 and put in service about a mounth later.
The MegaRAID controller has 8 Seagate ST3250823AS 250GB SATA drives with 
NCQ.  
The RAID array is a RAID5 array with a global spare.  It is divided 
into two nearly equal sized logical disks.  The controller parameters 
are set to:
FlexRAID PowerFail = ENABLED
Command Que = Enabled

both logical drives are set to:
RAID = 5
Size = 712392MB 
StripeSize = 64KB 
{Write Policy = WRTHRU
Read Policy = NORMAL
Cache Policy = DirectIO
#Stripes = 7
State = OPTIMAL

The system is running Red Hat Enterprise Linux AS release 4 (Nahant Update 1)
With an updated kernel (I am booting off of a SATA disk on the 
Silicon Image, Inc. SiI 3114 controller which was only fixed in recent
kernels and firmware):
Kernel 2.6.11.12 on a 2-processor i686

The system is being used primarily as an NFS server. It also serves as
the head node for a small cluster.  It does the Ganglia data collection
task for the cluster.  Looking at the Ganglia data does not indicate
that there was much of a load on the system just before the crash.  
Although Ganglia is not recording disk I/O's I do not see much indirect 
evidence that there was heavy disk I/O: the CPUs are steady state--
around 97% idle, and no particular peaks or valleys.  Same with the 
number of packets and network bytes transmitted/received, and memory 
usage.  It all seems normal, with no particular peaks just before
I rebooted it (as with the original case--the system kept running,
although it was logging lots of disk I/O failed messages becuse the 
controller had been off-lined.

I am attaching a file that has the log records from the last 
reboot (we had moved it to a UPS just under 4 days before the 
controller locked up) showing the megaraid initialization,
and the sequence of error (condensed) messages from the controller 
up to the point where it off-lined the array(s).

Other than this incident the system has been running fine since it was
installed.  I hope that this helps.  If you have any suggestions 
please tell me as I am worried that this may happen again.

Thank you,
	steve.

On Mon, Aug 29, 2005 at 04:25:52PM -0400, Ju, Seokmann wrote:
> FYI - Resending due to failure on previous sending.  
> 
> > -----Original Message-----
> > From: Ju, Seokmann 
> > Sent: Friday, August 26, 2005 11:00 AM
> > To: 'Jonathan Fischer'
> > Cc: Kolli, Neela Syam
> > Subject: RE: Megaraid and Dell PERC 4 controllers
> > 
> > Hi Jonathan,
> > 
> > On Tuesday, August 23, 2005 4:52 PM, Jonathan Fischer wrote:
> > > I think next up I'm trying writethru mode, instead of write 
> > back, but
> > > has anyone seen anything like this, or have any insight they might
> > > offer?  I'm quickly getting to the point of being stumped.
> > Can you please specify detail system configuration? (memory 
> > size, # of cpus)
> > And, what kind of load are you putting on the system when it locks up.
> > Also, I assuem that the system doesn't have any monitoring 
> > applications running for those PERC controllers. Please confirm this.
> > From the message, the controller takes more than 3 minutes to 
> > return certain I/O requests and it leads system to lock up.
> > 
> > Thank you.
> > 
> > Seokmann
> > 
> > > -----Original Message-----
> > > From: Jonathan Fischer [mailto:jfischer@csusm.edu] 
> > > Sent: Tuesday, August 23, 2005 4:52 PM
> > > To: linux-scsi@vger.kernel.org
> > > Subject: Megaraid and Dell PERC 4 controllers
> > > 
> > > I apologize if this is the wrong list to ask this kind of 
> > question on;
> > > I've posted on Dell's PowerEdge list and Red Hat's lists as 
> > > well, but I
> > > figure the people here might know better what to try for 
> > this problem.
> > > 
> > > I have 2 Dell PowerEdge 2850's, one with a PERC 4e/DC raid 
> > controller,
> > > and the other with a PERC 4e/Di.  On both of these systems, I can
> > > reliably cause the controllers to lock up under heavy load.  This is
> > > using a fully up-to-date Red Hat 4 EL (non x86_64) 
> > > installation on both
> > > computers.  The controllers use the megaraid_mbox driver.
> > > 
> > > During a period of high load, the controller suddenly seems to stop
> > > responding to the driver, causing the driver to go into a 
> > waiting loop
> > > for it.  It waits 3 minutes for the controller to respond, which it
> > > never does, and then takes the controller offline, pretty 
> > much yanking
> > > the filesystem out from underneath the OS.
> > > 
> > > Some things keep running alright, so (working with Red Hat's 
> > > support) I
> > > got the thing set up to netdump to another server to see if we could
> > > figure out what was going wrong.  The kernel never actually 
> > > crashes, so
> > > netdump doesn't produce a vmcore to look through, but syslog keeps
> > > spouting out information, so I've got that.
> > > 
> > > Every time this lockup occurs, the log file looks like this:
> > > 
> > > megaraid: aborting-29762 cmd=2a <c=2 t=0 l=0>
> > > megaraid abort: 29762:21[255:128], fw owner
> > > megaraid: aborting-29763 cmd=2a <c=2 t=0 l=0>
> > > megaraid abort: 29763:39[255:128], fw owner
> > > megaraid: aborting-29764 cmd=2a <c=2 t=0 l=0>
> > > megaraid abort: 29764:16[255:128], fw owner
> > > megaraid: aborting-29768 cmd=2a <c=2 t=0 l=0>
> > > megaraid abort: 29768:53[255:128], fw owner
> > > 
> > > 	This part repeats 64 times, then...
> > > 
> > > megaraid: aborting-29831 cmd=2a <c=2 t=0 l=0>
> > > megaraid abort: 29831:8[255:128], fw owner
> > > megaraid: resetting the host...
> > > megaraid: 64 outstanding commands. Max wait 180 sec
> > > megaraid mbox: Wait for 64 commands to complete:180
> > > megaraid mbox: Wait for 64 commands to complete:175
> > > 	
> > > 	megaraid mbox counts down to 0, and then...
> > > 
> > > megaraid mbox: critical hardware error!
> > > megaraid: resetting the host...
> > > megaraid: hw error, cannot reset
> > > megaraid: resetting the host...
> > > megaraid: hw error, cannot reset
> > > SCSI error : <0 2 0 0> return code = 0x6000000
> > > end_request: I/O error, dev sda, sector 242938701
> > > Buffer I/O error on device dm-4, logical block 9893952 lost 
> > page write
> > > due to I/O error on dm-4
> > > scsi0 (0:0): rejecting I/O to offline device
> > > 
> > > The commands that the driver are waiting for are always the 
> > > same, except
> > > for the sequence number (the number right after "aborting-" 
> > > and  "abort:
> > > ").  And there are always 64 commands backed up that the driver is
> > > waiting for.
> > > 
> > > Both machines in question pass memtest86 and Dell's 
> > > diagnostic sets, and
> > > since the failure is identical in both I don't believe it's bad
> > > hardware.  We've got the latest BIOS, RAID firmware, and backplane
> > > firmware on the machines.
> > > 
> > > I've also tried:
> > > - the RHEL 4 Update 2 Beta kernel (at Red Hat's suggestion)
> > > - RHEL 4 x86_64
> > > - RHEL 3 x86_64
> > > - Fedora Core 4 x86
> > > - disabling Patrol Read in the RAID bios
> > > - disabling read-ahead in the RAID bios
> > > - changing the writeback cache flush to every 2 seconds, 
> > > instead of the
> > > default 4
> > > 
> > > I think next up I'm trying writethru mode, instead of write 
> > back, but
> > > has anyone seen anything like this, or have any insight they might
> > > offer?  I'm quickly getting to the point of being stumped.
> > > 
> > > Jonathan Fischer
> > > Operating Systems Analyst - CSU San Marcos
> > > jfischer@csusm.edu
> > > 
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe 
> > > linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=brule_crash

Red Hat Enterprise Linux AS release 4 (Nahant Update 1)
Kernel 2.6.11.12 on a 2-processor i686

Aug 23 19:49:03 brule kernel: megaraid cmm: 2.20.2.5 (Release Date: Fri Jan 21 00:01:03 EST 2005)
Aug 23 19:49:03 brule kernel: megaraid: 2.20.4.5 (Release Date: Thu Feb 03 12:27:22 EST 2005)
Aug 23 19:49:03 brule kernel: megaraid: probe new device 0x1000:0x0409:0x1000:0x3008: bus 2:slot 14:func 0
Aug 23 19:49:03 brule kernel: ACPI: PCI interrupt 0000:02:0e.0[C] -> GSI 28 (level, low) -> IRQ 28
Aug 23 19:49:03 brule kernel: megaraid: fw version:[813i] bios version:[H430]
Aug 23 19:49:03 brule kernel: scsi0 : LSI Logic MegaRAID driver
Aug 23 19:49:03 brule kernel: scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
Aug 23 19:49:03 brule kernel: scsi[0]: scanning scsi channel 1 [virtual] for logical drives
Aug 23 19:49:03 brule kernel:   Vendor: MegaRAID  Model: LD 0 RAID5  712G  Rev: 813i
Aug 23 19:49:03 brule kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Aug 23 19:49:03 brule kernel:   Vendor: MegaRAID  Model: LD 1 RAID5  712G  Rev: 813i
Aug 23 19:49:03 brule kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Aug 23 19:49:03 brule kernel: ACPI: PCI interrupt 0000:04:05.0[A] -> GSI 19 (level, low) -> IRQ 19
Aug 23 19:49:03 brule kernel: ata1: SATA max UDMA/100 cmd 0xF8806C80 ctl 0xF8806C8A bmdma 0xF8806C00 irq 19
Aug 23 19:49:03 brule kernel: ata2: SATA max UDMA/100 cmd 0xF8806CC0 ctl 0xF8806CCA bmdma 0xF8806C08 irq 19
Aug 23 19:49:03 brule kernel: ata3: SATA max UDMA/100 cmd 0xF8806E80 ctl 0xF8806E8A bmdma 0xF8806E00 irq 19
Aug 23 19:49:03 brule kernel: ata4: SATA max UDMA/100 cmd 0xF8806EC0 ctl 0xF8806ECA bmdma 0xF8806E08 irq 19
Aug 23 19:49:03 brule kernel: ata1: dev 0 ATA, max UDMA/133, 234441648 sectors: lba48
Aug 23 19:49:03 brule kernel: ata1: dev 0 configured for UDMA/100
Aug 23 19:49:03 brule kernel: scsi1 : sata_sil
Aug 23 19:49:03 brule kernel: ata2: no device found (phy stat 00000000)
Aug 23 19:49:03 brule kernel: scsi2 : sata_sil
Aug 23 19:49:03 brule kernel: ata3: no device found (phy stat 00000000)
Aug 23 19:49:03 brule kernel: scsi3 : sata_sil
Aug 23 19:49:03 brule kernel: ata4: no device found (phy stat 00000000)
Aug 23 19:49:03 brule kernel: scsi4 : sata_sil
Aug 23 19:49:03 brule kernel:   Vendor: ATA       Model: ST3120026AS       Rev: 3.05
Aug 23 19:49:03 brule kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 23 19:49:03 brule kernel: SCSI device sda: 1458978816 512-byte hdwr sectors (746997 MB)
Aug 23 19:49:03 brule kernel: sda: asking for cache data failed
Aug 23 19:49:03 brule kernel: sda: assuming drive cache: write through
Aug 23 19:49:04 brule kernel: SCSI device sda: 1458978816 512-byte hdwr sectors (746997 MB)
Aug 23 19:49:04 brule kernel: sda: asking for cache data failed
Aug 23 19:49:04 brule kernel: sda: assuming drive cache: write through
Aug 23 19:49:04 brule kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 >
Aug 23 19:49:04 brule kernel: Attached scsi disk sda at scsi0, channel 1, id 0, lun 0
Aug 23 19:49:04 brule kernel: SCSI device sdb: 1458978816 512-byte hdwr sectors (746997 MB)
Aug 23 19:49:04 brule kernel: sdb: asking for cache data failed
Aug 23 19:49:04 brule kernel: sdb: assuming drive cache: write through
Aug 23 19:49:04 brule kernel: SCSI device sdb: 1458978816 512-byte hdwr sectors (746997 MB)
Aug 23 19:49:04 brule kernel: sdb: asking for cache data failed
Aug 23 19:49:04 brule kernel: sdb: assuming drive cache: write through
Aug 23 19:49:04 brule kernel:  sdb: sdb1 sdb2 sdb3 sdb4
Aug 23 19:49:04 brule kernel: Attached scsi disk sdb at scsi0, channel 1, id 1, lun 0
Aug 23 19:49:04 brule kernel: SCSI device sdc: 234441648 512-byte hdwr sectors (120034 MB)
Aug 23 19:49:04 brule kernel: SCSI device sdc: drive cache: write back
Aug 23 19:49:04 brule kernel: SCSI device sdc: 234441648 512-byte hdwr sectors (120034 MB)
Aug 23 19:49:04 brule kernel: SCSI device sdc: drive cache: write back
Aug 23 19:49:04 brule kernel:  sdc: sdc1 sdc2 sdc3 < sdc5 sdc6 sdc7 sdc8 > sdc4
Aug 23 19:49:04 brule kernel: Attached scsi disk sdc at scsi1, channel 0, id 0, lun 0
Aug 23 19:49:04 brule kernel: Attached scsi generic sg0 at scsi0, channel 1, id 0, lun 0,  type 0
Aug 23 19:49:04 brule kernel: Attached scsi generic sg1 at scsi0, channel 1, id 1, lun 0,  type 0
Aug 23 19:49:04 brule kernel: Attached scsi generic sg2 at scsi1, channel 0, id 0, lun 0,  type 0
... the disk ran fine for nearly 4 days

Aug 27 16:19:56 brule kernel: megaraid: aborting-35347365 cmd=2a <c=1 t=0 l=0>
Aug 27 16:19:56 brule kernel: megaraid abort: 35347365:95[255:128], fw owner
Aug 27 16:19:56 brule kernel: megaraid: aborting-35347366 cmd=2a <c=1 t=0 l=0>
Aug 27 16:19:56 brule kernel: megaraid abort: 35347366:121[255:128], fw owner
Aug 27 16:19:56 brule kernel: megaraid: aborting-35347367 cmd=2a <c=1 t=0 l=0>
...
Aug 27 16:19:57 brule kernel: megaraid: aborting-35347510 cmd=2a <c=1 t=0 l=0>
Aug 27 16:19:57 brule kernel: megaraid abort: 35347510:112[255:128], fw owner
Aug 27 16:19:57 brule kernel: megaraid: reseting the host...
Aug 27 16:19:57 brule kernel: megaraid: 64 outstanding commands. Max wait 180 sec
Aug 27 16:19:57 brule kernel: megaraid mbox: Wait for 64 commands to complete:180
Aug 27 16:20:01 brule kernel: megaraid mbox: Wait for 64 commands to complete:175
Aug 27 16:20:06 brule kernel: megaraid mbox: Wait for 1 commands to complete:170
Aug 27 16:20:11 brule kernel: megaraid mbox: Wait for 1 commands to complete:165
Aug 27 16:20:16 brule kernel: megaraid mbox: Wait for 1 commands to complete:160
...
Aug 27 16:22:51 brule kernel: megaraid mbox: Wait for 1 commands to complete:5
Aug 27 16:22:56 brule kernel: megaraid mbox: Wait for 1 commands to complete:0
Aug 27 16:23:01 brule kernel: megaraid mbox: Wait for 1 commands to complete:-5
...
Aug 27 16:24:46 brule kernel: megaraid mbox: Wait for 1 commands to complete:-110
Aug 27 16:24:51 brule kernel: megaraid mbox: Wait for 1 commands to complete:-115
Aug 27 16:24:56 brule kernel: megaraid mbox: critical hardware error!
Aug 27 16:24:56 brule kernel: megaraid: reseting the host...
Aug 27 16:24:56 brule kernel: megaraid: hw error, cannot reset
Aug 27 16:24:56 brule kernel: megaraid: reseting the host...
Aug 27 16:24:56 brule kernel: megaraid: hw error, cannot reset
Aug 27 16:24:56 brule kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 1 id 0 lun 0

--sfyO1m2EN8ZOtJL6--
