From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2] Storvsc: Select channel based on available percentage of ring buffer to write
Date: Thu, 19 Apr 2018 14:54:24 -0700
Message-ID: <20180419215424.3557-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

This is a best effort for estimating on how busy the ring buffer is for
that channel, based on available buffer to write in percentage. It is still
possible that at the time of actual ring buffer write, the space may not be
available due to other processes may be writing at the time.

Selecting a channel based on how full it is can reduce the possibility that
a ring buffer write will fail, and avoid the situation a channel is over
busy.

Now it's possible that storvsc can use a smaller ring buffer size
(e.g. 40k bytes) to take advantage of cache locality.

Changes.
v2: Pre-allocate struct cpumask on the heap.
Struct cpumask is a big structure (1k bytes) when CONFIG_NR_CPUS=8192 (default
value when CONFIG_MAXSMP=y). Don't use kernel stack for it by pre-allocating
them using kmalloc when channels are first initialized.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 90 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a2ec0bc9e9fa..2a9fff94dd1a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -395,6 +395,12 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subchannels");
+
+static int ring_avail_percent_lowater = 10;
+module_param(ring_avail_percent_lowater, int, S_IRUGO);
+MODULE_PARM_DESC(ring_avail_percent_lowater,
+		"Select a channel if available ring size > this in percent");
+
 /*
  * Timeout in seconds for all devices managed by this driver.
  */
@@ -468,6 +474,13 @@ struct storvsc_device {
 	 * Mask of CPUs bound to subchannels.
 	 */
 	struct cpumask alloced_cpus;
+	/*
+	 * Pre-allocated struct cpumask for each hardware queue.
+	 * struct cpumask is used by selecting out-going channels. It is a
+	 * big structure, default to 1024k bytes when CONFIG_MAXSMP=y.
+	 * Pre-allocate it to avoid allocation on the kernel stack.
+	 */
+	struct cpumask *cpumask_chns;
 	/* Used for vsc/vsp channel reset process */
 	struct storvsc_cmd_request init_request;
 	struct storvsc_cmd_request reset_request;
@@ -872,6 +885,13 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 	if (stor_device->stor_chns == NULL)
 		return -ENOMEM;
 
+	stor_device->cpumask_chns = kcalloc(num_possible_cpus(),
+			sizeof(struct cpumask), GFP_KERNEL);
+	if (stor_device->cpumask_chns == NULL) {
+		kfree(stor_device->stor_chns);
+		return -ENOMEM;
+	}
+
 	stor_device->stor_chns[device->channel->target_cpu] = device->channel;
 	cpumask_set_cpu(device->channel->target_cpu,
 			&stor_device->alloced_cpus);
@@ -1232,6 +1252,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 	vmbus_close(device->channel);
 
 	kfree(stor_device->stor_chns);
+	kfree(stor_device->cpumask_chns);
 	kfree(stor_device);
 	return 0;
 }
@@ -1241,7 +1262,7 @@ static struct vmbus_channel *get_og_chn(struct storvsc_device *stor_device,
 {
 	u16 slot = 0;
 	u16 hash_qnum;
-	struct cpumask alloced_mask;
+	struct cpumask *alloced_mask = &stor_device->cpumask_chns[q_num];
 	int num_channels, tgt_cpu;
 
 	if (stor_device->num_sc == 0)
@@ -1257,10 +1278,10 @@ static struct vmbus_channel *get_og_chn(struct storvsc_device *stor_device,
 	 * III. Mapping is persistent.
 	 */
 
-	cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
+	cpumask_and(alloced_mask, &stor_device->alloced_cpus,
 		    cpumask_of_node(cpu_to_node(q_num)));
 
-	num_channels = cpumask_weight(&alloced_mask);
+	num_channels = cpumask_weight(alloced_mask);
 	if (num_channels == 0)
 		return stor_device->device->channel;
 
@@ -1268,7 +1289,7 @@ static struct vmbus_channel *get_og_chn(struct storvsc_device *stor_device,
 	while (hash_qnum >= num_channels)
 		hash_qnum -= num_channels;
 
-	for_each_cpu(tgt_cpu, &alloced_mask) {
+	for_each_cpu(tgt_cpu, alloced_mask) {
 		if (slot == hash_qnum)
 			break;
 		slot++;
@@ -1285,9 +1306,9 @@ static int storvsc_do_io(struct hv_device *device,
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
-	struct vmbus_channel *outgoing_channel;
+	struct vmbus_channel *outgoing_channel, *channel;
 	int ret = 0;
-	struct cpumask alloced_mask;
+	struct cpumask *alloced_mask;
 	int tgt_cpu;
 
 	vstor_packet = &request->vstor_packet;
@@ -1301,22 +1322,53 @@ static int storvsc_do_io(struct hv_device *device,
 	/*
 	 * Select an an appropriate channel to send the request out.
 	 */
-
 	if (stor_device->stor_chns[q_num] != NULL) {
 		outgoing_channel = stor_device->stor_chns[q_num];
-		if (outgoing_channel->target_cpu == smp_processor_id()) {
+		if (outgoing_channel->target_cpu == q_num) {
 			/*
 			 * Ideally, we want to pick a different channel if
 			 * available on the same NUMA node.
 			 */
-			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
+			alloced_mask = &stor_device->cpumask_chns[q_num];
+			cpumask_and(alloced_mask, &stor_device->alloced_cpus,
 				    cpumask_of_node(cpu_to_node(q_num)));
-			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
-					outgoing_channel->target_cpu + 1) {
-				if (tgt_cpu != outgoing_channel->target_cpu) {
-					outgoing_channel =
-					stor_device->stor_chns[tgt_cpu];
-					break;
+
+			for_each_cpu_wrap(tgt_cpu, alloced_mask, q_num + 1) {
+				if (tgt_cpu == q_num)
+					continue;
+				channel = stor_device->stor_chns[tgt_cpu];
+				if (hv_get_avail_to_write_percent(
+							&channel->outbound)
+						> ring_avail_percent_lowater) {
+					outgoing_channel = channel;
+					goto found_channel;
+				}
+			}
+
+			/*
+			 * All the other channels on the same NUMA node are
+			 * busy. Try to use the channel on the current CPU
+			 */
+			if (hv_get_avail_to_write_percent(
+						&outgoing_channel->outbound)
+					> ring_avail_percent_lowater)
+				goto found_channel;
+
+			/*
+			 * If we reach here, all the channels on the current
+			 * NUMA node are busy. Try to find a channel in
+			 * other NUMA nodes
+			 */
+			cpumask_andnot(alloced_mask, &stor_device->alloced_cpus,
+					cpumask_of_node(cpu_to_node(q_num)));
+
+			for_each_cpu(tgt_cpu, alloced_mask) {
+				channel = stor_device->stor_chns[tgt_cpu];
+				if (hv_get_avail_to_write_percent(
+							&channel->outbound)
+						> ring_avail_percent_lowater) {
+					outgoing_channel = channel;
+					goto found_channel;
 				}
 			}
 		}
@@ -1324,7 +1376,7 @@ static int storvsc_do_io(struct hv_device *device,
 		outgoing_channel = get_og_chn(stor_device, q_num);
 	}
 
-
+found_channel:
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
 	vstor_packet->vm_srb.length = (sizeof(struct vmscsi_request) -
@@ -1732,8 +1784,9 @@ static int storvsc_probe(struct hv_device *device,
 				(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
 	}
 
-	scsi_driver.can_queue = (max_outstanding_req_per_channel *
-				 (max_sub_channels + 1));
+	scsi_driver.can_queue = max_outstanding_req_per_channel *
+				(max_sub_channels + 1) *
+				(100 - ring_avail_percent_lowater) / 100;
 
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
@@ -1864,6 +1917,7 @@ static int storvsc_probe(struct hv_device *device,
 
 err_out1:
 	kfree(stor_device->stor_chns);
+	kfree(stor_device->cpumask_chns);
 	kfree(stor_device);
 
 err_out0:
-- 
2.14.1
