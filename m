From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 1/7] libsas: Use static sas event pool to appease sas
 event lost
Date: Wed, 12 Jul 2017 10:06:03 +0800
Message-ID: <5965840B.2000909@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-2-git-send-email-wangyijing@huawei.com>
 <e45b90d1-9547-3845-9114-b794277d6c72@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e45b90d1-9547-3845-9114-b794277d6c72@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

>> -    unsigned long port_events_pending;
>> -    unsigned long phy_events_pending;
>> +    struct asd_sas_event   port_events[PORT_POOL_SIZE];
>> +    struct asd_sas_event   phy_events[PHY_POOL_SIZE];
>>
>>      int error;
> 
> Hi Yijing,
> 
> So now we are creating a static pool of events per PHY/port, instead of having 1 static work struct per event per PHY/port. So, for sure, this avoids the dynamic event issue of system memory exhaustion which we discussed in v1+v2 series. And it seems to possibly remove issue of losing SAS events.
> 
> But how did you determine the pool size for a PHY/port? It would seem to be 5 * #phy events or #port events (which is also 5, I figure by coincidence). How does this deal with flutter of >25 events?

There is no special meaning for the pool size, if flutter of > 25 events, notify sas events will return error, and the further step work is depending on LLDD drivers.
I hope libsas could do more work in this case, but now it seems a little difficult, this patch may be a interim fix, until we find a perfect solution.

Thanks!
Yijing.

> 
> Thanks,
> John
> 
> 
> .
> 
