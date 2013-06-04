From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/5] Drivers: scsi: storvsc: Update the storage protocol to
 win8 level
Date: Tue,  4 Jun 2013 12:05:06 -0700
Message-ID: <1370372709-10098-2-git-send-email-kys@microsoft.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
 <1370372709-10098-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1370372709-10098-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Update the storage protocol to the win8 level.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  203 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 168 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ede8694..9451989 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -55,10 +55,15 @@
  * V1 RC < 2008/1/31: 1.0
  * V1 RC > 2008/1/31:  2.0
  * Win7: 4.2
+ * Win8: 5.1
  */
 
-#define VMSTOR_CURRENT_MAJOR  4
-#define VMSTOR_CURRENT_MINOR  2
+
+#define VMSTOR_WIN7_MAJOR 4
+#define VMSTOR_WIN7_MINOR 2
+
+#define VMSTOR_WIN8_MAJOR 5
+#define VMSTOR_WIN8_MINOR 1
 
 
 /*  Packet structure describing virtual storage requests. */
@@ -74,18 +79,103 @@ enum vstor_packet_operation {
 	VSTOR_OPERATION_QUERY_PROTOCOL_VERSION	= 9,
 	VSTOR_OPERATION_QUERY_PROPERTIES	= 10,
 	VSTOR_OPERATION_ENUMERATE_BUS		= 11,
-	VSTOR_OPERATION_MAXIMUM			= 11
+	VSTOR_OPERATION_FCHBA_DATA              = 12,
+	VSTOR_OPERATION_CREATE_SUB_CHANNELS     = 13,
+	VSTOR_OPERATION_MAXIMUM                 = 13
+};
+
+/*
+ * WWN packet for Fibre Channel HBA
+ */
+
+struct hv_fc_wwn_packet {
+	bool	primary_active;
+	u8	reserved1;
+	u8	reserved2;
+	u8	primary_port_wwn[8];
+	u8	primary_node_wwn[8];
+	u8	secondary_port_wwn[8];
+	u8	secondary_node_wwn[8];
 };
 
+
+
+/*
+ * SRB Flag Bits
+ */
+
+#define SRB_FLAGS_QUEUE_ACTION_ENABLE		0x00000002
+#define SRB_FLAGS_DISABLE_DISCONNECT		0x00000004
+#define SRB_FLAGS_DISABLE_SYNCH_TRANSFER	0x00000008
+#define SRB_FLAGS_BYPASS_FROZEN_QUEUE		0x00000010
+#define SRB_FLAGS_DISABLE_AUTOSENSE		0x00000020
+#define SRB_FLAGS_DATA_IN			0x00000040
+#define SRB_FLAGS_DATA_OUT			0x00000080
+#define SRB_FLAGS_NO_DATA_TRANSFER		0x00000000
+#define SRB_FLAGS_UNSPECIFIED_DIRECTION	(SRB_FLAGS_DATA_IN | SRB_FLAGS_DATA_OUT)
+#define SRB_FLAGS_NO_QUEUE_FREEZE		0x00000100
+#define SRB_FLAGS_ADAPTER_CACHE_ENABLE		0x00000200
+#define SRB_FLAGS_FREE_SENSE_BUFFER		0x00000400
+
+/*
+ * This flag indicates the request is part of the workflow for processing a D3.
+ */
+#define SRB_FLAGS_D3_PROCESSING			0x00000800
+#define SRB_FLAGS_IS_ACTIVE			0x00010000
+#define SRB_FLAGS_ALLOCATED_FROM_ZONE		0x00020000
+#define SRB_FLAGS_SGLIST_FROM_POOL		0x00040000
+#define SRB_FLAGS_BYPASS_LOCKED_QUEUE		0x00080000
+#define SRB_FLAGS_NO_KEEP_AWAKE			0x00100000
+#define SRB_FLAGS_PORT_DRIVER_ALLOCSENSE	0x00200000
+#define SRB_FLAGS_PORT_DRIVER_SENSEHASPORT	0x00400000
+#define SRB_FLAGS_DONT_START_NEXT_PACKET	0x00800000
+#define SRB_FLAGS_PORT_DRIVER_RESERVED		0x0F000000
+#define SRB_FLAGS_CLASS_DRIVER_RESERVED		0xF0000000
+
+
 /*
  * Platform neutral description of a scsi request -
  * this remains the same across the write regardless of 32/64 bit
  * note: it's patterned off the SCSI_PASS_THROUGH structure
  */
 #define STORVSC_MAX_CMD_LEN			0x10
-#define STORVSC_SENSE_BUFFER_SIZE		0x12
+
+#define POST_WIN7_STORVSC_SENSE_BUFFER_SIZE	0x14
+#define PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE	0x12
+
+#define STORVSC_SENSE_BUFFER_SIZE		0x14
 #define STORVSC_MAX_BUF_LEN_WITH_PADDING	0x14
 
+/*
+ * Sense buffer size changed in win8; have a run-time
+ * variable to track the size we should use.
+ */
+static int sense_buffer_size;
+
+/*
+ * The size of the vmscsi_request has changed in win8. The
+ * additional size is because of new elements added to the
+ * structure. These elements are valid only when we are talking
+ * to a win8 host.
+ * Track the correction to size we need to apply.
+ */
+
+static int vmscsi_size_delta;
+static int vmstor_current_major;
+static int vmstor_current_minor;
+
+struct vmscsi_win8_extension {
+	/*
+	 * The following were added in Windows 8
+	 */
+	u16 reserve;
+	u8  queue_tag;
+	u8  queue_action;
+	u32 srb_flags;
+	u32 time_out_value;
+	u32 queue_sort_ey;
+} __packed;
+
 struct vmscsi_request {
 	u16 length;
 	u8 srb_status;
@@ -108,6 +198,11 @@ struct vmscsi_request {
 		u8 sense_data[STORVSC_SENSE_BUFFER_SIZE];
 		u8 reserved_array[STORVSC_MAX_BUF_LEN_WITH_PADDING];
 	};
+	/*
+	 * The following was added in win8.
+	 */
+	struct vmscsi_win8_extension win8_extension;
+
 } __attribute((packed));
 
 
@@ -115,22 +210,18 @@ struct vmscsi_request {
  * This structure is sent during the intialization phase to get the different
  * properties of the channel.
  */
+
+#define STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL		0x1
+
 struct vmstorage_channel_properties {
-	u16 protocol_version;
-	u8  path_id;
-	u8 target_id;
+	u32 reserved;
+	u16 max_channel_cnt;
+	u16 reserved1;
 
-	/* Note: port number is only really known on the client side */
-	u32  port_number;
-	u32  flags;
+	u32 flags;
 	u32   max_transfer_bytes;
 
-	/*
-	 * This id is unique for each channel and will correspond with
-	 * vendor specific data in the inquiry data.
-	 */
-
-	u64  unique_id;
+	u64  reserved2;
 } __packed;
 
 /*  This structure is sent during the storage protocol negotiations. */
@@ -175,6 +266,15 @@ struct vstor_packet {
 
 		/* Used during version negotiations. */
 		struct vmstorage_protocol_version version;
+
+		/* Fibre channel address packet */
+		struct hv_fc_wwn_packet wwn_packet;
+
+		/* Number of sub-channels to create */
+		u16 sub_channel_count;
+
+		/* This will be the maximum of the union members */
+		u8  buffer[0x34];
 	};
 } __packed;
 
@@ -679,7 +779,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+			       vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -703,7 +804,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	vstor_packet->version.major_minor =
-		storvsc_get_version(VMSTOR_CURRENT_MAJOR, VMSTOR_CURRENT_MINOR);
+		storvsc_get_version(vmstor_current_major, vmstor_current_minor);
 
 	/*
 	 * The revision number is only used in Windows; set it to 0.
@@ -711,7 +812,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	vstor_packet->version.revision = 0;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -732,11 +834,10 @@ static int storvsc_channel_init(struct hv_device *device)
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-	vstor_packet->storage_channel_properties.port_number =
-					stor_device->port_number;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -754,16 +855,13 @@ static int storvsc_channel_init(struct hv_device *device)
 	    vstor_packet->status != 0)
 		goto cleanup;
 
-	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
-	stor_device->target_id
-		= vstor_packet->storage_channel_properties.target_id;
-
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -1017,7 +1115,8 @@ static void storvsc_on_channel_callback(void *context)
 
 	do {
 		ret = vmbus_recvpacket(device->channel, packet,
-				       ALIGN(sizeof(struct vstor_packet), 8),
+				       ALIGN((sizeof(struct vstor_packet) -
+					     vmscsi_size_delta), 8),
 				       &bytes_recvd, &request_id);
 		if (ret == 0 && bytes_recvd > 0) {
 
@@ -1028,7 +1127,8 @@ static void storvsc_on_channel_callback(void *context)
 			    (request == &stor_device->reset_request)) {
 
 				memcpy(&request->vstor_packet, packet,
-				       sizeof(struct vstor_packet));
+				       (sizeof(struct vstor_packet) -
+					vmscsi_size_delta));
 				complete(&request->wait_event);
 			} else {
 				storvsc_on_receive(device,
@@ -1121,10 +1221,11 @@ static int storvsc_do_io(struct hv_device *device,
 
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
-	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
+	vstor_packet->vm_srb.length = (sizeof(struct vmscsi_request) -
+					vmscsi_size_delta);
 
 
-	vstor_packet->vm_srb.sense_info_length = STORVSC_SENSE_BUFFER_SIZE;
+	vstor_packet->vm_srb.sense_info_length = sense_buffer_size;
 
 
 	vstor_packet->vm_srb.data_transfer_length =
@@ -1136,11 +1237,13 @@ static int storvsc_do_io(struct hv_device *device,
 		ret = vmbus_sendpacket_multipagebuffer(device->channel,
 				&request->data_buffer,
 				vstor_packet,
-				sizeof(struct vstor_packet),
+				(sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 				(unsigned long)request);
 	} else {
 		ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -1264,7 +1367,8 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	vstor_packet->vm_srb.path_id = stor_device->path_id;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
+			       (sizeof(struct vstor_packet) -
+				vmscsi_size_delta),
 			       (unsigned long)&stor_device->reset_request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
@@ -1349,18 +1453,28 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	scmnd->host_scribble = (unsigned char *)cmd_request;
 
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
+	vm_srb->win8_extension.time_out_value = 60;
 
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
 		vm_srb->data_in = WRITE_TYPE;
+		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_OUT;
+		vm_srb->win8_extension.srb_flags |=
+			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
+			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	case DMA_FROM_DEVICE:
 		vm_srb->data_in = READ_TYPE;
+		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_IN;
+		vm_srb->win8_extension.srb_flags |=
+			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
+			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	default:
 		vm_srb->data_in = UNKNOWN_TYPE;
+		vm_srb->win8_extension.srb_flags = 0;
 		break;
 	}
 
@@ -1492,6 +1606,24 @@ static int storvsc_probe(struct hv_device *device,
 	int target = 0;
 	struct storvsc_device *stor_device;
 
+	/*
+	 * Based on the windows host we are running on,
+	 * set state to properly communicate with the host.
+	 */
+
+	if (vmbus_proto_version == VERSION_WIN8) {
+		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
+		vmscsi_size_delta = 0;
+		vmstor_current_major = VMSTOR_WIN8_MAJOR;
+		vmstor_current_minor = VMSTOR_WIN8_MINOR;
+	} else {
+		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
+		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
+		vmstor_current_major = VMSTOR_WIN7_MAJOR;
+		vmstor_current_minor = VMSTOR_WIN7_MINOR;
+	}
+
+
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
@@ -1601,7 +1733,8 @@ static int __init storvsc_drv_init(void)
 	max_outstanding_req_per_channel =
 		((storvsc_ringbuffer_size - PAGE_SIZE) /
 		ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
-		sizeof(struct vstor_packet) + sizeof(u64),
+		sizeof(struct vstor_packet) + sizeof(u64) -
+		vmscsi_size_delta,
 		sizeof(u64)));
 
 	if (max_outstanding_req_per_channel <
-- 
1.7.4.1
