From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Wed, 30 Jul 2014 20:25:14 +0530
Message-ID: <CAK=zhgoEhW7fT7SV6ZkzgFa_A49W9quzWOgXb=DH3D_CrMAdDw@mail.gmail.com>
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
	<CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
	<yq1r41bkgdp.fsf@sermon.lab.mkp.net>
	<CAK=zhgp_v_sdt+VLDs1Mxxi8Cg4nZNnzgQ=d228h+Ht2EpdEqw@mail.gmail.com>
	<yq138dpgr6z.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq138dpgr6z.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

Sorry for the delay as I was on vacation.

Here are the change set when compared to the initial patch

1. Declared the following functions at the beginning of the
mpt2sas_base.c file instead of moving all these functions before
mpt2sas_base_map_resources() function
        a. _base_wait_for_doorbell_int()
        b. _base_wait_for_doorbell_ack()
        c. _base_wait_for_doorbell_not_used()
        d. _base_handshake_req_reply_wait()
        e. _base_get_ioc_facts()

2. Initially set the consistent DMA mask to 32 bit and then change it
to 64 bit mask after allocating RDPQ pools by calling the function
_base_change_consistent_dma_mask. This is to ensure that all the upper
32 bits of RDPQ entries's base address to be same. Also allocated the
RDPQ pools first and then allocated remaining pools such as request
pool, sense buffer pools etc. Also this patch takes care to set the
consistent DMA mask to 64 bit (if it supports) even after resume
operation from hibernation.

3. Reduced the redundancy between the RDPQ and non-RDPQ support in
these following functions
        a. _base_release_memory_pools()
        b. _base_allocate_memory_pools()
        c. _base_send_ioc_init()
        d. _base_make_ioc_operational()

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6b2a79e..d81230a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -92,6 +92,22 @@ static int disable_discovery = -1;
 module_param(disable_discovery, int, 0);
 MODULE_PARM_DESC(disable_discovery, " disable discovery ");

+static int dma_mask;
+
+static int
+_base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                int sleep_flag);
+static int
+_base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                int sleep_flag);
+static int
+_base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                 int sleep_flag);
+static int
+_base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
+    u32 *request, int reply_bytes, u16 *reply, int timeout, int sleep_flag);
+static int
+_base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);
 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
  *
@@ -1179,17 +1195,22 @@ static int
 _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
     struct sysinfo s;
-    char *desc = NULL;
+    u64 consistent_dma_mask;
+
+    if (dma_mask)
+        consistent_dma_mask = DMA_BIT_MASK(64);
+    else
+        consistent_dma_mask = DMA_BIT_MASK(32);

     if (sizeof(dma_addr_t) > 4) {
         const uint64_t required_mask =
             dma_get_required_mask(&pdev->dev);
         if ((required_mask > DMA_BIT_MASK(32)) && !pci_set_dma_mask(pdev,
             DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(pdev,
-            DMA_BIT_MASK(64))) {
+            consistent_dma_mask)) {
             ioc->base_add_sg_single = &_base_add_sg_single_64;
             ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-            desc = "64";
+            dma_mask = 64;
             goto out;
         }
     }
@@ -1198,18 +1219,29 @@ _base_config_dma_addressing(struct
MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
         && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
         ioc->base_add_sg_single = &_base_add_sg_single_32;
         ioc->sge_size = sizeof(Mpi2SGESimple32_t);
-        desc = "32";
+        dma_mask = 32;
     } else
         return -ENODEV;

  out:
     si_meminfo(&s);
-    printk(MPT2SAS_INFO_FMT "%s BIT PCI BUS DMA ADDRESSING SUPPORTED, "
-        "total mem (%ld kB)\n", ioc->name, desc, convert_to_kb(s.totalram));
+    printk(MPT2SAS_INFO_FMT
+        "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
+        ioc->name, dma_mask, convert_to_kb(s.totalram));

     return 0;
 }

+static int
+_base_change_consistent_dma_mask(struct MPT2SAS_ADAPTER *ioc,
+                  struct pci_dev *pdev)
+{
+    if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+        if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
+            return -ENODEV;
+    }
+    return 0;
+}
 /**
  * _base_check_enable_msix - checks MSIX capabable.
  * @ioc: per adapter object
@@ -1424,6 +1456,9 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
     ioc->reply_queue_count = min_t(int, ioc->cpu_count,
         ioc->msix_vector_count);

+    if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
+        max_msix_vectors = 8;
+
     if (max_msix_vectors > 0) {
         ioc->reply_queue_count = min_t(int, max_msix_vectors,
             ioc->reply_queue_count);
@@ -1552,6 +1587,16 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
     }

     _base_mask_interrupts(ioc);
+
+    r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+    if (r)
+        goto out_fail;
+
+    if (!ioc->rdpq_array_enable_assigned) {
+        ioc->rdpq_array_enable = ioc->rdpq_array_capable;
+        ioc->rdpq_array_enable_assigned = 1;
+    }
+
     r = _base_enable_msix(ioc);
     if (r)
         goto out_fail;
@@ -2349,7 +2394,8 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 {
-    int i;
+    int i = 0;
+    struct reply_post_struct *rps;

     dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -2390,15 +2436,25 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
         ioc->reply_free = NULL;
     }

-    if (ioc->reply_post_free) {
-        pci_pool_free(ioc->reply_post_free_dma_pool,
-            ioc->reply_post_free, ioc->reply_post_free_dma);
+    if (ioc->reply_post) {
+        do {
+            rps = &ioc->reply_post[i];
+            if (rps->reply_post_free) {
+                pci_pool_free(
+                    ioc->reply_post_free_dma_pool,
+                    rps->reply_post_free,
+                    rps->reply_post_free_dma);
+                dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
+                    "reply_post_free_pool(0x%p): free\n",
+                    ioc->name, rps->reply_post_free));
+                rps->reply_post_free = NULL;
+            }
+        } while (ioc->rdpq_array_enable &&
+               (++i < ioc->reply_queue_count));
+
         if (ioc->reply_post_free_dma_pool)
             pci_pool_destroy(ioc->reply_post_free_dma_pool);
-        dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
-            "reply_post_free_pool(0x%p): free\n", ioc->name,
-            ioc->reply_post_free));
-        ioc->reply_post_free = NULL;
+        kfree(ioc->reply_post);
     }

     if (ioc->config_page) {
@@ -2541,6 +2597,69 @@ _base_allocate_memory_pools(struct
MPT2SAS_ADAPTER *ioc,  int sleep_flag)
         ioc->max_sges_in_chain_message, ioc->shost->sg_tablesize,
         ioc->chains_needed_per_io));

+    /* reply post queue, 16 byte align */
+    reply_post_free_sz = ioc->reply_post_queue_depth *
+        sizeof(Mpi2DefaultReplyDescriptor_t);
+    if (ioc->rdpq_array_enable)
+        sz = reply_post_free_sz;
+    else {
+        if (_base_is_controller_msix_enabled(ioc))
+            sz = reply_post_free_sz * ioc->reply_queue_count;
+        else
+            sz = reply_post_free_sz;
+    }
+
+    ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
+        (ioc->reply_queue_count):1,
+        sizeof(struct reply_post_struct), GFP_KERNEL);
+
+    if (!ioc->reply_post) {
+        printk(MPT2SAS_ERR_FMT "reply_post_free pool: kcalloc failed\n",
+            ioc->name);
+        goto out;
+    }
+    ioc->reply_post_free_dma_pool = pci_pool_create("reply_post_free pool",
+        ioc->pdev, sz, 16, 0);
+    if (!ioc->reply_post_free_dma_pool) {
+        printk(MPT2SAS_ERR_FMT
+         "reply_post_free pool: pci_pool_create failed\n",
+         ioc->name);
+        goto out;
+    }
+    i = 0;
+    do {
+        ioc->reply_post[i].reply_post_free =
+            pci_pool_alloc(ioc->reply_post_free_dma_pool,
+            GFP_KERNEL,
+            &ioc->reply_post[i].reply_post_free_dma);
+        if (!ioc->reply_post[i].reply_post_free) {
+            printk(MPT2SAS_ERR_FMT
+            "reply_post_free pool: pci_pool_alloc failed\n",
+            ioc->name);
+            goto out;
+        }
+        memset(ioc->reply_post[i].reply_post_free, 0, sz);
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "reply post free pool (0x%p): depth(%d),"
+            "element_size(%d), pool_size(%d kB)\n", ioc->name,
+            ioc->reply_post[i].reply_post_free,
+            ioc->reply_post_queue_depth, 8, sz/1024));
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "reply_post_free_dma = (0x%llx)\n", ioc->name,
+            (unsigned long long)
+            ioc->reply_post[i].reply_post_free_dma));
+        total_sz += sz;
+    } while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
+
+    if (dma_mask == 64) {
+        if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
+            printk(MPT2SAS_WARN_FMT
+                "no suitable consistent DMA mask for %s\n",
+                ioc->name, pci_name(ioc->pdev));
+            goto out;
+        }
+    }
+
     ioc->scsiio_depth = ioc->hba_queue_depth -
         ioc->hi_priority_depth - ioc->internal_depth;

@@ -2752,37 +2871,6 @@ chain_done:
         "(0x%llx)\n", ioc->name, (unsigned long long)ioc->reply_free_dma));
     total_sz += sz;

-    /* reply post queue, 16 byte align */
-    reply_post_free_sz = ioc->reply_post_queue_depth *
-        sizeof(Mpi2DefaultReplyDescriptor_t);
-    if (_base_is_controller_msix_enabled(ioc))
-        sz = reply_post_free_sz * ioc->reply_queue_count;
-    else
-        sz = reply_post_free_sz;
-    ioc->reply_post_free_dma_pool = pci_pool_create("reply_post_free pool",
-        ioc->pdev, sz, 16, 0);
-    if (!ioc->reply_post_free_dma_pool) {
-        printk(MPT2SAS_ERR_FMT "reply_post_free pool: pci_pool_create "
-            "failed\n", ioc->name);
-        goto out;
-    }
-    ioc->reply_post_free = pci_pool_alloc(ioc->reply_post_free_dma_pool ,
-        GFP_KERNEL, &ioc->reply_post_free_dma);
-    if (!ioc->reply_post_free) {
-        printk(MPT2SAS_ERR_FMT "reply_post_free pool: pci_pool_alloc "
-            "failed\n", ioc->name);
-        goto out;
-    }
-    memset(ioc->reply_post_free, 0, sz);
-    dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply post free pool"
-        "(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
-        ioc->name, ioc->reply_post_free, ioc->reply_post_queue_depth, 8,
-        sz/1024));
-    dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "reply_post_free_dma = "
-        "(0x%llx)\n", ioc->name, (unsigned long long)
-        ioc->reply_post_free_dma));
-    total_sz += sz;
-
     ioc->config_page_sz = 512;
     ioc->config_page = pci_alloc_consistent(ioc->pdev,
         ioc->config_page_sz, &ioc->config_page_dma);
@@ -3454,6 +3542,9 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc,
int sleep_flag)
     facts->IOCCapabilities = le32_to_cpu(mpi_reply.IOCCapabilities);
     if ((facts->IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID))
         ioc->ir_firmware = 1;
+    if ((facts->IOCCapabilities &
+          MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE))
+        ioc->rdpq_array_capable = 1;
     facts->FWVersion.Word = le32_to_cpu(mpi_reply.FWVersion.Word);
     facts->IOCRequestFrameSize =
         le16_to_cpu(mpi_reply.IOCRequestFrameSize);
@@ -3489,9 +3580,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
 {
     Mpi2IOCInitRequest_t mpi_request;
     Mpi2IOCInitReply_t mpi_reply;
-    int r;
+    int i, r = 0;
     struct timeval current_time;
     u16 ioc_status;
+    u32 reply_post_free_array_sz = 0;
+    Mpi2IOCInitRDPQArrayEntry *reply_post_free_array = NULL;
+    dma_addr_t reply_post_free_array_dma;

     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -3520,9 +3614,31 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
         cpu_to_le64((u64)ioc->request_dma);
     mpi_request.ReplyFreeQueueAddress =
         cpu_to_le64((u64)ioc->reply_free_dma);
-    mpi_request.ReplyDescriptorPostQueueAddress =
-        cpu_to_le64((u64)ioc->reply_post_free_dma);

+    if (ioc->rdpq_array_enable) {
+        reply_post_free_array_sz = ioc->reply_queue_count *
+            sizeof(Mpi2IOCInitRDPQArrayEntry);
+        reply_post_free_array = pci_alloc_consistent(ioc->pdev,
+            reply_post_free_array_sz, &reply_post_free_array_dma);
+        if (!reply_post_free_array) {
+            printk(MPT2SAS_ERR_FMT
+            "reply_post_free_array: pci_alloc_consistent failed\n",
+            ioc->name);
+            r = -ENOMEM;
+            goto out;
+        }
+        memset(reply_post_free_array, 0, reply_post_free_array_sz);
+        for (i = 0; i < ioc->reply_queue_count; i++)
+            reply_post_free_array[i].RDPQBaseAddress =
+                cpu_to_le64(
+                (u64)ioc->reply_post[i].reply_post_free_dma);
+        mpi_request.MsgFlags = MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE;
+        mpi_request.ReplyDescriptorPostQueueAddress =
+            cpu_to_le64((u64)reply_post_free_array_dma);
+    } else {
+        mpi_request.ReplyDescriptorPostQueueAddress =
+            cpu_to_le64((u64)ioc->reply_post[0].reply_post_free_dma);
+    }

     /* This time stamp specifies number of milliseconds
      * since epoch ~ midnight January 1, 1970.
@@ -3550,7 +3666,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc,
int sleep_flag)
     if (r != 0) {
         printk(MPT2SAS_ERR_FMT "%s: handshake failed (r=%d)\n",
             ioc->name, __func__, r);
-        return r;
+        goto out;
     }

     ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
@@ -3560,7 +3676,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER
*ioc, int sleep_flag)
         r = -EIO;
     }

-    return 0;
+out:
+    if (reply_post_free_array)
+        pci_free_consistent(ioc->pdev, reply_post_free_array_sz,
+                    reply_post_free_array,
+                    reply_post_free_array_dma);
+    return r;
 }

 /**
@@ -4093,7 +4214,7 @@ _base_make_ioc_operational(struct
MPT2SAS_ADAPTER *ioc, int sleep_flag)
     u8 hide_flag;
     struct adapter_reply_queue *reply_q;
     long reply_post_free;
-    u32 reply_post_free_sz;
+    u32 reply_post_free_sz, index = 0;

     dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
         __func__));
@@ -4164,19 +4285,27 @@ _base_make_ioc_operational(struct
MPT2SAS_ADAPTER *ioc, int sleep_flag)
         _base_assign_reply_queues(ioc);

     /* initialize Reply Post Free Queue */
-    reply_post_free = (long)ioc->reply_post_free;
     reply_post_free_sz = ioc->reply_post_queue_depth *
         sizeof(Mpi2DefaultReplyDescriptor_t);
+    reply_post_free = (long)ioc->reply_post[index].reply_post_free;
     list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
         reply_q->reply_post_host_index = 0;
         reply_q->reply_post_free = (Mpi2ReplyDescriptorsUnion_t *)
             reply_post_free;
         for (i = 0; i < ioc->reply_post_queue_depth; i++)
             reply_q->reply_post_free[i].Words =
-                            cpu_to_le64(ULLONG_MAX);
+                             cpu_to_le64(ULLONG_MAX);
         if (!_base_is_controller_msix_enabled(ioc))
             goto skip_init_reply_post_free_queue;
-        reply_post_free += reply_post_free_sz;
+        /*
+         * If RDPQ is enabled, switch to the next allocation.
+         * Otherwise advance within the contiguous region.
+         */
+        if (ioc->rdpq_array_enable)
+            reply_post_free = (long)
+                ioc->reply_post[++index].reply_post_free;
+        else
+            reply_post_free += reply_post_free_sz;
     }
  skip_init_reply_post_free_queue:

@@ -4304,6 +4433,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
         }
     }

+    ioc->rdpq_array_enable_assigned = 0;
     r = mpt2sas_base_map_resources(ioc);
     if (r)
         goto out_free_resources;
@@ -4664,6 +4794,16 @@ mpt2sas_base_hard_reset_handler(struct
MPT2SAS_ADAPTER *ioc, int sleep_flag,
         r = -EFAULT;
         goto out;
     }
+
+    r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+    if (r)
+        goto out;
+
+    if (ioc->rdpq_array_enable && !ioc->rdpq_array_capable)
+        panic("%s: Issue occurred with flashing controller firmware."
+              "Please reboot the system and ensure that the correct"
+              "firmware version is running\n", ioc->name);
+
     r = _base_make_ioc_operational(ioc, sleep_flag);
     if (!r)
         _base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
b/drivers/scsi/mpt2sas/mpt2sas_base.h
index be2ae90..5f85002 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -636,6 +636,11 @@ struct mpt2sas_port_facts {
     u16            MaxPostedCmdBuffers;
 };

+struct reply_post_struct {
+    Mpi2ReplyDescriptorsUnion_t    *reply_post_free;
+    dma_addr_t            reply_post_free_dma;
+};
+
 /**
  * enum mutex_type - task management mutex type
  * @TM_MUTEX_OFF: mutex is not required becuase calling function is
acquiring it
@@ -779,8 +784,11 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct
MPT2SAS_ADAPTER *ioc);
  * @reply_free_dma_pool:
  * @reply_free_host_index: tail index in pool to insert free replys
  * @reply_post_queue_depth: reply post queue depth
- * @reply_post_free: pool for reply post (64bit descriptor)
- * @reply_post_free_dma:
+ * @reply_post_struct: struct for reply_post_free physical & virt address
+ * @rdpq_array_capable: FW supports multiple reply queue addresses in ioc_init
+ * @rdpq_array_enable: rdpq_array support is enabled in the driver
+ * @rdpq_array_enable_assigned: this ensures that rdpq_array_enable flag
+ *                is assigned only ones
  * @reply_queue_count: number of reply queue's
  * @reply_queue_list: link list contaning the reply queue info
  * @reply_post_host_index: head index in the pool where FW completes IO
@@ -972,8 +980,10 @@ struct MPT2SAS_ADAPTER {

     /* reply post queue */
     u16         reply_post_queue_depth;
-    Mpi2ReplyDescriptorsUnion_t *reply_post_free;
-    dma_addr_t    reply_post_free_dma;
+    struct reply_post_struct *reply_post;
+    u8        rdpq_array_capable;
+    u8        rdpq_array_enable;
+    u8        rdpq_array_enable_assigned;
     struct dma_pool *reply_post_free_dma_pool;
     u8        reply_queue_count;
     struct list_head reply_queue_list;

On Sat, Jul 26, 2014 at 1:13 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth,
>
> Sreekanth> Following are the changes that I have done in this patch over
> Sreekanth> the first RDPQ support patch,
>
> Please, please do the function moves in a different patch. Or use a
> simple prototype declaration like I did to avoid moving the code around
> in the first place.
>
> Sreekanth> 2. Set pci_set_consistent_dma_mask() to
> Sreekanth>    DMA_BIT_MASK(32). still I am analysing whether this change
> Sreekanth>    may affect on any other things or not?
>
> I think you're done allocating things by the time this is called. But to
> be sure you can call _base_config_dma_addressing() after you're done
> with the RDPQ allocations (or rearrange the code so you allocate RDPQ
> before the DMA mask is upped in general).
>
> --
> Martin K. Petersen      Oracle Linux Engineering
