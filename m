From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v2 2/2] libsas: Enhance libsas hotplug
Date: Wed, 14 Jun 2017 17:15:43 +0800
Message-ID: <5940FEBF.3020009@huawei.com>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-3-git-send-email-wangyijing@huawei.com>
 <1fa27c30-aad7-2f19-4715-0ec02ef1a976@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1fa27c30-aad7-2f19-4715-0ec02ef1a976@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com
List-Id: linux-scsi@vger.kernel.org

>> In this patch, we try to solve these issues in following steps:
>> 1. create a new workqueue used to run sas event work, instead of scsi host workqueue,
>>    because we may block sas event work, we cannot block the normal scsi works.
>>    When libsas receive a phy down event, sas_deform_port would be called, and now we
>>    block sas_deform_port and wait for destruction work finish, in sas_destruct_devices,
>>    we may wait ata error handler, it would take a long time, so if do all stuff in scsi
>>    host workq, libsas may block other scsi works too long.
>> 2. create a new workqueue used to run sas discovery events work, instead of scsi host
>>    workqueue, because in some cases, eg. in revalidate domain event, we may unregister
>>    a sas device and discover new one, we must sync the execution, wait the remove process
>>    finish, then start a new discovery. So we must put the probe and destruct discovery
>>    events in a new workqueue to avoid deadlock.
>> 3. introudce a asd_sas_port level wait-complete and a sas_discovery level wait-complete
>>    we use former wait-complete to achieve a sas event atomic process and use latter to
>>    make a sas discovery sync.
>> 4. remove disco_mutex in sas_revalidate_domain, since now sas_revalidate_domain sync
>>    the destruct discovery event execution, it's no need to lock disco mutex there.
> 
> The way you've written the changelog suggests this patch should be split
> into 4 patches, each one taking care of one of your change items.

I will split it in next version.

Thanks!
Yijing.


> 
