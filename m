From: Matthias Henze <matthias@mhcsoftware.de>
Subject: CD Recorder does not work with 2.6
Date: Thu, 04 Mar 2004 11:15:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <pan.2004.03.04.10.15.33.654587@mhcsoftware.de>
Reply-To: matthias@mhcsoftware.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:1931 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261787AbUCDKUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 05:20:38 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1Aypy0-0002Om-00
	for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2004 11:20:36 +0100
Received: from p5085ec99.dip0.t-ipconnect.de ([80.133.236.153])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu Mar  4 10:20:36 2004
Received: from matthias by p5085ec99.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu Mar  4 10:20:36 2004
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi,

my problem:

mount /dev/sr0  hangs forever and could not be killed.

cdrecord -scanbus shows:

Linux sg driver version: 3.5.30
Using libscg version 'schily-0.8'.
scsibus0:
        0,0,0     0) *
        0,1,0     1) *
        0,2,0     2) *
        0,3,0     3) *
        0,4,0     4) *

and hangs forever, but could be stoped with crtl-c


everything used to work fine with kernel 2.4.

I've upgraded to kernel 2.6.3 on a debian sid based system. dmesg shows:

--- snip ---

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7890/91 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:5): 20.000MB/s transfers (20.000MHz, offset 16)
  Vendor: PLEXTOR   Model: CD-R   PX-W1210S  Rev: 1.00
  Type:   CD-ROM                             ANSI SCSI revision: 02
hdd: ATAPI 40X DVD-ROM drive, 512kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 5, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 5, lun 0,  type 5

--- snap ---

the usb scsi emulation for flash memory is active. the following modules
are loaded:

Module                  Size  Used by
aes                    32480  4
cryptoloop              3616  4
ext2                   72360  4
loop                   17960  9 cryptoloop
nls_cp437               5568  0
vfat                   15680  0
fat                    46848  1 vfat
snd_mixer_oss          20064  0
snd                    55428  1 snd_mixer_oss
parport_pc             35244  0
lp                     11556  0
parport                44520  2 parport_pc,lp
md5                     3872  1
ipv6                  255264  8
nfsd                  179776  8
exportfs                6496  1 nfsd
nfs                   186496  1
lockd                  63176  3 nfsd,nfs
sunrpc                138600  5 nfsd,nfs,lockd
dm_mod                 41568  0
md                     47400  0
autofs4                16000  1
af_packet              22216  2
nls_iso8859_1           3904  0
reiserfs              234000  0
agpgart                32424  0
eepro100               30444  0
mii                     5024  1 eepro100
emu10k1_gp              3456  0
gameport                4704  1 emu10k1_gp
emu10k1                84580  2
sound                  84812  1 emu10k1
ac97_codec             19084  1 emu10k1
soundcore              10208  5 snd,emu10k1,sound
psmouse                19976  0
mousedev               10004  1
usbmouse                5568  0
usb_storage            68000  0
ohci_hcd               19332  0
uhci_hcd               33136  0
usbcore               106684  6 usbmouse,usb_storage,ohci_hcd,uhci_hcd
apm                    18188  2
sg                     38880  0
sr_mod                 16612  1
ide_cd                 42468  0
cdrom                  39008  3 sr_mod,ide_cd
aic7xxx               206476  6
rtc                    12696  0
ext3                  121064  3
jbd                    62072  1 ext3
mbcache                 9220  2 ext2,ext3
sd_mod                 16736  0
ata_piix                8036  0
libata                 40928  1 ata_piix,[permanent]
scsi_mod              118136  6 usb_storage,sg,sr_mod,aic7xxx,sd_mod,libata
ide_disk               18560  7
ide_detect              1088  0
piix                   12768  1
ide_core              157644  5 usb_storage,ide_cd,ide_disk,ide_detect,piix
unix                   28368  359
fbcon                  30756  0
font                    8320  1 fbcon
vesafb                  5292  1
cfbcopyarea             3968  1 vesafb
cfbimgblt               3168  1 vesafb
cfbfillrect             3904  1 vesafb


any suggestions ?

TIA
matthias

