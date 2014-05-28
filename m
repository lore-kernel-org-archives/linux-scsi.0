From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio-scsi: replace target spinlock with seqcount
Date: Wed, 28 May 2014 09:48:50 +0800
Message-ID: <CACVXFVN8qaJVkipoKmvepfm0nAoeV0hGagzc=o=3DqVymDt+Xw@mail.gmail.com>
References: <20140527165031.GA21827@google.com>
	<5384C3F4.6080101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43226 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE1Bsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 21:48:51 -0400
Received: by mail-vc0-f171.google.com with SMTP id lc6so11686050vcb.30
        for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 18:48:51 -0700 (PDT)
In-Reply-To: <5384C3F4.6080101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, May 28, 2014 at 12:57 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 27/05/2014 18:50, Venkatesh Srinivas ha scritto:
>
>> Hi,
>>
>> I think this patch has a small race involving just two commands:
>>
>> 1. The first command to a target is in virtscsi_pick_vq(), after
>>    atomic_inc_return(&tgt->tgt_lock)) but before write_seqcount_begin()

Good catch, thanks Venkatesh

And it doesn't happen in my test, so looks it won't be easy to trigger, :-)

>> 2. A second command to the same target enters virtscsi_pick_vq(). It
>>    will hit the same atomic inc, take the upper branch of the
>>    conditional, and read out a stale (or NULL) tgt->req_vq.

Yes, that can't be avoided without spinlock and the 'stale' req_vq is
still fine, and it isn't a big deal since the window is very very small.

>>
>> Specifically:
>>
>> @@ -508,19 +507,33 @@ static struct virtio_scsi_vq
>> *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>>      unsigned long flags;
>>      u32 queue_num;
>>
>> -    spin_lock_irqsave(&tgt->tgt_lock, flags);
>> +    local_irq_save(flags);
>> +    if (atomic_inc_return(&tgt->reqs) > 1) {
>> +        unsigned long seq;
>> +
>> +        do {
>> +            seq = read_seqcount_begin(&tgt->tgt_seq);
>> +            vq = tgt->req_vq;
>> +        } while (read_seqcount_retry(&tgt->tgt_seq, seq));
>> +    } else {
>>
>> A second virtscsi_pick_vq() here will read a stale or NULL tgt->req_vq.
>
>
> The NULL case is true, indeed I was going to send a patch to initialize
> tgt->req_vq but I have not tested it.
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index fc054935eb1f..f0b4cdbfceb0 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -618,14 +631,17 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>
>  static int virtscsi_target_alloc(struct scsi_target *starget)
>  {
> +       struct Scsi_Host *sh = dev_to_shost(starget->dev.parent);
> +       struct virtio_scsi *vscsi = shost_priv(sh);
> +
>         struct virtio_scsi_target_state *tgt =
>                                 kmalloc(sizeof(*tgt), GFP_KERNEL);
>         if (!tgt)
>                 return -ENOMEM;
>
>
>         seqcount_init(&tgt->tgt_seq);
>         atomic_set(&tgt->reqs, 0);
> -       tgt->req_vq = NULL;
> +       tgt->req_vq = &vscsi->req_vqs[0];
>
>         starget->hostdata = tgt;
>         return 0;

Paolo, do you need me to integrate this one into the patch? or
you will make it as one standalone?

>
>
> The case of a stale req_vq is okay and is the (IMO reasonable) price to
> pay for allowing more concurrency.  If you have concurrent requests
> from multiple VCPUs, multiqueue is not great for your workload anyway,
> at least with the current steering algorithm.
>
> Paolo


Thanks,
-- 
Ming Lei
