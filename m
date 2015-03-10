From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] scsi: storvsc: Set the tablesize based on the information given by the host
Date: Mon,  9 Mar 2015 20:45:06 -0700
Message-ID: <1425959107-24199-2-git-send-email-kys@microsoft.com>
References: <1425958941-23374-1-git-send-email-kys@microsoft.com>
 <1425959107-24199-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425959107-24199-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Set the tablesize based on what the host has informed us.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   70 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5c13eec..a36c232 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -351,7 +351,10 @@ struct storvsc_cmd_request {
 	/* Synchronize the request/response if needed */
 	struct completion wait_event;
 
-	struct hv_multipage_buffer data_buffer;
+	struct vmbus_channel_packet_multipage_buffer mpb;
+	struct vmbus_packet_mpb_array *payload;
+	u32 payload_sz;
+
 	struct vstor_packet vstor_packet;
 };
 
@@ -1119,10 +1122,14 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 					 sense_hdr.ascq);
 
 	scsi_set_resid(scmnd,
-		cmd_request->data_buffer.len -
+		cmd_request->payload->range.len -
 		vm_srb->data_transfer_length);
 
 	scmnd->scsi_done(scmnd);
+
+	if (cmd_request->payload_sz >
+		sizeof(struct vmbus_channel_packet_multipage_buffer))
+		kfree(cmd_request->payload);
 }
 
 static void storvsc_on_io_completion(struct hv_device *device,
@@ -1324,7 +1331,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 }
 
 static int storvsc_do_io(struct hv_device *device,
-			      struct storvsc_cmd_request *request)
+			 struct storvsc_cmd_request *request)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
@@ -1356,13 +1363,14 @@ static int storvsc_do_io(struct hv_device *device,
 
 
 	vstor_packet->vm_srb.data_transfer_length =
-	request->data_buffer.len;
+	request->payload->range.len;
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
-	if (request->data_buffer.len) {
-		ret = vmbus_sendpacket_multipagebuffer(outgoing_channel,
-				&request->data_buffer,
+	if (request->payload->range.len) {
+
+		ret = vmbus_sendpacket_mpb_desc(outgoing_channel,
+				request->payload, request->payload_sz,
 				vstor_packet,
 				(sizeof(struct vstor_packet) -
 				vmscsi_size_delta),
@@ -1535,6 +1543,10 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
+	struct vmbus_packet_mpb_array  *payload;
+	u32 payload_sz;
+	u32 pfn_cnt;
+	u32 length;
 
 	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
 		/*
@@ -1588,7 +1600,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	cmd_request->data_buffer.len = scsi_bufflen(scmnd);
+	sgl = (struct scatterlist *)scsi_sglist(scmnd);
+	length = scsi_bufflen(scmnd);
+	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload_sz = sizeof(cmd_request->mpb);
+
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -1615,19 +1631,40 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		cmd_request->data_buffer.offset = sgl[0].offset;
+		pfn_cnt = DIV_ROUND_UP(sgl[0].offset + length, PAGE_SIZE);
+
+		if (pfn_cnt > MAX_PAGE_BUFFER_COUNT) {
+
+			payload_sz = (pfn_cnt * sizeof(void *) +
+				      sizeof(struct vmbus_packet_mpb_array));
+			payload = kzalloc(payload_sz, GFP_ATOMIC);
+			if (!payload) {
+				if (cmd_request->bounce_sgl_count)
+					destroy_bounce_buffer(
+					cmd_request->bounce_sgl,
+					cmd_request->bounce_sgl_count);
+
+				return SCSI_MLQUEUE_DEVICE_BUSY;
+			}
+		}
+
+		payload->range.len = length;
+		payload->range.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++)
-			cmd_request->data_buffer.pfn_array[i] =
+			payload->range.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 
 	} else if (scsi_sglist(scmnd)) {
-		cmd_request->data_buffer.offset =
+		payload->range.len = length;
+		payload->range.offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		cmd_request->data_buffer.pfn_array[0] =
+		payload->range.pfn_array[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
+	cmd_request->payload = payload;
+	cmd_request->payload_sz = payload_sz;
 	/* Invokes the vsc to start an IO */
 	ret = storvsc_do_io(dev, cmd_request);
 
@@ -1656,9 +1693,6 @@ static struct scsi_host_template scsi_driver = {
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
 	.this_id =		-1,
-	/* no use setting to 0 since ll_blk_rw reset it to 1 */
-	/* currently 32 */
-	.sg_tablesize =		MAX_MULTIPAGE_BUFFER_COUNT,
 	.use_clustering =	DISABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
@@ -1796,6 +1830,12 @@ static int storvsc_probe(struct hv_device *device,
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
+	/*
+	 * set the table size based on the info we got
+	 * from the host.
+	 */
+	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
 	if (ret != 0)
-- 
1.7.4.1
