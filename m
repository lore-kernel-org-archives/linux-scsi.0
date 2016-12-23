From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Fri, 23 Dec 2016 03:33:29 -0500
Message-ID: <20161223083329.GA13952@cmpxchg.org>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <alpine.LSU.2.11.1612221204510.4476@eggly.anvils>
 <20161223073241.GA13584@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161223073241.GA13584@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 02:32:41AM -0500, Johannes Weiner wrote:
> On Thu, Dec 22, 2016 at 12:22:27PM -0800, Hugh Dickins wrote:
> > On Wed, 21 Dec 2016, Linus Torvalds wrote:
> > > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > I unmounted the fs, mkfs'd it again, ran the
> > > > workload again and about a minute in this fired:
> > > >
> > > > [628867.607417] ------------[ cut here ]------------
> > > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> > > 
> > > Well, part of the changes during the merge window were the shadow
> > > entry tracking changes that came in through Andrew's tree. Adding
> > > Johannes Weiner to the participants.
> > > 
> > > > Now, this workload does not touch the page cache at all - it's
> > > > entirely an XFS metadata workload, so it should not really be
> > > > affecting the working set code.
> > > 
> > > Well, I suspect that anything that creates memory pressure will end up
> > > triggering the working set code, so ..
> > > 
> > > That said, obviously memory corruption could be involved and result in
> > > random issues too, but I wouldn't really expect that in this code.
> > > 
> > > It would probably be really useful to get more data points - is the
> > > problem reliably in this area, or is it going to be random and all
> > > over the place.
> > 
> > Data point: kswapd got WARNING on mm/workingset.c:457 in shadow_lru_isolate,
> > soon followed by NULL pointer deref in list_lru_isolate, one time when
> > I tried out Sunday's git tree.  Not seen since, I haven't had time to
> > investigate, just set it aside as something to worry about if it happens
> > again.  But it looks like shadow_lru_isolate() has issues beyond Dave's
> > case (I've no XFS and no iscsi), suspect unrelated to his other problems.
> 
> This seems consistent with what Dave observed: we encounter regular
> pages in radix tree nodes on the shadow LRU that should only contain
> nodes full of exceptional shadow entries. It could be an issue in the
> new slot replacement code and the node tracking callback.

Both encounters seem to indicate use-after-free. Dave's node didn't
warn about an unexpected node->count / node->exceptional state, but
had entries that were inconsistent with that. Hugh got the counter
warning but crashed on a list_head that's not NULLed in a live node.

workingset_update_node() should be called on page cache radix tree
leaf nodes that go empty. I must be missing an update_node callback
where a leaf node gets freed somewhere.
