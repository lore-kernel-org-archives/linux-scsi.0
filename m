From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 4/5] ipr: Issue Configure Cache Parameters command.
Date: Fri, 30 Oct 2015 14:49:08 -0200
Message-ID: <1446223749-17416-4-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53557 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbJ3Qtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 12:49:33 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 14:49:29 -0200
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 9E5CC1DC0060
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 12:48:23 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UGlNNV20906272
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:47:23 -0200
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UGnQY3023181
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:49:26 -0200
In-Reply-To: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Some new adapters require a special Configure Cache Parameters command
to enable the adapter write cache, so send this during the adapter
initialization if the adapter requires it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ipr.h |  4 ++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a9f825a..c83afeb 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7671,6 +7671,63 @@ static int ipr_ioafp_query_ioa_cfg(struct ipr_cmnd *ipr_cmd)
 	return IPR_RC_JOB_RETURN;
 }
 
+static int ipr_ioa_service_action_failed(struct ipr_cmnd *ipr_cmd)
+{
+	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
+
+	if (ioasc == IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT)
+		return IPR_RC_JOB_CONTINUE;
+
+	return ipr_reset_cmd_failed(ipr_cmd);
+}
+
+static void ipr_build_ioa_service_action(struct ipr_cmnd *ipr_cmd,
+					 __be32 res_handle, u8 sa_code)
+{
+	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
+
+	ioarcb->res_handle = res_handle;
+	ioarcb->cmd_pkt.cdb[0] = IPR_IOA_SERVICE_ACTION;
+	ioarcb->cmd_pkt.cdb[1] = sa_code;
+	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
+}
+
+/**
+ * ipr_ioafp_set_caching_parameters - Issue Set Cache parameters service
+ * action
+ *
+ * Return value:
+ * 	none
+ **/
+static int ipr_ioafp_set_caching_parameters(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
+
+	ENTER;
+
+	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+
+	if (pageC4->cache_cap[0] & IPR_CAP_SYNC_CACHE) {
+		ipr_build_ioa_service_action(ipr_cmd,
+					     cpu_to_be32(IPR_IOA_RES_HANDLE),
+					     IPR_IOA_SA_CHANGE_CACHE_PARAMS);
+
+		ioarcb->cmd_pkt.cdb[2] = 0x40;
+
+		ipr_cmd->job_step_failed = ipr_ioa_service_action_failed;
+		ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
+			   IPR_SET_SUP_DEVICE_TIMEOUT);
+
+		LEAVE;
+		return IPR_RC_JOB_RETURN;
+	}
+
+	LEAVE;
+	return IPR_RC_JOB_CONTINUE;
+}
+
 /**
  * ipr_ioafp_inquiry - Send an Inquiry to the adapter.
  * @ipr_cmd:	ipr command struct
@@ -7738,7 +7795,7 @@ static int ipr_ioafp_pageC4_inquiry(struct ipr_cmnd *ipr_cmd)
 	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
 	ENTER;
 
-	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	ipr_cmd->job_step = ipr_ioafp_set_caching_parameters;
 	memset(pageC4, 0, sizeof(*pageC4));
 
 	if (ipr_inquiry_page_supported(page0, 0xC4)) {
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index f0238cc..aab5c6d 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -216,6 +216,10 @@
 #define IPR_SET_ALL_SUPPORTED_DEVICES			0x80
 #define IPR_IOA_SHUTDOWN				0xF7
 #define	IPR_WR_BUF_DOWNLOAD_AND_SAVE			0x05
+#define IPR_IOA_SERVICE_ACTION				0xD2
+
+/* IOA Service Actions */
+#define IPR_IOA_SA_CHANGE_CACHE_PARAMS			0x14
 
 /*
  * Timeouts
-- 
2.1.0

