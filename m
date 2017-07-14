From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 7/7] libsas: release disco mutex during waiting in
 sas_ex_discover_end_dev
Date: Fri, 14 Jul 2017 09:26:55 +0100
Message-ID: <ef2e2d25-5d20-2cb5-d77f-24cabd7a93fd@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-8-git-send-email-wangyijing@huawei.com>
 <5dc7927b-27ac-ed09-9718-6cbe3ab53e19@huawei.com>
 <596821E8.2000200@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9858 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdGNI1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 04:27:47 -0400
In-Reply-To: <596821E8.2000200@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>

On 14/07/2017 02:44, wangyijing wrote:
>
>
> 在 2017/7/14 0:10, John Garry 写道:
>> On 10/07/2017 08:06, Yijing Wang wrote:
>>> Disco mutex was introudced to prevent domain rediscovery competing
>>> with ata error handling(87c8331). If we have already hold the lock
>>> in sas_revalidate_domain and sync executing probe, deadlock caused,
>>> because, sas_probe_sata() also need hold disco_mutex. Since disco mutex
>>> use to prevent revalidata domain happen during ata error handler,
>>> it should be safe to release disco mutex when sync probe, because
>>> no new revalidate domain event would be process until the sync return,
>>> and the current sas revalidate domain finish.
>>>
>>
>> So with your changes we have a chain of synchronised events, running in separate queues. In theory it sounds ok.
>>
>> Then, as you said in the commit message, sas_revalidate_domain() holds the disco mutex while *all* these chained events occur; so we will continue to hold the mutex until we have revalidated the domain, meaning until we have finished destroying or probing new devices.
>>
>> But in the domain revalidation when you discover a new ATA device, function sas_probe_sata() wants to grab the disco mutex and you just temporarily release it, even though adding a new ATA device kicks in EH. This defeats the principal of using a mutex at all, which is (according to 87c8331 commit message) to mutually exclude the domain re-discovery (which has not actually finished) and the ATA EH (and device destruction).
>>
>> Anyway, since we are synchronising this series of events (broadcast event, domain rediscovery, and device destruction), surely it should be possible to include the ATA EH as well, so we can actually get rid of the disco mutex finally, right?
>
> Yes, disco mutex make this issue complex, I checked the commit history, Dan introudce disco mutex and probe/destruct discovery event, so it seems to
> need a big rework to the libsas process logic, I am so sorry that I have no more time to deal with it, I will leave today, if you like, you could
> rework my patchset or add additional changes based this patchset.
>
>

Since we are now synchronising everything, we should work on removing 
the disco mutex. After all, that is what a mutex is for - synchronising.

But the devil is in the detail...

>
>>
>> Note: I think that there is a problem which you have not seen. Consider removing a ATA disk with IO active conncted to an expander:
>> - LLDD sends brodcast event
>> - sas_revalidate_domain(), which grabs disco mutex
>> - revalidate finds dev is gone
>> - destruct device, which calls sas_rphy_delete
>>     - this waits on command queue to drain
>> - commands time out and EH thread kicks in
>>     - sas_ata_strategy_handler() called
>>     - domain revalidation disable attempted
>>         - try to grab disco mutex = Deadlock.
>
> Yes, it's a issue I haven't found.
>
>
> Thanks!
> Yijing.
>
>
>
>
> Hi John, I also agree to rework disco mutex
>
>
>>
>> Thanks,
>> John
>>
>>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>> CC: John Garry <john.garry@huawei.com>
>>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>>> CC: Ewan Milne <emilne@redhat.com>
>>> CC: Christoph Hellwig <hch@lst.de>
>>> CC: Tomas Henzl <thenzl@redhat.com>
>>> CC: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>  drivers/scsi/libsas/sas_expander.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>>> index 9d26c28..077024e 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -776,6 +776,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>>>      struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
>>>      struct domain_device *child = NULL;
>>>      struct sas_rphy *rphy;
>>> +    bool prev_lock;
>>>      int res;
>>>
>>>      if (phy->attached_sata_host || phy->attached_sata_ps)
>>> @@ -803,6 +804,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>>>      sas_ex_get_linkrate(parent, child, phy);
>>>      sas_device_set_phy(child, phy->port);
>>>
>>> +    prev_lock = mutex_is_locked(&child->port->ha->disco_mutex);
>>>  #ifdef CONFIG_SCSI_SAS_ATA
>>>      if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
>>>          res = sas_get_ata_info(child, phy);
>>> @@ -832,7 +834,11 @@ static struct domain_device *sas_ex_discover_end_dev(
>>>                      SAS_ADDR(parent->sas_addr), phy_id, res);
>>>              goto out_list_del;
>>>          }
>>> +        if (prev_lock)
>>> +            mutex_unlock(&child->port->ha->disco_mutex);
>>>          sas_disc_wait_completion(child->port, DISCE_PROBE);
>>> +        if (prev_lock)
>>> +            mutex_lock(&child->port->ha->disco_mutex);
>>>
>>>      } else
>>>  #endif
>>> @@ -861,7 +867,11 @@ static struct domain_device *sas_ex_discover_end_dev(
>>>                      SAS_ADDR(parent->sas_addr), phy_id, res);
>>>              goto out_list_del;
>>>          }
>>> +        if (prev_lock)
>>> +            mutex_unlock(&child->port->ha->disco_mutex);
>>>          sas_disc_wait_completion(child->port, DISCE_PROBE);
>>> +        if (prev_lock)
>>> +            mutex_lock(&child->port->ha->disco_mutex);
>>>      } else {
>>>          SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
>>>                  phy->attached_tproto, SAS_ADDR(parent->sas_addr),
>>>
>>
>>
>>
>> .
>>
>
>
> .
>
