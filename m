From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at iscsi_tcp_segment_done+0x20d/0x2e0
Date: Wed, 21 Dec 2016 15:19:15 -0800
Message-ID: <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161221221638.GD4758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161221221638.GD4758@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Wed, Dec 21, 2016 at 2:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Dec 16, 2016 at 10:59:06AM -0800, Chris Leech wrote:
>> Thanks Dave,
>>
>> I'm hitting a bug at scatterlist.h:140 before I even get any iSCSI
>> modules loaded (virtio block) so there's something else going on in the
>> current merge window.  I'll keep an eye on it and make sure there's
>> nothing iSCSI needs fixing for.
>
> OK, so before this slips through the cracks.....
>
> Linus - your tree as of a few minutes ago still panics immediately
> when starting xfstests on iscsi devices. It appears to be a
> scatterlist corruption and not an iscsi problem, so the iscsi guys
> seem to have bounced it and no-one is looking at it.

Hmm. There's not much to go by.

Can somebody in iscsi-land please try to just bisect it - I'm not
seeing a lot of clues to where this comes from otherwise.

There clearly hasn't been anything done to drivers/scsi/*iscsi* since
4.9, so it's coming from elsewhere, presumably the block layer changes
as you say.

But I think we need iscsi people to pinpoint it a bit more, since
nobody else seems to be complaining.

Looking around a bit, the only even halfway suspicious scatterlist
initialization thing I see is commit f9d03f96b988 ("block: improve
handling of the magic discard payload") which used to have a magic
hack wrt !bio->bi_vcnt, and that got removed. See __blk_bios_map_sg(),
now it does __blk_bvec_map_sg() instead.

Maybe __blk_bvec_map_sg() would want that same

    if (!bio->bi_vcnt)
        return 0;

adding Christoph explicitly so that he can tell me why I'm a clueless
weenie. Although I suspect he's already on the scsi and block lists
and would have done so anyway.

> I'm disappearing for several months at the end of tomorrow, so I
> thought I better make sure you know about it.  I've also added
> linux-scsi, linux-block to the cc list....

Thanks,

            Linus
