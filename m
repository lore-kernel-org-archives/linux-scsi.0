From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 14/15] scsi: ufs: commit descriptors before setting
 the doorbell
Date: Tue, 25 Aug 2015 12:36:12 -0000
Message-ID: <1408ea96f7b8f33aef73e0f84abd8792.squirrel@www.codeaurora.org>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org>
    <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
    <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48000 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbbHYMgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2015 08:36:13 -0400
In-Reply-To: <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <jbottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>>
>> Add a write memory barrier to make sure descriptors prepared are
>> actually
>> written to memory before ringing the doorbell. We have also added the
>> write memory barrier after ringing the doorbell register so that
>> controller sees the new request immediately.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index fef0660..876148b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -833,6 +833,8 @@ void ufshcd_send_command(struct ufs_hba *hba,
>> unsigned int task_tag)
>>         ufshcd_clk_scaling_start_busy(hba);
>>         __set_bit(task_tag, &hba->outstanding_reqs);
>>         ufshcd_writel(hba, 1 << task_tag,
>> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> +       /* Make sure that doorbell is committed immediately */
>> +       wmb();
>
> Is this really necessary? Is there a measurable difference?

I'm not sure if there is a measurable difference, but as the Door-Bell
register is the one that actually responsible for the HW execution of the
requests, anyhow, it's recommended to its value will be written
instantly to the memory.

Also, as the Interrupt context reads this register, and compare it to the
SW mirroring value (hba->outstanding_reqs) in order to realize what
requests are already completed, it's important to get the correct value
by reading this register, otherwise we might realize a request completion
while it was never even submitted.

>
>>  }
>>
>>  /**
>> @@ -1418,6 +1420,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
>> *host, struct scsi_cmnd *cmd)
>>                 goto out;
>>         }
>>
>> +       /* Make sure descriptors are ready before ringing the doorbell
>> */
>> +       wmb();
>
> The writel for the doorbell will do a barrier first. (I didn't check
> what exactly ufshcd_writel does, but that is why I don't like these
> private access wrappers.)
>
>>         /* issue command to the controller */
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>>         ufshcd_send_command(hba, tag);
>> @@ -1627,6 +1631,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
>> *hba,
>>
>>         hba->dev_cmd.complete = &wait;
>>
>> +       /* Make sure descriptors are ready before ringing the doorbell
>> */
>> +       wmb();
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>>         ufshcd_send_command(hba, tag);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> --
>> 1.8.5.2
>>
>> --
>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
>> member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


