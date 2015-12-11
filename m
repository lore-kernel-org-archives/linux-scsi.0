From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/4] scsi: storvsc: Refactor the code in storvsc_channel_init()
Date: Thu, 10 Dec 2015 16:14:19 -0800
Message-ID: <1449792860-15447-3-git-send-email-kys@microsoft.com>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449792860-15447-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

The function storvsc_channel_init() repeatedly interacts with the host to
extract various channel properties. Refactor this code to eliminate code
repetition.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  155 ++++++++++++++++----------------------------
 1 files changed, 57 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index b94d471..6f18e94 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -721,29 +721,16 @@ static void cache_wwn(struct storvsc_device *stor_device,
 	}
 }
 
-static int storvsc_channel_init(struct hv_device *device, bool is_fc)
+static int storvsc_execute_vstor_op(struct hv_device *device,
+				    struct storvsc_cmd_request *request,
+				    bool status_check)
 {
-	struct storvsc_device *stor_device;
-	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
-	int ret, t, i;
-	int max_chns;
-	bool process_sub_channels = false;
-
-	stor_device = get_out_stor_device(device);
-	if (!stor_device)
-		return -ENODEV;
+	int ret, t;
 
-	request = &stor_device->init_request;
 	vstor_packet = &request->vstor_packet;
 
-	/*
-	 * Now, initiate the vsc/vsp initialization protocol on the open
-	 * channel
-	 */
-	memset(request, 0, sizeof(struct storvsc_cmd_request));
 	init_completion(&request->wait_event);
-	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
@@ -753,27 +740,62 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
-		goto cleanup;
+		goto done;
 
 	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
-		goto cleanup;
+		goto done;
 	}
 
+	if (!status_check)
+		goto done;
+
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0) {
 		ret = -EINVAL;
-		goto cleanup;
+		goto done;
 	}
 
+done:
+	return ret;
+}
+
+static int storvsc_channel_init(struct hv_device *device, bool is_fc)
+{
+	struct storvsc_device *stor_device;
+	struct storvsc_cmd_request *request;
+	struct vstor_packet *vstor_packet;
+	int ret, i;
+	int max_chns;
+	bool process_sub_channels = false;
+
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return -ENODEV;
+
+	request = &stor_device->init_request;
+	vstor_packet = &request->vstor_packet;
+
+	/*
+	 * Now, initiate the vsc/vsp initialization protocol on the open
+	 * channel
+	 */
+	memset(request, 0, sizeof(struct storvsc_cmd_request));
+	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
+	ret = storvsc_execute_vstor_op(device, request, true);
+	if (ret)
+		goto cleanup;
+
+	/*
+	 * Query host supported protocol version.
+	 */
 
 	for (i = 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
 		/* reuse the packet for version range supported */
 		memset(vstor_packet, 0, sizeof(struct vstor_packet));
 		vstor_packet->operation =
 			VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
-		vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 		vstor_packet->version.major_minor =
 			vmstor_protocols[i].protocol_version;
@@ -783,20 +805,9 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 		 */
 		vstor_packet->version.revision = 0;
 
-		ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-				vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-		if (ret != 0)
-			goto cleanup;
-
-		t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-		if (t == 0) {
-			ret = -ETIMEDOUT;
+		ret = storvsc_execute_vstor_op(device, request, false);
+		if (ret)
 			goto cleanup;
-		}
 
 		if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO) {
 			ret = -EINVAL;
@@ -822,32 +833,14 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 		goto cleanup;
 	}
 
-
+	/*
+	 * Query channel properties.
+	 */
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-				vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-
-	if (ret != 0)
-		goto cleanup;
-
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		ret = -EINVAL;
+	ret = storvsc_execute_vstor_op(device, request, true);
+	if (ret)
 		goto cleanup;
-	}
 
 	/*
 	 * Check to see if multi-channel support is there.
@@ -866,30 +859,15 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 	if (!is_fc)
 		goto done;
 
+	/*
+	 * For FC devices retrieve FC HBA data.
+	 */
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_FCHBA_DATA;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-			       vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-
-	if (ret != 0)
-		goto cleanup;
-
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	ret = storvsc_execute_vstor_op(device, request, true);
+	if (ret)
 		goto cleanup;
-
 	/*
 	 * Cache the currently active port and node ww names.
 	 */
@@ -899,29 +877,10 @@ done:
 
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-				vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-
-	if (ret != 0)
-		goto cleanup;
-
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		ret = -EINVAL;
+	ret = storvsc_execute_vstor_op(device, request, true);
+	if (ret)
 		goto cleanup;
-	}
 
 	if (process_sub_channels)
 		handle_multichannel_storage(device, max_chns);
-- 
1.7.4.1
