From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re: __elv_add_request
  OOPS]
Date: Wed, 25 May 2011 09:37:44 +0200
Message-ID: <4DDCB1C8.7040708@fusionio.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
Sender: linux-kernel-owner@vger.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-05-25 03:41, Parag Warudkar wrote:
> 
> 
> On Tue, 24 May 2011, Jens Axboe wrote:
> 
>> On 2011-05-24 06:29, Parag Warudkar wrote:
>>>
>>> External DVD drive - connected when suspended, removed before resume.
>>> Results in NULL pointer dereference in __blk_add_request on resume.
>>>
>>> *ffffffff811d6503:      48 89 58 08             mov    %rbx,0x8(%rax) |
>>> %ebx = ffff880131559020 <--- faulting instruction
>>>
>>> 48 89 58 08 appears only in list_add :
>>>
>>> static inline void list_add(struct list_head *new, struct list_head *head)
>>> {
>>>         __list_add(new, head, head->next);
>>> ffffffff81ac012c:       49 8b 04 24             mov    (%r12),%rax
>>> #ifndef CONFIG_DEBUG_LIST
>>> static inline void __list_add(struct list_head *new,
>>>                               struct list_head *prev,
>>>                               struct list_head *next)
>>> {
>>>         next->prev = new;
>>> ffffffff81ac0130:       48 89 58 08             mov    %rbx,0x8(%rax)
>>>
>>> AFAICS list_add is only called from one place in __elv_add_request :
>>>
>>>        switch (where) {
>>>         case ELEVATOR_INSERT_REQUEUE:
>>>         case ELEVATOR_INSERT_FRONT:
>>>                 rq->cmd_flags |= REQ_SOFTBARRIER;
>>>               **  list_add(&rq->queuelist, &q->queue_head);
>>>                 break;
>>>
>>> Now, where is the patch? :)
>>
>> You forgot to attach it?
>>
>> This is clearly q == NULL [snip]
> 
> OK, I think this patch should do the trick.
> 
> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> Reported-and-tested-by: Parag Warudkar <parag.lkml@gmail.com>
>  
> Check for device deletion before sending it a scsi command. This fixes an 
> OOPS I was seeing during resume when the external dvd drive was removed 
> while suspended.
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index d9564fb..cc4edbf 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -136,7 +136,7 @@ int scsi_set_medium_removal(struct scsi_device *sdev, char state)
>  	char scsi_cmd[MAX_COMMAND_SIZE];
>  	int ret;
>  
> -	if (!sdev->removable || !sdev->lockable)
> +	if (!sdev->removable || !sdev->lockable || sdev->sdev_state == SDEV_DEL)
>  	       return 0;
>  
>  	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;

While this will fix your particular oops, I don't think it's quite
right. It's fixing one particular piece of fall out from attempting to
talk to a removed device, it's not necessarily fixing the full class of
them. The other checks in scsi_set_medium_removal() aren't related to a
changing state of the device, they are capability checks.

-- 
Jens Axboe
