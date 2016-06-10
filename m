From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2] Add support for SCT Write Same
Date: Thu, 9 Jun 2016 22:24:40 -0500
Message-ID: <CAJVOszAO7YxznaUNs1+HaN=aRaA3yPiQDYHSQw+To6BKMEL++A@mail.gmail.com>
References: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
 <1465453967-11085-2-git-send-email-shaun@tancheff.com> <20160609092212.GA7459@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160609092212.GA7459@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 9, 2016 at 4:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +     if (ata_id_sct_write_same(dev->id))
>> +             sdev->sct_write_same = 1;
>> +
>
> What's the point of this flag?  It should simply clear the no_write_same
> flag for this device.  Due to the way how we have both a per-host and
> per-device flag that might not be completely trivial, but untangling
> that mess might be a good idea anyway.

Agreed. I looks like clearing the no_write_same flag mostly works
but the queue limits don't make any sense because they get cleared.
I'll see if I can untangle it.

>> @@ -3305,6 +3308,37 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>>               goto invalid_param_len;
>>
>>       buf = page_address(sg_page(scsi_sglist(scmd)));
>> +
>> +     if (ata_id_sct_write_same(dev->id)) {
>
> Various comments:
>
>  - The plain page_address above looks harmful, how do we know that
>    the page is mapped into kernel memory?  This might actually be broken
>    already, though.

I think it just happens to work because it's always used with a recently
allocated page. Fixing it to include the (possible) offset is just a good thing.

>  - Why is this below the check that rejects non-unmap WRITE SAME
>    commands?

Yeah, tunnel vision. For some reason I was thinking that it was
either WRITE SAME or SCT. But this case is actually TRIM and/or SCT which
makes the demuxing what the user expects a little less clear.

Now I am thinking that the cleanest method is to try and honor the unmap
flag to pick the command path.

If trim is available and unmap is set then you get the current behavior.
else if SCT is available follow the SCT path
else fail with the current error (unmap is not set).

In this way if you device supports both TRIM and SCT then you can WRITE SAME
or TRIM.

>  - Shouldn't we still translate discard command to TRIM?  Maybe we
>    need a check of the operation in the request structure..
>

-- 
Shaun Tancheff
