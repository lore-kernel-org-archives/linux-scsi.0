From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Mon, 2 Jan 2017 16:11:36 -0500
Message-ID: <20170102211136.GA3189@cmpxchg.org>
References: <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard>
 <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <alpine.LSU.2.11.1612221204510.4476@eggly.anvils>
 <20161223073241.GA13584@cmpxchg.org>
 <20161223083329.GA13952@cmpxchg.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD4ZBZ42QIOBBHEEVPBQKGQEAGKPIDA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20161223083329.GA13952-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 03:33:29AM -0500, Johannes Weiner wrote:
> On Fri, Dec 23, 2016 at 02:32:41AM -0500, Johannes Weiner wrote:
> > On Thu, Dec 22, 2016 at 12:22:27PM -0800, Hugh Dickins wrote:
> > > On Wed, 21 Dec 2016, Linus Torvalds wrote:
> > > > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > > > > I unmounted the fs, mkfs'd it again, ran the
> > > > > workload again and about a minute in this fired:
> > > > >
> > > > > [628867.607417] ------------[ cut here ]------------
> > > > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
> > > > 
> > > > Well, part of the changes during the merge window were the shadow
> > > > entry tracking changes that came in through Andrew's tree. Adding
> > > > Johannes Weiner to the participants.
> > > > 
> > > > > Now, this workload does not touch the page cache at all - it's
> > > > > entirely an XFS metadata workload, so it should not really be
> > > > > affecting the working set code.
> > > > 
> > > > Well, I suspect that anything that creates memory pressure will end up
> > > > triggering the working set code, so ..
> > > > 
> > > > That said, obviously memory corruption could be involved and result in
> > > > random issues too, but I wouldn't really expect that in this code.
> > > > 
> > > > It would probably be really useful to get more data points - is the
> > > > problem reliably in this area, or is it going to be random and all
> > > > over the place.
> > > 
> > > Data point: kswapd got WARNING on mm/workingset.c:457 in shadow_lru_isolate,
> > > soon followed by NULL pointer deref in list_lru_isolate, one time when
> > > I tried out Sunday's git tree.  Not seen since, I haven't had time to
> > > investigate, just set it aside as something to worry about if it happens
> > > again.  But it looks like shadow_lru_isolate() has issues beyond Dave's
> > > case (I've no XFS and no iscsi), suspect unrelated to his other problems.
> > 
> > This seems consistent with what Dave observed: we encounter regular
> > pages in radix tree nodes on the shadow LRU that should only contain
> > nodes full of exceptional shadow entries. It could be an issue in the
> > new slot replacement code and the node tracking callback.
> 
> Both encounters seem to indicate use-after-free. Dave's node didn't
> warn about an unexpected node->count / node->exceptional state, but
> had entries that were inconsistent with that. Hugh got the counter
> warning but crashed on a list_head that's not NULLed in a live node.
> 
> workingset_update_node() should be called on page cache radix tree
> leaf nodes that go empty. I must be missing an update_node callback
> where a leaf node gets freed somewhere.

Sorry for dropping silent on this. I'm traveling over the holidays
with sporadic access to my emails and no access to real equipment.

The times I managed to sneak away to look at the code didn't turn up
anything useful yet.

Andrea encountered the warning as well and I gave him a debugging
patch (attached below), but he hasn't been able to reproduce this
condition. I've personally never seen the warning trigger, even though
the patches have been running on my main development machine for quite
a while now. Albeit against an older base; I've updated to Linus's
master branch now in case it's an interaction with other new code.

If anybody manages to reproduce this, that would be helpful. Any extra
eyes on this would be much appreciated too until I'm back at my desk.

Thanks

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 6f382e07de77..0783af1c0ebb 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -640,6 +640,8 @@ static inline void radix_tree_shrink(struct radix_tree_root *root,
 				update_node(node, private);
 		}
 
+		WARN_ON_ONCE(!list_empty(&node->private_list));
+
 		radix_tree_node_free(node);
 	}
 }
@@ -666,6 +668,8 @@ static void delete_node(struct radix_tree_root *root,
 			root->rnode = NULL;
 		}
 
+		WARN_ON_ONCE(!list_empty(&node->private_list));
+
 		radix_tree_node_free(node);
 
 		node = parent;
@@ -767,6 +771,7 @@ static void radix_tree_free_nodes(struct radix_tree_node *node)
 			struct radix_tree_node *old = child;
 			offset = child->offset + 1;
 			child = child->parent;
+			WARN_ON_ONCE(!list_empty(&node->private_list));
 			radix_tree_node_free(old);
 			if (old == entry_to_node(node))
 				return;

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
