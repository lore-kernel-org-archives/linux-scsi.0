From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] Added flush_disk to factor out common buffer cache
	flushing code.
Date: Wed, 07 May 2008 12:59:01 -0500
Message-ID: <1210183141.3067.13.camel@localhost.localdomain>
References: <20080505230414.12905.15331.stgit@bluto.andrew>
	 <20080505230419.12905.36939.stgit@bluto.andrew>
	 <20080506084411.GA31380@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45102 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbYEGR7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 13:59:09 -0400
In-Reply-To: <20080506084411.GA31380@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com

On Tue, 2008-05-06 at 04:44 -0400, Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 05:04:19PM -0600, Andrew Patterson wrote:
> > Added flush_disk to factor out common buffer cache flushing code.
> > 
> > We need to be able to flush the buffer cache for more than just when a
> > disk is changed, so we factor out common cache flush code in
> > check_disk_change() to an internal flush_disk() routine.  This routine
> > will then be used for both disk changes and disk resizes (in a later
> > patch).
> > 
> > Include the disk name in the text indicating that there are busy
> > inodes on the device and increase the KERN severity of the message.
> 
> This doesn't make much sense to me.  When a disk has grown there's no
> point in invalidating any buffers, and when it has shrunk it's too late
> already.  Also I suspect modern filesystems might be really allergic to
> this kind of under the hood actions.  That is if they use the bdev
> mapping at all, something that at least xfs and I think btrfs aswell
> don't do at all.

I agree on the grown disc case.  For the shrunk disk, we need at least
to invalidate the sectors that no-longer physically exist.

The two use cases for shrinking I can see are

     1. planned: the fs is already shrunk to within the new boundaries
        and all data is relocated, so invalidate is fine (any dirty
        buffers that might exist in the shrunk region are there only
        because they were relocated but not yet written to their
        original location).
     2. unplanned:  In this case, the fs is probably toast, so whether
        we invalidate or not isn't going to make a whole lot of
        difference; it's still going to try to read or write from
        sectors beyond the new size and get I/O errors.

Unfortunately, we don't seem to have a partial invalidation function for
the page cache and filesystem, so should we have one?

James


