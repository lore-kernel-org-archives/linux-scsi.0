From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH 3/8] scsi: libsas: always unregister the old device if
 going to discover new
Date: Fri, 1 Jun 2018 08:28:16 +0800
Message-ID: <5B109320.8040104@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-4-yanaijie@huawei.com>
 <8d3c7ee0-b76e-841f-b8e3-0346d22ae0b7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d3c7ee0-b76e-841f-b8e3-0346d22ae0b7@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 2018/5/31 23:09, John Garry wrote:
> On 29/05/2018 03:23, Jason Yan wrote:
>> If we went into sas_rediscover_dev() the attached_sas_addr was already
>> insured not to be zero. So it's unnecessary to check if the
>> attached_sas_addr is zero.
>>
>> And although if the sas address is not changed, we always have to
>> unregister the old device when we are going to register a new one. We
>> cannot just leave the device there and bring up the new.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: chenxiang <chenxiang66@hisilicon.com>
>> CC: John Garry <john.garry@huawei.com>
>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>> CC: Ewan Milne <emilne@redhat.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> CC: Tomas Henzl <thenzl@redhat.com>
>> CC: Dan Williams <dan.j.williams@intel.com>
>> CC: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/libsas/sas_expander.c | 13 +++++--------
>>  1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c
>> b/drivers/scsi/libsas/sas_expander.c
>> index 8b7114348def..629c580d906b 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -2054,14 +2054,11 @@ static int sas_rediscover_dev(struct
>> domain_device *dev, int phy_id, bool last)
>>          return res;
>>      }
>>
>> -    /* delete the old link */
>> -    if (SAS_ADDR(phy->attached_sas_addr) &&
>> -        SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
>> -        SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
>> -                SAS_ADDR(dev->sas_addr), phy_id,
>> -                SAS_ADDR(phy->attached_sas_addr));
>> -        sas_unregister_devs_sas_addr(dev, phy_id, last);
>> -    }
>
> The preceeding checks in code check for no device/comm fail or SATA
> flutter.
>
> If we're rediscovering the device and the SAS address has not changed,
> then why previously still try to discover a new device? I'm guessing
> sas_discover_new() had no affect in this case, since maybe since the PHY
> was already discovered.

When we went here, means it is not flutter, something must change,
either the device type or the phy address. Then we call
sas_discover_new(). And sas_discover_new() sure *have* effect in this
case. Please check sas_discover_new() carefully.

  But that would not make sense since you say "we
> are going to register a new one". Or, if we are always going to register
> a new one, how did we ensure we always unregistered the old device
> previously (when SAS address did not change)?
>

If SAS address did not change, the device type must changed, otherwise
it will be a "flutter" and won't get here. So if the device type
changed, do we have a reason to keep the device? I don't think so.

>> +    /* we always have to delete the old device when we went here */
>> +    SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
>> +            SAS_ADDR(dev->sas_addr), phy_id,
>> +            SAS_ADDR(phy->attached_sas_addr));
>> +    sas_unregister_devs_sas_addr(dev, phy_id, last);
>>
>>      return sas_discover_new(dev, phy_id);
>>  }
>>
>
>
>
> .
>
