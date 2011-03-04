From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Fri, 4 Mar 2011 12:51:43 -0800
Message-ID: <20110304205143.GE27190@tux1.beaverton.ibm.com>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <4D634D8F.4070401@panasas.com> <20110222114222.GA24728@quack.suse.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110222114222.GA24728@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2011 at 12:42:22PM +0100, Jan Kara wrote:
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

Hmm.  Any interest in pushing the page copy patch as an interim solution while
I work on getting the wait-on-writeback strategy to function?  I agree it's not
the fastest solution, but at least it won't be running broken while I find the
faster solution(s).

(More on that writeback patch in a short while.)

--D
