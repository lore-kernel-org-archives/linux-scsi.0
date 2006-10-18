From: Colin Keith <linux-scsi@ckeith.clara.net>
Subject: kernel oops with aacraid 1.1-5[2409]-mh1 under 2.6.17-1.2187_FC5
Date: Wed, 18 Oct 2006 17:33:57 +0100
Message-ID: <20061018163357.GG1243@dot.oreally.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dot.reactive-networks.net ([217.144.82.11]:41735 "EHLO
	dot.oreally.co.uk") by vger.kernel.org with ESMTP id S1422663AbWJRQd7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 12:33:59 -0400
Received: from colin by dot.oreally.co.uk with local (Exim 4.62)
	(envelope-from <linux-scsi@ckeith.clara.net>)
	id 1GaEMf-00014h-66
	for linux-scsi@vger.kernel.org; Wed, 18 Oct 2006 17:33:57 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've been having a major problem with a box containing an adaptec
ASR-2130SLP scsi raid card randomly crashing. As more users were added
to the box it has gotten worse to the point where the uptime could be
in the order of hours. I've managed to snag the kernel oops a couple of
times and a copy of one is provided below (it always crashes in the sam=
e
place).

I've seen one other person post this exact same oops output but I saw n=
o
responses. I've tried a number of different fixes including upgrading t=
o
the Fedora provided 2.6.18-1.2200 kernel which uses 1-1.5[2409]-mh2.  T=
his
has been running for 12 hours, but as the crashes are intermittent its =
hard
to know if this resolves it as yet, but I'm concerned that it won't. I'=
ve
tried various different kernels (including using the wonderful 2.6.17-1=
=2E2157
which thanks to the XFS bugs was secretly trashing my FS each time it
crashed and 2.6.17-1.2174 which stayed up 5 minutes before triggering t=
his
bug).

I grabbed the 1-1.5.2429 drivers from adaptec's site, but they don't ha=
ve
any pre-compiled binaries for 2.6.18-1.2200 or 2.6.17-1.2187. I tried t=
o
compile the module from source but I must have messed it up because whe=
n it
booted the 2.6.18 kernel it loaded the modules in the initrd with the 2=
429
driver and panic'd with the message "corrupt module" (or something, I l=
ost
the text before I could copy it) I'd copied the source into the 2.6.18
build tree (from the 2.6.18-1.2200 source RPM) and reran "make modules"=
 to
rebuild it. modinfo suggested it was valid but apparently it wasn't.

Also the firmware I'm using is 4.2-0[7348]. I believe that b9194 is new=
er
firmware for these cards, but I wasn't sure if it still had the same
problem with the "drive is too small" as the beta firmware released pri=
or
to it.


Any and all tips / suggestions to resolve this are greatly appreciated.
Especially if you have the same hardware and resolved this problem.  If=
 the
bug report is wrong, please let me know what's missing. I did try to fo=
llow
the many suggestions on how to track down a bug from a kernel oops and =
I
see where it occurs, but I don't know why or what to do to fix it.

Regards,
Colin Keith


---- kernel oops output:


Kernel BUG at include/linux/list.h:180
invalid opcode: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:00.0/class
CPU 0
Modules linked in: w83627hf hwmon_vid hwmon i2c_isa ipv6 ip_conntrack_f=
tp ipt_owner ipt_LOG xt_limit ipt_REJECT xt_tcpudp xt_state ip_conntrac=
k nfnetlink iptable_filter ip_tables x_d
Pid: 0, comm: swapper Not tainted 2.6.17-1.2187_FC5 #1
RIP: 0010:[<ffffffff8804996d>] <ffffffff8804996d>{:aacraid:aac_intr_nor=
mal+473}
RSP: 0018:ffffffff80603ec8  EFLAGS: 00010082
RAX: 0000000000000054 RBX: ffff810275723f08 RCX: ffffffff80549a98
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff80549a80
RBP: ffff810275723e88 R08: ffffffff80549a98 R09: ffffffff80603c18
R10: 0000000000000006 R11: 0000000000000000 R12: ffff81007ff2b800
R13: 000000000000015d R14: ffff81027563cda0 R15: ffffffff806c9ef8
=46S:  00002aaaaad6d800(0000) GS:ffffffff8069e000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000e6d620 CR3: 000000045d0fa000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffffffff806c8000, task ffffffff8054=
2dc0)
Stack: 0000000000000282 000000000000015d ffff81027563cda0 0000000000000=
000
       00000000000000d9 ffffffff806c9ef8 ffffffff806c9ef8 ffffffff8804a=
a78
       ffffffff80544a20 ffff810275fbe740
Call Trace: <IRQ> <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55}
       <ffffffff80210809>{handle_IRQ_event+41} <ffffffff802b2c73>{__do_=
IRQ+154}
       <ffffffff802713c6>{do_IRQ+60} <ffffffff8026fde3>{default_idle+0}
       <ffffffff80262eea>{ret_from_intr+0} <EOI> <ffffffff8026fde3>{def=
ault_idle+0}
       <ffffffff802677b6>{thread_return+0} <ffffffff8026fe0e>{default_i=
dle+43}
       <ffffffff8024c7b7>{cpu_idle+151} <ffffffff806cb817>{start_kernel=
+502}
       <ffffffff806cb28a>{_sinittext+650}

Code: 0f 0b 68 64 c3 04 88 c2 b4 00 48 8b 85 80 00 00 00 48 8b 50
RIP <ffffffff8804996d>{:aacraid:aac_intr_normal+473} RSP <ffffffff80603=
ec8>
 <3>BUG: sleeping function called from invalid context at include/linux=
/rwsem.h:43
in_atomic():1, irqs_disabled():1

Call Trace: <IRQ> <ffffffff80299774>{blocking_notifier_call_chain+31}
       <ffffffff80215bf6>{do_exit+32} <ffffffff8027071f>{kernel_math_er=
ror+0}
       <ffffffff80270cbc>{do_invalid_op+173} <ffffffff8804996d>{:aacrai=
d:aac_intr_normal+473}
       <ffffffff80290543>{printk+82} <ffffffff802638a5>{error_exit+0}
       <ffffffff8804996d>{:aacraid:aac_intr_normal+473} <ffffffff880499=
6d>{:aacraid:aac_intr_normal+473}
       <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55} <ffffffff80210809>{=
handle_IRQ_event+41}
       <ffffffff802b2c73>{__do_IRQ+154} <ffffffff802713c6>{do_IRQ+60}
       <ffffffff8026fde3>{default_idle+0} <ffffffff80262eea>{ret_from_i=
ntr+0} <EOI>
       <ffffffff8026fde3>{default_idle+0} <ffffffff802677b6>{thread_ret=
urn+0}
       <ffffffff8026fe0e>{default_idle+43} <ffffffff8024c7b7>{cpu_idle+=
151}
       <ffffffff806cb817>{start_kernel+502} <ffffffff806cb28a>{_sinitte=
xt+650}
Kernel panic - not syncing: Aiee, killing interrupt handler!
 BUG: warning at kernel/panic.c:137/panic() (Not tainted)

Call Trace: <IRQ> <ffffffff8028fcd2>{panic+483} <ffffffff80269d4e>{_spi=
n_unlock_irq+12}
       <ffffffff80269711>{__down_read+60} <ffffffff80269d8e>{_spin_lock=
_irqsave+9}
       <ffffffff80222cba>{__up_read+25} <ffffffff8029979b>{blocking_not=
ifier_call_chain+70}
       <ffffffff80215c63>{do_exit+141} <ffffffff8027071f>{kernel_math_e=
rror+0}
       <ffffffff80270cbc>{do_invalid_op+173} <ffffffff8804996d>{:aacrai=
d:aac_intr_normal+473}
       <ffffffff80290543>{printk+82} <ffffffff802638a5>{error_exit+0}
       <ffffffff8804996d>{:aacraid:aac_intr_normal+473} <ffffffff880499=
6d>{:aacraid:aac_intr_normal+473}
       <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55} <ffffffff80210809>{=
handle_IRQ_event+41}
       <ffffffff802b2c73>{__do_IRQ+154} <ffffffff802713c6>{do_IRQ+60}
       <ffffffff8026fde3>{default_idle+0} <ffffffff80262eea>{ret_from_i=
ntr+0} <EOI>
       <ffffffff8026fde3>{default_idle+0} <ffffffff802677b6>{thread_ret=
urn+0}
       <ffffffff8026fe0e>{default_idle+43} <ffffffff8024c7b7>{cpu_idle+=
151}
       <ffffffff806cb817>{start_kernel+502} <ffffffff806cb28a>{_sinitte=
xt+650}

-----------------------------------------------------------------------=
-----

 This is the relevant text for this error message in the kernel docs:

    If you see a sleeping function called from invalid context
    warning message, then maybe you called a sleeping allocation functi=
on
    from interrupt context without GFP_ATOMIC.  You should really fix t=
hat.
    Run, don't walk.


-----------------------------------------------------------------------=
-----

apollo# ./ksymoops -k /proc/kallsyms -m /boot/System.map-2.6.17-1.2187_=
=46C5 -o /usr/src/debug/kernel-2.6.17/linux-2.6.17.x86_64/  < x
ksymoops 2.4.11 on x86_64 2.6.17-1.2187_FC5.  Options used
     -V (default)
     -k /proc/kallsyms (specified)
     -l /proc/modules (default)
     -o /usr/src/debug/kernel-2.6.17/linux-2.6.17.x86_64/ (specified)
     -m /boot/System.map-2.6.17-1.2187_FC5 (specified)

Warning (read_ksyms): no kernel symbols in ksyms, is /proc/kallsyms a v=
alid ksyms file?
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Kernel BUG at include/linux/list.h:180
CPU 0
Pid: 0, comm: swapper Not tainted 2.6.17-1.2187_FC5 #1
RIP: 0010:[<ffffffff8804996d>] <ffffffff8804996d>{:aacraid:aac_intr_nor=
mal+473}
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
RSP: 0018:ffffffff80603ec8  EFLAGS: 00010082
RAX: 0000000000000054 RBX: ffff810275723f08 RCX: ffffffff80549a98
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff80549a80
RBP: ffff810275723e88 R08: ffffffff80549a98 R09: ffffffff80603c18
R10: 0000000000000006 R11: 0000000000000000 R12: ffff81007ff2b800
R13: 000000000000015d R14: ffff81027563cda0 R15: ffffffff806c9ef8
=46S:  00002aaaaad6d800(0000) GS:ffffffff8069e000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000e6d620 CR3: 000000045d0fa000 CR4: 00000000000006e0
Stack: 0000000000000282 000000000000015d ffff81027563cda0 0000000000000=
000
       00000000000000d9 ffffffff806c9ef8 ffffffff806c9ef8 ffffffff8804a=
a78
       ffffffff80544a20 ffff810275fbe740
Call Trace: <IRQ> <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55}
       <ffffffff80210809>{handle_IRQ_event+41} <ffffffff802b2c73>{__do_=
IRQ+154}
       <ffffffff802713c6>{do_IRQ+60} <ffffffff8026fde3>{default_idle+0}
       <ffffffff80262eea>{ret_from_intr+0} <EOI> <ffffffff8026fde3>{def=
ault_idle+0}
       <ffffffff802677b6>{thread_return+0} <ffffffff8026fe0e>{default_i=
dle+43}
       <ffffffff8024c7b7>{cpu_idle+151} <ffffffff806cb817>{start_kernel=
+502}
       <ffffffff806cb28a>{_sinittext+650}
Code: 0f 0b 68 64 c3 04 88 c2 b4 00 48 8b 85 80 00 00 00 48 8b 50


>>RIP; ffffffff8804996d <_end+794496d/7eefb000>   <=3D=3D=3D=3D=3D

>>RBX; ffff810275723f08 <phys_startup_64+ffff810275523e08/ffffffff7ffff=
f00>
>>RCX; ffffffff80549a98 <log_wait+18/30>
>>RDI; ffffffff80549a80 <log_wait+0/30>
>>RBP; ffff810275723e88 <phys_startup_64+ffff810275523d88/ffffffff7ffff=
f00>
>>R08; ffffffff80549a98 <log_wait+18/30>
>>R09; ffffffff80603c18 <boot_cpu_stack+3c18/4000>
>>R12; ffff81007ff2b800 <phys_startup_64+ffff81007fd2b700/ffffffff7ffff=
f00>
>>R14; ffff81027563cda0 <phys_startup_64+ffff81027543cca0/ffffffff7ffff=
f00>
>>R15; ffffffff806c9ef8 <init_thread_union+1ef8/2000>

Trace; ffffffff80210809 <handle_IRQ_event+29/5a>
Trace; ffffffff802713c6 <do_IRQ+3c/4a>
Trace; ffffffff80262eea <ret_from_intr+0/12>
Trace; ffffffff802677b6 <thread_return+0/e0>
Trace; ffffffff8024c7b7 <cpu_idle+97/ba>
Trace; ffffffff806cb28a <x86_64_start_kernel+28a/28e>

Code;  ffffffff8804996d <_end+794496d/7eefb000>
0000000000000000 <_RIP>:
Code;  ffffffff8804996d <_end+794496d/7eefb000>   <=3D=3D=3D=3D=3D
   0:   0f 0b                     ud2a      <=3D=3D=3D=3D=3D
Code;  ffffffff8804996f <_end+794496f/7eefb000>
   2:   68 64 c3 04 88            pushq  $0xffffffff8804c364
Code;  ffffffff88049974 <_end+7944974/7eefb000>
   7:   c2 b4 00                  retq   $0xb4
Code;  ffffffff88049977 <_end+7944977/7eefb000>
   a:   48 8b 85 80 00 00 00      mov    0x80(%rbp),%rax
Code;  ffffffff8804997e <_end+794497e/7eefb000>
  11:   48 8b 50 00               mov    0x0(%rax),%rdx

Call Trace: <IRQ> <ffffffff80299774>{blocking_notifier_call_chain+31}
       <ffffffff80215bf6>{do_exit+32} <ffffffff8027071f>{kernel_math_er=
ror+0}
       <ffffffff80270cbc>{do_invalid_op+173} <ffffffff8804996d>{:aacrai=
d:aac_intr_normal+473}
       <ffffffff80290543>{printk+82} <ffffffff802638a5>{error_exit+0}
       <ffffffff8804996d>{:aacraid:aac_intr_normal+473} <ffffffff880499=
6d>{:aacraid:aac_intr_normal+473}
       <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55} <ffffffff80210809>{=
handle_IRQ_event+41}
       <ffffffff802b2c73>{__do_IRQ+154} <ffffffff802713c6>{do_IRQ+60}
       <ffffffff8026fde3>{default_idle+0} <ffffffff80262eea>{ret_from_i=
ntr+0} <EOI>
       <ffffffff8026fde3>{default_idle+0} <ffffffff802677b6>{thread_ret=
urn+0}
       <ffffffff8026fe0e>{default_idle+43} <ffffffff8024c7b7>{cpu_idle+=
151}
       <ffffffff806cb817>{start_kernel+502} <ffffffff806cb28a>{_sinitte=
xt+650}
Kernel panic - not syncing: Aiee, killing interrupt handler!
Call Trace: <IRQ> <ffffffff8028fcd2>{panic+483} <ffffffff80269d4e>{_spi=
n_unlock_irq+12}
       <ffffffff80269711>{__down_read+60} <ffffffff80269d8e>{_spin_lock=
_irqsave+9}
       <ffffffff80222cba>{__up_read+25} <ffffffff8029979b>{blocking_not=
ifier_call_chain+70}
       <ffffffff80215c63>{do_exit+141} <ffffffff8027071f>{kernel_math_e=
rror+0}
       <ffffffff80270cbc>{do_invalid_op+173} <ffffffff8804996d>{:aacrai=
d:aac_intr_normal+473}
       <ffffffff80290543>{printk+82} <ffffffff802638a5>{error_exit+0}
       <ffffffff8804996d>{:aacraid:aac_intr_normal+473} <ffffffff880499=
6d>{:aacraid:aac_intr_normal+473}
       <ffffffff8804aa78>{:aacraid:aac_rkt_intr+55} <ffffffff80210809>{=
handle_IRQ_event+41}
       <ffffffff802b2c73>{__do_IRQ+154} <ffffffff802713c6>{do_IRQ+60}
       <ffffffff8026fde3>{default_idle+0} <ffffffff80262eea>{ret_from_i=
ntr+0} <EOI>
       <ffffffff8026fde3>{default_idle+0} <ffffffff802677b6>{thread_ret=
urn+0}
       <ffffffff8026fe0e>{default_idle+43} <ffffffff8024c7b7>{cpu_idle+=
151}
       <ffffffff806cb817>{start_kernel+502} <ffffffff806cb28a>{_sinitte=
xt+650}
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff80215bf6 <do_exit+20/8f3>
Trace; ffffffff80270cbc <do_invalid_op+ad/b7>
Trace; ffffffff80290543 <printk+52/c9>
Trace; ffffffff8804996d <_end+794496d/7eefb000>
Trace; ffffffff8804aa78 <_end+7945a78/7eefb000>
Trace; ffffffff802b2c73 <__do_IRQ+9a/f4>
Trace; ffffffff8026fde3 <default_idle+0/54>
Trace; ffffffff8026fde3 <default_idle+0/54>
Trace; ffffffff8026fe0e <default_idle+2b/54>
Trace; ffffffff806cb817 <start_kernel+1f6/1fb>
Trace; ffffffff80269711 <__down_read+3c/d4>
Trace; ffffffff80222cba <__up_read+19/ed>
Trace; ffffffff80215c63 <do_exit+8d/8f3>
Trace; ffffffff80270cbc <do_invalid_op+ad/b7>
Trace; ffffffff80290543 <printk+52/c9>
Trace; ffffffff8804996d <_end+794496d/7eefb000>
Trace; ffffffff8804aa78 <_end+7945a78/7eefb000>
Trace; ffffffff802b2c73 <__do_IRQ+9a/f4>
Trace; ffffffff8026fde3 <default_idle+0/54>
Trace; ffffffff8026fde3 <default_idle+0/54>
Trace; ffffffff8026fe0e <default_idle+2b/54>
Trace; ffffffff806cb817 <start_kernel+1f6/1fb>


2 warnings issued.  Results may not be reliable.


-----------------------------------------------------------------------=
-----
Using the tips from oops-tracing.txt:


(gdb) disassemble str
Dump of assembler code for function str:
0x0000000000500820 <str+0>:     ud2a
0x0000000000500822 <str+2>:     pushq  $0xffffffff8804c364
0x0000000000500827 <str+7>:     retq   $0xb4
0x000000000050082a <str+10>:    mov    0x80(%rbp),%rax
0x0000000000500831 <str+17>:    mov    0x0(%rax),%rdx
0x0000000000500835 <str+21>:    add    %al,(%rax)
0x0000000000500837 <str+23>:    add    %al,(%rax)
End of assembler dump.


-----------------------------------------------------------------------=
-----

root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83                        =
         Bootdata ok (command line is ro root=3DLABEL=3D/ console=3Dtty=
S0,115200 console=3DttyS0)
Linux version 2.6.17-1.2187_FC5 (brewbuilder@hs20-bc2-4.build.redhat.co=
m) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Mon Sep 11 01:=
16:59 EDT 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fffe000 (ACPI data)
 BIOS-e820: 000000007fffe000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000480000000 (usable)               =
         S
DMI 2.3 present.
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 1 PXM 1 280000000-480000000
SRAT: Node 0 PXM 0 100000-280000000
SRAT: Node 0 PXM 0 0-280000000
Bootmem setup node 0 0000000000000000-0000000280000000
Bootmem setup node 1 0000000280000000-0000000480000000
Nvidia board detected. Ignoring ACPI timer override.
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xdffff000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xdffff000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xdfffe000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xdfffe000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Checking aperture...
CPU 0: aperture @ ca000000 size 32 MB
Aperture from northbridge cpu 0 too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
Built 2 zonelists
Kernel command line: ro root=3DLABEL=3D/ console=3DttyS0,115200 console=
=3DttyS0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2814.434 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Memory: 16383568k/18874368k available (2387k kernel code, 393184k reser=
ved, 1700k data, 200k init)
Calibrating delay using timer specific routine.. 5633.13 BogoMIPS (lpj=3D=
11266264)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0(1) -> Node 0 -> Core 0
Using local APIC timer interrupts.
result 12564449
Detected 12.564 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5629.21 BogoMIPS (lpj=3D=
11258435)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1(1) -> Node 1 -> Core 0
AMD Opteron(tm) Processor 254 stepping 01
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -125 cycles, maxerr 946 c=
ycles)
Brought up 2 CPUs
testing NMI watchdog ... OK.
migration_cost=3D0,491
checking if image is initramfs... it is
=46reeing initrd memory: 1130k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Root Bridge [PCIB] (0000:06)
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *3
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *11
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:09: ioport range 0xa00-0xa3f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: d000-dfff
  MEM window: cca00000-ceafffff
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: ceb00000-cebfffff
  PREFETCH window: ff200000-ff2fffff
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: cec00000-cecfffff
  PREFETCH window: ff300000-ff3fffff
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:02.0
  IO window: disabled.
  MEM window: cee00000-dfefffff
  PREFETCH window: ff500000-ff5fffff
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
audit: initializing netlink socket (disabled)
audit(1161001013.016:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key EF5047FF5C74A80F
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for subordinate bus.
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enable=
d
=EF=BF=BDserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 162
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:DMA
hda: DV-28E-N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver libusual
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f12:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: md driver 0.90.3 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: bitmap version 4.39
TCP bic registered
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon 64 / Opteron processors (version 1.60.2=
)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
ACPI wakeup devices:
USB0 USB1 P0P1 P0P2 NIC1 P0P3 NIC2 P0P4 P0P5 GOLA GOLB
ACPI: (supports S0 S4 S5)
=46reeing unused kernel memory: 200k freed
Write protecting the kernel read-only data: 919k
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
input: AT Translated Set 2 keyboard as /class/input/input0
Creating block device nodes.
Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Loading aacraid.ko module
Adaptec aacraid driver (1.1-5[2409]-mh1)
GSI 16 sharing vector 0xD9 and IRQ 16
ACPI: PCI Interrupt 0000:08:01.0[A] -> GSI 28 (level, low) -> IRQ 217
AAC0: kernel 4.2-0[7348]
AAC0: monitor 4.2-0[7348]
AAC0: bios 4.2-0[7348]
AAC0: serial 266441
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi0 : aacraid
  Vendor: Adaptec   Model: ARRAY 0           Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 2342518784 512-byte hdwr sectors (1199370 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
SCSI device sda: 2342518784 512-byte hdwr sectors (1199370 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:0:0:0: Attached scsi removable disk sda
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST3300007LC       Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
Loading libata.ko module
Loading sata_nv.ko module
Loading jbd.ko module
Loading ext3.ko module
Trying to resume from LABEL=3DSWAP-sda3
No suspend signature on swap, not resuming.
Creating root device.
Mounting root filesystem.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda1: orphan cleanup on readonly fs
EXT3-fs: sda1: 13 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Setting up other filesystems.
Setting up new root fs
no fstab.sys, mounting internal defaults
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
audit(1161001019.788:2): enforcing=3D1 old_enforcing=3D0 auid=3D4294967=
295
security:  3 users, 6 roles, 1481 types, 152 bools, 1 sens, 256 cats
security:  58 classes, 43474 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contex=
ts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contex=
ts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses task SID=
s
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contex=
ts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), not configured for labe=
ling
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1161001020.028:3): policy loaded auid=3D4294967295
INIT: version 2.86 booting
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
                Welcome to Fedora Core
                Press 'I' to enter interactive startup.
Setting clock  (localtime): Mon Oct 16 12:17:00 EDT 2006 [  OK  ]
Starting udev: [  OK  ]
Setting hostname apollo:  [  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda1
/: clean, 8067/524288 files, 147051/524112 blocks
[/sbin/fsck.xfs (1) -- /usr] fsck.xfs -a /dev/sda5
/sbin/fsck.xfs: XFS file system.
[/sbin/fsck.xfs (1) -- /var] fsck.xfs -a /dev/sda2
/sbin/fsck.xfs: XFS file system.
[  OK  ]
Remounting root filesystem in read-write mode:  [  OK  ]
Mounting local filesystems:  mount: No medium found
[FAILED]
Enabling local filesystem quotas:  [  OK  ]
realpath(/tmp) failed No such file or directory
                                               Enabling swap space:  [ =
 OK  ]
INIT: Entering runlevel: 3
Entering non-interactive startup
Starting fixcontext:  [  OK  ]
Applying iptables firewall rules: [  OK  ]
Loading additional iptables modules: ip_conntrack ip_conntrack_ftp ipt_=
owner [  OK  ]


--=20
 "Developers are like artists; they produce their best work if they
  have the freedom to do so" - Werner Vogels, CTO Amazon.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
