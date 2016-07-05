From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 1/2] libata-scsi: improve TRIM translation
Date: Wed, 6 Jul 2016 03:10:51 +0800
Message-ID: <CAGnHSEkoJPzi0qQbu2SjqYehFW9o1g8d-mm=jYuQk=YgBKa8Yw@mail.gmail.com>
References: <577b57b0.5b4c620a.37648.6c8d@mx.google.com> <6f5400ce-58c8-d52c-9ce5-a1450b52599e@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <6f5400ce-58c8-d52c-9ce5-a1450b52599e@cogentembedded.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Well it is exactly what the patch does. We no longer do the "divide it
by 8" thing each time we want to know the now defined TRIM_RANGE_NUM.

ata_set_lba_range_entries() has only been used by
ata_scsi_write_same_xlat()
(http://lxr.free-electrons.com/ident?i=ata_set_lba_range_entries,
although the comment of it seems to tell otherwise). That's why I
(could) changed the function itself and the param ("512")
ata_scsi_write_same_xlat() passes to it.

On 5 July 2016 at 19:04, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 7/5/2016 9:45 AM, tom.ty89@gmail.com wrote:
>
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> Define TRIM_RANGE_SIZE and TRIM_RANGE_NUM so that the corresponding
>> functions can be more generalized. Also, conform to SBC by rejecting
>> WRITE SAME (16) commands with number of blocks that exceeds the limit
>> that is defined in the SATL.
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
>
> [...]
>
>> diff --git a/include/linux/ata.h b/include/linux/ata.h
>> index 99346be..0971c3f 100644
>> --- a/include/linux/ata.h
>> +++ b/include/linux/ata.h
>> @@ -1071,7 +1071,7 @@ static inline unsigned
>> ata_set_lba_range_entries(void *_buffer,
>>         __le64 *buffer = _buffer;
>>         unsigned i = 0, used_bytes;
>>
>> -       while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry
>> */
>> +       while (i < buf_size) {
>
>
>    BTW, this change doesn't seem to be documented in the patch description?
>
> [...]
>
> MBR, Sergei
>
