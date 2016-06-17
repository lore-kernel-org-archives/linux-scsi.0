From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: Kernel panics while creating RAID volume on latest stable 4.6.2
 kernel beacuse of "[PATCH v2 3/3] ses: fix discovery of SATA devices in SAS enclosures"
Date: Fri, 17 Jun 2016 16:03:39 +0530
Message-ID: <489156e657bf7073e9e37a5d1112cf14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hi,
 Try creating RAID volume on latest stable 4.6.2 kernel, as soon as the
volume gets created kernel panics , below are the logs...

Carried out same experimentation on 4.4.13 kernel, issue was not
observed.After learning diff b/w 4.4.13 & 4.6.2 kernels "[PATCH v2  3/3]
ses: fix discovery of SATA devices in SAS enclosures" patch looks to be
suspicious.
commit 3f8d6f2a0797e8c650a47e5c1b5c2601a46f4293

And hence reverted above mentioned patch changes from 4.6.2 kernel and
tried volume creation, volume created successfully and issue is not
observed.

>>Kernel panic logs:

root@dhcp-135-24-192-112 ~]# sd 0:1:0:0: [sdw] No Caching mode page found
sd 0:1:0:0: [sdw] Assuming drive cache: write through
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_transport_sas.c:164!
invalid opcode: 0000 [#1] SMP
Modules linked in: mptctl mptbase ses enclosure ebtable_nat ebtables
xt_CHECKSUM iptable_mangle bridge autofs4 8021q garp stp llc ipt_REJECT
nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables
ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 vhost_net macvtap macvlan
vhost tun kvm_intel kvm irqbypass uinput ipmi_devintf iTCO_wdt
iTCO_vendor_support dcdbas pcspkr ipmi_si ipmi_msghandler acpi_pad sb_edac
edac_core wmi sg lpc_ich mfd_core shpchp tg3 ptp pps_core joydev ioatdma
dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) ahci(E) libahci(E) mpt3sas(E)
scsi_transport_sas(E) raid_class(E) dm_mirror(E) dm_region_hash(E)
dm_log(E) dm_mod(E) [last unloaded: speedstep_lib]
CPU: 1 PID: 375 Comm: kworker/u96:4 Tainted: G            E   4.6.2 #1
Hardware name: Dell Inc. PowerEdge T420/03015M, BIOS 2.2.0 02/06/2014
Workqueue: fw_event_mpt3sas0 _firmware_event_work [mpt3sas]
task: ffff8800377f6480 ti: ffff8800c62c8000 task.ti: ffff8800c62c8000
RIP: 0010:[<ffffffffa0041706>]  [<ffffffffa0041706>]
sas_get_address+0x26/0x30 [scsi_transport_sas]
RSP: 0018:ffff8800c62cb8a8  EFLAGS: 00010282
RAX: ffff8800c6986208 RBX: ffff8800b04ec800 RCX: ffff8800b3deaac4
RDX: 000000000000002b RSI: 0000000000000000 RDI: ffff8800b04ec800
RBP: ffff8800c62cb8a8 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800b04ec800
R13: 0000000000000000 R14: ffff8800b04ec998 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012f020000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c06000 CR4: 00000000000406e0
Stack:
 ffff8800c62cb8d8 ffffffffa066bc62 0000000000000000 0000000000000000
 ffff8800b04ecc68 ffff880128ee8000 ffff8800c62cb938 ffffffffa066bd5c
 ffff8800b04ecef8 ffffffff81608333 ffff8800b04ec800 ffff8800b04ecc68
Call Trace:
 [<ffffffffa066bc62>] ses_match_to_enclosure+0x72/0x80 [ses]
 [<ffffffffa066bd5c>] ses_intf_add+0xec/0x494 [ses]
 [<ffffffff81608333>] ? preempt_schedule_common+0x23/0x40
 [<ffffffff813f4978>] device_add+0x278/0x440
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8143110e>] scsi_sysfs_add_sdev+0xee/0x2b0
 [<ffffffff8142d2a7>] scsi_add_lun+0x437/0x580
 [<ffffffff8142defb>] scsi_probe_and_add_lun+0x1bb/0x4e0
 [<ffffffff813f21b9>] ? get_device+0x19/0x20
 [<ffffffff8142e8e3>] ? scsi_alloc_target+0x293/0x320
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8142eb2f>] __scsi_add_device+0x10f/0x130
 [<ffffffff8142eb61>] scsi_add_device+0x11/0x30
 [<ffffffffa0067039>] _scsih_sas_volume_add+0xf9/0x1b0 [mpt3sas]
 [<ffffffffa00678db>] _scsih_sas_ir_config_change_event+0xdb/0x210
[mpt3sas]
 [<ffffffffa0067ad1>] _mpt3sas_fw_work+0xc1/0x480 [mpt3sas]
 [<ffffffff81080010>] ? pwq_dec_nr_in_flight+0x50/0xa0
 [<ffffffffa0067ea9>] _firmware_event_work+0x19/0x20 [mpt3sas]
 [<ffffffff810809a9>] process_one_work+0x189/0x4e0
 [<ffffffff810cd7ec>] ? del_timer_sync+0x4c/0x60
 [<ffffffff810818fe>] ? maybe_create_worker+0x8e/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081aed>] worker_thread+0x16d/0x520
 [<ffffffff81090cb2>] ? default_wake_function+0x12/0x20
 [<ffffffff810a5916>] ? __wake_up_common+0x56/0x90
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8108666c>] kthread+0xcc/0xf0
 [<ffffffff8108ff6e>] ? schedule_tail+0x1e/0xc0
 [<ffffffff8160bc52>] ret_from_fork+0x22/0x40
 [<ffffffff810865a0>] ? kthread_freezable_should_stop+0x70/0x70
Code: 0f 1f 44 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 28 01 00 00 48 8b
40 28 83 b8 d0 02 00 00 01 75 09 48 8b 80 e0 02 00 00 c9 c3 <0f> 0b eb fe
66 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66
RIP  [<ffffffffa0041706>] sas_get_address+0x26/0x30 [scsi_transport_sas]
 RSP <ffff8800c62cb8a8>
---[ end trace c8c9da69e1dcb8a1 ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81086210>] kthread_data+0x10/0x20
PGD 1c07067 PUD 1c09067 PMD 0
Oops: 0000 [#2] SMP
Modules linked in: mptctl mptbase ses enclosure ebtable_nat ebtables
xt_CHECKSUM iptable_mangle bridge autofs4 8021q garp stp llc ipt_REJECT
nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables
ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 vhost_net macvtap macvlan
vhost tun kvm_intel kvm irqbypass uinput ipmi_devintf iTCO_wdt
iTCO_vendor_support dcdbas pcspkr ipmi_si ipmi_msghandler acpi_pad sb_edac
edac_core wmi sg lpc_ich mfd_core shpchp tg3 ptp pps_core joydev ioatdma
dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) ahci(E) libahci(E) mpt3sas(E)
scsi_transport_sas(E) raid_class(E) dm_mirror(E) dm_region_hash(E)
dm_log(E) dm_mod(E) [last unloaded: speedstep_lib]
CPU: 3 PID: 375 Comm: kworker/u96:4 Tainted: G      D     E   4.6.2 #1
Hardware name: Dell Inc. PowerEdge T420/03015M, BIOS 2.2.0 02/06/2014
task: ffff8800377f6480 ti: ffff8800c62c8000 task.ti: ffff8800c62c8000
RIP: 0010:[<ffffffff81086210>]  [<ffffffff81086210>]
kthread_data+0x10/0x20
RSP: 0018:ffff8800c62cb3e8  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff88012f0755c0 RCX: 0000000000000003
RDX: ffff8800377f6480 RSI: ffff8800377f6480 RDI: ffff8800377f6480
RBP: ffff8800c62cb3e8 R08: ffff8800377f6528 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8800377f6e20 R14: 0000000000000001 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff88012f060000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 00000000c43d4000 CR4: 00000000000406e0
Stack:
 ffff8800c62cb418 ffffffff8107dd32 ffffe8ff00000000 ffff88012f0755c0
 0000000000000000 ffff8800377f6e20 ffff8800c62cb528 ffffffff81607f70
 ffff8800377f6480 0000000000000296 ffff8800c78dff58 ffffffff812d2515
Call Trace:
 [<ffffffff8107dd32>] wq_worker_sleeping+0x12/0xa0
 [<ffffffff81607f70>] __schedule+0x510/0x8b0
 [<ffffffff812d2515>] ? cfq_put_queue+0xe5/0x280
 [<ffffffff810c97e7>] ? call_rcu_sched+0x17/0x20
 [<ffffffff8106a923>] ? release_task+0xf3/0x160
 [<ffffffff812b1601>] ? put_io_context+0x81/0xc0
 [<ffffffff812d2c95>] ? cfq_exit_cfqq+0x35/0x60
 [<ffffffff81608470>] schedule+0x40/0xb0
 [<ffffffff812b1b4f>] ? exit_io_context+0x3f/0x50
 [<ffffffff8106b594>] do_exit+0x2b4/0x4e0
 [<ffffffff810b94bb>] ? kmsg_dump+0x9b/0xc0
 [<ffffffff81022daf>] oops_end+0x9f/0xe0
 [<ffffffff81022eeb>] die+0x5b/0x90
 [<ffffffff81020171>] do_trap+0x161/0x170
 [<ffffffff810204f8>] do_error_trap+0xb8/0xf0
 [<ffffffffa0041706>] ? sas_get_address+0x26/0x30 [scsi_transport_sas]
 [<ffffffffa066b384>] ? ses_recv_diag+0x74/0xc0 [ses]
 [<ffffffff81020640>] do_invalid_op+0x20/0x30
 [<ffffffff8160d388>] invalid_op+0x18/0x20
 [<ffffffffa0041706>] ? sas_get_address+0x26/0x30 [scsi_transport_sas]
 [<ffffffffa066bc62>] ses_match_to_enclosure+0x72/0x80 [ses]
 [<ffffffffa066bd5c>] ses_intf_add+0xec/0x494 [ses]
 [<ffffffff81608333>] ? preempt_schedule_common+0x23/0x40
 [<ffffffff813f4978>] device_add+0x278/0x440
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8143110e>] scsi_sysfs_add_sdev+0xee/0x2b0
 [<ffffffff8142d2a7>] scsi_add_lun+0x437/0x580
 [<ffffffff8142defb>] scsi_probe_and_add_lun+0x1bb/0x4e0
 [<ffffffff813f21b9>] ? get_device+0x19/0x20
 [<ffffffff8142e8e3>] ? scsi_alloc_target+0x293/0x320
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8142eb2f>] __scsi_add_device+0x10f/0x130
 [<ffffffff8142eb61>] scsi_add_device+0x11/0x30
 [<ffffffffa0067039>] _scsih_sas_volume_add+0xf9/0x1b0 [mpt3sas]
 [<ffffffffa00678db>] _scsih_sas_ir_config_change_event+0xdb/0x210
[mpt3sas]
 [<ffffffffa0067ad1>] _mpt3sas_fw_work+0xc1/0x480 [mpt3sas]
 [<ffffffff81080010>] ? pwq_dec_nr_in_flight+0x50/0xa0
 [<ffffffffa0067ea9>] _firmware_event_work+0x19/0x20 [mpt3sas]
 [<ffffffff810809a9>] process_one_work+0x189/0x4e0
 [<ffffffff810cd7ec>] ? del_timer_sync+0x4c/0x60
 [<ffffffff810818fe>] ? maybe_create_worker+0x8e/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081aed>] worker_thread+0x16d/0x520
 [<ffffffff81090cb2>] ? default_wake_function+0x12/0x20
 [<ffffffff810a5916>] ? __wake_up_common+0x56/0x90
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8108666c>] kthread+0xcc/0xf0
 [<ffffffff8108ff6e>] ? schedule_tail+0x1e/0xc0
 [<ffffffff8160bc52>] ret_from_fork+0x22/0x40
 [<ffffffff810865a0>] ? kthread_freezable_should_stop+0x70/0x70
Code: 40 09 00 00 48 8b 40 c8 c9 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00
00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 40 09 00 00 <48> 8b 40 d8
c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
RIP  [<ffffffff81086210>] kthread_data+0x10/0x20
 RSP <ffff8800c62cb3e8>
CR2: ffffffffffffffd8
---[ end trace c8c9da69e1dcb8a2 ]---
Fixing recursive fault but reboot is needed!
NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
Modules linked in: mptctl mptbase ses enclosure ebtable_nat ebtables
xt_CHECKSUM iptable_mangle bridge autofs4 8021q garp stp llc ipt_REJECT
nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filterINFO:
rcu_sched detected stalls on CPUs/tasks:
        3-...: (2 GPs behind) idle=24d/140000000000000/0
softirq=12337/12338 fqs=6999
        (detected by 1, t=21002 jiffies, g=10149, c=10148, q=696)
Task dump for CPU 3:
kworker/u96:4   D ffff8800c62cb418     0   375      0 0x00000008
 ffffffff8107dd32 ffffe8ff00000000 ffff88012f0755c0 0000000000000000
 ffff8800377f6e20 ffff8800c62cb528 ffffffff81607f70 ffff8800377f6480
 0000000000000296 ffff8800c78dff58 ffffffff812d2515 ffff880000000042
Call Trace:
 [<ffffffff8107dd32>] ? wq_worker_sleeping+0x12/0xa0
 [<ffffffff81607f70>] ? __schedule+0x510/0x8b0
 [<ffffffff812d2515>] ? cfq_put_queue+0xe5/0x280
 [<ffffffff810c97e7>] ? call_rcu_sched+0x17/0x20
 [<ffffffff8106a923>] ? release_task+0xf3/0x160
 [<ffffffff812b1601>] ? put_io_context+0x81/0xc0
 [<ffffffff812d2c95>] ? cfq_exit_cfqq+0x35/0x60
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff812b1b4f>] ? exit_io_context+0x3f/0x50
 [<ffffffff8106b594>] ? do_exit+0x2b4/0x4e0
 [<ffffffff810b94bb>] ? kmsg_dump+0x9b/0xc0
 [<ffffffff81022daf>] ? oops_end+0x9f/0xe0
 [<ffffffff81022eeb>] ? die+0x5b/0x90
 [<ffffffff81020171>] ? do_trap+0x161/0x170
 [<ffffffff810204f8>] ? do_error_trap+0xb8/0xf0
 [<ffffffffa0041706>] ? sas_get_address+0x26/0x30 [scsi_transport_sas]
 [<ffffffffa066b384>] ? ses_recv_diag+0x74/0xc0 [ses]
 [<ffffffff81020640>] ? do_invalid_op+0x20/0x30
 [<ffffffff8160d388>] ? invalid_op+0x18/0x20
 [<ffffffffa0041706>] ? sas_get_address+0x26/0x30 [scsi_transport_sas]
 [<ffffffffa066bc62>] ? ses_match_to_enclosure+0x72/0x80 [ses]
 [<ffffffffa066bd5c>] ? ses_intf_add+0xec/0x494 [ses]
 [<ffffffff81608333>] ? preempt_schedule_common+0x23/0x40
 [<ffffffff813f4978>] ? device_add+0x278/0x440
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8143110e>] ? scsi_sysfs_add_sdev+0xee/0x2b0
 [<ffffffff8142d2a7>] ? scsi_add_lun+0x437/0x580
 [<ffffffff8142defb>] ? scsi_probe_and_add_lun+0x1bb/0x4e0
 [<ffffffff813f21b9>] ? get_device+0x19/0x20
 [<ffffffff8142e8e3>] ? scsi_alloc_target+0x293/0x320
 [<ffffffff814038dc>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8142eb2f>] ? __scsi_add_device+0x10f/0x130
 [<ffffffff8142eb61>] ? scsi_add_device+0x11/0x30
 [<ffffffffa0067039>] ? _scsih_sas_volume_add+0xf9/0x1b0 [mpt3sas]
 [<ffffffffa00678db>] ? _scsih_sas_ir_config_change_event+0xdb/0x210
[mpt3sas]
 [<ffffffffa0067ad1>] ? _mpt3sas_fw_work+0xc1/0x480 [mpt3sas]
 [<ffffffff81080010>] ? pwq_dec_nr_in_flight+0x50/0xa0
 [<ffffffffa0067ea9>] ? _firmware_event_work+0x19/0x20 [mpt3sas]
 [<ffffffff810809a9>] ? process_one_work+0x189/0x4e0
 [<ffffffff810cd7ec>] ? del_timer_sync+0x4c/0x60
 [<ffffffff810818fe>] ? maybe_create_worker+0x8e/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081aed>] ? worker_thread+0x16d/0x520
 [<ffffffff81090cb2>] ? default_wake_function+0x12/0x20
 [<ffffffff810a5916>] ? __wake_up_common+0x56/0x90
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff81081980>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8108666c>] ? kthread+0xcc/0xf0
 [<ffffffff8108ff6e>] ? schedule_tail+0x1e/0xc0
 [<ffffffff8160bc52>] ? ret_from_fork+0x22/0x40
 [<ffffffff810865a0>] ? kthread_freezable_should_stop+0x70/0x70

 ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6
xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vhost_net macvtap
macvlan vhost tun kvm_intel kvm irqbypass uinput ipmi_devintf iTCO_wdt
iTCO_vendor_support dcdbas pcspkr ipmi_si ipmi_msghandler acpi_pad sb_edac
edac_core wmi sg lpc_ich mfd_core shpchp tg3 ptp pps_core joydev ioatdma
dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) ahci(E) libahci(E) mpt3sas(E)
scsi_transport_sas(E) raid_class(E) dm_mirror(E) dm_region_hash(E)
dm_log(E) dm_mod(E) [last unloaded: speedstep_lib]
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D     E   4.6.2 #1
Hardware name: Dell Inc. PowerEdge T420/03015M, BIOS 2.2.0 02/06/2014
task: ffffffff81c0b500 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff814ed4db>]  [<ffffffff814ed4db>]
cpuidle_enter_state+0xbb/0x2e0
RSP: 0018:ffffffff81c03de8  EFLAGS: 00000206
RAX: ffff88012f0155c0 RBX: ffffe8ffff809fd0 RCX: 0000000000000018
RDX: 0000000000000000 RSI: ffffffff81c04000 RDI: 0000000000000000
RBP: ffffffff81c03e68 R08: 0000000000000378 R09: 071c71c71c71c71c
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 00000000000f3af3 R14: ffffffff81cb2c18 R15: 0000003169a7cd47
FS:  0000000000000000(0000) GS:ffff88012f000000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f52e1ac174b CR3: 0000000001c06000 CR4: 00000000000406f0
Stack:
 00ffffff81c03e68 0000000000000000 ffffffff00000000 00000000810cfcce
 0000000000000000 7fffffffffffffff ffffffff00000000 ffffffff814ee9c3
 ffffffff00000000 0000037981097a85 0000000000000000 ffffe8ffff809fd0
Call Trace:
 [<ffffffff814ee9c3>] ? menu_select+0x103/0x3a0
 [<ffffffff814ed717>] cpuidle_enter+0x17/0x20
 [<ffffffff810a68ce>] call_cpuidle+0x2e/0x40
 [<ffffffff810a6948>] cpuidle_idle_call+0x68/0x100
 [<ffffffff810a6b35>] cpu_idle_loop+0x155/0x240
 [<ffffffff81090cb2>] ? default_wake_function+0x12/0x20
 [<ffffffff81608470>] ? schedule+0x40/0xb0
 [<ffffffff810a6c41>] cpu_startup_entry+0x21/0x30
 [<ffffffff81600fb7>] rest_init+0x77/0x80
 [<ffffffff81d47348>] start_kernel+0x3c8/0x3ca
 [<ffffffff81d46da2>] ? set_init_arg+0x5f/0x5f
 [<ffffffff81d463b2>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81d466a2>] x86_64_start_kernel+0xee/0xf5
Code: 05 33 f2 80 00 8b 53 04 85 c0 89 55 8c 89 45 b0 0f 8f 55 01 00 00 31
ff e8 b3 92 bb ff 80 7d 87 00 0f 85 d6 00 00 00 fb 4d 29 fd <48> ba cf f7
53 e3 a5 9b c4 20 4c 89 e8 49 c1 fd 3f 48 f7 ea b8
Kernel panic - not syncing: Hard LOCKUP
Shutting down cpus with NMI
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Hard LOCKUP



Topology:
 Gen3 card(LSI Logic SAS3108) , An enclosure with set of drives connected
behind Gen3 card

Thanks,
 Chaitra
