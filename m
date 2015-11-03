From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 3/5] ipr: Inquiry IOA page 0xC4 during initialization.
Date: Tue,  3 Nov 2015 16:26:08 -0200
Message-ID: <1446575170-18656-3-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:38079 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbKCS0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 13:26:32 -0500
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 16:26:28 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 6625F1DC006F
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 13:25:21 -0500 (EST)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA3IQtrP3301618
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:26:55 -0200
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA3IQOL1021399
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:26:24 -0200
In-Reply-To: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Add an IOA Inquiry command for Page 0xC4 during IOA initialization to
collect cache capabilities, particularly to check if Sync IOA Write
Cache is supported.

Inquiry will happen right after Cap Inquiry on page 0xD0; and will
execute only if the "Supported Pages" field in Inquiry Page 0x0 shows
support for Page 0xC4.  Otherwise, assume Sync IOA Write Cache is
not supported.

Changes since v1:
        - Fix checkpatch.pl warnings.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 35 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/ipr.h | 11 +++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 6849b7f..5efc7ef 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7726,6 +7726,39 @@ static int ipr_inquiry_page_supported(struct ipr_inquiry_page0 *page0, u8 page)
 }
 
 /**
+ * ipr_ioafp_pageC4_inquiry - Send a Page 0xC4 Inquiry to the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function sends a Page 0xC4 inquiry to the adapter
+ * to retrieve software VPD information.
+ *
+ * Return value:
+ *	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_ioafp_pageC4_inquiry(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
+	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
+
+	ENTER;
+	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	memset(pageC4, 0, sizeof(*pageC4));
+
+	if (ipr_inquiry_page_supported(page0, 0xC4)) {
+		ipr_ioafp_inquiry(ipr_cmd, 1, 0xC4,
+				  (ioa_cfg->vpd_cbs_dma
+				   + offsetof(struct ipr_misc_cbs,
+					      pageC4_data)),
+				  sizeof(struct ipr_inquiry_pageC4));
+		return IPR_RC_JOB_RETURN;
+	}
+
+	LEAVE;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
  * ipr_ioafp_cap_inquiry - Send a Page 0xD0 Inquiry to the adapter.
  * @ipr_cmd:	ipr command struct
  *
@@ -7742,7 +7775,7 @@ static int ipr_ioafp_cap_inquiry(struct ipr_cmnd *ipr_cmd)
 	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
 
 	ENTER;
-	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	ipr_cmd->job_step = ipr_ioafp_pageC4_inquiry;
 	memset(cap, 0, sizeof(*cap));
 
 	if (ipr_inquiry_page_supported(page0, 0xD0)) {
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 69257c4..7be1271 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -849,6 +849,16 @@ struct ipr_inquiry_page0 {
 	u8 page[IPR_INQUIRY_PAGE0_ENTRIES];
 }__attribute__((packed));
 
+struct ipr_inquiry_pageC4 {
+	u8 peri_qual_dev_type;
+	u8 page_code;
+	u8 reserved1;
+	u8 len;
+	u8 cache_cap[4];
+#define IPR_CAP_SYNC_CACHE		0x08
+	u8 reserved2[20];
+} __packed;
+
 struct ipr_hostrcb_device_data_entry {
 	struct ipr_vpd vpd;
 	struct ipr_res_addr dev_res_addr;
@@ -1322,6 +1332,7 @@ struct ipr_misc_cbs {
 	struct ipr_inquiry_page0 page0_data;
 	struct ipr_inquiry_page3 page3_data;
 	struct ipr_inquiry_cap cap;
+	struct ipr_inquiry_pageC4 pageC4_data;
 	struct ipr_mode_pages mode_pages;
 	struct ipr_supported_device supp_dev;
 };
-- 
2.1.0

