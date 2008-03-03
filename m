From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
Date: Mon, 3 Mar 2008 02:48:23 +0100 (CET)
Message-ID: <tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>
References: <200803022053.m22KrP2Y023591@harpo.it.uu.se>
 <20080302233415.GA6258@Pilar> <18379.18297.838050.536473@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <18379.18297.838050.536473@harpo.it.uu.se>
Content-Disposition: INLINE
Sender: linux-ide-owner@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, htejun@gmail.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[resend with linux-ide and linux-scsi CCed]

Mikael Pettersson wrote:
> Carlos R. Mafra writes:
>  > On Sun  2.Mar'08 at 21:53:25 +0100, Mikael Pettersson wrote:
>  > > On my main workstation (Intel P965 chipset, ICH8 SATA driven by ahci,
>  > > Samsung/Toshiba SH-203P SATA DVD writer, FC5 user-space), cdrecord
>  > > stopped working on the 2.6.25-rc3 kernel, with the complaint:
>  > > 
>  > > Warning: controller returns zero sized CD capabilities page.
>  > > Warning: controller returns wrong page 0 for CD capabilities page (2A).
[...]
>  > I will try to help by pointing you to the patch here: 
>  > http://lkml.org/lkml/2008/2/28/76
>  > 
>  > It seems your problem is similar to the one Mike Galbraith reported.
> 
> That patch does seem to fix the problem. Thanks.

This also fixes the same regression for FireWire.

However, CD burning still fails for me via ide-cd, although in a
different way than without the patch.  (Without the patch, ide-cd also
fails like described by you for SATA.)

With the patch, the failure is as follows.  I don't know if this is
related to the data length arithmetic or something entirely different;
all I learned so far is that 2.6.24 works.  Application log from
2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:

System
-----------------------
K3b Version: 1.0.4

KDE Version: 3.5.8
QT Version:  3.3.8
Kernel:      2.6.25-rc3
Devices
-----------------------
MATSHITA CD-RW  CW-8124 DACH (/dev/hda, ) [CD-R, CD-RW, CD-ROM, DVD-ROM] [DVD-ROM, CD-ROM, CD-R, CD-RW] [SAO, TAO, RAW, SAO/R96P, SAO/R96R, RAW/R16, RAW/R96P, RAW/R96R]

Used versions
-----------------------
cdrecord: 1.1.6

cdrecord
-----------------------
/usr/bin/wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.
scsidev: '/dev/hda'
devname: '/dev/hda'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.6
SCSI buffer size: 64512
Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
communication breaks or freezes immediately after that.
TOC Type: 1 = CD-ROM
Driveropts: 'burnfree'
Device type    : Removable CD-ROM
Version        : 0
Response Format: 2
Capabilities   : 
Vendor_info    : 'MATSHITA'
Identification : 'CD-RW  CW-8124  '
Revision       : 'DACH'
Device seems to be: Generic mmc2 DVD-ROM.
Current: 0x0009 (CD-R)
Profile: 0x0010 (DVD-ROM) 
Profile: 0x0008 (CD-ROM) 
Profile: 0x0009 (CD-R) (current)
Profile: 0x000A (CD-RW) 
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-2 SWABAUDIO BURNFREE 
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
Drive buf size : 1716960 = 1676 KB
FIFO size      : 12582912 = 12288 KB
Speed set to 4233 KB/s
Track 01: data   698 MB        
Total size:      802 MB (79:28.48) = 357636 sectors
Lout start:      802 MB (79:30/36) = 357636 sectors
Current Secsize: 2048
ATIP info from disk:
  Indicated writing power: 4
  Is not unrestricted
  Is not erasable
  Disk sub type: Medium Type A, low Beta category (A-) (2)
  ATIP start of lead in:  -12508 (97:15/17)
  ATIP start of lead out: 359845 (79:59/70)
Disk type:    Short strategy type (Phthalocyanine or similar)
Manuf. index: 22
Manufacturer: Ritek Co.
Blocks total: 359845 Blocks current: 359845 Blocks remaining: 2209
Starting to write CD/DVD at speed  24.0 in dummy SAO mode for single session.
Last chance to quit, starting dummy write in  2 seconds.
   1 seconds.
   0 seconds. Operation starts.
Waiting for reader process to fill input buffer ... input buffer ready.
Sending CUE sheet...
Errno: 0 (Success), write_g1 scsi sendcmd: no error
CDB:  2A 00 FF FF FF 6A 00 00 1F 00
status: 0x2 (CHECK CONDITION)
Sense Bytes:
Sense Key: 0xFFFFFFFF [], Segment 0
Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
Sense flags: Blk 0 (not valid) 
resid: 63488
cmd finished after 0.001s timeout 200s
Writing pregap for track 1 at -150
write track pad data: error after 0 bytes
BFree: 1674 K BSize: 1676 K
Starting new track at sector: 0
Track 01:    0 of  698 MB written.
Errno: 0 (Success), write_g1 scsi sendcmd: no error
CDB:  2A 00 00 00 00 00 00 00 1F 00
status: 0x2 (CHECK CONDITION)
Sense Bytes:
Sense Key: 0xFFFFFFFF [], Segment 0
Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
Sense flags: Blk 0 (not valid) 
resid: 63488
cmd finished after 0.004s timeout 200s
/usr/bin/wodim: A write error occured.
/usr/bin/wodim: Please properly read the error message above.
write track data: error after 0 bytes
Writing  time:    5.257s
Average write speed 909.6x.
Fixating...
Errno: 0 (Success), test unit ready scsi sendcmd: no error
CDB:  00 00 00 00 00 00
status: 0x2 (CHECK CONDITION)
Sense Bytes:
Sense Key: 0xFFFFFFFF [], Segment 0
Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
Sense flags: Blk 0 (not valid) 
cmd finished after 0.000s timeout 200s
Errno: 0 (Success), flush cache scsi sendcmd: no error
CDB:  35 00 00 00 00 00 00 00 00 00
status: 0x2 (CHECK CONDITION)
Sense Bytes:
Sense Key: 0xFFFFFFFF [], Segment 0
Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
Sense flags: Blk 0 (not valid) 
cmd finished after 0.001s timeout 200s
WARNING: Some drives don't like fixation in dummy mode.
Trouble flushing the cache
Fixating time:   17.014s
/usr/bin/wodim: fifo had 191 puts and 1 gets.
/usr/bin/wodim: fifo was 0 times empty and 0 times full, min fill was 100%.

cdrecord command:
-----------------------
/usr/bin/wodim -v gracetime=2 dev=/dev/hda speed=24 -dao -dummy driveropts=burnfree -eject -data -tsize=357636s - 

-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/

