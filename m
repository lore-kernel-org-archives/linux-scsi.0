From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Mon, 21 Jul 2014 23:10:05 -0400
Message-ID: <yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
References: <20140625103445.GA12943@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625103445.GA12943@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:04:45 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth,

@@ -2393,15 +2735,39 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 		ioc->reply_free = NULL;
 	}
 
-	if (ioc->reply_post_free) {
-		pci_pool_free(ioc->reply_post_free_dma_pool,
-		    ioc->reply_post_free, ioc->reply_post_free_dma);
+	if (ioc->reply_post) {
+		if (ioc->rdpq_array_enable) {
+			for (i = 0; i < ioc->reply_queue_count; i++) {
+				if (ioc->reply_post[i].reply_post_free) {
+					pci_pool_free(
+					    ioc->reply_post_free_dma_pool,
+					    ioc->reply_post[i].reply_post_free,
+					    ioc->
+					    reply_post[i].reply_post_free_dma);
+					dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
+					   "reply_post_free_pool(0x%p): free\n",
+					    ioc->name,
+					    ioc->reply_post[i].reply_post_free)
+					     );
+					ioc->reply_post[i].reply_post_free =
+					  NULL;
+				}
+			}
+		} else {
+			if (ioc->reply_post[0].reply_post_free) {
+				pci_pool_free(ioc->reply_post_free_dma_pool,
+				    ioc->reply_post[0].reply_post_free,
+				    ioc->reply_post[0].reply_post_free_dma);
+				dexitprintk(ioc, printk(MPT2SAS_INFO_FMT
+				    "reply_post_free_pool(0x%p): free\n",
+				    ioc->name,
+				    ioc->reply_post[0].reply_post_free));
+				ioc->reply_post[0].reply_post_free = NULL;
+			}
+		}

Why do you need to special case !rdpq? Isn't reply_queue_count = 1 in
that case?

@@ -2755,36 +3121,84 @@ chain_done:
 	    "(0x%llx)\n", ioc->name, (unsigned long long)ioc->reply_free_dma));
 	total_sz += sz;
 
-	/* reply post queue, 16 byte align */
-	reply_post_free_sz = ioc->reply_post_queue_depth *
-	    sizeof(Mpi2DefaultReplyDescriptor_t);
-	if (_base_is_controller_msix_enabled(ioc))
-		sz = reply_post_free_sz * ioc->reply_queue_count;
-	else
+	if (ioc->rdpq_array_enable) {
+		ioc->reply_post = kcalloc(ioc->reply_queue_count,
+		    sizeof(struct reply_post_struct), GFP_KERNEL);
+		/* reply post queue, 16 byte align */
+		reply_post_free_sz = ioc->reply_post_queue_depth *
+		    sizeof(Mpi2DefaultReplyDescriptor_t);

This is done in both the rdpq and !rdpq cases. Please avoid code
duplication.

+		ioc->reply_post_free_dma_pool =
+		    pci_pool_create("reply_post_free pool", ioc->pdev, sz,
+		    16, 2147483648);

Magic number?           ^^^^^^^^^^

Why do you create pools for something that's not frequently allocated
and deallocated? These queues are set up once when a controller is
configured.

+		reply_post_free_sz = ioc->reply_post_queue_depth *
+		    sizeof(Mpi2DefaultReplyDescriptor_t);

What's all this reply_post_free business? I don't see the "_free" suffix
in the MPI spec and find it confusing.

@@ -3523,9 +3622,41 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	    cpu_to_le64((u64)ioc->request_dma);
 	mpi_request.ReplyFreeQueueAddress =
 	    cpu_to_le64((u64)ioc->reply_free_dma);
-	mpi_request.ReplyDescriptorPostQueueAddress =
-	    cpu_to_le64((u64)ioc->reply_post_free_dma);
-
+	if (ioc->rdpq_array_enable) {
+		reply_post_free_array_sz = ioc->reply_queue_count *
+		    sizeof(Mpi2IOCInitRDPQArrayEntry);
+		reply_post_free_array_dma_pool =
+		    pci_pool_create("reply_post_free_array pool",
+		    ioc->pdev, reply_post_free_array_sz, 16, 0);

This time with no magic number.                             ^^^

Another pool. This time short lived. Only does a single allocation and
then it's torn down.

+ * @rdpq_array_capable: FW supports multiple reply queue addresses in ioc_init
+ * @rdpq_array_enable: rdpq_array support is enabled in the driver
+ * @rdpq_array_enable_assigned: this ensures that rdpq_array_enable flag
+ *				is assigned only ones

I understand why array_capable is important. enable and enable_assigned
not so much.

In general, I think this could be made much simpler if you treated the
single reply_queue region as a subset of the multi region ditto. It
would avoid a lot of code duplication throughout. You should really only
need to make the distinction when you calculate the number of reply
queues and when you init the chip.

-- 
Martin K. Petersen	Oracle Linux Engineering
