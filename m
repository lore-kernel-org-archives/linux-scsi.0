From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/10] idr: Rework idr_preload()
Date: Wed, 19 Jun 2013 16:46:01 -0700
Message-ID: <20130619234601.GB14881@htj.dyndns.org>
References: <20130619081832.GC30681@mtj.dyndns.org>
	<20130619233330.GA6897@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130619233330.GA6897@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: Dmitry Torokhov <dtor@vmware.com>, David Airlie <airlied@linux.ie>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, nab@linux-iscsi.org, Sean Hefty <sean.hefty@intel.com>, Michel Lespinasse <walken@google.com>, John McCutchan <john@johnmccutchan.com>, Roland Dreier <roland@kernel.org>, Thomas Hellstrom <thellstrom@vmware.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Robert Love <rlove@rlove.org>, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>, Brian Paul <brianp@vmware.com>, Doug Gilbert <dgilbert@interlog.com>, Dave Airlie <airlied@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Rik van Riel <riel@redhat.com>, Erez Shitrit <erezsh@mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2013 at 04:33:44PM -0700, Kent Overstreet wrote:
> With respect to performance, strongly disagree. Leaving pointers out of
> the interior nodes cuts our space requirements by a factor of _64_ -
> that's huge, and with data structures the dominating factors w.r.t.
> performance tend to be the amount of memory you touch and the amount of
> pointer chasing.
> 
> The lack of pointer chasing also means I could add prefetching to the
> tree walking code (child nodes are always contiguous in memory) like I
> did in bcache's binary search trees - I didn't realize DLM was using
> this for so many ids so I'll probably add that.
>
> That means for quite large bitmaps, _all_ the interior nodes will fit
> onto a couple cachelines which are all contiguous in memory. That's
> _huge_.

Do all that in the leaf node which will be able to serve most use
cases with single leaf node anyway, so you really don't lose anything.

> Even for 1 million ids - that's 128 kilobytes for all the leaf nodes,
> which means all the interior nodes take up 2 kilobytes - which again is
> contiguous so we can prefetch far in advance as we walk down the tree.

So, that's ~30k IDs per page, right?  Let the internal node have 64
fan out, then you'll only have single depth tree for 1mil.  Again,
you're not losing much, if anything, while gaining more predictable
behavior and flexibility.

> Also, idr_find() was slower than radix_tree_lookup() before, as tested
> for some aio patches - decoupling the id allocation from the radix tree
> gives the id allocator more freedom in its data structures (couldn't
> realloc before without breaking RCU lookup).

Yeah, sure.  I don't have any problem implementing idr in terms of
ida.  I do have problems with ida being one contiguous array.

> Besides all that, the ida/idr reimplementations deleted > 300 lines of
> code from idr.[ch]. If you try to add caching to the existing ida code,
> it's only going to get more complicated - and trying to maintain the
> behaviour where we always allocate the smallest available id is going to
> be fun there (the cache has to be kept in sorted order every time you
> free an id).

It's like recursive code.  It looks more elegant and looks okay for
most cases but breaks in corner cases and we end up converting it to
iterative code anyway.  Similar thing.  Long contiguous arrays just
don't work.  We're very likely to break it up eventually anyway.

> (I'm still not going to go with anything resembling a radix tree though
> - instead of having a flat array, I'll have a an array of pointers to
> fixed size array segments once the entire tree exceeds a certain size).

I don't really care how it gets split but firm nack on single
contiguous array.

> > But we allow mixing preloaded and normal allocations and users are
> > allowed to allocate as many IDs they want after preloading.  It should
> > guarantee that the first allocation after preloading follows the
> > stronger allocation flag, and the above approach can't guarantee that.
> 
> None of the existing code nedes that guarantee, though.

Hmmm?  ISTR users mixing preloaded and !preloaded allocations.  Maybe
I'm misremembering.  I don't know.  But still the API is nasty like
hell.  Nobody is gonna notice even if it's being misused.  It's just
gonna have allocation failure after preloading once in a blue moon and
we won't be able to track it down.

> That's what I documented, and I audited all the existing idr_preload()
> users (had to anyways). Generally speaking idr allocations are done from
> a central location anyways so IMO it's a pretty trivial issue in
> practice.

If that has to happen, you need to enforce it.  Trigger WARN if
somebody violates the rule, but really this is just nasty.

Thanks.

-- 
tejun
