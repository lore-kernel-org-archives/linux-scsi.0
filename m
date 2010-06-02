From: Nick Piggin <npiggin@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Wed, 2 Jun 2010 23:41:21 +1000
Message-ID: <20100602134121.GD6152@laptop>
References: <1275399637.21962.11.camel@mulgrave.site>
 <20100601134951.GM8980@think>
 <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
 <20100601193528.GV8980@think>
 <20100602032030.GF9453@laptop>
 <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 02, 2010 at 09:17:56AM -0400, Martin K. Petersen wrote:
> >>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:
> 
> >> 1) filesystem changed it
> >> 2) corruption on the wire or in the raid controller
> >> 3) the page was corrupted while the IO layer was doing the IO.
> >> 
> >> 1 and 2 are easy, we bounce, retry and everyone continues on with
> >> their lives.  With #3, we'll recrc and send the IO down again
> >> thinking the data is correct when really we're writing garbage.
> >> 
> >> How can we tell these three cases apart?
> 
> Nick> Do we really need to handle #3? It could have happened before the
> Nick> checksum was calculated.
> 
> Reason #3 is one of the main reasons for having the checksum in the
> first place.  The whole premise of the data integrity extensions is that
> the checksum is calculated in close temporal proximity to the data
> creation.  I.e. eventually in userland.
> 
> Filesystems will inevitably have to be integrity-aware for that to work.
> And it will be their job to keep the data pages stable during DMA.

Let's just think hard about what windows can actually be closed versus
how much effort goes in to closing them. I also prefer not to accept
half-solutions in the kernel because they don't want to implement real
solutions in hardware (it's pretty hard to checksum and protect all
kernel data structures by hand).

For "normal" writes into pagecache, the data can get corrupted anywhere
from after it is generated in userspace, during the copy, while it is
dirty in cache, and while it is being written out.

Closing the while it is dirty, while it is being written back window
still leaves a pretty big window. Also, how do you handle mmap writes?
Write protect and checksum the destination page after every store? Or
leave some window between when the pagecache is dirtied and when it is
written back? So I don't know whether it's worth putting a lot of effort
into this case.

If you had an interface for userspace to insert checksums to direct IO
requests or pagecache ranges, then not only can you close the entire gap
between userspace data generation, and writeback. But you also can
handle mmap writes and anything else just fine: userspace knows about
the concurrency details, so it can add the right checksum (and
potentially fsync etc) when it's ready.

And the bounce-retry method would be sufficient to handle IO
transmission errors for normal IOs without being intrusive.
