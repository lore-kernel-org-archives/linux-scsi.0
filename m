From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Tue, 23 Aug 2016 11:16:35 +0000
Message-ID: <CAGnHSEn3d7s3Tw9MT9Vos+0QBRnnj_gqKorcC56SzOxkK5NN-w@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
 <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
 <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
 <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
 <CAGnHSEn470B0ecDdMSY29W4Or3jD_NPoUAku_09o=X9Tn6vSpw@mail.gmail.com>
 <CAJVOszB7cyUcE+A_EUw0OnvdO3iGFW9sG45R2Ng1Ea_Q7YxaQA@mail.gmail.com>
 <CAGnHSE=Lsb-L-nd8OHQpVPDe1JkURjnXoA26ZQ7bH1GBEPAAtA@mail.gmail.com>
 <CAGnHSEmZdVy2Xp_wK8n+89mD18NPAqcy5UBhhDEy5RAAC7c+vA@mail.gmail.com> <CAJVOszBcuNouJk28nr1smPYJfEhE_9LjD0UgOiG31ApgrXzGJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34468 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757331AbcHWLXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 07:23:12 -0400
In-Reply-To: <CAJVOszBcuNouJk28nr1smPYJfEhE_9LjD0UgOiG31ApgrXzGJg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 23 August 2016 at 10:45, Shaun Tancheff <shaun.tancheff@seagate.com> wrote:
> On Tue, Aug 23, 2016 at 5:17 AM, Tom Yan <tom.ty89@gmail.com> wrote:
>> Wait a minute. I think you missed or misunderstood something when you
>> listen to someone's opinion in that we should switch to sglist buffer.
>
> No, I think I can trust Christoph Hellwig <hch@lst.de>

I didn't say that you cannot trust him, but I just wonder you might
have misinterpreted what he said. I haven't really follow your patch
series earlier though.

>
>> I think the danger people referred to is exactly what is revealed when
>> the ugly code is removed in this commit (it doesn't mean that the code
>> should be kept though).
>>
>> The original buffer appears to be open:
>> buf = page_address(sg_page(scsi_sglist(scmd)));
>
> Which is unsafe.

Yup, but the while loop is not the right way to make it safe. It
probably prevent any overflow, but does not handle / response to the
request (n_block) properly.

It would only be practically unsafe if we would ever call it with a
request that needs a multi-block payload.

>
>> While the new buffer you adopted in in ata_format_sct_write_same() and
>> ata_format_dsm_trim_descr() is of fixed size:
>
> Yes ... it is a temporary response buffer for simulated commands used to
> copy data to and from the command sg_list so as not to hold irqs while
> modifying the buffer.
>
>> buffer = ((void *)ata_scsi_rbuf);
>>
>> sctpg = ((void *)ata_scsi_rbuf);
>>
>> because:
>>
>> #define ATA_SCSI_RBUF_SIZE      4096
>> ...
>> static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
>>
>> So the sglist buffer is always 4096 bytes.
>
> No. The sglist buffer attached to the write same / trim command

Don't you think it is in appropriate to use ata_scsi_rbuf here then?

> is always sdp->sector_size

I can hardly see how sdp->sector_size is relevant to the sglist buffer
(especially the sglist here is facing to the ATA device).
Scatter/gather list could have multiple entries of a certain size
(that is not necessarily, or unlikely, logical sector size). Although
I don't really know how scatter/gather list works, it hardly seems
making any sense by saying that the sglist buffer is always logical
sector size.

AFAIK, for example, USB Attached SCSI driver does not limit the
maximum number of entries (max_segment) so the kernel fall back to
SG_MAX_SEGMENTS (2048), while it reports a max_segment_size of 4096 in
spite of the logical sector size with dma_get_max_seg_size().

For AHCI, it reports a max_segment of 168, while it does not seem to
report any max_segment_size so dma_get_max_seg_size() fallback to
65536 (though practically it seems 4096 will still be used in normal
writing).

>
>> And hence you can probably safely use ATA_SCSI_RBUF_SIZE as the buflen
>> param in the sg_copy_from_buffer() calls (at least in the case of
>> ata_format_sct_write_same()).
>
> No. SCT Write Same has a fixed single 512 byte transfer.

Never mind on that. I have presumption that you should always fully
copy ata_scsi_rbuf to the sglist.

>
> However, the return value of
>> ata_format_dsm_trim_descr() should still always be used_bytes since
>> that is needed by the ata taskfile construction.
>
> So long as it does not exceed its sglist/sector_size buffer.
>
>> You may want to check (n_block / 65535 * 8 > ATA_SCSI_RBUF_SIZE). If
>> it is true, then perhaps we may want to return 0, and make the SATL
>> response with invalid CDB field if we catch that.
>
> No that is not quite right you need to check if you are
> overflowing either RBUF or sdp->sector_size.

Again, this does not make any sense. See above. Apparently you really
have no reason to use ata_scsi_rbuf.

>
>> Though IMHO this is really NOT a reason that is strong enough to
>> prevent this patch from entering the repo first.
>
>> On 23 August 2016 at 09:36, Tom Yan <tom.ty89@gmail.com> wrote:
>>> On 23 August 2016 at 09:18, Shaun Tancheff <shaun.tancheff@seagate.com> wrote:
>>>> On Tue, Aug 23, 2016 at 3:37 AM, Tom Yan <tom.ty89@gmail.com> wrote:
>>>>> On 23 August 2016 at 07:30, Shaun Tancheff <shaun@tancheff.com> wrote:
>>>>
>>>>> If we really want/need to avoid hitting some real buffer limit (e.g.
>>>>> maximum length of scatter/gather list?), then we should in some way
>>>>> check n_block against that. If it is too large we then return
>>>>> used_bytes = 0 (optionally with some follow-up to add a response to
>>>>> such return value or so).
>>>>
>>>> Yes there is a real buffer limit, I can think of these two options:
>>>> 1- Assume the setups from sd_setup_discard_cmnd() and/
>>>>    or sd_setup_write_same_cmnd() are providing an sglist of
>>>>    sdp->sector_size via scsi_init_io()
>>>
>>> That sounds completely wrong. The scatter/gather list we are talking
>>> about here has nothing to do with the SCSI or block layer anymore. The
>>> SATL has _already_ parsed the SCSI Write Same (16) command and is
>>> packing ranges/payload according to that in this stage. If there is
>>> any limit it would probably the max_segment allowed by the host driver
>>> (e.g. ahci).
>>>
>>> It doesn't seem to make sense to me either that we would need to
>>> prevent sglist overflow in such level. Doesn't that mean we would need
>>> to do the same checking (specifically, as in hard coding checks in all
>>> kinds of procedures) in every use of scatter/gather list? That doesn't
>>> sound right at all.
>>>
>>>>
>>>> 2- Find (or write) a suitable sg_get_size(sgl, nents) to walk the
>>>>     sglist and calculate the available buffer size.
>>>>
>>>> #2 sounds like more fun but I'm not sure it's what people would prefer to see.
>>>
>>> No idea if such thing exists / makes sense at all.
>>>
>>>>
>>>> --
>>>> Shaun
>
>
>
> --
> Shaun Tancheff
