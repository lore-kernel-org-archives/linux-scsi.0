From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v3
Date: Thu, 5 May 2016 16:40:16 -0400
Message-ID: <572BAFB0.2020305@stratus.com>
References: <56F9A22F.7020002@sandisk.com> <572BA5EF.6000702@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:53352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755906AbcEEUzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2016 16:55:19 -0400
In-Reply-To: <572BA5EF.6000702@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/05/2016 03:58 PM, Bart Van Assche wrote:
> On 03/28/2016 02:29 PM, Bart Van Assche wrote:
>> Avoid that the sd driver registers a BDI device with a name that
>> is still in use. This patch avoids that the following warning gets
>> triggered:
>>
>> [ ... ]
> 
> (replying to my own e-mail)
> 
> If anyone could review this patch that would be very welcome.

Hi Bart,

I *think* I may be hitting this same problem running some tests here at Stratus -- I've got slub_debugging and other kernel debugging turned on while repeatedly hotplugging controllers at various timings during probe.  It takes hours to hit, but I've seen it twice in the past week.  I've got some other testing on my plate at the moment, but when I get a chance I can give your v3 a spin.

Here's an example (sorry for the wide width) ...

------------[ cut here ]------------
WARNING: CPU: 5 PID: 30702 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
sysfs: cannot create duplicate filename '/devices/virtual/bdi/65:0'
Modules linked in: btrfs xor raid6_pq msdos ext4 jbd2 mbcache matroxfb(OE) ccmod(POE) ftmod(OE) videosw(OE) ipmi_devintf fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack bonding ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter vfat fat x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper cryptd dm_service_time pcspkr ses enclosure
  sg wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c raid1 sr_mod cdrom crc32c_intel qla2xxx(OE) scsi_transport_fc ixgbe(OE) mdio igb(OE) ptp pps_core mpt3sas(OE) 
raid_class i2c_algo_bit sra_sense(OE) i2c_core sd_mod(OE) scsi_transport_sas dca scsi_hbas(OE) fjes ipmi_msghandler usb_storage dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_devintf]
CPU: 5 PID: 30702 Comm: kworker/u97:7 Tainted: P        W  OE   4.6.0-rc6+ #37
Hardware name: Stratus ftServer 6800/G7LYY, BIOS BIOS Version 8.1:64 02/03/2016
Workqueue: events_unbound async_run_entry_fn
 0000000000000286 00000000e136f6f8 ffff88038ae03a50 ffffffff8134359f
 ffff88038ae03aa0 0000000000000000 ffff88038ae03a90 ffffffff8108af31
 0000001f5bdb0398 ffff880067e0e7e8 ffff88058f92def0 ffff88084bd2c008
Call Trace:
 [<ffffffff8134359f>] dump_stack+0x63/0x84
 [<ffffffff8108af31>] __warn+0xd1/0xf0
 [<ffffffff8108afaf>] warn_slowpath_fmt+0x5f/0x80
 [<ffffffff81297604>] sysfs_warn_dup+0x64/0x80
 [<ffffffff812976ee>] sysfs_create_dir_ns+0x7e/0x90
 [<ffffffff8134653a>] kobject_add_internal+0xaa/0x320
 [<ffffffff8146bf93>] ? device_private_init+0x23/0x70
 [<ffffffff813469e5>] kobject_add+0x75/0xd0
 [<ffffffff816a9cd2>] ? mutex_lock+0x12/0x2f
 [<ffffffff8146c105>] device_add+0x125/0x610
 [<ffffffff8146c7e8>] device_create_groups_vargs+0xd8/0x100
 [<ffffffff8146c82c>] device_create_vargs+0x1c/0x20
 [<ffffffff811b209c>] bdi_register+0x8c/0x180
 [<ffffffff811b21b7>] bdi_register_dev+0x27/0x30
 [<ffffffff81327e7f>] add_disk+0x17f/0x4a0
 [<ffffffff8147b955>] ? update_autosuspend+0x55/0x60
 [<ffffffff8147ba14>] ? __pm_runtime_use_autosuspend+0x54/0x70
 [<ffffffffa00a1a25>] sd_probe_async+0x115/0x1d0 [sd_mod]
 [<ffffffff810ad80a>] async_run_entry_fn+0x4a/0x140
 [<ffffffff810a464e>] process_one_work+0x16e/0x420
 [<ffffffff810a4f45>] worker_thread+0x125/0x4b0
 [<ffffffff816a780d>] ? __schedule+0x2ad/0x8a0
 [<ffffffff810a4e20>] ? rescuer_thread+0x380/0x380
 [<ffffffff810aa9b8>] kthread+0xd8/0xf0
 [<ffffffff816abb42>] ret_from_fork+0x22/0x40
 [<ffffffff810aa8e0>] ? kthread_park+0x60/0x60
---[ end trace 353add4e78cb2a75 ]---
------------[ cut here ]------------
WARNING: CPU: 5 PID: 30702 at lib/kobject.c:240 kobject_add_internal+0x262/0x320
kobject_add_internal failed for 65:0 with -EEXIST, don't try to register things with the same name in the same directory.
Modules linked in: btrfs xor raid6_pq msdos ext4 jbd2 mbcache matroxfb(OE) ccmod(POE) ftmod(OE) videosw(OE) ipmi_devintf fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack bonding ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter vfat fat x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper cryptd dm_service_time pcspkr ses enclosure
  sg wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c raid1 sr_mod cdrom crc32c_intel qla2xxx(OE) scsi_transport_fc ixgbe(OE) mdio igb(OE) ptp pps_core mpt3sas(OE) 
raid_class i2c_algo_bit sra_sense(OE) i2c_core sd_mod(OE) scsi_transport_sas dca scsi_hbas(OE) fjes ipmi_msghandler usb_storage dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_devintf]
CPU: 5 PID: 30702 Comm: kworker/u97:7 Tainted: P        W  OE   4.6.0-rc6+ #37
Hardware name: Stratus ftServer 6800/G7LYY, BIOS BIOS Version 8.1:64 02/03/2016
Workqueue: events_unbound async_run_entry_fn
 0000000000000286 00000000e136f6f8 ffff88038ae03aa0 ffffffff8134359f
 ffff88038ae03af0 0000000000000000 ffff88038ae03ae0 ffffffff8108af31
 000000f08129760c ffff880853a4f4f8 ffff88003b529e68 00000000ffffffef
Call Trace:
 [<ffffffff8134359f>] dump_stack+0x63/0x84
 [<ffffffff8108af31>] __warn+0xd1/0xf0
 [<ffffffff8108afaf>] warn_slowpath_fmt+0x5f/0x80
 [<ffffffff813466f2>] kobject_add_internal+0x262/0x320
 [<ffffffff8146bf93>] ? device_private_init+0x23/0x70
 [<ffffffff813469e5>] kobject_add+0x75/0xd0
 [<ffffffff816a9cd2>] ? mutex_lock+0x12/0x2f
 [<ffffffff8146c105>] device_add+0x125/0x610
 [<ffffffff8146c7e8>] device_create_groups_vargs+0xd8/0x100
 [<ffffffff8146c82c>] device_create_vargs+0x1c/0x20
 [<ffffffff811b209c>] bdi_register+0x8c/0x180
 [<ffffffff811b21b7>] bdi_register_dev+0x27/0x30
 [<ffffffff81327e7f>] add_disk+0x17f/0x4a0
 [<ffffffff8147b955>] ? update_autosuspend+0x55/0x60
 [<ffffffff8147ba14>] ? __pm_runtime_use_autosuspend+0x54/0x70
 [<ffffffffa00a1a25>] sd_probe_async+0x115/0x1d0 [sd_mod]
 [<ffffffff810ad80a>] async_run_entry_fn+0x4a/0x140
 [<ffffffff810a464e>] process_one_work+0x16e/0x420
 [<ffffffff810a4f45>] worker_thread+0x125/0x4b0
 [<ffffffff816a780d>] ? __schedule+0x2ad/0x8a0
 [<ffffffff810a4e20>] ? rescuer_thread+0x380/0x380
 [<ffffffff810aa9b8>] kthread+0xd8/0xf0
 [<ffffffff816abb42>] ret_from_fork+0x22/0x40
 [<ffffffff810aa8e0>] ? kthread_park+0x60/0x60
---[ end trace 353add4e78cb2a76 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffff81297924>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: btrfs xor raid6_pq msdos ext4 jbd2 mbcache matroxfb(OE) ccmod(POE) ftmod(OE) videosw(OE) ipmi_devintf fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack bonding ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter vfat fat x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper cryptd dm_service_time pcspkr ses enclosure
  sg wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c raid1 sr_mod cdrom crc32c_intel qla2xxx(OE) scsi_transport_fc ixgbe(OE) mdio igb(OE) ptp pps_core mpt3sas(OE) 
raid_class i2c_algo_bit sra_sense(OE) i2c_core sd_mod(OE) scsi_transport_sas dca scsi_hbas(OE) fjes ipmi_msghandler usb_storage dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_devintf]
CPU: 5 PID: 30702 Comm: kworker/u97:7 Tainted: P        W  OE   4.6.0-rc6+ #37
Hardware name: Stratus ftServer 6800/G7LYY, BIOS BIOS Version 8.1:64 02/03/2016
Workqueue: events_unbound async_run_entry_fn
task: ffff88038adfda40 ti: ffff88038ae00000 task.ti: ffff88038ae00000
RIP: 0010:[<ffffffff81297924>]  [<ffffffff81297924>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
RSP: 0018:ffff88038ae03d08  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000040 RDI: ffffffff8221adf0
RBP: ffff88038ae03d30 R08: ffff88084d4b91f0 R09: 0000000000000000
R10: ffff8801f1832608 R11: ffff8801f1832f88 R12: ffffffff81a2034e
R13: ffff8808580bae58 R14: 0000000000000001 R15: ffff8804ac9c7038
FS:  0000000000000000(0000) GS:ffff88085f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000040 CR3: 0000001054486000 CR4: 00000000001406e0
Stack:
 ffff8804ac9c6fc8 ffff8804ac9c7048 ffff8808352a0a58 ffff8804ac9c6fd4
 ffff8804ac9c7038 ffff88038ae03d40 ffffffff812979c5 ffff88038ae03da8
 ffffffff81327f15 ffff8804ac9c6fc8 041000008ae03d68 ffff8804ac9c6fc8
Call Trace:
 [<ffffffff812979c5>] sysfs_create_link+0x25/0x40
 [<ffffffff81327f15>] add_disk+0x215/0x4a0
 [<ffffffffa00a1a25>] sd_probe_async+0x115/0x1d0 [sd_mod]
 [<ffffffff810ad80a>] async_run_entry_fn+0x4a/0x140
 [<ffffffff810a464e>] process_one_work+0x16e/0x420
 [<ffffffff810a4f45>] worker_thread+0x125/0x4b0
 [<ffffffff816a780d>] ? __schedule+0x2ad/0x8a0
 [<ffffffff810a4e20>] ? rescuer_thread+0x380/0x380
 [<ffffffff810aa9b8>] kthread+0xd8/0xf0
 [<ffffffff816abb42>] ret_from_fork+0x22/0x40
 [<ffffffff810aa8e0>] ? kthread_park+0x60/0x60
Code: 48 89 e5 41 57 41 56 41 55 41 54 49 89 d4 53 74 73 48 85 ff 49 89 fd 74 6b 48 89 f3 48 c7 c7 f0 ad 21 82 41 89 ce e8 ac 3d 41 00 <48> 8b 1b 48 85 db 74 08 48 89 df e8 ac c1 ff ff 48 c7 c7 f0 ad
RIP  [<ffffffff81297924>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
 RSP <ffff88038ae03d08>
CR2: 0000000000000040
sd 1:0:0:2: [sds] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 1:0:0:2: [sds] Sense not available.
sd 1:0:0:2: [sds] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 1:0:0:2: [sds] Sense not available.
sd 1:0:0:2: [sds] Write Protect is off
sd 1:0:0:2: [sds] Mode Sense: 00 00 00 60
sd 1:0:0:2: [sds] Asking for cache data failed
sd 1:0:0:2: [sds] Assuming drive cache: write through

Regards,

-- Joe
