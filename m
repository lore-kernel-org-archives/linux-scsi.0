From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fwd: [powerpc/Baremetal]Kernel OOPS while executing memory
 hotplug on Power8 baremetal
Date: Thu, 7 Jun 2018 09:40:47 -0600
Message-ID: <f4a4410b-2517-9cf9-71bc-d337d04a0226@kernel.dk>
References: <ee45ead1d96ad05f77aec1d8d3e39c85@linux.vnet.ibm.com>
 <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
 <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
 <042fc8ee69b74c57815c0edfdbb253495e9d7718.camel@wdc.com>
 <e01428cf15ab45bd42a45a14424e5384@linux.vnet.ibm.com>
 <b1b67ad6-b300-7def-5851-b11baa6edf97@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <b1b67ad6-b300-7def-5851-b11baa6edf97@kernel.dk>
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

On 6/7/18 8:45 AM, Jens Axboe wrote:
> On 6/7/18 4:37 AM, vrbagal1 wrote:
>> On 2018-06-07 13:12, Bart Van Assche wrote:
>>> On Thu, 2018-06-07 at 12:56 +0530, Venkat Rao B wrote:
>>>> On Thursday 07 June 2018 12:46 PM, Bart Van Assche wrote:
>>>>> On Thu, 2018-06-07 at 12:38 +0530, vrbagal1 wrote:
>>>>>> Observing Kernel oops and machine reboots while executing memory hotplug
>>>>>> test case, on Power8 Baremetal machine.
>>>>>>
>>>>>> I see this is introduced some where between rc6 and 4.17.
>>>>>
>>>>> Please provide the exact versions (git commit IDs) of the kernel versions
>>>>> you have tested.
>>>>
>>>> Commit Id ---> 5037be168f
>>>
>>> The reason I was asking for the commit ID is because I saw that 
>>> clone_endio()
>>> occurs in the oops which means that the dm driver is involved. An 
>>> important fix
>>> for the dm driver went upstream recently, namely d37753540568 ("dm: Use 
>>> kzalloc
>>> for all structs with embedded biosets/mempools"). Can you double check 
>>> whether
>>> that commit it present in your tree? If it is not present, please 
>>> update to the
>>> latest master and retest. If it is present, please report how to 
>>> reproduce
>>> this oops to Kent Overstreet, Jens Axboe, linux-block and Mike Snitzer.
>>>
>>> Thanks,
>>>
>>> Bart.
>>
>>
>> Yes, the fix is present in the tree, which I have tested.
>>
>> Steps to reproduce:
>>
>> Step1: Clone and Install avocado git clone 
>> https://github.com/avocado-framework/avocado.git
>> Step2: Clone 
>> https://github.com/avocado-framework-tests/avocado-misc-tests.git
>>         Test case is 
>> https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/memhotplug.py
>> Step3: Command to run the test is avocado run 
>> avocado-misc-tests/memory/memhotplug.py
> 
> Can you try with the below? Not a fully formed fix since I'd prefer
> if the dm bioset copy stuff was changed instead, but worth a shot.

This is closer to an actual fix, please try that instead.


diff --git a/block/bio.c b/block/bio.c
index 595663e0281a..0616d86b15c6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1967,6 +1967,21 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+int bioset_init_from_src(struct bio_set *new, struct bio_set *src)
+{
+	unsigned int pool_size = src->bio_pool.min_nr;
+	int flags;
+
+	flags = 0;
+	if (src->bvec_pool.min_nr)
+		flags |= BIOSET_NEED_BVECS;
+	if (src->rescue_workqueue)
+		flags |= BIOSET_NEED_RESCUER;
+
+	return bioset_init(new, pool_size, src->front_pad, flags);
+}
+EXPORT_SYMBOL(bioset_init_from_src);
+
 #ifdef CONFIG_BLK_CGROUP
 
 /**
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 98dff36b89a3..20a8d63754bf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1953,9 +1953,10 @@ static void free_dev(struct mapped_device *md)
 	kvfree(md);
 }
 
-static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
+static int __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
+	int ret = 0;
 
 	if (dm_table_bio_based(t)) {
 		/*
@@ -1982,13 +1983,16 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 	       bioset_initialized(&md->bs) ||
 	       bioset_initialized(&md->io_bs));
 
-	md->bs = p->bs;
-	memset(&p->bs, 0, sizeof(p->bs));
-	md->io_bs = p->io_bs;
-	memset(&p->io_bs, 0, sizeof(p->io_bs));
+	ret = bioset_init_from_src(&md->bs, &p->bs);
+	if (ret)
+		goto out;
+	ret = bioset_init_from_src(&md->io_bs, &p->io_bs);
+	if (ret)
+		bioset_exit(&md->bs);
 out:
 	/* mempool bind completed, no longer need any mempools in the table */
 	dm_table_free_md_mempools(t);
+	return ret;
 }
 
 /*
@@ -2033,6 +2037,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	struct request_queue *q = md->queue;
 	bool request_based = dm_table_request_based(t);
 	sector_t size;
+	int ret;
 
 	lockdep_assert_held(&md->suspend_lock);
 
@@ -2068,7 +2073,11 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		md->immutable_target = dm_table_get_immutable_target(t);
 	}
 
-	__bind_mempools(md, t);
+	ret = __bind_mempools(md, t);
+	if (ret) {
+		old_map = ERR_PTR(ret);
+		goto out;
+	}
 
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
@@ -2078,6 +2087,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (old_map)
 		dm_sync_table(md);
 
+out:
 	return old_map;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 810a8bee8f85..307682ac2f31 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -417,6 +417,7 @@ enum {
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int, int flags);
 extern void bioset_exit(struct bio_set *);
 extern int biovec_init_pool(mempool_t *pool, int pool_entries);
+extern int bioset_init_from_src(struct bio_set *new, struct bio_set *src);
 
 extern struct bio *bio_alloc_bioset(gfp_t, unsigned int, struct bio_set *);
 extern void bio_put(struct bio *);

-- 
Jens Axboe
