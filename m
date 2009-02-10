From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/5 2.6.29-rc] cxgb3i -- added per-task data to track transmit progress
Date: Mon, 9 Feb 2009 18:10:11 -0800
Message-ID: <200902100210.n1A2ABVa019807@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:8528 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZBJCI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2009 21:08:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 1/5 2.6.29-rc] cxgb3i -- added per-task data to track transmit progress

From: Karen Xie <kxie@chelsio.com>

added per-task struct cxgb3i_task_data to track the data transmiting progress and the state of the pdus to be transmitted.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i.h       |   28 ++++++++++++++++++++++++++++
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    5 +++--
 2 files changed, 31 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index fde6e4c..ba45c1d 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/scatterlist.h>
+#include <linux/skbuff.h>
 #include <scsi/libiscsi_tcp.h>
 
 /* from cxgb3 LLD */
@@ -113,6 +114,33 @@ struct cxgb3i_endpoint {
 	struct cxgb3i_conn *cconn;
 };
 
+/**
+ * struct cxgb3i_task_data - private iscsi task data
+ *
+ * @nr_pages:	# tx pages
+ * @nr_frags:	# of coalesced page frags (from scsi sgl)
+ * @frags:	coalesced page frags (from scsi sgl)
+ * @pages:	tx pages
+ * @skb:	tx pdu skb
+ * @offset:	data offset for the next pdu
+ * @count:	max. possible pdu payload
+ * @sgoffset:	offset to the first sg entry for a given offset
+ */
+#define MAX_PDU_FULL_PAGES \
+	((ULP2_MAX_PDU_PAYLOAD + PAGE_SIZE - 1) >> PAGE_SHIFT)
+#define MAX_PDU_FRAGS	((ULP2_MAX_PDU_PAYLOAD + 512 - 1) / 512)
+
+struct cxgb3i_task_data {
+	unsigned short nr_pages;
+	unsigned short nr_frags;
+	skb_frag_t frags[MAX_PDU_FRAGS];
+	struct page *pages[MAX_PDU_FULL_PAGES];
+	struct sk_buff *skb;
+	unsigned int offset;
+	unsigned int count;
+	unsigned int sgoffset;
+};
+
 int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index d83464b..f0434b7 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -364,7 +364,8 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 
 	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
 					  cmds_max,
-					  sizeof(struct iscsi_tcp_task),
+					  sizeof(struct iscsi_tcp_task) +
+					  sizeof(struct cxgb3i_task_data),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
@@ -844,7 +845,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.proc_name		= "cxgb3i",
 	.queuecommand		= iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= 128 * (ISCSI_DEF_XMIT_CMDS_MAX - 1),
+	.can_queue		= CXGB3I_SCSI_QDEPTH_DFLT - 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
