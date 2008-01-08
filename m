From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Tue, 8 Jan 2008 11:39:13 +1100
Message-ID: <200801081139.14748.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071538.58875.rusty@rustcorp.com.au> <1199720904.3126.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1199720904.3126.24.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 08 January 2008 02:48:23 James Bottomley wrote:
> We're always open to new APIs (or more powerful and expanded old ones).
> The way we've been doing the sg_chain conversion is to slide API layers
> into the drivers so sg_chain becomes a simple API flip when we turn it
> on.  Unfortunately sg_ring doesn't quite fit nicely into this.

Hi James,

   Well, it didn't touch any drivers.  The only ones which needed altering 
were those which wanted to use large scatter-gather lists.  You think of the 
subtlety of sg-chain conversion as a feature; it's a bug :)

> > > The other thing I note is that the problem you're claiming to solve
> > > with sg_ring (the ability to add extra scatterlists to the front or the
> > > back of an existing one) is already solved with sg_chain, so the only
> > > real advantage of sg_ring was that it contains explicit counts, which
> > > sg_table (in -mm) also introduces.
> >
> > I just converted virtio using latest Linus for fair comparison
>
> Erm, but that's not really a fair comparison; you need the sg_table code
> in
>
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>
> branch sg as well.

Actually, I think it's a wash.  Now callers need to set up an sg_table as 
well.  It will save the count_sg() calls though.

> > , and it's still
> > pretty ugly.  sg_ring needs more work to de-scsi it.  sg_table is almost
> > sg_ring except it retains all the chaining warts.
> >
> > But we hit the same problems:
> >
> > 1) sg_chain loses information.  The clever chain packaging makes reading
> > easy, but manipulation is severely limited.  You can append to your own
> > chains by padding, but not someone elses.  This works for SCSI, but what
> > about the rest of us?  And don't even think of joining mapped chains: it
> > will almost work.
>
> OK, but realistically some of your criticisms are way outside of the
> design intent.  Scatterlists (and now sg_chains) are the way the block
> subsystem hands pages to its underlying block devices.

James, scatterlists are used for more than the block subsystem.  I know you're 
designing for that, but we can do better.

    Because a single sg_ring is trivially convertable to and from a 
scatterlist *, the compatibility story is nice.  You can implement a 
subsystem (say, the block layer) with sg_ring, and still hand out struct 
scatterlist arrays for backwards compat: old code won't ask for v. long 
scatterlist arrays anyway.

    Now we have sg_chaining, we can actually convert complex sg_rings into sg 
chains when someone asks, as my most recent patch does.  I think that's one 
abstraction too many, but it provides a transition path.

> There have never until now been any requirements to join already
> dma_map_sg() converted scatterlists ... that would wreak havoc with the
> way we reuse the list plus damage the idempotence of map/unmap.  What is
> the use case you have for this?

(This was, admittedly, a made-up example).

> > 2) sg_chain's end marker is only for reading non-dma elements, not for
> > mapped chains, nor for writing into chains.  Plus it's a duplicate of the
> > num arg, which is still passed around for efficiency.  (virtio had to
> > implement count_sg() because I didn't want those two redundant num args).
> >
> > 3) By overloading struct scatterlist, it's invisible what code has been
> > converted to chains, and which hasn't.  Too clever by half!
>
> No it's not ... that's the whole point.  Code not yet converted to use
> the API accessors is by definition unable to use chaining.  Code
> converted to use the accessors by design doesn't care (and so is
> "converted to chains").

But you've overloaded the type: what's the difference between:
	/* Before conversion */
	int foo(struct scatterlist *, int);
And:
	/* After conversion */
	int foo(struct scatterlist *, int);

You have to wade through the implementation to see the difference: does this 
function take a "chained scatterlist" or an "array scatterlist"?

Then you add insult to injury by implementing sg_chain() *which doesn't handle 
chained scatterlists!*.

> > sg_ring would not have required any change to existing drivers, just
> > those that want to use long sg lists.  And then it's damn obvious which
> > are which.
>
> Which, by definition, would have been pretty much all of them.

But it would have started with none of them, and it would have been done over 
time.  Eventually we might have had a flag day to remove raw scatterlist 
arrays.

> > 4) sg_chain missed a chance to combine all the relevent information (max,
> > num, num_dma and the sg array). sg_table comes close, but you still can't
> > join them (no max information, and even if there were, what if it's
> > full?). Unlike sg_ring, it's unlikely to reduce bugs.
>
> sg_table is sg_chain ... they're incremental extensions of the same body
> of work.

Yes.

> The only such example of a driver like that I know is the
> crypto API and now your virtio.  Once we have the actual requirements
> and then the API, I think the natural data structures will probably drop
> out.

ATA wants to chain sgs (Tejun cc'd).  It hasn't been practical to chain up 
until now, but I'd say it's going to be more widely used now it is.

Basically, sg_chain solves one problem: larger sg lists for scsi.  That's 
fine, but I want to see better use of scatterlists everywhere in the kernel.

sg_chains suck for manipulation, and AFAICT that's inherent.  Here, take a 
look at the sg_ring conversion of scsi_alloc_sgtable and scsi_free_sgtable 
and you can see why I'm unhappy with the sg_chain code:

@@ -737,21 +745,41 @@ static inline unsigned int scsi_sgtable_
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static void free_sgring(struct sg_ring *head)
 {
 	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl, *prev, *ret;
+	struct sg_ring *sg, *n;
+
+	/* Free any other entries in the ring. */
+	list_for_each_entry_safe(sg, n, &head->list, list) {
+		list_del(&sg->list);
+		sgp = scsi_sg_pools + scsi_sgtable_index(sg->max);
+		mempool_free(sg, sgp->pool);
+	}
+
+	/* Now free the head of the ring. */
+	BUG_ON(!list_empty(&head->list));
+
+	sgp = scsi_sg_pools + scsi_sgtable_index(head->max);
+	mempool_free(head, sgp->pool);
+}
+
+struct sg_ring *scsi_alloc_sgring(struct scsi_cmnd *cmd, unsigned int num,
+				  gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct sg_ring *sg, *ret;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
+	BUG_ON(!num);
 
-	left = cmd->use_sg;
-	ret = prev = NULL;
+	left = num;
+	ret = NULL;
 	do {
 		this = left;
 		if (this > SCSI_MAX_SG_SEGMENTS) {
-			this = SCSI_MAX_SG_SEGMENTS - 1;
+			this = SCSI_MAX_SG_SEGMENTS;
 			index = SG_MEMPOOL_NR - 1;
 		} else
 			index = scsi_sgtable_index(this);
@@ -760,32 +788,20 @@ struct scatterlist *scsi_alloc_sgtable(s
 
 		sgp = scsi_sg_pools + index;
 
-		sgl = mempool_alloc(sgp->pool, gfp_mask);
-		if (unlikely(!sgl))
+		sg = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sg))
 			goto enomem;
 
-		sg_init_table(sgl, sgp->size);
+		sg_ring_init(sg, sgp->size - SCSI_SG_PAD);
 
 		/*
-		 * first loop through, set initial index and return value
+		 * first loop through, set return value, otherwise
+		 * attach this to the tail.
 		 */
 		if (!ret)
-			ret = sgl;
-
-		/*
-		 * chain previous sglist, if any. we know the previous
-		 * sglist must be the biggest one, or we would not have
-		 * ended up doing another loop.
-		 */
-		if (prev)
-			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
-
-		/*
-		 * if we have nothing left, mark the last segment as
-		 * end-of-list
-		 */
-		if (!left)
-			sg_mark_end(&sgl[this - 1]);
+			ret = sg;
+		else
+			list_add_tail(&sg->list, &ret->list);
 
 		/*
 		 * don't allow subsequent mempool allocs to sleep, it would
@@ -793,85 +809,21 @@ struct scatterlist *scsi_alloc_sgtable(s
 		 */
 		gfp_mask &= ~__GFP_WAIT;
 		gfp_mask |= __GFP_HIGH;
-		prev = sgl;
 	} while (left);
 
-	/*
-	 * ->use_sg may get modified after dma mapping has potentially
-	 * shrunk the number of segments, so keep a copy of it for free.
-	 */
-	cmd->__use_sg = cmd->use_sg;
 	return ret;
 enomem:
-	if (ret) {
-		/*
-		 * Free entries chained off ret. Since we were trying to
-		 * allocate another sglist, we know that all entries are of
-		 * the max size.
-		 */
-		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
-		prev = ret;
-		ret = &ret[SCSI_MAX_SG_SEGMENTS - 1];
-
-		while ((sgl = sg_chain_ptr(ret)) != NULL) {
-			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
-			mempool_free(sgl, sgp->pool);
-		}
-
-		mempool_free(prev, sgp->pool);
-	}
+	if (ret)
+		free_sgring(ret);
 	return NULL;
 }
+EXPORT_SYMBOL(scsi_alloc_sgring);
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+void scsi_free_sgring(struct scsi_cmnd *cmd)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
-	struct scsi_host_sg_pool *sgp;
-
-	/*
-	 * if this is the biggest size sglist, check if we have
-	 * chained parts we need to free
-	 */
-	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
-		unsigned short this, left;
-		struct scatterlist *next;
-		unsigned int index;
-
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
-		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
-		while (left && next) {
-			sgl = next;
-			this = left;
-			if (this > SCSI_MAX_SG_SEGMENTS) {
-				this = SCSI_MAX_SG_SEGMENTS - 1;
-				index = SG_MEMPOOL_NR - 1;
-			} else
-				index = scsi_sgtable_index(this);
-
-			left -= this;
-
-			sgp = scsi_sg_pools + index;
-
-			if (left)
-				next = sg_chain_ptr(&sgl[sgp->size - 1]);
-
-			mempool_free(sgl, sgp->pool);
-		}
-
-		/*
-		 * Restore original, will be freed below
-		 */
-		sgl = cmd->request_buffer;
-		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
-	} else
-		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
-
-	mempool_free(sgl, sgp->pool);
+	free_sgring(cmd->sg);
 }
-
-EXPORT_SYMBOL(scsi_free_sgtable);
+EXPORT_SYMBOL(scsi_free_sgring);
 
 /*
  * Function:    scsi_release_buffers()

Hope that clarifies,
Rusty.
