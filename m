From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Sun, 14 Aug 2016 17:23:45 +0800
Message-ID: <CAGnHSEnycyCRy=SHXs+fQx8mwaQwLtAKO1thH6yYscbBkL2+VQ@mail.gmail.com>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
 <yq1r39upy7p.fsf@sermon.lab.mkp.net> <CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
 <yq1lh01n1ul.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1lh01n1ul.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13 August 2016 at 04:56, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> Tom,
>
>>> put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM / (sector_size / 512), &rbuf[36]);
>
> How many 8-byte ranges fit in a 4096-byte sector?

The thing is, as of ACS-4, blocks that carry DSM/TRIM LBA Range
Entries are always 512-byte. Honestly, I have no idea how that would
work on a 4Kn SSD, if it is / will ever be a thing.

Anyway I was NOT trying to bump the number entries allowed, but
instead to decrease it accordingly for the increased sector size, only
to make sure that the Maximum Write Same Length advertised here is
gonna overflow the 32-bit limit when it is converted to a
representation in bytes (i.e. discard_max_bytes and
write_same_max_bytes), and probably also, the bio size.

It's also a suggestion from me for Shaun to determine how the Maximum
Write Same Length to be advertised, so that the size in bytes covered
by a single SCT Write Same will stay at ~2G in spite of the logical
sector size.

>
> Tom> So were you trying to pointing out something I am still missing, or
> Tom> were you merely confirming I was right?
>
> I suggest you drop ATA_MAX_TRIM_RNUM and do:
>
> enum {
>      ATA_TRIM_BLOCKS_PER_RANGE = 65535, /* 0xffff blocks per range desc. */
>      ATA_TRIM_RANGE_SIZE_SHIFT = 3,     /* range descriptor is 8 bytes */
> };
>
> put_unaligned_be64(ATA_TRIM_BLOCKS_PER_RANGE *
>                    sector_size >> ATA_TRIM_RANGE_SIZE_SHIFT, &rbuf[36]);
>
> Might be worthwhile to create an ata_max_lba_range_blocks() wrapper.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
