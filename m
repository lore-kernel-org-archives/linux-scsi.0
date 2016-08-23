From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Tue, 23 Aug 2016 02:30:46 -0500
Message-ID: <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
 <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com> <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35541 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbcHWHar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 03:30:47 -0400
In-Reply-To: <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 3:53 PM, Tom Yan <tom.ty89@gmail.com> wrote:
> On 22 August 2016 at 20:32, Shaun Tancheff <shaun.tancheff@seagate.com> wrote:
>> On Mon, Aug 22, 2016 at 3:07 PM, Tom Yan <tom.ty89@gmail.com> wrote:
>>> I don't see how that's possible. count / n_block will always be
>>> smaller than 65535 * ATA_MAX_TRIM_RNUM(64) = 4194240. Not to mention
>>> that isn't even a "buffer limit" anyway. By SG_IO do you mean like
>>> SCSI Write Same commands that issued with sg_write_same or so? If
>>> that's the case, that's what exactly commit 5c79097a28c2
>>> ("libata-scsi: reject WRITE SAME (16) with n_block that exceeds
>>> limit") is for.
>>
>> Ah, I see. You are guarding the only user of ata_set_lba_range_entries().
>
> Yup. It is the only right thing to do anyway, that we leave the
> function "open" and guard per context when we use it. Say if
> ata_set_lba_range_entries() is gonna be a function that is shared by
> others, it would only make this commit more important. As I said, we
> did not guard it with a certain buffer limit, but merely redundantly
> guard it with a ("humanized") limit that applies to TRIM only.

But  the "humanized" limit is the one you just added and proceeded to
change ata_set_lba_range_entries(). You changed from a buffer size
to use "num" instead and now you want to remove the protection
entirely?

Why not just change to put this in front of ata_set_lba_range_entries()

if (n_block > 65535 * ATA_MAX_TRIM_RNUM) {
     fp = 2;
    goto invalid_fld;
}

And then restore ata_set_lba_range_entries() to how it looked
before you changed it in commit:

2983860c7 (libata-scsi: avoid repeated calculation of number of TRIM ranges)

Then you can have ata_set_lba_range_entries() take the buffer size ...
something like the following would be fine:

      size = ata_set_lba_range_entries(buf, scmd->device->sector_size,
block, n_block);

Now things are happily protected against both exceeding the b0 limit(s) and
overflowing the sglist buffer.

--
Shaun
