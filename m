From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Fri, 3 Jan 2014 12:02:06 -0800
Message-ID: <CAA9_cme0MZvz_6VXXpP3ATkR6p_OznHpVtyyNxA+HK2iBvb7Rg@mail.gmail.com>
References: <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com>
	<52B8518B.4060204@gmail.com>
	<52B8569D.4050101@redhat.com>
	<CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
	<20131223163410.GA28220@redhat.com>
	<20131223172744.GA2069@redhat.com>
	<20131223182323.GA8656@gmail.com>
	<20131223183341.GA6082@redhat.com>
	<20131224082931.GA20471@gmail.com>
	<CE2C58F938F4C44EA74FFF880BAA7E5E1C68AD12@BBYEXM01.pmc-sierra.internal>
	<20131227161802.GA21077@redhat.com>
	<CE2C58F938F4C44EA74FFF880BAA7E5E1CD22E04@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47270 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaACUCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 15:02:07 -0500
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5E1CD22E04@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Jan 2, 2014 at 2:31 AM, Suresh Thiagarajan
<Suresh.Thiagarajan@pmcs.com> wrote:
>
>
> On Fri, Dec 27, 2013 at 9:48 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 12/24, Suresh Thiagarajan wrote:
>>>
>>> Below is a small pseudo code on protecting/serializing the flag for global access.
>>> struct temp
>>> {
>>>       ...
>>>       spinlock_t lock;
>>>       unsigned long lock_flags;
>>> };
>>> void my_lock(struct temp *t)
>>> {
>>>                unsigned long flag; // thread-private variable as suggested
>>>                spin_lock_irqsave(&t->lock, flag);
>>>                t->lock_flags = flag; //updating inside critical section now to serialize the access to flag
>>> }
>>>
>>> void my_unlock(struct temp *t)
>>> {
>>>                unsigned long flag = t->lock_flags;
>>>                t->lock_flags = 0;  //clearing it before getting out of critical section
>>>                spin_unlock_irqrestore(&t->lock, flag);
>>> }
>>
>> Yes, this should work as a quick fix. And you do not need to clear ->lock_flags
>> in my_unlock().
>>
>> But when I look at original patch again, I no longer understand why do
>> you need pm8001_ha->lock_flags at all. Of course I do not understand this
>> code, I am sure I missed something, but at first glance it seems that only
>> this sequence
>>
>>         spin_unlock_irq(&pm8001_ha->lock);
>>         t->task_done(t);
>>         spin_lock_irq(&pm8001_ha->lock);
>>
>> should be fixed?
>>
>> If yes, why you can't simply do spin_unlock() + spin_lock() around
>> t->task_done() ? This won't enable irqs, but spin_unlock_irqrestore()
>> doesn't necessarily enables irqs too, so ->task_done() can run with
>> irqs disabled?
>>
>> And note that the pattern above has a lot of users, perhaps it makes
>> sense to start with something like the patch below?
>
> Thanks James, Oleg and all for your inputs.
> Will start with review and testing this patch and then work/investigate to keep shortest and clearest critical
> section so that we can have the lock and unlock within the same routine.
>

Fwiw we solved this in libsas a while back with a similar pattern
proposed by Oleg:

unsigned long flags;

local_irq_save(flags);
spin_unlock(lock);
...
spin_lock_lock(lock);
local_irq_restore(flags);

See commit 312d3e56119a "[SCSI] libsas: remove ata_port.lock
management duties from lldds"

--
Dan
