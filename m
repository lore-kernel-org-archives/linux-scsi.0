From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V3 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Fri, 19 Jul 2013 23:56:27 +0530
Message-ID: <51E984D3.80502@codeaurora.org>
References: <1373361310-30674-1-git-send-email-sthumma@codeaurora.org> <1373361310-30674-2-git-send-email-sthumma@codeaurora.org> <002501ce7d71$4c7a8f40$e56fadc0$%jun@samsung.com> <51DE7D08.9000306@codeaurora.org> <001a01ce82c5$8bd47d50$a37d77f0$%jun@samsung.com> <51E76596.5090509@codeaurora.org> <001c01ce8486$9357c510$ba074f30$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <001c01ce8486$9357c510$ba074f30$%jun@samsung.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'Dolev Raviv' <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 7/19/2013 7:17 PM, Seungwon Jeon wrote:
> On Thu, July 18, 2013, Sujit Reddy Thumma wrote:
>>>>>> + * ufshcd_wait_for_register - wait for register value to change
>>>>>> + * @hba - per-adapter interface
>>>>>> + * @reg - mmio register offset
>>>>>> + * @mask - mask to apply to read register value
>>>>>> + * @val - wait condition
>>>>>> + * @interval_us - polling interval in microsecs
>>>>>> + * @timeout_ms - timeout in millisecs
>>>>>> + *
>>>>>> + * Returns final register value after iteration
>>>>>> + */
>>>>>> +static u32 ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>>>>>> +		u32 val, unsigned long interval_us, unsigned long timeout_ms)
>>>>> I feel like this function's role is to wait for clearing register (specially, doorbells).
>>>>> If you really don't intend to apply other all register, I think it would better to change the
>>>> function name.
>>>>> ex> ufshcd_wait_for_clear_doorbell or ufshcd_wait_for_clear_reg?
>>>>
>>>> Although, this API is introduced in this patch and used only for
>>>> clearing the doorbell, I have intentionally made it generic to avoid
>>>> duplication of wait condition code in future (not just clearing but
>>>> also for setting a bit). For example, when we write to HCE.ENABLE we
>>>> wait for it turn to 1.
>>>>
>>>>
>>>>> And if you like it, it could be more simple like below
>>>>>
>>>>> static bool ufshcd_wait_for_clear_reg(struct ufs_hba *hba, u32 reg, u32 mask,
>>>>>                                             unsigned long interval_us,
>>>>>                                             unsigned int timeout_ms)
>>>>> {
>>>>>            unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
>>>>
>>>> Jiffies on 100Hz systems have minimum granularity of 10ms. So we really
>>>> wait for more 10ms even though the timeout_ms < 10ms.
>>> Yes. Real timeout depends on system.
>>> But normally actual wait will be maintained until 'ufshcd_readl' is done.
>>> Timeout is valid for failure case.  If we don't need to apply a strict timeout value, it's not bad.
>>
>> Hmm.. make sense. Will take care in the next patchset.
>>
>>>
>>>>
>>>>>            /* wakeup within 50us of expiry */
>>>>>            const unsigned int expiry = 50;
>>>>>
>>>>>            while (ufshcd_readl(hba, reg) & mask) {
>>>>>                    usleep_range(interval_us, interval_us + expiry);
>>>>>                    if (time_after(jiffies, timeout)) {
>>>>>                            if (ufshcd_readl(hba, reg) & mask)
>>>>>                                    return false;
>>>>
>>>> I really want the caller to decide on what to do after the timeout.
>>>> This helps in error handling cases where we try to clear off the entire
>>>> door-bell register but only a few of the bits are cleared after timeout.
>>> I don't know what we can do with the report of the partial success on clearing bit.
>>> It's just failure case. Isn't enough with false/true?
>>
>> The point is, if a bit can't be cleared it can be regarded as a
>> permanent failure (only for that request), otherwise, it can be
>> retried with the same tag value.
>>
>>>
>>>>
>>>>>                            else
>>>>>                                    return true;
>>>>>                    }
>>>>>            }
>>>>>
>>>>>            return true;
>>>>> }
>>>>>> +{
>>>>>> +	u32 tmp;
>>>>>> +	ktime_t start;
>>>>>> +	unsigned long diff;
>>>>>> +
>>>>>> +	tmp = ufshcd_readl(hba, reg);
>>>>>> +
>>>>>> +	if ((val & mask) != val) {
>>>>>> +		dev_err(hba->dev, "%s: Invalid wait condition 0x%x\n",
>>>>>> +				__func__, val);
>>>>>> +		goto out;
>>>>>> +	}
>>>>>> +
>>>>>> +	start = ktime_get();
>>>>>> +	while ((tmp & mask) != val) {
>>>>>> +		/* wakeup within 50us of expiry */
>>>>>> +		usleep_range(interval_us, interval_us + 50);
>>>>>> +		tmp = ufshcd_readl(hba, reg);
>>>>>> +		diff = ktime_to_ms(ktime_sub(ktime_get(), start));
>>>>>> +		if (diff > timeout_ms) {
>>>>>> +			tmp = ufshcd_readl(hba, reg);
>>>>>> +			break;
>>>>>> +		}
>>>>>> +	}
>>>>>> +out:
>>>>>> +	return tmp;
>>>>>> +}
>>>>>> +
>> ..
>>>>>> +static int
>>>>>> +ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
>>>>>> +{
>>>>>> +	int err = 0;
>>>>>> +	unsigned long flags;
>>>>>> +	u32 reg;
>>>>>> +	u32 mask = 1 << tag;
>>>>>> +
>>>>>> +	/* clear outstanding transaction before retry */
>>>>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>>>>>> +	ufshcd_utrl_clear(hba, tag);
>>>>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * wait for for h/w to clear corresponding bit in door-bell.
>>>>>> +	 * max. wait is 1 sec.
>>>>>> +	 */
>>>>>> +	reg = ufshcd_wait_for_register(hba,
>>>>>> +			REG_UTP_TRANSFER_REQ_DOOR_BELL,
>>>>>> +			mask, 0, 1000, 1000);
>>>>> 4th argument should be (~mask) instead of '0', right?
>>>>
>>>> True, but not really for this implementation. It breaks the check in
>>>> in wait_for_register -
>>>> if ((val & mask) != val)
>>>>               dev_err(...);
>>> Hmm, it seems complicated to use.
>>> Ok. Is right the following about val as 4th argument?
>>> - clear: val  should be '0' regardless corresponding bit.
>>> - set: val should be same with mask.
>>> If the related comment is added, it will be helpful.
>>
>> Thinking again it looks like it is complicated. How about changing
>> the check to -
>>
>> val = val & mask; /* ignore the bits we don't intend to wait on */
>> while (ufshcd_readl() & mask != val) {
>>    sleep
>> }
>>
>> Usage will be ~mask for clearing the bits, mask for setting the bits
>> in the fourth argument.
> Ok.
> It's better for the caller.
>
>>
>>>
>>>>
>>>>> Actually, mask value involves the corresponding bit to be cleared.
>>>>> So, 4th argument may be unnecessary.
>>>>
>>>> As I described above, the wait_for_register can also be used to
>>>> check if the value is set or not. In which case, we need 4th argument.
>>>>
>>>>>
>>>>>> +	if ((reg & mask) == mask)
>>>>>> +		err = -ETIMEDOUT;
>>>>> Also, checking the result can be involved in ufshcd_wait_for_register.
>>> Any comment?
>>
>> Sorry I missed this. But the point was the same. To make
>> wait_for_register() just to wait a definite time and not return any
>> error condition when the bits don't turn as expected.
> Comparing reg with mask can be done in 'ufshcd_wait_for_register' commonly.
> Currently the caller do the same.

Hmm.. you don't seem to agree to my point earlier mentioned

">>>> I really want the caller to decide on what to do after the timeout.
 >>>> This helps in error handling cases where we try to clear off the 
entire
 >>>> door-bell register but only a few of the bits are cleared after 
timeout.
 >>> I don't know what we can do with the report of the partial success 
on clearing bit.
 >>> It's just failure case. Isn't enough with false/true?
 >>
 >> The point is, if a bit can't be cleared it can be regarded as a
 >> permanent failure (only for that request), otherwise, it can be
 >> retried with the same tag value."

Since there is no real use case as of now. I will move the error check
to the wait_for_register.

-- 
Regards,
Sujit
