From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 7/7] scsi: libsas: fix issue of swapping two sas disks
Date: Thu, 31 Jan 2019 16:34:32 +0000
Message-ID: <1135102e-e563-d3ab-9b44-d8691c3e6ccb@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
 <20190130082412.9357-8-yanaijie@huawei.com>
 <368786a4-9c18-7d5b-e62b-5dcdc634d3e6@huawei.com>
 <5C5263BD.7060002@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C5263BD.7060002@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 31/01/2019 02:55, Jason Yan wrote:
>
>
> On 2019/1/31 1:53, John Garry wrote:
>> On 30/01/2019 08:24, Jason Yan wrote:
>>> The work flow of revalidation now is scanning expander phy by the
>>> sequence of the phy and check if the phy have changed. This will leads
>>> to an issue of swapping two sas disks on one expander.
>>>
>>> Assume we have two sas disks, connected with expander phy10 and phy11:
>>>
>>> phy10: 5000cca04eb1001d  port-0:0:10
>>> phy11: 5000cca04eb043ad  port-0:0:11
>>>
>>> Swap these two disks, and imaging the following scenario:
>>>
>>> revalidation 1:
>>
>> What does "revalidation 1" actually mean?
>
> 'revalidation 1' means one entry in sas_discover_domain().
>
>>
>>>   -->phy10: 0 --> delete phy10 domain device
>>>   -->phy11: 5000cca04eb043ad (no change)
>>
>> so is disk 11 still inserted at this stage?
>
> Maybe, but that's what we read from the hardware.
>
>>
>>> revalidation done
>>>
>>> revalidation 2:
>>
>> is port-0:0:10 deleted now?
>>
>
> Yes. But we don't care about it.
>
>>>   -->step 1, check phy10:
>>>   -->phy10: 5000cca04eb043ad   --> add to wide port(port-0:0:11) (phy11
>>>        address is still 5000cca04eb043ad now)

We do not want this to happen and it seems to be the crux of the problem.

As an alternate to your solution, how about check if the PHY is an end 
device. If so, it should not form/join a wideport; that is, apart from 
dual-port disks, which I am not sure about - I think each port still has 
a unique WWN, so should be ok.

>>
>> So this should not happen. How are you physcially swapping them such
>> that phy11 address is still 5000cca04eb043ad? I don't see how this would
>> be true at revalidation 1.
>>
>
> This issue is because we always process the PHYs from 0 to max phy
> number. And please be aware of the real physcial address of the PHY and
> the address stored in the memory is not always the same.
> Actually when you checking phy10, phy11 physcial address is not
> 5000cca04eb043ad. But the address stored in domain device is still
> 5000cca04eb043ad. We have not get a chance to to read it because we are
> processing phy10 now, right?
>

I see.

> It's very easy to reproduce. I suggest you to do it yourself and look at
> the logs.
>

I can't physically access the backpane, and this is not the sort of 
thing which is easy to fake by hacking the driver.

And the log which you provided internally does not have much - if any - 
libsas logs to help me understand it.

>>>
>>>   -->step 2, check phy11:
>>>   -->phy11: 0  --> phy11 address is 0 now, but it's part of wide
>>>        port(port-0:0:11), the domain device will not be deleted.
>>> revalidation done
>>>
>>> revalidation 3:
>>>   -->phy10, 5000cca04eb043ad (no change)
>>>   -->phy11: 5000cca04eb1001d --> try to add port-0:0:11 but failed,
>>>        port-0:0:11 already exist, trigger a warning as follows
>>> revalidation done
>>>
>>> [14790.189699] sysfs: cannot create duplicate filename
>>> '/devices/pci0000:74/0000:74:02.0/host0/port-0:0/expander-0:0/port-0:0:11'
>>>
>>>
>>> [14790.201081] CPU: 25 PID: 5031 Comm: kworker/u192:3 Not tainted
>>> 4.16.0-rc1-191134-g138f084-dirty #228
>>> [14790.210199] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 EC UEFI
>>> Nemo 2.0 RC0 - B303 05/16/2018
>>> [14790.219323] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
>>> [14790.225404] Call trace:
>>> [14790.227842]  dump_backtrace+0x0/0x18c
>>> [14790.231492]  show_stack+0x14/0x1c
>>> [14790.234798]  dump_stack+0x88/0xac
>>> [14790.238101]  sysfs_warn_dup+0x64/0x7c
>>> [14790.241751]  sysfs_create_dir_ns+0x90/0xa0
>>> [14790.245835]  kobject_add_internal+0xa0/0x284
>>> [14790.250092]  kobject_add+0xb8/0x11c
>>> [14790.253570]  device_add+0xe8/0x598
>>> [14790.256960]  sas_port_add+0x24/0x50
>>> [14790.260436]  sas_ex_discover_devices+0xb10/0xc30
>>> [14790.265040]  sas_ex_revalidate_domain+0x1d8/0x518
>>> [14790.269731]  sas_revalidate_domain+0x12c/0x154
>>> [14790.274163]  process_one_work+0x128/0x2b0
>>> [14790.278160]  worker_thread+0x14c/0x408
>>> [14790.281897]  kthread+0xfc/0x128
>>> [14790.285026]  ret_from_fork+0x10/0x18
>>> [14790.288598] ------------[ cut here ]------------
>>>
>>> At last, the disk 5000cca04eb1001d is lost.
