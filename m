From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH 3/3] drivers: hwmon: i5k_amb: remove unnecessary #ifdef
 MODULE
Date: Wed, 5 Jun 2019 23:59:09 +0000
Message-ID: <e91fabd4-a7a4-3afa-9f3a-95a6d90e8c7b@metux.net>
References: <1559397700-15585-1-git-send-email-info@metux.net>
 <1559397700-15585-4-git-send-email-info@metux.net>
 <20190601224946.GA6483@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190601224946.GA6483@roeck-us.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01.06.19 22:49, Guenter Roeck wrote:
> On Sat, Jun 01, 2019 at 04:01:40PM +0200, Enrico Weigelt, metux IT consult wrote:
>> The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
>> so the extra check here is not necessary.
>>
>> Signed-off-by: Enrico Weigelt <info@metux.net>
>> ---
>>   drivers/hwmon/i5k_amb.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
>> index b09c39a..b674c2f 100644
>> --- a/drivers/hwmon/i5k_amb.c
>> +++ b/drivers/hwmon/i5k_amb.c
>> @@ -482,14 +482,12 @@ static int i5k_channel_probe(u16 *amb_present, unsigned long dev_id)
>>   	{ 0, 0 }
>>   };
>>   
>> -#ifdef MODULE
>>   static const struct pci_device_id i5k_amb_ids[] = {
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
>>   	{ 0, }
>>   };
>>   MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
>> -#endif
>>   
> 
> I'd rather know what this table is used for in the first place.

Seems it's really just used for the module loader, while actual probing
is using a different table. IMHO, the worst thing my patch could do is
introducing a warning on unused variable (IMHO shouldn't happen when
it's static const).

I've just rewritten it to move everything into i5k_amb_ids ... just need
to run build tests on it (unfortunately can't run-test, as I don't have
that device).


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
