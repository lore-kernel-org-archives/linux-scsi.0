From: Ed Lin <ed.lin@promise.com>
Subject: [PATCH 4/5][resend] stex: Small fixes
Date: Mon, 26 Jan 2009 15:34:24 -0800
Message-ID: <f60baa940901261534i2d06cfdep468446df612550c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:57477 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZAZXe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 18:34:26 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2681375yxm.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 15:34:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: promise_linux <promise_linux@promise.com>, linux-scsi@vger.kernel.org

Some small fixes, including:
- add data direction in req_msg because new firmware version
  may require this (backward compatible)
- change internal timeout value
- change judgment of type st_vsc1
- blank line handling, etc.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 425a61c..c1a79c3 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -103,7 +103,7 @@ enum {
 	MU_REQ_COUNT				= (MU_MAX_REQUEST + 1),
 	MU_STATUS_COUNT				= (MU_MAX_REQUEST + 1),

-	STEX_CDB_LENGTH				= MAX_COMMAND_SIZE,
+	STEX_CDB_LENGTH				= 16,
 	REQ_VARIABLE_LEN			= 1024,
 	STATUS_VAR_LEN				= 128,
 	ST_CAN_QUEUE				= MU_MAX_REQUEST,
@@ -114,6 +114,9 @@ enum {
 	SG_CF_EOT				= 0x80,	/* end of table */
 	SG_CF_64B				= 0x40,	/* 64 bit item */
 	SG_CF_HOST				= 0x20,	/* sg in host memory */
+	MSG_DATA_DIR_ND				= 0,
+	MSG_DATA_DIR_IN				= 1,
+	MSG_DATA_DIR_OUT			= 2,

 	st_shasta				= 0,
 	st_vsc					= 1,
@@ -123,7 +126,7 @@ enum {

 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
-	ST_INTERNAL_TIMEOUT			= 30,
+	ST_INTERNAL_TIMEOUT			= 180,

 	ST_TO_CMD				= 0,
 	ST_FROM_CMD				= 1,
@@ -194,7 +197,7 @@ struct req_msg {
 	u8 target;
 	u8 task_attr;
 	u8 task_manage;
-	u8 prd_entry;
+	u8 data_dir;
 	u8 payload_sz;		/* payload size in 4-byte, not used */
 	u8 cdb[STEX_CDB_LENGTH];
 	u8 variable[REQ_VARIABLE_LEN];
@@ -318,8 +321,8 @@ MODULE_VERSION(ST_DRIVER_VERSION);
 static void stex_gettime(__le32 *time)
 {
 	struct timeval tv;
-	do_gettimeofday(&tv);

+	do_gettimeofday(&tv);
 	*time = cpu_to_le32(tv.tv_sec & 0xffffffff);
 	*(time + 1) = cpu_to_le32((tv.tv_sec >> 16) >> 16);
 }
@@ -340,7 +343,7 @@ static void stex_invalid_field(struct scsi_cmnd *cmd,
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;

-	/* "Invalid field in cbd" */
+	/* "Invalid field in cdb" */
 	scsi_build_sense_buffer(0, cmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
 				0x0);
 	done(cmd);
@@ -469,6 +472,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (*
done)(struct scsi_cmnd *))
 	unsigned int id,lun;
 	struct req_msg *req;
 	u16 tag;
+
 	host = cmd->device->host;
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -480,6 +484,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (*
done)(struct scsi_cmnd *))
 		static char ms10_caching_page[12] =
 			{ 0, 0x12, 0, 0, 0, 0, 0, 0, 0x8, 0xa, 0x4, 0 };
 		unsigned char page;
+
 		page = cmd->cmnd[2] & 0x3f;
 		if (page == 0x8 || page == 0x3f) {
 			scsi_sg_copy_from_buffer(cmd, ms10_caching_page,
@@ -523,6 +528,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (*
done)(struct scsi_cmnd *))
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
 			struct st_drvver ver;
 			size_t cp_len = sizeof(ver);
+
 			ver.major = ST_VER_MAJOR;
 			ver.minor = ST_VER_MINOR;
 			ver.oem = ST_OEM;
@@ -556,6 +562,13 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (*
done)(struct scsi_cmnd *))
 	/* cdb */
 	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);

+	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		req->data_dir = MSG_DATA_DIR_IN;
+	else if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		req->data_dir = MSG_DATA_DIR_OUT;
+	else
+		req->data_dir = MSG_DATA_DIR_ND;
+
 	hba->ccb[tag].cmd = cmd;
 	hba->ccb[tag].sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	hba->ccb[tag].sense_buffer = cmd->sense_buffer;
@@ -614,6 +627,7 @@ static void stex_copy_data(struct st_ccb *ccb,
 	struct status_msg *resp, unsigned int variable)
 {
 	size_t count = variable;
+
 	if (resp->scsi_status != SAM_STAT_GOOD) {
 		if (ccb->sense_buffer != NULL)
 			memcpy(ccb->sense_buffer, resp->variable,
@@ -938,6 +952,7 @@ static int stex_reset(struct scsi_cmnd *cmd)
 	struct st_hba *hba;
 	unsigned long flags;
 	unsigned long before;
+
 	hba = (struct st_hba *) &cmd->device->host->hostdata[0];

 	printk(KERN_INFO DRV_NAME
@@ -1022,6 +1037,7 @@ static struct scsi_host_template driver_template = {
 static int stex_set_dma_mask(struct pci_dev * pdev)
 {
 	int ret;
+
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
 		&& !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
 		return 0;
@@ -1079,7 +1095,7 @@ stex_probe(struct pci_dev *pdev, const struct
pci_device_id *id)
 	}

 	hba->cardtype = (unsigned int) id->driver_data;
-	if (hba->cardtype == st_vsc && (pdev->subsystem_device & 0xf) == 0x1)
+	if (hba->cardtype == st_vsc && (pdev->subsystem_device & 1))
 		hba->cardtype = st_vsc1;
 	hba->dma_size = (hba->cardtype == st_vsc1 || hba->cardtype == st_seq) ?
 		(STEX_BUFFER_SIZE + ST_ADDITIONAL_MEM) : (STEX_BUFFER_SIZE);
