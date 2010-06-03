From: Nick Piggin <npiggin@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Fri, 4 Jun 2010 02:27:18 +1000
Message-ID: <20100603162718.GR6822@laptop>
References: <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
 <20100601193528.GV8980@think>
 <20100602032030.GF9453@laptop>
 <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
 <20100602134121.GD6152@laptop>
 <20100603154634.GC8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab0FCQ1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 12:27:23 -0400
Content-Disposition: inline
In-Reply-To: <20100603154634.GC8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof

On Thu, Jun 03, 2010 at 11:46:34AM -0400, Chris Mason wrote:
> On Wed, Jun 02, 2010 at 11:41:21PM +1000, Nick Piggin wrote:
> > On Wed, Jun 02, 2010 at 09:17:56AM -0400, Martin K. Petersen wrote:
> > > >>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:
> > > 
> > > >> 1) filesystem changed it
> > > >> 2) corruption on the wire or in the raid controller
> > > >> 3) the page was corrupted while the IO layer was doing the IO.
> > > >> 
> > > >> 1 and 2 are easy, we bounce, retry and everyone continues on with
> > > >> their lives.  With #3, we'll recrc and send the IO down again
> > > >> thinking the data is correct when really we're writing garbage.
> > > >> 
> > > >> How can we tell these three cases apart?
> > > 
> > > Nick> Do we really need to handle #3? It could have happened before the
> > > Nick> checksum was calculated.
> > > 
> > > Reason #3 is one of the main reasons for having the checksum in the
> > > first place.  The whole premise of the data integrity extensions is that
> > > the checksum is calculated in close temporal proximity to the data
> > > creation.  I.e. eventually in userland.
> > > 
> > > Filesystems will inevitably have to be integrity-aware for that to work.
> > > And it will be their job to keep the data pages stable during DMA.
> > 
> > Let's just think hard about what windows can actually be closed versus
> > how much effort goes in to closing them. I also prefer not to accept
> > half-solutions in the kernel because they don't want to implement real
> > solutions in hardware (it's pretty hard to checksum and protect all
> > kernel data structures by hand).
> > 
> > For "normal" writes into pagecache, the data can get corrupted anywhere
> > from after it is generated in userspace, during the copy, while it is
> > dirty in cache, and while it is being written out.
> 
> This is why the DIF/DIX spec has the idea of a crc generated in userland
> when the data is generated.  At any rate the basic idea is to crc early
> but not often...recalculating the crc after we hand our precious memory
> to the evil device driver does weaken the end-to-end integrity checks.
> 
> What I don't want to do is weaken the basic DIF/DIX structure by letting
> the lower recrc stuff as they find faults.  It would be fine if we had
> some definitive way to say: the FS raced, just recrc, but we really
> don't.

That's true but a naive kernel crc cannot do better than the
user/kernel boundary (and has very big problems even doing that well
with mmap, get_user_pages, concurrent dirtying). So we are already
resigned there to a best effort approach.

Since we fundamentally can't have end-to-end protection then, it's
much harder to argue for significant complexity just to close the
hole a little.

So if we do the block layer retries in response to concurrent writes, it
opens the window there a little bit, but remember only a small
proportion of writes will require retries, and for that proportion, the
window is only opening a small amount.

As far as I know, we're not checksumming at the usercopy point, but the
writeback point, so we have a vastly bigger window there already.


> > Closing the while it is dirty, while it is being written back window
> > still leaves a pretty big window. Also, how do you handle mmap writes?
> > Write protect and checksum the destination page after every store? Or
> > leave some window between when the pagecache is dirtied and when it is
> > written back? So I don't know whether it's worth putting a lot of effort
> > into this case.
> 
> So, changing gears to how do we protect filesystem page cache pages
> instead of the generic idea of dif/dix, btrfs crcs just before writing,
> which does leave a pretty big window for the page to get corrupted.
> The storage layer shouldn't care or know about that though, we hand it a
> crc and it makes sure data matching that crc goes to the media.

I'm not totally against freezing redirtying events during writeback,
but as long as there is a huge window of the page sitting dirty in
pagecache, it's not worth much if any complexity.

Also I don't think we can deal with memory errors and scribbles just by
crcing dirty data. The calculations generating the data could get
corrupted. Data can be corrupted on its way back from the device to
userspace. Dirty memory writeback is usually only a small part of the
entire data transformation process.


> > If you had an interface for userspace to insert checksums to direct IO
> > requests or pagecache ranges, then not only can you close the entire gap
> > between userspace data generation, and writeback. But you also can
> > handle mmap writes and anything else just fine: userspace knows about
> > the concurrency details, so it can add the right checksum (and
> > potentially fsync etc) when it's ready.
> 
> Yeah, I do agree here.

After protecting writeback from IO bus and wire errors, I think this
would be the most productive thing to work on. Obviously this feature is
being pushed by databases and such that really want to pass checksums
all the way from userspace. Block retrying is _not_ needed or wanted
here of course.

After that is done, it might be worth coming back to see if
regular pagecache can be protected any better. I just think that's
the highest hanging fruit at the moment.

