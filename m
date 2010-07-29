From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 22:11:24 +0200
Message-ID: <20100729201124.GD17767@lst.de>
References: <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <1280434037.4441.414.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1280434037.4441.414.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 29, 2010 at 03:07:17PM -0500, James Bottomley wrote:
> There's lies, damned lies and benchmarks .. but what I was thinking is
> could we just do the right thing?  SCSI exposes (in sd) the interfaces
> to change the cache setting, so if the customer *doesn't* specify
> barriers on mount, could we just flip the device to write through it
> would be more performant in most use cases.

We could for SCSI and ATA, but probably not easily for other kind of
storage.  Except that it's not that simple as we have partitions and
volume managers inbetween - different filesystems sitting on the same
device might have very different ideas of what they want.

For SCSI we can at least permanently disable the cache, but ATA devices
keep coming up again with the volatile write cache enabled after a
reboot, or even worse a suspend to ram / resume cycle.  The latter is
what keeps me from just disabling the volatile cache on my laptop,
despite that option giving significanly better performance for typical
kernel developer workloads.

