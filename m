From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: replace target spinlock with seqcount
Date: Wed, 28 May 2014 10:52:24 +0200
Message-ID: <5385A3C8.7090305@redhat.com>
References: <20140527165031.GA21827@google.com>	<5384C3F4.6080101@redhat.com> <CACVXFVN8qaJVkipoKmvepfm0nAoeV0hGagzc=o=3DqVymDt+Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaE1Iwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 04:52:30 -0400
In-Reply-To: <CACVXFVN8qaJVkipoKmvepfm0nAoeV0hGagzc=o=3DqVymDt+Xw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

Il 28/05/2014 03:48, Ming Lei ha scritto:
> On Wed, May 28, 2014 at 12:57 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 27/05/2014 18:50, Venkatesh Srinivas ha scritto:
>>
>>> Hi,
>>>
>>> I think this patch has a small race involving just two commands:
>>>
>>> 1. The first command to a target is in virtscsi_pick_vq(), after
>>>    atomic_inc_return(&tgt->tgt_lock)) but before write_seqcount_begin()
>
> Good catch, thanks Venkatesh
>
> And it doesn't happen in my test, so looks it won't be easy to trigger, :-)

No, it's basically impossible because the race window is very small and 
the first command (INQUIRY or REPORT LUNS) is likely to be synchronous 
anyway.  But it's there anyway.

>>> Specifically:
>>>
>>> @@ -508,19 +507,33 @@ static struct virtio_scsi_vq
>>> *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>>>      unsigned long flags;
>>>      u32 queue_num;
>>>
>>> -    spin_lock_irqsave(&tgt->tgt_lock, flags);
>>> +    local_irq_save(flags);
>>> +    if (atomic_inc_return(&tgt->reqs) > 1) {
>>> +        unsigned long seq;
>>> +
>>> +        do {
>>> +            seq = read_seqcount_begin(&tgt->tgt_seq);
>>> +            vq = tgt->req_vq;
>>> +        } while (read_seqcount_retry(&tgt->tgt_seq, seq));
>>> +    } else {
>>>
>>> A second virtscsi_pick_vq() here will read a stale or NULL tgt->req_vq.
>>
>>
>> The NULL case is true, indeed I was going to send a patch to initialize
>> tgt->req_vq but I have not tested it.
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index fc054935eb1f..f0b4cdbfceb0 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -618,14 +631,17 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>>
>>  static int virtscsi_target_alloc(struct scsi_target *starget)
>>  {
>> +       struct Scsi_Host *sh = dev_to_shost(starget->dev.parent);
>> +       struct virtio_scsi *vscsi = shost_priv(sh);
>> +
>>         struct virtio_scsi_target_state *tgt =
>>                                 kmalloc(sizeof(*tgt), GFP_KERNEL);
>>         if (!tgt)
>>                 return -ENOMEM;
>>
>>
>>         seqcount_init(&tgt->tgt_seq);
>>         atomic_set(&tgt->reqs, 0);
>> -       tgt->req_vq = NULL;
>> +       tgt->req_vq = &vscsi->req_vqs[0];
>>
>>         starget->hostdata = tgt;
>>         return 0;
>
> Paolo, do you need me to integrate this one into the patch? or
> you will make it as one standalone?

I will integrate it myself after testing it.

Paolo
