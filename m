From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 10/10] idr: Rework idr_preload()
Date: Wed, 19 Jun 2013 16:33:44 -0700
Message-ID: <20130619233330.GA6897@localhost>
References: <20130619081832.GC30681@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130619081832.GC30681@mtj.dyndns.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dtor@vmware.com>, David Airlie <airlied@linux.ie>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, nab@linux-iscsi.org, Sean Hefty <sean.hefty@intel.com>, Michel Lespinasse <walken@google.com>, John McCutchan <john@johnmccutchan.com>, Roland Dreier <roland@kernel.org>, Thomas Hellstrom <thellstrom@vmware.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Robert Love <rlove@rlove.org>, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>, Brian Paul <brianp@vmware.com>, Doug Gilbert <dgilbert@interlog.com>, Dave Airlie <airlied@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Rik van Riel <riel@redhat.com>, Erez Shitrit <erezsh@mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2013 at 01:18:32AM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Jun 18, 2013 at 05:02:30PM -0700, Kent Overstreet wrote:
> > With the new ida implementation, that doesn't work anymore - the new ida
> > code grows its bitmap tree by reallocating the entire thing in power of
> > two increments. Doh.
> 
> So, I'm not sure about the single contiguous array implementation.  It
> introduces some nasty characteristics such as possibly too large
> contiguous allocation, bursty CPU usages, and loss of the ability to
> handle ID allocations clustered in high areas - sure, the old ida
> wasn't great on that part either but this can be much worse.
> 
> In addition, I'm not sure what this single contiguous allocation buys
> us.  Let's say each leaf node size is 4k.  Even with in-array tree
> implementation, it should be able to serve 2k IDs per-page, which
> would be enough for most use cases and with a bit of caching it can
> easily achieve both the performance benefits of array implementation
> and the flexibility of allocating each leaf separately.  Even without
> caching, the tree depth would normally be much lower than the current
> implementation and the performance should be better.  If you're
> bothered by having to implement another radix tree for it, it should
> be possible to just implement the leaf node logic and use the existing
> radix tree for internal nodes, right?

With respect to performance, strongly disagree. Leaving pointers out of
the interior nodes cuts our space requirements by a factor of _64_ -
that's huge, and with data structures the dominating factors w.r.t.
performance tend to be the amount of memory you touch and the amount of
pointer chasing.

The lack of pointer chasing also means I could add prefetching to the
tree walking code (child nodes are always contiguous in memory) like I
did in bcache's binary search trees - I didn't realize DLM was using
this for so many ids so I'll probably add that.

That means for quite large bitmaps, _all_ the interior nodes will fit
onto a couple cachelines which are all contiguous in memory. That's
_huge_.

Even for 1 million ids - that's 128 kilobytes for all the leaf nodes,
which means all the interior nodes take up 2 kilobytes - which again is
contiguous so we can prefetch far in advance as we walk down the tree.

(If I was optimizing for huge bitmaps I would've picked a bigger splay
factor and the interior nodes would take up even less memory, but I've
been assuming the common case for the bitmap size is less than a page in
which case BITS_PER_LONG should be about right).

Also, idr_find() was slower than radix_tree_lookup() before, as tested
for some aio patches - decoupling the id allocation from the radix tree
gives the id allocator more freedom in its data structures (couldn't
realloc before without breaking RCU lookup).

I'm highly skeptical the bursty CPU usage is going to be a real issue in
practice, as that can happen anywhere we do allocation - the realloc is
going to be trivial compared to what can happen then. What's important
is just the amortized cpu overhead, and in that respect doing the
realloc is definitely a performance win.

Besides all that, the ida/idr reimplementations deleted > 300 lines of
code from idr.[ch]. If you try to add caching to the existing ida code,
it's only going to get more complicated - and trying to maintain the
behaviour where we always allocate the smallest available id is going to
be fun there (the cache has to be kept in sorted order every time you
free an id).

Sparse id allocations/allocations clustered in the high areas isn't a
concern - part of the reason I separated out ida_alloc() from
ida_alloc_range() was to make sure none of the existing code was doing
anything dumb with the starting id.

The only thing that would've been a problem there was idr_alloc_cyclic()
(and the code that was open coding ida_alloc_cyclic() as a performance
hack), but the new ida_alloc_cyclic() handles that - handles it better
than the old version, too.

The only real concern I've come across is the fact that this
implementation currently can't allocate up to INT_MAX ids with the whole
allocation being contiguous - for all the uses I'd looked at I didn't
think this was going to be an issue, but turns out it probably will be
for DLM. So I've got a bit more work to do there.

(I'm still not going to go with anything resembling a radix tree though
- instead of having a flat array, I'll have a an array of pointers to
fixed size array segments once the entire tree exceeds a certain size).

> > So we need a slightly different trick. Note that if all allocations from
> > an idr start by calling idr_prealloc() and disabling premption, at
> > most nr_cpus() allocations can happen before someone calls
> > idr_prealloc() again.
> 
> But we allow mixing preloaded and normal allocations and users are
> allowed to allocate as many IDs they want after preloading.  It should
> guarantee that the first allocation after preloading follows the
> stronger allocation flag, and the above approach can't guarantee that.

None of the existing code nedes that guarantee, though.

> You can declare that if preload is to work, all allocators of the ida
> should preload and enforce it but that restriction arises only because
> you're using this single array implementation.  It's another drawback
> of this particular approach. 

That's what I documented, and I audited all the existing idr_preload()
users (had to anyways). Generally speaking idr allocations are done from
a central location anyways so IMO it's a pretty trivial issue in
practice.
