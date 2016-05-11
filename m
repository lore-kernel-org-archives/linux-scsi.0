From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 6/6] mpt3sas: Used "synchronize_irq()"API to synchronize
 timed-out IO & TMs
Date: Wed, 11 May 2016 09:23:10 +0530
Message-ID: <CAK=zhgo_QGBBqQNRK_bDcvVGw10Rm=3nTpVFs+w0K2APSVW28g@mail.gmail.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
	<1462525171-6877-7-git-send-email-chaitra.basappa@broadcom.com>
	<5731DE15.5030906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36046 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbcEKDxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 23:53:11 -0400
Received: by mail-oi0-f41.google.com with SMTP id x201so48439381oif.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2016 20:53:11 -0700 (PDT)
In-Reply-To: <5731DE15.5030906@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash Veerichetty <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, May 10, 2016 at 6:41 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 6.5.2016 10:59, Chaitra P B wrote:
>> Replaced mpt3sas_base_flush_reply_queues()with
>> mpt3sas_base_sync_reply_irqs(),as mpt3sas_base_flush_reply_queues()
>> skips over reply queues that are currently busy (i.e. being handled
>> by interrupt processing in another core). If a reply queue is busy,
>> then call to synchronize_irq()in mpt3sas_base_sync_reply_irqs()make
>> sures the other core has finished flushing the queue and completed
>> any calls to the mid-layer scsi_done() routine.
>>
>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 15 +++++++--------
>>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ++-
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +++-
>>  3 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 4e9142f..fd9002d 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -1103,18 +1103,16 @@ _base_is_controller_msix_enabled(struct MPT3SAS_ADAPTER *ioc)
>>  }
>>
>>  /**
>> - * mpt3sas_base_flush_reply_queues - flushing the MSIX reply queues
>> + * mpt3sas_base_sync_reply_irqs - flush pending MSIX interrupts
>>   * @ioc: per adapter object
>> - * Context: ISR conext
>> + * Context: non ISR conext
>>   *
>> - * Called when a Task Management request has completed. We want
>> - * to flush the other reply queues so all the outstanding IO has been
>> - * completed back to OS before we process the TM completetion.
>> + * Called when a Task Management request has completed.
>>   *
>>   * Return nothing.
>>   */
>>  void
>> -mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>> +mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
>>  {
>>       struct adapter_reply_queue *reply_q;
>>
>> @@ -1125,12 +1123,13 @@ mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>>               return;
>>
>>       list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>> -             if (ioc->shost_recovery)
>> +             if (ioc->shost_recovery || ioc->remove_host ||
>> +                             ioc->pci_error_recovery)
>
> Hi Chaitra,
> how is this change + (ioc->remove_host || ioc->pci_error_recovery)
> related to the subject?

[Sreekanth] These changes are actually not related to this subject, but these
sanity checks were missing previously.

>
>>                       return;
>>               /* TMs are on msix_index == 0 */
>>               if (reply_q->msix_index == 0)
>>                       continue;
>> -             _base_interrupt(reply_q->vector, (void *)reply_q);
>> +             synchronize_irq(reply_q->vector);
>>       }
>
> One thing I don't understand - what if an interrupt comes after
> the synchronize_irq has finished ?

[Sreekanth] Tomas, we are calling this function
'mpt3sas_base_flush_reply_queues()'
only after we got the reply for the TM. Also our firmware will send
reply for the TM only after
it sends reply for the all terminated IOs (due to this TM). So by this
time firmware has already
raised interrupts for all the terminated IOs before it raising
interrupt for TM. So we won't get
any interrupts (which we are interested) after synchronize_irq.

Thanks,
Sreekanth
>
> Thanks,
> Tomas
>
>>  }
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
>> index e1befba..1a614d7 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>> @@ -1236,7 +1236,8 @@ void *mpt3sas_base_get_msg_frame(struct MPT3SAS_ADAPTER *ioc, u16 smid);
>>  void *mpt3sas_base_get_sense_buffer(struct MPT3SAS_ADAPTER *ioc, u16 smid);
>>  __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
>>       u16 smid);
>> -void mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc);
>> +
>> +void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
>>
>>  /* hi-priority queue */
>>  u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index abd8717..928214f 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -2126,7 +2126,6 @@ _scsih_tm_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>>               return 1;
>>       if (ioc->tm_cmds.smid != smid)
>>               return 1;
>> -     mpt3sas_base_flush_reply_queues(ioc);
>>       ioc->tm_cmds.status |= MPT3_CMD_COMPLETE;
>>       mpi_reply =  mpt3sas_base_get_reply_virt_addr(ioc, reply);
>>       if (mpi_reply) {
>> @@ -2311,6 +2310,9 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
>>               }
>>       }
>>
>> +     /* sync IRQs in case those were busy during flush. */
>> +     mpt3sas_base_sync_reply_irqs(ioc);
>> +
>>       if (ioc->tm_cmds.status & MPT3_CMD_REPLY_VALID) {
>>               mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
>>               mpi_reply = ioc->tm_cmds.reply;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
