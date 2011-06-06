From: John Lumby <johnlumby@hotmail.com>
Subject: PROBLEM:  spinlock errors and system dies on 2.6.39
Date: Mon, 6 Jun 2011 15:14:21 -0400
Message-ID: <COL116-W57B0B4B5EC9D6478705870A3600@phx.gbl>
References: <COL116-W5CAEF822D4FC5E9AF152CA3600@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from col0-omc4-s8.col0.hotmail.com ([65.55.34.210]:41728 "EHLO
	col0-omc4-s8.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757838Ab1FFTUb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2011 15:20:31 -0400
In-Reply-To: <COL116-W5CAEF822D4FC5E9AF152CA3600@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de


(also posted to linux-kernel =A0:: =A0the first error message is from s=
csi, =A0so posting to scsi as well.)
PROBLEM: spinlock errors and system dies on 2.6.39 when I plug in my Ki=
ngston Data Traveller USB mass storage device.
On 2.6.39 (built from source using GCC 4.5.3), when I insert the stick,=
 the kernel displays BUG reports to the console and the system becomes =
unavailable. I managed to gather to relevant console messages from a se=
rial console, attached below.
I noticed one thing: I have console timestamping enabled. The bug alway=
s happens with this enabled.But if I turn off the console timestamping =
with printk.time=3D0, it very occasionally does not happen (scsi device=
 comes up as expected). So it may be a timing problem.
The bug never happens on 2.6.38.4
console messages: (I had to paste some information as the serial consol=
e garbled some pieces of some lines - some addresses and offsets may be=
 incorrect but the sequence is correct)
[ 174.192721] scsi 2:0:0:0: Direct-Access Kingston DataTraveler G3 1.00=
 PQ: 0 ANSI: 2[ 174.210226] scsi: killing requests for dead queue[ 174.=
212068] BUG: spinlock already unlocked on CPU#0, ksoftirqd/0/3[ 174.212=
068] lock: f55dc5e8, .magic: dead4ead, .owner: /-1, .owner_cpu: -1[ 174=
=2E212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1[ 174.21=
2068] Call Trace:[ 174.212068] [] ? do_raw_spin_lock+0x75/0x170[ 174.21=
2068] [] ? scsi_kill_request.clone.13+0x59/0xb0[ 174.212068] [] ? scsi_=
request_fn+0x30c/0x380[ 174.212068] [] ? scsi_request_fn+0x84/0x380[ 17=
4.212068] [] ? blk_run_queue+0x28/0x40[ 174.212068] [] ? scsi_run_queue=
+0xb1/0x230[ 174.212068] [] ? scsi_next_command+0x30/0x50[ 174.212068] =
[] ? scsi_io_completion+0x148/0x550[ 174.212068] [] ? blk_done_softirq+=
0x52/0x60[ 174.212068] [[ 174.212068] [] ? __wake_up_common+0x47/0x70[ =
174.212068] [] ? run_ksoftirqd+0xa7/0x130[ 174.212068] [] ? __do_softir=
q+0xf0/0xf0[ 174.212068] [] ? kthread+0x74/0x80[ 174.212068] [] ? __ini=
t_kthread_worker+0x30/0x30[ 174.212068] [] ? kernel_thread_helper+0x6/0=
xd[ 174.212068] BUG: spinlock lockup on CPU#0, ksoftirqd/0/3, f55dc5e8[=
 174.212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1[ 174.=
212068] Call Trace:[ 174.212068] [] ? do_raw_spin_lock+0x157/0x170[ 174=
=2E212068] [] ? scsi_kill_request.clone.13+0x88/0xb0[ 174.212068] [] ? =
scsi_request_fn+0x30c/0x380[ 174.212068] [] ? scsi_request_fn+0x84/0x38=
0[ 174.212068] [] ? blk_run_queue+0x28/0x40[ 174.212068] [] ? scsi_run_=
queue+0xb1/0x230[ 174.212068] [] ? scsi_next_command+0x30/0x50[ 174.212=
068] [] ? scsi_io_completion+0x148/0x550[ 174.212068] [] ? blk_done_sof=
tirq+0x52/0x60[ 174.212068] [] ? __do_softirq+0x75/0xf0[ 174.212068] []=
 ? __wake_up_common+0x47/0x70[ 174.212068] [] ? run_ksoftirqd+0xa7/0x13=
0[ 174.212068] [] ? __do_softirq+0xf0/0xf0[ 174.212068] [] ? kthread+0x=
74/0x80[ 174.212068] [] ? __init_kthread_worker+0x30/0x30[ 174.212068] =
[] ? kernel_thread_helper+0x6/0xd
ver_linux output:(note --- the 4 CPUs are 2 cores each with SMT enabled=
)(note -- relevant scsi and usb mass-stg drivers are builtin)
Linux lumbyont.localdomain 2.6.39-vnla #1 SMP Tue May 31 13:55:29 EDT 2=
011 i686 GNU/Linux
Gnu C 4.5.3Gnu make 3.81binutils 2.21util-linux 2.13-pre7mount supportm=
odule-init-tools 3.3-pre1e2fsprogs 1.41.13pcmciautils 014quota-tools 3.=
13.PPP 2.4.4isdn4k-utils 3.9Linux C Library 2.11.1Dynamic linker (ldd) =
2.11.1Procps 3.2.7Net-tools 1.60Kbd 1.12oprofile 0.9.7gitSh-utils 8.9ud=
ev 095wireless-tools 29Modules Loaded snd_hda_intel snd_hda_codec rtc_c=
mos rtc_core rtc_lib bridge stp llc i915 drm_kms_helper intel_agp intel=
_gtt tun xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 n=
f_conntrack nf_defrag_ipv4 dm_mod parport_pc lp parport=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D /proc/cpuinfo =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
processor : 0vendor_id : GenuineIntelcpu family : 6model : 28model name=
 : Intel(R) Atom(TM) CPU 330 @ 1.60GHzstepping : 2cpu MHz : 1596.167cac=
he size : 512 KBphysical id : 0siblings : 4core id : 0cpu cores : 2apic=
id : 0initial apicid : 0fdiv_bug : nohlt_bug : nof00f_bug : nocoma_bug =
: nofpu : yesfpu_exception : yescpuid level : 10wp : yesflags : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts =
acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon peb=
s bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm mov=
be lahf_lm dtsbogomips : 3192.33clflush size : 64cache_alignment : 64ad=
dress sizes : 32 bits physical, 48 bits virtualpower management:
processor : 1vendor_id : GenuineIntelcpu family : 6model : 28model name=
 : Intel(R) Atom(TM) CPU 330 @ 1.60GHzstepping : 2cpu MHz : 1596.167cac=
he size : 512 KBphysical id : 0siblings : 4core id : 1cpu cores : 2apic=
id : 2initial apicid : 2fdiv_bug : nohlt_bug : nof00f_bug : nocoma_bug =
: nofpu : yesfpu_exception : yescpuid level : 10wp : yesflags : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts =
acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon peb=
s bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm mov=
be lahf_lm dtsbogomips : 3191.98clflush size : 64cache_alignment : 64ad=
dress sizes : 32 bits physical, 48 bits virtualpower management:
processor : 2vendor_id : GenuineIntelcpu family : 6model : 28model name=
 : Intel(R) Atom(TM) CPU 330 @ 1.60GHzstepping : 2cpu MHz : 1596.167cac=
he size : 512 KBphysical id : 0siblings : 4core id : 0cpu cores : 2apic=
id : 1initial apicid : 1fdiv_bug : nohlt_bug : nof00f_bug : nocoma_bug =
: nofpu : yesfpu_exception : yescpuid level : 10wp : yesflags : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts =
acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon peb=
s bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm mov=
be lahf_lm dtsbogomips : 3191.95clflush size : 64cache_alignment : 64ad=
dress sizes : 32 bits physical, 48 bits virtualpower management:
processor : 3vendor_id : GenuineIntelcpu family : 6model : 28model name=
 : Intel(R) Atom(TM) CPU 330 @ 1.60GHzstepping : 2cpu MHz : 1596.167cac=
he size : 512 KBphysical id : 0siblings : 4core id : 1cpu cores : 2apic=
id : 3initial apicid : 3fdiv_bug : nohlt_bug : nof00f_bug : nocoma_bug =
: nofpu : yesfpu_exception : yescpuid level : 10wp : yesflags : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts =
acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon peb=
s bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm mov=
be lahf_lm dtsbogomips : 3191.85clflush size : 64cache_alignment : 64ad=
dress sizes : 32 bits physical, 48 bits virtualpower management:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D /proc/modules =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3Dsnd_hda_intel 17288 0 - Live 0xf81e5000snd_hda_codec =
49964 1 snd_hda_intel, Live 0xf81ca000rtc_cmos 6500 0 - Live 0xf8151000=
rtc_core 13963 1 rtc_cmos, Live 0xf814b000rtc_lib 1765 1 rtc_core, Live=
 0xf80d0000bridge 56404 0 - Live 0xf80b9000stp 1136 1 bridge, Live 0xf8=
0b3000llc 2864 2 bridge,stp, Live 0xf8005000i915 297997 1 - Live 0xf80e=
5000drm_kms_helper 24000 1 i915, Live 0xf80d8000intel_agp 8367 1 i915, =
Live 0xf8c10000intel_gtt 11161 3 i915,intel_agp, Live 0xf8bd7000tun 125=
25 1 - Live 0xf8b98000xt_state 867 26 - Live 0xf8b44000ipt_MASQUERADE 1=
358 1 - Live 0xf8ae6000iptable_nat 3543 1 - Live 0xf8aa6000nf_nat 11151=
 2 ipt_MASQUERADE,iptable_nat, Live 0xf8a3a000nf_conntrack_ipv4 8405 29=
 iptable_nat,nf_nat, Live 0xf8910000nf_conntrack 40997 5 xt_state,ipt_M=
ASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf8868000nf_defra=
g_ipv4 887 1 nf_conntrack_ipv4, Live 0xf8696000dm_mod 52766 0 - Live 0x=
f8350000parport_pc 17355 1 - Live 0xf81de000lp 6716 0 - Live 0xf802b000=
parport 24631 2 parport_pc,lp, Live 0xf8159000=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D /proc/ioports =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D0000-0cf=
7 : PCI Bus 0000:000000-001f : dma10020-0021 : pic10040-0043 : timer000=
50-0053 : timer10060-0060 : keyboard0064-0064 : keyboard0070-0071 : rtc=
00080-008f : dma page reg00a0-00a1 : pic200c0-00df : dma200f0-00ff : fp=
u0170-0177 : 0000:00:1f.10170-0177 : piix01f0-01f7 : 0000:00:1f.101f0-0=
1f7 : piix0376-0376 : 0000:00:1f.10376-0376 : piix0378-037a : parport00=
37b-037f : parport003c0-03df : vga+03f6-03f6 : 0000:00:1f.103f6-03f6 : =
piix03f8-03ff : serial0400-047f : pnp 00:060400-0403 : ACPI PM1a_EVT_BL=
K0404-0405 : ACPI PM1a_CNT_BLK0408-040b : ACPI PM_TMR0410-0415 : ACPI C=
PU throttle0420-0420 : ACPI PM2_CNT_BLK0428-042f : ACPI GPE0_BLK0500-05=
3f : pnp 00:060680-06ff : pnp 00:060cf8-0cff : PCI conf10d00-ffff : PCI=
 Bus 0000:001000-1fff : PCI Bus 0000:041000-10ff : 0000:04:00.02000-2ff=
f : PCI Bus 0000:012000-20ff : 0000:01:00.03000-301f : 0000:00:1f.33000=
-301f : i801_smbus3020-303f : 0000:00:1d.33040-305f : 0000:00:1d.23060-=
307f : 0000:00:1d.13080-309f : 0000:00:1d.030a0-30af : 0000:00:1f.230a0=
-30af : ata_piix30b0-30bf : 0000:00:1f.130b0-30bf : piix30c0-30c7 : 000=
0:00:1f.230c0-30c7 : ata_piix30c8-30cf : 0000:00:1f.230c8-30cf : ata_pi=
ix30e0-30e7 : 0000:00:02.030e8-30eb : 0000:00:1f.230e8-30eb : ata_piix3=
0ec-30ef : 0000:00:1f.230ec-30ef : ata_piix4000-4fff : PCI Bus 0000:035=
000-5fff : PCI Bus 0000:02=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D /proc/io=
mem =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D00000000-0000ffff : reserved=
00010000-0008efff : System RAM0008f000-0009ffff : reserved000a0000-000b=
ffff : PCI Bus 0000:00000a0000-000bffff : Video RAM area000c0000-000c7f=
ff : Video ROM000cb000-000cbfff : Adapter ROM000e0000-000fffff : reserv=
ed000e0000-000effff : PCI Bus 0000:00000f0000-000fffff : System ROM0010=
0000-7f531fff : System RAM01000000-0141a980 : Kernel code0141a981-0159c=
abf : Kernel data0160d000-0166cfff : Kernel bss7f532000-7f539fff : rese=
rved7f53a000-7f5cafff : System RAM7f5cb000-7f5cefff : reserved7f5cf000-=
7f65ffff : System RAM7f660000-7f6effff : ACPI Non-volatile Storage7f6f0=
000-7f6f1fff : System RAM7f6f2000-7f6fefff : ACPI Tables7f6ff000-7f6fff=
ff : System RAM7f700000-7fffffff : reserved80000000-ffffffff : reserved=
80000000-f0000000 : PCI Bus 0000:0080000000-8fffffff : 0000:00:02.09000=
0000-900fffff : PCI Bus 0000:0190000000-9000ffff : 0000:01:00.090020000=
-9003ffff : 0000:01:00.090100000-901fffff : PCI Bus 0000:0490100000-901=
000ff : 0000:04:00.090200000-902fffff : PCI Bus 0000:0190200000-90200ff=
f : 0000:01:00.090300000-9037ffff : 0000:00:02.090380000-903bffff : 000=
0:00:02.0903c0000-903c3fff : 0000:00:1b.0903c0000-903c3fff : ICH HD aud=
io903c4000-903c43ff : 0000:00:1d.7903c4000-903c43ff : ehci_hcd90400000-=
904fffff : PCI Bus 0000:0490400000-9040ffff : 0000:04:00.090500000-906f=
ffff : PCI Bus 0000:0390700000-908fffff : PCI Bus 0000:0390900000-90aff=
fff : PCI Bus 0000:0290b00000-90cfffff : PCI Bus 0000:02f8000000-febfff=
ff : PCI Bus 0000:00fec00000-fec003ff : IOAPIC 0fed00000-fed003ff : HPE=
T 0fed13000-fed13fff : pnp 00:01fed14000-fed17fff : pnp 00:01fed18000-f=
ed18fff : pnp 00:01fed19000-fed19fff : pnp 00:01fed1c000-fed1ffff : pnp=
 00:01fed20000-fed3ffff : pnp 00:01fed45000-fed99fff : pnp 00:01fee0000=
0-fee00fff : Local APIC=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D /proc/scsi/=
scsi =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAttached devices:Host: scsi=
0 Channel: 00 Id: 00 Lun: 00Vendor: ATA Model: WDC WD5000AAKS-6 Rev: 05=
=2E0Type: Direct-Access ANSI SCSI revision: 05Host: scsi1 Channel: 00 I=
d: 00 Lun: 00Vendor: ATA Model: WDC WD5000AAKS-6 Rev: 05.0Type: Direct-=
Access ANSI SCSI revision: 05
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
