From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: Problem: sym53c8xx and io_request_lock
Date: Tue, 27 May 2003 11:17:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000801c32463$2886f000$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:25605 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S263721AbTE0PE6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 11:04:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org

Hello,

I am having a problem with the 2.4 kernel locking up when I load the
sym53c8xx SCSI driver.  The lockup occurs on a dual-processor SMP system
with two dual-channel LSI22903 SCSI cards (LSI Logic 53c1010-66).  The
lockup happens only with two SCSI cards installed; with only one SCSI card
installed it works fine.  For debugging purposes there are no SCSI devices
attached; the lockup happens when loading the driver, not when accessing
devices.  I have tested two completely different sets of hardware in the
same configuration with the same results.

I enabled the NMI watchdog timer to get an oops report of the lockup.  It
actually oopses in one of two different places.  Both oops reports are
included below.

The lockup is triggered by a call to either ioremap() or iounmap().  After
discussing it on the linux-smp mailing list, I have determined that the
lockup is caused by the driver holding io_request_lock while calling
ioremap() and iounmap().  Unfortunately, I don't know enough about the Linux
SCSI subsystem to suggest a proper fix myself.

I was initially using 2.4.21-rc1 but also tried 2.4.21-rc3 with the same
results.

Anthony J. Battersby
Cybernetics

----------------------------------------------------------------------

Oops report #1.  The pci_unmap_mem() function in sym53c8xx calls iounmap()
while holding io_request_lock, which triggers the lockup.

ksymoops 2.4.4 on i686 2.4.21-rc1-debug.  Options used
     -V (default)
     -k 20030523004504.ksyms (specified)
     -l 20030523004504.modules (specified)
     -o /lib/modules/2.4.21-rc1-debug/ (default)
     -m /boot/System.map-2.4.21-rc1-debug (specified)

NMI Watchdog detected LOCKUP on CPU1, eip c011286b, registers:
CPU:    1
EIP:    0010:[<c011286b>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00000097
eax: 00000000   ebx: 00000001   ecx: c100001c   edx: d082b000
esi: 00000001   edi: cf8c20fc   ebp: cfb1bb20   esp: cfb1baf8
ds: 0018   es: 0018   ss: 0018
Process insmod (pid: 239, stackpage=cfb1b000)
Stack: c01126b0 00000000 00000000 00000000 00000001 c011aa2b 00003a48
0002b000
       cfb46974 00000000 cfb1bb3c c0112724 c01126b0 00000000 00000001
00000001
       cfb46974 cfb1bb50 c0134509 d0829000 00002000 d0829000 cfb1bb68
d083ca14
Call Trace:    [<c01126b0>] [<c011aa2b>] [<c0112724>] [<c01126b0>]
[<c0134509>]
  [<d083ca14>] [<d084a3d9>] [<d083fc8b>] [<d084a586>] [<c01b87b7>]
[<d084d9e0>]
  [<d083fe69>] [<d084d9e0>] [<d084d9e0>] [<c011bf26>] [<d083c060>]
[<c01076b3>]
Code: 39 d8 75 f9 85 f6 74 09 eb 00 8b 45 e4 39 d8 75 f9 81 3d ac

>>EIP; c011286b <smp_call_function+9b/f0>   <=====
Trace; c01126b0 <flush_tlb_all_ipi+0/60>
Trace; c011aa2b <call_console_drivers+eb/100>
Trace; c0112724 <flush_tlb_all+14/80>
Trace; c01126b0 <flush_tlb_all_ipi+0/60>
Trace; c0134509 <vfree+39/c0>
Trace; d083ca14 <[sym53c8xx]pci_unmap_mem+24/50>
Trace; d084a3d9 <[sym53c8xx].rodata.end+19ea/29b1>
Trace; d083fc8b <[sym53c8xx]sym53c8xx_detect+35b/470>
Trace; d084a586 <[sym53c8xx].rodata.end+1b97/29b1>
Trace; c01b87b7 <scsi_register_host+97/360>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; d083fe69 <[sym53c8xx]init_this_scsi_driver+19/40>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; c011bf26 <sys_init_module+596/680>
Trace; d083c060 <[sym53c8xx]sym_fw1_patch+0/60>
Trace; c01076b3 <system_call+33/38>
Code;  c011286b <smp_call_function+9b/f0>
00000000 <_EIP>:
Code;  c011286b <smp_call_function+9b/f0>   <=====
   0:   39 d8                     cmp    %ebx,%eax   <=====
Code;  c011286d <smp_call_function+9d/f0>
   2:   75 f9                     jne    fffffffd <_EIP+0xfffffffd> c0112868
<smp_call_function+98/f0>
Code;  c011286f <smp_call_function+9f/f0>
   4:   85 f6                     test   %esi,%esi
Code;  c0112871 <smp_call_function+a1/f0>
   6:   74 09                     je     11 <_EIP+0x11> c011287c
<smp_call_function+ac/f0>
Code;  c0112873 <smp_call_function+a3/f0>
   8:   eb 00                     jmp    a <_EIP+0xa> c0112875
<smp_call_function+a5/f0>
Code;  c0112875 <smp_call_function+a5/f0>
   a:   8b 45 e4                  mov    0xffffffe4(%ebp),%eax
Code;  c0112878 <smp_call_function+a8/f0>
   d:   39 d8                     cmp    %ebx,%eax
Code;  c011287a <smp_call_function+aa/f0>
   f:   75 f9                     jne    a <_EIP+0xa> c0112875
<smp_call_function+a5/f0>
Code;  c011287c <smp_call_function+ac/f0>
  11:   81 3d ac 00 00 00 00      cmpl   $0x0,0xac
Code;  c0112883 <smp_call_function+b3/f0>
  18:   00 00 00

----------------------------------------------------------------------

Kernel messages to go with oops #1, including some ioremap/iounmap printk()s
I added.

ioremap(0xFC006000, 8192)
ioremap(0xFC006000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 128)
ioremap(0xFC009000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC000000, 8192)
ioremap(0xFC000000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC00B000, 128)
ioremap(0xFC00B000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC002000, 8192)
ioremap(0xFC002000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC008000, 128)
ioremap(0xFC008000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC004000, 8192)
ioremap(0xFC004000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC00A000, 128)
ioremap(0xFC00A000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 128)
ioremap(0xFC009000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 256)
ioremap(0xFC009000, 256) = 0xD081A000
ioremap(0xFC006000, 8192)
ioremap(0xFC006000, 8192) = 0xD081C000
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym0: SCSI BUS has been reset.
ioremap(0xFC00B000, 128)
ioremap(0xFC00B000, 128) = 0xD081F000
iounmap(0xD081F000)
iounmap done
ioremap(0xFC00B000, 256)
ioremap(0xFC00B000, 256) = 0xD081F000
ioremap(0xFC000000, 8192)
ioremap(0xFC000000, 8192) = 0xD0821000
sym1: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
ioremap(0xFC008000, 128)
ioremap(0xFC008000, 128) = 0xD0824000
iounmap(0xD0824000)
iounmap done
ioremap(0xFC008000, 256)
ioremap(0xFC008000, 256) = 0xD0824000
ioremap(0xFC002000, 8192)
ioremap(0xFC002000, 8192) = 0xD0826000
sym2: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym2: open drain IRQ line driver, using on-chip SRAM
sym2: using LOAD/STORE-based firmware.
sym2: handling phase mismatch from SCRIPTS.
sym2: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym2: SCSI BUS has been reset.
ioremap(0xFC00A000, 128)
ioremap(0xFC00A000, 128) = 0xD0829000
iounmap(0xD0829000)
--> The NMI watchdog oopses in the call to iounmap() above.

----------------------------------------------------------------------

Oops report #2.  The pci_map_mem() function in sym53c8xx calls ioremap()
while holding io_request_lock, which triggers the lockup.

ksymoops 2.4.4 on i686 2.4.21-rc1-debug.  Options used
     -V (default)
     -k 20030523004504.ksyms (specified)
     -l 20030523004504.modules (specified)
     -o /lib/modules/2.4.21-rc1-debug/ (default)
     -m /boot/System.map-2.4.21-rc1-debug (specified)

NMI Watchdog detected LOCKUP on CPU1, eip c011286b, registers:
CPU:    1
EIP:    0010:[<c011286b>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00000097
eax: 00000000   ebx: 00000001   ecx: cff360a8   edx: d082a000
esi: 00000001   edi: 0002a000   ebp: cf88dab0   esp: cf88da88
ds: 0018   es: 0018   ss: 0018
Process insmod (pid: 229, stackpage=cf88d000)
Stack: c01126b0 00000000 00000000 00000000 00000001 00010838 cf88dac0
c0195775
       0002a000 00400000 cf88dacc c0112724 c01126b0 00000000 00000001
00000001
       0002a000 cf88db00 c0115258 fc00b000 cff360a8 0002a000 fbfe1000
c0101d0c
Call Trace:    [<c01126b0>] [<c0195775>] [<c0112724>] [<c01126b0>]
[<c0115258>]
  [<c0115343>] [<d083c9bc>] [<d083f0ae>] [<d083fc8b>] [<d084a586>]
[<c01b87b7>]
  [<d084d9e0>] [<d083fe69>] [<d084d9e0>] [<d084d9e0>] [<c011bf26>]
[<d083c060>]
  [<c01076b3>]
Code: 39 d8 75 f9 85 f6 74 09 eb 00 8b 45 e4 39 d8 75 f9 81 3d ac

>>EIP; c011286b <smp_call_function+9b/f0>   <=====
Trace; c01126b0 <flush_tlb_all_ipi+0/60>
Trace; c0195775 <vt_console_print+2a5/2c0>
Trace; c0112724 <flush_tlb_all+14/80>
Trace; c01126b0 <flush_tlb_all_ipi+0/60>
Trace; c0115258 <remap_area_pages+208/220>
Trace; c0115343 <__ioremap+d3/f0>
Trace; d083c9bc <[sym53c8xx]pci_map_mem+3c/70>
Trace; d083f0ae <[sym53c8xx]sym_get_nvram+2e/60>
Trace; d083fc8b <[sym53c8xx]sym53c8xx_detect+35b/470>
Trace; d084a586 <[sym53c8xx].rodata.end+1b97/29b1>
Trace; c01b87b7 <scsi_register_host+97/360>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; d083fe69 <[sym53c8xx]init_this_scsi_driver+19/40>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; d084d9e0 <[sym53c8xx]driver_template+0/80>
Trace; c011bf26 <sys_init_module+596/680>
Trace; d083c060 <[sym53c8xx]sym_fw1_patch+0/60>
Trace; c01076b3 <system_call+33/38>
Code;  c011286b <smp_call_function+9b/f0>
00000000 <_EIP>:
Code;  c011286b <smp_call_function+9b/f0>   <=====
   0:   39 d8                     cmp    %ebx,%eax   <=====
Code;  c011286d <smp_call_function+9d/f0>
   2:   75 f9                     jne    fffffffd <_EIP+0xfffffffd> c0112868
<smp_call_function+98/f0>
Code;  c011286f <smp_call_function+9f/f0>
   4:   85 f6                     test   %esi,%esi
Code;  c0112871 <smp_call_function+a1/f0>
   6:   74 09                     je     11 <_EIP+0x11> c011287c
<smp_call_function+ac/f0>
Code;  c0112873 <smp_call_function+a3/f0>
   8:   eb 00                     jmp    a <_EIP+0xa> c0112875
<smp_call_function+a5/f0>
Code;  c0112875 <smp_call_function+a5/f0>
   a:   8b 45 e4                  mov    0xffffffe4(%ebp),%eax
Code;  c0112878 <smp_call_function+a8/f0>
   d:   39 d8                     cmp    %ebx,%eax
Code;  c011287a <smp_call_function+aa/f0>
   f:   75 f9                     jne    a <_EIP+0xa> c0112875
<smp_call_function+a5/f0>
Code;  c011287c <smp_call_function+ac/f0>
  11:   81 3d ac 00 00 00 00      cmpl   $0x0,0xac
Code;  c0112883 <smp_call_function+b3/f0>
  18:   00 00 00

----------------------------------------------------------------------

Kernel messages to go with oops #2, including some ioremap/iounmap printk()s
I added.

ioremap(0xFC006000, 8192)
ioremap(0xFC006000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 128)
ioremap(0xFC009000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC000000, 8192)
ioremap(0xFC000000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC00B000, 128)
ioremap(0xFC00B000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC002000, 8192)
ioremap(0xFC002000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC008000, 128)
ioremap(0xFC008000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC004000, 8192)
ioremap(0xFC004000, 8192) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC00A000, 128)
ioremap(0xFC00A000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 128)
ioremap(0xFC009000, 128) = 0xD081A000
iounmap(0xD081A000)
iounmap done
ioremap(0xFC009000, 256)
ioremap(0xFC009000, 256) = 0xD081A000
ioremap(0xFC006000, 8192)
ioremap(0xFC006000, 8192) = 0xD081C000
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym0: SCSI BUS has been reset.
ioremap(0xFC00B000, 128)
ioremap(0xFC00B000, 128) = 0xD081F000
iounmap(0xD081F000)
iounmap done
ioremap(0xFC00B000, 256)
ioremap(0xFC00B000, 256) = 0xD081F000
ioremap(0xFC000000, 8192)
ioremap(0xFC000000, 8192) = 0xD0821000
sym1: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
ioremap(0xFC008000, 128)
ioremap(0xFC008000, 128) = 0xD0824000
iounmap(0xD0824000)
iounmap done
ioremap(0xFC008000, 256)
ioremap(0xFC008000, 256) = 0xD0824000
ioremap(0xFC002000, 8192)
ioremap(0xFC002000, 8192) = 0xD0826000
sym2: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym2: open drain IRQ line driver, using on-chip SRAM
sym2: using LOAD/STORE-based firmware.
sym2: handling phase mismatch from SCRIPTS.
sym2: SCAN AT BOOT disabled for targets 0 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym2: SCSI BUS has been reset.
ioremap(0xFC00A000, 128)
--> The NMI watchdog oopses in the call to ioremap() above.

----------------------------------------------------------------------

