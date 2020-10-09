Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF563C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6345C22277
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVkpKe77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbgJIR6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731500AbgJIR6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602266284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3G+H/JWLSlRdIyXhnSMRY5cZGfBOHRPwxI/3YP2dFiY=;
        b=WVkpKe77Yzoz7Dt8gpguq2INpjbumhUq2jQMAw5nZMA0BKiJaWW1rW+5sbkt5ph+K/Pmyy
        B2wPNYApYGrtADgMKq7IlsSDpl/n7hnSJ0U6r70ppa7nFkfh8PrZ5XEiHLnDKJYKy8m5hk
        DkfQkaLwaL49trt7juCVbzxzpqc7724=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-8fT2-tb3OmGFzc2bMRmwlA-1; Fri, 09 Oct 2020 13:58:02 -0400
X-MC-Unique: 8fT2-tb3OmGFzc2bMRmwlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC37F1084C88;
        Fri,  9 Oct 2020 17:58:00 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA5219D7C;
        Fri,  9 Oct 2020 17:57:59 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     Sagar.Biradar@microchip.com, aacraid@microsemi.com,
        Dave.Carroll@microchip.com, Balsundar.P@microchip.com
Subject: [PATCH 1/1] aacraid: remove needless code
Date:   Fri,  9 Oct 2020 19:57:58 +0200
Message-Id: <20201009175758.11731-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patch "bef18d308a22 scsi: aacraid: Disabling TM path
and only processing IOP reset"
has modified aac_hba_send so it returns -EINVAL for everything except
HBA_IU_TYPE_SCSI_TM_REQ command. That makes callers using other commands
useless - remove them together with related functions and make the test
in aac_hba_send more visible.
Patch also replaces a /* fall through */ comment.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/commsup.c |  12 +-
 drivers/scsi/aacraid/linit.c   | 379 +++++----------------------------
 2 files changed, 64 insertions(+), 327 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 7c0710417d37..77affdb56742 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -714,6 +714,9 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 	struct aac_hba_cmd_req *hbacmd = (struct aac_hba_cmd_req *)
 			fibptr->hw_fib_va;
 
+	if (command != HBA_IU_TYPE_SCSI_CMD_REQ)
+		return -EINVAL;
+
 	fibptr->flags = (FIB_CONTEXT_FLAG | FIB_CONTEXT_FLAG_NATIVE_HBA);
 	if (callback) {
 		wait = 0;
@@ -725,13 +728,10 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 
 	hbacmd->iu_type = command;
 
-	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
 		/* bit1 of request_id must be 0 */
-		hbacmd->request_id =
-			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
-		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
-	} else
-		return -EINVAL;
+	hbacmd->request_id =
+		cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
+	fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
 
 
 	if (wait) {
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7d99f7155a13..534285b9856e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -681,7 +681,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	int count, found;
+	int count;
 	u32 bus, cid;
 	int ret = FAILED;
 
@@ -690,334 +690,73 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
-	if (aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
-		struct fib *fib;
-		struct aac_hba_tm_req *tmf;
-		int status;
-		u64 address;
-
-		pr_err("%s: Host adapter abort request (%d,%d,%d,%d)\n",
-		 AAC_DRIVERNAME,
-		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
-
-		found = 0;
-		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-			fib = &aac->fibs[count];
-			if (*(u8 *)fib->hw_fib_va != 0 &&
-				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
-				(fib->callback_data == cmd)) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
-			return ret;
-
-		/* start a HBA_TMF_ABORT_TASK TMF request */
-		fib = aac_fib_alloc(aac);
-		if (!fib)
-			return ret;
-
-		tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
-		memset(tmf, 0, sizeof(*tmf));
-		tmf->tmf = HBA_TMF_ABORT_TASK;
-		tmf->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
-		tmf->lun[1] = cmd->device->lun;
-
-		address = (u64)fib->hw_error_pa;
-		tmf->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
-		tmf->error_ptr_lo = cpu_to_le32((u32)(address & 0xffffffff));
-		tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
-
-		fib->hbacmd_size = sizeof(*tmf);
-		cmd->SCp.sent_command = 0;
-
-		status = aac_hba_send(HBA_IU_TYPE_SCSI_TM_REQ, fib,
-				  (fib_callback) aac_hba_callback,
-				  (void *) cmd);
-		if (status != -EINPROGRESS) {
-			aac_fib_complete(fib);
-			aac_fib_free(fib);
-			return ret;
-		}
-		/* Wait up to 15 secs for completion */
-		for (count = 0; count < 15; ++count) {
-			if (cmd->SCp.sent_command) {
+	if (aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW)
+		return ret;
+
+	pr_err(
+		"%s: Host adapter abort request.\n"
+		"%s: Outstanding commands on (%d,%d,%d,%d):\n",
+		AAC_DRIVERNAME, AAC_DRIVERNAME,
+		host->host_no, sdev_channel(dev), sdev_id(dev),
+		(int)dev->lun);
+	switch (cmd->cmnd[0]) {
+	case SERVICE_ACTION_IN_16:
+		if (!(aac->raw_io_interface) ||
+		    !(aac->raw_io_64) ||
+		    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
+			break;
+		fallthrough;
+	case INQUIRY:
+	case READ_CAPACITY:
+		/*
+		 * Mark associated FIB to not complete,
+		 * eh handler does this
+		 */
+		for (count = 0;
+			count < (host->can_queue + AAC_NUM_MGT_FIB);
+			++count) {
+			struct fib *fib = &aac->fibs[count];
+
+			if (fib->hw_fib_va->header.XferState &&
+			(fib->flags & FIB_CONTEXT_FLAG) &&
+			(fib->callback_data == cmd)) {
+				fib->flags |=
+					FIB_CONTEXT_FLAG_TIMED_OUT;
+				cmd->SCp.phase =
+					AAC_OWNER_ERROR_HANDLER;
 				ret = SUCCESS;
-				break;
 			}
-			msleep(1000);
 		}
+		break;
+	case TEST_UNIT_READY:
+		/*
+		 * Mark associated FIB to not complete,
+		 * eh handler does this
+		 */
+		for (count = 0;
+			count < (host->can_queue + AAC_NUM_MGT_FIB);
+			++count) {
+			struct scsi_cmnd *command;
+			struct fib *fib = &aac->fibs[count];
 
-		if (ret != SUCCESS)
-			pr_err("%s: Host adapter abort request timed out\n",
-			AAC_DRIVERNAME);
-	} else {
-		pr_err(
-			"%s: Host adapter abort request.\n"
-			"%s: Outstanding commands on (%d,%d,%d,%d):\n",
-			AAC_DRIVERNAME, AAC_DRIVERNAME,
-			host->host_no, sdev_channel(dev), sdev_id(dev),
-			(int)dev->lun);
-		switch (cmd->cmnd[0]) {
-		case SERVICE_ACTION_IN_16:
-			if (!(aac->raw_io_interface) ||
-			    !(aac->raw_io_64) ||
-			    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
-				break;
-			/* fall through */
-		case INQUIRY:
-		case READ_CAPACITY:
-			/*
-			 * Mark associated FIB to not complete,
-			 * eh handler does this
-			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
-				struct fib *fib = &aac->fibs[count];
-
-				if (fib->hw_fib_va->header.XferState &&
+			command = fib->callback_data;
+
+			if ((fib->hw_fib_va->header.XferState &
+				cpu_to_le32
+				(Async | NoResponseExpected)) &&
 				(fib->flags & FIB_CONTEXT_FLAG) &&
-				(fib->callback_data == cmd)) {
-					fib->flags |=
-						FIB_CONTEXT_FLAG_TIMED_OUT;
-					cmd->SCp.phase =
-						AAC_OWNER_ERROR_HANDLER;
+				((command)) &&
+				(command->device == cmd->device)) {
+				fib->flags |=
+					FIB_CONTEXT_FLAG_TIMED_OUT;
+				command->SCp.phase =
+					AAC_OWNER_ERROR_HANDLER;
+				if (command == cmd)
 					ret = SUCCESS;
-				}
 			}
-			break;
-		case TEST_UNIT_READY:
-			/*
-			 * Mark associated FIB to not complete,
-			 * eh handler does this
-			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
-				struct scsi_cmnd *command;
-				struct fib *fib = &aac->fibs[count];
-
-				command = fib->callback_data;
-
-				if ((fib->hw_fib_va->header.XferState &
-					cpu_to_le32
-					(Async | NoResponseExpected)) &&
-					(fib->flags & FIB_CONTEXT_FLAG) &&
-					((command)) &&
-					(command->device == cmd->device)) {
-					fib->flags |=
-						FIB_CONTEXT_FLAG_TIMED_OUT;
-					command->SCp.phase =
-						AAC_OWNER_ERROR_HANDLER;
-					if (command == cmd)
-						ret = SUCCESS;
-				}
-			}
-			break;
 		}
-	}
-	return ret;
-}
-
-static u8 aac_eh_tmf_lun_reset_fib(struct aac_hba_map_info *info,
-				   struct fib *fib, u64 tmf_lun)
-{
-	struct aac_hba_tm_req *tmf;
-	u64 address;
-
-	/* start a HBA_TMF_LUN_RESET TMF request */
-	tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
-	memset(tmf, 0, sizeof(*tmf));
-	tmf->tmf = HBA_TMF_LUN_RESET;
-	tmf->it_nexus = info->rmw_nexus;
-	int_to_scsilun(tmf_lun, (struct scsi_lun *)tmf->lun);
-
-	address = (u64)fib->hw_error_pa;
-	tmf->error_ptr_hi = cpu_to_le32
-		((u32)(address >> 32));
-	tmf->error_ptr_lo = cpu_to_le32
-		((u32)(address & 0xffffffff));
-	tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
-	fib->hbacmd_size = sizeof(*tmf);
-
-	return HBA_IU_TYPE_SCSI_TM_REQ;
-}
-
-static u8 aac_eh_tmf_hard_reset_fib(struct aac_hba_map_info *info,
-				    struct fib *fib)
-{
-	struct aac_hba_reset_req *rst;
-	u64 address;
-
-	/* already tried, start a hard reset now */
-	rst = (struct aac_hba_reset_req *)fib->hw_fib_va;
-	memset(rst, 0, sizeof(*rst));
-	rst->it_nexus = info->rmw_nexus;
-
-	address = (u64)fib->hw_error_pa;
-	rst->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
-	rst->error_ptr_lo = cpu_to_le32((u32)(address & 0xffffffff));
-	rst->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
-	fib->hbacmd_size = sizeof(*rst);
-
-       return HBA_IU_TYPE_SATA_REQ;
-}
-
-static void aac_tmf_callback(void *context, struct fib *fibptr)
-{
-	struct aac_hba_resp *err =
-		&((struct aac_native_hba *)fibptr->hw_fib_va)->resp.err;
-	struct aac_hba_map_info *info = context;
-	int res;
-
-	switch (err->service_response) {
-	case HBA_RESP_SVCRES_TMF_REJECTED:
-		res = -1;
-		break;
-	case HBA_RESP_SVCRES_TMF_LUN_INVALID:
-		res = 0;
-		break;
-	case HBA_RESP_SVCRES_TMF_COMPLETE:
-	case HBA_RESP_SVCRES_TMF_SUCCEEDED:
-		res = 0;
-		break;
-	default:
-		res = -2;
 		break;
 	}
-	aac_fib_complete(fibptr);
-
-	info->reset_state = res;
-}
-
-/*
- *	aac_eh_dev_reset	- Device reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
- *
- */
-static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
-{
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
-	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	struct aac_hba_map_info *info;
-	int count;
-	u32 bus, cid;
-	struct fib *fib;
-	int ret = FAILED;
-	int status;
-	u8 command;
-
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
-
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
-		return FAILED;
-
-	info = &aac->hba_map[bus][cid];
-
-	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
-	 !(info->reset_state > 0)))
-		return FAILED;
-
-	pr_err("%s: Host device reset request. SCSI hang ?\n",
-	       AAC_DRIVERNAME);
-
-	fib = aac_fib_alloc(aac);
-	if (!fib)
-		return ret;
-
-	/* start a HBA_TMF_LUN_RESET TMF request */
-	command = aac_eh_tmf_lun_reset_fib(info, fib, dev->lun);
-
-	info->reset_state = 1;
-
-	status = aac_hba_send(command, fib,
-			      (fib_callback) aac_tmf_callback,
-			      (void *) info);
-	if (status != -EINPROGRESS) {
-		info->reset_state = 0;
-		aac_fib_complete(fib);
-		aac_fib_free(fib);
-		return ret;
-	}
-	/* Wait up to 15 seconds for completion */
-	for (count = 0; count < 15; ++count) {
-		if (info->reset_state == 0) {
-			ret = info->reset_state == 0 ? SUCCESS : FAILED;
-			break;
-		}
-		msleep(1000);
-	}
-
-	return ret;
-}
-
-/*
- *	aac_eh_target_reset	- Target reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
- *
- */
-static int aac_eh_target_reset(struct scsi_cmnd *cmd)
-{
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
-	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	struct aac_hba_map_info *info;
-	int count;
-	u32 bus, cid;
-	int ret = FAILED;
-	struct fib *fib;
-	int status;
-	u8 command;
-
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
-
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
-		return FAILED;
-
-	info = &aac->hba_map[bus][cid];
-
-	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
-	 !(info->reset_state > 0)))
-		return FAILED;
-
-	pr_err("%s: Host target reset request. SCSI hang ?\n",
-	       AAC_DRIVERNAME);
-
-	fib = aac_fib_alloc(aac);
-	if (!fib)
-		return ret;
-
-
-	/* already tried, start a hard reset now */
-	command = aac_eh_tmf_hard_reset_fib(info, fib);
-
-	info->reset_state = 2;
-
-	status = aac_hba_send(command, fib,
-			      (fib_callback) aac_tmf_callback,
-			      (void *) info);
-
-	if (status != -EINPROGRESS) {
-		info->reset_state = 0;
-		aac_fib_complete(fib);
-		aac_fib_free(fib);
-		return ret;
-	}
-
-	/* Wait up to 15 seconds for completion */
-	for (count = 0; count < 15; ++count) {
-		if (info->reset_state <= 0) {
-			ret = info->reset_state == 0 ? SUCCESS : FAILED;
-			break;
-		}
-		msleep(1000);
-	}
-
 	return ret;
 }
 
@@ -1545,8 +1284,6 @@ static struct scsi_host_template aac_driver_template = {
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_attrs			= aac_dev_attrs,
 	.eh_abort_handler		= aac_eh_abort,
-	.eh_device_reset_handler	= aac_eh_dev_reset,
-	.eh_target_reset_handler	= aac_eh_target_reset,
 	.eh_bus_reset_handler		= aac_eh_bus_reset,
 	.eh_host_reset_handler		= aac_eh_host_reset,
 	.can_queue			= AAC_NUM_IO_FIB,
-- 
2.25.4

