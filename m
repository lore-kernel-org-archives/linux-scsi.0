From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 3/4] scsi: storvsc: Refactor the code in
 storvsc_channel_init()
Date: Sat, 12 Dec 2015 13:53:44 -0800
Message-ID: <1449957225-9276-3-git-send-email-kys@microsoft.com>
References: <1449957191-9232-1-git-send-email-kys@microsoft.com>
 <1449957225-9276-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449957225-9276-1-git-send-email-kys@microsoft.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Alex Ng <alexng@microsoft.com>
---
	V2: Fixed error paths - Dan Carpenter <dan.carpenter@oracle.com>

 drivers/scsi/storvsc_drv.c |  126 ++++++++++++++++----------------------------
 1 files changed, 46 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ab9828c..947f812 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -721,29 +721,17 @@ static void cache_wwn(struct storvsc_device *stor_device,
 	}
 }
 
-static int storvsc_channel_init(struct hv_device *device, bool is_fc)
+
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
@@ -759,17 +747,50 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 	if (t == 0)
 		return -ETIMEDOUT;
 
+	if (!status_check)
+		return ret;
+
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0)
 		return -EINVAL;
 
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
+		return ret;
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
@@ -778,20 +799,10 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 		 * The revision number is only used in Windows; set it to 0.
 		 */
 		vstor_packet->version.revision = 0;
-
-		ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-				vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+		ret = storvsc_execute_vstor_op(device, request, false);
 		if (ret != 0)
 			return ret;
 
-		t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-		if (t == 0)
-			return -ETIMEDOUT;
-
 		if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO)
 			return -EINVAL;
 
@@ -815,26 +826,10 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 
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
+	ret = storvsc_execute_vstor_op(device, request, true);
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0)
-		return -ETIMEDOUT;
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		return -EINVAL;
-
 	/*
 	 * Check to see if multi-channel support is there.
 	 * Hosts that implement protocol version of 5.1 and above
@@ -852,28 +847,15 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 	if (!is_fc)
 		goto done;
 
+	/*
+	 * For FC devices retrieve FC HBA data.
+	 */
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_FCHBA_DATA;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-			       vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-
+	ret = storvsc_execute_vstor_op(device, request, true);
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0)
-		return -ETIMEDOUT;
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		return -EINVAL;
-
 	/*
 	 * Cache the currently active port and node ww names.
 	 */
@@ -883,26 +865,10 @@ done:
 
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       (sizeof(struct vstor_packet) -
-				vmscsi_size_delta),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-
+	ret = storvsc_execute_vstor_op(device, request, true);
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0)
-		return -ETIMEDOUT;
-
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		return -EINVAL;
-
 	if (process_sub_channels)
 		handle_multichannel_storage(device, max_chns);
 
-- 
1.7.4.1
