From: Brad Boyer <flar@allandria.com>
Subject: Re: Aggregating discard requests in the filesystem
Date: Mon, 10 Nov 2008 16:12:36 -0800
Message-ID: <20081111001236.GA14000@cynthia.pants.nu>
References: <4913028B.6010405@redhat.com> <20081110203915.GP15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081110203915.GP15439@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 10, 2008 at 01:39:15PM -0700, Matthew Wilcox wrote:
> One of the proposals in this thread (that has got buried somewhere) was
> to expand any discard request sent down from the filesystem to encompass
> all the adjacent free space.  I've checked with our SSD people and
> they're fine with this idea.
> 
> dwmw2 says "it isn't actually that hard in FAT" and then interjects some
> personal opinion about this solution ;-)
> 
> Is it hard in XFS?  btrfs?  ext2?  Does anyone have a problem with this
> as a solution?

I suspect how hard it is depends somewhat on exactly what you mean by
"all the adjacent free space" and what is expected of the file system.
My concern would particularly be around cluster file systems, which may
not have perfect local knowledge of exactly what is happening. My guess
is that it would be easy to know about some given range within some
larger aggregation of blocks, but not always across the entire device.

The other question is how this translates through software raid or
other non-simple block layers.

	Brad Boyer
	flar@allandria.com

