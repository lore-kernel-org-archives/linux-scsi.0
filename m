From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 19:16:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021030181627.GV3416@suse.de>
References: <20021027215433.GA30429@suse.de> <200210301739.g9UHdDU12308@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210301739.g9UHdDU12308@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@redhat.com>

On Wed, Oct 30 2002, Badari Pulavarty wrote:
> Hi,
> 
> I still get panics while doing filesystem IO on -mm kernels (with
> qlogic fc). I get following msgs before getting the panic:
> 
> Incorrect number of segments after building list
> counted 3, received 2
> req nr_sec 256, cur_nr_sec 8
> 
> So I debugged why this is happening. Here is the bottom line:
> 
> bio->bi_phys_segments calculated by blk_recount_segments()
> is not matching the number of sg elements used by blk_rq_map_sg().
> 
> I am doing 128K IO. In the following debug output, my pages in the 
> IO except for the first one are contiguous. Since q->max_segment_size = 64K,
> it is using 3 sg elememnts - which is correct. 
> 
> But blk_recount_segments() is not incrementing bio->bi_phys_segments 
> due to the BIOVEC_VIRT_MERGEABLE() check. It always fails and
> it creats a new segment all the time. (which does not increment
> bi_phys_segments).
> 
> What does BIOVEC_VIRT_MERGEABLE() supposed to do ? I am guessing
> it is supposed to restrict IO crossing 4GB boundary. Is it correct ?

It's only for platforms with iommu that can do funky remapping tricks
for pages ending on certain boundaries. I'm sure davem or anton can tell
you more about this for sparc64 or ppc64. For x86, it will always be
true. Hmm, looking at it, I can't convince myself that it is right.
Davem, could you please check up on this? I'll be back later tonight to
review it as well. Things are not consistent, I agree on that.

Good debugging, btw!

-- 
Jens Axboe

