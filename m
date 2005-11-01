From: brking@us.ibm.com
Subject: [PATCH 12/26] ipr: Fix adapter microcode update DMA mapping leak
Date: Tue, 01 Nov 2005 17:01:27 -0600
Message-ID: <200511012301.jA1N1SxX014736@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60042 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751408AbVKAXB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:29 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1Txb021811
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:29 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1Tbn082314
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:29 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1Svl014756
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


If the write buffer command that is issued to the ipr adapter
to update its microcode fails for some reason, the DMA buffer
will never get unmapped. Move the pci_map/unmap out of the
IOA reset job so that the buffer is always clearly mapped
and unmapped.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |  104 ++++++++++++++++++++++++++++-------------------------
 drivers/scsi/ipr.h |    1 
 2 files changed, 56 insertions(+), 49 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_write_buffer_leak drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_write_buffer_leak	2005-10-31 21:53:12.040957856 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:12.099948888 -0600
@@ -2351,31 +2351,24 @@ static int ipr_copy_ucode_buffer(struct 
 }
 
 /**
- * ipr_map_ucode_buffer - Map a microcode download buffer
+ * ipr_build_ucode_ioadl - Build a microcode download IOADL
  * @ipr_cmd:	ipr command struct
  * @sglist:		scatter/gather list
- * @len:		total length of download buffer
  *
- * Maps a microcode download scatter/gather list for DMA and
- * builds the IOADL.
+ * Builds a microcode download IOA data list (IOADL).
  *
- * Return value:
- * 	0 on success / -EIO on failure
  **/
-static int ipr_map_ucode_buffer(struct ipr_cmnd *ipr_cmd,
-				struct ipr_sglist *sglist, int len)
+static void ipr_build_ucode_ioadl(struct ipr_cmnd *ipr_cmd,
+				  struct ipr_sglist *sglist)
 {
-	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 	struct scatterlist *scatterlist = sglist->scatterlist;
 	int i;
 
-	ipr_cmd->dma_use_sg = pci_map_sg(ioa_cfg->pdev, scatterlist,
-					 sglist->num_sg, DMA_TO_DEVICE);
-
+	ipr_cmd->dma_use_sg = sglist->num_dma_sg;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
-	ioarcb->write_data_transfer_length = cpu_to_be32(len);
+	ioarcb->write_data_transfer_length = cpu_to_be32(sglist->buffer_len);
 	ioarcb->write_ioadl_len =
 		cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
 
@@ -2386,15 +2379,52 @@ static int ipr_map_ucode_buffer(struct i
 			cpu_to_be32(sg_dma_address(&scatterlist[i]));
 	}
 
-	if (likely(ipr_cmd->dma_use_sg)) {
-		ioadl[i-1].flags_and_data_len |=
-			cpu_to_be32(IPR_IOADL_FLAGS_LAST);
+	ioadl[i-1].flags_and_data_len |=
+		cpu_to_be32(IPR_IOADL_FLAGS_LAST);
+}
+
+/**
+ * ipr_update_ioa_ucode - Update IOA's microcode
+ * @ioa_cfg:	ioa config struct
+ * @sglist:		scatter/gather list
+ *
+ * Initiate an adapter reset to update the IOA's microcode
+ *
+ * Return value:
+ * 	0 on success / -EIO on failure
+ **/
+static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
+				struct ipr_sglist *sglist)
+{
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+
+	if (ioa_cfg->ucode_sglist) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		dev_err(&ioa_cfg->pdev->dev,
+			"Microcode download already in progress\n");
+		return -EIO;
 	}
-	else {
-		dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
+
+	sglist->num_dma_sg = pci_map_sg(ioa_cfg->pdev, sglist->scatterlist,
+					sglist->num_sg, DMA_TO_DEVICE);
+
+	if (!sglist->num_dma_sg) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		dev_err(&ioa_cfg->pdev->dev,
+			"Failed to map microcode download buffer!\n");
 		return -EIO;
 	}
 
+	ioa_cfg->ucode_sglist = sglist;
+	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	ioa_cfg->ucode_sglist = NULL;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
 }
 
@@ -2417,7 +2447,6 @@ static ssize_t ipr_store_update_fw(struc
 	struct ipr_ucode_image_header *image_hdr;
 	const struct firmware *fw_entry;
 	struct ipr_sglist *sglist;
-	unsigned long lock_flags;
 	char fname[100];
 	char *src;
 	int len, result, dnld_size;
@@ -2458,35 +2487,17 @@ static ssize_t ipr_store_update_fw(struc
 	if (result) {
 		dev_err(&ioa_cfg->pdev->dev,
 			"Microcode buffer copy to DMA buffer failed\n");
-		ipr_free_ucode_buffer(sglist);
-		release_firmware(fw_entry);
-		return result;
-	}
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-
-	if (ioa_cfg->ucode_sglist) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		dev_err(&ioa_cfg->pdev->dev,
-			"Microcode download already in progress\n");
-		ipr_free_ucode_buffer(sglist);
-		release_firmware(fw_entry);
-		return -EIO;
+		goto out;
 	}
 
-	ioa_cfg->ucode_sglist = sglist;
-	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	ioa_cfg->ucode_sglist = NULL;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	result = ipr_update_ioa_ucode(ioa_cfg, sglist);
 
+	if (!result)
+		result = count;
+out:
 	ipr_free_ucode_buffer(sglist);
 	release_firmware(fw_entry);
-
-	return count;
+	return result;
 }
 
 static struct class_device_attribute ipr_update_fw_attr = {
@@ -5291,12 +5302,7 @@ static int ipr_reset_ucode_download(stru
 	ipr_cmd->ioarcb.cmd_pkt.cdb[7] = (sglist->buffer_len & 0x00ff00) >> 8;
 	ipr_cmd->ioarcb.cmd_pkt.cdb[8] = sglist->buffer_len & 0x0000ff;
 
-	if (ipr_map_ucode_buffer(ipr_cmd, sglist, sglist->buffer_len)) {
-		dev_err(&ioa_cfg->pdev->dev,
-			"Failed to map microcode download buffer\n");
-		return IPR_RC_JOB_CONTINUE;
-	}
-
+	ipr_build_ucode_ioadl(ipr_cmd, sglist);
 	ipr_cmd->job_step = ipr_reset_ucode_download_done;
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
diff -puN drivers/scsi/ipr.h~ipr_write_buffer_leak drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_write_buffer_leak	2005-10-31 21:53:12.043957400 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-31 21:53:12.100948736 -0600
@@ -811,6 +811,7 @@ struct ipr_trace_entry {
 struct ipr_sglist {
 	u32 order;
 	u32 num_sg;
+	u32 num_dma_sg;
 	u32 buffer_len;
 	struct scatterlist scatterlist[1];
 };
_
