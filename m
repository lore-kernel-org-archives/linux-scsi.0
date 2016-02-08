From: John Garry <john.garry@huawei.com>
Subject: Re: Question for Patch"libsas: fix "sysfs group not found" warnings
 at port teardown time"
Date: Mon, 8 Feb 2016 17:20:59 +0000
Message-ID: <56B8CE7B.2060008@huawei.com>
References: <56B46943.5040808@huawei.com>
 <73C1379F-2511-4C31-AB88-65061EBFAEBC@logicube.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:33606 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbcBHRVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 12:21:49 -0500
In-Reply-To: <73C1379F-2511-4C31-AB88-65061EBFAEBC@logicube.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>, wangyijing <wangyijing@huawei.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 05/02/2016 21:33, Praveen Murali wrote:
> Hi Yijing,
>    The fix was deemed inappropriate and I think the explanation provided by James was kind similar to what your observation is. Also, as far as I remember the consensus was that these error messages (sysfs group not found) are harmless at this point. I think James can provide a better explanation and direction for you (copying him here).
>
> Praveen
>

I can't find the original full discussion on this. My impression is that 
the fix is incorrect as the port should not be deleted in 
sas_destruct_devices(). I also tried this patch and got a NULL deference 
when I unplugged the disk from the expander.

We get the warn as the port is deleted before the device which is 
attached to it. The tricky part is that the port and devices are deleted 
in seperate work structs being processed in same work queue (shost wq). 
The first cannot be relinquished to allow the second to run.

One (undesirable) solution is to call sas_destruct_devices() directly 
from sas_unregister_dev().

>> On Feb 5, 2016, at 1:20 AM, wangyijing <wangyijing@huawei.com> wrote:
>>
>> Hi Dan and Praveen,
>>    I found a patch titled "libsas: fix "sysfs group not found" warnings at port teardown time" by google,
>> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html
>>
>> I found the same warning calltrace in my platform, but I didn't find the patch changes in the latest kernel 4.5-rc2.
>> So is this issue still in kernel ?
>>
>> I think your patch could fix this issue we found, but I'm worried about another problem.
>>
>> Now when unplug a disk
>>
>> LLDD report a event loss_of_singal
>>     sas_deform_port
>> 	sas_unregister_domain_devices
>> 		sas_unregister_dev
>> 			sas_discover_event(dev->port, DISCE_DESTRUCT);
>> 	sas_port_delete
>> 	phy->port = NULL;
>>
>> and after your patch changes
>>
>> LLDD report a event loss_of_singal
>> 	sas_deform_port
>> 		sas_unregister_domain_devices
>> 			sas_unregister_dev
>> 				sas_discover_event(dev->port, DISCE_DESTRUCT);
>> 	phy->port = NULL;
>>
>> ...
>> 	sas_destruct_devices
>> 		sas_port_delete   //now we actually delete the port device, but we set 	phy->port = NULL;  before this time.
>>
>>
>> So if we hotplug the disk quickly, plug,unplug,plug,
>> The new dmaed event(plug) would try to alloc and add a new port, but the old port device is still alive.
>> Another calltrace would occur
>>
>> WARNING: CPU: 0 PID: 1038 at lib/kobject.c:240 kobject_add_internal+0x258/0x318()
>> kobject_add_internal failed for port-0:0 with -EEXIST, don't try to register things with the same name in the same directory.
>> CPU: 0 PID: 1038 Comm: kworker/u64:2 Tainted: G        W       4.1.6+ #140
>> [<ffff800000089918>] dump_backtrace+0x0/0x124
>> [<ffff800000089a4c>] show_stack+0x10/0x1c
>> [<ffff80000009fcbc>] warn_slowpath_fmt+0x4c/0x58
>> [<ffff8000003cdc04>] device_add+0x28c/0x5b8
>> [<ffff80000040d4ec>] sas_port_add+0x20/0xbc
>> [<ffff80000040f3e8>] sas_porte_bytes_dmaed
>> [<ffff8000000b5504>] process_one_work+0x13c/0x344
>>
>> Because I am not a sas guy, so if you could comment this or post new patch, I would be thanks a lot!
>>
>> Thanks!
>> Yijing.
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


