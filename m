From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/10] idr: Rework idr_preload()
Date: Wed, 19 Jun 2013 01:18:32 -0700
Message-ID: <20130619081832.GC30681@mtj.dyndns.org>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
	<1371600150-23557-11-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1371600150-23557-11-git-send-email-koverstreet@google.com>
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

Hello, Kent.

On Tue, Jun 18, 2013 at 05:02:30PM -0700, Kent Overstreet wrote:
> With the new ida implementation, that doesn't work anymore - the new ida
> code grows its bitmap tree by reallocating the entire thing in power of
> two increments. Doh.

So, I'm not sure about the single contiguous array implementation.  It
introduces some nasty characteristics such as possibly too large
contiguous allocation, bursty CPU usages, and loss of the ability to
handle ID allocations clustered in high areas - sure, the old ida
wasn't great on that part either but this can be much worse.

In addition, I'm not sure what this single contiguous allocation buys
us.  Let's say each leaf node size is 4k.  Even with in-array tree
implementation, it should be able to serve 2k IDs per-page, which
would be enough for most use cases and with a bit of caching it can
easily achieve both the performance benefits of array implementation
and the flexibility of allocating each leaf separately.  Even without
caching, the tree depth would normally be much lower than the current
implementation and the performance should be better.  If you're
bothered by having to implement another radix tree for it, it should
be possible to just implement the leaf node logic and use the existing
radix tree for internal nodes, right?

> So we need a slightly different trick. Note that if all allocations from
> an idr start by calling idr_prealloc() and disabling premption, at
> most nr_cpus() allocations can happen before someone calls
> idr_prealloc() again.

But we allow mixing preloaded and normal allocations and users are
allowed to allocate as many IDs they want after preloading.  It should
guarantee that the first allocation after preloading follows the
stronger allocation flag, and the above approach can't guarantee that.
You can declare that if preload is to work, all allocators of the ida
should preload and enforce it but that restriction arises only because
you're using this single array implementation.  It's another drawback
of this particular approach.  There seem to be a lot of cons and I
can't really see what the pros are.

Thanks.

-- 
tejun
