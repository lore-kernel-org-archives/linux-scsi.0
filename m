From: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: Re: [PATCH] scsi/eh: fix hang adding ehandler wakeups after
 decrementing host_busy
Date: Tue, 21 Nov 2017 18:49:42 -0600
Message-ID: <173c0be5-e4ab-452d-e5f6-2852147eb040@gmail.com>
References: <20170905125424.15412-1-ptikhomirov@virtuozzo.com>
 <496d6c6e-565b-9ebb-59b4-d4b17e0d9a62@virtuozzo.com>
 <9941b46c-72be-e171-2e4b-cb12ac5c439d@gmail.com>
 <753b79c1-1127-c431-e411-1ff47eea0e98@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <753b79c1-1127-c431-e411-1ff47eea0e98@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

My apologies... yes, your patch also fixes my issue.  I was looking at the two new places from which you were calling scsi_eh_wakeup(), and didn't notice that you moved the spinlock in scsi_device_unbusy()... moving the spinlock in scsi_device_unbusy() also should the issue I'm seeing, given that scsi_eh_scmd_add() also uses the spinlock.

I tested your patch on my issue, and it did indeed fix my issue.

So you can add...

Tested-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Thanks
Stuart


On 11/21/2017 2:09 AM, Pavel Tikhomirov wrote:
> My patch should also fix your issue too, please see explanation in reply to your patch. Do your testing show that it doesn't?
> 
> Thanks, Pavel.
> 
> On 11/21/2017 09:10 AM, Stuart Hayes wrote:
>> Pavel,
>>
>> It turns out that the error handler on our systems was not getting woken up for a different reason... I submitted a patch earlier today that fixes the issue I were seeing (I CCed you on the patch).
>>
>> Before I got my hands on the failing system and was able to root cause it, I was pretty sure that your patch was going to fix our issue, because after I examined the code paths, I couldn't find any other reason that the error handler would not get woken up.  I tried forcing the bug that your patch fixes to occur, by compiling in some mdelay()s in a key place or two in the scsi code, but it never failed for me that way.  With my patch, several systems that previously failed in 10 minutes or less successfully ran for many days.
>>
>> Thanks,
>> Stuart
>>
>> On 11/9/2017 8:54 AM, Pavel Tikhomirov wrote:
>>>> Are there any issues with this patch (https://patchwork.kernel.org/patch/9938919/) that Pavel Tikhomirov submitted back in September?  I am willing to help if there's anything I can do to help get it accepted.
>>>
>>> Hi, Stuart, I asked James Bottomley about the patch status offlist and it seems that the problem is - patch lacks testing and review. I would highly appreciate review from your side and anyone who wants to participate!
>>>
>>> And if you can confirm that the patch solves the problem on your environment with no side effects please add "Tested-by:" tag also.
>>>
>>> Thanks, Pavel
>>>
>>> On 09/05/2017 03:54 PM, Pavel Tikhomirov wrote:
>>>> We have a problem on several our nodes with scsi EH. Imagine such an
>>>> order of execution of two threads:
>>>>
>>>> CPU1 scsi_eh_scmd_add        CPU2 scsi_host_queue_ready
>>>> /* shost->host_busy == 1 initialy */
>>>>
>>>>                  if (shost->shost_state == SHOST_RECOVERY)
>>>>                      /* does not get here */
>>>>                      return 0;
>>>>
>>>> lock(shost->host_lock);
>>>> shost->shost_state = SHOST_RECOVERY;
>>>>
>>>>                  busy = shost->host_busy++;
>>>>                  /* host->can_queue == 1 initialy, busy == 1
>>>>                   * - go to starved label */
>>>>                  lock(shost->host_lock) /* wait */
>>>>
>>>> shost->host_failed++;
>>>> /* shost->host_busy == 2, shost->host_failed == 1 */
>>>> call scsi_eh_wakeup(shost) {
>>>>      if (host_busy == host_failed) {
>>>>          /* does not get here */
>>>>          wake_up_process(shost->ehandler)
>>>>      }
>>>> }
>>>> unlock(shost->host_lock)
>>>>
>>>>                  /* acquire lock */
>>>>                  shost->host_busy--;
>>>>
>>>> Finaly we do not wakeup scsi_error_handler and all other commands
>>>> coming will hang as we are in never ending recovery state as there
>>>> is no one left to wakeup handler.
>>>>
>>>> So scsi disc in these host becomes unresponsive and all bio on node
>>>> hangs. (We trigger these problem when scsi cmnds to DVD drive timeout.)
>>>>
>>>> Main idea of the fix is to try to do wake up every time we decrement
>>>> host_busy or increment host_failed(the latter is already OK).
>>>>
>>>> Now the very *last* one of busy threads getting host_lock after
>>>> decrementing host_busy will see all write operations on host's
>>>> shost_state, host_busy and host_failed completed thanks to implied
>>>> memory barriers on spin_lock/unlock, so at the time of busy==failed
>>>> we will trigger wakeup in at least one thread. (Thats why putting
>>>> recovery and failed checks under lock)
>>>>
>>>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>>>> ---
>>>>    drivers/scsi/scsi_lib.c | 21 +++++++++++++++++----
>>>>    1 file changed, 17 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>> index f6097b89d5d3..6c99221d60aa 100644
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -320,12 +320,11 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>>>>        if (starget->can_queue > 0)
>>>>            atomic_dec(&starget->target_busy);
>>>>    +    spin_lock_irqsave(shost->host_lock, flags);
>>>>        if (unlikely(scsi_host_in_recovery(shost) &&
>>>> -             (shost->host_failed || shost->host_eh_scheduled))) {
>>>> -        spin_lock_irqsave(shost->host_lock, flags);
>>>> +             (shost->host_failed || shost->host_eh_scheduled)))
>>>>            scsi_eh_wakeup(shost);
>>>> -        spin_unlock_irqrestore(shost->host_lock, flags);
>>>> -    }
>>>> +    spin_unlock_irqrestore(shost->host_lock, flags);
>>>>          atomic_dec(&sdev->device_busy);
>>>>    }
>>>> @@ -1503,6 +1502,13 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>>>>        spin_unlock_irq(shost->host_lock);
>>>>    out_dec:
>>>>        atomic_dec(&shost->host_busy);
>>>> +
>>>> +    spin_lock_irq(shost->host_lock);
>>>> +    if (unlikely(scsi_host_in_recovery(shost) &&
>>>> +             (shost->host_failed || shost->host_eh_scheduled)))
>>>> +        scsi_eh_wakeup(shost);
>>>> +    spin_unlock_irq(shost->host_lock);
>>>> +
>>>>        return 0;
>>>>    }
>>>>    @@ -1964,6 +1970,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>>      out_dec_host_busy:
>>>>        atomic_dec(&shost->host_busy);
>>>> +
>>>> +    spin_lock_irq(shost->host_lock);
>>>> +    if (unlikely(scsi_host_in_recovery(shost) &&
>>>> +             (shost->host_failed || shost->host_eh_scheduled)))
>>>> +        scsi_eh_wakeup(shost);
>>>> +    spin_unlock_irq(shost->host_lock);
>>>> +
>>>>    out_dec_target_busy:
>>>>        if (scsi_target(sdev)->can_queue > 0)
>>>>            atomic_dec(&scsi_target(sdev)->target_busy);
>>>>
>>>
>>
>> ---
>> This email has been checked for viruses by Avast antivirus software.
>> https://www.avast.com/antivirus
>>
