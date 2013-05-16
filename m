From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 5/7] Drivers: scsi: storvsc: Implement multi-channel support
Date: Thu, 16 May 2013 05:21:17 -0700
Message-ID: <1368706879-32321-5-git-send-email-kys@microsoft.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1368706879-32321-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

Implement multi-channel support for the storage devices.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  124 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a3cf85c..6bc4e3b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -330,6 +330,8 @@ MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
 
 #define STORVSC_MAX_IO_REQUESTS				128
 
+static void storvsc_on_channel_callback(void *context);
+
 /*
  * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
  * reality, the path/target is not used (ie always set to 0) so our
@@ -757,12 +759,99 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	return total_copied;
 }
 
+static void handle_sc_creation(struct vmbus_channel *new_sc)
+{
+	struct hv_device *device = new_sc->primary_channel->device_obj;
+	struct storvsc_device *stor_device;
+	struct vmstorage_channel_properties props;
+
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return;
+
+
+	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
+
+	vmbus_open(new_sc,
+		   storvsc_ringbuffer_size,
+		   storvsc_ringbuffer_size,
+		   (void *)&props,
+		   sizeof(struct vmstorage_channel_properties),
+		   storvsc_on_channel_callback, new_sc);
+}
+
+static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
+{
+	struct storvsc_device *stor_device;
+	int num_cpus = num_online_cpus();
+	int num_sc;
+	struct storvsc_cmd_request *request;
+	struct vstor_packet *vstor_packet;
+	int ret, t;
+
+	num_sc = ((max_chns > num_cpus) ? num_cpus : max_chns);
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return;
+
+	request = &stor_device->init_request;
+	vstor_packet = &request->vstor_packet;
+
+	/*
+	 * Establish a handler for dealing with subchannels.
+	 */
+	vmbus_set_sc_create_callback(device->channel, handle_sc_creation);
+
+	/*
+	 * Check to see if sub-channels have already been created. This
+	 * can happen when this driver is re-loaded after unloading.
+	 */
+
+	if (vmbus_are_subchannels_present(device->channel))
+		return;
+
+	/*
+	 * Request the host to create sub-channels.
+	 */
+	memset(request, 0, sizeof(struct storvsc_cmd_request));
+	init_completion(&request->wait_event);
+	vstor_packet->operation = VSTOR_OPERATION_CREATE_SUB_CHANNELS;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->sub_channel_count = num_sc;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       (sizeof(struct vstor_packet) -
+			       vmscsi_size_delta),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	if (ret != 0)
+		return;
+
+	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
+	if (t == 0)
+		return;
+
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0)
+		return;
+
+	/*
+	 * Now that we created the sub-channels, invoke the check; this
+	 * will trigger the callback.
+	 */
+	vmbus_are_subchannels_present(device->channel);
+}
+
 static int storvsc_channel_init(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
+	int max_chns;
+	bool process_sub_channels = false;
 
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
@@ -857,6 +946,19 @@ static int storvsc_channel_init(struct hv_device *device)
 	    vstor_packet->status != 0)
 		goto cleanup;
 
+	/*
+	 * Check to see if multi-channel support is there.
+	 * Hosts that implement protocol version of 5.1 and above
+	 * support multi-channel.
+	 */
+	max_chns = vstor_packet->storage_channel_properties.max_channel_cnt;
+	if ((vmbus_proto_version != VERSION_WIN7) &&
+	   (vmbus_proto_version != VERSION_WS2008))  {
+		if (vstor_packet->storage_channel_properties.flags &
+		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
+			process_sub_channels = true;
+	}
+
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
@@ -881,6 +983,9 @@ static int storvsc_channel_init(struct hv_device *device)
 	    vstor_packet->status != 0)
 		goto cleanup;
 
+	if (process_sub_channels)
+		handle_multichannel_storage(device, max_chns);
+
 
 cleanup:
 	return ret;
@@ -1102,7 +1207,8 @@ static void storvsc_on_receive(struct hv_device *device,
 
 static void storvsc_on_channel_callback(void *context)
 {
-	struct hv_device *device = (struct hv_device *)context;
+	struct vmbus_channel *channel = (struct vmbus_channel *)context;
+	struct hv_device *device;
 	struct storvsc_device *stor_device;
 	u32 bytes_recvd;
 	u64 request_id;
@@ -1110,13 +1216,17 @@ static void storvsc_on_channel_callback(void *context)
 	struct storvsc_cmd_request *request;
 	int ret;
 
+	if (channel->primary_channel != NULL)
+		device = channel->primary_channel->device_obj;
+	else
+		device = channel->device_obj;
 
 	stor_device = get_in_stor_device(device);
 	if (!stor_device)
 		return;
 
 	do {
-		ret = vmbus_recvpacket(device->channel, packet,
+		ret = vmbus_recvpacket(channel, packet,
 				       ALIGN((sizeof(struct vstor_packet) -
 					     vmscsi_size_delta), 8),
 				       &bytes_recvd, &request_id);
@@ -1157,7 +1267,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 			 ring_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
-			 storvsc_on_channel_callback, device);
+			 storvsc_on_channel_callback, device->channel);
 
 	if (ret != 0)
 		return ret;
@@ -1209,6 +1319,7 @@ static int storvsc_do_io(struct hv_device *device,
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
+	struct vmbus_channel *outgoing_channel;
 	int ret = 0;
 
 	vstor_packet = &request->vstor_packet;
@@ -1219,6 +1330,11 @@ static int storvsc_do_io(struct hv_device *device,
 
 
 	request->device  = device;
+	/*
+	 * Select an an appropriate channel to send the request out.
+	 */
+
+	outgoing_channel = vmbus_get_outgoing_channel(device->channel);
 
 
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
@@ -1236,7 +1352,7 @@ static int storvsc_do_io(struct hv_device *device,
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
 	if (request->data_buffer.len) {
-		ret = vmbus_sendpacket_multipagebuffer(device->channel,
+		ret = vmbus_sendpacket_multipagebuffer(outgoing_channel,
 				&request->data_buffer,
 				vstor_packet,
 				(sizeof(struct vstor_packet) -
-- 
1.7.4.1
