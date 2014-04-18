From: Jerome Martin <tramjoe.merin@gmail.com>
Subject: Re: [PATCH] target: Allow non-supporting backends to set pi_prot_type
 to 0
Date: Fri, 18 Apr 2014 16:25:35 +0200
Message-ID: <535135DF.6000708@gmail.com>
References: <1397596392-32552-1-git-send-email-agrover@redhat.com> <1397780048.28248.76.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1397780048.28248.76.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, frirajder@gmail.com
List-Id: linux-scsi@vger.kernel.org

Excellent, thank you Nic and Andy, that will fix the issue with 
rtslib/targetcli main branch too.

On 04/18/2014 02:14 AM, Nicholas A. Bellinger wrote:
> On Tue, 2014-04-15 at 14:13 -0700, Andy Grover wrote:
>> Userspace tools assume if a value is read from configfs, it is valid
>> and will not cause an error if the same value is written back. The only
>> valid value for pi_prot_type for backends not supporting DIF is 0, so allow
>> this particular value to be set without returning an error.
>>
>> Reported-by: Krzysztof Chojnowski <frirajder@gmail.com>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>> ---
>>   drivers/target/target_core_device.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
>> index 65001e1..382b66b 100644
>> --- a/drivers/target/target_core_device.c
>> +++ b/drivers/target/target_core_device.c
>> @@ -936,6 +936,10 @@ int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
>>   		return 0;
>>   	}
>>   	if (!dev->transport->init_prot || !dev->transport->free_prot) {
>> +		/* 0 is only allowed value for non-supporting backends */
>> +		if (flag == 0)
>> +			return 0;
>> +
>>   		pr_err("DIF protection not supported by backend: %s\n",
>>   		       dev->transport->name);
>>   		return -ENOSYS;
>
> Applied to target-pending/queue, and will merge into master as soon as
> the rebase to v3.15-rc occurs.
>
> Thanks!
>
> --nab
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
