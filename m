From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: + aacraid-fix-unchecked-down_interruptible.patch added to -mm tree
Date: Thu, 10 Apr 2008 17:19:23 -0400
Message-ID: <18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com>
References: <200804102037.m3AKb2g4016314@imap1.linux-foundation.org> <1207860882.4915.35.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:40072 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbYDJVT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 17:19:26 -0400
In-Reply-To: <1207860882.4915.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

Until the epiphany that solves this problem or someone straightens me  
out on the proper usage, I suggest a STRONG comment be added: /*  
BADCODE DO NOT COPY */ :-)

The check 'fibptr->done == 0' below is used to indirectly deal with  
the lock state, for if it is still zero (I know a race condition is  
here) then the lock was not 'taken', and the setting it to a value of  
2 acknowledges this fact. The fix may very well be that if the return  
value indicates interrupt instead of release, that we set 'done' to a  
value of 2 ...

I will need to revisit this ...

Sincerely -- Mark Salyzyn

On Apr 10, 2008, at 4:54 PM, James Bottomley wrote:

>
> On Thu, 2008-04-10 at 13:26 -0700, akpm@linux-foundation.org wrote:
>> The patch titled
>>     aacraid: fix unchecked down_interruptible()
>> has been added to the -mm tree.  Its filename is
>>     aacraid-fix-unchecked-down_interruptible.patch
>>
>> Before you just go and hit "reply", please:
>>   a) Consider who else should be cc'ed
>>   b) Prefer to cc a suitable mailing list as well
>>   c) Ideally: find the original patch on the mailing list and do a
>>      reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your  
>> code ***
>>
>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt  
>> to find
>> out what to do about this
>>
>> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>>
>> ------------------------------------------------------
>> Subject: aacraid: fix unchecked down_interruptible()
>> From: Andrew Morton <akpm@linux-foundation.org>
>>
>> drivers/scsi/aacraid/commsup.c: In function 'aac_fib_send':
>> drivers/scsi/aacraid/commsup.c:519: warning: ignoring return value  
>> of 'down_interruptible', declared with attribute warn_unused_result
>>
>> This is a bug.  Code *must* check whether or not down_interruptible()
>> succeeded.  This driver has lost track of whether or not the lock  
>> was taken.
>>
>> (I thought I already fixed this once?)
>
> You added the patch once before, it seems to have dropped out of the  
> -mm
> tree, but it was never sent upstream.
>
>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> I researched this with Adaptec.  This is what they say:
>
>> We had to use down_interruptible because if the Firmware locked up,
>> unresponsive or retiscent, and the system was being shut down, it
>> would never complete the shutdown. The user task is 'in driver' and
>> can not be shut down.
>>
>> The loss of this one fib because a user is interrupting the
>> management
>> applications is a small price to pay. This FIB remains in the open
>> queue and needs to since the Adapter has not completed it...
>
> So the point about this is that if you ever hit the interrupt, you  
> lose
> a FIB, but on the other hand, there's nothing the driver can  
> actually do
> to recover it, hence it wouldn't behave differently regardless of the
> return value of down_interruptible().  On the other hand, if you  
> change
> the down_interruptible() to down() we lock up the system when we hit  
> the
> wait forever condition.  I'm sympathetic, even though I agree we don't
> want this bad programming example persisting for someone to cut and
> paste, so I think we have to keep the interruptible, but I'm open to
> other ways of making the warning go away.
>
>> ---
>>
>> drivers/scsi/aacraid/commsup.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -puN drivers/scsi/aacraid/commsup.c~aacraid-fix-unchecked- 
>> down_interruptible drivers/scsi/aacraid/commsup.c
>> --- a/drivers/scsi/aacraid/commsup.c~aacraid-fix-unchecked- 
>> down_interruptible
>> +++ a/drivers/scsi/aacraid/commsup.c
>> @@ -516,7 +516,7 @@ int aac_fib_send(u16 command, struct fib
>>                              udelay(5);
>>                      }
>>              } else
>> -                     (void)down_interruptible(&fibptr->event_wait);
>> +                     down(&fibptr->event_wait);
>>              spin_lock_irqsave(&fibptr->event_lock, flags);
>>              if (fibptr->done == 0) {
>>                      fibptr->done = 2; /* Tell interrupt we aborted  
>> */
>
> James
>
>

