From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH 0/22] lpfc 8.1.2 driver update, crash in lpfc_worker_0
Date: Sun, 12 Feb 2006 15:57:36 +0100
Message-ID: <20060212145736.GA23765@suse.de>
References: <43EA10FC.3030008@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:11681 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750755AbWBLO5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 09:57:41 -0500
Content-Disposition: inline
In-Reply-To: <43EA10FC.3030008@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

 On Wed, Feb 08, James Smart wrote:

> This patch set updates the lpfc driver to revision 8.1.2, which includes

James, we have this driver now.
Today I got this crash during bootup on a p620 (4 RS64 cpus), it ran
-git9 before, now -git11. A quick look at the changes did not show
anything related.
both cpu1 and cpu3 had a invalid data access at the same time,
no idea which one came first.

It came up on after a second try.
Maybe there is an obvious error in the new code,
maybe 303 patches on top of Linus tree are bad.


...
Linux version 2.6.16-rc2-git11-20060212084234-ppc64 (geeko@buildhost) (gcc version 4.1.0 20060210 (prerelease) (SUSE Linux)) #1 SMP Sun Feb 12 08:42:34 UTC 2006
...
Kernel command line: root=/dev/md0 xmon=on kdb=on sysrq=1 selinux=0 elevator=cfq splash=silent desktop
...
Loading scsi_mod
SCSI subsystem initialized
Loading sd_mod
Loading scsi_transport_spi
Loading sym53c8xx
sym0: <896> rev 0x7 at pci 0000:01:01.0 irq 35
sym0: No NVRAM, ID 7, Fast-40, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.2
  Vendor: IBM       Model: CDRM00203     !K  Rev: 1_05
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target0:0:1: Beginning Domain Validation
 target0:0:1: asynchronous
 target0:0:1: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 target0:0:1: Domain Validation skipping write tests
 target0:0:1: Ending Domain Validation
 target0:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
  Vendor: IBM       Model: ST318305LC        Rev: C505
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:2: tagged command queuing enabled, command queue depth 16.
 target0:0:2: Beginning Domain Validation
 target0:0:2: asynchronous
 target0:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 31)
 target0:0:2: Domain Validation skipping write tests
 target0:0:2: Ending Domain Validation
sr0: scsi-1 drive
SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2
sd 0:0:2:0: Attached scsi disk sda
Uniform CD-ROM driver Revision: 3.20
scsi_id[1068]: ssr 0:0:1:0: Attached scsi generic sg0 type 5
csi_id: unable tsd 0:0:2:0: Attached scsi generic sg1 type 0
o access parent device of '/block/sda'
sym1: <896> rev 0x7 at pci 0000:01:01.1 irq 34
sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.2
Loading scsi_transport_fc
Loading lpfc
Emulex LightPulse Fibre Channel SCSI driver 8.1.2
Copyright(c) 2004-2006 Emulex.  All rights reserved.
scsi2 :  on PCI bus 21 device 08 irq 55
lpfc 0001:21:01.0: 0:1303 Link Up Event x1 received Data: x1 x1 x4 xa9
  Vendor: IBM       Model: 2105F20           Rev: 1.94
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 12500032 512-byte hdwr sectors (6400 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write back
SCSI device sdb: 12500032 512-byte hdwr sectors (6400 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3
md: raid0 personality registered for level 0
scsi_sid[1186]: d 2:0:0:0: Attached scsi disk sdb
csi_id: unable tsd 2:0:0:0: Attached scsi generic sg2 type 0
o access parent   Vendor: device of '/blocIk/sdb'
WaitingBM  for udev to set  tle: scsi_id[112]: scsi_id: una ble to access pa  rent device of  Model: /block/sdb'
2105F20           Rev: 1.94
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 12500032 512-byte hdwr sectors (6400 MB)
Decbpuug: 0x3 :s Velecteorpi: 30n0 (gD afutanc Atcicesos)n  acat l[cl0e00d 00fr00o3fm bib2envba0]
id   c o pnct: ecx0t0 a00t0 i00n00c052lu22dce/: l.inreusxc/hpaedg_etmaaps.k+0hx:314/06xc08       l

    lr: c000000000053adc: .try_to_wake_up+0x4a8/0x51c
    sp: c00000003fbb3130
   msr: a000000000001032
   dar: c00001800048acb0
 dsisr: 40000000
  current = 0xc0000000034d07f0
  paca    = 0xc00000000048b280
    pid   = 1167, comm = lpfc_worker_0
enter ? for help
[c00000003fbb31b0] c000000000053adc .try_to_wake_up+0x4a8/0x51c
[c00000003fbb3290] c000000000051c4c .__wake_up_common+0x68/0xe0
[c00000003fbb3340] c000000000055214 .__wake_up+0x54/0x88
[c00000003fbb33f0] c0000000002daafc .sock_def_readable+0x54/0xa8
[c00000003fbb3480] c00000000030115c .netlink_broadcast+0x344/0x50c
[c00000003fbb3560] c0000000001c6378 .kobject_uevent+0x41c/0x4dc
[c00000003fbb3650] c000000000251c94 .class_device_add+0x240/0x398
[c00000003fbb3700] c000000000254f74 .attribute_container_add_class_device+0x18/0x50
[c00000003fbb3780] c0000000002556c8 .transport_add_class_device+0x24/0x68
[c00000003fbb3810] c000000000254e3c .attribute_container_device_trigger+0x124/0x1c8
[c00000003fbb38d0] c0000000002555e0 .transport_add_device+0x1c/0x34
[c00000003fbb3950] d000000000052bb0 .fc_rport_create+0x270/0x36c [scsi_transport_fc]
[c00000003fbb3a10] d0000000001504c4 .lpfc_nlp_list+0x988/0xaf8 [lpfc]
[c00000003fbb3af0] d000000000158f68 .lpfc_cmpl_reglogin_reglogin_issue+0x150/0x174 [lpfc]
[c00000003fbb3b80] d000000000157a58 .lpfc_disc_state_machine+0xd4/0x1c8 [lpfc]
[c00000003fbb3c20] d000000000151510 .lpfc_mbx_cmpl_reg_login+0x44/0x94 [lpfc]
[c00000003fbb3cc0] d000000000144b40 .lpfc_sli_handle_mb_event+0x418/0x5c8 [lpfc]
[c00000003fbb3da0] d000000000152550 .lpfc_do_work+0x1c0/0xbf8 [lpfc]
[c00000003fbb3ee0] c000000000079250 .kthread+0x128/0x178
[c00000003fbb3f90] c000000000024adc .kernel_thread+0x4c/0x68
3:mon> cpu 0x1: Vector: 300 (Data Access) at [c00000002f806d30]
    pc: c00000000000ecdc: .validate_sp+0x30/0x88
    lr: c00000000000ee14: .show_stack+0xe0/0x1b0
    sp: c00000002f806fb0
   msr: a000000000001032
   dar: c000000600627b20
 dsisr: 40000000
  current = 0xc0000000fe9587f0
  paca    = 0xc00000000048ae80
    pid   = 1205, comm = vol_id


...
3:mon> e
cpu 0x3: Vector: 300 (Data Access) at [c00000003fbb2eb0]
    pc: c00000000005222c: .resched_task+0x34/0xc0
    lr: c000000000053adc: .try_to_wake_up+0x4a8/0x51c
    sp: c00000003fbb3130
   msr: a000000000001032
   dar: c00001800048acb0
 dsisr: 40000000
  current = 0xc0000000034d07f0
  paca    = 0xc00000000048b280
    pid   = 1167, comm = lpfc_worker_0
3:mon> t
[c00000003fbb31b0] c000000000053adc .try_to_wake_up+0x4a8/0x51c
[c00000003fbb3290] c000000000051c4c .__wake_up_common+0x68/0xe0
[c00000003fbb3340] c000000000055214 .__wake_up+0x54/0x88
[c00000003fbb33f0] c0000000002daafc .sock_def_readable+0x54/0xa8
[c00000003fbb3480] c00000000030115c .netlink_broadcast+0x344/0x50c
[c00000003fbb3560] c0000000001c6378 .kobject_uevent+0x41c/0x4dc
[c00000003fbb3650] c000000000251c94 .class_device_add+0x240/0x398
[c00000003fbb3700] c000000000254f74 .attribute_container_add_class_device+0x18/0x50
[c00000003fbb3780] c0000000002556c8 .transport_add_class_device+0x24/0x68
[c00000003fbb3810] c000000000254e3c .attribute_container_device_trigger+0x124/0x1c8
[c00000003fbb38d0] c0000000002555e0 .transport_add_device+0x1c/0x34
[c00000003fbb3950] d000000000052bb0 .fc_rport_create+0x270/0x36c [scsi_transport_fc]
[c00000003fbb3a10] d0000000001504c4 .lpfc_nlp_list+0x988/0xaf8 [lpfc]
[c00000003fbb3af0] d000000000158f68 .lpfc_cmpl_reglogin_reglogin_issue+0x150/0x174 [lpfc]
[c00000003fbb3b80] d000000000157a58 .lpfc_disc_state_machine+0xd4/0x1c8 [lpfc]
[c00000003fbb3c20] d000000000151510 .lpfc_mbx_cmpl_reg_login+0x44/0x94 [lpfc]
[c00000003fbb3cc0] d000000000144b40 .lpfc_sli_handle_mb_event+0x418/0x5c8 [lpfc]
[c00000003fbb3da0] d000000000152550 .lpfc_do_work+0x1c0/0xbf8 [lpfc]
[c00000003fbb3ee0] c000000000079250 .kthread+0x128/0x178
[c00000003fbb3f90] c000000000024adc .kernel_thread+0x4c/0x68
3:mon> r
R00 = c00000000048ac80   R16 = 0000000000000000
R01 = c00000003fbb3130   R17 = 0000000000000000
R02 = c000000000625be0   R18 = 0000000000000000
R03 = c0000000fe9587f0   R19 = c00000000fdbca08
R04 = c000000004a55140   R20 = 0000000000000000
R05 = 0000000000000000   R21 = 0000000000000001
R06 = c000000004a6cf70   R22 = 0000000000000001
R07 = c000000003393870   R23 = a000000000001032
R08 = c0000000fe9587f0   R24 = 0000000000000003
R09 = c00001800048ac80   R25 = c0000000035a87f0
R10 = c000000004a55850   R26 = 0000000000000001
R11 = c0000000004341c0   R27 = 0000000000000001
R12 = 0000000000000000   R28 = c000000004a54f70
R13 = c00000000048b280   R29 = 0000000000000001
R14 = 0000000000000000   R30 = c0000000004c7e78
R15 = 0000000000000000   R31 = c000000004a550c0
pc  = c00000000005222c .resched_task+0x34/0xc0
lr  = c000000000053adc .try_to_wake_up+0x4a8/0x51c
msr = a000000000001032   cr  = 24000088
ctr = c000000000053b50   xer = 0000000020000000   trap =  300
dar = c00001800048acb0   dsisr = 40000000

cpu2 idle.

1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c00000002f806d30]
    pc: c00000000000ecdc: .validate_sp+0x30/0x88
    lr: c00000000000ee14: .show_stack+0xe0/0x1b0
    sp: c00000002f806fb0
   msr: a000000000001032
   dar: c000000600627b20
 dsisr: 40000000
  current = 0xc0000000fe9587f0
  paca    = 0xc00000000048ae80
    pid   = 1205, comm = vol_id
1:mon> t
[link register   ] c00000000000ee14 .show_stack+0xe0/0x1b0
[c00000002f806fb0] c00000000000ee00 .show_stack+0xcc/0x1b0 (unreliable)
[c00000002f807050] c0000000001cb214 ._raw_spin_lock+0x120/0x164
[c00000002f8070e0] c00000000036bf44 ._spin_lock+0x10/0x24
[c00000002f807160] c00000000005440c .scheduler_tick+0xf4/0x3ec
[c00000002f807210] c00000000006aa44 .update_process_times+0x7c/0xa8
[c00000002f8072a0] c000000000021100 .timer_interrupt+0x94/0x404
[c00000002f807380] c0000000000034b4 decrementer_common+0xb4/0x100
--- Exception: 901 (Decrementer) at c00000000005cd64 .release_console_sem+0x1c4/0x284
[c00000002f807720] c00000000005d7dc .vprintk+0x330/0x388
[c00000002f807840] c00000000005d86c .printk+0x38/0x48
[c00000002f8078d0] c0000000000524e4 .__might_sleep+0x98/0xf4
[c00000002f807950] c000000000092468 .do_generic_mapping_read+0x1fc/0x4dc
[c00000002f807aa0] c00000000009307c .__generic_file_aio_read+0x184/0x22c
[c00000002f807b70] c00000000009487c .generic_file_read+0x94/0xcc
[c00000002f807cf0] c0000000000c42f0 .vfs_read+0x118/0x1fc
[c00000002f807d90] c0000000000c47d0 .sys_read+0x4c/0x8c
[c00000002f807e30] c0000000000086f8 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff5cc68
SP (ffd46a00) is in userspace
1:mon> r
R00 = 0000000600000000   R16 = c00000002f807e08
R01 = c00000002f806fb0   R17 = 00000000000200e3
R02 = c000000000625be0   R18 = c0000000005eaa90
R03 = c00000002f807d90   R19 = c0000000fed52c50
R04 = c0000000fe9587f0   R20 = 0000000000000000
R05 = 00000000000002f0   R21 = c00000002f807b10
R06 = c00000002f806fe8   R22 = 00000000000200e4
R07 = 0000000000080000   R23 = 0000000000000800
R08 = 0000000000002b02   R24 = c000000000629f50
R09 = c000000000627b20   R25 = 0000000000000001
R10 = 0000000000000000   R26 = c00000002f807e30
R11 = c00000002f804000   R27 = 000000000000000f
R12 = 0000000000000020   R28 = c00000000005cd60
R13 = c00000000048ae80   R29 = c00000002f807d90
R14 = 00000000000200e3   R30 = c0000000fe9587f0
R15 = c00000003fa1c508   R31 = c0000000000c47d0
pc  = c00000000000ecdc .validate_sp+0x30/0x88
lr  = c00000000000ee14 .show_stack+0xe0/0x1b0
msr = a000000000001032   cr  = 88022444
ctr = 0000000000000000   xer = 0000000000000000   trap =  300
dar = c000000600627b20   dsisr = 40000000

cpu0 idle


looking into dmesg, its not clear anymore if lpfc is at fault:

<6>md: raid0 personality registered for level 0
<5>sd 2:0:0:0: Attached scsi disk sdb
<5>sd 2:0:0:0: Attached scsi generic sg2 type 0
<5>  Vendor: IBM       Model: 2105F20           Rev: 1.94
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<5>SCSI device sdc: 12500032 512-byte hdwr sectors (6400 MB)
<3>Debug: sleeping function called from invalid context at include/linux/pagemap.h:168
<1>Unable to handle kernel paging request for data at address 0xc00001800048acb0
<1>Faulting instruction address: 0xc00000000005222c
<0>BUG: spinlock lockup on CPU#1, vol_id/1205, c000000004a550c0
<4>Call Trace:
<4>[C00000002F806FB0] [C00000000000ED9C] .show_stack+0x68/0x1b0 (unreliable)
<4>[C00000002F807050] [C0000000001CB214] ._raw_spin_lock+0x120/0x164
<4>[C00000002F8070E0] [C00000000036BF44] ._spin_lock+0x10/0x24
<4>[C00000002F807160] [C00000000005440C] .scheduler_tick+0xf4/0x3ec
<4>[C00000002F807210] [C00000000006AA44] .update_process_times+0x7c/0xa8
<4>[C00000002F8072A0] [C000000000021100] .timer_interrupt+0x94/0x404
<4>[C00000002F807380] [C0000000000034B4] decrementer_common+0xb4/0x100
<4>--- Exception: 901 at .release_console_sem+0x1c4/0x284
<4>    LR = .release_console_sem+0x1c0/0x284
<4>[C00000002F807720] [C00000000005D7DC] .vprintk+0x330/0x388
<4>[C00000002F807840] [C00000000005D86C] .printk+0x38/0x48
<4>[C00000002F8078D0] [C0000000000524E4] .__might_sleep+0x98/0xf4
<4>[C00000002F807950] [C000000000092468] .do_generic_mapping_read+0x1fc/0x4dc
<4>[C00000002F807AA0] [C00000000009307C] .__generic_file_aio_read+0x184/0x22c
<4>[C00000002F807B70] [C00000000009487C] .generic_file_read+0x94/0xcc
<4>[C00000002F807CF0] [C0000000000C42F0] .vfs_read+0x118/0x1fc
<4>[C00000002F807D90] [C0000000000C47D0] .sys_read+0x4c/0x8c
<1>Unable to handle kernel paging request for data at address 0xc000000600627b20
<1>Faulting instruction address: 0xc00000000000ecdc
0:mon> 

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
