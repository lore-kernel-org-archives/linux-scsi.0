From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 3/3] Storvsc: Select channel based on available percentage of
 ring buffer to write
Date: Thu, 22 Mar 2018 17:15:38 -0700
Message-ID: <20180323001538.31876-3-longli@linuxonhyperv.com>
References: <20180323001538.31876-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180323001538.31876-1-longli@linuxonhyperv.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 62 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a2ec0bc9e9fa..96681c4f75cb 100644
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
@@ -1285,9 +1291,9 @@ static int storvsc_do_io(struct hv_device *device,
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
-	struct vmbus_channel *outgoing_channel;
+	struct vmbus_channel *outgoing_channel, *channel;
 	int ret = 0;
-	struct cpumask alloced_mask;
+	struct cpumask alloced_mask, other_numa_mask;
 	int tgt_cpu;
 
 	vstor_packet = &request->vstor_packet;
@@ -1301,22 +1307,53 @@ static int storvsc_do_io(struct hv_device *device,
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
 			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
 				    cpumask_of_node(cpu_to_node(q_num)));
-			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
-					outgoing_channel->target_cpu + 1) {
-				if (tgt_cpu != outgoing_channel->target_cpu) {
-					outgoing_channel =
-					stor_device->stor_chns[tgt_cpu];
-					break;
+
+			for_each_cpu_wrap(tgt_cpu, &alloced_mask, q_num + 1) {
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
+			 * All the othe channels on the same NUMA node are
+			 * busy. Try to use the channel with the current CPU
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
+			cpumask_andnot(&other_numa_mask,
+					&stor_device->alloced_cpus,
+					cpumask_of_node(cpu_to_node(q_num)));
+
+			for_each_cpu(tgt_cpu, &other_numa_mask) {
+				channel = stor_device->stor_chns[tgt_cpu];
+				if (hv_get_avail_to_write_percent(
+							&channel->outbound)
+						> ring_avail_percent_lowater) {
+					outgoing_channel = channel;
+					goto found_channel;
 				}
 			}
 		}
@@ -1324,7 +1361,7 @@ static int storvsc_do_io(struct hv_device *device,
 		outgoing_channel = get_og_chn(stor_device, q_num);
 	}
 
-
+found_channel:
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
 	vstor_packet->vm_srb.length = (sizeof(struct vmscsi_request) -
@@ -1733,7 +1770,8 @@ static int storvsc_probe(struct hv_device *device,
 	}
 
 	scsi_driver.can_queue = (max_outstanding_req_per_channel *
-				 (max_sub_channels + 1));
+				 (max_sub_channels + 1)) *
+				 (100 - ring_avail_percent_lowater) / 100;
 
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
-- 
2.14.1
