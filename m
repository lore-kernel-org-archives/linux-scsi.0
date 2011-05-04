From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
 ensure	commands don't get lost.
Date: Wed, 04 May 2011 15:34:31 +0200
Message-ID: <4DC155E7.1010802@redhat.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110504125212.GC5997@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On 05/04/2011 02:52 PM, scameron@beardog.cce.hp.com wrote:
> On Wed, May 04, 2011 at 01:15:50PM +0200, Tomas Henzl wrote:
>   
>> On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
>>     
>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> Apparently we've been doin it rong for a decade, but only lately do we
>>> run into problems.
>>>
>>> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>> ---
>>>  drivers/scsi/hpsa.h |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>>> index 621a153..98c97ca 100644
>>> --- a/drivers/scsi/hpsa.h
>>> +++ b/drivers/scsi/hpsa.h
>>> @@ -212,6 +212,7 @@ static void SA5_submit_command(struct ctlr_info *h,
>>>  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
>>>  		c->Header.Tag.lower);
>>>  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
>>> +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
>>>   
>>>       
>> Hi,
>> a small nit -
>> the (void) ^ is I think not needed for gcc and isn't present in the cciss.h patch
>>     
> I just put it there to make it clear that it ignoring the return of readl is 
> done intentionally, not accidentally.  If this goes against some coding convention,
> whatever, I'm not super attached to the (void), but I did put it there on purpose,
> and would have done it in cciss as well, had I thought of it at the time.
>   
I'm not sure what the coding convention says about this, I personally would omit it,
both ways are used in the kernel - so it is fine for me.

Ack - Tomas



> -- steve
>
>   
>> Tomas
>>
>>     
>>>  	h->commands_outstanding++;
>>>  	if (h->commands_outstanding > h->max_outstanding)
>>>  		h->max_outstanding = h->commands_outstanding;
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>   
>>>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
