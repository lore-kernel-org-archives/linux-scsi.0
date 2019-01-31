From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 6/7] scsi: libsas: reset the phy address if discover
 failed
Date: Thu, 31 Jan 2019 09:10:24 +0000
Message-ID: <8ca27632-bf8c-b8eb-bb56-00e04c559ac1@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
 <20190130082412.9357-7-yanaijie@huawei.com>
 <e6bb5696-b2ad-d546-5571-1e2fe39edb61@huawei.com> <5C5259B4.10005@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C5259B4.10005@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 31/01/2019 02:13, Jason Yan wrote:
>
>
> On 2019/1/31 1:36, John Garry wrote:
>> On 30/01/2019 08:24, Jason Yan wrote:
>>> When we failed to discover the device, the phy address is still kept

/s/phy/PHY/

>>> in ex_phy. So when the next time we revalidate this phy the
>>> address and device type is the same, it will be considered as flutter
>>> and will not be discovered again. So the device will not be brought up.
>>>
>>> Fix this by reset the phy address to the initial value. Then
>>> in the next revalidation the device will be discovered agian.
>>
>> Why fail to discover the device? I wonder in which scenario you have
>> seen this, such that it is worth rediscovery.
>>
>
> The test guys have seen this for several times, especially after LLDD
> changed the logic of lldd_dev_found and may return error now.

We're finding that a specific SATA disk stays in STP pending for some 
time and we fail the init in lldd dev found, like you say.

However, I think that we should ensure that this passes, as with your 
change I find we get some looping of dev found and lost until it finally 
recovers.

Regardless, I think that your change on its own is ok, so:
Reviewed-by: John Garry <john.garry@huawei.com>


>
>
>>>
>>> Tested-by: Chen Liangfei <chenliangfei1@huawei.com>
>>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>>> CC: Xiaofei Tan <tanxiaofei@huawei.com>
>>> CC: John Garry <john.garry@huawei.com>
>>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>>> CC: Ewan Milne <emilne@redhat.com>
>>> CC: Christoph Hellwig <hch@lst.de>
>>> CC: Tomas Henzl <thenzl@redhat.com>
>>> CC: Dan Williams <dan.j.williams@intel.com>
>>> CC: Hannes Reinecke <hare@suse.com>
>>> ---
>>>  drivers/scsi/libsas/sas_expander.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c
>>> b/drivers/scsi/libsas/sas_expander.c
>>> index 6e56ebdc2148..e781941a7088 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -1100,6 +1100,13 @@ static int sas_ex_discover_dev(struct
>>> domain_device *dev, int phy_id)
>>>                           i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
>>>              }
>>>          }
>>> +    } else {
>>> +        /* if we failed to discover this device, we have to
>>> +         * reset the expander phy attached address so that we
>>> +         * will not treat the phy as flutter in the next
>>> +         * revalidation
>>> +         */
>>> +        memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
>>>      }
>>>
>>>      return res;
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
