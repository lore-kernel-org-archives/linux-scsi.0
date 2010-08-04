From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 4 Aug 2010 02:58:13 +0100
Message-ID: <20100804015813.GR27827@shareable.org>
References: <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <1280434037.4441.414.camel@mulgrave.site> <20100729201124.GD17767@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:46046 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab0HDB6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2010 21:58:35 -0400
Content-Disposition: inline
In-Reply-To: <20100729201124.GD17767@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig wrote:
> On Thu, Jul 29, 2010 at 03:07:17PM -0500, James Bottomley wrote:
> > There's lies, damned lies and benchmarks .. but what I was thinking is
> > could we just do the right thing?  SCSI exposes (in sd) the interfaces
> > to change the cache setting, so if the customer *doesn't* specify
> > barriers on mount, could we just flip the device to write through it
> > would be more performant in most use cases.
> 
> We could for SCSI and ATA, but probably not easily for other kind of
> storage.  Except that it's not that simple as we have partitions and
> volume managers inbetween - different filesystems sitting on the same
> device might have very different ideas of what they want.
> 
> For SCSI we can at least permanently disable the cache, but ATA devices
> keep coming up again with the volatile write cache enabled after a
> reboot, or even worse a suspend to ram / resume cycle.  The latter is
> what keeps me from just disabling the volatile cache on my laptop,
> despite that option giving significanly better performance for typical
> kernel developer workloads.

I have workloads where enabling volatile write cache + barriers is much
faster than disabling the cache.

It is admittedly a 2.4.ancient kernel and PATA on an embedded system,
but still, it's enough of a difference (about 3x speedup for large
file writes) that it was worth porting SuSE's barrier patches to that
kernel so that I could enable the write cache to get a huge speedup
while remaining powerfail safe with ext3.

-- Jamie
