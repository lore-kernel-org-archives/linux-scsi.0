From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Thu, 15 Jun 2017 16:21:53 +0800
Message-ID: <594243A1.7050200@huawei.com>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
 <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de> <5940FC1C.5050000@huawei.com>
 <00f4b3f1-ada0-d07d-2640-d902a437b24e@huawei.com>
 <59423956.6070905@huawei.com>
 <1f9d5190-97f2-f98e-c7c4-80e259346e91@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1f9d5190-97f2-f98e-c7c4-80e259346e91@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Yousong He <heyousong@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/6/15 16:00, John Garry 写道:
> On 15/06/2017 08:37, wangyijing wrote:
>>
>>
>> 在 2017/6/14 21:08, John Garry 写道:
>>> On 14/06/2017 10:04, wangyijing wrote:
>>>>>>  static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>>>>>>>>  {
>>>>>>>> +    struct sas_ha_event *ev;
>>>>>>>> +
>>>>>>>>      BUG_ON(event >= HA_NUM_EVENTS);
>>>>>>>>
>>>>>>>> -    sas_queue_event(event, &sas_ha->pending,
>>>>>>>> -            &sas_ha->ha_events[event].work, sas_ha);
>>>>>>>> +    ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
>>>>>>>> +    if (!ev)
>>>>>>>> +        return;
>>>>>> GFP_ATOMIC allocations can fail and then no events will be queued *and* we
>>>>>> don't report the error back to the caller.
>>>>>>
>>>> Yes, it's really a problem, but I don't find a better solution, do you have some suggestion ?
>>>>
>>>
>>> Dan raised an issue with this approach, regarding a malfunctioning PHY which spews out events. I still don't think we're handling it safely. Here's the suggestion:
>>> - each asd_sas_phy owns a finite-sized pool of events
>>> - when the event pool becomes exhausted, libsas stops queuing events (obviously) and disables the PHY in the LLDD
>>> - upon attempting to re-enable the PHY from sysfs, libsas first checks that the pool is still not exhausted
>>>
>>> If you cannot find a good solution, then let us know and we can help.
>>
>> Hi John and Dan, what's event you found on malfunctioning PHY, if the event is PORTE_BROADCAST_RCVD, since
>> every PORTE_BROADCAST_RCVD libsas always call sas_revalidate_domain(), what about keeping a broadcast waiting(not queued in workqueue)
>> and discard others. If the event is other types, things may become knotty.
>>
> 
> As I mentioned in the v1 series discussion, I found a poorly connected expander PHY was spewing out PHY up and loss of signal events continuously. This is the sort of situation we should protect against. Current solution is ok, as it uses a static event per port/PHY/HA.
> 
> The point is that we cannot allow a PHY to continuously send events to libsas, which may lead to memory exhaustion.

The current solution won't introduce memory exhaustion, but it's not ok, since the root of this issue is it may lost event which is normal.
If we cannot identify the abnormal PHY, I think your mem pool idea is a candidate solution.

> 
> John
> 
>>
>>>
>>> John
>>>
>>>
>>> .
>>>
>>
>>
>> .
>>
> 
> 
> 
> .
> 
