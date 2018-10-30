From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 11:09:04 -0600
Message-ID: <535480f3-9087-b4ae-e7c8-cfe3c2d1e2c9@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
 <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
 <20181030150840.GC18906@localhost.localdomain>
 <d049e764-b9d1-f06f-40d3-39517f3f65a2@kernel.dk>
 <20181030160242.GD18906@localhost.localdomain>
 <27c1017a-9560-80cb-038d-f64727a162c3@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27c1017a-9560-80cb-038d-f64727a162c3@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 10:42 AM, Jens Axboe wrote:
> On 10/30/18 10:02 AM, Keith Busch wrote:
>> On Tue, Oct 30, 2018 at 09:18:05AM -0600, Jens Axboe wrote:
>>> On 10/30/18 9:08 AM, Keith Busch wrote:
>>>> On Tue, Oct 30, 2018 at 08:53:37AM -0600, Jens Axboe wrote:
>>>>> The sum of the set can't exceed the nvecs passed in, the nvecs passed in
>>>>> should be the less than or equal to nvecs. Granted this isn't enforced,
>>>>> and perhaps that should be the case.
>>>>
>>>> That should at least initially be true for a proper functioning
>>>> driver. It's not enforced as you mentioned, but that's only related to
>>>> the issue I'm referring to.
>>>>
>>>> The problem is pci_alloc_irq_vectors_affinity() takes a range, min_vecs
>>>> and max_vecs, but a range of allowable vector allocations doesn't make
>>>> sense when using sets.
>>>
>>> I feel like we're going in circles here, not sure what you feel the
>>> issue is now? The range is fine, whoever uses sets will need to adjust
>>> their sets based on what pci_alloc_irq_vectors_affinity() returns,
>>> if it didn't return the passed in desired max.
>>
>> Sorry, let me to try again.
>>
>> pci_alloc_irq_vectors_affinity() starts at the provided max_vecs. If
>> that doesn't work, it will iterate down to min_vecs without returning to
>> the caller. The caller doesn't have a chance to adjust its sets between
>> iterations when you provide a range.
>>
>> The 'masks' overrun problem happens if the caller provides min_vecs
>> as a smaller value than the sum of the set (plus any reserved).
>>
>> If it's up to the caller to ensure that doesn't happen, then min and
>> max must both be the same value, and that value must also be the same as
>> the set sum + reserved vectors. The range just becomes redundant since
>> it is already bounded by the set.
>>
>> Using the nvme example, it would need something like this to prevent the
>> 'masks' overrun:
> 
> OK, now I hear what you are saying. And you are right, the callers needs
> to provide minvec == maxvec for sets, and then have a loop around that
> to adjust as needed.
> 
> I'll make that change in nvme.

Pretty trivial, below. This also keeps the queue mapping calculations
more clean, as we don't have to do one after we're done allocating
IRQs.


commit e8a35d023a192e34540c60f779fe755970b8eeb2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Oct 30 11:06:29 2018 -0600

    nvme: utilize two queue maps, one for reads and one for writes
    
    NVMe does round-robin between queues by default, which means that
    sharing a queue map for both reads and writes can be problematic
    in terms of read servicing. It's much easier to flood the queue
    with writes and reduce the read servicing.
    
    Implement two queue maps, one for reads and one for writes. The
    write queue count is configurable through the 'write_queues'
    parameter.
    
    By default, we retain the previous behavior of having a single
    queue set, shared between reads and writes. Setting 'write_queues'
    to a non-zero value will create two queue sets, one for reads and
    one for writes, the latter using the configurable number of
    queues (hardware queue counts permitting).
    
    Reviewed-by: Hannes Reinecke <hare@suse.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e5d783cb6937..17170686105f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -74,11 +74,29 @@ static int io_queue_depth = 1024;
 module_param_cb(io_queue_depth, &io_queue_depth_ops, &io_queue_depth, 0644);
 MODULE_PARM_DESC(io_queue_depth, "set io queue depth, should >= 2");
 
+static int queue_count_set(const char *val, const struct kernel_param *kp);
+static const struct kernel_param_ops queue_count_ops = {
+	.set = queue_count_set,
+	.get = param_get_int,
+};
+
+static int write_queues;
+module_param_cb(write_queues, &queue_count_ops, &write_queues, 0644);
+MODULE_PARM_DESC(write_queues,
+	"Number of queues to use for writes. If not set, reads and writes "
+	"will share a queue set.");
+
 struct nvme_dev;
 struct nvme_queue;
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 
+enum {
+	NVMEQ_TYPE_READ,
+	NVMEQ_TYPE_WRITE,
+	NVMEQ_TYPE_NR,
+};
+
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
  */
@@ -92,6 +110,7 @@ struct nvme_dev {
 	struct dma_pool *prp_small_pool;
 	unsigned online_queues;
 	unsigned max_qid;
+	unsigned io_queues[NVMEQ_TYPE_NR];
 	unsigned int num_vecs;
 	int q_depth;
 	u32 db_stride;
@@ -134,6 +153,17 @@ static int io_queue_depth_set(const char *val, const struct kernel_param *kp)
 	return param_set_int(val, kp);
 }
 
+static int queue_count_set(const char *val, const struct kernel_param *kp)
+{
+	int n = 0, ret;
+
+	ret = kstrtoint(val, 10, &n);
+	if (n > num_possible_cpus())
+		n = num_possible_cpus();
+
+	return param_set_int(val, kp);
+}
+
 static inline unsigned int sq_idx(unsigned int qid, u32 stride)
 {
 	return qid * 2 * stride;
@@ -218,9 +248,20 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_dbbuf) != 64);
 }
 
+static unsigned int max_io_queues(void)
+{
+	return num_possible_cpus() + write_queues;
+}
+
+static unsigned int max_queue_count(void)
+{
+	/* IO queues + admin queue */
+	return 1 + max_io_queues();
+}
+
 static inline unsigned int nvme_dbbuf_size(u32 stride)
 {
-	return ((num_possible_cpus() + 1) * 8 * stride);
+	return (max_queue_count() * 8 * stride);
 }
 
 static int nvme_dbbuf_dma_alloc(struct nvme_dev *dev)
@@ -431,12 +472,41 @@ static int nvme_init_request(struct blk_mq_tag_set *set, struct request *req,
 	return 0;
 }
 
+static int queue_irq_offset(struct nvme_dev *dev)
+{
+	/* if we have more than 1 vec, admin queue offsets us 1 */
+	if (dev->num_vecs > 1)
+		return 1;
+
+	return 0;
+}
+
 static int nvme_pci_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_dev *dev = set->driver_data;
+	int i, qoff, offset;
+
+	offset = queue_irq_offset(dev);
+	for (i = 0, qoff = 0; i < set->nr_maps; i++) {
+		struct blk_mq_queue_map *map = &set->map[i];
 
-	return blk_mq_pci_map_queues(&set->map[0], to_pci_dev(dev->dev),
-			dev->num_vecs > 1 ? 1 /* admin queue */ : 0);
+		map->nr_queues = dev->io_queues[i];
+		if (!map->nr_queues) {
+			BUG_ON(i == NVMEQ_TYPE_READ);
+
+			/* shared set, resuse read set parameters */
+			map->nr_queues = dev->io_queues[NVMEQ_TYPE_READ];
+			qoff = 0;
+			offset = queue_irq_offset(dev);
+		}
+
+		map->queue_offset = qoff;
+		blk_mq_pci_map_queues(map, to_pci_dev(dev->dev), offset);
+		qoff += map->nr_queues;
+		offset += map->nr_queues;
+	}
+
+	return 0;
 }
 
 /**
@@ -849,6 +919,14 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
+static int nvme_flags_to_type(struct request_queue *q, unsigned int flags)
+{
+	if ((flags & REQ_OP_MASK) == REQ_OP_READ)
+		return NVMEQ_TYPE_READ;
+
+	return NVMEQ_TYPE_WRITE;
+}
+
 static void nvme_pci_complete_rq(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -1476,6 +1554,7 @@ static const struct blk_mq_ops nvme_mq_admin_ops = {
 
 static const struct blk_mq_ops nvme_mq_ops = {
 	.queue_rq	= nvme_queue_rq,
+	.flags_to_type	= nvme_flags_to_type,
 	.complete	= nvme_pci_complete_rq,
 	.init_hctx	= nvme_init_hctx,
 	.init_request	= nvme_init_request,
@@ -1888,18 +1967,53 @@ static int nvme_setup_host_mem(struct nvme_dev *dev)
 	return ret;
 }
 
+static void nvme_calc_io_queues(struct nvme_dev *dev, unsigned int nr_io_queues)
+{
+	unsigned int this_w_queues = write_queues;
+
+	/*
+	 * Setup read/write queue split
+	 */
+	if (nr_io_queues == 1) {
+		dev->io_queues[NVMEQ_TYPE_READ] = 1;
+		dev->io_queues[NVMEQ_TYPE_WRITE] = 0;
+		return;
+	}
+
+	/*
+	 * If 'write_queues' is set, ensure it leaves room for at least
+	 * one read queue
+	 */
+	if (this_w_queues >= nr_io_queues)
+		this_w_queues = nr_io_queues - 1;
+
+	/*
+	 * If 'write_queues' is set to zero, reads and writes will share
+	 * a queue set.
+	 */
+	if (!this_w_queues) {
+		dev->io_queues[NVMEQ_TYPE_WRITE] = 0;
+		dev->io_queues[NVMEQ_TYPE_READ] = nr_io_queues;
+	} else {
+		dev->io_queues[NVMEQ_TYPE_WRITE] = this_w_queues;
+		dev->io_queues[NVMEQ_TYPE_READ] = nr_io_queues - this_w_queues;
+	}
+}
+
 static int nvme_setup_io_queues(struct nvme_dev *dev)
 {
 	struct nvme_queue *adminq = &dev->queues[0];
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	int result, nr_io_queues;
 	unsigned long size;
-
+	int irq_sets[2];
 	struct irq_affinity affd = {
-		.pre_vectors = 1
+		.pre_vectors = 1,
+		.nr_sets = ARRAY_SIZE(irq_sets),
+		.sets = irq_sets,
 	};
 
-	nr_io_queues = num_possible_cpus();
+	nr_io_queues = max_io_queues();
 	result = nvme_set_queue_count(&dev->ctrl, &nr_io_queues);
 	if (result < 0)
 		return result;
@@ -1934,13 +2048,48 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	 * setting up the full range we need.
 	 */
 	pci_free_irq_vectors(pdev);
-	result = pci_alloc_irq_vectors_affinity(pdev, 1, nr_io_queues + 1,
-			PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY, &affd);
-	if (result <= 0)
-		return -EIO;
+
+	/*
+	 * For irq sets, we have to ask for minvec == maxvec. This passes
+	 * any reduction back to us, so we can adjust our queue counts and
+	 * IRQ vector needs.
+	 */
+	do {
+		nvme_calc_io_queues(dev, nr_io_queues);
+		irq_sets[0] = dev->io_queues[NVMEQ_TYPE_READ];
+		irq_sets[1] = dev->io_queues[NVMEQ_TYPE_WRITE];
+		if (!irq_sets[1])
+			affd.nr_sets = 1;
+
+		/*
+		 * Need IRQs for read+write queues, and one for the admin queue
+		 */
+		nr_io_queues = irq_sets[0] + irq_sets[1] + 1;
+
+		result = pci_alloc_irq_vectors_affinity(pdev, nr_io_queues,
+				nr_io_queues,
+				PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY, &affd);
+
+		/*
+		 * Need to reduce our vec counts
+		 */
+		if (result == -ENOSPC) {
+			nr_io_queues--;
+			if (!nr_io_queues)
+				return result;
+			continue;
+		} else if (result <= 0)
+			return -EIO;
+		break;
+	} while (1);
+
 	dev->num_vecs = result;
 	dev->max_qid = max(result - 1, 1);
 
+	dev_info(dev->ctrl.device, "%d/%d/%d read/write queues\n",
+					dev->io_queues[NVMEQ_TYPE_READ],
+					dev->io_queues[NVMEQ_TYPE_WRITE]);
+
 	/*
 	 * Should investigate if there's a performance win from allocating
 	 * more queues than interrupt vectors; it might allow the submission
@@ -2042,6 +2191,7 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	if (!dev->ctrl.tagset) {
 		dev->tagset.ops = &nvme_mq_ops;
 		dev->tagset.nr_hw_queues = dev->online_queues - 1;
+		dev->tagset.nr_maps = NVMEQ_TYPE_NR;
 		dev->tagset.timeout = NVME_IO_TIMEOUT;
 		dev->tagset.numa_node = dev_to_node(dev->dev);
 		dev->tagset.queue_depth =
@@ -2489,8 +2639,8 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!dev)
 		return -ENOMEM;
 
-	dev->queues = kcalloc_node(num_possible_cpus() + 1,
-			sizeof(struct nvme_queue), GFP_KERNEL, node);
+	dev->queues = kcalloc_node(max_queue_count(), sizeof(struct nvme_queue),
+					GFP_KERNEL, node);
 	if (!dev->queues)
 		goto free;
 

-- 
Jens Axboe
