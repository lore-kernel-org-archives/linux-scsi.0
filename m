From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 10:55:21 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC7FC89.4060601@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311280831330.1470-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl262.nas911.n-yokohama.nttpc.ne.jp ([210.139.38.6]:55263 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S263596AbTK2Bzu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 20:55:50 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1APuKZ-00397bC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2003 10:55:31 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311280831330.1470-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

Guennadi Liakhovetski wrote:
> On Fri, 28 Nov 2003, Chiaki wrote:
> 
> 
>>I am afraid that it didn't solve the problem.
>>I got the same kernel bug triggered at the same place.
> 
> 
> Ok, then, please, try this one (on the top of yesterday's):
> 
> diff -u linux/drivers/scsi/scsiiom.c~ linux/drivers/scsi/scsiiom.c
> --- linux/drivers/scsi/scsiiom.c~	Thu Nov 27 23:02:35 2003
> +++ linux/drivers/scsi/scsiiom.c	Fri Nov 28 08:29:40 2003
> @@ -1439,7 +1439,7 @@
>  		goto ckc_e;
>  	    }
>  	    SET_RES_DRV(pcmd->result,DRIVER_SENSE);
> -//	    pcmd->use_sg	 = pSRB->SavedSGCount;
> +	    pcmd->use_sg	 = pSRB->SavedSGCount;
>  	    //pSRB->ScsiCmdLen	 = (UCHAR) (pSRB->Segment1[0] >> 8);
>  	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
>  	    pSRB->SGIndex = 0;
> @@ -1734,22 +1734,22 @@
>  static void __inline__
>  dc390_RequestSense( PACB pACB, PDCB pDCB, PSRB pSRB )
>  {
> -//    PSCSICMD  pcmd;
> +    PSCSICMD  pcmd;
> +
> +    pcmd = pSRB->pcmd;
> 
>      REMOVABLEDEBUG(printk (KERN_INFO "DC390: RequestSense (Cmd %02x, Id %02x, LUN %02x)\n",\
> -	    pSRB->pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
> +	    pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
> 
>      pSRB->SRBFlag |= AUTO_REQSENSE;
>      //pSRB->Segment0[0] = (UINT) pSRB->CmdBlock[0];
>      //pSRB->Segment0[1] = (UINT) pSRB->CmdBlock[4];
> -    //pSRB->Segment1[0] = ((UINT)(pSRB->pcmd->cmd_len) << 8) + pSRB->SGcount;
> +    //pSRB->Segment1[0] = ((UINT)(pcmd->cmd_len) << 8) + pSRB->SGcount;
>      //pSRB->Segment1[1] = pSRB->TotalXferredLen;
> -    pSRB->SavedSGCount = pSRB->SGcount;
> +    pSRB->SavedSGCount = pcmd->use_sg;
>      pSRB->SavedTotXLen = pSRB->TotalXferredLen;
>      pSRB->AdaptStatus = 0;
>      pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
> -
> -//    pcmd = pSRB->pcmd;
> 
>      /* We are called from SRBdone, original PCI mapping has been removed
>       * already, new one is set up from StartSCSI */
> 

(My mail feed from linux-scsi list was flakey for the last 24 hours, and
Guennadi Liakohovetski kindly sent me scsiiom.c file entirely after my 
asking for it.)

Hi,

A good news, and a strange observation (not fatal I think...).

I applied the latest patch to scsiiom.c: actually I used the source
file you kindly sent me.

Also, I disabled kernel preemption after reading your post.
 From my .config:
   # CONFIG_PREEMPT is not set

Also, please note that I upgraded to 2.6.0-test11.
(I am still using gcc 3.3.2)

Now the tmscsim module loaded without a problem!

Attached is the initial portion of the message recorded during booting.
The PD drive at lun 0, and CD drive at lun 1 are both recognized, and
I later could mount a joliet CD and list its directory using "ls -R"
and so the driver seems to work fine more or less!

A strange observation is this.  The very first time after I set up the
new kernel and tmscsim module and tried to run 2.6.0-test11, the
module Oopsed again.
But at that time, I was not using serial console :-(
[I thought if the new patch worked for someone else, it might work for 
me.]
I looked at the address where Oops occurred on the screen.
It was slightly different from the one reported earlier.  Obviously,
the patch changed the absolute addresses. However, the symptoms (stack
trace, with a duplication.) was essentially the same from the report I
gave earlier.

However, after this, when I tried the serial console booting afresh, the
system worked withtout a hitch. The attached log was recorded at the time.
Afterward, I also tried the CRT-console booting again. The
system worked just fine this time around. Hmm...

So there *could* be a timing related race or somthing that might
trigger a problem in a rare situation.

On the other hand, since the problem occurred only at the very first
time so far, it may be due to a setup error : like the object file was
not copied correctly although I think that is highly unlikely due to
the nature of "make bzImage; make modules; make modules_install".
Anyway, I will report to you if such an error occurs again.  (Well, I
am not using 2.6.0-testXX regularly, but will try to exercise the new
kernel test versions now and then. Oh, maybe I should test HP DAT
drive, too.).

(The single isolated failure could be even related to my rather
lengthy loadlin command line.  MS-DOS command.com ignores characters
after 128(?) characters and that may have played a role: I shortened
my loadlin command line just in case. I could also use
@additional.bat construct to avoid this, but not used it so far.).

So many variables to eliminate from the equation, so to speak.

Anyway, here is the successful log: again, I tried to remove Japanese
characters from it.


Linux version 2.6.0-test11 (root@duron) (gcc ... 3.3.2 (Debian)) #4 Sat 
Nov 29 09:11:21 JST 2003
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
  BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
  BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
767MB LOWMEM available.
On node 0 totalpages: 196592
   DMA zone: 4096 pages, LIFO batch:1
   Normal zone: 192496 pages, LIFO batch:16
   HighMem zone: 0 pages, LIFO batch:1
DMI 2.2 present.
Building zonelist for node : 0
Kernel command line: root=/dev/sda6 ro scsihosts=sym53c8xx:tmscsim 
console=ttyS0
,9600n8 BOOT_IMAGE=260t9
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 1535.151 MHz processor.
Console: colour VGA+ 80x28
Memory: 774720k/786368k available (1888k kernel code, 10880k reserved, 
703k data
, 136k init, 0k highmem)
Calibrating delay loop... 3022.84 BogoMIPS
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) XP 1800+ stepping 02
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb690, last bus=1
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
Linux Plug and Play Support v0.97 (c) Adam Belay
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fc030
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc060, dseg 0xf0000
PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by driver
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
Machine check exception polling timer started.
ikconfig 0.7 with /proc/config*
devfs: v1.22 (20021013) Richard Gooch (rgooch@atnf.csiro.au)
devfs: devfs_debug: 0x0
devfs: boot_options: 0x0
Initializing Cryptographic API
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
agpgart: Detected AMD 761 chipset
agpgart: Maximum main memory to use for agp memory: 690M
agpgart: AGP aperture is 64M @ 0xf0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Intel(R) PRO/100 Network Driver - version 2.3.30-k1
Copyright (c) 2003 Intel Corporation

PCI: Found IRQ 11 for device 0000:00:0f.0
PCI: Sharing IRQ 11 with 0000:00:0d.0
e100: eth0: Intel(R) PRO/100 Network Connection

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
     ide0: BM-DMA at 0xb400-0xb407, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xb408-0xb40f, BIOS settings: hdc:DMA, hdd:pio
hda: ST320423A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: MATSHITA CR-583, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
HPT370A: IDE controller at PCI slot 0000:00:13.0
PCI: Found IRQ 5 for device 0000:00:13.0
HPT370A: chipset revision 4
HPT37X: using 33MHz PCI clock
HPT370A: 100% native mode on irq 5
     ide2: BM-DMA at 0xe400-0xe407, BIOS settings: hde:pio, hdf:pio
     ide3: BM-DMA at 0xe408-0xe40f, BIOS settings: hdg:pio, hdh:pio
hda: max request size: 128KiB
hda: 40011300 sectors (20485 MB) w/512KiB Cache, CHS=39693/16/63, UDMA(66)
  /dev/ide/host0/bus0/target0/lun0: p1 p2 < p5 p6 p7 p8 p9 p10 p11 p12 
p13 p14 >
PCI: Found IRQ 10 for device 0000:00:0b.0
PCI: Sharing IRQ 10 with 0000:00:07.2
PCI: Sharing IRQ 10 with 0000:00:07.3
PCI: Sharing IRQ 10 with 0000:00:08.0
sym0: <895> rev 0x1 at pci 0000:00:0b.0 irq 10
sym0: Tekram NVRAM, ID 7, Fast-40, SE, parity checking
sym0: SCSI BUS has been reset.
sym0: SCSI BUS mode change from SE to SE.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18b
   Vendor: HITACHI   Model: DK318H-91WS	     Rev: B2BQ
   Type:	  Direct-Access			     ANSI SCSI revision: 02
sym0:4:0: tagged command queuing enabled, command queue depth 16.
   Vendor: IBM	    Model: DNES-318350Y	     Rev: SA60
   Type:	  Direct-Access			     ANSI SCSI revision: 03
sym0:6:0: tagged command queuing enabled, command queue depth 16.
sym0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
sym0:6:0:phase change 2-3 12@2fc5cf60 resid=11.
sym0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
SCSI device sda: 17773980 512-byte hdwr sectors (9100 MB)
SCSI device sda: drive cache: write through
  /dev/scsi/host0/bus0/target4/lun0: p1 < p5 p6 p7 p8 >
Attached scsi disk sda at scsi0, channel 0, id 4, lun 0
SCSI device sdb: 35566501 512-byte hdwr sectors (18210 MB)
SCSI device sdb: drive cache: write through
  /dev/scsi/host0/bus0/target6/lun0: p1 < p5 p6 p7 >
Attached scsi disk sdb at scsi0, channel 0, id 6, lun 0
mice: PS/2 mouse device common for all mice
input: PS/2 Logitech Mouse on isa0060/serio1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
I2O Core - (C) Copyright 1999 Red Hat Software
I2O: Event thread created as pid 12
i2o: Checking for PCI I2O controllers...
I2O configuration manager v 0.04.
   (C) Copyright 1999 Red Hat Software
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 37449)
NET: Registered protocol family 1
NET: Registered protocol family 17
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 136k freed
INIT: version 2.84 booting
Loading /etc/console/boottime.kmap.gz
Activating swap.
Adding 2000052k swap on /dev/hda12.  Priority:-1 extents:1
Checking root file system...
fsck 1.34-WIP (21-May-2003)
/dev/sda6: clean, 212160/895840 files, 1634625/1791484 blocks
/etc/isapnp.conf:20 -- Fatal - Error occurred executing request 'ISOLATE 
PRESERV
E' --- further action aborted
System time was Sat Nov 29 00:58:21 UTC 2003.
Setting the System Clock using the Hardware Clock as reference...
System Clock set. System local time is now Sat Nov 29 09:58:23 JST 2003.
Calculating module dependencies... done.
Loading modules...
     hpfs
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?
     nls_cp437
     sg
Attached scsi generic sg0 at scsi0, channel 0, id 4, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 6, lun 0,  type 0
     sr_mod
     tmscsim
PCI: Found IRQ 11 for device 0000:00:0d.0
PCI: Sharing IRQ 11 with 0000:00:0f.0
DC390: 1 adapters found
scsi1 : Tekram DC390/AM53C974 V2.0f 2000-12-20
DC390: Target 5: Sync transfer 5.0 MHz, Offset 8
   Vendor: MATSHITA  Model: PD-1 LF-1000	     Rev: A111
   Type:	  Optical Device		     ANSI SCSI revision: 02
Attached scsi removable disk sdc at scsi1, channel 0, id 5, lun 0
Attached scsi generic sg2 at scsi1, channel 0, id 5, lun 0,  type 7
   Vendor: MATSHITA  Model: PD-1 LF-1000	     Rev: A111
   Type:	  CD-ROM			     ANSI SCSI revision: 02
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.12
Attached scsi generic sg3 at scsi1, channel 0, id 5, lun 1,  type 5
     ide-cd
hdc: ATAPI 8X CD-ROM drive, 128kB Cache, DMA
     radeon
[drm] Initialized radeon 1.9.0 20020828 on minor 0
     ecc
FATAL: Module ecc not found.
     ipv6
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
All modules loaded.
Checking all file systems...
fsck 1.34-WIP (21-May-2003)
/dev/sdb5: clean, 167104/770048 files, 1449390/1537272 blocks
/dev/hda11: clean, 13/250368 files, 455595/500015 blocks
/dev/hda10: clean, 12/250368 files, 129092/500015 blocks
Setting kernel variables..
Mounting local filesystems...
/dev/sdb5 on /u2 type ext2 (rw)
mount: none already mounted or /dev/pts busy
mount: according to mtab, devpts is already mounted on /dev/pts
mount: fs type shm not supported by kernel
/dev/hda11 on /dos-vmware-dir type ext2 (rw)
/dev/hda10 on /dos-vmware-2-dir type ext2 (rw)
/dev/hda1 on /dos-c-drive type vfat (rw)

	  ... omitted ...

Later from the command line.

ishikawa@duron$ cat /proc/scsi/
device_info  scsi	  sg	       sym53c8xx    tmscsim
ishikawa@duron$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 04 Lun: 00
   Vendor: HITACHI  Model: DK318H-91WS	   Rev: B2BQ
   Type:	  Direct-Access			   ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
   Vendor: IBM	   Model: DNES-318350Y	   Rev: SA60
   Type:	  Direct-Access			   ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 05 Lun: 00
   Vendor: MATSHITA Model: PD-1 LF-1000	   Rev: A111
   Type:	  Optical Device		   ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 05 Lun: 01
   Vendor: MATSHITA Model: PD-1 LF-1000	   Rev: A111
   Type:	  CD-ROM			   ANSI SCSI revision: 02
ishikawa@duron$ cat /proc/scsi/tmscsim/1
Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f 2000-12-20
SCSI Host Nr 1, DC390 Adapter Nr 0
IOPortBase 0xcc00, IRQ 11
MaxID 7, MaxLUN 8, AdapterID 7, SelTimeout 250 ms, DelayReset 3 s
TagMaxNum 16, Status 0x00, ACBFlag 0x00, GlitchEater 24 ns
Statistics: Cmnds 28, Cmnds not sent directly 0, Out of SRB conds 0
	    Lost arbitrations 0, Sel. connected 0, Connected: No
Nr of attached devices: 4, Nr of DCBs: 2
Map of attached LUNs: 00 00 00 00 00 03 00 00
Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd
00  05	00  Yes	 Yes  Yes  Yes	No    200 ns	 5.0 M	    08	    01
01  05	01  Yes	 Yes  Yes  Yes	No    200 ns	 5.0 M	    08	    01
Commands in Queues: Query: 0:
ishikawa@duron$ ls /dev/cdrom*
/dev/cdrom@
ishikawa@duron$ ls -l /dev/cdroms
ishikawa@duron$ ls -l /dev/sr*
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr0 -> scd0
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr1 -> scd1
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr2 -> scd2
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr3 -> scd3
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr4 -> scd4
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr5 -> scd5
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr6 -> scd6
lrwxrwxrwx    1 root	 root		 4 2000-11-24 05:31 /dev/sr7 -> scd7
ishikawa@duron$ dmesg | grep sr
sr0: scsi-1 drive
Attached scsi CD-ROM sr0 at scsi1, channel 0, id 5, lun 1
ishikawa@duron$ su
Password:
duron:/home/ishikawa# mount /dev/sr0 /mnt
mount: block device /dev/sr0 is write-protected, mounting read-only
duron:/home/ishikawa# ls -l /mnt
  2992
dr-xr-xr-x    1 root	 root	      2048 2003-05-07 14:25 DATA
-r-xr-xr-x    1 root	 root	   3061340 2003-05-07 14:25 prog.exe

	     ... later I could recursively list DATA ...


Thank you agai for your help.


PS: now that the driver seems to be in better shape, you might want to
bump the driver version number  reported in the banner,
"Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f 
2000-12-20".
The new version banner will help you and users in keeping track of the new
drivers which will solve problems encountered in the future versions
of 2.6.x kernel. Numbering probably should be coordinated with
Kurt Garloff.

PPS: also someone might want to run
	indent -kr -i8
on the source files after the cleanup (or before cleanup).





-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

