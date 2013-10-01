From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 2/4] esas2r: Fixes for big-endian platforms
Date: Tue, 1 Oct 2013 14:26:02 -0400
Message-ID: <1380651964-8124-2-git-send-email-bgrove@attotech.com>
References: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:51974 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751803Ab3JASfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 14:35:25 -0400
In-Reply-To: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>

In esas2r_format_init_msg(), sgl_page_size and epoch_time params
are converted to little endian and the firmware version read from
the hba is converted to cpu endianess.

In esas2r_rq_init_request, correct and simplify the construction
of the SCSI handle.

These fixes are the result of testing on a PPC64 machine.

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r.h      |  7 ++-----
 drivers/scsi/esas2r/esas2r_init.c | 11 +++++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index d128c96..3fd305d 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -1207,7 +1207,6 @@ static inline void esas2r_rq_init_request(struct esas2r_request *rq,
 					  struct esas2r_adapter *a)
 {
 	union atto_vda_req *vrq = rq->vrq;
-	u32 handle;
 
 	INIT_LIST_HEAD(&rq->sg_table_head);
 	rq->data_buf = (void *)(vrq + 1);
@@ -1243,11 +1242,9 @@ static inline void esas2r_rq_init_request(struct esas2r_request *rq,
 
 	/*
 	 * add a reference number to the handle to make it unique (until it
-	 * wraps of course) while preserving the upper word
+	 * wraps of course) while preserving the least significant word
 	 */
-
-	handle = be32_to_cpu(vrq->scsi.handle) & 0xFFFF0000;
-	vrq->scsi.handle = cpu_to_be32(handle + a->cmd_ref_no++);
+	vrq->scsi.handle = (a->cmd_ref_no++ << 16) | (u16)vrq->scsi.handle;
 
 	/*
 	 * the following formats a SCSI request.  the caller can override as
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 15d222b..8278819 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -1235,8 +1235,8 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 				     0,
 				     NULL);
 		ci = (struct atto_vda_cfg_init *)&rq->vrq->cfg.data.init;
-		ci->sgl_page_size = sgl_page_size;
-		ci->epoch_time = now.tv_sec;
+		ci->sgl_page_size = cpu_to_le32(sgl_page_size);
+		ci->epoch_time = cpu_to_le32(now.tv_sec);
 		rq->flags |= RF_FAILURE_OK;
 		a->init_msg = ESAS2R_INIT_MSG_INIT;
 		break;
@@ -1246,12 +1246,15 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 		if (rq->req_stat == RS_SUCCESS) {
 			u32 major;
 			u32 minor;
+			u16 fw_release;
 
 			a->fw_version = le16_to_cpu(
 				rq->func_rsp.cfg_rsp.vda_version);
 			a->fw_build = rq->func_rsp.cfg_rsp.fw_build;
-			major = LOBYTE(rq->func_rsp.cfg_rsp.fw_release);
-			minor = HIBYTE(rq->func_rsp.cfg_rsp.fw_release);
+			fw_release = le16_to_cpu(
+				rq->func_rsp.cfg_rsp.fw_release);
+			major = LOBYTE(fw_release);
+			minor = HIBYTE(fw_release);
 			a->fw_version += (major << 16) + (minor << 24);
 		} else {
 			esas2r_hdebug("FAILED");
-- 
1.8.3.1

