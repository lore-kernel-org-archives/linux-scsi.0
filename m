From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 14/15] scsi: ufs: commit descriptors before setting
 the doorbell
Date: Thu, 27 Aug 2015 12:11:37 -0000
Message-ID: <bda781000a13a1b72fa811c191a40a51.squirrel@www.codeaurora.org>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org>
    <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
    <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com>
    <1408ea96f7b8f33aef73e0f84abd8792.squirrel@www.codeaurora.org>
    <CAL_JsqKPz85_6_Q0Q8kJBhi6oDAHnf8LpdvCy+-qbyfEHK1cQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbH0MLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2015 08:11:38 -0400
In-Reply-To: <CAL_JsqKPz85_6_Q0Q8kJBhi6oDAHnf8LpdvCy+-qbyfEHK1cQQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <jbottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> On Tue, Aug 25, 2015 at 7:36 AM,  <ygardi@codeaurora.org> wrote:
>>> On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>>>>
>>>> Add a write memory barrier to make sure descriptors prepared are
>>>> actually
>>>> written to memory before ringing the doorbell. We have also added the
>>>> write memory barrier after ringing the doorbell register so that
>>>> controller sees the new request immediately.
>>>>
>>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>>
>>>> ---
>>>>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>>>>  1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index fef0660..876148b 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -833,6 +833,8 @@ void ufshcd_send_command(struct ufs_hba *hba,
>>>> unsigned int task_tag)
>>>>         ufshcd_clk_scaling_start_busy(hba);
>>>>         __set_bit(task_tag, &hba->outstanding_reqs);
>>>>         ufshcd_writel(hba, 1 << task_tag,
>>>> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>>> +       /* Make sure that doorbell is committed immediately */
>>>> +       wmb();
>>>
>>> Is this really necessary? Is there a measurable difference?
>>
>> I'm not sure if there is a measurable difference, but as the Door-Bell
>> register is the one that actually responsible for the HW execution of
>> the
>> requests, anyhow, it's recommended to its value will be written
>> instantly to the memory.
>
> A barrier doesn't guarantee speed, only ordering. Unless you can
> measure the difference, you should not have it.

Rob,
let me have an example:
context#1 updates outstanding_reqs variable and write(DOOR_BELL)
context#2 upon interrupt of a request completion the following happens:
  report completion on each one of the bits in:
  outstanding_reqs ^ read(DOOR_BELL);

0. let's assume the DOOR_BELL = 0x1 (which means 1 active request in slot 0)
1. context#1: update the DOOR_BELL to be 0x3; (2 active requests: in slot
0 and 1)
2. the new value 0x3 is still not written to the DR so DORR_BELL is still
0x1, but outstanding_reqs is already updated = 0x3
3. the request in slot 0 just completed, and interrupt happens, so
DORR_BELL is now 0 (request in slot 0 completed)
4. context#2: outstanding_reqs ^ read(DOOR_BELL) = 0x3 ^ 0x0 = 0x3 =>
wrong conclusion since the request in slot 1 never completed, and actually
never started.


>
>> Also, as the Interrupt context reads this register, and compare it to
>> the
>> SW mirroring value (hba->outstanding_reqs) in order to realize what
>> requests are already completed, it's important to get the correct value
>> by reading this register, otherwise we might realize a request
>> completion
>> while it was never even submitted.
>
> If a register read can pass a register write out of order, then your
> h/w is broken. Plus what if the interrupt occurs before the barrier.
>
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


