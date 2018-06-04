From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH 4/8] scsi: libsas: trigger a new revalidation to discover
 the device
Date: Mon, 4 Jun 2018 09:01:38 +0800
Message-ID: <5B148F72.3000000@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-5-yanaijie@huawei.com>
 <013c5c91-9792-7951-95ed-22daae2e2dbe@huawei.com>
 <5B109A79.6060907@huawei.com>
 <6b030b96-9733-f6b5-e8af-d1d488c52fb4@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b030b96-9733-f6b5-e8af-d1d488c52fb4@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 2018/6/1 18:02, John Garry wrote:
> I mean that since libsas does disocovery/revalidation for all expander
> PHYS for a single event, than all discovery/revalidation should be
> synchronised with that same event. I don't mean that for a given
> expander PHY which originated a broadcast event, the
> revalidation/discovery for that PHY should be synchronised with that
> same event. Like you said, I don't think it's possible.
>
> On another point, one of the reasons to synchronise event processing was
> so events are not lost and are processed in order. In principle, by
> chaining these bcast events we lose that, since other PHY events may be
> queued before we queue the new artificial bcast events.
>

I got what you mean. I will try to keep the principle of synchronised 
event processing.

>>
>> But if you mean we shall do this device removing and rediscovering in
>> one revalidation if it is not a "flutter", I think we can wrap a new
>> function for sas_revalidate_domain(), such as:
>>
>>
>> while (need_to_revalidate_again)
>>     need_to_revalidate_again = sas_revalidate_domain()
>>
>> In this way the sas_port adding/removing is packed in one loop, we won't
>> have the annoyance of "duplicate filename" warning. What do you
>> think?
>
> Something like that, where all the discovery/revalidation and related
> device + port processing is done before we complete the revalidation
> event processing. A single revalidation event may defer do device+port
> processing multiple times.
