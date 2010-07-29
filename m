From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 15:07:17 -0500
Message-ID: <1280434037.4441.414.camel@mulgrave.site>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org>
	 <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org>
	 <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org>
	 <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de>
	 <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site>
	 <20100729200327.GA17767@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100729200327.GA17767@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-07-29 at 22:03 +0200, Christoph Hellwig wrote:
> On Thu, Jul 29, 2010 at 02:59:51PM -0500, James Bottomley wrote:
> > That's basically everything FUA ... you might just as well switch your
> > cache to write through and have done.
> > 
> > This, by the way, is one area I'm hoping to have researched on SCSI
> > (where most devices do obey the caching directives).  Actually see if
> > write through without flush barriers is faster than writeback with flush
> > barriers.  I really suspect it is.
> 
> We have done the research and at least for XFS a write through cache
> actually is faster for many workloads.  Ric always has workloads where
> the cache is faster, though - mostly doing lots of small file write
> kind of setups.

There's lies, damned lies and benchmarks .. but what I was thinking is
could we just do the right thing?  SCSI exposes (in sd) the interfaces
to change the cache setting, so if the customer *doesn't* specify
barriers on mount, could we just flip the device to write through it
would be more performant in most use cases.

James


