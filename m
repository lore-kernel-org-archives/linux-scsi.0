From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Tue, 23 Aug 2016 08:37:24 +0000
Message-ID: <CAGnHSEn470B0ecDdMSY29W4Or3jD_NPoUAku_09o=X9Tn6vSpw@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
 <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
 <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com> <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:32956 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753781AbcHWIh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 04:37:26 -0400
In-Reply-To: <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 23 August 2016 at 07:30, Shaun Tancheff <shaun@tancheff.com> wrote:
>
> But  the "humanized" limit is the one you just added and proceeded to
> change ata_set_lba_range_entries(). You changed from a buffer size
> to use "num" instead and now you want to remove the protection
> entirely?

I am not sure about what you are talking about here. What I did is
just to avoid setting an (inappropriate and unnecessary) hard-coded
limit (with the original while-condition) for i (the unaligned buffer
size) in this general (in the sense that TRIM payload is _not always_
of one 512-byte block, even if we may want to forever practice that in
our kernel) function.

If we really want/need to avoid hitting some real buffer limit (e.g.
maximum length of scatter/gather list?), then we should in some way
check n_block against that. If it is too large we then return
used_bytes = 0 (optionally with some follow-up to add a response to
such return value or so).

We advertise 4194240 as Maximum Write Same Length so that the
SCSI/block layer will know how to split the discard request, and then
we make sure that the SATL reject SCSI commands (that is not issued
through the discard / write same ioctl but with SG_IO /
sg_write_same). That's all we really need to do, end of story.

>
> Why not just change to put this in front of ata_set_lba_range_entries()
>
> if (n_block > 65535 * ATA_MAX_TRIM_RNUM) {
>      fp = 2;
>     goto invalid_fld;
> }

Well you can change the if-else clause to that. Apparently you've been
doing that in your patch series. But that has nothing to do with what
I am fixing here. Neither does it affect the actual behavior.

>
> And then restore ata_set_lba_range_entries() to how it looked
> before you changed it in commit:
>
> 2983860c7 (libata-scsi: avoid repeated calculation of number of TRIM ranges)

I don't see how it is relevant at all. Though I should have introduced
_this_ patch before that to save some work. Unfortunately I wasn't
aware how ugly ata_set_lba_range_entries was.

>
> Then you can have ata_set_lba_range_entries() take the buffer size ...
> something like the following would be fine:
>
>       size = ata_set_lba_range_entries(buf, scmd->device->sector_size,
> block, n_block);
>
> Now things are happily protected against both exceeding the b0 limit(s) and
> overflowing the sglist buffer.

We have no reason at all to bring the logical sector size in here.
Only if in future ACS standards it is stated that payload block are
counted in logical block size instead of statically 512, we would only
need to make the now static "512" in ALIGN() in to 4096.

For possible sglist buffer overflow, see what I mentioned above about
checking n_block and return 0. We would not want to do it with the
original while-way anyway. All it does would be to truncate larger
request and partially complete it silently.

Can you tell exactly how the size of the sglist buffer is limited?
AFAIK it has nothing to do with logical sector size. I doubt that we
will ever cause an overflow, given how conservative we have been on
the size of TRIM payload. We would probably ignore the reported value
once it is larger than 16 or so, if we would ever enable multi-block
payload in the future.

Realistically speaking, I sent this patch not really to get the
function ready for multi-block payload (neither I have mentioned that
in the commit message), but just to make the code proper and avoid
silly effort (and confusion caused) you and I spent in our patches.

>
> --
> Shaun
