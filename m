From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Mon, 9 Jan 2017 15:45:30 -0500
Message-ID: <20170109204530.GA24743@cmpxchg.org>
References: <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <alpine.LSU.2.11.1612221204510.4476@eggly.anvils>
 <20161223073241.GA13584@cmpxchg.org>
 <20161223083329.GA13952@cmpxchg.org>
 <20170102211136.GA3189@cmpxchg.org>
 <20170103122825.GC3780@quack2.suse.cz>
 <20170108020200.GA16312@cmpxchg.org>
 <20170109203005.GE18524@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170109203005.GE18524@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@codemonkey.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 09, 2017 at 09:30:05PM +0100, Jan Kara wrote:
> On Sat 07-01-17 21:02:00, Johannes Weiner wrote:
> > On Tue, Jan 03, 2017 at 01:28:25PM +0100, Jan Kara wrote:
> > > On Mon 02-01-17 16:11:36, Johannes Weiner wrote:
> > > > On Fri, Dec 23, 2016 at 03:33:29AM -0500, Johannes Weiner wrote:
> > > > > On Fri, Dec 23, 2016 at 02:32:41AM -0500, Johannes Weiner wrote:
> > > > > > On Thu, Dec 22, 2016 at 12:22:27PM -0800, Hugh Dickins wrote:
> > > > > > > On Wed, 21 Dec 2016, Linus Torvalds wrote:
> > > > > > > > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > > > > > > I unmounted the fs, mkfs'd it again, ran the
> > > > > > > > > workload again and about a minute in this fired:
> > > > > > > > >
> > > > > > > > > [628867.607417] ------------[ cut here ]------------
> > > > > > > > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> > > > > > > > 
> > > > > > > > Well, part of the changes during the merge window were the shadow
> > > > > > > > entry tracking changes that came in through Andrew's tree. Adding
> > > > > > > > Johannes Weiner to the participants.
> > 
> > Okay, the below patch should address this problem. Dave Jones managed
> > to reproduce it with the added WARN_ONs, and they made it obvious. He
> > cannot trigger it anymore with this fix applied. Thanks Dave!
> 
> FWIW the patch looks good to me. I'd just note that the need to pass the
> callback to deletion function and the fact that we do it only in cases
> where we think it is needed appears errorprone. With the warning you've
> added it should at least catch the cases where we got it wrong but more
> robust would be if the radix tree root contained a pointer to the callback
> function so that we would not rely on passing the callback to every place
> which can possibly free a node. Also conceptually this would make more
> sense to me since the fact that we may need to do some cleanup on node
> deletion is a property of the particular radix tree and how we use it.
> OTOH that would mean growing radix tree root by one pointer which would be
> unpopular I guess.

The last sentence is the crux, unfortunately. The first iteration of
the shadow shrinker linked up mappings that contained shadow entries,
rather than nodes. The code would have been drastically simpler in
pretty much all regards, without changes to the radix tree API. But
Dave Chinner objected to adding a pointer to the inode when we could
stick them into empty space (slab fragmentation) inside the nodes. A
fair point, I guess, especially when you consider metadata-intense
workloads. But now we're kind of stuck with the complexity of this.
