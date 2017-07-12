From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 1/7] libsas: Use static sas event pool to appease sas
 event lost
Date: Wed, 12 Jul 2017 11:13:38 +0100
Message-ID: <a3a7c434-cbd8-c84a-8ec1-5345f9ce4056@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-2-git-send-email-wangyijing@huawei.com>
 <e45b90d1-9547-3845-9114-b794277d6c72@huawei.com>
 <5965840B.2000909@huawei.com>
 <0af2bdd0-90ce-6b04-bbf3-9b8ffbb34b38@huawei.com>
 <5965E22F.7020309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5965E22F.7020309@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 12/07/2017 09:47, wangyijing wrote:
>
>
> 在 2017/7/12 16:17, John Garry 写道:
>> On 12/07/2017 03:06, wangyijing wrote:
>>>>> -    unsigned long port_events_pending;
>>>>> -    unsigned long phy_events_pending;
>>>>> +    struct asd_sas_event   port_events[PORT_POOL_SIZE];
>>>>> +    struct asd_sas_event   phy_events[PHY_POOL_SIZE];
>>>>>
>>>>>      int error;
>>>>
>>>> Hi Yijing,
>>>>
>>>> So now we are creating a static pool of events per PHY/port, instead of having 1 static work struct per event per PHY/port. So, for sure, this avoids the dynamic event issue of system memory exhaustion which we discussed in v1+v2 series. And it seems to possibly remove issue of losing SAS events.
>>>>
>>>> But how did you determine the pool size for a PHY/port? It would seem to be 5 * #phy events or #port events (which is also 5, I figure by coincidence). How does this deal with flutter of >25 events?
>>>
>>> There is no special meaning for the pool size, if flutter of > 25 events, notify sas events will return error, and the further step work is depending on LLDD drivers.
>>> I hope libsas could do more work in this case, but now it seems a little difficult, this patch may be a interim fix, until we find a perfect solution.
>>
>> The principal of having a fixed-sized pool is ok, even though the pool size needs more consideration.
>>
>> However my issue is how to handle pool exhaustion. For a start, relaying info to the LLDD that the event notification failed is probably not the way to go. I only now noticed "scsi: sas: scsi_queue_work can fail, so make callers aware" made it into the kernel; as I mentioned in response to this patch, the LLDD does not know how to handle this (and no LLDDs do actually handle this).
>>
>> I would say it is better to shut down the PHY from libsas (As Dan mentioned in the v1 series) when the pool exhausts, under the assumption that the PHY has gone into some erroneous state. The user can later re-enable the PHY from sysfs, if required.
>
> I considered this suggestion, and what I am worried about are, first if we disable phy once the sas event pool exhausts, it may hurt the pending sas event process which has been queued,

I don't see how it affects currently queued events - they should just be 
processed normally. As for LLDD reporting events when the pool is 
exhausted, they are just lost.

> second, if phy was disabled, and no one trigger the reenable by sysfs, the LLDD has no way to post new sas phy events.

For the extreme scenario of pool becoming exhausted and PHY being 
disabled, it should remain disabled until user takes some action to fix 
originating problem.

>
> Thanks!
> Yijing.
>
>>
>> Much appreciated,
>> John
>>
>>>
>>> Thanks!
>>> Yijing.
>>>
>>>>
>>>> Thanks,
>>>> John
>>>>
>>>>
>>>> .
>>>>
>>>
>>>
>>> .
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
