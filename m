From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into
 sas_remove_host
Date: Mon, 24 Apr 2017 14:38:40 +0100
Message-ID: <e90738ea-185a-2c29-3542-c40057d46b6f@huawei.com>
References: <20170421121141.20701-1-jthumshirn@suse.de>
 <c3ddfbfd-1b4f-d53b-d9b3-9d475985ce9e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c3ddfbfd-1b4f-d53b-d9b3-9d475985ce9e@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Hannes Reinecke <hare@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>, Christoph Hellwig <hch@lst.de>Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 24/04/2017 11:09, John Garry wrote:
> On 21/04/2017 13:11, Johannes Thumshirn wrote:
>> Move scsi_remove_host call into sas_remove_host and remove it from SAS
>> HBA
>> drivers, so we don't mess up the ordering. This solves an issue with
>> double
>> deleting sysfs entries that was introduced by the change of sysfs
>> behaviour
>> from commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").
>>
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: James Bottomley <jejb@linux.vnet.ibm.com>
>> Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
>> Cc: John Garry <john.garry@huawei.com>
>
> For what it's worth:
>
> Tested-by: John Garry <john.garry@huawei.com> # On hisi_sas
>

I have actually tested this a little further and now I see an issue. 
Maybe it is related to the internal development kernel I am using or a 
pre-existing issue with our driver, but I doubt it.
This time I removed the WARN in sysfs_remove_group() [so the console is 
not bombarded] and ran repeated insmod/rmmod, and I see this sometimes:

root@(none)$
root@(none)$ insmod hisi_sas_v2_hw.ko
[ 2150.478485] scsi host6: hisi_sas
[ 2151.629343] scsi host7: hisi_sas
[ 2152.248410] hisi_sas_v2_hw HISI0162:01: phyup: phy0 link_rate=11
[ 2152.254424] hisi_sas_v2_hw HISI0162:01: phyup: phy1 link_rate=11
[ 2152.260422] hisi_sas_v2_hw HISI0162:01: phyup: phy2 link_rate=11
[ 2152.266421] hisi_sas_v2_hw HISI0162:01: phyup: phy3 link_rate=11
[ 2152.272419] hisi_sas_v2_hw HISI0162:01: phyup: phy4 link_rate=11
[ 2152.278416] hisi_sas_v2_hw HISI0162:01: phyup: phy5 link_rate=11
[ 2152.284413] hisi_sas_v2_hw HISI0162:01: phyup: phy6 link_rate=11
[ 2152.290410] hisi_sas_v2_hw HISI0162:01: phyup: phy7 link_rate=11
[ 2152.507431] ata3.00: ATA-8: HGST HUS724040ALA640, MFAOA8B0, max UDMA/133
[ 2152.514127] ata3.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 2152.522726] ata3.00: configured for UDMA/133
[ 2152.574540] scsi 7:0:0:0: Direct-Access     SanDisk  LT0200MO 
P404 PQ: 0 ANSI: 6
[ 2152.835694] scsi 7:0:1:0: Direct-Access     ATA      HGST HUS724040AL 
A8B0 PQ: 0 ANSI: 5
[ 2152.873713] sd 7:0:1:0: [sdb] 7814037168 512-byte logical blocks: 
(4.00 TB/3.64 TiB)
[ 2152.881468] sd 7:0:1:0: [sdb] Write Protect is off
[ 2152.886274] sd 7:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2152.911092] scsi 7:0:2:0: Direct-Access     SanDisk  LT0200MO 
P404 PQ: 0 ANSI: 6
[ 2153.050599] sd 7:0:0:0: [sda] 390721968 512-byte logical blocks: (200 
GB/186 GiB)
[ 2153.092625] sd 7:0:0:0: [sda] Write Protect is off
[ 2153.174641] sd 7:0:0:0: [sda] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[ 2153.209183] scsi 7:0:3:0: Direct-Access     SanDisk  LT0200MO 
P404 PQ: 0 ANSI: 6
[ 2153.387054] sd 7:0:2:0: [sdc] 390721968 512-byte logical blocks: (200 
GB/186 GiB)
[ 2153.429080] sd 7:0:2:0: [sdc] Write Protect is off
[ 2153.507273] scsi 7:0:4:0: Direct-Access     SanDisk  LT0200MO 
P404 PQ: 0 ANSI: 6
[ 2153.515382] sd 7:0:2:0: [sdc] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[ 2153.685254] sd 7:0:3:0: [sdd] 390721968 512-byte logical blocks: (200 
GB/186 GiB)
[ 2153.727267] sd 7:0:3:0: [sdd] Write Protect is off
[ 2153.805266] scsi 7:0:5:0: Direct-Access     SanDisk  LT0200MO 
P404 PQ: 0 ANSI: 6
[ 2153.813359] sd 7:0:3:0: [sdd] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[ 2153.983165] sd 7:0:4:0: [sde] 390721968 512-byte logical blocks: (200 
GB/186 GiB)
[ 2154.025158] sd 7:0:4:0: [sde] Write Protect is off
[ 2154.066761] scsi 7:0:6:0: Enclosure         12G SAS  Expander 
RevB PQ: 0 ANSI: 6
[ 2154.107141] sd 7:0:4:0: [sde] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[ 2154.124866] scsi host8: hisi_sas
[ 2154.281354] sd 7:0:5:0: [sdf] 390721968 512-byte logical blocks: (200 
GB/186 GiB)
[ 2154.323385] sd 7:0:5:0: [sdf] Write Protect is off
[ 2154.405404] sd 7:0:5:0: [sdf] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[ 2154.409289] sd 7:0:0:0: [sda] Attached SCSI disk
[ 2154.745722] sd 7:0:2:0: [sdc] Attached SCSI disk
[ 2155.044051] sd 7:0:3:0: [sdd] Attached SCSI disk

root@(none)$
root@(none)$ [ 2155.341986] sd 7:0:4:0: [sde] Attached SCSI disk

root@(none)$
root@(none)$ [ 2155.640217] sd 7:0:5:0: [sdf] Attached SCSI disk

root@(none)$
root@(none)$ rmmod hisi_sas_v2_hw.ko
[ 2158.679637] hisi_sas_v2_hw HISI0162:01: found dev[7:1] is gone
[ 2161.587449]  sdb: sdb1 sdb2
[ 2161.590253] kobject_add_internal failed for sdb1 (error: -2 parent: sdb)
[ 2161.596954] ------------[ cut here ]------------
[ 2161.601562] WARNING: CPU: 0 PID: 2150 at lib/kobject.c:244 
kobject_add_internal+0xdc/0x298
[ 2161.609811] Modules linked in: hisi_sas_v2_hw(-) hisi_sas_main [last 
unloaded: hisi_sas_v2_hw]
[ 2161.618412]
[ 2161.619893] CPU: 0 PID: 2150 Comm: kworker/u129:6 Tainted: G        W 
       4.11.0-rc1-13718-gb5b0d57-dirty #1584
[ 2161.630138] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 UEFI 16.12 Release 02/27/2017
[ 2161.639345] Workqueue: events_unbound async_run_entry_fn
[ 2161.644644] task: ffff8017b2240000 task.stack: ffff8017b223c000
[ 2161.650550] PC is at kobject_add_internal+0xdc/0x298
[ 2161.655501] LR is at kobject_add_internal+0xdc/0x298
[ 2161.660452] pc : [<ffff000008391190>] lr : [<ffff000008391190>] 
pstate: 60000145
[ 2161.667833] sp : ffff8017b223f980
[ 2161.671134] x29: ffff8017b223f980 x28: ffff8017c3946400
[ 2161.676434] x27: 000000000c800000 x26: ffff00000926a095
[ 2161.681733] x25: 0000000000000800 x24: 0000000000000001
[ 2161.687032] x23: ffff8017b1f71280 x22: ffff8017b27be088
[ 2161.692332] x21: 00000000fffffffe x20: ffff8017b27be088
[ 2161.697631] x19: ffff8017c3946438 x18: 0000000000000000
[ 2161.702930] x17: 0000ffff8c4cb0c0 x16: ffff0000081f3d78
[ 2161.708229] x15: 0000000000000000 x14: 0000000000000000
[ 2161.713528] x13: 0000000000000000 x12: 0000000000000020
[ 2161.718827] x11: ffff000008eeba58 x10: 0000000000000000
[ 2161.724126] x9 : 000000000000060e x8 : 20322d203a726f72
[ 2161.729426] x7 : ffff000008df9e08 x6 : ffff8017fbe7cbd0
[ 2161.734725] x5 : 0000000000000000 x4 : 0000000000000000
[ 2161.740024] x3 : ffffffffffffffff x2 : ffff000008e11e60
[ 2161.745323] x1 : 0000000000000000 x0 : 000000000000003c
[ 2161.750622]
[ 2161.752100] ---[ end trace 5f225d19a45cb6b2 ]---
[ 2161.756703] Call trace:
[ 2161.759137] Exception stack(0xffff8017b223f7b0 to 0xffff8017b223f8e0)
[ 2161.765563] f7a0:                                   ffff8017c3946438 
0001000000000000
[ 2161.773379] f7c0: ffff8017b223f980 ffff000008391190 ffff000008bd1c80 
0000000000000000
[ 2161.781194] f7e0: ffff8017b1f71280 0000000000000001 0000000000000800 
ffff00000926a095
[ 2161.789009] f800: 000000000c800000 ffff8017c3946400 0000000000000140 
0000000000000000
[ 2161.796824] f820: ffff8017b223f980 ffff8017b223f980 ffff8017b223f940 
00000000ffffffc8
[ 2161.804640] f840: ffff8017b223f870 ffff00000810d7ec 000000000000003c 
0000000000000000
[ 2161.812455] f860: ffff000008e11e60 ffffffffffffffff 0000000000000000 
0000000000000000
[ 2161.820270] f880: ffff8017fbe7cbd0 ffff000008df9e08 20322d203a726f72 
000000000000060e
[ 2161.828085] f8a0: 0000000000000000 ffff000008eeba58 0000000000000020 
0000000000000000
[ 2161.835901] f8c0: 0000000000000000 0000000000000000 ffff0000081f3d78 
0000ffff8c4cb0c0
[ 2161.843717] [<ffff000008391190>] kobject_add_internal+0xdc/0x298
[ 2161.849709] [<ffff0000083915bc>] kobject_add+0x90/0xdc
[ 2161.854835] [<ffff00000854bc00>] device_add+0xdc/0x54c
[ 2161.859960] [<ffff00000837baec>] add_partition+0x25c/0x3bc
[ 2161.865432] [<ffff00000837be4c>] rescan_partitions+0x200/0x39c
[ 2161.871252] [<ffff00000822b940>] __blkdev_get+0x2b0/0x39c
[ 2161.876636] [<ffff00000822bba0>] blkdev_get+0x174/0x2f0
[ 2161.881847] [<ffff00000837a5b8>] device_add_disk+0x3c8/0x434
[ 2161.887494] [<ffff0000085a2de4>] sd_probe_async+0xdc/0x1bc
[ 2161.892966] [<ffff0000080df85c>] async_run_entry_fn+0x40/0x108
[ 2161.898786] [<ffff0000080d6324>] process_one_work+0x138/0x2d8
[ 2161.904518] [<ffff0000080d651c>] worker_thread+0x58/0x424
[ 2161.909904] [<ffff0000080dc32c>] kthread+0xf4/0x120
[ 2161.914768] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[ 2161.920083]  sdb: p1 could not be added: 2
[ 2161.924177] kobject_add_internal failed for sdb2 (error: -2 parent: sdb)
[ 2161.930872] ------------[ cut here ]------------
[ 2161.935477] WARNING: CPU: 0 PID: 2150 at lib/kobject.c:244 
kobject_add_internal+0xdc/0x298
[ 2161.943725] Modules linked in: hisi_sas_v2_hw(-) hisi_sas_main [last 
unloaded: hisi_sas_v2_hw]
[ 2161.952325]
[ 2161.953804] CPU: 0 PID: 2150 Comm: kworker/u129:6 Tainted: G        W 
       4.11.0-rc1-13718-gb5b0d57-dirty #1584
[ 2161.964049] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 UEFI 16.12 Release 02/27/2017
[ 2161.973254] Workqueue: events_unbound async_run_entry_fn
[ 2161.978553] task: ffff8017b2240000 task.stack: ffff8017b223c000
[ 2161.984459] PC is at kobject_add_internal+0xdc/0x298
[ 2161.989410] LR is at kobject_add_internal+0xdc/0x298
[ 2161.994360] pc : [<ffff000008391190>] lr : [<ffff000008391190>] 
pstate: 60000145
[ 2162.001741] sp : ffff8017b223f980
[ 2162.005042] x29: ffff8017b223f980 x28: ffff8017c3946400
[ 2162.010342] x27: 000000000c800000 x26: ffff00000926a115
[ 2162.015641] x25: 000000000c800800 x24: 0000000000000002
[ 2162.020940] x23: ffff8017b1f71280 x22: ffff8017b27be088
[ 2162.026239] x21: 00000000fffffffe x20: ffff8017b27be088
[ 2162.031538] x19: ffff8017c3946438 x18: 0000000000000000
[ 2162.036838] x17: 0000ffff8c4cb0c0 x16: ffff0000081f3d78
[ 2162.042137] x15: 0000000000000000 x14: 0000000000000000
[ 2162.047436] x13: 0000000000000000 x12: 0000000000000020
[ 2162.052735] x11: ffff000008eeba58 x10: 0000000000000000
[ 2162.058034] x9 : 0000000000000647 x8 : 29626473203a746e
[ 2162.063333] x7 : ffff000008df9e08 x6 : ffff8017fbe7cbd0
[ 2162.068632] x5 : 0000000000000000 x4 : 0000000000000000
[ 2162.073932] x3 : ffffffffffffffff x2 : ffff000008e11e60
[ 2162.079231] x1 : 0000000000000000 x0 : 000000000000003c
[ 2162.084530]
[ 2162.086008] ---[ end trace 5f225d19a45cb6b3 ]---
[ 2162.090611] Call trace:
[ 2162.093044] Exception stack(0xffff8017b223f7b0 to 0xffff8017b223f8e0)
[ 2162.099471] f7a0:                                   ffff8017c3946438 
0001000000000000
[ 2162.107286] f7c0: ffff8017b223f980 ffff000008391190 ffff000008bd1c80 
0000000000000000
[ 2162.115102] f7e0: ffff8017b1f71280 0000000000000002 000000000c800800 
ffff00000926a115
[ 2162.122917] f800: 000000000c800000 ffff8017c3946400 0000000000000140 
0000000000000000
[ 2162.130732] f820: ffff8017b223f980 ffff8017b223f980 ffff8017b223f940 
00000000ffffffc8
[ 2162.138547] f840: ffff8017b223f870 ffff00000810d7ec 000000000000003c 
0000000000000000
[ 2162.146362] f860: ffff000008e11e60 ffffffffffffffff 0000000000000000 
0000000000000000
[ 2162.154178] f880: ffff8017fbe7cbd0 ffff000008df9e08 29626473203a746e 
0000000000000647
[ 2162.161993] f8a0: 0000000000000000 ffff000008eeba58 0000000000000020 
0000000000000000
[ 2162.169808] f8c0: 0000000000000000 0000000000000000 ffff0000081f3d78 
0000ffff8c4cb0c0
[ 2162.177624] [<ffff000008391190>] kobject_add_internal+0xdc/0x298
[ 2162.183617] [<ffff0000083915bc>] kobject_add+0x90/0xdc
[ 2162.188742] [<ffff00000854bc00>] device_add+0xdc/0x54c
[ 2162.193867] [<ffff00000837baec>] add_partition+0x25c/0x3bc
[ 2162.199338] [<ffff00000837be4c>] rescan_partitions+0x200/0x39c
[ 2162.205157] [<ffff00000822b940>] __blkdev_get+0x2b0/0x39c
[ 2162.210542] [<ffff00000822bba0>] blkdev_get+0x174/0x2f0
[ 2162.215753] [<ffff00000837a5b8>] device_add_disk+0x3c8/0x434
[ 2162.221399] [<ffff0000085a2de4>] sd_probe_async+0xdc/0x1bc
[ 2162.226871] [<ffff0000080df85c>] async_run_entry_fn+0x40/0x108
[ 2162.232691] [<ffff0000080d6324>] process_one_work+0x138/0x2d8
[ 2162.238423] [<ffff0000080d651c>] worker_thread+0x58/0x424
[ 2162.243808] [<ffff0000080dc32c>] kthread+0xf4/0x120
[ 2162.248672] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[ 2162.253979]  sdb: p2 could not be added: 2
[ 2162.258103] kobject_add_internal failed for queue (error: -2 parent: sdb)
[ 2162.264885] ------------[ cut here ]------------
[ 2162.269490] WARNING: CPU: 0 PID: 2150 at lib/kobject.c:244 
kobject_add_internal+0xdc/0x298
[ 2162.277739] Modules linked in: hisi_sas_v2_hw(-) hisi_sas_main [last 
unloaded: hisi_sas_v2_hw]
[ 2162.286339]
[ 2162.287817] CPU: 0 PID: 2150 Comm: kworker/u129:6 Tainted: G        W 
       4.11.0-rc1-13718-gb5b0d57-dirty #1584
[ 2162.298062] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 UEFI 16.12 Release 02/27/2017
[ 2162.307267] Workqueue: events_unbound async_run_entry_fn
[ 2162.312566] task: ffff8017b2240000 task.stack: ffff8017b223c000
[ 2162.318471] PC is at kobject_add_internal+0xdc/0x298
[ 2162.323422] LR is at kobject_add_internal+0xdc/0x298
[ 2162.328373] pc : [<ffff000008391190>] lr : [<ffff000008391190>] 
pstate: 60000145
[ 2162.335753] sp : ffff8017b223fba0
[ 2162.339054] x29: ffff8017b223fba0 x28: ffff000008df7000
[ 2162.344353] x27: ffff0000080d64c4 x26: ffff8017b2238000
[ 2162.349652] x25: ffff8017b27be018 x24: 0000000000000001
[ 2162.354951] x23: ffff8017b27be088 x22: ffff8017b27be088
[ 2162.360251] x21: 00000000fffffffe x20: ffff8017b27be088
[ 2162.365550] x19: ffff8017b27ee9d0 x18: 0000000000000000
[ 2162.370849] x17: 0000ffff8c4cb0c0 x16: ffff0000081f3d78
[ 2162.376148] x15: 0000000000000000 x14: 00001c4900001c45
[ 2162.381447] x13: 00001c4100001c3d x12: 0000000085aac367
[ 2162.386746] x11: ffff000008eeba58 x10: 0000000000000000
[ 2162.392045] x9 : 0000000000000680 x8 : 3a746e6572617020
[ 2162.397344] x7 : ffff000008df9e08 x6 : ffff8017fbe7cbd0
[ 2162.402644] x5 : 0000000000000000 x4 : 0000000000000000
[ 2162.407943] x3 : ffffffffffffffff x2 : ffff000008e11e60
[ 2162.413242] x1 : 0000000000000000 x0 : 000000000000003d
[ 2162.418541]
[ 2162.420019] ---[ end trace 5f225d19a45cb6b4 ]---
[ 2162.424622] Call trace:
[ 2162.427056] Exception stack(0xffff8017b223f9d0 to 0xffff8017b223fb00)
[ 2162.433482] f9c0:                                   ffff8017b27ee9d0 
0001000000000000
[ 2162.441297] f9e0: ffff8017b223fba0 ffff000008391190 ffff000008bd1c80 
0000000000000000
[ 2162.449113] fa00: ffff8017b27be088 0000000000000001 ffff8017b27be018 
ffff8017b2238000
[ 2162.456928] fa20: ffff0000080d64c4 ffff000008df7000 0000000000000140 
0000000000000000
[ 2162.464743] fa40: ffff8017b223fba0 ffff8017b223fba0 ffff8017b223fb60 
00000000ffffffc8
[ 2162.472559] fa60: ffff8017b223fa90 ffff00000810d7ec 000000000000003d 
0000000000000000
[ 2162.480374] fa80: ffff000008e11e60 ffffffffffffffff 0000000000000000 
0000000000000000
[ 2162.488190] faa0: ffff8017fbe7cbd0 ffff000008df9e08 3a746e6572617020 
0000000000000680
[ 2162.496005] fac0: 0000000000000000 ffff000008eeba58 0000000085aac367 
00001c4100001c3d
[ 2162.503820] fae0: 00001c4900001c45 0000000000000000 ffff0000081f3d78 
0000ffff8c4cb0c0
[ 2162.511636] [<ffff000008391190>] kobject_add_internal+0xdc/0x298
[ 2162.517629] [<ffff0000083915bc>] kobject_add+0x90/0xdc
[ 2162.522755] [<ffff00000836a538>] blk_register_queue+0x74/0x12c
[ 2162.528573] [<ffff00000837a3fc>] device_add_disk+0x20c/0x434
[ 2162.534219] [<ffff0000085a2de4>] sd_probe_async+0xdc/0x1bc
[ 2162.539691] [<ffff0000080df85c>] async_run_entry_fn+0x40/0x108
[ 2162.545511] [<ffff0000080d6324>] process_one_work+0x138/0x2d8
[ 2162.551243] [<ffff0000080d651c>] worker_thread+0x58/0x424
[ 2162.556628] [<ffff0000080dc32c>] kthread+0xf4/0x120
[ 2162.561492] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[ 2162.566803] ------------[ cut here ]------------
[ 2162.571408] WARNING: CPU: 0 PID: 2150 at block/genhd.c:653 
device_add_disk+0x3dc/0x434
[ 2162.579309] Modules linked in: hisi_sas_v2_hw(-) hisi_sas_main [last 
unloaded: hisi_sas_v2_hw]
[ 2162.587908]
[ 2162.589387] CPU: 0 PID: 2150 Comm: kworker/u129:6 Tainted: G        W 
       4.11.0-rc1-13718-gb5b0d57-dirty #1584
[ 2162.599632] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 UEFI 16.12 Release 02/27/2017
[ 2162.608837] Workqueue: events_unbound async_run_entry_fn
[ 2162.614135] task: ffff8017b2240000 task.stack: ffff8017b223c000
[ 2162.620041] PC is at device_add_disk+0x3dc/0x434
[ 2162.624644] LR is at device_add_disk+0x234/0x434
[ 2162.629247] pc : [<ffff00000837a5cc>] lr : [<ffff00000837a424>] 
pstate: 20000145
[ 2162.636628] sp : ffff8017b223fcd0
[ 2162.639929] x29: ffff8017b223fcd0 x28: ffff000008df7000
[ 2162.645228] x27: ffff0000080d64c4 x26: ffff8017b2238000
[ 2162.650527] x25: ffff8017b27be018 x24: 0000000000000001
[ 2162.655826] x23: ffff8017c396e800 x22: ffff8017c3f38000
[ 2162.661125] x21: ffff8017b27be088 x20: ffff8017b27be078
[ 2162.666425] x19: ffff8017b27be000 x18: 0000000000000000
[ 2162.671724] x17: 0000ffff8c4cb0c0 x16: ffff0000081f3d78
[ 2162.677023] x15: 0000000000000000 x14: 00001c4900001c45
[ 2162.682322] x13: 00001c4100001c3d x12: 0000000085aac367
[ 2162.687621] x11: ffff000008eeba58 x10: 0000000000000000
[ 2162.692920] x9 : 0000000000000680 x8 : ffff8017b1f77258
[ 2162.698219] x7 : 0000000000000220 x6 : ffff8017fbe86d80
[ 2162.703518] x5 : ffffffffffffffff x4 : 000000000006cb40
[ 2162.708818] x3 : ffff000008dbfd80 x2 : 0000000000000000
[ 2162.714117] x1 : 0000000000000000 x0 : 00000000fffffffe
[ 2162.719416]
[ 2162.720894] ---[ end trace 5f225d19a45cb6b5 ]---
[ 2162.725497] Call trace:
[ 2162.727930] Exception stack(0xffff8017b223fb00 to 0xffff8017b223fc30)
[ 2162.734357] fb00: ffff8017b27be000 0001000000000000 ffff8017b223fcd0 
ffff00000837a5cc
[ 2162.742172] fb20: ffff8017b223fb90 ffff0000083901d8 ffff000008f27a78 
ffff8017db510e10
[ 2162.749987] fb40: 0000000000000140 ffff8017c4015bb8 ffff8017db510e10 
ffff000008f22000
[ 2162.757802] fb60: ffff8017b223fbd0 0000000000000014 0000000000000040 
ffff0000082656cc
[ 2162.765618] fb80: ffff8017b223fbd0 ffff0000082656e4 ffff8017b1f771e0 
00000000fffffffe
[ 2162.773433] fba0: 00000000fffffffe 0000000000000000 0000000000000000 
ffff000008dbfd80
[ 2162.781248] fbc0: 000000000006cb40 ffffffffffffffff ffff8017fbe86d80 
0000000000000220
[ 2162.789063] fbe0: ffff8017b1f77258 0000000000000680 0000000000000000 
ffff000008eeba58
[ 2162.796879] fc00: 0000000085aac367 00001c4100001c3d 00001c4900001c45 
0000000000000000
[ 2162.804694] fc20: ffff0000081f3d78 0000ffff8c4cb0c0
[ 2162.809557] [<ffff00000837a5cc>] device_add_disk+0x3dc/0x434
[ 2162.815203] [<ffff0000085a2de4>] sd_probe_async+0xdc/0x1bc
[ 2162.820675] [<ffff0000080df85c>] async_run_entry_fn+0x40/0x108
[ 2162.826495] [<ffff0000080d6324>] process_one_work+0x138/0x2d8
[ 2162.832227] [<ffff0000080d651c>] worker_thread+0x58/0x424
[ 2162.837612] [<ffff0000080dc32c>] kthread+0xf4/0x120
[ 2162.842476] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[ 2162.847782] sdb: failed to create sysfs files for events
[ 2162.853109] kobject_add_internal failed for integrity (error: -2 
parent: sdb)
[ 2162.860238] ------------[ cut here ]------------
[ 2162.864843] WARNING: CPU: 0 PID: 2150 at lib/kobject.c:244 
kobject_add_internal+0xdc/0x298
[ 2162.873092] Modules linked in: hisi_sas_v2_hw(-) hisi_sas_main [last 
unloaded: hisi_sas_v2_hw]
[ 2162.881692]
[ 2162.883170] CPU: 0 PID: 2150 Comm: kworker/u129:6 Tainted: G        W 
       4.11.0-rc1-13718-gb5b0d57-dirty #1584
[ 2162.893415] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 UEFI 16.12 Release 02/27/2017
[ 2162.902620] Workqueue: events_unbound async_run_entry_fn
[ 2162.907919] task: ffff8017b2240000 task.stack: ffff8017b223c000
[ 2162.913825] PC is at kobject_add_internal+0xdc/0x298
[ 2162.918776] LR is at kobject_add_internal+0xdc/0x298
[ 2162.923726] pc : [<ffff000008391190>] lr : [<ffff000008391190>] 
pstate: 60000145
[ 2162.931107] sp : ffff8017b223fbc0
[ 2162.934408] x29: ffff8017b223fbc0 x28: ffff000008df7000
[ 2162.939707] x27: ffff0000080d64c4 x26: ffff8017b2238000
[ 2162.945006] x25: ffff8017b27be018 x24: 0000000000000001
[ 2162.950305] x23: ffff8017c396e800 x22: ffff8017b27be088
[ 2162.955604] x21: 00000000fffffffe x20: 0000000000000000
[ 2162.960903] x19: ffff8017b27be420 x18: 0000000000000000
[ 2162.966202] x17: 0000ffff8c4cb0c0 x16: ffff0000081f3d78
[ 2162.971502] x15: 0000000000000000 x14: 626473203a746e65
[ 2162.976801] x13: 72617020322d203a x12: 726f727265282079
[ 2162.982100] x11: 7469726765746e69 x10: 20726f662064656c
[ 2162.987399] x9 : 696166206c616e72 x8 : 65746e695f646461
[ 2162.992698] x7 : ffff000008df9e08 x6 : ffff8017fbe7cbd0
[ 2162.997997] x5 : 0000000000000000 x4 : 0000000000000000
[ 2163.003296] x3 : ffffffffffffffff x2 : ffff000008e11e60
[ 2163.008595] x1 : 0000000000000000 x0 : 0000000000000041
[ 2163.013895]
[ 2163.015373] ---[ end trace 5f225d19a45cb6b6 ]---
[ 2163.019976] Call trace:
[ 2163.022409] Exception stack(0xffff8017b223f9f0 to 0xffff8017b223fb20)
[ 2163.028835] f9e0:                                   ffff8017b27be420 
0001000000000000
[ 2163.036651] fa00: ffff8017b223fbc0 ffff000008391190 ffff000008bd1c80 
0000000000000000
[ 2163.044466] fa20: ffff8017c396e800 0000000000000001 ffff8017b27be018 
ffff8017b2238000
[ 2163.052281] fa40: ffff0000080d64c4 ffff000008df7000 0000000000000140 
0000000000000000
[ 2163.060096] fa60: ffff8017b223fbc0 ffff8017b223fbc0 ffff8017b223fb80 
00000000ffffffc8
[ 2163.067912] fa80: ffff8017b223fab0 ffff00000810d7ec 0000000000000041 
0000000000000000
[ 2163.075727] faa0: ffff000008e11e60 ffffffffffffffff 0000000000000000 
0000000000000000
[ 2163.083542] fac0: ffff8017fbe7cbd0 ffff000008df9e08 65746e695f646461 
696166206c616e72
[ 2163.091357] fae0: 20726f662064656c 7469726765746e69 726f727265282079 
72617020322d203a
[ 2163.099173] fb00: 626473203a746e65 0000000000000000 ffff0000081f3d78 
0000ffff8c4cb0c0
[ 2163.106988] [<ffff000008391190>] kobject_add_internal+0xdc/0x298
[ 2163.112981] [<ffff0000083913dc>] kobject_init_and_add+0x90/0xb4
[ 2163.118887] [<ffff00000838ba90>] blk_integrity_add+0x3c/0x58
[ 2163.124532] [<ffff00000837a490>] device_add_disk+0x2a0/0x434
[ 2163.130178] [<ffff0000085a2de4>] sd_probe_async+0xdc/0x1bc
[ 2163.135650] [<ffff0000080df85c>] async_run_entry_fn+0x40/0x108
[ 2163.141470] [<ffff0000080d6324>] process_one_work+0x138/0x2d8
[ 2163.147202] [<ffff0000080d651c>] worker_thread+0x58/0x424
[ 2163.152587] [<ffff0000080dc32c>] kthread+0xf4/0x120
[ 2163.157451] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
[ 2163.162859] sd 7:0:1:0: [sdb] Attached SCSI disk
[ 2163.189791] hisi_sas_v2_hw HISI0162:01: found dev[6:1] is gone
[ 2163.233739] hisi_sas_v2_hw HISI0162:01: found dev[5:1] is gone
[ 2163.281771] hisi_sas_v2_hw HISI0162:01: found dev[4:1] is gone
[ 2163.321734] hisi_sas_v2_hw HISI0162:01: found dev[3:1] is gone
[ 2163.328034] sd 7:0:1:0: [sdb] Synchronizing SCSI cache
[ 2163.333404] sd 7:0:1:0: [sdb] Stopping disk
[ 2164.013743] hisi_sas_v2_hw HISI0162:01: found dev[2:5] is gone
[ 2164.037791] hisi_sas_v2_hw HISI0162:01: found dev[1:1] is gone
[ 2164.044559] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
root@(none)$


Ring any bells? I don't see this new WARN without the change.


> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
>
> .
>
