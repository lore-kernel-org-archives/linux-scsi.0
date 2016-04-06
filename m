From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: Re: [PATCH] csiostor: Fix backwards locking in the function
 __csio_unreg_rnode
Date: Wed, 6 Apr 2016 13:35:25 -0400
Message-ID: <570548DD.60103@gmail.com>
References: <1459891143-20451-1-git-send-email-bastienphilbert@gmail.com>
 <CAGRGNgXXBZb91xgRfkU_xtAF4rmCFbDFuxq8jRmQzJXU2wHb7Q@mail.gmail.com>
 <57050D62.3090802@gmail.com> <1459949907.2372.13.camel@linux.vnet.ibm.com>
 <57051913.4050304@gmail.com> <1459952680.2372.25.camel@linux.vnet.ibm.com>
 <57051EF3.2070508@gmail.com> <1459962881.2372.40.camel@linux.vnet.ibm.com>
 <5705460C.4090105@gmail.com> <1459963704.2372.43.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:35905 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbcDFRf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2016 13:35:28 -0400
In-Reply-To: <1459963704.2372.43.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 2016-04-06 01:28 PM, James Bottomley wrote:
> On Wed, 2016-04-06 at 13:23 -0400, Bastien Philbert wrote:
>>
>> On 2016-04-06 01:14 PM, James Bottomley wrote:
>>> On Wed, 2016-04-06 at 10:36 -0400, Bastien Philbert wrote:
>>>>
>>>> On 2016-04-06 10:24 AM, James Bottomley wrote:
>>>>> On Wed, 2016-04-06 at 10:11 -0400, Bastien Philbert wrote:
>>>>>>
>>>>>> On 2016-04-06 09:38 AM, James Bottomley wrote:
>>>>>>> On Wed, 2016-04-06 at 09:21 -0400, Bastien Philbert wrote:
>>>>>>>>
>>>>>>>> On 2016-04-06 03:48 AM, Julian Calaby wrote:
>>>>>>>>> Hi Bastien,
>>>>>>>>>
>>>>>>>>> On Wed, Apr 6, 2016 at 7:19 AM, Bastien Philbert
>>>>>>>>> <bastienphilbert@gmail.com> wrote:
>>>>>>>>>> This fixes backwards locking in the function
>>>>>>>>>> __csio_unreg_rnode
>>>>>>>>>> to
>>>>>>>>>> properly lock before the call to the function
>>>>>>>>>> csio_unreg_rnode
>>>>>>>>>> and
>>>>>>>>>> not unlock with spin_unlock_irq as this would not
>>>>>>>>>> allow
>>>>>>>>>> the
>>>>>>>>>> proper
>>>>>>>>>> protection for concurrent access on the shared
>>>>>>>>>> csio_hw
>>>>>>>>>> structure
>>>>>>>>>> pointer hw. In addition switch the locking after the
>>>>>>>>>> critical
>>>>>>>>>> region
>>>>>>>>>> function call to properly unlock instead with
>>>>>>>>>> spin_unlock_irq
>>>>>>>>>> on
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Bastien Philbert <
>>>>>>>>>> bastienphilbert@gmail.com>
>>>>>>>>>> ---
>>>>>>>>>>  drivers/scsi/csiostor/csio_rnode.c | 4 ++--
>>>>>>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/scsi/csiostor/csio_rnode.c
>>>>>>>>>> b/drivers/scsi/csiostor/csio_rnode.c
>>>>>>>>>> index e9c3b04..029a09e 100644
>>>>>>>>>> --- a/drivers/scsi/csiostor/csio_rnode.c
>>>>>>>>>> +++ b/drivers/scsi/csiostor/csio_rnode.c
>>>>>>>>>> @@ -580,9 +580,9 @@ __csio_unreg_rnode(struct
>>>>>>>>>> csio_rnode
>>>>>>>>>> *rn)
>>>>>>>>>>                 ln->last_scan_ntgts--;
>>>>>>>>>>         }
>>>>>>>>>>
>>>>>>>>>> -       spin_unlock_irq(&hw->lock);
>>>>>>>>>> -       csio_unreg_rnode(rn);
>>>>>>>>>>         spin_lock_irq(&hw->lock);
>>>>>>>>>> +       csio_unreg_rnode(rn);
>>>>>>>>>> +       spin_unlock_irq(&hw->lock);
>>>>>>>>>
>>>>>>>>> Are you _certain_ this is correct? This construct
>>>>>>>>> usually
>>>>>>>>> appears
>>>>>>>>> when
>>>>>>>>> a function has a particular lock held, then needs to
>>>>>>>>> unlock
>>>>>>>>> it
>>>>>>>>> to
>>>>>>>>> call
>>>>>>>>> some other function. Are you _certain_ that this isn't
>>>>>>>>> the
>>>>>>>>> case?
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>>
>>>>>>>> Yes I am pretty certain this is correct. I checked the
>>>>>>>> paths
>>>>>>>> that
>>>>>>>> called this function
>>>>>>>> and it was weired that none of them gradded the spinlock
>>>>>>>> before
>>>>>>>> hand.
>>>>>>>
>>>>>>> That's not good enough.  If your theory is correct, lockdep
>>>>>>> should
>>>>>>> be
>>>>>>> dropping an already unlocked assertion in this codepath ...
>>>>>>> do
>>>>>>> you
>>>>>>> see
>>>>>>> this?
>>>>>>>
>>>>>>> James
>>>>>>>
>>>>>>>
>>>>>> Yes I do.
>>>>>
>>>>> You mean you don't see the lockdep assert, since you're asking
>>>>> to 
>>>>> drop the patch?
>>>>>
>>>>>>  For now just drop the patch but I am still concerned that we
>>>>>> are
>>>>>> double unlocking here.
>>>>>
>>>>> Really, no.  The pattern in the code indicates the lock is
>>>>> expected 
>>>>> to be held.  This can be wrong (sometimes code moves or people
>>>>> forget), but if it is wrong we'll get an assert about unlock of
>>>>> an 
>>>>> already unlocked lock.  If there's no assert, the lock is held
>>>>> on 
>>>>> entry and the code is correct.
>>>>>
>>>>> You're proposing patches based on misunderstandings of the code
>>>>> which aren't backed up by actual issues and wasting everyone's
>>>>> time 
>>>>> to look at them.  Please begin with the hard evidence of a
>>>>> problem 
>>>>> first, so post the lockdep assert in the changelog so we know 
>>>>> there's a real problem.
>>>>>
>>>>> James
>>>>>
>>>> Certainly James. I think I just got carried away with the last
>>>> few 
>>>> patches :(.
>>>
>>> Is this Nick Krause?  An email reply that Martin forwarded but the 
>>> list didn't pick up (because it had a html part) suggests this. 
>>>  What you're doing is what got you banned from LKML the last time: 
>>> sending patches without evidence there's a problem or understanding 
>>> the code you're patching.  Repeating the behaviour under a new 
>>> identity isn't going to help improve your standing.
>>>
>>> James
>>>
>> No I am not Nick Krause. I am just aware of how he got banned a few 
>> years ago. That email was a mistake by typo and was hoping nobody 
>> picked it up as they would then believe I was Nick Krause.
> 
> Hm, OK, but currently you are repeating his behaviour ... please don't
> send any more patches until they're about real problems backed by
> actual data.
> 
> Thanks,
> 
> James
> 
> 
Ok sure I do have one patch that I tested and it worked for me but wasn't sure if I am just
trampling over the actual bug. If you would like me to send the patch and you can tell me 
if I am right please let me known.
Sorry about the other patches,
Bastien
