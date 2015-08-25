From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v1 14/15] scsi: ufs: commit descriptors before setting the doorbell
Date: Tue, 25 Aug 2015 13:25:02 -0500
Message-ID: <CAL_JsqKPz85_6_Q0Q8kJBhi6oDAHnf8LpdvCy+-qbyfEHK1cQQ@mail.gmail.com>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org>
 <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
 <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com> <1408ea96f7b8f33aef73e0f84abd8792.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408ea96f7b8f33aef73e0f84abd8792.squirrel@www.codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <jbottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 25, 2015 at 7:36 AM,  <ygardi@codeaurora.org> wrote:
>> On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>>>
>>> Add a write memory barrier to make sure descriptors prepared are
>>> actually
>>> written to memory before ringing the doorbell. We have also added the
>>> write memory barrier after ringing the doorbell register so that
>>> controller sees the new request immediately.
>>>
>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index fef0660..876148b 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -833,6 +833,8 @@ void ufshcd_send_command(struct ufs_hba *hba,
>>> unsigned int task_tag)
>>>         ufshcd_clk_scaling_start_busy(hba);
>>>         __set_bit(task_tag, &hba->outstanding_reqs);
>>>         ufshcd_writel(hba, 1 << task_tag,
>>> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>> +       /* Make sure that doorbell is committed immediately */
>>> +       wmb();
>>
>> Is this really necessary? Is there a measurable difference?
>
> I'm not sure if there is a measurable difference, but as the Door-Bell
> register is the one that actually responsible for the HW execution of the
> requests, anyhow, it's recommended to its value will be written
> instantly to the memory.

A barrier doesn't guarantee speed, only ordering. Unless you can
measure the difference, you should not have it.

> Also, as the Interrupt context reads this register, and compare it to the
> SW mirroring value (hba->outstanding_reqs) in order to realize what
> requests are already completed, it's important to get the correct value
> by reading this register, otherwise we might realize a request completion
> while it was never even submitted.

If a register read can pass a register write out of order, then your
h/w is broken. Plus what if the interrupt occurs before the barrier.

Rob
