From: wangyijing <wangyijing@huawei.com>
Subject: Warning Calltrace when hotplug sas disk
Date: Fri, 5 Feb 2016 15:05:09 +0800
Message-ID: <56B449A5.3010209@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([58.251.152.52]:49929 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbcBEHLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 02:11:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list, I tried to hotplug disk in my machine, but when I hot remove the disk, I found some warning calltrace.

When we try to unplug a disk,

The lldd report a loss_of_singal event to sas, so

sas_deform_port
	sas_unregister_domain_devices
		sas_unregister_dev
			queue the destruct to scsi work queue
	sas_port_delete
		device_del(port)  //port device is parent of phy and end device, so in this case, we first delete the parent kobj then to delete the children device.
..
sas_destruct_devices
	sas_rphy_delete
		...

It seems caused by delete the parent device before the children devices. This is my personal idea, if anyone could comment on this, I will be appreciate very much, thanks.


WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:224 sysfs_remove_group+0xa0/0xa4()
kobj ffff8013e8389410 sysfs group (power)ffff800000a2dbe8 not found for kobject '0:0:1:0'
Modules linked in:
CPU: 2 PID: 6 Comm: kworker/u64:0 Not tainted 4.1.6+ #160
Hardware name: Hisilicon PhosphorV660 Development Board (DT)
Workqueue: scsi_wq_0 sas_destruct_devices
Call trace:
[<ffff800000089918>] dump_backtrace+0x0/0x124
[<ffff800000089a4c>] show_stack+0x10/0x1c
[<ffff8000006ecdf8>] dump_stack+0x78/0x98
[<ffff80000009fc38>] warn_slowpath_common+0x98/0xd0
[<ffff80000009fcbc>] warn_slowpath_fmt+0x4c/0x58
[<ffff8000001fc194>] sysfs_remove_group+0x9c/0xa4
[<ffff8000003d7bb8>] dpm_sysfs_remove+0x54/0x94
[<ffff8000003cca3c>] device_del+0x58/0x24c
[<ffff8000003ccc40>] device_unregister+0x10/0x2c
[<ffff80000030781c>] bsg_unregister_queue+0xbc/0xf8
[<ffff8000003fa498>] __scsi_remove_device+0x9c/0xbc
[<ffff8000003fa4fc>] scsi_remove_device+0x44/0x64
[<ffff8000003fa6ec>] scsi_remove_target+0x198/0x258
[<ffff80000040c178>] sas_rphy_remove+0x8c/0xb4
[<ffff80000040c1d4>] sas_rphy_delete+0x34/0x54
[<ffff8000004103b8>] sas_destruct_devices+0x60/0x98
[<ffff8000000b5490>] process_one_work+0x13c/0x344
[<ffff8000000b57d4>] worker_thread+0x13c/0x494
[<ffff8000000bafb8>] kthread+0xd8/0xf0
---[ end trace b69dffc64eb59f96 ]---





