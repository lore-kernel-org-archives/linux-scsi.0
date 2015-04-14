From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Has anyone seen this?
Date: Tue, 14 Apr 2015 19:52:05 +0300
Message-ID: <552D45B5.1040801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34918 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbbDNQwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 12:52:08 -0400
Received: by wgyo15 with SMTP id o15so18973365wgy.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2015 09:52:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>

When I set up a DIX enabled device for the first time (say
scsi_debug) it all works, but when I remove it
and set it up again I get the below crash:

Reproducer:
$modprobe scsi_debug dif=1 dix=1
$modprobe -r scsi_debug
$modprobe scsi_debug dif=1 dix=1

It seems that somehow bdi_destroy() is not
invoked for DIX...

scsi_debug_init: dif_storep 131072 bytes @ ffffc90018507000 

scsi_debug: host protection DIF1 DIX1 

scsi host9: scsi_debug, version 1.85 [20141022], dev_size_mb=8, opts=0x0 

scsi 9:0:0:0: Direct-Access     Linux    scsi_debug       0184 PQ: 0 
ANSI: 6
sd 9:0:0:0: Attached scsi generic sg2 type 0 

sd 9:0:0:0: [sdc] Enabling DIF Type 1 protection 

sd 9:0:0:0: [sdc] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB) 

sd 9:0:0:0: [sdc] Write Protect is off 

sd 9:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 9:0:0:0: [sdc] Enabling DIX T10-DIF-TYPE1-CRC protection 

sd 9:0:0:0: [sdc] DIF application tag size 2 

sd 9:0:0:0: [sdc] Attached SCSI disk 

sd 9:0:0:0: [sdc] Synchronizing SCSI cache 

scsi_debug_init: dif_storep 131072 bytes @ ffffc900185e7000 

scsi_debug: host protection DIF1 DIX1 

scsi host10: scsi_debug, version 1.85 [20141022], dev_size_mb=8, 
opts=0x0
scsi 10:0:0:0: Direct-Access     Linux    scsi_debug       0184 PQ: 0 
ANSI: 6
sd 10:0:0:0: Attached scsi generic sg2 type 0 

sd 10:0:0:0: [sdc] Enabling DIF Type 1 protection 

sd 10:0:0:0: [sdc] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB) 

sd 10:0:0:0: [sdc] Write Protect is off 

sd 10:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
------------[ cut here ]------------
WARNING: CPU: 2 PID: 753 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x65/0x80()
sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:32'
---[ end trace 08a96f4c6fca987b ]---
------------[ cut here ]------------
WARNING: CPU: 2 PID: 753 at lib/kobject.c:240 
kobject_add_internal+0x194/0x1f0()
---[ end trace 08a96f4c6fca987c ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffff811cbede>] sysfs_do_create_link_sd+0x3e/0xc0
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: netconsole tcm_loop vhost_scsi vhost ib_srpt ib_isert 
iscsi_target_mod rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr tcm_fc 
libfc target_core_file target_core_iblock target_core_pscsi 
target_core_mod configfs nfsd exportfs nfsv3 nfs_acl rpcsec_gss_krb5 
auth_rpcgss nfsv4 nfs fscache lockd grace autofs4 sunrpc 
cpufreq_ondemand ipv6 ext4 jbd2 dm_mirror dm_region_hash dm_log uinput 
iTCO_wdt iTCO_vendor_support microcode serio_raw pcspkr ipmi_si 
ipmi_msghandler acpi_cpufreq sg sb_edac edac_core i2c_i801 lpc_ich 
mfd_core shpchp ioatdma igb dm_mod dca i2c_algo_bit i2c_core ptp 
pps_core wmi ext3(E) jbd(E) mbcache(E) sd_mod(E) ahci(E) libahci(E) 
isci(E) libsas(E) scsi_transport_sas(E) qla2xxx(E) scsi_transport_fc(E) 
[last unloaded: netconsole]
CPU: 4 PID: 753 Comm: kworker/u49:6 Tainted: G        W   E   4.0.0-rc1+ #38
Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
Workqueue: events_unbound async_run_entry_fn
task: ffff88046de44410 ti: ffff88046b754000 task.ti: ffff88046b754000
RIP: 0010:[<ffffffff811cbede>]  [<ffffffff811cbede>] 
sysfs_do_create_link_sd+0x3e/0xc0
RSP: 0018:ffff88046b757cf8  EFLAGS: 00010246
RAX: 00000000112e112e RBX: ffffffff817d2813 RCX: 0000000000000001
RDX: 000000000000112e RSI: 0000000000000010 RDI: ffffffff81e440c8
RBP: ffff88046b757d28 R08: ffff880468270f50 R09: 0000000000000040
R10: 0000000000000001 R11: 0000000000000010 R12: ffff880079b92988
R13: 0000000000000010 R14: 0000000000000001 R15: ffff88046fa0ae05
FS:  0000000000000000(0000) GS:ffff88047fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000040 CR3: 0000000001a0e000 CR4: 00000000000406e0
Stack:
  ffff88046b757d38 ffff88046ddea000 ffff88046b806008 ffff88046ddea080
  0000000000000000 ffff88046fa0ae05 ffff88046b757d38 ffffffff811cbfb1
  ffff88046b757d78 ffffffff81231c60 ffff88046b806008 008000206e800800
Call Trace:
  [<ffffffff811cbfb1>] sysfs_create_link+0x21/0x40
  [<ffffffff81231c60>] add_disk+0x1b0/0x310
  [<ffffffffa01306ec>] sd_probe_async+0x11c/0x1d0 [sd_mod]
  [<ffffffff8106d525>] async_run_entry_fn+0x55/0x160
  [<ffffffff81066126>] process_one_work+0x136/0x3a0
  [<ffffffff810664a7>] worker_thread+0x117/0x3b0
  [<ffffffff81066390>] ? process_one_work+0x3a0/0x3a0
  [<ffffffff81066390>] ? process_one_work+0x3a0/0x3a0
  [<ffffffff8106afbe>] kthread+0xce/0xf0
  [<ffffffff8106aef0>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff81542e6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106aef0>] ? kthread_freezable_should_stop+0x70/0x70
Code: 48 89 d3 4c 89 6d e8 4c 89 75 f0 49 89 fc 4c 89 7d f8 49 89 f5 41 
89 ce 74 6e 48 85 ff 74 69 48 c7 c7 c8 40 e4 81 e8 52 6b 37 00 <4d> 8b 
6d 30 4d 85 ed 74 08 4c 89 ef e8 01 c7 ff ff 66 83 05 d1
RIP  [<ffffffff811cbede>] sysfs_do_create_link_sd+0x3e/0xc0
  RSP <ffff88046b757cf8>
CR2: 0000000000000040
---[ end trace 08a96f4c6fca987d ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
