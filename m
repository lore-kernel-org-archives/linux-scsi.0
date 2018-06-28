From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Oops in kmem_cache_free() via bioset_exit() (was Re:
 [next-20180601][nvme][ppc] Kernel Oops is triggered when creating lvm
 snapshots on nvme disks)
Date: Thu, 28 Jun 2018 13:57:55 -0600
Message-ID: <32e06233-3e58-10af-40d9-a22d9e5c4e96@kernel.dk>
References: <1530003645.24245.7.camel@abdul.in.ibm.com>
 <87d0wd7jph.fsf@concordia.ellerman.id.au>
 <1530176707.24245.12.camel@abdul.in.ibm.com>
 <87a7rf55vy.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a7rf55vy.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, sachinp <sachinp@linux.vnet.ibm.com>, sim <sim@linux.vnet.ibm.com>, manvanth <manvanth@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 6/28/18 8:42 AM, Michael Ellerman wrote:
> Kent, Jens,
> 
> This looks like it might be related to the recent bioset changes?
> 
> cheers
> 
> Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
>> On Tue, 2018-06-26 at 23:36 +1000, Michael Ellerman wrote:
>>> Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
> ...
>> I was able to reproduce again with slub_debug=FZP and DEBUG_INFO enabled
>> on 4.17.0-rc7-next-20180601, but not much traces other than the Oops stack trace
> 
> Are you still testing on that revision? It's nearly a month old.
> 
> Please try to reproduce on mainline or today's linux-next.
> 
> 
>> the faulty instruction points to below code path :
>>
>> gdb -batch vmlinux -ex 'list *(0xc000000000304fe0)'
>> 0xc000000000304fe0 is in kmem_cache_free (mm/slab.h:231).
>> 226	}
>> 227	
>> 228	static inline bool slab_equal_or_root(struct kmem_cache *s,
>> 229					      struct kmem_cache *p)
>> 230	{
>> 231		return p == s || p == s->memcg_params.root_cache;
>> 232	}
> 
> And s is NULL.
> 
> Called via:
>   kmem_cache_free+0x210/0x2a0
>   mempool_free_slab+0x24/0x40
>   mempool_exit+0x50/0x90
>   bioset_exit+0x40/0x1d0
>   dm_io_client_destroy+0x2c/0x50
>   dm_bufio_client_destroy+0x1fc/0x2d0 [dm_bufio]
>   persistent_read_metadata+0x430/0x660 [dm_snapshot]
>   snapshot_ctr+0x5c8/0x7a0 [dm_snapshot]
>   dm_table_add_target+0x19c/0x3c0
>   table_load+0x104/0x450
>   ctl_ioctl+0x1f8/0x570
>   dm_ctl_ioctl+0x18/0x30
>   do_vfs_ioctl+0xcc/0x9e0
>   ksys_ioctl+0x5c/0xe0
>   sys_ioctl+0x20/0x80
>   system_call+0x58/0x6c
> 
> So looks like we did:
> 
>   kmem_cache_free(NULL
> 
> Probably a bad error path that frees before the cache has been allocated.
> 
> mempool_init_node() calls mempool_exit() on a partially initialised
> mempool, which looks fishy, though you're not hitting that patch AFAICS.

The slab cache is setup elsewhere, it's pending_cache. So if pending_cache
is NULL, then yeah and exit there will barf. I'd try something like the
below, but from the trace, we already basically see the path.


diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 0c964ac107c2..ebfa2f89ffdd 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -59,6 +59,7 @@ void mempool_free_slab(void *element, void *pool_data);
 static inline int
 mempool_init_slab_pool(mempool_t *pool, int min_nr, struct kmem_cache *kc)
 {
+	BUG_ON(!kc);
 	return mempool_init(pool, min_nr, mempool_alloc_slab,
 			    mempool_free_slab, (void *) kc);
 }
diff --git a/mm/mempool.c b/mm/mempool.c
index b54f2c20e5e0..060f44acd0df 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -508,7 +508,9 @@ EXPORT_SYMBOL(mempool_alloc_slab);
 void mempool_free_slab(void *element, void *pool_data)
 {
 	struct kmem_cache *mem = pool_data;
-	kmem_cache_free(mem, element);
+
+	if (!WARN_ON(!mem))
+		kmem_cache_free(mem, element);
 }
 EXPORT_SYMBOL(mempool_free_slab);
 

-- 
Jens Axboe
