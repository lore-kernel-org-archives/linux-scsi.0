From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Mon, 22 Aug 2016 15:32:45 -0500
Message-ID: <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com> <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 3:07 PM, Tom Yan <tom.ty89@gmail.com> wrote:
> I don't see how that's possible. count / n_block will always be
> smaller than 65535 * ATA_MAX_TRIM_RNUM(64) = 4194240. Not to mention
> that isn't even a "buffer limit" anyway. By SG_IO do you mean like
> SCSI Write Same commands that issued with sg_write_same or so? If
> that's the case, that's what exactly commit 5c79097a28c2
> ("libata-scsi: reject WRITE SAME (16) with n_block that exceeds
> limit") is for.

Ah, I see. You are guarding the only user of ata_set_lba_range_entries().
Still if you are going to do that you have to alert any new user that they
must have an appropriately sized buffer to be overwriting.

Better to move it out of ata.h then the limit the scope of accidental
misuse?

Regards,
Shaun
