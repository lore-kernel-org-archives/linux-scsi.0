From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 08/10] stex: use sg buffer copy helper functions
Date: Mon, 10 Mar 2008 12:02:52 -0700
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F9F7C7F@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:21344 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbYCJTCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 15:02:54 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org
Cc: tomof@acm.org, James Bottomley <James.Bottomley@SteelEye.com>



>-----Original Message-----
>From: fujita [mailto:tomof@acm.org] On Behalf Of FUJITA Tomonori
>Sent: Saturday, March 08, 2008 8:45 PM
>To: linux-scsi@vger.kernel.org
>Cc: tomof@acm.org; FUJITA Tomonori; Ed Lin; James Bottomley
>Subject: [PATCH 08/10] stex: use sg buffer copy helper functions
>
>
>This replaces stex_internal_copy with scsi_sg_copy_to/from_buffer.
>
>Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>Cc: Ed Lin <ed.lin@promise.com>
>Cc: James Bottomley <James.Bottomley@SteelEye.com>
>---
> drivers/scsi/stex.c |   66 
>+++++++-------------------------------------------
> 1 files changed, 10 insertions(+), 56 deletions(-)
>
>diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>index 654430e..8c7b183 100644
>--- a/drivers/scsi/stex.c
>+++ b/drivers/scsi/stex.c
>@@ -426,49 +426,13 @@ static int stex_map_sg(struct st_hba *hba,
> 	return 0;
> }
> 
>-static void stex_internal_copy(struct scsi_cmnd *cmd,
>-	const void *src, size_t *count, int sg_count, int direction)
>-{
>-	size_t lcount;
>-	size_t len;
>-	void *s, *d, *base = NULL;
>-	size_t offset;
>-
>-	if (*count > scsi_bufflen(cmd))
>-		*count = scsi_bufflen(cmd);
>-	lcount = *count;
>-	while (lcount) {
>-		len = lcount;
>-		s = (void *)src;
>-
>-		offset = *count - lcount;
>-		s += offset;
>-		base = scsi_kmap_atomic_sg(scsi_sglist(cmd),
>-					   sg_count, &offset, &len);
>-		if (!base) {
>-			*count -= lcount;
>-			return;
>-		}
>-		d = base + offset;
>-
>-		if (direction == ST_TO_CMD)
>-			memcpy(d, s, len);
>-		else
>-			memcpy(s, d, len);
>-
>-		lcount -= len;
>-		scsi_kunmap_atomic_sg(base);
>-	}
>-}
>-
> static void stex_controller_info(struct st_hba *hba, struct 
>st_ccb *ccb)
> {
> 	struct st_frame *p;
> 	size_t count = sizeof(struct st_frame);
> 
> 	p = hba->copy_buffer;
>-	stex_internal_copy(ccb->cmd, p, &count, scsi_sg_count(ccb->cmd),
>-			   ST_FROM_CMD);
>+	count = scsi_sg_copy_to_buffer(ccb->cmd, p, count);
> 	memset(p->base, 0, sizeof(u32)*6);
> 	*(unsigned long *)(p->base) = pci_resource_start(hba->pdev, 0);
> 	p->rom_addr = 0;
>@@ -486,8 +450,7 @@ static void stex_controller_info(struct 
>st_hba *hba, struct st_ccb *ccb)
> 	p->subid =
> 		hba->pdev->subsystem_vendor << 16 | 
>hba->pdev->subsystem_device;
> 
>-	stex_internal_copy(ccb->cmd, p, &count, scsi_sg_count(ccb->cmd),
>-			   ST_TO_CMD);
>+	count = scsi_sg_copy_from_buffer(ccb->cmd, p, count);
> }
> 
> static void
>@@ -554,10 +517,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, 
>void (* done)(struct scsi_cmnd *))
> 		unsigned char page;
> 		page = cmd->cmnd[2] & 0x3f;
> 		if (page == 0x8 || page == 0x3f) {
>-			size_t cp_len = sizeof(ms10_caching_page);
>-			stex_internal_copy(cmd, ms10_caching_page,
>-					   &cp_len, scsi_sg_count(cmd),
>-					   ST_TO_CMD);
>+			scsi_sg_copy_from_buffer(cmd, ms10_caching_page,
>+						 
>sizeof(ms10_caching_page));
> 			cmd->result = DID_OK << 16 | 
>COMMAND_COMPLETE << 8;
> 			done(cmd);
> 		} else
>@@ -586,10 +547,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, 
>void (* done)(struct scsi_cmnd *))
> 		if (id != host->max_id - 1)
> 			break;
> 		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
>-			size_t cp_len = sizeof(console_inq_page);
>-			stex_internal_copy(cmd, console_inq_page,
>-					   &cp_len, scsi_sg_count(cmd),
>-					   ST_TO_CMD);
>+			scsi_sg_copy_from_buffer(cmd, (void 
>*)console_inq_page,
>+						 
>sizeof(console_inq_page));
> 			cmd->result = DID_OK << 16 | 
>COMMAND_COMPLETE << 8;
> 			done(cmd);
> 		} else
>@@ -606,8 +565,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, 
>void (* done)(struct scsi_cmnd *))
> 			ver.signature[0] = PASSTHRU_SIGNATURE;
> 			ver.console_id = host->max_id - 1;
> 			ver.host_no = hba->host->host_no;
>-			stex_internal_copy(cmd, &ver, &cp_len,
>-					   scsi_sg_count(cmd), 
>ST_TO_CMD);
>+			cp_len = scsi_sg_copy_from_buffer(cmd, 
>&ver, cp_len);
> 			cmd->result = sizeof(ver) == cp_len ?
> 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
> 				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
>@@ -700,15 +658,12 @@ static void stex_copy_data(struct st_ccb *ccb,
> 
> 	if (ccb->cmd == NULL)
> 		return;
>-	stex_internal_copy(ccb->cmd,
>-		resp->variable, &count, 
>scsi_sg_count(ccb->cmd), ST_TO_CMD);
>+	count = scsi_sg_copy_from_buffer(ccb->cmd, 
>resp->variable, count);
> }
> 
> static void stex_ys_commands(struct st_hba *hba,
> 	struct st_ccb *ccb, struct status_msg *resp)
> {
>-	size_t count;
>-
> 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
> 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
> 		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
>@@ -724,9 +679,8 @@ static void stex_ys_commands(struct st_hba *hba,
> 		resp->scsi_status == SAM_STAT_GOOD) {
> 		ST_INQ *inq_data;
> 
>-		count = STEX_EXTRA_SIZE;
>-		stex_internal_copy(ccb->cmd, hba->copy_buffer,
>-			&count, scsi_sg_count(ccb->cmd), ST_FROM_CMD);
>+		scsi_sg_copy_to_buffer(ccb->cmd, hba->copy_buffer,
>+				       STEX_EXTRA_SIZE);
> 		inq_data = (ST_INQ *)hba->copy_buffer;
> 		if (inq_data->DeviceTypeQualifier != 0)
> 			ccb->srb_status = SRB_STATUS_SELECTION_TIMEOUT;
>-- 
>1.5.3.7
>
>

ACK patch 8.

Ed Lin
