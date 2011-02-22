From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Tue, 22 Feb 2011 09:13:49 -0700
Message-ID: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-02-21, at 19:00, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
> write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
> discussion about how to deal with the situation where one program tells the
> kernel to write a block to disk, the kernel computes the checksum of that data,
> and then a second program begins writing to that same block before the disk HBA
> can DMA the memory block, thereby causing the disk to complain about being sent
> invalid checksums.
> 
> I was able to write a
> trivial program to trigger the write problem, I'm pretty sure that this has not
> been fixed upstream.  (FYI, using O_DIRECT still seems fine.)

Can you please attach your reproducer? IIRC it needed mmap() to hit this problem?  Did you measure CPU usage during your testing?

> Below is a simple if naive solution: (ab)use the bounce buffering code to copy
> the memory page just prior to calculating the checksum, and send the copy and
> the checksum to the disk controller.  With this patch applied, the invalid
> guard tag messages go away.  An optimization would be to perform the copy only
> when memory contents change, but I wanted to ask peoples' opinions before
> continuing.  I don't imagine bounce buffering is particularly speedy, though I
> haven't noticed any corruption errors or weirdness yet.

I don't like adding a data copy in the IO path at all. We are just looking to enable T10 DIF for Lustre and this would definitely hurt performance significantly, even though it isn't needed there at all (since the server side has proper locking of the pages to prevent multiple writers to the same page).

> Anyway, I'm mostly wondering: what do people think of this as a starting point
> to fixing the DIF checksum problem?

I'd definitely prefer that the filesystem be in charge of deciding whether this is needed or not. If the use of the data copy can be constrained to only the minimum required cases (e.g. if fs checks for rewrite on page that is marked as Writeback and either copies or blocks until writeback is complete, as a mount option) that would be better. At that point we can compare on different hardware whether copying or blocking should be the default. 

Cheers, Andreas
