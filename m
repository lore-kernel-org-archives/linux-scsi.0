From: Mateusz.Blaszczyk@nask.pl
Subject: 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Mon, 18 Oct 2004 14:51:32 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0410181447450.29704@boromir>
Reply-To: Mateusz.Blaszczyk@nask.pl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boromix.nask.net.pl ([195.187.245.33]:64432 "EHLO
	boromix.nask.net.pl") by vger.kernel.org with ESMTP id S266459AbUJRMv4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 08:51:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-usb-devel@lists.sourceforge.net

Hi,

After successful write on USB DVD-R writer (HP-200j), system oops's whe=
n unpluging USB device.
Same thing with 2.6.9-rc2mm1.

Attached:
1. kern.log (OOPS)
2. decode of OOPS from ksymoops
3. my .config


------------------------------ OOPS -----------------------------------=
------------------------------

Oct 15 14:42:10 localhost kernel: usb 1-3: new high speed USB device us=
ing address 3
Oct 15 14:42:11 localhost kernel: Initializing USB Mass Storage driver.=
=2E.
Oct 15 14:42:11 localhost kernel: scsi0 : SCSI emulation for USB Mass S=
torage devices
Oct 15 14:42:11 localhost kernel: usbcore: registered new driver usb-st=
orage
Oct 15 14:42:11 localhost kernel: USB Mass Storage support registered.
Oct 15 14:42:11 localhost kernel: usb-storage: device found at 3
Oct 15 14:42:11 localhost kernel: usb-storage: waiting for device to se=
ttle before scanning
Oct 15 14:42:18 localhost kernel:   Vendor: HP        Model: DVD Writer=
 200j   Rev: 1.06
Oct 15 14:42:18 localhost kernel:   Type:   CD-ROM                     =
        ANSI SCSI revision: 00
Oct 15 14:42:18 localhost kernel: Attached scsi generic sg0 at scsi0, c=
hannel 0, id 0, lun 0,  type 5
Oct 15 14:42:18 localhost kernel: usb-storage: device scan complete
Oct 15 14:42:18 localhost kernel: sr0: scsi-1 drive
Oct 15 14:42:18 localhost kernel: Attached scsi CD-ROM sr0 at scsi0, ch=
annel 0, id 0, lun 0
Oct 15 15:07:37 localhost kernel: cdrom: sr0: mmc-3 profile capable, cu=
rrent profile: 1Bh
Oct 15 15:07:37 localhost kernel: sr0: Hmm, seems the drive doesn't sup=
port multisession CD's
Oct 15 15:07:37 localhost kernel: cfq: depth 4 reached, tagging now on
Oct 15 16:00:20 localhost kernel: drivers/usb/input/hid-core.c: input i=
rq status -84 received
Oct 15 16:00:20 localhost last message repeated 3 times
Oct 15 16:00:20 localhost kernel: usb 2-1: USB disconnect, address 2
Oct 15 16:00:22 localhost kernel: usb 1-3: USB disconnect, address 3
Oct 15 16:00:23 localhost kernel: eth0: link down
Oct 15 16:00:27 localhost kernel: scsi: Device offlined - not ready aft=
er error recovery: host 0 channel 0 id 0 lun 0
Oct 15 16:00:27 localhost kernel: sr 0:0:0:0: Illegal state transition =
cancel->offline
Oct 15 16:00:27 localhost kernel: Badness in scsi_device_set_state at d=
rivers/scsi/scsi_lib.c:1713
Oct 15 16:00:27 localhost kernel:  [scsi_device_set_state+199/210] scsi=
_device_set_state+0xc7/0xd2
Oct 15 16:00:27 localhost kernel:  [scsi_eh_offline_sdevs+70/95] scsi_e=
h_offline_sdevs+0x46/0x5f
Oct 15 16:00:27 localhost kernel:  [scsi_unjam_host+154/169] scsi_unjam=
_host+0x9a/0xa9
Oct 15 16:00:27 localhost kernel:  [scsi_error_handler+134/176] scsi_er=
ror_handler+0x86/0xb0
Oct 15 16:00:27 localhost kernel:  [scsi_error_handler+0/176] scsi_erro=
r_handler+0x0/0xb0
Oct 15 16:00:27 localhost kernel:  [kernel_thread_helper+5/11] kernel_t=
hread_helper+0x5/0xb
Oct 15 16:00:27 localhost kernel: Badness in kref_get at lib/kref.c:32
Oct 15 16:00:27 localhost kernel:  [kref_get+36/43] kref_get+0x24/0x2b
Oct 15 16:00:27 localhost kernel:  [kobject_get+15/19] kobject_get+0xf/=
0x13
Oct 15 16:00:27 localhost kernel:  [get_device+14/20] get_device+0xe/0x=
14
Oct 15 16:00:27 localhost kernel:  [scsi_request_fn+25/795] scsi_reques=
t_fn+0x19/0x31b
Oct 15 16:00:27 localhost kernel:  [__generic_unplug_device+40/42] __ge=
neric_unplug_device+0x28/0x2a
Oct 15 16:00:27 localhost kernel:  [generic_unplug_device+21/54] generi=
c_unplug_device+0x15/0x36
Oct 15 16:00:27 localhost kernel:  [blk_unplug_work+3/4] blk_unplug_wor=
k+0x3/0x4
Oct 15 16:00:27 localhost kernel:  [worker_thread+411/548] worker_threa=
d+0x19b/0x224
Oct 15 16:00:27 localhost kernel:  [blk_unplug_work+0/4] blk_unplug_wor=
k+0x0/0x4
Oct 15 16:00:27 localhost kernel:  [default_wake_function+0/12] default=
_wake_function+0x0/0xc
Oct 15 16:00:27 localhost kernel:  [default_wake_function+0/12] default=
_wake_function+0x0/0xc
Oct 15 16:00:27 localhost kernel:  [worker_thread+0/548] worker_thread+=
0x0/0x224
Oct 15 16:00:27 localhost kernel:  [kthread+105/145] kthread+0x69/0x91
Oct 15 16:00:27 localhost kernel:  [kthread+0/145] kthread+0x0/0x91
Oct 15 16:00:27 localhost kernel:  [kernel_thread_helper+5/11] kernel_t=
hread_helper+0x5/0xb
Oct 15 16:00:27 localhost kernel: Unable to handle kernel paging reques=
t at virtual address 00100104
Oct 15 16:00:27 localhost kernel:  printing eip:
Oct 15 16:00:27 localhost kernel: c0256226
Oct 15 16:00:27 localhost kernel: *pde =3D 00000000
Oct 15 16:00:27 localhost kernel: Oops: 0002 [#1]
Oct 15 16:00:27 localhost kernel: PREEMPT
Oct 15 16:00:27 localhost kernel: Modules linked in: udf sr_mod usb_sto=
rage msdos fat nls_base ext2 aes_i586 des i830 pktcdvd lp button proces=
sor ac battery ipt_REJECT ipt_pkttype ipt_LOG ipt_state ipt_multiport i=
pt_conntrack iptable_mangle ip_nat_irc ip_nat_tftp ip_nat_ftp iptable_n=
at ip_conntrack_irc ip_conntrack_tftp ip_conntrack_ftp ip_conntrack ipt=
able_filter ip_tables usbhid ipw2100 ieee80211 ieee80211_crypt 8139too =
mii crc32 hw_random intel_agp agpgart parport_pc parport pcspkr cpufreq=
_userspace irtty_sir sir_dev
Oct 15 16:00:27 localhost kernel: CPU:    0
Oct 15 16:00:27 localhost kernel: EIP:    0060:[scsi_request_fn+491/795=
]    Not tainted VLI
Oct 15 16:00:27 localhost kernel: EFLAGS: 00010013   (2.6.9-rc4mm1)
Oct 15 16:00:27 localhost kernel: EIP is at scsi_request_fn+0x1eb/0x31b
Oct 15 16:00:27 localhost kernel: eax: 00200200   ebx: c24fe4b0   ecx: =
00100100   edx: c7d87824
Oct 15 16:00:27 localhost kernel: esi: c7d87800   edi: ce8ef400   ebp: =
c9240de0   esp: c136df48
Oct 15 16:00:27 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct 15 16:00:27 localhost kernel: Process kblockd/0 (pid: 131, threadin=
fo=3Dc136c000 task=3Dc1265aa0)
Oct 15 16:00:27 localhost kernel: Stack: c9240de0 c137f200 c9240e60 000=
00216 c023963c c9240de0 c0239653 c9240e64
Oct 15 16:00:27 localhost kernel:        c0239684 c0123e02 c9240de0 c02=
39681 ffffffff ffffffff 00000001 00000000
Oct 15 16:00:27 localhost kernel:        c0114608 00010000 00000000 c12=
65aa0 c1265aa0 c136dfcc 00000000 c1265aa0
Oct 15 16:00:27 localhost kernel: Call Trace:
Oct 15 16:00:27 localhost kernel:  [__generic_unplug_device+40/42] __ge=
neric_unplug_device+0x28/0x2a
Oct 15 16:00:27 localhost kernel:  [generic_unplug_device+21/54] generi=
c_unplug_device+0x15/0x36
Oct 15 16:00:27 localhost kernel:  [blk_unplug_work+3/4] blk_unplug_wor=
k+0x3/0x4
Oct 15 16:00:27 localhost kernel:  [worker_thread+411/548] worker_threa=
d+0x19b/0x224
Oct 15 16:00:27 localhost kernel:  [blk_unplug_work+0/4] blk_unplug_wor=
k+0x0/0x4
Oct 15 16:00:27 localhost kernel:  [default_wake_function+0/12] default=
_wake_function+0x0/0xc
Oct 15 16:00:27 localhost kernel:  [default_wake_function+0/12] default=
_wake_function+0x0/0xc
Oct 15 16:00:27 localhost kernel:  [worker_thread+0/548] worker_thread+=
0x0/0x224
Oct 15 16:00:27 localhost kernel:  [kthread+105/145] kthread+0x69/0x91
Oct 15 16:00:27 localhost kernel:  [kthread+0/145] kthread+0x0/0x91
Oct 15 16:00:27 localhost kernel:  [kernel_thread_helper+5/11] kernel_t=
hread_helper+0x5/0xb
Oct 15 16:00:27 localhost kernel: Code: 4e 24 0f 85 cf 00 00 00 8d 47 1=
4 8b 50 04 89 46 24 89 48 04 89 0a 89 51 04 e9 b9 00 00 00 8b 4e 24 8d =
56 24 39 d1 74 0e 8b 42 04 <89> 41 04 89 08 89 52 04 89 56 24 f6 86 75 =
01 00 00 80 74 18 8b
Oct 15 16:00:27 localhost kernel:  <6>note: kblockd/0[131] exited with =
preempt_count 1
----------------------------------- END OF OOPS -----------------------=
--------------------------


---------------------------- OOPS DECODED -----------------------------=
---------------------

ksymoops 2.4.9 on i686 2.6.9-rc4mm1.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.9-rc4mm1/ (default)
     -m /boot/System.map-2.6.9-rc4mm1 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Unable to handle kernel paging request at virtual address 00100104
c0256226
*pde =3D 00000000
Oops: 0002 [#1]
CPU:    0
EIP:    0060:[<c0256226>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010013   (2.6.9-rc4mm1)
eax: 00200200   ebx: c24fe4b0   ecx: 00100100   edx: c7d87824
esi: c7d87800   edi: ce8ef400   ebp: c9240de0   esp: c136df48
ds: 007b   es: 007b   ss: 0068
Stack: c9240de0 c137f200 c9240e60 00000216 c023963c c9240de0 c0239653 c=
9240e64
       c0239684 c0123e02 c9240de0 c0239681 ffffffff ffffffff 00000001 0=
0000000
       c0114608 00010000 00000000 c1265aa0 c1265aa0 c136dfcc 00000000 c=
1265aa0
Call Trace:
 [<c023963c>] __generic_unplug_device+0x28/0x2a
 [<c0239653>] generic_unplug_device+0x15/0x36
 [<c0239684>] blk_unplug_work+0x3/0x4
 [<c0123e02>] worker_thread+0x19b/0x224
 [<c0239681>] blk_unplug_work+0x0/0x4
 [<c0114608>] default_wake_function+0x0/0xc
 [<c0114608>] default_wake_function+0x0/0xc
 [<c0123c67>] worker_thread+0x0/0x224
 [<c0127171>] kthread+0x69/0x91
 [<c0127108>] kthread+0x0/0x91
 [<c01021f9>] kernel_thread_helper+0x5/0xb
Code: 4e 24 0f 85 cf 00 00 00 8d 47 14 8b 50 04 89 46 24 89 48 04 89 0a=
 89 51 04 e9 b9 00 00 00 8b 4e 24 8d 56 24 39 d1 74 0e 8b 42 04 <89> 41=
 04 89 08 89 52 04 89 56 24 f6 86 75 01 00 00 80 74 18 8b


>>EIP; c0256226 <scsi_request_fn+1eb/31b>   <=3D=3D=3D=3D=3D

>>ebx; c24fe4b0 <pg0+20774b0/3fb77400>
>>edx; c7d87824 <pg0+7900824/3fb77400>
>>esi; c7d87800 <pg0+7900800/3fb77400>
>>edi; ce8ef400 <pg0+e468400/3fb77400>
>>ebp; c9240de0 <pg0+8db9de0/3fb77400>
>>esp; c136df48 <pg0+ee6f48/3fb77400>

Trace; c023963c <__generic_unplug_device+28/2a>
Trace; c0239653 <generic_unplug_device+15/36>
Trace; c0239684 <blk_unplug_work+3/4>
Trace; c0123e02 <worker_thread+19b/224>
Trace; c0239681 <blk_unplug_work+0/4>
Trace; c0114608 <default_wake_function+0/c>
Trace; c0114608 <default_wake_function+0/c>
Trace; c0123c67 <worker_thread+0/224>
Trace; c0127171 <kthread+69/91>
Trace; c0127108 <kthread+0/91>
Trace; c01021f9 <kernel_thread_helper+5/b>

This architecture has variable length instructions, decoding before eip
is unreliable, take these instructions with a pinch of salt.

Code;  c02561fb <scsi_request_fn+1c0/31b>
00000000 <_EIP>:
Code;  c02561fb <scsi_request_fn+1c0/31b>
   0:   4e                        dec    %esi
Code;  c02561fc <scsi_request_fn+1c1/31b>
   1:   24 0f                     and    $0xf,%al
Code;  c02561fe <scsi_request_fn+1c3/31b>
   3:   85 cf                     test   %ecx,%edi
Code;  c0256200 <scsi_request_fn+1c5/31b>
   5:   00 00                     add    %al,(%eax)
Code;  c0256202 <scsi_request_fn+1c7/31b>
   7:   00 8d 47 14 8b 50         add    %cl,0x508b1447(%ebp)
Code;  c0256208 <scsi_request_fn+1cd/31b>
   d:   04 89                     add    $0x89,%al
Code;  c025620a <scsi_request_fn+1cf/31b>
   f:   46                        inc    %esi
Code;  c025620b <scsi_request_fn+1d0/31b>
  10:   24 89                     and    $0x89,%al
Code;  c025620d <scsi_request_fn+1d2/31b>
  12:   48                        dec    %eax
Code;  c025620e <scsi_request_fn+1d3/31b>
  13:   04 89                     add    $0x89,%al
Code;  c0256210 <scsi_request_fn+1d5/31b>
  15:   0a 89 51 04 e9 b9         or     0xb9e90451(%ecx),%cl
Code;  c0256216 <scsi_request_fn+1db/31b>
  1b:   00 00                     add    %al,(%eax)
Code;  c0256218 <scsi_request_fn+1dd/31b>
  1d:   00 8b 4e 24 8d 56         add    %cl,0x568d244e(%ebx)
Code;  c025621e <scsi_request_fn+1e3/31b>
  23:   24 39                     and    $0x39,%al
Code;  c0256220 <scsi_request_fn+1e5/31b>
  25:   d1                        (bad)
Code;  c0256221 <scsi_request_fn+1e6/31b>
  26:   74 0e                     je     36 <_EIP+0x36>
Code;  c0256223 <scsi_request_fn+1e8/31b>
  28:   8b 42 04                  mov    0x4(%edx),%eax

This decode from eip onwards should be reliable

Code;  c0256226 <scsi_request_fn+1eb/31b>
00000000 <_EIP>:
Code;  c0256226 <scsi_request_fn+1eb/31b>   <=3D=3D=3D=3D=3D
   0:   89 41 04                  mov    %eax,0x4(%ecx)   <=3D=3D=3D=3D=
=3D
Code;  c0256229 <scsi_request_fn+1ee/31b>
   3:   89 08                     mov    %ecx,(%eax)
Code;  c025622b <scsi_request_fn+1f0/31b>
   5:   89 52 04                  mov    %edx,0x4(%edx)
Code;  c025622e <scsi_request_fn+1f3/31b>
   8:   89 56 24                  mov    %edx,0x24(%esi)
Code;  c0256231 <scsi_request_fn+1f6/31b>
   b:   f6 86 75 01 00 00 80      testb  $0x80,0x175(%esi)
Code;  c0256238 <scsi_request_fn+1fd/31b>
  12:   74 18                     je     2c <_EIP+0x2c>
Code;  c025623a <scsi_request_fn+1ff/31b>
  14:   8b                        .byte 0x8b


1 warning and 1 error issued.  Results may not be reliable.
---------------------- END OF DECODED OOPS ----------------------------=
----------------------

---------------------- .config ----------------------------------------=
----------------------

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.9-rc4mm1
# Wed Oct 13 13:22:54 2004
#
CONFIG_X86=3Dy
CONFIG_MMU=3Dy
CONFIG_UID16=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_CLEAN_COMPILE=3Dy
CONFIG_BROKEN_ON_SMP=3Dy

#
# General setup
#
CONFIG_LOCALVERSION=3D""
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_POSIX_MQUEUE=3Dy
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_SYSCTL=3Dy
# CONFIG_AUDIT is not set
CONFIG_LOG_BUF_SHIFT=3D14
CONFIG_HOTPLUG=3Dy
CONFIG_KOBJECT_UEVENT=3Dy
# CONFIG_IKCONFIG is not set
CONFIG_EMBEDDED=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_IOSCHED_NOOP=3Dy
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
CONFIG_SHMEM=3Dy
# CONFIG_TINY_SHMEM is not set

#
# Loadable module support
#
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_OBSOLETE_MODPARM=3Dy
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=3Dy

#
# Processor type and features
#
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=3Dy
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_XADD=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_GOOD_APIC=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
# CONFIG_SMP is not set
CONFIG_PREEMPT=3Dy
CONFIG_PREEMPT_BKL=3Dy
CONFIG_X86_UP_APIC=3Dy
CONFIG_X86_UP_IOAPIC=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_NONFATAL=3Dy
CONFIG_X86_MCE_P4THERMAL=3Dy
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=3Dy
# CONFIG_HIGHMEM64G is not set
CONFIG_HIGHMEM=3Dy
CONFIG_HIGHPTE=3Dy
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
# CONFIG_EFI is not set
CONFIG_HAVE_DEC_LOCK=3Dy
CONFIG_REGPARM=3Dy

#
# Performance-monitoring counters support
#
CONFIG_PERFCTR=3Dy
CONFIG_PERFCTR_INIT_TESTS=3Dy
CONFIG_PERFCTR_VIRTUAL=3Dy
CONFIG_PERFCTR_INTERRUPT_SUPPORT=3Dy
# CONFIG_KEXEC is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
CONFIG_SOFTWARE_SUSPEND=3Dy
CONFIG_PM_STD_PARTITION=3D""

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=3Dy
CONFIG_ACPI_BOOT=3Dy
CONFIG_ACPI_INTERPRETER=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_SLEEP_PROC_FS=3Dy
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_FAN=3Dm
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_THINKPAD is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_BUS=3Dy
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_PCI=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy

#
# APM (Advanced Power Management) BIOS Support
#
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
# CONFIG_CPU_FREQ_PROC_INTF is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
# CONFIG_CPU_FREQ_24_API is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_TABLE=3Dy

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=3Dy
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=3Dy
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set

#
# shared options
#

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=3Dy
CONFIG_PCI_BIOS=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_MSI=3Dy
CONFIG_PCI_LEGACY_PROC=3Dy
CONFIG_PCI_NAMES=3Dy
CONFIG_ISA=3Dy
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCMCIA/CardBus support
#
CONFIG_PCMCIA=3Dy
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_YENTA=3Dy
CONFIG_CARDBUS=3Dy
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=3Dy

#
# PCI Hotplug Support
#
CONFIG_HOTPLUG_PCI=3Dy
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=3Dy
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_PC_CML1=3Dm
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_OTHER is not set
# CONFIG_PARPORT_1284 is not set

#
# Plug and Play support
#
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=3Dy
CONFIG_PNPBIOS=3Dy
CONFIG_PNPBIOS_PROC_FS=3Dy

#
# Block devices
#
CONFIG_BLK_DEV_FD=3Dm
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=3Dy
CONFIG_BLK_DEV_CRYPTOLOOP=3Dy
CONFIG_BLK_DEV_NBD=3Dm
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dm
CONFIG_BLK_DEV_RAM_SIZE=3D4096
CONFIG_INITRAMFS_SOURCE=3D""
# CONFIG_LBD is not set
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
CONFIG_CDROM_PKTCDVD_WCACHE=3Dy

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=3Dy
CONFIG_BLK_DEV_IDE=3Dy

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dy
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECS=3Dm
CONFIG_BLK_DEV_IDECD=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=3Dm
CONFIG_BLK_DEV_IDESCSI=3Dm
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dy
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_SHARE_IRQ=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=3Dy
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=3Dy
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_IDE_ARM is not set
# CONFIG_IDE_CHIPSETS is not set
CONFIG_BLK_DEV_IDEDMA=3Dy
# CONFIG_IDEDMA_IVB is not set
CONFIG_IDEDMA_AUTO=3Dy
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_SCSI=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dy

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set

#
# SCSI Transport Attributes
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set

#
# SCSI low-level drivers
#
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_SCSI_SATA is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_EATA_PIO is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_ISP is not set
# CONFIG_SCSI_QLOGIC_FC is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLOGIC_1280_1040 is not set
CONFIG_SCSI_QLA2XXX=3Dy
# CONFIG_SCSI_QLA21XX is not set
# CONFIG_SCSI_QLA22XX is not set
# CONFIG_SCSI_QLA2300 is not set
# CONFIG_SCSI_QLA2322 is not set
# CONFIG_SCSI_QLA6312 is not set
# CONFIG_SCSI_QLA6322 is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set

#
# PCMCIA SCSI adapter support
#
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_NINJA_SCSI is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set

#
# Old CD-ROM drivers (not SCSI, not IDE)
#
# CONFIG_CD_NO_IDESCSI is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Networking support
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_NETLINK_DEV=3Dm
CONFIG_UNIX=3Dy
CONFIG_NET_KEY=3Dm
CONFIG_INET=3Dy
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TUNNEL=3Dm

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set

#
# IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=3Dm
# CONFIG_IP_NF_CT_ACCT is not set
# CONFIG_IP_NF_CT_PROTO_SCTP is not set
CONFIG_IP_NF_FTP=3Dm
CONFIG_IP_NF_IRC=3Dm
CONFIG_IP_NF_TFTP=3Dm
CONFIG_IP_NF_AMANDA=3Dm
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_LIMIT=3Dm
CONFIG_IP_NF_MATCH_IPRANGE=3Dm
CONFIG_IP_NF_MATCH_MAC=3Dm
CONFIG_IP_NF_MATCH_PKTTYPE=3Dm
CONFIG_IP_NF_MATCH_MARK=3Dm
CONFIG_IP_NF_MATCH_MULTIPORT=3Dm
CONFIG_IP_NF_MATCH_TOS=3Dm
CONFIG_IP_NF_MATCH_RECENT=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_DSCP=3Dm
CONFIG_IP_NF_MATCH_AH_ESP=3Dm
CONFIG_IP_NF_MATCH_LENGTH=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_MATCH_TCPMSS=3Dm
CONFIG_IP_NF_MATCH_HELPER=3Dm
CONFIG_IP_NF_MATCH_STATE=3Dm
CONFIG_IP_NF_MATCH_CONNTRACK=3Dm
CONFIG_IP_NF_MATCH_OWNER=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_MATCH_REALM=3Dm
# CONFIG_IP_NF_MATCH_SCTP is not set
# CONFIG_IP_NF_MATCH_COMMENT is not set
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_IP_NF_TARGET_TCPMSS=3Dm
CONFIG_IP_NF_NAT=3Dm
CONFIG_IP_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_SAME=3Dm
# CONFIG_IP_NF_NAT_LOCAL is not set
# CONFIG_IP_NF_NAT_SNMP_BASIC is not set
CONFIG_IP_NF_NAT_IRC=3Dm
CONFIG_IP_NF_NAT_FTP=3Dm
CONFIG_IP_NF_NAT_TFTP=3Dm
CONFIG_IP_NF_NAT_AMANDA=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_TOS=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_DSCP=3Dm
CONFIG_IP_NF_TARGET_MARK=3Dm
CONFIG_IP_NF_TARGET_CLASSIFY=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_TARGET_NOTRACK=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm
# CONFIG_IP_NF_COMPAT_IPCHAINS is not set
# CONFIG_IP_NF_COMPAT_IPFWADM is not set
CONFIG_XFRM=3Dy
# CONFIG_XFRM_USER is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=3Dm
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_NET_DIVERT is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_HW_FLOWCONTROL is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_KGDBOE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NETPOLL_RX is not set
# CONFIG_NETPOLL_TRAP is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=3Dy

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dy
CONFIG_IRDA_ULTRA=3Dy

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
CONFIG_IRDA_DEBUG=3Dy

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=3Dm

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# Old SIR device drivers
#
CONFIG_IRPORT_SIR=3Dm

#
# Old Serial dongle support
#
# CONFIG_DONGLE_OLD is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=3Dm
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
CONFIG_NETDEVICES=3Dy
CONFIG_DUMMY=3Dm
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_ETHERTAP is not set
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set

#
# Tulip family network device support
#
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=3Dm
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_NET_POCKET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
CONFIG_NET_RADIO=3Dy

#
# Obsolete Wireless cards support (pre-802.11)
#
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
# CONFIG_WAVELAN is not set
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_PCMCIA_NETWAVE is not set

#
# Wireless 802.11 Frequency Hopping cards support
#
# CONFIG_PCMCIA_RAYCS is not set

#
# Wireless 802.11b ISA/PCI cards support
#
CONFIG_IEEE80211=3Dm
CONFIG_IEEE80211_CRYPT=3Dm
CONFIG_IEEE80211_WPA=3Dm
CONFIG_IEEE80211_CRYPT_CCMP=3Dm
CONFIG_IEEE80211_CRYPT_TKIP=3Dm
CONFIG_IPW2100=3Dm
CONFIG_IPW2100_PROMISC=3Dy
# CONFIG_IPW2100_LEGACY_FW_LOAD is not set
CONFIG_IPW_DEBUG=3Dy
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set

#
# Wireless 802.11b Pcmcia/Cardbus cards support
#
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set

#
# Prism GT/Duette 802.11(a/b/g) PCI/Cardbus support
#
# CONFIG_PRISM54 is not set
CONFIG_NET_WIRELESS=3Dy

#
# PCMCIA network device support
#
# CONFIG_NET_PCMCIA is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPPOE=3Dm
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input I/O drivers
#
# CONFIG_GAMEPORT is not set
CONFIG_SOUND_GAMEPORT=3Dy
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
# CONFIG_INPUT_UINPUT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_ACPI=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dm
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I8XX_TCO=3Dm
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_MACHZ_WDT is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_HW_RANDOM=3Dm
# CONFIG_NVRAM is not set
CONFIG_RTC=3Dy
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# Ftape, the floppy tape device driver
#
# CONFIG_FTAPE is not set
CONFIG_AGP=3Dm
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=3Dm
# CONFIG_AGP_INTEL_MCH is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=3Dy
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I830=3Dm
CONFIG_DRM_I915=3Dm
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set

#
# Graphics support
#
CONFIG_FB=3Dy
CONFIG_FB_MODE_HELPERS=3Dy
# CONFIG_FB_TILEBLITTING is not set
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=3Dy
CONFIG_VIDEO_SELECT=3Dy
# CONFIG_FB_HGA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON_OLD is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy

#
# Logo configuration
#
CONFIG_LOGO=3Dy
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=3Dy
# CONFIG_LOGO_LINUX_CLUT224 is not set

#
# Sound
#
CONFIG_SOUND=3Dy

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=3Dy
CONFIG_SND_TIMER=3Dy
CONFIG_SND_PCM=3Dy
CONFIG_SND_RAWMIDI=3Dy
CONFIG_SND_SEQUENCER=3Dy
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dy
CONFIG_SND_PCM_OSS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
CONFIG_SND_RTCTIMER=3Dy
CONFIG_SND_VERBOSE_PRINTK=3Dy
CONFIG_SND_DEBUG=3Dy
# CONFIG_SND_DEBUG_MEMORY is not set
CONFIG_SND_DEBUG_DETECT=3Dy

#
# Generic devices
#
CONFIG_SND_MPU401_UART=3Dy
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=3Dy

#
# ISA devices
#
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_WAVEFRONT is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set

#
# PCI devices
#
CONFIG_SND_AC97_CODEC=3Dy
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=3Dy
CONFIG_SND_INTEL8X0M=3Dy
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VX222 is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_VXP440 is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set

#
# USB support
#
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_BANDWIDTH=3Dy
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=3Dy
CONFIG_USB_EHCI_SPLIT_ISO=3Dy
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=3Dy

#
# USB Device Class drivers
#
CONFIG_USB_AUDIO=3Dm
CONFIG_USB_BLUETOOTH_TTY=3Dm
CONFIG_USB_MIDI=3Dm
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_RW_DETECT=3Dy
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
CONFIG_USB_STORAGE_ISD200=3Dy
CONFIG_USB_STORAGE_DPCM=3Dy
CONFIG_USB_STORAGE_HP8200e=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy

#
# USB Human Interface Devices (HID)
#
CONFIG_USB_HID=3Dm
CONFIG_USB_HIDINPUT=3Dy
CONFIG_HID_FF=3Dy
CONFIG_HID_PID=3Dy
CONFIG_LOGITECH_FF=3Dy
CONFIG_THRUSTMASTER_FF=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_AIPTEK=3Dm
CONFIG_USB_WACOM=3Dm
CONFIG_USB_KBTAB=3Dm
CONFIG_USB_POWERMATE=3Dm
CONFIG_USB_MTOUCH=3Dm
CONFIG_USB_EGALAX=3Dm
CONFIG_USB_XPAD=3Dm
CONFIG_USB_ATI_REMOTE=3Dm

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm
CONFIG_USB_HPUSBSCSI=3Dm

#
# USB Multimedia devices
#
CONFIG_USB_DABUSB=3Dm

#
# Video4Linux support is needed for USB Multimedia device support
#

#
# USB Network adaptors
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm

#
# USB Host-to-Host Cables
#
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_GENESYS=3Dy
CONFIG_USB_NET1080=3Dy
CONFIG_USB_PL2301=3Dy

#
# Intelligent USB Devices/Gadgets
#
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_ZAURUS=3Dy
CONFIG_USB_CDCETHER=3Dy

#
# USB Network Adapters
#
CONFIG_USB_AX8817X=3Dy

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_TIGL=3Dm
CONFIG_USB_AUERSWALD=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_PHIDGETSERVO=3Dm
CONFIG_USB_TEST=3Dm

#
# USB ATM/DSL drivers
#

#
# USB Gadget Support
#
CONFIG_USB_GADGET=3Dm
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_NET2280=3Dy
CONFIG_USB_NET2280=3Dm
# CONFIG_USB_GADGET_PXA2XX is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_SA1100 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
# CONFIG_USB_GADGET_OMAP is not set
CONFIG_USB_GADGET_DUALSPEED=3Dy
CONFIG_USB_ZERO=3Dm
CONFIG_USB_ETH=3Dm
CONFIG_USB_ETH_RNDIS=3Dy
CONFIG_USB_GADGETFS=3Dm
CONFIG_USB_FILE_STORAGE=3Dm
CONFIG_USB_FILE_STORAGE_TEST=3Dy
CONFIG_USB_G_SERIAL=3Dm

#
# File systems
#
CONFIG_EXT2_FS=3Dm
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
# CONFIG_JBD is not set
CONFIG_REISER4_FS=3Dy
CONFIG_REISER4_LARGE_KEY=3Dy
# CONFIG_REISER4_CHECK is not set
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=3Dy
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_MINIX_FS=3Dm
# CONFIG_ROMFS_FS is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=3Dy

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_ZISOFS_FS=3Dm
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dm
CONFIG_NTFS_DEBUG=3Dy
CONFIG_NTFS_RW=3Dy

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_SYSFS=3Dy
# CONFIG_DEVFS_FS is not set
# CONFIG_DEVPTS_FS_XATTR is not set
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=3Dy

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_EXPORTFS is not set
CONFIG_SMB_FS=3Dm
CONFIG_SMB_NLS_DEFAULT=3Dy
CONFIG_SMB_NLS_REMOTE=3D"cp852"
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=3Dy
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_EFI_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=3Dm
CONFIG_NLS_DEFAULT=3D"iso8859-2"
CONFIG_NLS_CODEPAGE_437=3Dm
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=3Dm
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=3Dm
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=3Dm
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=3Dm
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=3Dm

#
# Profiling support
#
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_PREEMPT=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=3Dy
CONFIG_X86_MPPARSE=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=3Dy
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES_586=3Dm
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=3Dm
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_TEST is not set

#
# Library routines
#
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC32=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_ZLIB_INFLATE=3Dm
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
----------------------------- END OF .config --------------------------=
------------------

-mat

--=20
Pozdrowienia,Regards,Cheers,Gr=FC=DFe,A plus!,
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
