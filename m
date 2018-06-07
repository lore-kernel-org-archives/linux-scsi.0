From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fwd: [powerpc/Baremetal]Kernel OOPS while executing memory
 hotplug on Power8 baremetal
Date: Thu, 7 Jun 2018 08:45:41 -0600
Message-ID: <b1b67ad6-b300-7def-5851-b11baa6edf97@kernel.dk>
References: <ee45ead1d96ad05f77aec1d8d3e39c85@linux.vnet.ibm.com>
 <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
 <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
 <042fc8ee69b74c57815c0edfdbb253495e9d7718.camel@wdc.com>
 <e01428cf15ab45bd42a45a14424e5384@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <e01428cf15ab45bd42a45a14424e5384@linux.vnet.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: vrbagal1 <vrbagal1@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, kent.overstreet@gmail.com, snitzer@redhat.com, linux-block@vger.kernel.org
Cc: sachinp@linux.vnet.ibm.com, Linuxppc-dev <linuxppc-dev-bounces+vrbagal1=linux.vnet.ibm.com@lists.ozlabs.org>, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/7/18 4:37 AM, vrbagal1 wrote:
> On 2018-06-07 13:12, Bart Van Assche wrote:
>> On Thu, 2018-06-07 at 12:56 +0530, Venkat Rao B wrote:
>>> On Thursday 07 June 2018 12:46 PM, Bart Van Assche wrote:
>>>> On Thu, 2018-06-07 at 12:38 +0530, vrbagal1 wrote:
>>>>> Observing Kernel oops and machine reboots while executing memory hotplug
>>>>> test case, on Power8 Baremetal machine.
>>>>>
>>>>> I see this is introduced some where between rc6 and 4.17.
>>>>
>>>> Please provide the exact versions (git commit IDs) of the kernel versions
>>>> you have tested.
>>>
>>> Commit Id ---> 5037be168f
>>
>> The reason I was asking for the commit ID is because I saw that 
>> clone_endio()
>> occurs in the oops which means that the dm driver is involved. An 
>> important fix
>> for the dm driver went upstream recently, namely d37753540568 ("dm: Use 
>> kzalloc
>> for all structs with embedded biosets/mempools"). Can you double check 
>> whether
>> that commit it present in your tree? If it is not present, please 
>> update to the
>> latest master and retest. If it is present, please report how to 
>> reproduce
>> this oops to Kent Overstreet, Jens Axboe, linux-block and Mike Snitzer.
>>
>> Thanks,
>>
>> Bart.
> 
> 
> Yes, the fix is present in the tree, which I have tested.
> 
> Steps to reproduce:
> 
> Step1: Clone and Install avocado git clone 
> https://github.com/avocado-framework/avocado.git
> Step2: Clone 
> https://github.com/avocado-framework-tests/avocado-misc-tests.git
>         Test case is 
> https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/memhotplug.py
> Step3: Command to run the test is avocado run 
> avocado-misc-tests/memory/memhotplug.py

Can you try with the below? Not a fully formed fix since I'd prefer
if the dm bioset copy stuff was changed instead, but worth a shot.


diff --git a/block/bio.c b/block/bio.c
index 595663e0281a..45bdee67d28b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1967,6 +1967,27 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+void bioset_move(struct bio_set *dst, struct bio_set *src)
+{
+	dst->bio_slab = src->bio_slab;
+	dst->front_pad = src->front_pad;
+	mempool_move(&dst->bio_pool, &src->bio_pool);
+	mempool_move(&dst->bvec_pool, &src->bvec_pool);
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_move(&dst->bio_integrity_pool, &src->bio_integrity_pool);
+	mempool_move(&dst->bvec_integrity_pool, &src->bvec_integrity_pool);
+#endif
+	BUG_ON(!bio_list_empty(&src->rescue_list));
+	BUG_ON(work_pending(&src->rescue_work));
+	spin_lock_init(&dst->rescue_lock);
+	bio_list_init(&dst->rescue_list);
+	INIT_WORK(&dst->rescue_work, bio_alloc_rescue);
+	dst->rescue_workqueue = src->rescue_workqueue;
+
+	memset(src, 0, sizeof(*src));
+}
+EXPORT_SYMBOL(bioset_move);
+
 #ifdef CONFIG_BLK_CGROUP
 
 /**
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 98dff36b89a3..87f636815baf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1982,10 +1982,8 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 	       bioset_initialized(&md->bs) ||
 	       bioset_initialized(&md->io_bs));
 
-	md->bs = p->bs;
-	memset(&p->bs, 0, sizeof(p->bs));
-	md->io_bs = p->io_bs;
-	memset(&p->io_bs, 0, sizeof(p->io_bs));
+	bioset_move(&md->bs, &p->bs);
+	bioset_move(&md->io_bs, &p->io_bs);
 out:
 	/* mempool bind completed, no longer need any mempools in the table */
 	dm_table_free_md_mempools(t);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 810a8bee8f85..7581231dd0a3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -417,6 +417,7 @@ enum {
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int, int flags);
 extern void bioset_exit(struct bio_set *);
 extern int biovec_init_pool(mempool_t *pool, int pool_entries);
+extern void bioset_move(struct bio_set *dst, struct bio_set *src);
 
 extern struct bio *bio_alloc_bioset(gfp_t, unsigned int, struct bio_set *);
 extern void bio_put(struct bio *);
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 0c964ac107c2..20818919180c 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -47,6 +47,7 @@ extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
+extern void mempool_move(mempool_t *dst, mempool_t *src);
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
diff --git a/mm/mempool.c b/mm/mempool.c
index b54f2c20e5e0..dd402653367b 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -181,6 +181,8 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 		      mempool_free_t *free_fn, void *pool_data,
 		      gfp_t gfp_mask, int node_id)
 {
+	memset(pool, 0, sizeof(*pool));
+
 	spin_lock_init(&pool->lock);
 	pool->min_nr	= min_nr;
 	pool->pool_data = pool_data;
@@ -546,3 +548,19 @@ void mempool_free_pages(void *element, void *pool_data)
 	__free_pages(element, order);
 }
 EXPORT_SYMBOL(mempool_free_pages);
+
+void mempool_move(mempool_t *dst, mempool_t *src)
+{
+	BUG_ON(waitqueue_active(&src->wait));
+
+	spin_lock_init(&dst->lock);
+	dst->min_nr = src->min_nr;
+	dst->curr_nr = src->curr_nr;
+	memcpy(dst->elements, src->elements, sizeof(void *) * src->curr_nr);
+	dst->pool_data = src->pool_data;
+	dst->alloc = src->alloc;
+	dst->free = src->free;
+	init_waitqueue_head(&dst->wait);
+
+	memset(src, 0, sizeof(*src));
+}

-- 
Jens Axboe
