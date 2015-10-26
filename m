From: ygardi@codeaurora.org
Subject: Re: [PATCH v3 13/15] scsi: ufs: add missing memory barriers
Date: Mon, 26 Oct 2015 12:35:05 -0000
Message-ID: <e8df00bf987f9d15d0da562498670dd7.squirrel@www.codeaurora.org>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
    <1441188795-4600-14-git-send-email-ygardi@codeaurora.org>
    <CAC5umyhkAdEjtFd+r3EOKfkPdFgfZ5juH0Wg2983=UqUSzkD7Q@mail.gmail.com>
    <191698899544068194e28246454c2613.squirrel@www.codeaurora.org>
    <CAC5umygdHdYt7OuJyxg=-77bA5GctO9OgrUCGo9iY-ukjkxQUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umygdHdYt7OuJyxg=-77bA5GctO9OgrUCGo9iY-ukjkxQUA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> 2015-10-25 23:40 GMT+09:00  <ygardi@codeaurora.org>:
>>> 2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>>>> Performing several writes to UFS host controller registers has
>>>> no gurrantee of ordering, so we must make sure register writes
>>>> to setup request list base address etc. are performed before the
>>>> run/stop register is enabled.
>>>> In addition, when setting up a task request, we must make sure
>>>> the updating of descriptors takes places before ringing the
>>>> doorbell, similarly to setting up a transfer request.
>>>>
>>>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>>
>>>> ---
>>>>  drivers/scsi/ufs/ufshcd.c | 21 +++++++++++++++------
>>>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index fc2a52d..298511a 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -401,11 +401,9 @@ static inline int ufshcd_get_lists_status(u32
>>>> reg)
>>>>          *  1           UTRLRDY
>>>>          *  2           UTMRLRDY
>>>>          *  3           UCRDY
>>>> -        *  4           HEI
>>>> -        *  5           DEI
>>>> -        * 6-7          reserved
>>>> +        * 4-7          reserved
>>>>          */
>>>> -       return (((reg) & (0xFF)) >> 1) ^ (0x07);
>>>> +       return ((reg & 0xFF) >> 1) ^ 0x07;
>>>>  }
>>>>
>>>>  /**
>>>> @@ -2726,7 +2724,7 @@ out:
>>>>   * To bring UFS host controller to operational state,
>>>>   * 1. Enable required interrupts
>>>>   * 2. Configure interrupt aggregation
>>>> - * 3. Program UTRL and UTMRL base addres
>>>> + * 3. Program UTRL and UTMRL base address
>>>>   * 4. Configure run-stop-registers
>>>>   *
>>>>   * Returns 0 on success, non-zero value on failure
>>>> @@ -2756,8 +2754,13 @@ static int ufshcd_make_hba_operational(struct
>>>> ufs_hba *hba)
>>>>                         REG_UTP_TASK_REQ_LIST_BASE_H);
>>>>
>>>>         /*
>>>> +        * Make sure base address and interrupt setup are updated
>>>> before
>>>> +        * enabling the run/stop registers below.
>>>> +        */
>>>> +       wmb();
>>>> +
>>>> +       /*
>>>>          * UCRDY, UTMRLDY and UTRLRDY bits must be 1
>>>> -        * DEI, HEI bits must be 0
>>>>          */
>>>>         reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
>>>>         if (!(ufshcd_get_lists_status(reg))) {
>>>> @@ -3920,7 +3923,13 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
>>>> *hba, int lun_id, int task_id,
>>>>
>>>>         /* send command to the controller */
>>>>         __set_bit(free_slot, &hba->outstanding_tasks);
>>>> +
>>>> +       /* Make sure descriptors are ready before ringing the task
>>>> doorbell */
>>>> +       wmb();
>>>> +
>>>>         ufshcd_writel(hba, 1 << free_slot,
>>>> REG_UTP_TASK_REQ_DOOR_BELL);
>>>> +       /* Make sure that doorbell is committed immediately */
>>>> +       wmb();
>>>
>>> Is this wmb() after ringing tm doorbell is needed?
>>
>> Well, Mita, in the case of DB register (Request DB and TASK DB), every
>> write operation to the DB should be barrier, as if not, out of order
>> writing to this register might cause inconsistency in its value, and
>> thus,
>> un-handled requests/tasks.
>
> I couldn't fully understand why out of order writing to TASK DB
> register causes inconsistency.
> In the TASK request completion (ufshcd_tmc_handler), TASK DB register
> is read before handling finished requests, so it ensures that all
> write operations for TASK DB have been performed.
>

thanks, Mita
your explanation makes sense.
It will be fixed in v4.


>>>
>>>>
>>>>         spin_unlock_irqrestore(host->host_lock, flags);
>>>>
>>>> --
>>>> 1.8.5.2
>>>>
>>>> --
>>>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
>>>> member of Code Aurora Forum, hosted by The Linux Foundation
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>
