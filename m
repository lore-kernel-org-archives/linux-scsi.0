From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 0/7] Enhance libsas hotplug feature
Date: Thu, 13 Jul 2017 09:37:43 +0800
Message-ID: <5966CEE7.4060506@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <153868d4-9aa6-21b5-81f3-868668218cb2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153868d4-9aa6-21b5-81f3-868668218cb2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/7/12 17:59, John Garry 写道:
> On 10/07/2017 08:06, Yijing Wang wrote:
>> This patchset is based Johannes's patch
>> "scsi: sas: scsi_queue_work can fail, so make callers aware"
>>
>> Now the libsas hotplug has some issues, Dan Williams report
>> a similar bug here before
>> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html
>>
>> The issues we have found
>> 1. if LLDD burst reports lots of phy-up/phy-down sas events, some events
>>    may lost because a same sas events is pending now, finally libsas topo
>>    may different the hardware.
>> 2. receive a phy down sas event, libsas call sas_deform_port to remove
>>    devices, it would first delete the sas port, then put a destruction
>>    discovery event in a new work, and queue it at the tail of workqueue,
>>    once the sas port be deleted, its children device will be deleted too,
>>    when the destruction work start, it will found the target device has
>>    been removed, and report a sysfs warnning.
>> 3. since a hotplug process will be devided into several works, if a phy up
>>    sas event insert into phydown works, like
>>    destruction work  ---> PORTE_BYTES_DMAED (sas_form_port) ---->PHYE_LOSS_OF_SIGNAL
>>    the hot remove flow would broken by PORTE_BYTES_DMAED event, it's not
>>    we expected, and issues would occur.
>>
>> The first patch fix the sas events lost, and the second one introudce wait-complete
>> to fix the hotplug order issues.
>>
> 
> I quickly tested this for basic hotplug.
> 
> Before:
> root@(none)$ echo 0 > ./phy-0:6/sas_phy/phy-0:6/enable
> root@(none)$ echo 0 > ./phy-0:5/sas_phy/phy-0:5/enable
> root@(none)$ echo 0 > ./phy-0:4/sas_phy/phy-0:4/enable
> root@(none)$ echo 0 > ./phy-0:3/sas_phy/phy-0:3/enable
> root@(none)$ echo 0 > ./phy-0:3/sas_phy/phy-0:2/enable
> root@(none)$ echo 0 > ./phy-0:2/sas_phy/phy-0:2/enable
> root@(none)$ echo 0 > ./phy-0:1/sas_phy/phy-0:1/enable
> root@(none)$ echo 0 > ./phy-0:0/sas_phy/phy-0:0/enable
> root@(none)$ echo 0 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  102.570694] sysfs group 'power' not found for kobject '0:0:7:0'
> [  102.577250] ------------[ cut here ]------------
> [  102.581861] WARNING: CPU: 3 PID: 1740 at fs/sysfs/group.c:237 sysfs_remove_group+0x8c/0x94
> [  102.590110] Modules linked in:
> [  102.593154] CPU: 3 PID: 1740 Comm: kworker/u128:2 Not tainted 4.12.0-rc1-00032-g3ab81fc #1907
> [  102.601664] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon D05 UEFI Nemo 1.7 RC3 06/23/2017
> [  102.610784] Workqueue: scsi_wq_0 sas_destruct_devices
> [  102.615822] task: ffff8017d4793400 task.stack: ffff8017b7e70000
> [  102.621728] PC is at sysfs_remove_group+0x8c/0x94
> [  102.626419] LR is at sysfs_remove_group+0x8c/0x94
> [  102.631109] pc : [<ffff000008267c44>] lr : [<ffff000008267c44>] pstate: 60000045
> [  102.638490] sp : ffff8017b7e73b80
> [  102.641791] x29: ffff8017b7e73b80 x28: ffff8017db010800
> [  102.647091] x27: ffff000008e27000 x26: ffff8017d43e6600
> [  102.652390] x25: ffff8017b8280000 x24: 0000000000000003
> [  102.657689] x23: ffff8017b78864b0 x22: ffff8017b784c988
> [  102.662988] x21: ffff8017b7886410 x20: ffff000008ee9dd0
> [  102.668288] x19: 0000000000000000 x18: ffff000008a1b678
> [  102.673587] x17: 000000000000000e x16: 0000000000000007
> [  102.678886] x15: 0000000000000000 x14: 00000000000000a3
> [  102.684185] x13: 0000000000000033 x12: 0000000000000028
> [  102.689484] x11: ffff000008f3be58 x10: 0000000000000000
> [  102.694783] x9 : 000000000000043c x8 : 6f6b20726f662064
> [  102.700082] x7 : ffff000008e29e08 x6 : ffff8017fbe34c50
> [  102.705382] x5 : 0000000000000000 x4 : 0000000000000000
> [  102.710681] x3 : ffffffffffffffff x2 : ffff000008e427e0
> [  102.715980] x1 : 0000000000000000 x0 : 0000000000000033
> [  102.721279] ---[ end trace c216cc1451d5f7ec ]---
> [  102.725882] Call trace:
> [  102.728316] Exception stack(0xffff8017b7e739b0 to 0xffff8017b7e73ae0)
> [  102.734742] 39a0:                                   0000000000000000 0001000000000000
> [  102.742557] 39c0: ffff8017b7e73b80 ffff000008267c44 ffff000008bfa050 0000000000000000
> [  102.750372] 39e0: ffff8017b78864b0 0000000000000003 ffff8017b8280000 ffff8017d43e6600
> [  102.758188] 3a00: ffff000008e27000 ffff8017db010800 ffff8017d4793400 0000000000000000
> [  102.766003] 3a20: ffff8017b7e73b80 ffff8017b7e73b80 ffff8017b7e73b40 00000000ffffffc8
> [  102.773818] 3a40: ffff8017b7e73a70 ffff00000810c12c 0000000000000033 0000000000000000
> [  102.781633] 3a60: ffff000008e427e0 ffffffffffffffff 0000000000000000 0000000000000000
> [  102.789449] 3a80: ffff8017fbe34c50 ffff000008e29e08 6f6b20726f662064 000000000000043c
> [  102.797264] 3aa0: 0000000000000000 ffff000008f3be58 0000000000000028 0000000000000033
> [  102.805079] 3ac0: 00000000000000a3 0000000000000000 0000000000000007 000000000000000e
> [  102.812895] [<ffff000008267c44>] sysfs_remove_group+0x8c/0x94
> [  102.818628] [<ffff00000855b14c>] dpm_sysfs_remove+0x58/0x68
> [  102.824188] [<ffff00000854e0e8>] device_del+0xf8/0x2d0
> [  102.829312] [<ffff00000854e2d4>] device_unregister+0x14/0x2c
> [  102.834959] [<ffff00000837e6e0>] bsg_unregister_queue+0x60/0x98
> [  102.840866] [<ffff000008593cd4>] __scsi_remove_device+0xa0/0xbc
> 
> <snip>
> 
> [  151.331854] 3bc0: ffff0000081f21ac 0000ffff803370c0
> [  151.336718] [<ffff000008267c44>] sysfs_remove_group+0x8c/0x94
> [  151.342449] [<ffff00000855b14c>] dpm_sysfs_remove+0x58/0x68
> [  151.348008] [<ffff00000854e0e8>] device_del+0xf8/0x2d0
> [  151.353133] [<ffff000008597278>] sas_rphy_remove+0x54/0x80
> [  151.358604] [<ffff0000085972b8>] sas_rphy_delete+0x14/0x28
> [  151.364076] [<ffff00000859b304>] sas_destruct_devices+0x64/0x98
> [  151.369982] [<ffff0000080d8194>] process_one_work+0x12c/0x28c
> [  151.375714] [<ffff0000080d834c>] worker_thread+0x58/0x3b8
> [  151.381100] [<ffff0000080ddee4>] kthread+0x100/0x12c
> [  151.386050] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
> [  151.391360] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
> 
> root@(none)$
> 
> So the console locks for ~50 seconds with WARN garbage.
> 
> After:
> ...
> root@(none)$ echo 0 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  446.193336] hisi_sas_v2_hw HISI0162:01: found dev[8:1] is gone
> [  446.249205] hisi_sas_v2_hw HISI0162:01: found dev[7:1] is gone
> [  446.325201] hisi_sas_v2_hw HISI0162:01: found dev[6:1] is gone
> [  446.373189] hisi_sas_v2_hw HISI0162:01: found dev[5:1] is gone
> [  446.421187] hisi_sas_v2_hw HISI0162:01: found dev[4:1] is gone
> [  446.457232] hisi_sas_v2_hw HISI0162:01: found dev[3:1] is gone
> [  446.477151] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [  446.482373] sd 0:0:1:0: [sdb] Synchronize Cache(10) failed: Result: hostbyte=0x04 driverbyte=0x00
> [  446.491238] sd 0:0:1:0: [sdb] Stopping disk
> [  446.495419] sd 0:0:1:0: [sdb] Start/Stop Unit failed: Result: hostbyte=0x04 driverbyte=0x00
> [  446.525227] hisi_sas_v2_hw HISI0162:01: found dev[2:5] is gone
> [  446.569249] hisi_sas_v2_hw HISI0162:01: found dev[1:1] is gone
> [  446.576872] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
> 
> root@(none)$
> 
> So much nicer. BTW, /dev/sdb is a SATA disk, the rest are SAS.

Oh, I take a mistake ? The result you tested the hotplug which applied this patchset is fine ?

Thanks!
Yijing.


> 
> John
> 
>> v2->v3: some code improvements suggested by Johannes and John,
>>         split v2 patch 2 into several small pathes.
>> v1->v2: some code improvements suggested by John Garry
>>
>> Yijing Wang (7):
>>   libsas: Use static sas event pool to appease sas event lost
>>   libsas: remove unused port_gone_completion
>>   libsas: Use new workqueue to run sas event
>>   libsas: add sas event wait-complete support
>>   libsas: add a new workqueue to run probe/destruct discovery event
>>   libsas: add wait-complete support to sync discovery event
>>   libsas: release disco mutex during waiting in sas_ex_discover_end_dev
>>
>>  drivers/scsi/libsas/sas_discover.c |  58 +++++++---
>>  drivers/scsi/libsas/sas_event.c    | 212 ++++++++++++++++++++++++++++++++-----
>>  drivers/scsi/libsas/sas_expander.c |  22 +++-
>>  drivers/scsi/libsas/sas_init.c     |  21 ++--
>>  drivers/scsi/libsas/sas_internal.h |  64 +++++++++++
>>  drivers/scsi/libsas/sas_phy.c      |  48 +++------
>>  drivers/scsi/libsas/sas_port.c     |  22 ++--
>>  include/scsi/libsas.h              |  27 +++--
>>  8 files changed, 373 insertions(+), 101 deletions(-)
>>
> 
> 
> 
> .
> 
