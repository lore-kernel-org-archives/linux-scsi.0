From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/7] discard support revisited
Date: Wed, 2 Sep 2009 13:46:58 -0600
Message-ID: <20090902194658.GQ22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829233718.GD22870@parisc-linux.org> <20090830021534.GA14706@infradead.org> <1251663439.10135.159.camel@mulgrave.site> <20090830224829.GA22682@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35380 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZIBTq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 15:46:56 -0400
Content-Disposition: inline
In-Reply-To: <20090830224829.GA22682@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, dwmw2@infradead.org

On Sun, Aug 30, 2009 at 06:48:29PM -0400, Christoph Hellwig wrote:
> As I've recently worked on all sides of the discard battle (filesystem
> support, initiator support, and target support) here are my notes:
> 
>  - WRITE_SAME is extremly nice to implement for both the initiator and
>    target.  It has the LBA and len exactly in the same place as normal
>    16 byte commands, the payload length is fixed to one block, which
>    we can allocate once and zero so that we don't even need any memory
>    allocations for this command in the initiator.
>  - UNMAP is a pain to implement in both initiator and target.  Not
>    actuall having the LBA/len information in the cdb but in the payload
>    is at least a minor incovenience in the initator, and quite annoying
>    in the target as we now need to process payload data in the fastpath,
>    which we otherwise only do for slow path CDBs.  This will be
>    especially bad for split kernel/user target implementations.
> 
> Now the weird design of UNMAP of course has a rather (besides some
> apparent pissing contest at NetApp about who can't come with the worst
> possible protocol specifications, whose results can be seen in NFSv4
> and iSer), and that is that it allows dicarding of multiple
> discontinguous ranges.

This sentence no object ;-)

> Doing so is really bad for the filesystem as
> it requires it to track multiple outstanding discard requests, which
> requires locking, and book keeping to make sure we do not re-use these
> blocks before they are discarded.

Yeah, but we need to do that for TRIM anyway.  While we're doing it for
TRIM, we might as well do it for UNMAP.

> And at least for my target design it does not provide any measureable
> benefits at all, the discard operations are mapped to a hole punch
> ioctl on a filesystem, which has a constant basic overhead for each
> region punched (synchronous transaction commit) and a small linear
> cost per extent removed.  The only benefit of the multiple rangs unmap
> would be a saving of protocol roundtrips.

Sure, but you've got a relatively sane underpinning.  NAND is pretty
insane, and the aggregation can actually go a long way to helping with
some of the problems.

> Now that is interestingly actually a downside at least for my still
> rather dumb target implementation with a typical Linux filesystem
> workload on the initiator side.  If we actually do a lot different unmap
> operations in a single unmap command it can start to take significant
> amounts of time, and do to Linux waiting for queue drains frequently
> due to the barrier implementations we will end up waiting for the unmap
> command.

OK, but that's because you've implemented a single-range ioctl.  If we
had an ioctl which let you discard multiple ranges, it would actually
be faster (due to the barriers) than implementing a WRITE SAME.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
