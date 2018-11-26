From: kys@linuxonhyperv.com
Subject: [PATCH] scsi: storvsc: Fix a race in sub-channel creation that can cause panic
Date: Mon, 26 Nov 2018 00:26:17 +0000
Message-ID: <20181126002617.7398-1-kys@linuxonhyperv.com>
Reply-To: kys@microsoft.com
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
Cc: Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org, Long Li <longli@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

We can concurrently try to open the same sub-channel from 2 paths:

path #1: vmbus_onoffer() -> vmbus_process_offer() -> handle_sc_creation().
path #2: storvsc_probe() -> storvsc_connect_to_vsp() ->
	 -> storvsc_channel_init() -> handle_multichannel_storage() ->
	 -> vmbus_are_subchannels_present() -> handle_sc_creation().

They conflict with each other, but it was not an issue before the recent
commit ae6935ed7d42 ("vmbus: split ring buffer allocation from open"),
because at the beginning of vmbus_open() we checked newchannel->state so
only one path could succeed, and the other would return with -EINVAL.

After ae6935ed7d42, the failing path frees the channel's ringbuffer by
vmbus_free_ring(), and this causes a panic later.

Commit ae6935ed7d42 itself is good, and it just reveals the longstanding
race. We can resolve the issue by removing path #2, i.e. removing the
second vmbus_are_subchannels_present() in handle_multichannel_storage().

BTW, the comment "Check to see if sub-channels have already been created"
in handle_multichannel_storage() is incorrect: when we unload the driver,
we first close the sub-channel(s) and then close the primary channel, next
the host sends rescind-offer message(s) so primary->sc_list will become
empty. This means the first vmbus_are_subchannels_present() in
handle_multichannel_storage() is never useful.

Fixes: ae6935ed7d42 ("vmbus: split ring buffer allocation from open")
Cc: stable@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 61 +++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f03dc03a42c3..8f88348ebe42 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -446,7 +446,6 @@ struct storvsc_device {
 
 	bool	 destroy;
 	bool	 drain_notify;
-	bool	 open_sub_channel;
 	atomic_t num_outstanding_req;
 	struct Scsi_Host *host;
 
@@ -636,33 +635,38 @@ static inline struct storvsc_device *get_in_stor_device(
 static void handle_sc_creation(struct vmbus_channel *new_sc)
 {
 	struct hv_device *device = new_sc->primary_channel->device_obj;
+	struct device *dev = &device->device;
 	struct storvsc_device *stor_device;
 	struct vmstorage_channel_properties props;
+	int ret;
 
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return;
 
-	if (stor_device->open_sub_channel == false)
-		return;
-
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	vmbus_open(new_sc,
-		   storvsc_ringbuffer_size,
-		   storvsc_ringbuffer_size,
-		   (void *)&props,
-		   sizeof(struct vmstorage_channel_properties),
-		   storvsc_on_channel_callback, new_sc);
+	ret = vmbus_open(new_sc,
+			 storvsc_ringbuffer_size,
+			 storvsc_ringbuffer_size,
+			 (void *)&props,
+			 sizeof(struct vmstorage_channel_properties),
+			 storvsc_on_channel_callback, new_sc);
 
-	if (new_sc->state == CHANNEL_OPENED_STATE) {
-		stor_device->stor_chns[new_sc->target_cpu] = new_sc;
-		cpumask_set_cpu(new_sc->target_cpu, &stor_device->alloced_cpus);
+	/* In case vmbus_open() fails, we don't use the sub-channel. */
+	if (ret != 0) {
+		dev_err(dev, "Failed to open sub-channel: err=%d\n", ret);
+		return;
 	}
+
+	/* Add the sub-channel to the array of available channels. */
+	stor_device->stor_chns[new_sc->target_cpu] = new_sc;
+	cpumask_set_cpu(new_sc->target_cpu, &stor_device->alloced_cpus);
 }
 
 static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 {
+	struct device *dev = &device->device;
 	struct storvsc_device *stor_device;
 	int num_cpus = num_online_cpus();
 	int num_sc;
@@ -679,21 +683,11 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	request = &stor_device->init_request;
 	vstor_packet = &request->vstor_packet;
 
-	stor_device->open_sub_channel = true;
 	/*
 	 * Establish a handler for dealing with subchannels.
 	 */
 	vmbus_set_sc_create_callback(device->channel, handle_sc_creation);
 
-	/*
-	 * Check to see if sub-channels have already been created. This
-	 * can happen when this driver is re-loaded after unloading.
-	 */
-
-	if (vmbus_are_subchannels_present(device->channel))
-		return;
-
-	stor_device->open_sub_channel = false;
 	/*
 	 * Request the host to create sub-channels.
 	 */
@@ -710,23 +704,29 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
-	if (ret != 0)
+	if (ret != 0) {
+		dev_err(dev, "Failed to create sub-channel: err=%d\n", ret);
 		return;
+	}
 
 	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
-	if (t == 0)
+	if (t == 0) {
+		dev_err(dev, "Failed to create sub-channel: timed out\n");
 		return;
+	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	    vstor_packet->status != 0) {
+		dev_err(dev, "Failed to create sub-channel: op=%d, sts=%d\n",
+			vstor_packet->operation, vstor_packet->status);
 		return;
+	}
 
 	/*
-	 * Now that we created the sub-channels, invoke the check; this
-	 * may trigger the callback.
+	 * We need to do nothing here, because vmbus_process_offer()
+	 * invokes channel->sc_creation_callback, which will open and use
+	 * the sub-channel(s).
 	 */
-	stor_device->open_sub_channel = true;
-	vmbus_are_subchannels_present(device->channel);
 }
 
 static void cache_wwn(struct storvsc_device *stor_device,
@@ -1794,7 +1794,6 @@ static int storvsc_probe(struct hv_device *device,
 	}
 
 	stor_device->destroy = false;
-	stor_device->open_sub_channel = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
 	stor_device->host = host;
-- 
2.19.1
