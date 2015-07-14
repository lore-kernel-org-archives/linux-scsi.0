From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] [RESEND] ipr: Fix incorrect trace indexing
Date: Tue, 14 Jul 2015 11:41:31 -0500
Message-ID: <201507141641.t6EGfWxP005714@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:40117 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbGNQlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 12:41:36 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 14 Jul 2015 10:41:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com


When ipr's internal driver trace was changed to an atomic, a signed/unsigned
bug slipped in which results in us indexing backwards in our memory buffer
writing on memory that does not belong to us. This patch fixes this by removing
the modulo and instead just mask off the low bits.

Cc: <stable@vger.kernel.org>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com> 
Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    5 +++--
 drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_trace_index_fix drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_trace_index_fix	2015-07-14 11:12:29.898655454 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-07-14 11:12:29.908655404 -0500
@@ -1486,6 +1486,7 @@ struct ipr_ioa_cfg {
 
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
+#define IPR_TRACE_INDEX_MASK		(IPR_NUM_TRACE_ENTRIES - 1)
 #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
 	char trace_start[8];
 #define IPR_TRACE_START_LABEL			"trace"
diff -puN drivers/scsi/ipr.c~ipr_trace_index_fix drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_trace_index_fix	2015-07-14 11:12:29.903655429 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-07-14 11:21:31.112799218 -0500
@@ -599,9 +599,10 @@ static void ipr_trc_hook(struct ipr_cmnd
 {
 	struct ipr_trace_entry *trace_entry;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	unsigned int trace_index;
 
-	trace_entry = &ioa_cfg->trace[atomic_add_return
-			(1, &ioa_cfg->trace_index)%IPR_NUM_TRACE_ENTRIES];
+	trace_index = atomic_add_return(1, &ioa_cfg->trace_index) & IPR_TRACE_INDEX_MASK;
+	trace_entry = &ioa_cfg->trace[trace_index];
 	trace_entry->time = jiffies;
 	trace_entry->op_code = ipr_cmd->ioarcb.cmd_pkt.cdb[0];
 	trace_entry->type = type;
_

