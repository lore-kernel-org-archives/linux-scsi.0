From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 09/30] scsi: aacraid: Create bmic submission function from bmic identify
Date: Tue, 26 Dec 2017 20:34:30 -0800
Message-ID: <20171227043451.27813-10-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0058.outbound.protection.outlook.com ([104.47.32.58]:39984
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751495AbdL0EfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:11 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

safw command submission is duplicated across many functions.

Move the safw submission code from bmic identify into its own function
for common use

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  | 147 +++++++++++++++++++++++++++--------------
 drivers/scsi/aacraid/aacraid.h |   7 +-
 2 files changed, 105 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 7173ae5..e02158d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1667,60 +1667,116 @@ static int aac_adapter_hba(struct fib *fib, struct scsi_cmnd *cmd)
 				  (void *) cmd);
 }
 
-int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
+static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
+	struct aac_srb_unit *srbu, void *xfer_buf, int xfer_len)
 {
-	struct fib *fibptr;
-	struct aac_srb *srbcmd;
-	struct sgmap64 *sg64;
-	struct aac_ciss_identify_pd *identify_resp;
-	dma_addr_t addr;
-	u32 vbus, vid;
-	u16 fibsize, datasize;
-	int rcode = -ENOMEM;
-
+	struct fib	*fibptr;
+	dma_addr_t	addr;
+	int		rcode;
+	int		fibsize;
+	struct aac_srb	*srb;
+	struct aac_srb_reply *srb_reply;
+	struct sgmap64	*sg64;
+	u32 vbus;
+	u32 vid;
+
+	if (!dev->sa_firmware)
+		return 0;
 
+	/* allocate FIB */
 	fibptr = aac_fib_alloc(dev);
 	if (!fibptr)
-		goto out;
+		return -ENOMEM;
 
-	fibsize = sizeof(struct aac_srb) -
-			sizeof(struct sgentry) + sizeof(struct sgentry64);
-	datasize = sizeof(struct aac_ciss_identify_pd);
+	aac_fib_init(fibptr);
+	fibptr->hw_fib_va->header.XferState &=
+		~cpu_to_le32(FastResponseCapable);
 
-	identify_resp = dma_alloc_coherent(&dev->pdev->dev, datasize, &addr,
-					   GFP_KERNEL);
-	if (!identify_resp)
-		goto fib_free_ptr;
+	fibsize  = sizeof(struct aac_srb) - sizeof(struct sgentry) +
+						sizeof(struct sgentry64);
 
-	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
-	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_target);
+	/* allocate DMA buffer for response */
+	addr = dma_map_single(&dev->pdev->dev, xfer_buf, xfer_len,
+							DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&dev->pdev->dev, addr)) {
+		rcode = -ENOMEM;
+		goto fib_error;
+	}
 
-	aac_fib_init(fibptr);
+	srb = fib_data(fibptr);
+	memcpy(srb, &srbu->srb, sizeof(struct aac_srb));
 
-	srbcmd = (struct aac_srb *) fib_data(fibptr);
-	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel  = cpu_to_le32(vbus);
-	srbcmd->id       = cpu_to_le32(vid);
-	srbcmd->lun      = 0;
-	srbcmd->flags    = cpu_to_le32(SRB_DataIn);
-	srbcmd->timeout  = cpu_to_le32(10);
-	srbcmd->retry_limit = 0;
-	srbcmd->cdb_size = cpu_to_le32(12);
-	srbcmd->count = cpu_to_le32(datasize);
+	vbus = (u32)le16_to_cpu(
+			dev->supplement_adapter_info.virt_device_bus);
+	vid  = (u32)le16_to_cpu(
+			dev->supplement_adapter_info.virt_device_target);
 
-	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
-	srbcmd->cdb[0] = 0x26;
-	srbcmd->cdb[2] = (u8)((AAC_MAX_LUN + target) & 0x00FF);
-	srbcmd->cdb[6] = CISS_IDENTIFY_PHYSICAL_DEVICE;
+	/* set the common request fields */
+	srb->channel		= cpu_to_le32(vbus);
+	srb->id			= cpu_to_le32(vid);
+	srb->lun		= 0;
+	srb->function		= cpu_to_le32(SRBF_ExecuteScsi);
+	srb->timeout		= 0;
+	srb->retry_limit	= 0;
+	srb->cdb_size		= cpu_to_le32(16);
+	srb->count		= cpu_to_le32(xfer_len);
+
+	sg64 = (struct sgmap64 *)&srb->sg;
+	sg64->count		= cpu_to_le32(1);
+	sg64->sg[0].addr[1]	= cpu_to_le32(upper_32_bits(addr));
+	sg64->sg[0].addr[0]	= cpu_to_le32(lower_32_bits(addr));
+	sg64->sg[0].count	= cpu_to_le32(xfer_len);
 
-	sg64 = (struct sgmap64 *)&srbcmd->sg;
-	sg64->count = cpu_to_le32(1);
-	sg64->sg[0].addr[1] = cpu_to_le32((u32)(((addr) >> 16) >> 16));
-	sg64->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
-	sg64->sg[0].count = cpu_to_le32(datasize);
+	/*
+	 * Copy the updated data for other dumping or other usage if needed
+	 */
+	memcpy(&srbu->srb, srb, sizeof(struct aac_srb));
+
+	/* issue request to the controller */
+	rcode = aac_fib_send(ScsiPortCommand64, fibptr, fibsize, FsaNormal,
+					1, 1, NULL, NULL);
+
+	if (rcode == -ERESTARTSYS)
+		rcode = -ERESTART;
+
+	if (unlikely(rcode < 0))
+		goto bmic_error;
+
+	srb_reply = (struct aac_srb_reply *)fib_data(fibptr);
+	memcpy(&srbu->srb_reply, srb_reply, sizeof(struct aac_srb_reply));
+
+bmic_error:
+	dma_unmap_single(&dev->pdev->dev, addr, xfer_len, DMA_BIDIRECTIONAL);
+fib_error:
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
+	return rcode;
+}
+
+static int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
+{
+	int rcode = -ENOMEM;
+	u16 datasize;
+	struct aac_srb_unit srbu;
+	struct aac_srb *srbcmd;
+	struct aac_ciss_identify_pd *identify_resp;
+
+	datasize = sizeof(struct aac_ciss_identify_pd);
+	identify_resp = kmalloc(datasize, GFP_KERNEL);
+	if (!identify_resp)
+		goto out;
+
+	memset(&srbu, 0, sizeof(struct aac_srb_unit));
 
-	rcode = aac_fib_send(ScsiPortCommand64,
-		fibptr, fibsize, FsaNormal, 1, 1, NULL, NULL);
+	srbcmd = &srbu.srb;
+	srbcmd->flags	= cpu_to_le32(SRB_DataIn);
+	srbcmd->cdb[0]	= 0x26;
+	srbcmd->cdb[2]	= (u8)((AAC_MAX_LUN + target) & 0x00FF);
+	srbcmd->cdb[6]	= CISS_IDENTIFY_PHYSICAL_DEVICE;
+
+	rcode = aac_send_safw_bmic_cmd(dev, &srbu, identify_resp, datasize);
+	if (unlikely(rcode < 0))
+		goto out;
 
 	if (identify_resp->current_queue_depth_limit <= 0 ||
 		identify_resp->current_queue_depth_limit > 32)
@@ -1729,12 +1785,7 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 		dev->hba_map[bus][target].qd_limit =
 			identify_resp->current_queue_depth_limit;
 
-	dma_free_coherent(&dev->pdev->dev, datasize, identify_resp, addr);
-
-	aac_fib_complete(fibptr);
-
-fib_free_ptr:
-	aac_fib_free(fibptr);
+	kfree(identify_resp);
 out:
 	return rcode;
 }
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 403a639..bc2a0bc 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2021,6 +2021,12 @@ struct aac_srb_reply
 	__le32		sense_data_size;
 	u8		sense_data[AAC_SENSE_BUFFERSIZE]; // Can this be SCSI_SENSE_BUFFERSIZE
 };
+
+struct aac_srb_unit {
+	struct aac_srb		srb;
+	struct aac_srb_reply	srb_reply;
+};
+
 /*
  * SRB Flags
  */
@@ -2634,7 +2640,6 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
 int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan);
-int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
-- 
2.9.4
