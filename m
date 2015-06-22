From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v1 01/20] [SCSI] mpt3sas: Added Combined Reply Queue
 feature to extend up-to 96 MSIX vector support
Date: Mon, 22 Jun 2015 18:08:27 +0530
Message-ID: <CAK=zhgp2vf_CqLv+eG_RkZsCAD3P8dmFPYaYRArMiCgP-4ZpNQ@mail.gmail.com>
References: <1434711346-9970-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1vbejd9uf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34483 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbFVMi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 08:38:29 -0400
Received: by wicnd19 with SMTP id nd19so75284863wic.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2015 05:38:27 -0700 (PDT)
In-Reply-To: <yq1vbejd9uf.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 8:27 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth,
>
> It's fine that you outline the 96 / 12 = 8 layout in the patch
> description. But that relationship is not made clear when reading the
> code. Please add a comment describing why things are set up this way.

Accepted. I will add the comments where ever required.

>
>> @@ -1009,8 +1009,15 @@ _base_interrupt(int irq, void *bus_id)
>>       }
>>
>>       wmb();
>> -     writel(reply_q->reply_post_host_index | (msix_index <<
>> -         MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostIndex);
>> +     if (ioc->msix96_vector) {
>> +             writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
>> +                     MPI2_RPHI_MSIX_INDEX_SHIFT),
>> +                             ioc->replyPostRegisterIndex[msix_index/8]);
>> +     } else {
>> +             writel(reply_q->reply_post_host_index | (msix_index <<
>> +                     MPI2_RPHI_MSIX_INDEX_SHIFT),
>> +                             &ioc->chip->ReplyPostHostIndex);
>> +     }
>
> Too many brackets. Why don't you do:

I will remove these extra brackets. but SAS3 HBA's less than C0
revision (which doesn't support this Combined Reply Queue feature)
will support up to 16 MSI-X vectors. so can't update the MSIxIndex
field with just from 0 to 7 by taking the modular of 8 on msix_index
value. so can't do below this.

>
>         index = reply_q->reply_post_host_index |
>                 ((msix_index & 7) << MPI_RPHI_MSIX_INDEX_SHIFT);
>
>         if (ioc->msix96_vector)
>                 writel(index, ioc->replyPostRegisterIndex[msix_index / 8]);
>         else
>                 writel(index, &ioc->chip->ReplyPostHostIndex);
>
>> +     if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
>> +             /* If this is an 96 vector supported device,
>> +             set up ReplyPostIndex addresses */
>
> Bad comment formatting.

Accepted, will update this.

>
>> +             ioc->replyPostRegisterIndex = kcalloc(12,
>> +                     sizeof(resource_size_t *), GFP_KERNEL);
> [...]
>> +             for (i = 0; i < 12; i++) {
>
> Make 12 a constant or at the very least a variable with a comment.

Agreed. Will do this.

>
>> +                     ioc->replyPostRegisterIndex[i] = (resource_size_t *)
>> +                             ((u8 *)&ioc->chip->Doorbell +
>> +                             MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
>> +                             (i * 0x10));
>
> 0x10 - Another magic constant.

Accepted, Will update.

>
>> @@ -4522,8 +4554,16 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
>>
>>       /* initialize reply post host index */
>>       list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>> -             writel(reply_q->msix_index << MPI2_RPHI_MSIX_INDEX_SHIFT,
>> -                 &ioc->chip->ReplyPostHostIndex);
>> +             if (ioc->msix96_vector) {
>> +                     writel((reply_q->msix_index & 7)<<
>> +                        MPI2_RPHI_MSIX_INDEX_SHIFT,
>> +                        ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
>> +             } else {
>> +                     writel(reply_q->msix_index <<
>> +                             MPI2_RPHI_MSIX_INDEX_SHIFT,
>> +                                     &ioc->chip->ReplyPostHostIndex);
>> +             }
>> +
>
> Too many brackets.

I will remove these brackets and also will post the next version of
this patch by considering all above comments.

>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 

Regards,
Sreekanth
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
