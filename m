From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Wed, 23 Jul 2014 23:07:37 +0530
Message-ID: <CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18unklvda.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

Following are the changes that I have done in this patch over the
first RDPQ support patch,

1. As per your suggestion reduced the redundancy in the function
_base_release_memory_pools(), _base_allocate_memory_pools().
2. As per MPI Spec, each set of 8 reply descriptor post queues must
have the same value for the upper 32-bits of their memory address. So
allocated set of eight queues in a single pool and added a new
function is_MSB_are_same() to check whether higher 32 bits of this
pool memory address are same or not. If this functions returns zero
then we are saving these pools in the bad_reply_post_pool list. then
releasing these pools once we get the required memory pools.

Still some unit testing is needed for this patch. So I will post this
patch once again tomorrow.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f5b8583..a319bd0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2681,6 +2681,34 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 }

 /**
+ * release_bad_memory_pools - release bad reply post queue pools
+ * @ioc: per adapter object
+ *
+ * Free bad reply post queue pools.
+ *
+ * Return nothing.
+ */
+void
+release_bad_memory_pools(struct MPT2SAS_ADAPTER *ioc)
+{
+    struct bad_reply_post_pools *bad_reply_post_pool, *next;
+
+    list_for_each_entry_safe(bad_reply_post_pool, next,
+         &ioc->bad_reply_post_pool_list, list) {
+        pci_pool_free(ioc->reply_post_free_dma_pool,
+                  bad_reply_post_pool->reply_post_free,
+                  bad_reply_post_pool->reply_post_free_dma);
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "bad reply post free pool (0x%p): free\n",
+            ioc->name, bad_reply_post_pool->reply_post_free));
+        bad_reply_post_pool->reply_post_free = NULL;
+
+        list_del(&bad_reply_post_pool->list);
+        kfree(bad_reply_post_pool);
+    }
+}
+
+/**
  * _base_release_memory_pools - release memory
  * @ioc: per adapter object
  *
@@ -2692,6 +2720,7 @@ static void
 _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 {
     int i;
+    struct reply_post_struct *rps;

     dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -2733,18 +2762,24 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
     }

     if (ioc->reply_post) {
-        for (i = 0; i < ioc->reply_queue_count; i++) {
-            struct reply_post_struct *rps = &ioc->reply_post[i];
-            if (rps->reply_post_free) {
-                pci_pool_free(
-                    ioc->reply_post_free_dma_pool,
-                    rps->reply_post_free,
-                    rps->reply_post_free_dma);
-                dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
-                   "reply_post_free_pool(0x%p): free\n",
-                    ioc->name, rps->reply_post_free));
-                rps->reply_post_free = NULL;
-            }
+        i=0;
+        do {
+            if (i%8 == 0) {
+                rps = &ioc->reply_post[i];
+                if (rps->reply_post_free) {
+                    pci_pool_free(
+                        ioc->reply_post_free_dma_pool,
+                        rps->reply_post_free, rps->reply_post_free_dma);
+                    dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
+                       "reply_post_free_pool(0x%p): free\n",
+                        ioc->name,rps->reply_post_free));
+                    rps->reply_post_free = NULL;
+                }
+            } else
+                ioc->reply_post[i].reply_post_free = NULL;
+            i++;
+        } while (ioc->rdpq_array_enable && i < ioc->reply_queue_count);
+
         if (ioc->reply_post_free_dma_pool)
             pci_pool_destroy(ioc->reply_post_free_dma_pool);
         kfree(ioc->reply_post);
@@ -2778,6 +2813,30 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
     }
 }

+/*
+ * is_MSB_are_same - checks whether all reply queues in a set are
+ *                   having same upper 32bits in their base memory address.
+ * @reply_pool_start_address: Base address of a reply queue set
+ * @pool_sz: Size of single Reply Descriptor Post Queues pool size
+ *
+ * Returns 1 if reply queues in a set have a same upper 32bits in
their base memory address,
+ * else 0
+ */
+
+static int
+is_MSB_are_same(long reply_pool_start_address, u32 pool_sz)
+{
+        long reply_pool_end_address;
+        unsigned long bit_divisor_16 = 0x10000;
+
+        reply_pool_end_address = reply_pool_start_address + pool_sz;
+
+        if (((reply_pool_start_address / bit_divisor_16) / (bit_divisor_16)) ==
+                ((reply_pool_end_address / bit_divisor_16) / bit_divisor_16))
+                return 1;
+        else
+                return 0;
+}

 /**
  * _base_allocate_memory_pools - allocate start of day memory pools
@@ -2796,6 +2855,7 @@ _base_allocate_memory_pools(struct
MPT2SAS_ADAPTER *ioc,  int sleep_flag)
     u32 retry_sz;
     u16 max_request_credit;
     int i;
+    struct bad_reply_post_pools *bad_reply_post_pool;

     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -3101,84 +3161,88 @@ chain_done:
         "(0x%llx)\n", ioc->name, (unsigned long long)ioc->reply_free_dma));
     total_sz += sz;

+    reply_post_free_sz = ioc->reply_post_queue_depth *
+        sizeof(Mpi2DefaultReplyDescriptor_t);
     if (ioc->rdpq_array_enable) {
-        ioc->reply_post = kcalloc(ioc->reply_queue_count,
-            sizeof(struct reply_post_struct), GFP_KERNEL);
-        /* reply post queue, 16 byte align */
-        reply_post_free_sz = ioc->reply_post_queue_depth *
-            sizeof(Mpi2DefaultReplyDescriptor_t);
-        sz = reply_post_free_sz;
-        ioc->reply_post_free_dma_pool =
-            pci_pool_create("reply_post_free pool", ioc->pdev, sz,
-            16, 2147483648);
-        if (!ioc->reply_post_free_dma_pool) {
-            printk(MPT2SAS_ERR_FMT
-             "reply_post_free pool: pci_pool_create failed\n",
-             ioc->name);
-            goto out;
-        }
-        for (i = 0; i < ioc->reply_queue_count; i++) {
+        sz = reply_post_free_sz * 8;
+        INIT_LIST_HEAD(&ioc->bad_reply_post_pool_list);
+    } else
+        sz = reply_post_free_sz * ioc->reply_queue_count;
+
+    ioc->reply_post = kcalloc((ioc->rdpq_array_enable)?
+        (ioc->reply_queue_count/8):1,
+        sizeof(struct reply_post_struct), GFP_KERNEL);
+
+    if (!ioc->reply_post) {
+        printk(MPT2SAS_ERR_FMT "reply_post_free pool: kcalloc failed\n",
+            ioc->name);
+        goto out;
+    }
+
+    ioc->reply_post_free_dma_pool =
+        pci_pool_create("reply_post_free pool", ioc->pdev, sz,
+            16, 0);
+    if (!ioc->reply_post_free_dma_pool) {
+        printk(MPT2SAS_ERR_FMT
+         "reply_post_free pool: pci_pool_create failed\n",
+         ioc->name);
+        goto out;
+    }
+
+    i = 0;
+    do {
+        if (i%8 == 0) {
             ioc->reply_post[i].reply_post_free =
                 pci_pool_alloc(ioc->reply_post_free_dma_pool,
                 GFP_KERNEL,
                 &ioc->reply_post[i].reply_post_free_dma);
             if (!ioc->reply_post[i].reply_post_free) {
                 printk(MPT2SAS_ERR_FMT
-                "reply_post_free pool: pci_pool_alloc failed\n"
-                , ioc->name);
+                "reply_post_free pool: pci_pool_alloc failed\n",
+                ioc->name);
+                release_bad_memory_pools(ioc);
                 goto out;
             }
+            if (ioc->rdpq_array_enable && !is_MSB_are_same(
+                 (long)ioc->reply_post[i].reply_post_free, sz)) {
+                bad_reply_post_pool = kzalloc(
+                    sizeof(struct bad_reply_post_pools),
+                    GFP_KERNEL);
+                bad_reply_post_pool->reply_post_free =
+                    ioc->reply_post[i].reply_post_free;
+                bad_reply_post_pool->reply_post_free_dma =
+                     ioc->reply_post[i].reply_post_free_dma;
+                list_add_tail(&bad_reply_post_pool->list,
+                    &ioc->bad_reply_post_pool_list);
+                ioc->reply_post[i].reply_post_free = NULL;
+                ioc->reply_post[i].reply_post_free_dma = 0;
+                continue;
+            }
             memset(ioc->reply_post[i].reply_post_free, 0, sz);
-            dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
-                "reply post free pool (0x%p): depth(%d),"
-                "element_size(%d), pool_size(%d kB)\n", ioc->name,
-                ioc->reply_post[i].reply_post_free,
-                ioc->reply_post_queue_depth, 8, sz/1024));
-            dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
-                "reply_post_free_dma = (0x%llx)\n", ioc->name,
-                (unsigned long long)
-                ioc->reply_post[i].reply_post_free_dma));
-            total_sz += sz;
-        }
-    } else {
-        ioc->reply_post = kzalloc(sizeof(struct reply_post_struct),
-            GFP_KERNEL);
-        /* reply post queue, 16 byte align */
-        reply_post_free_sz = ioc->reply_post_queue_depth *
-            sizeof(Mpi2DefaultReplyDescriptor_t);
-        if (_base_is_controller_msix_enabled(ioc))
-            sz = reply_post_free_sz * ioc->reply_queue_count;
-        else
-            sz = reply_post_free_sz;
-        ioc->reply_post_free_dma_pool =
-            pci_pool_create("reply_post_free pool",
-            ioc->pdev, sz, 16, 0);
-        if (!ioc->reply_post_free_dma_pool) {
-            printk(MPT2SAS_ERR_FMT
-                "reply_post_free pool: pci_pool_create failed\n",
-                ioc->name);
-            goto out;
-        }
-        ioc->reply_post[0].reply_post_free =
-            pci_pool_alloc(ioc->reply_post_free_dma_pool,
-            GFP_KERNEL, &ioc->reply_post[0].reply_post_free_dma);
-        if (!ioc->reply_post[0].reply_post_free) {
-            printk(MPT2SAS_ERR_FMT
-                "reply_post_free pool: pci_pool_alloc failed\n",
-                ioc->name);
-            goto out;
+        } else {
+            ioc->reply_post[i].reply_post_free =
+              (Mpi2ReplyDescriptorsUnion_t *)
+              ((long)ioc->reply_post[i-1].reply_post_free +
+              reply_post_free_sz);
+            ioc->reply_post[i].reply_post_free_dma = (dma_addr_t)
+              (ioc->reply_post[i-1].reply_post_free_dma +
+              reply_post_free_sz);
         }
-        memset(ioc->reply_post[0].reply_post_free, 0, sz);
-        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply post free pool"
-            "(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
-            ioc->name, ioc->reply_post[0].reply_post_free,
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "reply post free pool (0x%p): depth(%d),"
+            "element_size(%d), pool_size(%d kB)\n", ioc->name,
+            ioc->reply_post[i].reply_post_free,
             ioc->reply_post_queue_depth, 8, sz/1024));
         dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
             "reply_post_free_dma = (0x%llx)\n", ioc->name,
             (unsigned long long)
-            ioc->reply_post[0].reply_post_free_dma));
-        total_sz += sz;
-    }
+            ioc->reply_post[i].reply_post_free_dma));
+        i++;
+    } while (ioc->rdpq_array_enable && i < ioc->reply_queue_count);
+
+    release_bad_memory_pools(ioc);
+    total_sz += ioc->reply_post_queue_depth *
+        sizeof(Mpi2DefaultReplyDescriptor_t) * ioc->reply_queue_count;

     ioc->config_page_sz = 512;
     ioc->config_page = pci_alloc_consistent(ioc->pdev,
@@ -3570,10 +3634,9 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
     int i, r = 0;
     struct timeval current_time;
     u16 ioc_status;
-    u32 reply_post_free_array_sz;
+    u32 reply_post_free_array_sz = 0;
     Mpi2IOCInitRDPQArrayEntry *reply_post_free_array = NULL;
     dma_addr_t reply_post_free_array_dma;
-    struct dma_pool *reply_post_free_array_dma_pool = NULL;

     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -3605,23 +3668,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
     if (ioc->rdpq_array_enable) {
         reply_post_free_array_sz = ioc->reply_queue_count *
             sizeof(Mpi2IOCInitRDPQArrayEntry);
-        reply_post_free_array_dma_pool =
-            pci_pool_create("reply_post_free_array pool",
-            ioc->pdev, reply_post_free_array_sz, 16, 0);
-        if (!reply_post_free_array_dma_pool) {
-            printk(MPT2SAS_ERR_FMT
-            "reply_post_free_array pool: pci_pool_create failed\n",
-            ioc->name);
-            r = -ENOMEM;
-            goto out;
-        }
-        reply_post_free_array =
-            pci_pool_alloc(reply_post_free_array_dma_pool,
-            GFP_KERNEL, &reply_post_free_array_dma);
+        reply_post_free_array = pci_alloc_consistent(ioc->pdev,
+            reply_post_free_array_sz, &reply_post_free_array_dma);
         if (!reply_post_free_array) {
             printk(MPT2SAS_ERR_FMT
-             "reply_post_free_array pool: pci_pool_alloc failed\n",
-             ioc->name);
+            "reply_post_free_array: pci_alloc_consistent failed\n",
+            ioc->name);
             r = -ENOMEM;
             goto out;
         }
@@ -3675,15 +3727,10 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
     }

  out:
-    if (ioc->rdpq_array_enable) {
-        if (reply_post_free_array) {
-            pci_pool_free(reply_post_free_array_dma_pool,
-                reply_post_free_array, reply_post_free_array_dma);
-            reply_post_free_array = NULL;
-        }
-        if (reply_post_free_array_dma_pool)
-            pci_pool_destroy(reply_post_free_array_dma_pool);
-    }
+    if (reply_post_free_array)
+        pci_free_consistent(ioc->pdev, reply_post_free_array_sz,
+                    reply_post_free_array,
+                    reply_post_free_array_dma);
     return r;
 }

@@ -4209,15 +4256,15 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag,
 static int
 _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
-    int r, i, j = 0;
+    int r, i;
     unsigned long    flags;
     u32 reply_address;
     u16 smid;
     struct _tr_list *delayed_tr, *delayed_tr_next;
     u8 hide_flag;
     struct adapter_reply_queue *reply_q;
-    long reply_post_free;
-    u32 reply_post_free_sz;
+    Mpi2ReplyDescriptorsUnion_t *reply_post_free = NULL;
+    unsigned int reply_post_free_sz, index = 0;

     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -4288,32 +4335,23 @@ _base_make_ioc_operational(struct
MPT2SAS_ADAPTER *ioc, int sleep_flag)
         _base_assign_reply_queues(ioc);

     /* initialize Reply Post Free Queue */
-    if (ioc->rdpq_array_enable) {
-        list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-            reply_q->reply_post_host_index = 0;
-            reply_q->reply_post_free =
-                ioc->reply_post[j++].reply_post_free;
-            for (i = 0; i < ioc->reply_post_queue_depth; i++)
-                reply_q->reply_post_free[i].Words =
-                    cpu_to_le64(ULLONG_MAX);
-            if (!_base_is_controller_msix_enabled(ioc))
-                goto skip_init_reply_post_free_queue;
-        }
-    } else {
-        reply_post_free = (long)ioc->reply_post[0].reply_post_free;
-        reply_post_free_sz = ioc->reply_post_queue_depth *
-            sizeof(Mpi2DefaultReplyDescriptor_t);
-        list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-            reply_q->reply_post_host_index = 0;
-            reply_q->reply_post_free =
-                (Mpi2ReplyDescriptorsUnion_t *)reply_post_free;
-            for (i = 0; i < ioc->reply_post_queue_depth; i++)
-                reply_q->reply_post_free[i].Words =
-                    cpu_to_le64(ULLONG_MAX);
-            if (!_base_is_controller_msix_enabled(ioc))
-                goto skip_init_reply_post_free_queue;
+    reply_post_free_sz = ioc->reply_post_queue_depth *
+                sizeof(Mpi2DefaultReplyDescriptor_t);
+    list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+        reply_post_free = ioc->reply_post[index].reply_post_free;
+        reply_q->reply_post_free = reply_post_free;
+        reply_q->reply_post_host_index = 0;
+        memset(reply_post_free, 0xff, reply_post_free_sz);
+        if (!_base_is_controller_msix_enabled(ioc))
+            goto skip_init_reply_post_free_queue;
+        /*
+         * If RDPQ is enabled, switch to the next allocation.
+         * Otherwise advance within the contiguous region.
+         */
+        if (ioc->rdpq_array_enable)
+            index++;
+        else
             reply_post_free += reply_post_free_sz;
-        }
     }
  skip_init_reply_post_free_queue:

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
b/drivers/scsi/mpt2sas/mpt2sas_base.h
index ec15e0e..8b9a50d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -642,6 +642,20 @@ struct reply_post_struct {
 };

 /**
+ * struct bad_reply_post_pools - per bad reply post pool which doesn't
+ *             satisfy MPI SPEC rule of having same upper 32bits
+ *             of memory address in a set of 8 reply queues
+ * @reply_post_free: virtual address of reply post pool
+ * @reply_post_free_dma: Physical address of reply post pool
+ * @list: Bad reply post pool list
+ */
+struct bad_reply_post_pools {
+    Mpi2ReplyDescriptorsUnion_t     *reply_post_free;
+    dma_addr_t                      reply_post_free_dma;
+    struct list_head         list;
+};
+
+/**
  * enum mutex_type - task management mutex type
  * @TM_MUTEX_OFF: mutex is not required becuase calling function is
acquiring it
  * @TM_MUTEX_ON: mutex is required
@@ -785,6 +799,7 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct
MPT2SAS_ADAPTER *ioc);
  * @reply_free_host_index: tail index in pool to insert free replys
  * @reply_post_queue_depth: reply post queue depth
  * @reply_post_struct: struct for reply_post_free physical & virt address
+ * @bad_reply_post_pool_list: list of bad reply post queue pools
  * @rdpq_array_capable: FW supports multiple reply queue addresses in ioc_init
  * @rdpq_array_enable: rdpq_array support is enabled in the driver
  * @rdpq_array_enable_assigned: this ensures that rdpq_array_enable flag
@@ -981,6 +996,7 @@ struct MPT2SAS_ADAPTER {
     /* reply post queue */
     u16         reply_post_queue_depth;
     struct reply_post_struct *reply_post;
+    struct list_head bad_reply_post_pool_list;
     struct dma_pool *reply_post_free_dma_pool;
     u8        reply_queue_count;
     struct list_head reply_queue_list;

On Wed, Jul 23, 2014 at 6:55 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth,
>
>>> Why do you need to special case !rdpq? Isn't reply_queue_count = 1 in
>>> that case?
>
> Sreekanth> [Sreekanth] we have added this RDPQ support in phase18. So,
> Sreekanth> the firmware from less than phase18 doesn't have this RDPQ
> Sreekanth> support.
>
> Yes, but a single allocation is a subset of multiple allocations. That
> has nothing to do with firmware phase and whether RDPQ is available or
> not.
>
> I have attached a simplified patch below. I probably messed something up
> but you get the idea.
>
> When a new feature is introduced you guys generally go:
>
>         if (new_feature) {
>                 /* Huge block of code */
>         } else {
>                 /* Almost identical huge block of original code */
>         }
>
> I assume that's done to leave the original code paths unchanged. But
> that approach doesn't fly around here. You'll have to come up with a
> generic approach that reduces code duplication and which minimizes the
> differences between the new feature and the old one.
>
> As an example:
>
> Original patch:
>  mpt2sas_base.c |  923 +++++++++++++++++++++++++++++++++------------------------
>  mpt2sas_base.h |   18 -
>  2 files changed, 558 insertions(+), 383 deletions(-)
>
> My patch:
>  mpt2sas_base.c |  207 +++++++++++++++++++++++++++++++++++++++++----------------
>  mpt2sas_base.h |   18 +++-
>  2 files changed, 166 insertions(+), 59 deletions(-)
>
>
> commit ef510bd8dc0e43f8c58012ba9f54213b26381464
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Tue Jul 22 20:56:27 2014 -0400
>
>     Up to now, driver allocates a single contiguous block of memory pool for
>     all reply queues and passes down a single address in the
>     ReplyDescriptorPostQueueAddress field of the IOC Init Request Message to
>     the firmware.
>
>     When firmware receives this address, it will program each of the Reply
>     Descriptor Post Queue registers, as each reply queue has its own
>     register. Thus the firmware, starting from a base address it determines
>     the starting address of the subsequent reply queues through some simple
>     arithmetic calculations.
>
>     The size of this contiguous block of memory pool is directly
>     proportional to number of MSI-X vectors and the HBA queue depth. For
>     example higher MSI-X vectors requires larger contiguous block of memory
>     pool.
>
>     But some of the OS kernels are unable to allocate this larger
>     contiguous block of memory pool.
>
>     So, the proposal is to allocate memory independently for each Reply
>     Queue and pass down all of the addresses to the firmware.  Then the
>     firmware will just take each address and program the value into the
>     correct register.
>
>     When HBAs with older firmware(i.e. without RDPQ capability) is used with
>     this new driver then the max_msix_vectors value would be set to 8 by
>     default.
>
>     Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 22c4575241fc..2d39d5196788 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -92,6 +92,8 @@ static int disable_discovery = -1;
>  module_param(disable_discovery, int, 0);
>  MODULE_PARM_DESC(disable_discovery, " disable discovery ");
>
> +static int _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);
> +
>  /**
>   * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
>   *
> @@ -1424,6 +1426,9 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>         ioc->reply_queue_count = min_t(int, ioc->cpu_count,
>             ioc->msix_vector_count);
>
> +       if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
> +               max_msix_vectors = 8;
> +
>         if (max_msix_vectors > 0) {
>                 ioc->reply_queue_count = min_t(int, max_msix_vectors,
>                     ioc->reply_queue_count);
> @@ -1552,6 +1557,16 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
>         }
>
>         _base_mask_interrupts(ioc);
> +
> +       r = _base_get_ioc_facts(ioc, CAN_SLEEP);
> +       if (r)
> +               goto out_fail;
> +
> +       if (!ioc->rdpq_array_enable_assigned) {
> +               ioc->rdpq_array_enable = ioc->rdpq_array_capable;
> +               ioc->rdpq_array_enable_assigned = 1;
> +       }
> +
>         r = _base_enable_msix(ioc);
>         if (r)
>                 goto out_fail;
> @@ -2390,15 +2405,25 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
>                 ioc->reply_free = NULL;
>         }
>
> -       if (ioc->reply_post_free) {
> -               pci_pool_free(ioc->reply_post_free_dma_pool,
> -                   ioc->reply_post_free, ioc->reply_post_free_dma);
> +       if (ioc->reply_post) {
> +               for (i = 0; i < ioc->reply_queue_count ; i++) {
> +                       struct reply_post_struct *rps = &ioc->reply_post[i];
> +
> +                       if (rps->reply_post_free) {
> +                               pci_pool_free(ioc->reply_post_free_dma_pool,
> +                                             rps->reply_post_free,
> +                                             rps->reply_post_free_dma);
> +                               dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
> +                                       "reply_post_free_pool(0x%p): free\n",
> +                                       ioc->name, rps->reply_post_free));
> +                               rps->reply_post_free = NULL;
> +                       }
> +               }
> +
>                 if (ioc->reply_post_free_dma_pool)
>                         pci_pool_destroy(ioc->reply_post_free_dma_pool);
> -               dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
> -                   "reply_post_free_pool(0x%p): free\n", ioc->name,
> -                   ioc->reply_post_free));
> -               ioc->reply_post_free = NULL;
> +
> +               kfree(ioc->reply_post);
>         }
>
>         if (ioc->config_page) {
> @@ -2443,7 +2468,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
>         struct mpt2sas_facts *facts;
>         u16 max_sge_elements;
>         u16 chains_needed_per_io;
> -       u32 sz, total_sz, reply_post_free_sz;
> +       u32 sz, total_sz;
>         u32 retry_sz;
>         u16 max_request_credit;
>         int i;
> @@ -2752,36 +2777,52 @@ chain_done:
>             "(0x%llx)\n", ioc->name, (unsigned long long)ioc->reply_free_dma));
>         total_sz += sz;
>
> -       /* reply post queue, 16 byte align */
> -       reply_post_free_sz = ioc->reply_post_queue_depth *
> -           sizeof(Mpi2DefaultReplyDescriptor_t);
> -       if (_base_is_controller_msix_enabled(ioc))
> -               sz = reply_post_free_sz * ioc->reply_queue_count;
> -       else
> -               sz = reply_post_free_sz;
> -       ioc->reply_post_free_dma_pool = pci_pool_create("reply_post_free pool",
> -           ioc->pdev, sz, 16, 0);
> -       if (!ioc->reply_post_free_dma_pool) {
> -               printk(MPT2SAS_ERR_FMT "reply_post_free pool: pci_pool_create "
> -                   "failed\n", ioc->name);
> +       /* reply post queue, 16-byte alignment, do not cross 2GB boundary */
> +       sz = ioc->reply_post_queue_depth * sizeof(Mpi2DefaultReplyDescriptor_t);
> +
> +       ioc->reply_post = kcalloc(ioc->reply_queue_count,
> +                                 sizeof(struct reply_post_struct), GFP_KERNEL);
> +       if (!ioc->reply_post) {
> +               printk(MPT2SAS_ERR_FMT "reply_post_free pool: kcalloc failed\n",
> +                      ioc->name);
>                 goto out;
>         }
> -       ioc->reply_post_free = pci_pool_alloc(ioc->reply_post_free_dma_pool ,
> -           GFP_KERNEL, &ioc->reply_post_free_dma);
> -       if (!ioc->reply_post_free) {
> -               printk(MPT2SAS_ERR_FMT "reply_post_free pool: pci_pool_alloc "
> -                   "failed\n", ioc->name);
> +
> +       ioc->reply_post_free_dma_pool =
> +               pci_pool_create("reply_post_free pool", ioc->pdev, sz, 16,
> +                               2L * 1024 * 1024 * 1024);
> +       if (!ioc->reply_post_free_dma_pool) {
> +               printk(MPT2SAS_ERR_FMT
> +                      "reply_post_free pool: pci_pool_create failed\n",
> +                      ioc->name);
>                 goto out;
>         }
> -       memset(ioc->reply_post_free, 0, sz);
> -       dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply post free pool"
> -           "(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
> -           ioc->name, ioc->reply_post_free, ioc->reply_post_queue_depth, 8,
> -           sz/1024));
> -       dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply_post_free_dma = "
> -           "(0x%llx)\n", ioc->name, (unsigned long long)
> -           ioc->reply_post_free_dma));
> -       total_sz += sz;
> +
> +       for (i = 0; i < ioc->reply_queue_count ; i++) {
> +               ioc->reply_post[i].reply_post_free =
> +                       pci_pool_alloc(ioc->reply_post_free_dma_pool,
> +                                      GFP_KERNEL,
> +                                      &ioc->reply_post[i].reply_post_free_dma);
> +               if (!ioc->reply_post[i].reply_post_free) {
> +                       printk(MPT2SAS_ERR_FMT
> +                              "reply_post_free pool: pci_pool_alloc failed\n"
> +                              , ioc->name);
> +                       goto out;
> +               }
> +
> +               dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
> +                                       "reply post free pool (0x%p): depth(%d),"
> +                                       "element_size(%d), pool_size(%d kB)\n",
> +                                       ioc->name,
> +                                       ioc->reply_post[i].reply_post_free,
> +                                       ioc->reply_post_queue_depth, 8,
> +                                       sz/1024));
> +               dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
> +                                       "reply_post_free_dma = (0x%llx)\n",
> +                                       ioc->name, (unsigned long long)
> +                                       ioc->reply_post[i].reply_post_free_dma));
> +       }
> +       total_sz += sz * ioc->reply_queue_count;
>
>         ioc->config_page_sz = 512;
>         ioc->config_page = pci_alloc_consistent(ioc->pdev,
> @@ -2793,15 +2834,15 @@ chain_done:
>         }
>         dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "config page(0x%p): size"
>             "(%d)\n", ioc->name, ioc->config_page, ioc->config_page_sz));
> -       dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "config_page_dma"
> -           "(0x%llx)\n", ioc->name, (unsigned long long)ioc->config_page_dma));
> +       dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "config_page_dma (0x%llx)\n",
> +           ioc->name, (unsigned long long)ioc->config_page_dma));
>         total_sz += ioc->config_page_sz;
>
>         printk(MPT2SAS_INFO_FMT "Allocated physical memory: size(%d kB)\n",
>             ioc->name, total_sz/1024);
> -       printk(MPT2SAS_INFO_FMT "Current Controller Queue Depth(%d), "
> -           "Max Controller Queue Depth(%d)\n",
> -           ioc->name, ioc->shost->can_queue, facts->RequestCredit);
> +       printk(MPT2SAS_INFO_FMT
> +       "Current Controller Queue Depth(%d), Max Controller Queue Depth(%d)\n",
> +        ioc->name, ioc->shost->can_queue, facts->RequestCredit);
>         printk(MPT2SAS_INFO_FMT "Scatter Gather Elements per IO(%d)\n",
>             ioc->name, ioc->shost->sg_tablesize);
>         return 0;
> @@ -3489,9 +3530,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>  {
>         Mpi2IOCInitRequest_t mpi_request;
>         Mpi2IOCInitReply_t mpi_reply;
> -       int r;
> +       int i, r = 0;
>         struct timeval current_time;
>         u16 ioc_status;
> +       u32 reply_post_free_array_sz = 0;
> +       Mpi2IOCInitRDPQArrayEntry *reply_post_free_array = NULL;
> +       dma_addr_t reply_post_free_array_dma;
>
>         dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
>             __func__));
> @@ -3520,9 +3564,35 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>             cpu_to_le64((u64)ioc->request_dma);
>         mpi_request.ReplyFreeQueueAddress =
>             cpu_to_le64((u64)ioc->reply_free_dma);
> -       mpi_request.ReplyDescriptorPostQueueAddress =
> -           cpu_to_le64((u64)ioc->reply_post_free_dma);
>
> +       if (ioc->rdpq_array_enable) {
> +               reply_post_free_array_sz = ioc->reply_queue_count *
> +                   sizeof(Mpi2IOCInitRDPQArrayEntry);
> +
> +               reply_post_free_array = pci_alloc_consistent(ioc->pdev,
> +                               reply_post_free_array_sz,
> +                               &reply_post_free_array_dma);
> +
> +               if (!reply_post_free_array) {
> +                       printk(MPT2SAS_ERR_FMT
> +                              "reply_post_free_array: pci_alloc_consistent failed\n",
> +                              ioc->name);
> +                       r = -ENOMEM;
> +                       goto out;
> +               }
> +
> +               memset(reply_post_free_array, 0, reply_post_free_array_sz);
> +
> +               for (i = 0; i < ioc->reply_queue_count; i++)
> +                       reply_post_free_array[i].RDPQBaseAddress =
> +                           cpu_to_le64(ioc->reply_post[i].reply_post_free_dma);
> +
> +               mpi_request.MsgFlags = MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE;
> +               mpi_request.ReplyDescriptorPostQueueAddress =
> +                   cpu_to_le64(reply_post_free_array_dma);
> +       } else
> +               mpi_request.ReplyDescriptorPostQueueAddress =
> +                   cpu_to_le64(ioc->reply_post[0].reply_post_free_dma);
>
>         /* This time stamp specifies number of milliseconds
>          * since epoch ~ midnight January 1, 1970.
> @@ -3550,7 +3620,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>         if (r != 0) {
>                 printk(MPT2SAS_ERR_FMT "%s: handshake failed (r=%d)\n",
>                     ioc->name, __func__, r);
> -               return r;
> +               goto out;
>         }
>
>         ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
> @@ -3560,7 +3630,13 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>                 r = -EIO;
>         }
>
> -       return 0;
> + out:
> +       if (reply_post_free_array)
> +               pci_free_consistent(ioc->pdev, reply_post_free_array_sz,
> +                                   reply_post_free_array,
> +                                   reply_post_free_array_dma);
> +
> +       return r;
>  }
>
>  /**
> @@ -4092,8 +4168,6 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>         struct _tr_list *delayed_tr, *delayed_tr_next;
>         u8 hide_flag;
>         struct adapter_reply_queue *reply_q;
> -       long reply_post_free;
> -       u32 reply_post_free_sz;
>
>         dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
>             __func__));
> @@ -4164,20 +4238,32 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
>                 _base_assign_reply_queues(ioc);
>
>         /* initialize Reply Post Free Queue */
> -       reply_post_free = (long)ioc->reply_post_free;
> -       reply_post_free_sz = ioc->reply_post_queue_depth *
> -           sizeof(Mpi2DefaultReplyDescriptor_t);
>         list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> +               Mpi2ReplyDescriptorsUnion_t *reply_post_free;
> +               unsigned int reply_post_free_sz, index = 0;
> +
> +               reply_post_free_sz = ioc->reply_post_queue_depth *
> +                       sizeof(Mpi2DefaultReplyDescriptor_t);
> +               reply_post_free = ioc->reply_post[index].reply_post_free;
> +
> +               reply_q->reply_post_free = reply_post_free;
>                 reply_q->reply_post_host_index = 0;
> -               reply_q->reply_post_free = (Mpi2ReplyDescriptorsUnion_t *)
> -                   reply_post_free;
> -               for (i = 0; i < ioc->reply_post_queue_depth; i++)
> -                       reply_q->reply_post_free[i].Words =
> -                                                       cpu_to_le64(ULLONG_MAX);
> +
> +               memset(reply_post_free, 0xff, reply_post_free_sz);
> +
>                 if (!_base_is_controller_msix_enabled(ioc))
>                         goto skip_init_reply_post_free_queue;
> -               reply_post_free += reply_post_free_sz;
> +
> +               /*
> +                * If RDPQ is enabled, switch to the next allocation.
> +                * Otherwise advance within the contiguous region.
> +                */
> +               if (ioc->rdpq_array_enable)
> +                       index++;
> +               else
> +                       reply_post_free += reply_post_free_sz;
>         }
> +
>   skip_init_reply_post_free_queue:
>
>         r = _base_send_ioc_init(ioc, sleep_flag);
> @@ -4304,6 +4390,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
>                 }
>         }
>
> +       ioc->rdpq_array_enable_assigned = 0;
>         r = mpt2sas_base_map_resources(ioc);
>         if (r)
>                 goto out_free_resources;
> @@ -4664,6 +4751,16 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
>                 r = -EFAULT;
>                 goto out;
>         }
> +
> +       r = _base_get_ioc_facts(ioc, CAN_SLEEP);
> +       if (r)
> +               goto out;
> +
> +       if (ioc->rdpq_array_enable && !ioc->rdpq_array_capable)
> +               panic("%s: Issue occurred with flashing controller firmware."
> +                     "Please reboot the system and ensure that the correct"
> +                     "firmware version is running\n", ioc->name);
> +
>         r = _base_make_ioc_operational(ioc, sleep_flag);
>         if (!r)
>                 _base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index fd3b998c75b1..e9749cb7c044 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -634,6 +634,11 @@ struct mpt2sas_port_facts {
>         u16                     MaxPostedCmdBuffers;
>  };
>
> +struct reply_post_struct {
> +       Mpi2ReplyDescriptorsUnion_t     *reply_post_free;
> +       dma_addr_t                      reply_post_free_dma;
> +};
> +
>  /**
>   * enum mutex_type - task management mutex type
>   * @TM_MUTEX_OFF: mutex is not required becuase calling function is acquiring it
> @@ -777,8 +782,11 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct MPT2SAS_ADAPTER *ioc);
>   * @reply_free_dma_pool:
>   * @reply_free_host_index: tail index in pool to insert free replys
>   * @reply_post_queue_depth: reply post queue depth
> - * @reply_post_free: pool for reply post (64bit descriptor)
> - * @reply_post_free_dma:
> + * @reply_post_struct: struct for reply_post_free physical & virt address
> + * @rdpq_array_capable: FW supports multiple reply queue addresses in ioc_init
> + * @rdpq_array_enable: rdpq_array support is enabled in the driver
> + * @rdpq_array_enable_assigned: this ensures that rdpq_array_enable flag
> + *                             is assigned only ones
>   * @reply_queue_count: number of reply queue's
>   * @reply_queue_list: link list contaning the reply queue info
>   * @reply_post_host_index: head index in the pool where FW completes IO
> @@ -970,11 +978,13 @@ struct MPT2SAS_ADAPTER {
>
>         /* reply post queue */
>         u16             reply_post_queue_depth;
> -       Mpi2ReplyDescriptorsUnion_t *reply_post_free;
> -       dma_addr_t      reply_post_free_dma;
> +       struct reply_post_struct *reply_post;
>         struct dma_pool *reply_post_free_dma_pool;
>         u8              reply_queue_count;
>         struct list_head reply_queue_list;
> +       u8              rdpq_array_capable;
> +       u8              rdpq_array_enable;
> +       u8              rdpq_array_enable_assigned;
>
>         struct list_head delayed_tr_list;
>         struct list_head delayed_tr_volume_list;
