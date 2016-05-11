From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/6] mpt3sas: Used "synchronize_irq()"API to synchronize
 timed-out IO & TMs
Date: Wed, 11 May 2016 16:04:28 +0200
Message-ID: <57333BEC.6030604@redhat.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
 <1462525171-6877-7-git-send-email-chaitra.basappa@broadcom.com>
 <5731DE15.5030906@redhat.com>
 <CAK=zhgo_QGBBqQNRK_bDcvVGw10Rm=3nTpVFs+w0K2APSVW28g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbcEKOEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 10:04:32 -0400
In-Reply-To: <CAK=zhgo_QGBBqQNRK_bDcvVGw10Rm=3nTpVFs+w0K2APSVW28g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash Veerichetty <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 11.5.2016 05:53, Sreekanth Reddy wrote:
> On Tue, May 10, 2016 at 6:41 PM, Tomas Henzl <thenzl@redhat.com> wrote:
>> On 6.5.2016 10:59, Chaitra P B wrote:
>>> Replaced mpt3sas_base_flush_reply_queues()with
>>> mpt3sas_base_sync_reply_irqs(),as mpt3sas_base_flush_reply_queues()
>>> skips over reply queues that are currently busy (i.e. being handled
>>> by interrupt processing in another core). If a reply queue is busy,
>>> then call to synchronize_irq()in mpt3sas_base_sync_reply_irqs()make
>>> sures the other core has finished flushing the queue and completed
>>> any calls to the mid-layer scsi_done() routine.
>>>
>>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>>> ---
>>>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 15 +++++++--------
>>>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ++-
>>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +++-
>>>  3 files changed, 12 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> index 4e9142f..fd9002d 100644
>>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> @@ -1103,18 +1103,16 @@ _base_is_controller_msix_enabled(struct MPT3SAS_ADAPTER *ioc)
>>>  }
>>>
>>>  /**
>>> - * mpt3sas_base_flush_reply_queues - flushing the MSIX reply queues
>>> + * mpt3sas_base_sync_reply_irqs - flush pending MSIX interrupts
>>>   * @ioc: per adapter object
>>> - * Context: ISR conext
>>> + * Context: non ISR conext
>>>   *
>>> - * Called when a Task Management request has completed. We want
>>> - * to flush the other reply queues so all the outstanding IO has been
>>> - * completed back to OS before we process the TM completetion.
>>> + * Called when a Task Management request has completed.
>>>   *
>>>   * Return nothing.
>>>   */
>>>  void
>>> -mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>>> +mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
>>>  {
>>>       struct adapter_reply_queue *reply_q;
>>>
>>> @@ -1125,12 +1123,13 @@ mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>>>               return;
>>>
>>>       list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>>> -             if (ioc->shost_recovery)
>>> +             if (ioc->shost_recovery || ioc->remove_host ||
>>> +                             ioc->pci_error_recovery)
>> Hi Chaitra,
>> how is this change + (ioc->remove_host || ioc->pci_error_recovery)
>> related to the subject?
> [Sreekanth] These changes are actually not related to this subject, but these
> sanity checks were missing previously.

Please next time put in a separated patch.

>
>>>                       return;
>>>               /* TMs are on msix_index == 0 */
>>>               if (reply_q->msix_index == 0)
>>>                       continue;
>>> -             _base_interrupt(reply_q->vector, (void *)reply_q);
>>> +             synchronize_irq(reply_q->vector);
>>>       }
>> One thing I don't understand - what if an interrupt comes after
>> the synchronize_irq has finished ?
> [Sreekanth] Tomas, we are calling this function
> 'mpt3sas_base_flush_reply_queues()'
> only after we got the reply for the TM. Also our firmware will send
> reply for the TM only after
> it sends reply for the all terminated IOs (due to this TM). So by this
> time firmware has already
> raised interrupts for all the terminated IOs before it raising
> interrupt for TM. So we won't get
> any interrupts (which we are interested) after synchronize_irq.

Thanks.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

