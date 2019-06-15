From: Andrew Randrianasulu <randrianasulu@gmail.com>
Subject: Bug 7805 strikes again?
Date: Sat, 15 Jun 2019 19:16:09 +0300
Message-ID: <201906151916.09688.randrianasulu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello!

I was puzzled by strange fact my qemu stopped to boot DVDs I made over years, if I put them in physical drive and try to boot them via qemu.
After  a lot of digging I found possible reason: wrongly-set block device size on /dev/sr0

And this lead me to
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=619757

and
https://bugzilla.kernel.org/show_bug.cgi?id=7805

so I checked if my dmesg had anything related to pktcdvd:

 dmesg | grep pkt
[    7.681270] pktcdvd: pktcdvd0: writer mapped to sr0


blockdev --getsize64 /dev/sr0
1073741312
pktsetup -d /dev/sr0
pktsetup: Error: Can't tear down packet device '/dev/sr0': Inappropriate ioctl for device

 blockdev --getsize64 /dev/sr0
4700372992

after this I can boot my DVD fully (before it was failing at mounting squashfs images):
qemu-system-x86_64 -enable-kvm -display sdl,gl=on -cdrom /dev/sr0 -m 1G -soundhw es1370 -usbdevice mouse -smp 3 -cpu max

 uname -a
Linux slax 5.1.6-x64 #1 SMP PREEMPT Fri May 31 23:49:35 MSK 2019 x86_64 AMD FX(tm)-4300 Quad-Core Processor AuthenticAMD GNU/Linux

Userspace is 32-bit Slackware (mix of many versions).

 sg_inq /dev/sr0
standard INQUIRY:
  PQual=0  Device_type=5  RMB=1  LU_CONG=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: cd/dvd
 Vendor identification: ASUS
 Product identification: DRW-24D5MT
 Product revision level: 1.00
