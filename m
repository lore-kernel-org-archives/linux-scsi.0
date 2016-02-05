From: wangyijing <wangyijing@huawei.com>
Subject: Question for Patch"libsas: fix "sysfs group not found" warnings at
 port teardown time"
Date: Fri, 5 Feb 2016 17:20:03 +0800
Message-ID: <56B46943.5040808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([58.251.152.179]:36987 "EHLO
	szxga05-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbcBEJWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 04:22:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, Praveen Murali <pmurali@logicube.com>
Cc: linux-scsi@vger.kernel.org

Hi Dan and Praveen,
   I found a patch titled "libsas: fix "sysfs group not found" warnings at port teardown time" by google,
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html

I found the same warning calltrace in my platform, but I didn't find the patch changes in the latest kernel 4.5-rc2.
So is this issue still in kernel ?

I think your patch could fix this issue we found, but I'm worried about another problem.

Now when unplug a disk

LLDD report a event loss_of_singal
    sas_deform_port
	sas_unregister_domain_devices
		sas_unregister_dev
			sas_discover_event(dev->port, DISCE_DESTRUCT);
	sas_port_delete
	phy->port = NULL;

and after your patch changes

LLDD report a event loss_of_singal
	sas_deform_port
		sas_unregister_domain_devices
			sas_unregister_dev
				sas_discover_event(dev->port, DISCE_DESTRUCT);
	phy->port = NULL;

...
	sas_destruct_devices
		sas_port_delete   //now we actually delete the port device, but we set 	phy->port = NULL;  before this time.


So if we hotplug the disk quickly, plug,unplug,plug,
The new dmaed event(plug) would try to alloc and add a new port, but the old port device is still alive.
Another calltrace would occur

WARNING: CPU: 0 PID: 1038 at lib/kobject.c:240 kobject_add_internal+0x258/0x318()
kobject_add_internal failed for port-0:0 with -EEXIST, don't try to register things with the same name in the same directory.
CPU: 0 PID: 1038 Comm: kworker/u64:2 Tainted: G        W       4.1.6+ #140
[<ffff800000089918>] dump_backtrace+0x0/0x124
[<ffff800000089a4c>] show_stack+0x10/0x1c
[<ffff80000009fcbc>] warn_slowpath_fmt+0x4c/0x58
[<ffff8000003cdc04>] device_add+0x28c/0x5b8
[<ffff80000040d4ec>] sas_port_add+0x20/0xbc
[<ffff80000040f3e8>] sas_porte_bytes_dmaed
[<ffff8000000b5504>] process_one_work+0x13c/0x344

Because I am not a sas guy, so if you could comment this or post new patch, I would be thanks a lot!

Thanks!
Yijing.



