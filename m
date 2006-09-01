From: "Ed Lin" <ed.lin@promise.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 1 Sep 2006 14:31:51 +0800
Message-ID: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:48569 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S1750823AbWIAG35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 02:29:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>


======= On 2006-09-01 06:21:45, James Bottomley wrote:

>On Thu, 2006-08-31 at 16:55 +0800, Ed Lin wrote:
>> EXPORT_SYMBOL(blk_free_tags) ?
>> Also, add new function definitions in blkdev.h?
>
>Yes .. fixed that up when I tried to use it in a module.
>
>So, given these two plus another patch that should fix all of the sync
>cache issues, how about this as the final patch for stex (to replace the
>[PATCH 3/3] stex: use block layer tagging)?
>

Thanks. It's good. But here are a few issues.

1.Maybe we need to check the result of scsi_init_shared_tag_map.
It's unlikely to fail. In case it really fails, we can simply exit
since we need tagging. Just checking.

2.During shutdown/unload, we need to notify firmware to stop some
background activities, that we are going to shutdown. If we don't do this,
and the power is switched off when firmware is not ready, there may be
error. It's possible the firmware is doing something that need to be
stopped before shutdown. So it's different from a simple cache issue.

So it's better to keep the stex_hba_stop function and the .shutdown
entry. In normal cases, there is no outside command at the stage when
shutdown functions are called. So we can safely assume the tag is 0,
and issue the notifying command, and then exit. It's only one and it
will be issued only once. This way we can guarantee data integrity,
and remove internal tag handling functions at the same time.

I agree with the other parts of the patch. So maybe we can consider
something like the following?



diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index fd09330..15fb99f 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -34,6 +34,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 #define DRV_NAME "stex"
 #define ST_DRIVER_VERSION "2.9.0.13"
@@ -95,7 +96,6 @@ enum {
 
 	/* request count, etc. */
 	MU_MAX_REQUEST				= 32,
-	TAG_BITMAP_LENGTH			= MU_MAX_REQUEST,
 
 	/* one message wasted, use MU_MAX_REQUEST+1
 		to handle MU_MAX_REQUEST messages */
@@ -265,7 +265,6 @@ struct st_hba {
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
 
-	u32 tag;
 	u32 req_head;
 	u32 req_tail;
 	u32 status_head;
@@ -309,40 +308,6 @@ static void stex_gettime(__le32 *time)
 	*(time + 1) = cpu_to_le32((tv.tv_sec >> 16) >> 16);
 }
 
-static u16 __stex_alloc_tag(unsigned long *bitmap)
-{
-	int i;
-	i = find_first_zero_bit(bitmap, TAG_BITMAP_LENGTH);
-	if (i < TAG_BITMAP_LENGTH)
-		__set_bit(i, bitmap);
-	return (u16)i;
-}
-
-static u16 stex_alloc_tag(struct st_hba *hba, unsigned long *bitmap)
-{
-	unsigned long flags;
-	u16 tag;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	tag = __stex_alloc_tag(bitmap);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	return tag;
-}
-
-static void __stex_free_tag(unsigned long *bitmap, u16 tag)
-{
-	__clear_bit((int)tag, bitmap);
-}
-
-static void stex_free_tag(struct st_hba *hba, unsigned long *bitmap, u16 tag)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	__stex_free_tag(bitmap, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-}
-
 static struct status_msg *stex_get_status(struct st_hba *hba)
 {
 	struct status_msg *status =
@@ -535,57 +500,31 @@ stex_send_cmd(struct st_hba *hba, struct
 }
 
 static int
+stex_slave_alloc(struct scsi_device *sdev)
+{
+	/* Cheat: usually extracted from Inquiry data */
+	sdev->tagged_supported = 1;
+
+	scsi_activate_tcq(sdev, sdev->host->can_queue);
+
+	return 0;
+}
+
+static int
 stex_slave_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
 	sdev->timeout = 60 * HZ;
+	sdev->tagged_supported = 1;
+
 	return 0;
 }
 
 static void
 stex_slave_destroy(struct scsi_device *sdev)
 {
-	struct st_hba *hba = (struct st_hba *) sdev->host->hostdata;
-	struct req_msg *req;
-	unsigned long flags;
-	unsigned long before;
-	u16 tag;
-
-	if (sdev->type != TYPE_DISK)
-		return;
-
-	before = jiffies;
-	while ((tag = stex_alloc_tag(hba, (unsigned long *)&hba->tag))
-		== TAG_BITMAP_LENGTH) {
-		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ))
-			return;
-		msleep(10);
-	}
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	req = stex_alloc_req(hba);
-	memset(req->cdb, 0, STEX_CDB_LENGTH);
-
-	req->target = sdev->id;
-	req->lun = sdev->channel; /* firmware lun issue work around */
-	req->cdb[0] = SYNCHRONIZE_CACHE;
-
-	hba->ccb[tag].cmd = NULL;
-	hba->ccb[tag].sg_count = 0;
-	hba->ccb[tag].sense_bufflen = 0;
-	hba->ccb[tag].sense_buffer = NULL;
-	hba->ccb[tag].req_type |= PASSTHRU_REQ_TYPE;
-
-	stex_send_cmd(hba, req, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	wait_event_timeout(hba->waitq,
-		!(hba->ccb[tag].req_type), ST_INTERNAL_TIMEOUT * HZ);
-	if (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE)
-		return;
-
-	stex_free_tag(hba, (unsigned long *)&hba->tag, tag);
+	scsi_deactivate_tcq(sdev, 1);
 }
 
 static int
@@ -650,8 +589,9 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 
 	cmd->scsi_done = done;
 
-	if (unlikely((tag = __stex_alloc_tag((unsigned long *)&hba->tag))
-		== TAG_BITMAP_LENGTH))
+	tag = cmd->request->tag;
+
+	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	req = stex_alloc_req(hba);
@@ -771,26 +711,18 @@ static void stex_mu_intr(struct st_hba *
 	while (hba->status_tail != hba->status_head) {
 		resp = stex_get_status(hba);
 		tag = le16_to_cpu(resp->tag);
-		if (unlikely(tag >= TAG_BITMAP_LENGTH)) {
+		if (unlikely(tag >= hba->host->can_queue)) {
 			printk(KERN_WARNING DRV_NAME
 				"(%s): invalid tag\n", pci_name(hba->pdev));
 			continue;
 		}
-		if (unlikely((hba->tag & (1 << tag)) == 0)) {
-			printk(KERN_WARNING DRV_NAME
-				"(%s): null tag\n", pci_name(hba->pdev));
-			continue;
-		}
 
-		hba->out_req_cnt--;
 		ccb = &hba->ccb[tag];
 		if (hba->wait_ccb == ccb)
 			hba->wait_ccb = NULL;
 		if (unlikely(ccb->req == NULL)) {
 			printk(KERN_WARNING DRV_NAME
 				"(%s): lagging req\n", pci_name(hba->pdev));
-			__stex_free_tag((unsigned long *)&hba->tag, tag);
-			stex_unmap_sg(hba, ccb->cmd); /* ??? */
 			continue;
 		}
 
@@ -808,7 +740,15 @@ static void stex_mu_intr(struct st_hba *
 		ccb->srb_status = resp->srb_status;
 		ccb->scsi_status = resp->scsi_status;
 
-		if (ccb->req_type & PASSTHRU_REQ_TYPE) {
+		if (likely(ccb->cmd != NULL)) {
+			if (unlikely(ccb->cmd->cmnd[0] == PASSTHRU_CMD &&
+				ccb->cmd->cmnd[1] == PASSTHRU_GET_ADAPTER))
+				stex_controller_info(hba, ccb);
+			stex_unmap_sg(hba, ccb->cmd);
+			stex_scsi_done(ccb);
+			hba->out_req_cnt--;
+		} else if (ccb->req_type & PASSTHRU_REQ_TYPE) {
+			hba->out_req_cnt--;
 			if (ccb->req_type & PASSTHRU_REQ_NO_WAKEUP) {
 				ccb->req_type = 0;
 				continue;
@@ -816,14 +756,7 @@ static void stex_mu_intr(struct st_hba *
 			ccb->req_type = 0;
 			if (waitqueue_active(&hba->waitq))
 				wake_up(&hba->waitq);
-			continue;
 		}
-		if (ccb->cmd->cmnd[0] == PASSTHRU_CMD &&
-			ccb->cmd->cmnd[1] == PASSTHRU_GET_ADAPTER)
-			stex_controller_info(hba, ccb);
-		__stex_free_tag((unsigned long *)&hba->tag, tag);
-		stex_unmap_sg(hba, ccb->cmd);
-		stex_scsi_done(ccb);
 	}
 
 update_status:
@@ -933,21 +866,24 @@ static int stex_abort(struct scsi_cmnd *
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag;
+	u16 tag = cmd->request->tag;
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
 	unsigned long flags;
 	base = hba->mmio_base;
 	spin_lock_irqsave(host->host_lock, flags);
-
-	for (tag = 0; tag < MU_MAX_REQUEST; tag++)
-		if (hba->ccb[tag].cmd == cmd && (hba->tag & (1 << tag))) {
-			hba->wait_ccb = &(hba->ccb[tag]);
-			break;
-		}
-	if (tag >= MU_MAX_REQUEST)
-		goto out;
+	if (tag < host->can_queue && hba->ccb[tag].cmd == cmd)
+		hba->wait_ccb = &hba->ccb[tag];
+	else {
+		for (tag = 0; tag < host->can_queue; tag++)
+			if (hba->ccb[tag].cmd == cmd) {
+				hba->wait_ccb = &hba->ccb[tag];
+				break;
+			}
+		if (tag >= host->can_queue)
+			goto out;
+	}
 
 	data = readl(base + ODBL);
 	if (data == 0 || data == 0xffffffff)
@@ -965,6 +901,7 @@ static int stex_abort(struct scsi_cmnd *
 	}
 
 fail_out:
+	stex_unmap_sg(hba, cmd);
 	hba->wait_ccb->req = NULL; /* nullify the req's future return */
 	hba->wait_ccb = NULL;
 	result = FAILED;
@@ -1025,7 +962,6 @@ static int stex_reset(struct scsi_cmnd *
 		return FAILED;
 	}
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->tag = 0;
 	hba->req_head = 0;
 	hba->req_tail = 0;
 	hba->status_head = 0;
@@ -1061,6 +997,7 @@ static struct scsi_host_template driver_
 	.proc_name			= DRV_NAME,
 	.bios_param			= stex_biosparam,
 	.queuecommand			= stex_queuecommand,
+	.slave_alloc			= stex_slave_alloc,
 	.slave_configure		= stex_slave_config,
 	.slave_destroy			= stex_slave_destroy,
 	.eh_abort_handler		= stex_abort,
@@ -1171,6 +1108,14 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
+	scsi_init_shared_tag_map(host, ST_CAN_QUEUE);
+	if (host->bqt == NULL) {
+		err = -ENOMEM;
+		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
+			pci_name(pdev));
+		goto out_free_irq;
+	}
+
 	pci_set_drvdata(pdev, hba);
 
 	err = scsi_add_host(host, &pdev->dev);
@@ -1206,15 +1151,7 @@ static void stex_hba_stop(struct st_hba 
 	struct req_msg *req;
 	unsigned long flags;
 	unsigned long before;
-	u16 tag;
-
-	before = jiffies;
-	while ((tag = stex_alloc_tag(hba, (unsigned long *)&hba->tag))
-		== TAG_BITMAP_LENGTH) {
-		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ))
-			return;
-		msleep(10);
-	}
+	u16 tag = 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	req = stex_alloc_req(hba);
@@ -1233,12 +1170,12 @@ static void stex_hba_stop(struct st_hba 
 	stex_send_cmd(hba, req, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	wait_event_timeout(hba->waitq,
-		!(hba->ccb[tag].req_type), ST_INTERNAL_TIMEOUT * HZ);
-	if (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE)
-		return;
-
-	stex_free_tag(hba, (unsigned long *)&hba->tag, tag);
+	before = jiffies;
+	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
+		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ))
+			return;
+		msleep(10);
+	}
 }
 
 static void stex_hba_free(struct st_hba *hba)

