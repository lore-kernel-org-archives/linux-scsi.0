From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Mon, 22 Aug 2016 20:53:14 +0000
Message-ID: <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com> <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36135 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbcHVUxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 16:53:17 -0400
In-Reply-To: <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 22 August 2016 at 20:32, Shaun Tancheff <shaun.tancheff@seagate.com> wrote:
> On Mon, Aug 22, 2016 at 3:07 PM, Tom Yan <tom.ty89@gmail.com> wrote:
>> I don't see how that's possible. count / n_block will always be
>> smaller than 65535 * ATA_MAX_TRIM_RNUM(64) = 4194240. Not to mention
>> that isn't even a "buffer limit" anyway. By SG_IO do you mean like
>> SCSI Write Same commands that issued with sg_write_same or so? If
>> that's the case, that's what exactly commit 5c79097a28c2
>> ("libata-scsi: reject WRITE SAME (16) with n_block that exceeds
>> limit") is for.
>
> Ah, I see. You are guarding the only user of ata_set_lba_range_entries().

Yup. It is the only right thing to do anyway, that we leave the
function "open" and guard per context when we use it. Say if
ata_set_lba_range_entries() is gonna be a function that is shared by
others, it would only make this commit more important. As I said, we
did not guard it with a certain buffer limit, but merely redundantly
guard it with a ("humanized") limit that applies to TRIM only.

> Still if you are going to do that you have to alert any new user that they
> must have an appropriately sized buffer to be overwriting.
>
> Better to move it out of ata.h then the limit the scope of accidental
> misuse?

I am not sure if it is really necessary but that's fine to me. I see
that you have been doing it in your SCT Write Same patch series.
Probably I can/should just leave the move to you?

>
> Regards,
> Shaun
