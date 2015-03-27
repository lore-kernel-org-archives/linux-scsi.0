From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 7/7] scsi: storvsc: Set the tablesize based on the information given by the host
Date: Fri, 27 Mar 2015 00:27:20 -0700
Message-ID: <1427441240-29314-7-git-send-email-kys@microsoft.com>
References: <1427441219-29275-1-git-send-email-kys@microsoft.com>
 <1427441240-29314-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427441240-29314-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Set the tablesize based on the information given by the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Tested-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   89 +++++++++++++++++++++++++++++++------------
 1 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 4156e29..d9dad90 100644
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
 
@@ -1103,6 +1106,8 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	struct Scsi_Host *host;
 	struct storvsc_device *stor_dev;
 	struct hv_device *dev = host_dev->dev;
+	u32 payload_sz = cmd_request->payload_sz;
+	void *payload = cmd_request->payload;
 
 	stor_dev = get_in_stor_device(dev);
 	host = stor_dev->host;
@@ -1132,10 +1137,14 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 					 sense_hdr.ascq);
 
 	scsi_set_resid(scmnd,
-		cmd_request->data_buffer.len -
+		cmd_request->payload->range.len -
 		vm_srb->data_transfer_length);
 
 	scmnd->scsi_done(scmnd);
+
+	if (payload_sz >
+		sizeof(struct vmbus_channel_packet_multipage_buffer))
+		kfree(payload);
 }
 
 static void storvsc_on_io_completion(struct hv_device *device,
@@ -1337,7 +1346,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 }
 
 static int storvsc_do_io(struct hv_device *device,
-			      struct storvsc_cmd_request *request)
+			 struct storvsc_cmd_request *request)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
@@ -1369,13 +1378,14 @@ static int storvsc_do_io(struct hv_device *device,
 
 
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
@@ -1549,6 +1559,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
 	struct scatterlist *cur_sgl;
+	struct vmbus_packet_mpb_array  *payload;
+	u32 payload_sz;
+	u32 length;
 
 	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
 		/*
@@ -1602,48 +1615,71 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	cmd_request->data_buffer.len = scsi_bufflen(scmnd);
-	if (scsi_sg_count(scmnd)) {
-		sgl = (struct scatterlist *)scsi_sglist(scmnd);
-		sg_count = scsi_sg_count(scmnd);
+	sgl = (struct scatterlist *)scsi_sglist(scmnd);
+	sg_count = scsi_sg_count(scmnd);
 
+	length = scsi_bufflen(scmnd);
+	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload_sz = sizeof(cmd_request->mpb);
+
+	if (sg_count) {
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
 			cmd_request->bounce_sgl =
-				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
-						     scsi_bufflen(scmnd),
+				create_bounce_buffer(sgl, sg_count,
+						     length,
 						     vm_srb->data_in);
 			if (!cmd_request->bounce_sgl)
 				return SCSI_MLQUEUE_HOST_BUSY;
 
 			cmd_request->bounce_sgl_count =
-				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
-					PAGE_SHIFT;
+				ALIGN(length, PAGE_SIZE) >> PAGE_SHIFT;
 
 			if (vm_srb->data_in == WRITE_TYPE)
 				copy_to_bounce_buffer(sgl,
-					cmd_request->bounce_sgl,
-					scsi_sg_count(scmnd));
+					cmd_request->bounce_sgl, sg_count);
 
 			sgl = cmd_request->bounce_sgl;
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		cmd_request->data_buffer.offset = sgl[0].offset;
+
+		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
+
+			payload_sz = (sg_count * sizeof(void *) +
+				      sizeof(struct vmbus_packet_mpb_array));
+			payload = kmalloc(payload_sz, GFP_ATOMIC);
+			if (!payload) {
+				if (cmd_request->bounce_sgl_count)
+					destroy_bounce_buffer(
+					cmd_request->bounce_sgl,
+					cmd_request->bounce_sgl_count);
+
+					return SCSI_MLQUEUE_DEVICE_BUSY;
+			}
+		}
+
+		payload->range.len = length;
+		payload->range.offset = sgl[0].offset;
+
 		cur_sgl = sgl;
 		for (i = 0; i < sg_count; i++) {
-			cmd_request->data_buffer.pfn_array[i] =
+			payload->range.pfn_array[i] =
 				page_to_pfn(sg_page((cur_sgl)));
 			cur_sgl = sg_next(cur_sgl);
 		}
 
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
+
 	/* Invokes the vsc to start an IO */
 	ret = storvsc_do_io(dev, cmd_request);
 
@@ -1672,10 +1708,7 @@ static struct scsi_host_template scsi_driver = {
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
 	.this_id =		-1,
-	/* no use setting to 0 since ll_blk_rw reset it to 1 */
-	/* currently 32 */
-	.sg_tablesize =		MAX_MULTIPAGE_BUFFER_COUNT,
-	.use_clustering =	DISABLE_CLUSTERING,
+	.use_clustering =	ENABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
 	.no_write_same =	1,
@@ -1812,6 +1845,12 @@ static int storvsc_probe(struct hv_device *device,
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
