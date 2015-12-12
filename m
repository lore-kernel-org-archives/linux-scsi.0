From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 4/4] scsi: storvsc: Tighten up the interrupt path
Date: Sat, 12 Dec 2015 13:53:45 -0800
Message-ID: <1449957225-9276-4-git-send-email-kys@microsoft.com>
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

On the interrupt path, we repeatedly establish the pointer to the
storvsc_device. Fix this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Alex Ng <alexng@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 947f812..3d3d157 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -943,19 +943,16 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 }
 
 
-static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
+static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
+				       struct storvsc_device *stor_dev)
 {
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 	struct Scsi_Host *host;
-	struct storvsc_device *stor_dev;
-	struct hv_device *dev = host_dev->dev;
 	u32 payload_sz = cmd_request->payload_sz;
 	void *payload = cmd_request->payload;
 
-	stor_dev = get_in_stor_device(dev);
 	host = stor_dev->host;
 
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
@@ -985,14 +982,13 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 		kfree(payload);
 }
 
-static void storvsc_on_io_completion(struct hv_device *device,
+static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 				  struct vstor_packet *vstor_packet,
 				  struct storvsc_cmd_request *request)
 {
-	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
+	struct hv_device *device = stor_device->device;
 
-	stor_device = hv_get_drvdata(device);
 	stor_pkt = &request->vstor_packet;
 
 	/*
@@ -1047,7 +1043,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	stor_pkt->vm_srb.data_transfer_length =
 	vstor_packet->vm_srb.data_transfer_length;
 
-	storvsc_command_completion(request);
+	storvsc_command_completion(request, stor_device);
 
 	if (atomic_dec_and_test(&stor_device->num_outstanding_req) &&
 		stor_device->drain_notify)
@@ -1056,21 +1052,19 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 }
 
-static void storvsc_on_receive(struct hv_device *device,
+static void storvsc_on_receive(struct storvsc_device *stor_device,
 			     struct vstor_packet *vstor_packet,
 			     struct storvsc_cmd_request *request)
 {
 	struct storvsc_scan_work *work;
-	struct storvsc_device *stor_device;
 
 	switch (vstor_packet->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
-		storvsc_on_io_completion(device, vstor_packet, request);
+		storvsc_on_io_completion(stor_device, vstor_packet, request);
 		break;
 
 	case VSTOR_OPERATION_REMOVE_DEVICE:
 	case VSTOR_OPERATION_ENUMERATE_BUS:
-		stor_device = get_in_stor_device(device);
 		work = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
 		if (!work)
 			return;
@@ -1081,7 +1075,6 @@ static void storvsc_on_receive(struct hv_device *device,
 		break;
 
 	case VSTOR_OPERATION_FCHBA_DATA:
-		stor_device = get_in_stor_device(device);
 		cache_wwn(stor_device, vstor_packet);
 		fc_host_node_name(stor_device->host) = stor_device->node_name;
 		fc_host_port_name(stor_device->host) = stor_device->port_name;
@@ -1129,7 +1122,7 @@ static void storvsc_on_channel_callback(void *context)
 					vmscsi_size_delta));
 				complete(&request->wait_event);
 			} else {
-				storvsc_on_receive(device,
+				storvsc_on_receive(stor_device,
 						(struct vstor_packet *)packet,
 						request);
 			}
-- 
1.7.4.1
