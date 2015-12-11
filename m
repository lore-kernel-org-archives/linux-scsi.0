From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/4] scsi: storvsc: Properly support Fibre Channel devices
Date: Thu, 10 Dec 2015 16:14:18 -0800
Message-ID: <1449792860-15447-2-git-send-email-kys@microsoft.com>
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

For FC devices managed by this driver, atttach the appropriate transport
template. This will allow us to create the appropriate sysfs files for
these devices. With this we can publish the wwn for both the port and the node.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  100 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 00bb4bd..b94d471 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -41,6 +41,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_fc.h>
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -397,6 +398,7 @@ static int storvsc_timeout = 180;
 
 static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
 
+static struct scsi_transport_template *fc_transport_template;
 
 static void storvsc_on_channel_callback(void *context);
 
@@ -456,6 +458,11 @@ struct storvsc_device {
 	/* Used for vsc/vsp channel reset process */
 	struct storvsc_cmd_request init_request;
 	struct storvsc_cmd_request reset_request;
+	/*
+	 * Currently active port and node names for FC devices.
+	 */
+	u64 node_name;
+	u64 port_name;
 };
 
 struct hv_host_device {
@@ -695,7 +702,26 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	vmbus_are_subchannels_present(device->channel);
 }
 
-static int storvsc_channel_init(struct hv_device *device)
+static void cache_wwn(struct storvsc_device *stor_device,
+		      struct vstor_packet *vstor_packet)
+{
+	/*
+	 * Cache the currently active port and node ww names.
+	 */
+	if (vstor_packet->wwn_packet.primary_active) {
+		stor_device->node_name =
+			wwn_to_u64(vstor_packet->wwn_packet.primary_node_wwn);
+		stor_device->port_name =
+			wwn_to_u64(vstor_packet->wwn_packet.primary_port_wwn);
+	} else {
+		stor_device->node_name =
+			wwn_to_u64(vstor_packet->wwn_packet.secondary_node_wwn);
+		stor_device->port_name =
+			wwn_to_u64(vstor_packet->wwn_packet.secondary_port_wwn);
+	}
+}
+
+static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_cmd_request *request;
@@ -837,6 +863,40 @@ static int storvsc_channel_init(struct hv_device *device)
 	stor_device->max_transfer_bytes =
 		vstor_packet->storage_channel_properties.max_transfer_bytes;
 
+	if (!is_fc)
+		goto done;
+
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_FCHBA_DATA;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       (sizeof(struct vstor_packet) -
+			       vmscsi_size_delta),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	if (ret != 0)
+		goto cleanup;
+
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	if (t == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0)
+		goto cleanup;
+
+	/*
+	 * Cache the currently active port and node ww names.
+	 */
+	cache_wwn(stor_device, vstor_packet);
+
+done:
+
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
@@ -1076,6 +1136,12 @@ static void storvsc_on_receive(struct hv_device *device,
 		schedule_work(&work->work);
 		break;
 
+	case VSTOR_OPERATION_FCHBA_DATA:
+		stor_device = get_in_stor_device(device);
+		cache_wwn(stor_device, vstor_packet);
+		fc_host_node_name(stor_device->host) = stor_device->node_name;
+		fc_host_port_name(stor_device->host) = stor_device->port_name;
+		break;
 	default:
 		break;
 	}
@@ -1131,7 +1197,8 @@ static void storvsc_on_channel_callback(void *context)
 	return;
 }
 
-static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
+static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
+				  bool is_fc)
 {
 	struct vmstorage_channel_properties props;
 	int ret;
@@ -1148,7 +1215,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 	if (ret != 0)
 		return ret;
 
-	ret = storvsc_channel_init(device);
+	ret = storvsc_channel_init(device, is_fc);
 
 	return ret;
 }
@@ -1573,6 +1640,7 @@ static int storvsc_probe(struct hv_device *device,
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
+	bool is_fc = ((dev_id->driver_data == SFC_GUID) ? true : false);
 	int target = 0;
 	struct storvsc_device *stor_device;
 	int max_luns_per_target;
@@ -1630,7 +1698,7 @@ static int storvsc_probe(struct hv_device *device,
 	hv_set_drvdata(device, stor_device);
 
 	stor_device->port_number = host->host_no;
-	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
+	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
 	if (ret)
 		goto err_out1;
 
@@ -1642,6 +1710,7 @@ static int storvsc_probe(struct hv_device *device,
 		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
 		host->max_id = STORVSC_FC_MAX_TARGETS;
 		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
+		host->transportt = fc_transport_template;
 		break;
 
 	case SCSI_GUID:
@@ -1681,6 +1750,10 @@ static int storvsc_probe(struct hv_device *device,
 			goto err_out2;
 		}
 	}
+	if (host->transportt == fc_transport_template) {
+		fc_host_node_name(host) = stor_device->node_name;
+		fc_host_port_name(host) = stor_device->port_name;
+	}
 	return 0;
 
 err_out2:
@@ -1706,6 +1779,8 @@ static int storvsc_remove(struct hv_device *dev)
 	struct storvsc_device *stor_device = hv_get_drvdata(dev);
 	struct Scsi_Host *host = stor_device->host;
 
+	if (host->transportt == fc_transport_template)
+		fc_remove_host(host);
 	scsi_remove_host(host);
 	storvsc_dev_remove(dev);
 	scsi_host_put(host);
@@ -1720,8 +1795,14 @@ static struct hv_driver storvsc_drv = {
 	.remove = storvsc_remove,
 };
 
+static struct fc_function_template fc_transport_functions = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+};
+
 static int __init storvsc_drv_init(void)
 {
+	int ret;
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less
@@ -1736,12 +1817,21 @@ static int __init storvsc_drv_init(void)
 		vmscsi_size_delta,
 		sizeof(u64)));
 
-	return vmbus_driver_register(&storvsc_drv);
+	fc_transport_template = fc_attach_transport(&fc_transport_functions);
+	if (!fc_transport_template)
+		return -ENODEV;
+
+	ret = vmbus_driver_register(&storvsc_drv);
+	if (ret)
+		fc_release_transport(fc_transport_template);
+
+	return ret;
 }
 
 static void __exit storvsc_drv_exit(void)
 {
 	vmbus_driver_unregister(&storvsc_drv);
+	fc_release_transport(fc_transport_template);
 }
 
 MODULE_LICENSE("GPL");
-- 
1.7.4.1
