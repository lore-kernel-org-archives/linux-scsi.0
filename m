From: kys@exchange.microsoft.com
Subject: [PATCH 3/6] storvsc: Enable multi-queue support
Date: Wed, 14 Dec 2016 18:46:00 -0800
Message-ID: <1481769963-2069-3-git-send-email-kys@exchange.microsoft.com>
References: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
 <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: K. Y. Srinivasan <kys@microsoft.com>

Enable multi-q support. We will allocate the outgoing channel using
the following policy:

        1. We will make every effort to pick a channel that is in the
           same NUMA node that is initiating the I/O
        2. The mapping between the guest CPU and the outgoing channel
           is persistent.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  113 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3b1c2f6..63f6b1a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -458,6 +458,15 @@ struct storvsc_device {
 	 * Max I/O, the device can support.
 	 */
 	u32   max_transfer_bytes;
+	/*
+	 * Number of sub-channels we will open.
+	 */
+	u16 num_sc;
+	struct vmbus_channel **stor_chns;
+	/*
+	 * Mask of CPUs bound to subchannels.
+	 */
+	struct cpumask alloced_cpus;
 	/* Used for vsc/vsp channel reset process */
 	struct storvsc_cmd_request init_request;
 	struct storvsc_cmd_request reset_request;
@@ -635,6 +644,11 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 		   (void *)&props,
 		   sizeof(struct vmstorage_channel_properties),
 		   storvsc_on_channel_callback, new_sc);
+
+	if (new_sc->state == CHANNEL_OPENED_STATE) {
+		stor_device->stor_chns[new_sc->target_cpu] = new_sc;
+		cpumask_set_cpu(new_sc->target_cpu, &stor_device->alloced_cpus);
+	}
 }
 
 static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
@@ -651,6 +665,7 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	if (!stor_device)
 		return;
 
+	stor_device->num_sc = num_sc;
 	request = &stor_device->init_request;
 	vstor_packet = &request->vstor_packet;
 
@@ -838,6 +853,25 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 	 * support multi-channel.
 	 */
 	max_chns = vstor_packet->storage_channel_properties.max_channel_cnt;
+
+	/*
+	 * Allocate state to manage the sub-channels.
+	 * We allocate an array based on the numbers of possible CPUs
+	 * (Hyper-V does not support cpu online/offline).
+	 * This Array will be sparseley populated with unique
+	 * channels - primary + sub-channels.
+	 * We will however populate all the slots to evenly distribute
+	 * the load.
+	 */
+	stor_device->stor_chns = kzalloc(sizeof(void *) * num_possible_cpus(),
+					 GFP_KERNEL);
+	if (stor_device->stor_chns == NULL)
+		return -ENOMEM;
+
+	stor_device->stor_chns[device->channel->target_cpu] = device->channel;
+	cpumask_set_cpu(device->channel->target_cpu,
+			&stor_device->alloced_cpus);
+
 	if (vmstor_proto_version >= VMSTOR_PROTO_VERSION_WIN8) {
 		if (vstor_packet->storage_channel_properties.flags &
 		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
@@ -1198,17 +1232,64 @@ static int storvsc_dev_remove(struct hv_device *device)
 	/* Close the channel */
 	vmbus_close(device->channel);
 
+	kfree(stor_device->stor_chns);
 	kfree(stor_device);
 	return 0;
 }
 
+static struct vmbus_channel *get_og_chn(struct storvsc_device *stor_device,
+					u16 q_num)
+{
+	u16 slot = 0;
+	u16 hash_qnum;
+	struct cpumask alloced_mask;
+	int num_channels, tgt_cpu;
+
+	if (stor_device->num_sc == 0)
+		return stor_device->device->channel;
+
+	/*
+	 * Our channel array is sparsley populated and we
+	 * initiated I/O on a processor/hw-q that does not
+	 * currently have a designated channel. Fix this.
+	 * The strategy is simple:
+	 * I. Ensure NUMA locality
+	 * II. Distribute evenly (best effort)
+	 * III. Mapping is persistent.
+	 */
+
+	cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
+		    cpumask_of_node(cpu_to_node(q_num)));
+
+	num_channels = cpumask_weight(&alloced_mask);
+	if (num_channels == 0)
+		return stor_device->device->channel;
+
+	hash_qnum = q_num;
+	while (hash_qnum >= num_channels)
+		hash_qnum -= num_channels;
+
+	for_each_cpu(tgt_cpu, &alloced_mask) {
+		if (slot == hash_qnum)
+			break;
+		slot++;
+	}
+
+	stor_device->stor_chns[q_num] = stor_device->stor_chns[tgt_cpu];
+
+	return stor_device->stor_chns[q_num];
+}
+
+
 static int storvsc_do_io(struct hv_device *device,
-			 struct storvsc_cmd_request *request)
+			 struct storvsc_cmd_request *request, u16 q_num)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
 	struct vmbus_channel *outgoing_channel;
 	int ret = 0;
+	struct cpumask alloced_mask;
+	int tgt_cpu;
 
 	vstor_packet = &request->vstor_packet;
 	stor_device = get_out_stor_device(device);
@@ -1222,7 +1303,26 @@ static int storvsc_do_io(struct hv_device *device,
 	 * Select an an appropriate channel to send the request out.
 	 */
 
-	outgoing_channel = vmbus_get_outgoing_channel(device->channel);
+	if (stor_device->stor_chns[q_num] != NULL) {
+		outgoing_channel = stor_device->stor_chns[q_num];
+		if (outgoing_channel->target_cpu == smp_processor_id()) {
+			/*
+			 * Ideally, we want to pick a different channel if
+			 * available on the same NUMA node.
+			 */
+			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
+				    cpumask_of_node(cpu_to_node(q_num)));
+			for_each_cpu(tgt_cpu, &alloced_mask) {
+				if (tgt_cpu != outgoing_channel->target_cpu) {
+					outgoing_channel =
+					stor_device->stor_chns[tgt_cpu];
+					break;
+				}
+			}
+		}
+	} else {
+		outgoing_channel = get_og_chn(stor_device, q_num);
+	}
 
 
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
@@ -1522,7 +1622,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	cmd_request->payload_sz = payload_sz;
 
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_do_io(dev, cmd_request);
+	ret = storvsc_do_io(dev, cmd_request, get_cpu());
+	put_cpu();
 
 	if (ret == -EAGAIN) {
 		/* no more space */
@@ -1679,6 +1780,11 @@ static int storvsc_probe(struct hv_device *device,
 	 * from the host.
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+	/*
+	 * Set the number of HW queues we are supporting.
+	 */
+	if (stor_device->num_sc != 0)
+		host->nr_hw_queues = stor_device->num_sc + 1;
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
@@ -1715,6 +1821,7 @@ static int storvsc_probe(struct hv_device *device,
 	goto err_out0;
 
 err_out1:
+	kfree(stor_device->stor_chns);
 	kfree(stor_device);
 
 err_out0:
-- 
1.7.4.1
