From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 09/30] cxlflash: Fix to stop interrupt processing on
 remove
Date: Fri, 18 Sep 2015 13:59:07 +0200
Message-ID: <55FBFC8B.9060305@redhat.com>
References: <1442422399-41262-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <55FAB43B.8050306@redhat.com>
 <97A059A7-2054-4DBD-B993-BBF47AC105E0@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbbIRL7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2015 07:59:12 -0400
In-Reply-To: <97A059A7-2054-4DBD-B993-BBF47AC105E0@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com, mikey@neuling.org, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 17.9.2015 19:16, Matthew R. Ochs wrote:
>> On Sep 17, 2015, at 7:38 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>>
>> On 16.9.2015 18:53, Matthew R. Ochs wrote:
>>> Interrupt processing can run in parallel to a remove operation. This
>>> can lead to a condition where the interrupt handler is processing with
>>> memory that has been freed.
>>>
>>> To avoid processing an interrupt while memory may be yanked, check for
>>> removal while in the interrupt handler. Bail when removal is imminent.
>>>
>>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>>> ---
>>> drivers/scsi/cxlflash/common.h |  2 ++
>>> drivers/scsi/cxlflash/main.c   | 21 +++++++++++++++------
>>> 2 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
>>> index 1abe4e0..03d2cc6 100644
>>> --- a/drivers/scsi/cxlflash/common.h
>>> +++ b/drivers/scsi/cxlflash/common.h
>>> @@ -103,6 +103,8 @@ struct cxlflash_cfg {
>>> 	enum cxlflash_lr_state lr_state;
>>> 	int lr_port;
>>>
>>> +	atomic_t remove_active;
>>> +
>>> 	struct cxl_afu *cxl_afu;
>>>
>>> 	struct pci_pool *cxlflash_cmd_pool;
>>> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
>>> index 6e85c77..89ee648 100644
>>> --- a/drivers/scsi/cxlflash/main.c
>>> +++ b/drivers/scsi/cxlflash/main.c
>>> @@ -892,6 +892,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
>>> 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>>>
>>> 	cfg->state = STATE_FAILTERM;
>>> +	atomic_inc(&cfg->remove_active);
>> Hi Matthew,
>> you could just call term_afu at this point, this way you don't
>> need an additional check in all irq functions.
>> Cheers,
>> Tomas
> Hi Tomas,
>
> We actually do call term_afu() a few lines down from here. I don't follow
> how moving it here would help things.

When you disable ints sooner (that is what term_afu does ?) you'll get no
more ints later isn't this what you want?

>
> The reason for the atomic was to provide something lightweight that we
> could check _inside_ the processing loop for the read-response queue
> handler. A check outside that loop doesn't really provide much in terms
> of closing or narrowing down the window of when freed memory can be
> accessed.
>
> As David Laight correctly pointed out, this approach does not completely
> close the window. We'd need something heavier to fully protect (e.g. a lock
> to wrap around the entire loop). I will look into adding this in a future cycle
> when I can adequately test.

term_afu calls free_irq and this function
does not return until any executing interrupts for have completed.
This is the sync mechanism you need, it's lightweight
(does not add an additional check to your irq functions)
and closes the race window completely.

--tm

>
>
> -matt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

