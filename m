From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 1/7] scsi: libsas: reset the negotiated_linkrate when
 phy is down
Date: Thu, 31 Jan 2019 09:00:47 +0000
Message-ID: <21c9fcdb-b0ce-6205-d53a-12ff68b0a5f7@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
 <20190130082412.9357-2-yanaijie@huawei.com>
 <6b06f81e-9ede-014d-b678-1996044106e3@huawei.com>
 <5C524B3B.5030007@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C524B3B.5030007@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 31/01/2019 01:11, Jason Yan wrote:
>
>
> On 2019/1/30 21:08, John Garry wrote:
>> On 30/01/2019 08:24, Jason Yan wrote:
>>> If the device is unplugged or disconnected, the negotiated_linkrate
>>> still can be seen from the userspace by sysfs. This makes people
>>> confused and leaks information of the device last used. So let's reset
>>> the negotiated_linkrate after the phy is down.
>>>
>>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>>> CC: John Garry <john.garry@huawei.com>
>>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>>> CC: Ewan Milne <emilne@redhat.com>
>>> CC: Christoph Hellwig <hch@lst.de>
>>> CC: Tomas Henzl <thenzl@redhat.com>
>>> CC: Dan Williams <dan.j.williams@intel.com>
>>> CC: Hannes Reinecke <hare@suse.com>
>>> ---
>>>  drivers/scsi/libsas/sas_expander.c | 2 ++
>>>  include/scsi/libsas.h              | 3 +++
>>>  2 files changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c
>>> b/drivers/scsi/libsas/sas_expander.c
>>> index 17eb4185f29d..7b0e6dcef6e6 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -1904,6 +1904,8 @@ static void sas_unregister_devs_sas_addr(struct
>>> domain_device *parent,
>>>                  &parent->port->sas_port_del_list);
>>>          phy->port = NULL;
>>>      }
>>> +    if (phy->phy)
>>> +        phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
>>
>> Does this work for both PHYs which were either directly attached or just
>> forming part of a wideport?
>>
>> Please also note that the expander PHY which was previously attached may
>> also show the incorrect value.
>
> Good catch, all PHYs need to do this, not only the last PHY of the
> wideport.

Please also consider this:
- For the expander host PHY, it will also go down. I find however on my 
system that this generates no broadcast event, but the I find that the 
event count has changed for that PHY. So the expander PHY's state would 
also be wrong.  So maybe we need to yet again inject a broadcast.

- we should update PHY sysfs entries for device_type, sas_addr, and 
target protocols

>
>>
>>>  }
>>>
>>>  static int sas_discover_bfs_by_root_level(struct domain_device *root,
>>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>>> index 3de3b10da19a..420156cea3ee 100644
>>> --- a/include/scsi/libsas.h
>>> +++ b/include/scsi/libsas.h
>>> @@ -448,6 +448,9 @@ static inline void sas_phy_disconnected(struct
>>> asd_sas_phy *phy)
>>>  {
>>>      phy->oob_mode = OOB_NOT_CONNECTED;
>>>      phy->linkrate = SAS_LINK_RATE_UNKNOWN;
>>> +
>>
>> Then idea behind sas_phy_disconnected() was to set root PHY values only:
>>
>> /* Before calling a notify event, LLDD should use this function
>>   * when the link is severed (possibly from its tasklet).
>>   * The idea is that the Class only reads those, while the LLDD,
>>   * can R/W these (thus avoiding a race)
>>
>> libsas does set sas_phy negotiated_linkrate (but only for expander
>> PHYs), so not the perfect place to set this. I'm nitpicking a bit here.
>>
>
> I don't want to put it here. I asked chenxiang to fix this in LLDD, but
> he insist libsas to do this. Would you please discuss with chenxiang and
> come to an agreement?

I'm ok with the LLDD.

For sure, adding it here is convenient and would resolve the issue for 
other LLDDs using libsas, but setting it directly in the LLDD seems like 
the right thing to do, since this is what we do for other sas_phy rates.

>
>>
>>> +    if (phy->phy)
>>> +        phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
>>>  }
>>>
>>>  static inline unsigned int to_sas_gpio_od(int device, int bit)
>>
>> Thanks,
>>
>>>
>>
>>
>>
>>
>>
>> .
>>
>
>
> .
>
