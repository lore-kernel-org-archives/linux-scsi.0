From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Wed, 14 Jun 2017 14:08:16 +0100
Message-ID: <00f4b3f1-ada0-d07d-2640-d902a437b24e@huawei.com>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
 <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de> <5940FC1C.5050000@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5940FC1C.5050000@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Yousong He <heyousong@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 14/06/2017 10:04, wangyijing wrote:
>>>  static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>>> >>  {
>>> >> +	struct sas_ha_event *ev;
>>> >> +
>>> >>  	BUG_ON(event >= HA_NUM_EVENTS);
>>> >>
>>> >> -	sas_queue_event(event, &sas_ha->pending,
>>> >> -			&sas_ha->ha_events[event].work, sas_ha);
>>> >> +	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
>>> >> +	if (!ev)
>>> >> +		return;
>> > GFP_ATOMIC allocations can fail and then no events will be queued *and* we
>> > don't report the error back to the caller.
>> >
> Yes, it's really a problem, but I don't find a better solution, do you have some suggestion ?
>

Dan raised an issue with this approach, regarding a malfunctioning PHY 
which spews out events. I still don't think we're handling it safely. 
Here's the suggestion:
- each asd_sas_phy owns a finite-sized pool of events
- when the event pool becomes exhausted, libsas stops queuing events 
(obviously) and disables the PHY in the LLDD
- upon attempting to re-enable the PHY from sysfs, libsas first checks 
that the pool is still not exhausted

If you cannot find a good solution, then let us know and we can help.

John
