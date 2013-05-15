From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/6] Drivers: hv: vmbus: Implement multi-channel support
Date: Wed, 15 May 2013 15:02:29 -0700
Message-ID: <1368655354-27651-1-git-send-email-kys@microsoft.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368655320-27599-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Starting with Win8, the host supports multiple sub-channels for a given
device. As in the past, the initial channel offer specifies the device and
is associated with both the type and the instance GUIDs. For performance
critical devices, the host may support multiple sub-channels. The sub-channels
share the same type and instance GUID as the primary channel. The number of
sub-channels offerrred to the guest depends on the number of virtual CPUs
assigned to the guest. The guest can request the creation of these sub-channels
and once created and opened, the guest can distribute the traffic across all
the channels (the primary and the sub-channels). A request sent on a sub-channel
will have the response delivered on the same sub-channel.

At channel (sub-channel) creation we bind the channel interrupt to a CPU and
with this sub-channel support we will be able to spread the interrupt load
of a given device across all available CPUs.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |   41 ++++++++++++++--
 drivers/hv/channel_mgmt.c |  117 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/hyperv.h    |   62 +++++++++++++++++++++++-
 3 files changed, 211 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 0b122f8..c219e9f 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -216,6 +216,9 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	list_del(&open_info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
+	if (err == 0)
+		newchannel->state = CHANNEL_OPENED_STATE;
+
 	kfree(open_info);
 	return err;
 
@@ -500,15 +503,14 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
 
-/*
- * vmbus_close - Close the specified channel
- */
-void vmbus_close(struct vmbus_channel *channel)
+static void vmbus_close_internal(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	int ret;
 	unsigned long flags;
 
+	channel->state = CHANNEL_OPEN_STATE;
+	channel->sc_creation_callback = NULL;
 	/* Stop callback and cancel the timer asap */
 	spin_lock_irqsave(&channel->inbound_lock, flags);
 	channel->onchannel_callback = NULL;
@@ -538,6 +540,37 @@ void vmbus_close(struct vmbus_channel *channel)
 
 
 }
+
+/*
+ * vmbus_close - Close the specified channel
+ */
+void vmbus_close(struct vmbus_channel *channel)
+{
+	struct list_head *cur, *tmp;
+	struct vmbus_channel *cur_channel;
+
+	if (channel->primary_channel != NULL) {
+		/*
+		 * We will only close sub-channels when
+		 * the primary is closed.
+		 */
+		return;
+	}
+	/*
+	 * Close all the sub-channels first and then close the
+	 * primary channel.
+	 */
+	list_for_each_safe(cur, tmp, &channel->sc_list) {
+		cur_channel = list_entry(cur, struct vmbus_channel, sc_list);
+		if (cur_channel->state != CHANNEL_OPENED_STATE)
+			continue;
+		vmbus_close_internal(cur_channel);
+	}
+	/*
+	 * Now close the primary.
+	 */
+	vmbus_close_internal(channel);
+}
 EXPORT_SYMBOL_GPL(vmbus_close);
 
 /**
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 21ef689..834dff3 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -115,6 +115,9 @@ static struct vmbus_channel *alloc_channel(void)
 		return NULL;
 
 	spin_lock_init(&channel->inbound_lock);
+	spin_lock_init(&channel->sc_lock);
+
+	INIT_LIST_HEAD(&channel->sc_list);
 
 	channel->controlwq = create_workqueue("hv_vmbus_ctl");
 	if (!channel->controlwq) {
@@ -166,6 +169,7 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 						     struct vmbus_channel,
 						     work);
 	unsigned long flags;
+	struct vmbus_channel *primary_channel;
 	struct vmbus_channel_relid_released msg;
 
 	vmbus_device_unregister(channel->device_obj);
@@ -174,9 +178,16 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
 	vmbus_post_msg(&msg, sizeof(struct vmbus_channel_relid_released));
 
-	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
-	list_del(&channel->listentry);
-	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
+	if (channel->primary_channel == NULL) {
+		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
+		list_del(&channel->listentry);
+		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
+	} else {
+		primary_channel = channel->primary_channel;
+		spin_lock_irqsave(&primary_channel->sc_lock, flags);
+		list_del(&channel->listentry);
+		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
+	}
 	free_channel(channel);
 }
 
@@ -228,6 +239,21 @@ static void vmbus_process_offer(struct work_struct *work)
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 	if (!fnew) {
+		/*
+		 * Check to see if this is a sub-channel.
+		 */
+		if (newchannel->offermsg.offer.sub_channel_index != 0) {
+			/*
+			 * Process the sub-channel.
+			 */
+			newchannel->primary_channel = channel;
+			spin_lock_irqsave(&channel->sc_lock, flags);
+			list_add_tail(&newchannel->sc_list, &channel->sc_list);
+			spin_unlock_irqrestore(&channel->sc_lock, flags);
+			newchannel->state = CHANNEL_OPEN_STATE;
+			return;
+		}
+
 		free_channel(newchannel);
 		return;
 	}
@@ -685,4 +711,87 @@ cleanup:
 	return ret;
 }
 
-/* eof */
+/*
+ * Retrieve the (sub) channel on which to send an outgoing request.
+ * When a primary channel has multiple sub-channels, we choose a
+ * channel whose VCPU binding is closest to the VCPU on which
+ * this call is being made.
+ */
+struct vmbus_channel *get_outgoing_channel(struct vmbus_channel *primary)
+{
+	struct list_head *cur, *tmp;
+	int cur_cpu = hv_context.vp_index[smp_processor_id()];
+	struct vmbus_channel *cur_channel;
+	struct vmbus_channel *outgoing_channel = primary;
+	int cpu_distance, new_cpu_distance;
+
+	if (list_empty(&primary->sc_list))
+		return outgoing_channel;
+
+	list_for_each_safe(cur, tmp, &primary->sc_list) {
+		cur_channel = list_entry(cur, struct vmbus_channel, sc_list);
+		if (cur_channel->state != CHANNEL_OPENED_STATE)
+			continue;
+
+		if (cur_channel->target_vp == cur_cpu)
+			return cur_channel;
+
+		cpu_distance = ((outgoing_channel->target_vp > cur_cpu) ?
+				(outgoing_channel->target_vp - cur_cpu) :
+				(cur_cpu - outgoing_channel->target_vp));
+
+		new_cpu_distance = ((cur_channel->target_vp > cur_cpu) ?
+				(cur_channel->target_vp - cur_cpu) :
+				(cur_cpu - cur_channel->target_vp));
+
+		if (cpu_distance < new_cpu_distance)
+			continue;
+
+		outgoing_channel = cur_channel;
+	}
+
+	return outgoing_channel;
+}
+EXPORT_SYMBOL_GPL(get_outgoing_channel);
+
+static void invoke_sc_cb(struct vmbus_channel *primary_channel)
+{
+	struct list_head *cur, *tmp;
+	struct vmbus_channel *cur_channel;
+
+	if (primary_channel->sc_creation_callback == NULL)
+		return;
+
+	list_for_each_safe(cur, tmp, &primary_channel->sc_list) {
+		cur_channel = list_entry(cur, struct vmbus_channel, sc_list);
+
+		primary_channel->sc_creation_callback(cur_channel);
+	}
+}
+
+void set_sc_create_callback(struct vmbus_channel *primary_channel,
+				void (*sc_cr_cb)(struct vmbus_channel *new_sc))
+{
+	primary_channel->sc_creation_callback = sc_cr_cb;
+	invoke_sc_cb(primary_channel);
+}
+EXPORT_SYMBOL_GPL(set_sc_create_callback);
+
+bool subchannels_present(struct vmbus_channel *primary)
+{
+	bool ret;
+
+	ret = !list_empty(&primary->sc_list);
+
+	if (ret) {
+		/*
+		 * Invoke the callback on sub-channel creation.
+		 * This will present a uniform interface to the
+		 * clients.
+		 */
+		invoke_sc_cb(primary);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(subchannels_present);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index c255984..a1a97a7 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -909,6 +909,7 @@ enum vmbus_channel_state {
 	CHANNEL_OFFER_STATE,
 	CHANNEL_OPENING_STATE,
 	CHANNEL_OPEN_STATE,
+	CHANNEL_OPENED_STATE,
 };
 
 struct vmbus_channel_debug_info {
@@ -1046,6 +1047,38 @@ struct vmbus_channel {
 	 * preserve the earlier behavior.
 	 */
 	u32 target_vp;
+	/*
+	 * Support for sub-channels. For high performance devices,
+	 * it will be useful to have multiple sub-channels to support
+	 * a scalable communication infrastructure with the host.
+	 * The support for sub-channels is implemented as an extention
+	 * to the current infrastructure.
+	 * The initial offer is considered the primary channel and this
+	 * offer message will indicate if the host supports sub-channels.
+	 * The guest is free to ask for sub-channels to be offerred and can
+	 * open these sub-channels as a normal "primary" channel. However,
+	 * all sub-channels will have the same type and instance guids as the
+	 * primary channel. Requests sent on a given channel will result in a
+	 * response on the same channel.
+	 */
+
+	/*
+	 * Sub-channel creation callback. This callback will be called in
+	 * process context when a sub-channel offer is received from the host.
+	 * The guest can open the sub-channel in the context of this callback.
+	 */
+	void (*sc_creation_callback)(struct vmbus_channel *new_sc);
+
+	spinlock_t sc_lock;
+	/*
+	 * All Sub-channels of a primary channel are linked here.
+	 */
+	struct list_head sc_list;
+	/*
+	 * The primary channel this sub-channel belongs to.
+	 * This will be NULL for the primary channel.
+	 */
+	struct vmbus_channel *primary_channel;
 };
 
 static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
@@ -1057,6 +1090,34 @@ void vmbus_onmessage(void *context);
 
 int vmbus_request_offers(void);
 
+/*
+ * APIs for managing sub-channels.
+ */
+
+void set_sc_create_callback(struct vmbus_channel *primary_channel,
+			void (*sc_cr_cb)(struct vmbus_channel *new_sc));
+
+/*
+ * Retrieve the (sub) channel on which to send an outgoing request.
+ * When a primary channel has multiple sub-channels, we choose a
+ * channel whose VCPU binding is closest to the VCPU on which
+ * this call is being made.
+ */
+struct vmbus_channel *get_outgoing_channel(struct vmbus_channel *primary);
+
+/*
+ * Check if sub-channels have already been offerred. This API will be useful
+ * when the driver is unloaded after establishing sub-channels. In this case,
+ * when the driver is re-loaded, the driver would have to check if the
+ * subchannels have already been established before attempting to request
+ * the creation of sub-channels.
+ * This function returns TRUE to indicate that subchannels have already been
+ * created.
+ * This function should be invoked after setting the callback function for
+ * sub-channel creation.
+ */
+bool subchannels_present(struct vmbus_channel *primary);
+
 /* The format must be the same as struct vmdata_gpa_direct */
 struct vmbus_channel_packet_page_buffer {
 	u16 type;
@@ -1327,7 +1388,6 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 			0x8e, 0x77, 0x05, 0x58, 0xeb, 0x10, 0x73, 0xf8 \
 		}
 
-
 /*
  * Common header for Hyper-V ICs
  */
-- 
1.7.4.1
