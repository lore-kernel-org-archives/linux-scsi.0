From: Jens Axboe <axboe@fb.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Fri, 23 Dec 2016 19:45:45 -0700
Message-ID: <fadbf3d2-23c1-f822-cf0f-50182227a2dc@fb.com>
References: <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <20161222065012.GI4758@dastard>
 <20161222185030.so4btkuzzkih3owz@straylight.hirudinean.org>
 <CACVXFVOGoh+AEGSSMsbxfdAjZQS5k_t+7uR-+qwusm0vfauHEA@mail.gmail.com>
 <20161223000356.dxwkgsei32w7hc4f@straylight.hirudinean.org>
 <20161223100014.GA29467@lst.de>
 <CA+55aFxA1LE+4jdR8YXZyRVJ-MpOCUVob=ESBsMPuW=Qb=px-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxA1LE+4jdR8YXZyRVJ-MpOCUVob=ESBsMPuW=Qb=px-A@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: Chris Leech <cleech@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/23/2016 12:42 PM, Linus Torvalds wrote:
> On Fri, Dec 23, 2016 at 2:00 AM, Christoph Hellwig <hch@lst.de> wrote:
>>
>> From: Christoph Hellwig <hch@lst.de>
>> Date: Fri, 23 Dec 2016 10:57:06 +0100
>> Subject: virtio_blk: avoid DMA to stack for the sense buffer
>>
>> Most users of BLOCK_PC requests allocate the sense buffer on the stack,
>> so to avoid DMA to the stack copy them to a field in the heap allocated
>> virtblk_req structure.  Without that any attempt at SCSI passthrough I/O,
>> including the SG_IO ioctl from userspace will crash the kernel.  Note that
>> this includes running tools like hdparm even when the host does not have
>> SCSI passthrough enabled.
> 
> Ugh. This patch is nasty.
> 
> I think we should just fix blk_execute_rq() instead.
> 
> But from a quick look, we also have at least sg_scsi_ioctl() and
> sg_io() doing the same thing.
> 
> And the SG_IO thing in bsg_ioctl(). And spi_execute() in scsi_transport_spi.c
> 
> And resp_requests() in scsi_debug.c.

It's not that it's technically hard to fix up, it's more that it's a
pain in the ass to have to do it. For instance, for blk_execute_rq(), we
either should enforce that the caller allocates it dynamically and then
free it, or we need nasty hack where the caller needs to know he has to
free it. Pretty obvious what I would prefer there.

And yes, there would be a good chunk of other places where this would
nede to be fixed up...

> So I guess ugly it may need to be, and the rule is that the sense
> buffer really can be on the stack and you can't DMA to/from it.
> Comments from others?

I'm just wondering why this is being hit now, we have a 4.9 release with
this issue and nobody reported it (that I saw)... Which is pretty sad.

If no one beats me to it, I'll try and get a patch done on Sunday. We're
in the midst of the holidays here.

-- 
Jens Axboe

