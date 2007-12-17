From: "John Stoffel" <john@stoffel.org>
Subject: Re: 2.6.24-rc5: tape drive not responding
Date: Sun, 16 Dec 2007 20:05:51 -0500
Message-ID: <18277.52079.718004.969358@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:36939 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXLQBFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Dec 2007 20:05:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Hi,

This looks to be a regression between 2.6.23 and 2.6.24-rc5, I'll try
to bi-sect this and report more on it.  Basically, when I bootup, I
get a ton of errors in the dmesg log along the lines of:

[  215.007701] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.008145] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.008678] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.009122] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.009598] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.010042] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.010516] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.010959] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.011403] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  215.011850] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
.
.
.
[  232.954629] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  233.035902] scsi 3:0:3:0: DEVICE RESET operation started
[  233.099514] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
.
.
.

These repeat for about 15 seconds or so.  They're really annoying and
I'd love to see some sort of rate limiting put in here.  The messages
and end with:
.
.
.
[  238.084175] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  238.165887] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  238.247157] scsi 3:0:3:0: DEVICE RESET operation timed-out.
[  238.313892] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  238.395192] scsi 3:0:3:0: BUS RESET operation started
[  238.455690] sym1: SCSI parity error detected: SCR1=1 DBC=11000028 SBCL=ae
[  238.539216] sym1: SCSI BUS reset detected.
[  238.592552] sym1: SCSI BUS has been reset.
[  238.641576] scsi 3:0:3:0: BUS RESET operation complete.
[  248.700373]  target3:0:3: wide asynchronous
[  248.752026]  target3:0:3: Wide Transfers Fail
[  248.805220]  target3:0:3: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[  248.886729]  target3:0:3: Domain Validation skipping write tests
[  248.958666]  target3:0:3: Ending Domain Validation
[  252.264086] scsi 3:0:0:0: Attached scsi generic sg2 type 8
[  252.331257] st 3:0:2:0: Attached scsi tape st0
[  252.384549] st 3:0:2:0: st0: try direct i/o: yes (alignment 512 B)
[  252.458875] st 3:0:2:0: Attached scsi generic sg3 type 1
[  252.523963] st 3:0:3:0: Attached scsi tape st1
[  252.577184] st 3:0:3:0: st1: try direct i/o: yes (alignment 512 B)
[  252.651484] st 3:0:3:0: Attached scsi generic sg4 type 1


I've also got an ATL P1000 SCSI tape library hooked up to this same
controller and port, and I can manipulate it properly using the 'mtx'
program pointed to the /dev/changer alias, which points to the correct
/dev/sg# device.

Here's my /proc/scsi/scsi output, as you can see, I've got a bunch of
devices on this system:

# cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: COMPAQ   Model: HC01841729       Rev: 3208
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: COMPAQ   Model: BD018222CA       Rev: B016
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATL      Model: P1000    6220051 Rev: 1.20
  Type:   Medium Changer                   ANSI  SCSI revision: 02
Host: scsi3 Channel: 00 Id: 02 Lun: 00
  Vendor: QUANTUM  Model: DLT7000          Rev: 2565
  Type:   Sequential-Access                ANSI  SCSI revision: 02
Host: scsi3 Channel: 00 Id: 03 Lun: 00
  Vendor: QUANTUM  Model: DLT7000          Rev: 2565
  Type:   Sequential-Access                ANSI  SCSI revision: 02
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: SAMSUNG  Model: CDRW/DVD SM-352B Rev: T806
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3320620AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200AAKS-0 Rev: 12.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi10 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD1200JB-00C Rev: 17.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi11 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD1200JB-00E Rev: 15.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi12 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi12 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi12 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi12 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 00


When I try to access my tape devices, I get the following:

    # mt -f /dev/st0 status
    /dev/st0: Device or resource busy

But lsof doesn't show any other processes accessing this device, and
I've stopped my backup software since it keeps hanging on tape device
access.

Here's the output of dmesg where I get the OOPS:

[  273.382057] sd 12:0:0:3: Attached scsi generic sg13 type 0
[  276.244872] ------------[ cut here ]------------
[  276.300215] kernel BUG at include/linux/scatterlist.h:59!
[  276.364873] invalid opcode: 0000 [#1] SMP 
[  276.414346] Modules linked in:
[  276.451148] 
[  276.469036] Pid: 1824, comm: stinit Not tainted (2.6.24-rc5 #2)
[  276.539940] EIP: 0060:[<c0343c30>] EFLAGS: 00010213 CPU: 0
[  276.605651] EIP is at st_do_scsi+0x2e0/0x340
[  276.656788] EAX: 00000000 EBX: 00000000 ECX: c16ef780 EDX: f7c4f050
[  276.731847] ESI: f7c4f7d0 EDI: 00001000 EBP: f7c4f000 ESP: f712bdf8
[  276.806904]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  276.871568] Process stinit (pid: 1824, ti=f712b000 task=f750a030 task.ti=f712b000)
[  276.960139] Stack: 00000003 f7c4f050 00000000 00000000 00d59f80 00000000 f776fe20 c03468a0 
[  277.062012]        000000d0 f712be9c f7d2a000 f776fe20 f7d2a018 00000000 00000006 f712be9c 
[  277.163890]        f7d2a000 f712beac f7c4f000 c0345790 00000006 00000002 000dbba0 00000000 
[  277.265771] Call Trace:
[  277.297383]  [<c03468a0>] st_sleep_done+0x0/0x70
[  277.352894]  [<c0345790>] check_tape+0x510/0x640
[  277.408414]  [<c0346cfb>] st_open+0x18b/0x220
[  277.460803]  [<c01707e0>] exact_match+0x0/0x10
[  277.514237]  [<c0346b70>] st_open+0x0/0x220
[  277.564553]  [<c0170ebf>] chrdev_open+0x9f/0x190
[  277.620069]  [<c0170e20>] chrdev_open+0x0/0x190
[  277.674543]  [<c016c86f>] __dentry_open+0xaf/0x1b0
[  277.732136]  [<c016ca25>] nameidata_to_filp+0x35/0x40
[  277.792847]  [<c016ca7b>] do_filp_open+0x4b/0x60
[  277.848364]  [<c016c732>] get_unused_fd_flags+0x52/0xd0
[  277.911153]  [<c016cadc>] do_sys_open+0x4c/0xe0
[  277.965629]  [<c016cbac>] sys_open+0x1c/0x20
[  278.016983]  [<c0104306>] syscall_call+0x7/0xb
[  278.070419]  =======================
[  278.113249] Code: 32 8b 54 24 28 89 44 24 2c 89 50 74 e9 ba fd ff ff 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe 64 a1 00 40 6c c0 8b 40 04 8b 40 08 a8 
[  278.352558] EIP: [<c0343c30>] st_do_scsi+0x2e0/0x340 SS:ESP 0068:f712bdf8
[  278.437476] ------------[ cut here ]------------
[  278.492809] kernel BUG at include/linux/scatterlist.h:59!
[  278.557467] invalid opcode: 0000 [#2] SMP 
[  278.606943] Modules linked in:
[  278.643745] 
[  278.661635] Pid: 1826, comm: stinit Tainted: G      D (2.6.24-rc5 #2)
[  278.738774] EIP: 0060:[<c0343c30>] EFLAGS: 00010213 CPU: 1
[  278.804482] EIP is at st_do_scsi+0x2e0/0x340
[  278.855623] EAX: 00000000 EBX: 00000000 ECX: c16e0ce0 EDX: f740c050
[  278.930680] ESI: f740c7d0 EDI: 00001000 EBP: f740c000 ESP: f70f9df8
[  279.005738]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  279.070402] Process stinit (pid: 1826, ti=f70f9000 task=f705e580 task.ti=f70f9000)
[  279.158970] Stack: 00000003 f740c050 00000000 00000000 00d59f80 00000000 f759cbe0 c03468a0 
[  279.260848]        000000d0 f70f9e9c f7d22e00 f759cbe0 f7d22e18 00000000 00000006 f70f9e9c 
[  279.362727]        f7d22e00 f70f9eac f740c000 c0345790 00000006 00000002 000dbba0 00000000 
[  279.464606] Call Trace:
[  279.496220]  [<c03468a0>] st_sleep_done+0x0/0x70
[  279.551728]  [<c0345790>] check_tape+0x510/0x640
[  279.607243]  [<c0346cfb>] st_open+0x18b/0x220
[  279.659636]  [<c01707e0>] exact_match+0x0/0x10
[  279.713076]  [<c0346b70>] st_open+0x0/0x220
[  279.763389]  [<c0170ebf>] chrdev_open+0x9f/0x190
[  279.818903]  [<c0170e20>] chrdev_open+0x0/0x190
[  279.873377]  [<c016c86f>] __dentry_open+0xaf/0x1b0
[  279.930973]  [<c016ca25>] nameidata_to_filp+0x35/0x40
[  279.991684]  [<c016ca7b>] do_filp_open+0x4b/0x60
[  280.047198]  [<c016c732>] get_unused_fd_flags+0x52/0xd0
[  280.109989]  [<c016cadc>] do_sys_open+0x4c/0xe0
[  280.164463]  [<c016cbac>] sys_open+0x1c/0x20
[  280.215819]  [<c0104306>] syscall_call+0x7/0xb
[  280.269252]  =======================
[  280.312081] Code: 32 8b 54 24 28 89 44 24 2c 89 50 74 e9 ba fd ff ff 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe 64 a1 00 40 6c c0 8b 40 04 8b 40 08 a8 
[  280.551395] EIP: [<c0343c30>] st_do_scsi+0x2e0/0x340 SS:ESP 0068:f70f9df8




And here's my CPU and other info:

# lspci
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


# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 547.192
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 1094.96
clflush size    : 32

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 547.192
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 1094.20
clflush size    : 32

# cat /proc/scsi/sym53c8xx/2 
Chip sym53c875, device id 0xf, revision id 0x14
At PCI address 0000:00:0d.0, IRQ 17
Min. period factor 12, Wide SCSI BUS
Max. started commands 448, max. commands per LUN 64

jfsnew:~# cat /proc/scsi/sym53c8xx/3
Chip sym53c875, device id 0xf, revision id 0x14
At PCI address 0000:00:0d.1, IRQ 16
Min. period factor 12, Wide SCSI BUS
Max. started commands 448, max. commands per LUN 64



Thanks,
John



