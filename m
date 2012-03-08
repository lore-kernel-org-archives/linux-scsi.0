From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Thu, 8 Mar 2012 12:11:07 -0500
Message-ID: <FA58CA70-02BE-4CCD-855C-4C5CE28EA1B2@xyratex.com>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com> <528D7E8A-B2F6-4EDB-A7C0-E0BF494038D0@xyratex.com> <CAOD=uF4+F7MYO0cqd7ogmc=K9jtE5DX3wDoMv1eTxFq48JCX2g@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:47061 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753801Ab2CHRLP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 12:11:15 -0500
In-Reply-To: <CAOD=uF4+F7MYO0cqd7ogmc=K9jtE5DX3wDoMv1eTxFq48JCX2g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, Jack Wang <jack_wang@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

Comments embedded

On Mar 8, 2012, at 11:50 AM, santosh prasad nayak wrote:

> Hi Mark,
> 
> Thanks for your review.
> 
> Few queries:
> 
> 1. Similar changes have been made in mpi_sata_completion() surrounding
> spin_*lock_irq*(&t->task->state_lock)
>    Should those changes also need to revert back ?

I was talking generically, yes, in both set of functions, everything associated with the task_state_lock. The change as described needs to be applied to both sets of functions.

>> The change you did was not inert, and result in the IRQ being disabled upon exit should a
>> SAS_TASK_STATE_ABORTED task state condition occur then following block will enable IRQ.
> 
> 2.  I could not get this point.
>     If "SAS_TASK_STATE_ABORTED" task state condition occurs then following
>     block will enable IRQ.
> 
>          if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>                spin_unlock_irq(&t->task_state_lock);
>           //   HERE IRQ will be enabled.
>                  .......
>                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>          }

Exactly, the IRQ is enabled, then the routine exits. All other paths leave the IRQ disabled (with a spin_lock_irq()).

> 3.  How bad  will be "spin_lock_irq / spin_unlock_irq" in this case compared to
>     "spin_lock_irqsave / spin_unlock_irqrestore "

Efficiency is not so much the requirement, but correctness. Yes, a spin_unlock(&t->task_state_lock) will do, but the 'world' likes to see the balance of flag save/restore, one should NOT make the assumption the interrupt is enabled or disabled upon entry, and should preserve such upon exit.

Given this statement, perhaps for the case of the hacks surrounding the completion handler calls and host locks, one would do a save of the irq, unlock with irq enabled, lock, and then restore it back to the value upon entry. This is balanced. Your changes make the (correct) assumption that the irq is disabled upon entry. But pedantically incorrect, I'd take the extra steps, but I do not view that as a critical deficiency in your patch.

> Regards
> Santosh
> 
>> 
>> I propose (annotated below) you leave the flags automatic variable, but uninitialized. The changes surrounding spin_*lock_irq*(&pm8001_ha->lock, flags) are OK, but revert back the changes surrounding the spin_*lock_irq*(&t->task->state_lock,flags) so that lock would be properly nested.
>> 
>> To be pedantic, and to be more correct, this code should have spawned a work queue task to perform the t->task_done(t) operation in a separate thread rather than inline and precariously unlocked; but that would be beyond the scope of these changes and should be left for future work to decide if it is even necessary. Not sure how such a change would affect performance (using the work queue) ... so I am 'afraid' of pushing such a change in any case given the relatively reliable operation of this driver (and the dynamic nature of the changes Dan is making to the SATA side of things for instance ;-} ).
>> 
>> I am sorry for taking so long to get to the task of reviewing this (and the previous) code. I look forward to your comments.
>> 
>> Sincerely -- Mark Salyzyn
>> 
>> On Feb 26, 2012, at 8:33 AM, santosh nayak wrote:
>> 
>>> @@ -2207,7 +2206,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>>> static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>>> {
>>>       struct sas_task *t;
>>> -     unsigned long flags = 0;
>> MGS>    unsigned long flags;
>>>       struct task_status_struct *ts;
>>>       struct pm8001_ccb_info *ccb;
>>>       struct pm8001_device *pm8001_dev;
>>> @@ -2287,9 +2285,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>>>                       ts->stat = SAS_QUEUE_FULL;
>>>                       pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>>                       mb();/*ditto*/
>>> -                     spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>>> +                     spin_unlock_irq(&pm8001_ha->lock);
>>>                       t->task_done(t);
>>> -                     spin_lock_irqsave(&pm8001_ha->lock, flags);
>>> +                     spin_lock_irq(&pm8001_ha->lock);
>>>                       return;
>>>               }
>>>               break;
>>> @@ -2387,31 +2385,31 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>>>               ts->stat = SAS_OPEN_TO;
>>>               break;
>>>       }
>>> -     spin_lock_irqsave(&t->task_state_lock, flags);
>>> +     spin_lock_irq(&t->task_state_lock);
>> MGS>    spin_lock_irqsave(&t->task_state_lock, flags);
>>>       t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>>>       t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>>>       t->task_state_flags |= SAS_TASK_STATE_DONE;
>>>       if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>>> +             spin_unlock_irq(&t->task_state_lock);
>> MGS>            spin_unlock_irqrestore(&t->task_state_lock, flags);
>>>               PM8001_FAIL_DBG(pm8001_ha,
>>>                       pm8001_printk("task 0x%p done with io_status 0x%x"
>>>                       " resp 0x%x stat 0x%x but aborted by upper layer!\n",
>>>                       t, event, ts->resp, ts->stat));
>>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>>       } else if (t->uldd_task) {
>>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>>> +             spin_unlock_irq(&t->task_state_lock);
>>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>>               mb();/* ditto */
>>> -             spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>>> +             spin_unlock_irq(&pm8001_ha->lock);
>>>               t->task_done(t);
>>> -             spin_lock_irqsave(&pm8001_ha->lock, flags);
>>> +             spin_lock_irq(&pm8001_ha->lock);
>>>       } else if (!t->uldd_task) {
>>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>>> +             spin_unlock_irq(&t->task_state_lock);
>>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>>               mb();/*ditto*/
>>> -             spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>>> +             spin_unlock_irq(&pm8001_ha->lock);
>>>               t->task_done(t);
>>> -             spin_lock_irqsave(&pm8001_ha->lock, flags);
>>> +             spin_lock_irq(&pm8001_ha->lock);
>>>       }
>>> }

