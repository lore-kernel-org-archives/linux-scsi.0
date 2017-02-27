From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when
 !CONFIG_LBDAF
Date: Mon, 27 Feb 2017 11:13:24 -0600
Message-ID: <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
 <1488211985.2656.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488211985.2656.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart -

Thanks for taking the time to look this over.

On 02/27/2017 10:13 AM, Bart Van Assche wrote:
> On Mon, 2017-02-27 at 09:22 -0600, Steven J. Magnani wrote:
>> @@ -2122,7 +2122,10 @@ static int read_capacity_16(struct scsi_
>>   		return -ENODEV;
>>   	}
>>   
>> -	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
>> +	/* Make sure logical_to_sectors() won't overflow */
>> +	lba_in_sectors = lba << (ilog2(sector_size) - 9);
>> +	if ((sizeof(sdkp->capacity) == 4) &&
>> +	    ((lba >= 0xffffffffULL) || (lba_in_sectors >= 0xffffffffULL))) {
>>   		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>>   			"kernel compiled with support for large block "
>>   			"devices.\n");
>> @@ -2162,6 +2165,7 @@ static int read_capacity_10(struct scsi_
>>   	int the_result;
>>   	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
>>   	sector_t lba;
>> +	unsigned long long lba_in_sectors;
>>   	unsigned sector_size;
>>   
>>   	do {
>> @@ -2208,7 +2212,10 @@ static int read_capacity_10(struct scsi_
>>   		return sector_size;
>>   	}
>>   
>> -	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
>> +	/* Make sure logical_to_sectors() won't overflow */
>> +	lba_in_sectors = ((unsigned long long) lba) << (ilog2(sector_size) - 9);
>> +	if ((sizeof(sdkp->capacity) == 4) &&
>> +	    (lba_in_sectors >= 0xffffffffULL)) {
>>   		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>>   			"kernel compiled with support for large block "
>>   			"devices.\n");
> Why are the two checks slightly different? Could the same code be used for
> both checks?
The checks are different because with READ CAPACITY(16) a _really_ huge 
device could report a max LBA so large that left-shifting it causes bits 
to drop off the end. That's not an issue with READ CAPACITY(10) because 
at most the 32-bit LBA reported by the device will become a 35-bit value 
(since the max supported block size is 4096 == (512 << 3)).

> BTW, using the macro below would make the above checks less
> verbose and easier to read:
>
> /*
>   * Test whether the result of a shift-left operation would be larger than
>   * what fits in a variable with the type of @a.
>   */
> #define shift_left_overflows(a, b)					\
> 	({								\
> 		typeof(a) _minus_one = -1LL;				\
> 		typeof(a) _plus_one = 1;				\
> 		bool _a_is_signed = _minus_one < 0;			\
> 		int _shift = sizeof(a) * 8 - ((b) + _a_is_signed);	\
> 		_shift < 0 || ((a) & ~((_plus_one << _shift) - 1)) != 0;\
> 	})
>
> Bart.
Perhaps but I am not a fan of putting braces in non-obvious places such 
as within array subscripts (which I've encountered recently) or 
conditional expressions, which is what this amounts to.

Regards,
------------------------------------------------------------------------
  Steven J. Magnani               "I claim this network for MARS!
  www.digidescorp.com              Earthling, return my space modulator!"

  #include <standard.disclaimer>
