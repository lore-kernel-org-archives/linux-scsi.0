From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Wed, 14 Jun 2017 17:04:28 +0800
Message-ID: <5940FC1C.5050000@huawei.com>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
 <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Yousong He <heyousong@huawei.com>
List-Id: linux-scsi@vger.kernel.org

>>  static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>>  {
>> +	struct sas_ha_event *ev;
>> +
>>  	BUG_ON(event >= HA_NUM_EVENTS);
>>  
>> -	sas_queue_event(event, &sas_ha->pending,
>> -			&sas_ha->ha_events[event].work, sas_ha);
>> +	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
>> +	if (!ev)
>> +		return;
> GFP_ATOMIC allocations can fail and then no events will be queued *and* we
> don't report the error back to the caller.
> 

Yes, it's really a problem, but I don't find a better solution, do you have some suggestion ?

> 
> 
>> index 64e9cdd..c227a8b 100644
>> --- a/drivers/scsi/libsas/sas_init.c
>> +++ b/drivers/scsi/libsas/sas_init.c
>> @@ -111,10 +111,6 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
>>  
>>  void sas_hae_reset(struct work_struct *work)
>>  {
>> -	struct sas_ha_event *ev = to_sas_ha_event(work);
>> -	struct sas_ha_struct *ha = ev->ha;
>> -
>> -	clear_bit(HAE_RESET, &ha->pending);
>>  }
> 
> I don't really get why you need a stubbed out sas_hae_reset(). Can't we
> just kill it if it doesn't have anything left to do?

I have no idea about this function history, I agree clean it out.

> 
> 
