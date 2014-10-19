From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] storvsc: set cmd_info and avoid mempool allocation for per-cmd data
Date: Sun, 19 Oct 2014 17:18:15 +0200
Message-ID: <1413731895-6967-2-git-send-email-hch@lst.de>
References: <1413731895-6967-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaJSPPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 11:15:42 -0400
In-Reply-To: <1413731895-6967-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/storvsc_drv.c | 118 +++------------------------------------------
 1 file changed, 7 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 733e5f7..0ddb0b6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/hyperv.h>
-#include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -309,14 +308,6 @@ enum storvsc_request_type {
  * This is the end of Protocol specific defines.
  */
 
-
-/*
- * We setup a mempool to allocate request structures for this driver
- * on a per-lun basis. The following define specifies the number of
- * elements in the pool.
- */
-
-#define STORVSC_MIN_BUF_NR				64
 static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
 
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
@@ -346,7 +337,6 @@ static void storvsc_on_channel_callback(void *context);
 #define STORVSC_IDE_MAX_CHANNELS			1
 
 struct storvsc_cmd_request {
-	struct list_head entry;
 	struct scsi_cmnd *cmd;
 
 	unsigned int bounce_sgl_count;
@@ -357,7 +347,6 @@ struct storvsc_cmd_request {
 	/* Synchronize the request/response if needed */
 	struct completion wait_event;
 
-	unsigned char *sense_buffer;
 	struct hv_multipage_buffer data_buffer;
 	struct vstor_packet vstor_packet;
 };
@@ -389,11 +378,6 @@ struct storvsc_device {
 	struct storvsc_cmd_request reset_request;
 };
 
-struct stor_mem_pools {
-	struct kmem_cache *request_pool;
-	mempool_t *request_mempool;
-};
-
 struct hv_host_device {
 	struct hv_device *dev;
 	unsigned int port;
@@ -1070,10 +1054,8 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 {
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
-	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
-	struct stor_mem_pools *memp = scmnd->device->hostdata;
 	struct Scsi_Host *host;
 	struct storvsc_device *stor_dev;
 	struct hv_device *dev = host_dev->dev;
@@ -1108,14 +1090,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 		cmd_request->data_buffer.len -
 		vm_srb->data_transfer_length);
 
-	scsi_done_fn = scmnd->scsi_done;
-
-	scmnd->host_scribble = NULL;
-	scmnd->scsi_done = NULL;
-
-	scsi_done_fn(scmnd);
-
-	mempool_free(cmd_request, memp->request_mempool);
+	scmnd->scsi_done(scmnd);
 }
 
 static void storvsc_on_io_completion(struct hv_device *device,
@@ -1159,7 +1134,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 			SRB_STATUS_AUTOSENSE_VALID) {
 			/* autosense data available */
 
-			memcpy(request->sense_buffer,
+			memcpy(request->cmd->sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
 			       vstor_packet->vm_srb.sense_info_length);
 
@@ -1377,55 +1352,6 @@ static int storvsc_do_io(struct hv_device *device,
 	return ret;
 }
 
-static int storvsc_device_alloc(struct scsi_device *sdevice)
-{
-	struct stor_mem_pools *memp;
-	int number = STORVSC_MIN_BUF_NR;
-
-	memp = kzalloc(sizeof(struct stor_mem_pools), GFP_KERNEL);
-	if (!memp)
-		return -ENOMEM;
-
-	memp->request_pool =
-		kmem_cache_create(dev_name(&sdevice->sdev_dev),
-				sizeof(struct storvsc_cmd_request), 0,
-				SLAB_HWCACHE_ALIGN, NULL);
-
-	if (!memp->request_pool)
-		goto err0;
-
-	memp->request_mempool = mempool_create(number, mempool_alloc_slab,
-						mempool_free_slab,
-						memp->request_pool);
-
-	if (!memp->request_mempool)
-		goto err1;
-
-	sdevice->hostdata = memp;
-
-	return 0;
-
-err1:
-	kmem_cache_destroy(memp->request_pool);
-
-err0:
-	kfree(memp);
-	return -ENOMEM;
-}
-
-static void storvsc_device_destroy(struct scsi_device *sdevice)
-{
-	struct stor_mem_pools *memp = sdevice->hostdata;
-
-	if (!memp)
-		return;
-
-	mempool_destroy(memp->request_mempool);
-	kmem_cache_destroy(memp->request_pool);
-	kfree(memp);
-	sdevice->hostdata = NULL;
-}
-
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
@@ -1561,13 +1487,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	int ret;
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
-	struct storvsc_cmd_request *cmd_request;
-	unsigned int request_size = 0;
+	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
 	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
-	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
 	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
 		/*
@@ -1584,25 +1508,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		}
 	}
 
-	request_size = sizeof(struct storvsc_cmd_request);
-
-	cmd_request = mempool_alloc(memp->request_mempool,
-				       GFP_ATOMIC);
-
-	/*
-	 * We might be invoked in an interrupt context; hence
-	 * mempool_alloc() can fail.
-	 */
-	if (!cmd_request)
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-
-	memset(cmd_request, 0, sizeof(struct storvsc_cmd_request));
-
 	/* Setup the cmd request */
 	cmd_request->cmd = scmnd;
 
-	scmnd->host_scribble = (unsigned char *)cmd_request;
-
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
 	vm_srb->win8_extension.time_out_value = 60;
 
@@ -1637,9 +1545,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	cmd_request->sense_buffer = scmnd->sense_buffer;
-
-
 	cmd_request->data_buffer.len = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
@@ -1651,10 +1556,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
 						     scsi_bufflen(scmnd),
 						     vm_srb->data_in);
-			if (!cmd_request->bounce_sgl) {
-				ret = SCSI_MLQUEUE_HOST_BUSY;
-				goto queue_error;
-			}
+			if (!cmd_request->bounce_sgl)
+				return SCSI_MLQUEUE_HOST_BUSY;
 
 			cmd_request->bounce_sgl_count =
 				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
@@ -1692,28 +1595,21 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 
-			ret = SCSI_MLQUEUE_DEVICE_BUSY;
-			goto queue_error;
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 	}
 
 	return 0;
-
-queue_error:
-	mempool_free(cmd_request, memp->request_mempool);
-	scmnd->host_scribble = NULL;
-	return ret;
 }
 
 static struct scsi_host_template scsi_driver = {
 	.module	=		THIS_MODULE,
 	.name =			"storvsc_host_t",
+	.cmd_size =		sizeof(struct storvsc_cmd_request),
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
 	.eh_timed_out =		storvsc_eh_timed_out,
-	.slave_alloc =		storvsc_device_alloc,
-	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
-- 
1.9.1

