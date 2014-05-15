From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/2] target: Don't allow setting WC emulation if device
 doesn't support
Date: Wed, 14 May 2014 17:22:36 -0700
Message-ID: <537408CC.2070704@redhat.com>
References: <1400107687-15797-1-git-send-email-agrover@redhat.com> <1400112426.7127.60.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400112426.7127.60.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/14/2014 05:07 PM, Nicholas A. Bellinger wrote:
> On Wed, 2014-05-14 at 15:48 -0700, Andy Grover wrote:
>> Just like for pSCSI, if the transport sets get_write_cache, then it is
>> not valid to enable write cache emulation for it. Return an error.
>>
>> see https://bugzilla.redhat.com/show_bug.cgi?id=1082675
>>
>> Reviewed-by: Chris Leech <cleech@redhat.com>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>> ---
>>   drivers/target/target_core_device.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
>> index 65001e1..d461ecb 100644
>> --- a/drivers/target/target_core_device.c
>> +++ b/drivers/target/target_core_device.c
>> @@ -798,10 +798,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
>>   		pr_err("emulate_write_cache not supported for pSCSI\n");
>>   		return -EINVAL;
>>   	}
>> -	if (dev->transport->get_write_cache) {
>> -		pr_warn("emulate_write_cache cannot be changed when underlying"
>> -			" HW reports WriteCacheEnabled, ignoring request\n");
>> -		return 0;
>> +	if (flag &&
>> +	    dev->transport->get_write_cache) {
>> +		pr_err("emulate_write_cache not supported for this device\n");
>> +		return -EINVAL;
>>   	}
>>
>>   	dev->dev_attrib.emulate_write_cache = flag;
>
> Allowing the target WCE bit to be disabled when the underlying device
> has WCE enabled is a recipe for disaster.
>
> How is the initiator supposed to know when to flush writes if the target
> is telling it that WCE is disabled.
>
> I'll take change to return -EINVAL here, but the other part is dangerous
> and wrong.

This is for backstores like iblock, where we're actually getting WCE 
yes/no from the backing block device. This configfs entry is not for WCE 
yes/no, it is for WCE *emulation* yes/no.

So we should allow emulate_write_cache to be set to 0, because we're not 
emulating the write cache value, we're using the actual value... but we 
shouldn't allow it to be enabled if we're getting real WCE yes/no values.

So I'm still not seeing how this is not the right thing to do, 
especially since it's identical to the pscsi case immediately above.

Regards -- Andy
