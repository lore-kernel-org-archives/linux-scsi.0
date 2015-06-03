From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 3/7] scsi: storvsc: Untangle the storage protocol negotiation from the vmbus protocol negotiation.
Date: Wed,  3 Jun 2015 15:34:28 -0700
Message-ID: <1433370872-3302-3-git-send-email-kys@microsoft.com>
References: <1433370839-3240-1-git-send-email-kys@microsoft.com>
 <1433370872-3302-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56558
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbbFCVNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jun 2015 17:13:14 -0400
In-Reply-To: <1433370872-3302-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: Keith Mange <keith.mange@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>

From: Keith Mange <keith.mange@microsoft.com>

Currently we are making decisions based on vmbus protocol versions
that have been negotiated; use storage potocol versions instead.

Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: Keith Mange <keith.mange@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  109 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 87 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5f9d133..f29871e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -56,14 +56,18 @@
  * V1 RC > 2008/1/31:  2.0
  * Win7: 4.2
  * Win8: 5.1
+ * Win8.1: 6.0
+ * Win10: 6.2
  */
 
 #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
 						(((MINOR_) & 0xff)))
 
+#define VMSTOR_PROTO_VERSION_WIN6	VMSTOR_PROTO_VERSION(2, 0)
 #define VMSTOR_PROTO_VERSION_WIN7	VMSTOR_PROTO_VERSION(4, 2)
 #define VMSTOR_PROTO_VERSION_WIN8	VMSTOR_PROTO_VERSION(5, 1)
-
+#define VMSTOR_PROTO_VERSION_WIN8_1	VMSTOR_PROTO_VERSION(6, 0)
+#define VMSTOR_PROTO_VERSION_WIN10	VMSTOR_PROTO_VERSION(6, 2)
 
 /*  Packet structure describing virtual storage requests. */
 enum vstor_packet_operation {
@@ -205,6 +209,46 @@ struct vmscsi_request {
 
 
 /*
+ * The list of storage protocols in order of preference.
+ */
+struct vmstor_protocol {
+	int protocol_version;
+	int sense_buffer_size;
+	int vmscsi_size_delta;
+};
+
+#define VMSTOR_NUM_PROTOCOLS    5
+
+const struct vmstor_protocol vmstor_protocols[VMSTOR_NUM_PROTOCOLS] = {
+	{
+		VMSTOR_PROTO_VERSION_WIN10,
+		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
+		0
+	},
+	{
+		VMSTOR_PROTO_VERSION_WIN8_1,
+		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
+		0
+	},
+	{
+		VMSTOR_PROTO_VERSION_WIN8,
+		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
+		0
+	},
+	{
+		VMSTOR_PROTO_VERSION_WIN7,
+		PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE,
+		sizeof(struct vmscsi_win8_extension),
+	},
+	{
+		VMSTOR_PROTO_VERSION_WIN6,
+		PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE,
+		sizeof(struct vmscsi_win8_extension),
+	}
+};
+
+
+/*
  * This structure is sent during the intialization phase to get the different
  * properties of the channel.
  */
@@ -871,7 +915,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	struct storvsc_device *stor_device;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
-	int ret, t;
+	int ret, t, i;
 	int max_chns;
 	bool process_sub_channels = false;
 
@@ -911,36 +955,59 @@ static int storvsc_channel_init(struct hv_device *device)
 		goto cleanup;
 
 
-	/* reuse the packet for version range supported */
-	memset(vstor_packet, 0, sizeof(struct vstor_packet));
-	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	for (i = 0; i < VMSTOR_NUM_PROTOCOLS; i++) {
+		/* reuse the packet for version range supported */
+		memset(vstor_packet, 0, sizeof(struct vstor_packet));
+		vstor_packet->operation =
+			VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
+		vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	vstor_packet->version.major_minor = vmstor_proto_version;
+		vstor_packet->version.major_minor =
+			vmstor_protocols[i].protocol_version;
 
-	/*
-	 * The revision number is only used in Windows; set it to 0.
-	 */
-	vstor_packet->version.revision = 0;
+		/*
+		 * The revision number is only used in Windows; set it to 0.
+		 */
+		vstor_packet->version.revision = 0;
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
+		ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				vmscsi_size_delta),
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0)
-		goto cleanup;
+		if (ret != 0)
+			goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
+		t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+		if (t == 0) {
+			ret = -ETIMEDOUT;
+			goto cleanup;
+		}
+
+		if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
+
+		if (vstor_packet->status == 0) {
+			vmstor_proto_version =
+				vmstor_protocols[i].protocol_version;
+
+			sense_buffer_size =
+				vmstor_protocols[i].sense_buffer_size;
+
+			vmscsi_size_delta =
+				vmstor_protocols[i].vmscsi_size_delta;
+
+			break;
+		}
 	}
 
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	if (vstor_packet->status != 0) {
+		ret = -EINVAL;
 		goto cleanup;
+	}
 
 
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
@@ -1745,14 +1812,12 @@ static int storvsc_probe(struct hv_device *device,
 	if (vmbus_proto_version < VERSION_WIN8) {
 		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
-		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN7;
 		max_luns_per_target = STORVSC_IDE_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_IDE_MAX_TARGETS;
 		max_channels = STORVSC_IDE_MAX_CHANNELS;
 	} else {
 		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = 0;
-		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN8;
 		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_MAX_TARGETS;
 		max_channels = STORVSC_MAX_CHANNELS;
-- 
1.7.4.1

