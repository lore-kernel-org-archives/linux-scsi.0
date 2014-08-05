From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Tue, 05 Aug 2014 17:24:20 +0200
Message-ID: <53E0F724.7070500@redhat.com>
References: <20140625104135.GA13038@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625104135.GA13038@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 12:41 PM, Reddy, Sreekanth wrote:
> Up to now, Driver allocates a single contiguous block of memory
> pool for all reply queues and passes down a single address in the
> ReplyDescriptorPostQueueAddress field of the IOC Init Request
> Message to the firmware.
>
> When firmware receives this address, it will program each of the
> Reply Descriptor Post Queue registers, as each reply queue has its
> own register. Thus the firmware, starting from a base address it
> determines the starting address of the subsequent reply queues
> through some simple arithmetic calculations.
>
> The size of this contiguous block of memory pool is directly proportional
> to number of MSI-X vectors and the HBA queue depth. For example higher
> MSIX vectors requires larger contiguous block of memory pool.
>
> But some of the OS kernels are unable to allocate this larger
> contiguous block of memory pool.
>
> So, the proposal is to allocate memory independently for each
> Reply Queue and pass down all of the addresses to the firmware.
> Then the firmware will just take each address and program the value
> into the correct register.
>
> When HBAs with older firmware(i.e. without RDPQ capability) is used
> with this new driver then the max_msix_vectors value would be set
> to 8 by default.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c |  916 ++++++++++++++++++++---------------
>  drivers/scsi/mpt3sas/mpt3sas_base.h |   19 +-
>  2 files changed, 543 insertions(+), 392 deletions(-)
>
...
> +static int
> +_base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
> +	u32 *request, int reply_bytes, u16 *reply, int timeout, int sleep_flag)
> +{
> +	MPI2DefaultReply_t *default_reply = (MPI2DefaultReply_t *)reply;
> +	int i;
> +	u8 failed;
> +	u16 dummy;
> +	__le32 *mfp;
> +
> +	/* make sure doorbell is not in use */
> +	if ((readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {

	if (readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED) {
I think it's equal and better looking with less parentheses, but 
it's a personal preference so you can ignore it.

> +		pr_err(MPT3SAS_FMT "doorbell is in use (line=%d)\n",
> +		    ioc->name, __LINE__);
> +		return -EFAULT;
> +	}
> +
> +	/* clear pending doorbell interrupts from previous state changes */
> +	if (readl(&ioc->chip->HostInterruptStatus) &
> +	    MPI2_HIS_IOC2SYS_DB_STATUS)
> +		writel(0, &ioc->chip->HostInterruptStatus);
> +
> +	/* send message to ioc */
> +	writel(((MPI2_FUNCTION_HANDSHAKE<<MPI2_DOORBELL_FUNCTION_SHIFT) |
> +	    ((request_bytes/4)<<MPI2_DOORBELL_ADD_DWORDS_SHIFT)),
> +	    &ioc->chip->Doorbell);
> +
> +	if ((_base_wait_for_doorbell_int(ioc, 5, NO_SLEEP))) {

Most likely not a problem, but why NO_SLEEP and not the sleep_flag ?

> +		pr_err(MPT3SAS_FMT "doorbell handshake int failed (line=%d)\n",
> +		   ioc->name, __LINE__);
> +		return -EFAULT;
> +	}
> +	writel(0, &ioc->chip->HostInterruptStatus);
> +
> +	if ((_base_wait_for_doorbell_ack(ioc, 5, sleep_flag))) {
> +		pr_err(MPT3SAS_FMT "doorbell handshake ack failed (line=%d)\n",
> +		    ioc->name, __LINE__);
> +		return -EFAULT;
> +	}
> +
> +	/* send message 32-bits at a time */
> +	for (i = 0, failed = 0; i < request_bytes/4 && !failed; i++) {
> +		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
> +		if ((_base_wait_for_doorbell_ack(ioc, 5, sleep_flag)))
> +			failed = 1;
> +	}
...

@@ -2945,39 +3307,82 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 		ioc->name, (unsigned long long)ioc->reply_free_dma));
 	total_sz += sz;
 
-	/* reply post queue, 16 byte align */
-	reply_post_free_sz = ioc->reply_post_queue_depth *
-	    sizeof(Mpi2DefaultReplyDescriptor_t);
-	if (_base_is_controller_msix_enabled(ioc))
-		sz = reply_post_free_sz * ioc->reply_queue_count;
-	else
+	if (ioc->rdpq_array_enable) {
+		ioc->reply_post = kcalloc(ioc->reply_queue_count,
+		sizeof(struct reply_post_struct), GFP_KERNEL);
+		/* reply post queue, 16 byte align */
+		reply_post_free_sz = ioc->reply_post_queue_depth *
+		sizeof(Mpi2DefaultReplyDescriptor_t);
 		sz = reply_post_free_sz;
-	ioc->reply_post_free_dma_pool = pci_pool_create("reply_post_free pool",
-	    ioc->pdev, sz, 16, 0);
-	if (!ioc->reply_post_free_dma_pool) {
-		pr_err(MPT3SAS_FMT
-			"reply_post_free pool: pci_pool_create failed\n",
-			ioc->name);
-		goto out;
-	}
-	ioc->reply_post_free = pci_pool_alloc(ioc->reply_post_free_dma_pool ,
-	    GFP_KERNEL, &ioc->reply_post_free_dma);
-	if (!ioc->reply_post_free) {
-		pr_err(MPT3SAS_FMT
-			"reply_post_free pool: pci_pool_alloc failed\n",
-			ioc->name);
-		goto out;
+		ioc->reply_post_free_dma_pool =
+			pci_pool_create("reply_post_free pool", ioc->pdev, sz,
+			16, 2147483648);

Few lines below with older firmware you don't need this rather
high boundary of 2^31, why is it needed here?

Besides that, checkpatch shows 11 warnings and some of them might be functional - 
"WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers"
please clean your patch next time.

Cheers,
Tomas
