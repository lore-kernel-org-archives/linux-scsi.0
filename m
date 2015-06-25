From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix invalid array indexing for HRRQ
Date: Thu, 25 Jun 2015 10:50:23 -0500
Message-ID: <558C233F.2080509@linux.vnet.ibm.com>
References: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com> <558C11F0.6020505@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <558C11F0.6020505@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2015 09:36 AM, Jiri Slaby wrote:
> On 06/25/2015, 03:44 PM, Brian King wrote:
>> Fixes another signed / unsigned array indexing bug in the ipr driver.
> 
> Could you be more specific? Specifically, I fail to see why you do +1
> twice now.

Sure. With the code that is currently upstream, when hrrq_index wraps, it
becomes a negative number. We do the modulo, but still have a negative number,
so we end up indexing backwards in the array. Given where the hrrq array is located
in memory, we probably won't actually reference memory we don't own, but nonetheless
ipr is still looking at data within struct ipr_ioa_cfg and interpreting it as
struct ipr_hrr_queue data, so bad things could certainly happen.

As far as the fix goes...

Each ipr adapter has anywhere from 1 to 16 HRRQs. By default, we use 2 on new adapters.
Let's take an example:

Assume ioa_cfg->hrrq_index=0x7fffffffe and ioa_cfg->hrrq_num=4:

The atomic_add_return will then return -1. We mod this with 3 and get -2, add one and
get -1 for an array index.

Some background on the different hrrq uses. On adapters which support more than a single
HRRQ, we dedicate HRRQ to adapter initialization and error interrupts so that we can
optimize the other queues for fast path I/O. So all normal I/O uses HRRQ 1-15. So we
want to spread the I/O requests across those HRRQs.

I should add here that with the default module parameter settings, this bug won't
hit, only when someone sets the ipr.number_of_msix parameter to a value larger than 3
is when bad things start to happen.

Thanks,

Brian


> 
>> --- linux/drivers/scsi/ipr.c~ipr_hrrq_index_fix	2015-06-23 11:43:18.151741523 -0500
>> +++ linux-bjking1/drivers/scsi/ipr.c	2015-06-23 11:43:18.157741435 -0500
>> @@ -1052,10 +1052,15 @@ static void ipr_send_blocking_cmd(struct
>>  
>>  static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
>>  {
>> +	unsigned int hrrq;
>> +
>>  	if (ioa_cfg->hrrq_num == 1)
>> -		return 0;
>> -	else
>> -		return (atomic_add_return(1, &ioa_cfg->hrrq_index) % (ioa_cfg->hrrq_num - 1)) + 1;
>> +		hrrq = 0;
>> +	else {
>> +		hrrq = atomic_add_return(1, &ioa_cfg->hrrq_index);
>> +		hrrq = ((hrrq + 1) % (ioa_cfg->hrrq_num - 1)) + 1;
>> +	}
>> +	return hrrq;
> 
> thanks,
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
