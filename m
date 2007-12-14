From: "John Stoffel" <john@stoffel.org>
Subject: 2.6.24-rc5-mm1:  kernel BUG at include/linux/scatterlist.h:59!
Date: Fri, 14 Dec 2007 18:05:56 -0500
Message-ID: <18275.3156.745358.12056@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933056AbXLNXGS@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi,

Just fired up 2.6.24-rc5-mm1 on a Dual CPU PIII 550mhz system with 2gb
of RAM.  Got the following error.  Let me know if you need more
details or want me to run tests or make changes.  Looks like something
in the SCSI st driver, which makes sense since I have a pair of DLT 7k
drives hooked upto this system via a Symbios PCI card.  I've also got
a P1000 jukebox on there as well.

  [  354.338667] kernel BUG at include/linux/scatterlist.h:59!
  [  354.403311] invalid opcode: 0000 [#1] SMP 
  [  354.452774] last sysfs file:
  /sys/devices/pci0000:00/0000:00:0d.1/host3/target3:0:3/3:0:3:0/vendor
  [  354.560099] Modules linked in:
  [  354.596859] 
  [  354.614753] Pid: 1795, comm: stinit Not tainted (2.6.24-rc5-mm1 #3)
  [  354.689825] EIP: 0060:[<c0356bd0>] EFLAGS: 00010213 CPU: 0
  [  354.755538] EIP is at st_do_scsi+0x2e0/0x340
  [  354.806668] EAX: 00000000 EBX: 00000000 ECX: c16e1f80 EDX: f7f87050
  [  354.881731] ESI: f7f877d0 EDI: 00001000 EBP: f7f87000 ESP: f7167db0
  [  354.956788]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  [  355.021452] Process stinit (pid: 1795, ti=f7167000 task=f74d7030
  task.ti=f7167000)
  [  355.110028] Stack: 00000003 f7f87050 00000000 00000000 00d59f80
  00000000 f75cf9e0 c0359840 
  [  355.211879]        000000d0 f7167e54 f7d2bc00 f75cf9e0 f7d2bc18
  00000000 00000006 f7167e54 
  [  355.313757]        f7d2bc00 f7167e64 f7f87000 c0358730 00000006
  00000002 000dbba0 00000000 
  [  355.415639] Call Trace:
  [  355.447258]  [<c0359840>] st_sleep_done+0x0/0x70
  [  355.502773]  [<c0358730>] check_tape+0x510/0x640
  [  355.558284]  [<c0359c9b>] st_open+0x18b/0x220
  [  355.610677]  [<c0171850>] exact_match+0x0/0x10
  [  355.664113]  [<c0359b10>] st_open+0x0/0x220
  [  355.714429]  [<c0171f2f>] chrdev_open+0x9f/0x190
  [  355.769945]  [<c0171e90>] chrdev_open+0x0/0x190
  [  355.824418]  [<c016d685>] __dentry_open+0xb5/0x2a0
  [  355.882013]  [<c01762cb>] permission+0xdb/0x100
  [  355.936486]  [<c016d937>] nameidata_to_filp+0x47/0x60
  [  355.997200]  [<c017985d>] open_pathname+0x17d/0x740
  [  356.055831]  [<c011fa10>] update_curr+0x80/0x110
  [  356.111345]  [<c0123792>] scheduler_tick+0xe2/0x130
  [  356.169979]  [<c0177765>] getname+0xa5/0xc0
  [  356.220294]  [<c016d4bc>] do_sys_open+0x4c/0xe0
  [  356.274770]  [<c016d58c>] sys_open+0x1c/0x20
  [  356.326123]  [<c0103f6e>] syscall_call+0x7/0xb
  [  356.379559]  =======================
  [  356.422393] Code: 32 8b 54 24 28 89 44 24 2c 89 50 74 e9 ba fd ff ff 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe 64 a1 00 50 6e c0 8b 40 04 8b 40 08 a8 
  [  356.661693] EIP: [<c0356bd0>] st_do_scsi+0x2e0/0x340 SS:ESP
  0068:f7167db0


My system is pretty loaded with the following stuff in lspci:

  00:00.0 Host bridge: Intel Corporation 440GX - 82443GX Host bridge
  00:01.0 PCI bridge: Intel Corporation 440GX - 82443GX AGP bridge
  00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
  00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
  00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
  00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
  00:0d.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
  00:0d.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
  00:0e.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
  00:10.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) (rev 13)
  00:11.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
  00:13.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
  01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G400/G450 (rev 82)
  02:08.0 USB Controller: NEC Corporation USB (rev 41)
  02:08.1 USB Controller: NEC Corporation USB (rev 41)
  02:08.2 USB Controller: NEC Corporation USB 2.0 (rev 02)
  02:0b.0 FireWire (IEEE 1394): Texas Instruments TSB12LV26 IEEE-1394 Controller (Link)
  03:06.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N (rev 01)
  03:09.0 Communication controller: Cyclades Corporation Cyclom-8Y above first megabyte (rev 01)
  03:0a.0 SCSI storage controller: Adaptec AHA-2940U2/U2W / 7890/7891
  03:0e.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
