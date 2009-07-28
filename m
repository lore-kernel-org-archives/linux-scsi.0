From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ipr: Buffer overflow
Date: Tue, 28 Jul 2009 15:25:57 +0200
Message-ID: <4A6EFC65.2060905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52122 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZG1NXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 09:23:10 -0400
Received: by ewy26 with SMTP id 26so8217ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 06:23:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

ioa_cfg->ipr_cmd_label is 8 bytes, IPR_CMD_LABEL is the string "ipr_cmnd",
ie 9 bytes including terminating null.

This patch also corrects the sizes of the other strings.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with Parfait, http://research.sun.com/projects/parfait/

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 4b63dd6..44cb128 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1081,7 +1081,7 @@ enum ipr_cache_state {
 
 /* Per-controller data */
 struct ipr_ioa_cfg {
-	char eye_catcher[8];
+	char eye_catcher[7];
 #define IPR_EYECATCHER			"iprcfg"
 
 	struct list_head queue;
@@ -1111,7 +1111,7 @@ struct ipr_ioa_cfg {
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
 #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
-	char trace_start[8];
+	char trace_start[6];
 #define IPR_TRACE_START_LABEL			"trace"
 	struct ipr_trace_entry *trace;
 	u32 trace_index:IPR_NUM_TRACE_INDEX_BITS;
@@ -1119,18 +1119,18 @@ struct ipr_ioa_cfg {
 	/*
 	 * Queue for free command blocks
 	 */
-	char ipr_free_label[8];
+	char ipr_free_label[7];
 #define IPR_FREEQ_LABEL			"free-q"
 	struct list_head free_q;
 
 	/*
 	 * Queue for command blocks outstanding to the adapter
 	 */
-	char ipr_pending_label[8];
+	char ipr_pending_label[7];
 #define IPR_PENDQ_LABEL			"pend-q"
 	struct list_head pending_q;
 
-	char cfg_table_start[8];
+	char cfg_table_start[4];
 #define IPR_CFG_TBL_START		"cfg"
 	struct ipr_config_table *cfg_table;
 	dma_addr_t cfg_table_dma;
@@ -1141,7 +1141,7 @@ struct ipr_ioa_cfg {
 	struct list_head free_res_q;
 	struct list_head used_res_q;
 
-	char ipr_hcam_label[8];
+	char ipr_hcam_label[6];
 #define IPR_HCAM_LABEL			"hcams"
 	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
 	dma_addr_t hostrcb_dma[IPR_NUM_HCAMS];
@@ -1198,7 +1198,7 @@ struct ipr_ioa_cfg {
 	int (*reset) (struct ipr_cmnd *);
 
 	struct ata_host ata_host;
-	char ipr_cmd_label[8];
+	char ipr_cmd_label[9];
 #define IPR_CMD_LABEL		"ipr_cmnd"
 	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
 	u32 ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
