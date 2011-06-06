From: John Lumby <johnlumby@hotmail.com>
Subject: PROBLEM:  spinlock errors and system dies on 2.6.39
Date: Mon, 6 Jun 2011 15:36:28 -0400
Message-ID: <COL116-W197CF565B7C648D53CD409A3600@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from col0-omc4-s7.col0.hotmail.com ([65.55.34.209]:39331 "EHLO
	col0-omc4-s7.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757704Ab1FFTg3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2011 15:36:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi list <linux-scsi@vger.kernel.org>


(apologies for terrible formatting of previous message=A0 - try again=A0=
 -=A0 but just in case this one is also unreadable, =A0 it is readable =
here :
http://marc.info/?l=3Dlinux-kernel&m=3D130732656325766&w=3D2=20
=A0)

(also posted to linux-kernel =A0:: =A0the first error message is from s=
csi, =A0so posting to scsi as well.)

PROBLEM: spinlock errors and system dies on 2.6.39 when I plug in my Ki=
ngston Data Traveller USB mass storage device.

On 2.6.39 (built from source using GCC 4.5.3),=A0=A0=A0 when I insert t=
he stick,=A0=A0 the kernel displays BUG reports to the console and the =
system becomes unavailable.=A0=A0=A0=A0 I managed to gather to relevant=
 console messages from a serial console,=A0 attached below.=20

I noticed one thing: =A0 I have console timestamping enabled. =A0=A0 Th=
e bug always happens with this enabled.=20
But if I turn off the console timestamping with printk.time=3D0,=A0=A0 =
it very occasionally does not happen (scsi device comes up as expected)=
=2E=A0=A0 So it may be a timing problem.

The bug never happens on 2.6.38.4

console messages:=A0=A0 (I had to paste some information as the serial =
console garbled some pieces of some lines -=A0 some addresses and offse=
ts may be incorrect but the sequence is correct)

[=A0 174.192721] scsi 2:0:0:0: Direct-Access=A0=A0=A0=A0 Kingston DataT=
raveler G3=A0 1.00 PQ: 0 ANSI: 2
[=A0 174.210226] scsi: killing requests for dead queue
[=A0 174.212068] BUG: spinlock already unlocked on CPU#0, ksoftirqd/0/3
[=A0 174.212068]=A0 lock: f55dc5e8, .magic: dead4ead, .owner: <none>/-1=
, .owner_cpu: -1
[=A0 174.212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1
[=A0 174.212068] Call Trace:
[=A0 174.212068]=A0 [<????????>] ? do_raw_spin_lock+0x75/0x170
[=A0 174.212068]=A0 [<c???????>] ? scsi_kill_request.clone.13+0x59/0xb0
[=A0 174.212068]=A0 [<c1??????>] ? scsi_request_fn+0x30c/0x380
[=A0 174.212068]=A0 [<c12bb3d4>] ? scsi_request_fn+0x84/0x380
[=A0 174.212068]=A0 [<????????>] ? blk_run_queue+0x28/0x40
[=A0 174.212068]=A0 [<c12b9fd1>] ? scsi_run_queue+0xb1/0x230
[=A0 174.212068]=A0 [<c12b????>] ? scsi_next_command+0x30/0x50
[=A0 174.212068]=A0 [<c12bbb??>] ? scsi_io_completion+0x148/0x550
[=A0 174.212068]=A0 [<????????>] ? blk_done_softirq+0x52/0x60
[=A0 174.212068]=A0 [<c103bd475] ? __do_softirq+0x54/0xf0
[=A0 174.212068]=A0 [<c1025c07>] ? __wake_up_common+0x47/0x70
[=A0 174.212068]=A0 [<c103be67>] ? run_ksoftirqd+0xa7/0x130
[=A0 174.212068]=A0 [<c103bdc0>] ? __do_softirq+0xf0/0xf0
[=A0 174.212068]=A0 [<c104e284>] ? kthread+0x74/0x80
[=A0 174.212068]=A0 [<c104e210>] ? __init_kthread_worker+0x30/0x30
[=A0 174.212068]=A0 [<c1419f76>] ? kernel_thread_helper+0x6/0xd
[=A0 174.212068] BUG: spinlock lockup on CPU#0, ksoftirqd/0/3, f55dc5e8
[=A0 174.212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1
[=A0 174.212068] Call Trace:
[=A0 174.212068]=A0 [<c1208647>] ? do_raw_spin_lock+0x157/0x170
[=A0 174.212068]=A0 [<c12bb328>] ? scsi_kill_request.clone.13+0x88/0xb0
[=A0 174.212068]=A0 [<c12bb65c>] ? scsi_request_fn+0x30c/0x380
[=A0 174.212068]=A0 [<c12bb3d4>] ? scsi_request_fn+0x84/0x380
[=A0 174.212068]=A0 [<c11eee28>] ? blk_run_queue+0x28/0x40
[=A0 174.212068]=A0 [<c12b9fd1>] ? scsi_run_queue+0xb1/0x230
[=A0 174.212068]=A0 [<c12bb9a0>] ? scsi_next_command+0x30/0x50
[=A0 174.212068]=A0 [<c12bbb48>] ? scsi_io_completion+0x148/0x550
[=A0 174.212068]=A0 [<c11f5362>] ? blk_done_softirq+0x52/0x60
[=A0 174.212068]=A0 [<c103bd45>] ? __do_softirq+0x75/0xf0
[=A0 174.212068]=A0 [<c1025c07>] ? __wake_up_common+0x47/0x70
[=A0 174.212068]=A0 [<c103be67>] ? run_ksoftirqd+0xa7/0x130
[=A0 174.212068]=A0 [<c103bdc0>] ? __do_softirq+0xf0/0xf0
[=A0 174.212068]=A0 [<c104e284>] ? kthread+0x74/0x80
[=A0 174.212068]=A0 [<c104e210>] ? __init_kthread_worker+0x30/0x30
[=A0 174.212068]=A0 [<c1419f76>] ? kernel_thread_helper+0x6/0xd

ver_linux output:
=A0 (note ---=A0=A0 the 4 CPUs are 2 cores each with SMT enabled)
=A0 (note=A0 -- relevant scsi and usb mass-stg drivers are builtin)
=A0
Linux lumbyont.localdomain 2.6.39-vnla #1 SMP Tue May 31 13:55:29 EDT 2=
011 i686 GNU/Linux
=A0
Gnu C=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.5.3
Gnu make=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.81
binutils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.21
util-linux=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.13-pre7
mount=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 support
module-init-tools=A0=A0=A0=A0=A0 3.3-pre1
e2fsprogs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.41.13
pcmciautils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 014
quota-tools=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.13.
PPP=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.4.4
isdn4k-utils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.9
Linux C Library=A0=A0=A0=A0=A0=A0=A0 2.11.1
Dynamic linker (ldd)=A0=A0 2.11.1
Procps=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.2.7
Net-tools=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.60
Kbd=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.12
oprofile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.9.7git
Sh-utils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 8.9
udev=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 095
wireless-tools=A0=A0=A0=A0=A0=A0=A0=A0 29
Modules Loaded=A0=A0=A0=A0=A0=A0=A0=A0 snd_hda_intel snd_hda_codec rtc_=
cmos rtc_core rtc_lib bridge stp llc i915 drm_kms_helper intel_agp inte=
l_gtt tun xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 =
nf_conntrack nf_defrag_ipv4 dm_mod parport_pc lp parport
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0 /proc/cpuinfo =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
processor=A0=A0=A0 : 0
vendor_id=A0=A0=A0 : GenuineIntel
cpu family=A0=A0=A0 : 6
model=A0=A0=A0 =A0=A0=A0 : 28
model name=A0=A0=A0 : Intel(R) Atom(TM) CPU=A0 330=A0=A0 @ 1.60GHz
stepping=A0=A0=A0 : 2
cpu MHz=A0=A0=A0 =A0=A0=A0 : 1596.167
cache size=A0=A0=A0 : 512 KB
physical id=A0=A0=A0 : 0
siblings=A0=A0=A0 : 4
core id=A0=A0=A0 =A0=A0=A0 : 0
cpu cores=A0=A0=A0 : 2
apicid=A0=A0=A0 =A0=A0=A0 : 0
initial apicid=A0=A0=A0 : 0
fdiv_bug=A0=A0=A0 : no
hlt_bug=A0=A0=A0 =A0=A0=A0 : no
f00f_bug=A0=A0=A0 : no
coma_bug=A0=A0=A0 : no
fpu=A0=A0=A0 =A0=A0=A0 : yes
fpu_exception=A0=A0=A0 : yes
cpuid level=A0=A0=A0 : 10
wp=A0=A0=A0 =A0=A0=A0 : yes
flags=A0=A0=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep =
mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe n=
x lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor d=
s_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips=A0=A0=A0 : 3192.33
clflush size=A0=A0=A0 : 64
cache_alignment=A0=A0=A0 : 64
address sizes=A0=A0=A0 : 32 bits physical, 48 bits virtual
power management:

processor=A0=A0=A0 : 1
vendor_id=A0=A0=A0 : GenuineIntel
cpu family=A0=A0=A0 : 6
model=A0=A0=A0 =A0=A0=A0 : 28
model name=A0=A0=A0 : Intel(R) Atom(TM) CPU=A0 330=A0=A0 @ 1.60GHz
stepping=A0=A0=A0 : 2
cpu MHz=A0=A0=A0 =A0=A0=A0 : 1596.167
cache size=A0=A0=A0 : 512 KB
physical id=A0=A0=A0 : 0
siblings=A0=A0=A0 : 4
core id=A0=A0=A0 =A0=A0=A0 : 1
cpu cores=A0=A0=A0 : 2
apicid=A0=A0=A0 =A0=A0=A0 : 2
initial apicid=A0=A0=A0 : 2
fdiv_bug=A0=A0=A0 : no
hlt_bug=A0=A0=A0 =A0=A0=A0 : no
f00f_bug=A0=A0=A0 : no
coma_bug=A0=A0=A0 : no
fpu=A0=A0=A0 =A0=A0=A0 : yes
fpu_exception=A0=A0=A0 : yes
cpuid level=A0=A0=A0 : 10
wp=A0=A0=A0 =A0=A0=A0 : yes
flags=A0=A0=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep =
mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe n=
x lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor d=
s_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips=A0=A0=A0 : 3191.98
clflush size=A0=A0=A0 : 64
cache_alignment=A0=A0=A0 : 64
address sizes=A0=A0=A0 : 32 bits physical, 48 bits virtual
power management:

processor=A0=A0=A0 : 2
vendor_id=A0=A0=A0 : GenuineIntel
cpu family=A0=A0=A0 : 6
model=A0=A0=A0 =A0=A0=A0 : 28
model name=A0=A0=A0 : Intel(R) Atom(TM) CPU=A0 330=A0=A0 @ 1.60GHz
stepping=A0=A0=A0 : 2
cpu MHz=A0=A0=A0 =A0=A0=A0 : 1596.167
cache size=A0=A0=A0 : 512 KB
physical id=A0=A0=A0 : 0
siblings=A0=A0=A0 : 4
core id=A0=A0=A0 =A0=A0=A0 : 0
cpu cores=A0=A0=A0 : 2
apicid=A0=A0=A0 =A0=A0=A0 : 1
initial apicid=A0=A0=A0 : 1
fdiv_bug=A0=A0=A0 : no
hlt_bug=A0=A0=A0 =A0=A0=A0 : no
f00f_bug=A0=A0=A0 : no
coma_bug=A0=A0=A0 : no
fpu=A0=A0=A0 =A0=A0=A0 : yes
fpu_exception=A0=A0=A0 : yes
cpuid level=A0=A0=A0 : 10
wp=A0=A0=A0 =A0=A0=A0 : yes
flags=A0=A0=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep =
mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe n=
x lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor d=
s_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips=A0=A0=A0 : 3191.95
clflush size=A0=A0=A0 : 64
cache_alignment=A0=A0=A0 : 64
address sizes=A0=A0=A0 : 32 bits physical, 48 bits virtual
power management:

processor=A0=A0=A0 : 3
vendor_id=A0=A0=A0 : GenuineIntel
cpu family=A0=A0=A0 : 6
model=A0=A0=A0 =A0=A0=A0 : 28
model name=A0=A0=A0 : Intel(R) Atom(TM) CPU=A0 330=A0=A0 @ 1.60GHz
stepping=A0=A0=A0 : 2
cpu MHz=A0=A0=A0 =A0=A0=A0 : 1596.167
cache size=A0=A0=A0 : 512 KB
physical id=A0=A0=A0 : 0
siblings=A0=A0=A0 : 4
core id=A0=A0=A0 =A0=A0=A0 : 1
cpu cores=A0=A0=A0 : 2
apicid=A0=A0=A0 =A0=A0=A0 : 3
initial apicid=A0=A0=A0 : 3
fdiv_bug=A0=A0=A0 : no
hlt_bug=A0=A0=A0 =A0=A0=A0 : no
f00f_bug=A0=A0=A0 : no
coma_bug=A0=A0=A0 : no
fpu=A0=A0=A0 =A0=A0=A0 : yes
fpu_exception=A0=A0=A0 : yes
cpuid level=A0=A0=A0 : 10
wp=A0=A0=A0 =A0=A0=A0 : yes
flags=A0=A0=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep =
mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe n=
x lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor d=
s_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips=A0=A0=A0 : 3191.85
clflush size=A0=A0=A0 : 64
cache_alignment=A0=A0=A0 : 64
address sizes=A0=A0=A0 : 32 bits physical, 48 bits virtual
power management:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0 /proc/modules =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
snd_hda_intel 17288 0 - Live 0xf81e5000
snd_hda_codec 49964 1 snd_hda_intel, Live 0xf81ca000
rtc_cmos 6500 0 - Live 0xf8151000
rtc_core 13963 1 rtc_cmos, Live 0xf814b000
rtc_lib 1765 1 rtc_core, Live 0xf80d0000
bridge 56404 0 - Live 0xf80b9000
stp 1136 1 bridge, Live 0xf80b3000
llc 2864 2 bridge,stp, Live 0xf8005000
i915 297997 1 - Live 0xf80e5000
drm_kms_helper 24000 1 i915, Live 0xf80d8000
intel_agp 8367 1 i915, Live 0xf8c10000
intel_gtt 11161 3 i915,intel_agp, Live 0xf8bd7000
tun 12525 1 - Live 0xf8b98000
xt_state 867 26 - Live 0xf8b44000
ipt_MASQUERADE 1358 1 - Live 0xf8ae6000
iptable_nat 3543 1 - Live 0xf8aa6000
nf_nat 11151 2 ipt_MASQUERADE,iptable_nat, Live 0xf8a3a000
nf_conntrack_ipv4 8405 29 iptable_nat,nf_nat, Live 0xf8910000
nf_conntrack 40997 5 xt_state,ipt_MASQUERADE,iptable_nat,nf_nat,nf_conn=
track_ipv4, Live 0xf8868000
nf_defrag_ipv4 887 1 nf_conntrack_ipv4, Live 0xf8696000
dm_mod 52766 0 - Live 0xf8350000
parport_pc 17355 1 - Live 0xf81de000
lp 6716 0 - Live 0xf802b000
parport 24631 2 parport_pc,lp, Live 0xf8159000
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0 /proc/ioports =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
0000-0cf7 : PCI Bus 0000:00
=A0 0000-001f : dma1
=A0 0020-0021 : pic1
=A0 0040-0043 : timer0
=A0 0050-0053 : timer1
=A0 0060-0060 : keyboard
=A0 0064-0064 : keyboard
=A0 0070-0071 : rtc0
=A0 0080-008f : dma page reg
=A0 00a0-00a1 : pic2
=A0 00c0-00df : dma2
=A0 00f0-00ff : fpu
=A0 0170-0177 : 0000:00:1f.1
=A0=A0=A0 0170-0177 : piix
=A0 01f0-01f7 : 0000:00:1f.1
=A0=A0=A0 01f0-01f7 : piix
=A0 0376-0376 : 0000:00:1f.1
=A0=A0=A0 0376-0376 : piix
=A0 0378-037a : parport0
=A0 037b-037f : parport0
=A0 03c0-03df : vga+
=A0 03f6-03f6 : 0000:00:1f.1
=A0=A0=A0 03f6-03f6 : piix
=A0 03f8-03ff : serial
=A0 0400-047f : pnp 00:06
=A0=A0=A0 0400-0403 : ACPI PM1a_EVT_BLK
=A0=A0=A0 0404-0405 : ACPI PM1a_CNT_BLK
=A0=A0=A0 0408-040b : ACPI PM_TMR
=A0=A0=A0 0410-0415 : ACPI CPU throttle
=A0=A0=A0 0420-0420 : ACPI PM2_CNT_BLK
=A0=A0=A0 0428-042f : ACPI GPE0_BLK
=A0 0500-053f : pnp 00:06
=A0 0680-06ff : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
=A0 1000-1fff : PCI Bus 0000:04
=A0=A0=A0 1000-10ff : 0000:04:00.0
=A0 2000-2fff : PCI Bus 0000:01
=A0=A0=A0 2000-20ff : 0000:01:00.0
=A0 3000-301f : 0000:00:1f.3
=A0=A0=A0 3000-301f : i801_smbus
=A0 3020-303f : 0000:00:1d.3
=A0 3040-305f : 0000:00:1d.2
=A0 3060-307f : 0000:00:1d.1
=A0 3080-309f : 0000:00:1d.0
=A0 30a0-30af : 0000:00:1f.2
=A0=A0=A0 30a0-30af : ata_piix
=A0 30b0-30bf : 0000:00:1f.1
=A0=A0=A0 30b0-30bf : piix
=A0 30c0-30c7 : 0000:00:1f.2
=A0=A0=A0 30c0-30c7 : ata_piix
=A0 30c8-30cf : 0000:00:1f.2
=A0=A0=A0 30c8-30cf : ata_piix
=A0 30e0-30e7 : 0000:00:02.0
=A0 30e8-30eb : 0000:00:1f.2
=A0=A0=A0 30e8-30eb : ata_piix
=A0 30ec-30ef : 0000:00:1f.2
=A0=A0=A0 30ec-30ef : ata_piix
=A0 4000-4fff : PCI Bus 0000:03
=A0 5000-5fff : PCI Bus 0000:02
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0 /proc/iomem =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
00000000-0000ffff : reserved
00010000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
=A0 000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cb000-000cbfff : Adapter ROM
000e0000-000fffff : reserved
=A0 000e0000-000effff : PCI Bus 0000:00
=A0 000f0000-000fffff : System ROM
00100000-7f531fff : System RAM
=A0 01000000-0141a980 : Kernel code
=A0 0141a981-0159cabf : Kernel data
=A0 0160d000-0166cfff : Kernel bss
7f532000-7f539fff : reserved
7f53a000-7f5cafff : System RAM
7f5cb000-7f5cefff : reserved
7f5cf000-7f65ffff : System RAM
7f660000-7f6effff : ACPI Non-volatile Storage
7f6f0000-7f6f1fff : System RAM
7f6f2000-7f6fefff : ACPI Tables
7f6ff000-7f6fffff : System RAM
7f700000-7fffffff : reserved
80000000-ffffffff : reserved
=A0 80000000-f0000000 : PCI Bus 0000:00
=A0=A0=A0 80000000-8fffffff : 0000:00:02.0
=A0=A0=A0 90000000-900fffff : PCI Bus 0000:01
=A0=A0=A0=A0=A0 90000000-9000ffff : 0000:01:00.0
=A0=A0=A0=A0=A0 90020000-9003ffff : 0000:01:00.0
=A0=A0=A0 90100000-901fffff : PCI Bus 0000:04
=A0=A0=A0=A0=A0 90100000-901000ff : 0000:04:00.0
=A0=A0=A0 90200000-902fffff : PCI Bus 0000:01
=A0=A0=A0=A0=A0 90200000-90200fff : 0000:01:00.0
=A0=A0=A0 90300000-9037ffff : 0000:00:02.0
=A0=A0=A0 90380000-903bffff : 0000:00:02.0
=A0=A0=A0 903c0000-903c3fff : 0000:00:1b.0
=A0=A0=A0=A0=A0 903c0000-903c3fff : ICH HD audio
=A0=A0=A0 903c4000-903c43ff : 0000:00:1d.7
=A0=A0=A0=A0=A0 903c4000-903c43ff : ehci_hcd
=A0=A0=A0 90400000-904fffff : PCI Bus 0000:04
=A0=A0=A0=A0=A0 90400000-9040ffff : 0000:04:00.0
=A0=A0=A0 90500000-906fffff : PCI Bus 0000:03
=A0=A0=A0 90700000-908fffff : PCI Bus 0000:03
=A0=A0=A0 90900000-90afffff : PCI Bus 0000:02
=A0=A0=A0 90b00000-90cfffff : PCI Bus 0000:02
=A0 f8000000-febfffff : PCI Bus 0000:00
=A0 fec00000-fec003ff : IOAPIC 0
=A0 fed00000-fed003ff : HPET 0
=A0 fed13000-fed13fff : pnp 00:01
=A0 fed14000-fed17fff : pnp 00:01
=A0 fed18000-fed18fff : pnp 00:01
=A0 fed19000-fed19fff : pnp 00:01
=A0 fed1c000-fed1ffff : pnp 00:01
=A0 fed20000-fed3ffff : pnp 00:01
=A0 fed45000-fed99fff : pnp 00:01
=A0 fee00000-fee00fff : Local APIC
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0 /proc/scsi/scsi =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
=A0 Vendor: ATA=A0=A0=A0=A0=A0 Model: WDC WD5000AAKS-6 Rev: 05.0
=A0 Type:=A0=A0 Direct-Access=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
=A0 Vendor: ATA=A0=A0=A0=A0=A0 Model: WDC WD5000AAKS-6 Rev: 05.0
=A0 Type:=A0=A0 Direct-Access=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05


 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
