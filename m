From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Tue, 22 Feb 2011 08:02:10 -0500
Message-ID: <1298379714-sup-3015@think>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <4D634D8F.4070401@panasas.com> <20110222114222.GA24728@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110222114222.GA24728@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>, djwong <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[ resend sorry if you get this twice ]

Excerpts from Jan Kara's message of 2011-02-22 06:42:22 -0500:
>   Hi Boaz,
> 
> On Mon 21-02-11 21:45:51, Boaz Harrosh wrote:
> > On 02/21/2011 06:00 PM, Darrick J. Wong wrote:
> > > Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
> > > write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
> > > discussion about how to deal with the situation where one program tells the
> > > kernel to write a block to disk, the kernel computes the checksum of that data,
> > > and then a second program begins writing to that same block before the disk HBA
> > > can DMA the memory block, thereby causing the disk to complain about being sent
> > > invalid checksums.
> > 
> > The brokenness is in ext2/3 if you'll use btrfs, xfs and I think late versions
> > of ext4 it should work much better. (If you still have problems please report
> > them, those FSs advertise stable pages write-out)
>   Do they? I've just checked ext4 and xfs and they don't seem to enforce
> stable pages. They do lock the page (which implicitely happens in mm code
> for any filesystem BTW) but this is not enough. You have to wait for
> PageWriteback to get cleared and only btrfs does that.
>  
> > This problem is easily fixed at the FS layer or even at VFS, by overriding mk_write
> > and syncing with write-out for example by taking the page-lock. Currently each
> > FS is to itself because in VFS it would force the behaviour on FSs that it does
> > not make sense to.
>   Yes, it's easy to fix but at a performance cost for any application doing
> frequent rewrites regardless whether integrity features are used or not.
> And I don't think that's a good thing. I even remember someone measured the
> hit last time this came up and it was rather noticeable.

Do you remember which workload this was?  I do remember someone
mentioning a specific workload, but can't recall which one now.  fsx is
definitely slower when we wait for writeback, but that's because it's
all evil inside.

> 
> > Note that the proper solution does not copy any data, just forces the app to
> > wait before changing write-out pages.
>   I think that's up for discussion. In fact what is going to be faster
> depends pretty much on your system config. If you have enough CPU/RAM
> bandwidth compared to storage speed, you're better of doing copying. If
> you can barely saturate storage with your CPU/RAM, waiting is probably
> better for you. 
> 
> Moreover if you do data copyout, you push the performance cost only on
> users of the integrity feature which is nice. But on the other hand users
> of integrity take the cost even if they are not doing rewrites.
> 
> A solution which is technically plausible and penalizing only rewrites
> of data-integrity protected pages would be a use of shadow pages as Darrick
> describes below. So I'd lean towards that long term. But for now I think
> Darrick's solution is OK to make the integrity feature actually useful and
> later someone can try something more clever.

Rewrites in flight should be very rare though, and I think the bouncing
is going to have a big impact on the intended workloads.  It's not just
the cost of the copy, it's also the increased time as we beat on the
page allocator.

We're working on adding stable pages to ext34 and other filesystems
missing it.  When the work is done we can benchmark and decide on the
tradeoffs.

-chris
