From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix incorrect trace indexing
Date: Mon, 22 Jun 2015 17:33:50 -0500
Message-ID: <201506222233.t5MMXpZR011546@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:48916 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbFVWd4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 18:33:56 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 22 Jun 2015 16:33:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org


James,

One more ipr patch to go on top of my previous series I sent. This one fixes
a pretty nasty bug that can cause us to go writing in memory that is not ours.

8<

When ipr's internal driver trace was changed to an atomic, a signed/unsigned
bug slipped in which results in us indexing backwards in our memory buffer
writing on memory that does not below to us. This patch fixes this by removing
the modulo and instead just mask off the low bits.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    5 +++--
 drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_trace_index_fix drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_trace_index_fix	2015-06-22 16:52:15.649018937 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-06-22 16:52:31.895895037 -0500
@@ -1487,6 +1487,7 @@ struct ipr_ioa_cfg {
 
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
+#define IPR_TRACE_INDEX_MASK		(IPR_NUM_TRACE_ENTRIES - 1)
 #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
 	char trace_start[8];
 #define IPR_TRACE_START_LABEL			"trace"
diff -puN drivers/scsi/ipr.c~ipr_trace_index_fix drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_trace_index_fix	2015-06-22 16:52:17.800002537 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-22 16:53:17.327548285 -0500
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
