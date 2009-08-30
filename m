From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] discard support revisited
Date: Sun, 30 Aug 2009 18:48:29 -0400
Message-ID: <20090830224829.GA22682@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829233718.GD22870@parisc-linux.org> <20090830021534.GA14706@infradead.org> <1251663439.10135.159.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1251663439.10135.159.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2009 at 03:17:19PM -0500, James Bottomley wrote:
> > Good question.  Latest I had heard was that at least one array vendor
> > prefers the WRITE SAME.  To me it looks like the much saner interface
> > for the OS, so unless there are arrays that strongly prefer UNMAP or
> > we need to make use of the multiple extends feature in it I'd go with
> > WRITE SAME as first choice.
> 
> So, since their respective names are on the proposals, it's no real
> secret that EMC are pushing WRITE_SAME and Netapp UNMAP, but they are
> both working together on this.  I've already communicated to T10 via
> intermediaries that we'd like only a single implementation for this,
> please.  However, failing that, the current situation where we know from
> an inquiry that the array supports thin provisioning, but don't know
> whether it supports WRITE_SAME or UNMAP until we get a command failure
> is unacceptable.
> 
> If we could get some good solid implementation evidence that WRITE_SAME
> is much easier for an OS than UNMAP, that might help with the T10
> deliberations.

As I've recently worked on all sides of the discard battle (filesystem
support, initiator support, and target support) here are my notes:


 - WRITE_SAME is extremly nice to implement for both the initiator and
   target.  It has the LBA and len exactly in the same place as normal
   16 byte commands, the payload length is fixed to one block, which
   we can allocate once and zero so that we don't even need any memory
   allocations for this command in the initiator.
 - UNMAP is a pain to implement in both initiator and target.  Not
   actuall having the LBA/len information in the cdb but in the payload
   is at least a minor incovenience in the initator, and quite annoying
   in the target as we now need to process payload data in the fastpath,
   which we otherwise only do for slow path CDBs.  This will be
   especially bad for split kernel/user target implementations.

Now the weird design of UNMAP of course has a rather (besides some
apparent pissing contest at NetApp about who can't come with the worst
possible protocol specifications, whose results can be seen in NFSv4
and iSer), and that is that it allows dicarding of multiple
discontinguous ranges.  Doing so is really bad for the filesystem as
it requires it to track multiple outstanding discard requests, which
requires locking, and book keeping to make sure we do not re-use these
blocks before they are discarded.

And at least for my target design it does not provide any measureable
benefits at all, the discard operations are mapped to a hole punch
ioctl on a filesystem, which has a constant basic overhead for each
region punched (synchronous transaction commit) and a small linear
cost per extent removed.  The only benefit of the multiple rangs unmap
would be a saving of protocol roundtrips.

Now that is interestingly actually a downside at least for my still
rather dumb target implementation with a typical Linux filesystem
workload on the initiator side.  If we actually do a lot different unmap
operations in a single unmap command it can start to take significant
amounts of time, and do to Linux waiting for queue drains frequently
due to the barrier implementations we will end up waiting for the unmap
command.

